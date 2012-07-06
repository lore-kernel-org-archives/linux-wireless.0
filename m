Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44808 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2GFEh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 00:37:27 -0400
Received: by yhmm54 with SMTP id m54so9001341yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 21:37:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
References: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
From: Andrew Chant <andrew.chant@gmail.com>
Date: Thu, 5 Jul 2012 21:36:46 -0700
Message-ID: <CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com> (sfid-20120706_063735_542275_72C9855A)
Subject: v3.4.4 ath9k: kernel NULL pointer dereference in skb_dequeue during
 heavy udp xmit
To: Johannes Berg <johannes.berg@intel.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless,
 while performance testing ath9k -> ath9k performance in 3.4.4, I got
a nasty kernel panic.  My performance testing involved filling the air
with 1410-byte UDP packets between the machines, and switching the
frequencies of the two cards to see how frequency affected
performance.  I had switched between channels 36, 40, 44, and 48.
Oops was on the transmitting machine, which was acting as the AP.

Very clear screen image of the oops is at
https://picasaweb.google.com/lh/photo/CjBdHLZH0up5PrnmCySJidMTjNZETYmyPJy0liipFm0?feat=directlink

Rough transcription:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<fffffffff8125103a>] skb_dequeue+0x3a/0x58
PGD 0
Oops: 0002 [#1] SMP
CPU 4
Modules linked in: vfat fat usb_storage loop hid_microsoft usbhid
snd_hda_codec_hdmi snd_hda_codec_via i915 cfbimgblt arc4 cfbcopyarea
cfbfillarea ath9k i2c_algo_bit drm_kms_helper ath9k_common ath9k_hw
snd_hda_intel mac80211 ath snd_hda_codec snd_hwdep snd_pcm snd_timer
xhci_hcd cfg80211 drm ehci_hcd usbcore snd psmouse intel_agp atl1c
usb_common video intel_gtt i2c_core evdev crc32c_intel microcode
snd_page_alloc agpgart

Pid: 0, comm: swapper/4 Not tainted 3.4.4 #37 Gigabyte Technology Co.,
Ltd.  To be filled by O.E.M./Z77-D3H
RIP: 0010:[<ffffffff8125103a>][<ffffffff8125103a>] skm_dequeue+0x3a/0x58
RSP: blah... look at image if you care
RAX: 0000...00012 ... RCX: 0
blah blah blah

Call Trace:
 test_and_clear_sta_flag+0x33/0x33 [mac80211]
 ieee80211_add_pending_skbs_fn+0x81/0xf7 [mac80211]
 ieee80211_sta_ps_deliver_wakeup+0x170/0x18a[mac80211]
 ieee80211_rx_handlers+0x5b3/0x1685 [mac80211]
 get_pageblock_migratetype+0xc/0xd
 ieee80211_prepare_and_rx_handle+0x634/0x6c6 [mac80211]
 ieee80211_rx+0x492/0x5a1 [ath9k]
 ath_rx_tasklet+0x135/0x15a1 [ath9k]
 ath9k_tasklet+0xce/0x10b [ath9k]
...blah blah blah

Code: 32 a8 07 00 48 8b 5d 00 48 39 eb 74 27 48 85 db 74 24 ff 4d 10
48 8b 0b 48 c7 03 00 00 00 00 48 8b ...
