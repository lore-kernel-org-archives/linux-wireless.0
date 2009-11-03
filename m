Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44111 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZKCXix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 18:38:53 -0500
Received: by bwz27 with SMTP id 27so8234291bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 15:38:57 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Nov 2009 18:38:57 -0500
Message-ID: <cb0375e10911031538n62fe7473x4dd41329b9264b5c@mail.gmail.com>
Subject: iwlwifi connection troubles, maybe aggregation related
From: Andrew Lutomirski <luto@mit.edu>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all-

My laptop (Intel 5350) has trouble using the wireless networks here.
I'm at MIT, which has a bunch of Cisco 1250 AP's (dual-band, MIMO,
etc).  Running Windows, everything works perfectly.  On Linux
(2.6.31-rc5, but I've seen problems with other, older kernels as
well), it sometimes works, but I frequently find the network almost
completely unusable.  I can associate and ping just fine, but, as soon
as I try to send any significant amount of data, I can no longer
transmit.  I can still receive both broadcast and unicast frames, but
the network doesn't see anything I send.  An older laptop (presumably
with 4965,

This seems to be correlated with a line like:

iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:21:d8:49:4a:52 tid = 0

appearing in dmesg.

Running "iw dev wlan0 disconnect" will make the connection start
working until I try to send data again (presumably because either NM
or wpa_supplicant will reassociate).

Turning on or off power management and fiddling with
no_sleep_autoadjust makes no difference.  Setting tx_agg_tid_enable to
zero in debugfs while the connection was working seemed to make it a
little more reliable (it lasted long enough to do "git pull" but not
much longer).

After running "iw dev wlan0 disconnect" a few times, I start to get
errors like this:

[18078.209635] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
[18078.313461] iwlagn 0000:03:00.0: No space for Tx
[18078.313467] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
enqueue_hcmd failed: -28
[18078.313470] iwlagn 0000:03:00.0: SENSITIVITY_CMD failed
[18078.522409] iwlagn 0000:03:00.0: No space for Tx
[18078.522414] iwlagn 0000:03:00.0: Error sending SENSITIVITY_CMD:
enqueue_hcmd failed: -28

The driver doesn't recover until I do "echo 1 >
/sys/kernel/debug/ieee80211/phy0/reset"  Oddly enough, after resetting
just now, I couldn't trigger the failure again, even though it was
100% reproducible before resetting.

Thanks,
Andy
