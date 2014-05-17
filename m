Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41499 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaEQPnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 11:43:03 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so6068634wgg.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 08:43:01 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
From: Andrea Merello <andrea.merello@gmail.com>
Date: Sat, 17 May 2014 17:42:41 +0200
Message-ID: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com> (sfid-20140517_174307_788362_95E52488)
Subject: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216.. and RX
 path involved in scan
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	oku@masqmail.cx, joerg.albert@gmx.de, alex@foogod.com,
	n0_5p4m_p13453@hotmail.com, proski@gnu.org, agx@sigxcpu.org,
	kalle.valo@iki.fi, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

It happened that since Emmanuel's commit
3afc2167f60a327a2c1e1e2600ef209a3c2b75b7 (cfg80211/mac80211: ignore
signal if the frame was heard on wrong channel) my atmel-based wifi
device couldn't scan anymore.

I looked at this issue and I found the cause, but currently I have
some doubts, and I would like asking for clarification and comments,
before trying to patch the driver or mac80211 itself....

The problem is triggered because the at76x50x-usb driver does not
provide frequency information in rx_status (and AFAIK it difficultly
could do that during scan right now).

Emmanuel's commit make certain mac80211 functions stop getting the
channel information from the beacon/probe response, and start getting
it from rx_status, but the channel results now NULL, and the frame is
discarded.
The relevant check is done in mlme.c, ieee80211_rx_bss_info
if (!channel)
    return;
just after Emmanuel's change.

So my first question is:
Are mac80211 drivers obligated to report this information?
Does this commit just rely on something that should be already in that
way (and the at7950x-usb driver is simply buggy not doing this)?
Reading Emmanuel's commit message it seems he didn't have any
intention to introduce this constraint now.

Said that, I dig in mac80211 code, and I saw Emmanuel commit does
affect frames processed in sta (and ibss, but i didn't look at this)
rx path.

Summarizing it a bit, the call path should be:
 __ieee80211_rx_handle_packet()
ieee80211_invoke_rx_handlers()
ieee80211_rx_h_mgmt()
-- work queue --
ieee80211_iface_work()
ieee80211_sta_rx_queued_mgmt()
ieee80211_rx_bss_info() - patched to get channel from driver's rx_status.
And finally
ieee80211_bss_info_update()

is this right?

What is surprising for me is that
 __ieee80211_rx_handle_packet()
contains a shorter path for updating BSS information by
ieee80211_scan_rx() that directly calls
ieee80211_bss_info_update()

The interesting thing is that ieee80211_scan_rx was already written in
the way Emmanuel's patched ieee80211_rx_bss_info(): It get channel
info from rx_status.

This suggests that the at79c50x-usb driver, prior to Emmanuel's
commit, was able to scan by getting mgmt frames processed by the
former, longer, RX path, and that the ieee80211_scan_rx() path was
never really used.

If this is correct, my question is:
Isn't this a redundant path duplication (provided that drivers
supplies channel information)?

This seems to be confirmed by the fact that if I modify mac80211 to
avoid discarding frame without channel information (by putting a valid
channel information directly in mac80211 just before the check for
NULL), the scan works by either doing this in ieee80211_scan_rx() or
in ieee80211_rx_bss_info() (reverting Emmanuel change in mlme.c).

Finally my latest question is:
Emmanuel's patch makes cfg80211_inform_bss_width_frame() compare the
RX channel and the actual BSS channel (known from beacon/probe
response), and it does this by comparing the two pointers.

Are we guaranteed that only one instance of every channel object does
exists ? isn't it safer to compare the frequency field value?

Thank you
Andrea
