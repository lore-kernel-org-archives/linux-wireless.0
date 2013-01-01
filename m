Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50041 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab3AAWQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jan 2013 17:16:47 -0500
Date: Tue, 1 Jan 2013 23:15:44 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/wireless/mlme.c:517
Message-ID: <20130101231544.430cf1fe@ilfaris> (sfid-20130101_231653_354741_2553DAC8)
In-Reply-To: <50E325B5.205@lwfinger.net>
References: <20130101154507.351dfb03@ilfaris>
	<50E325B5.205@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This one indicates that there was a call to disassociate when the
> device was not associated. It might have been informative to have
> seen the logged messages earlier than 436.155474 seconds.
Some of the earlier messages can be found below together with the trace
with hopefully not mest up formatting like in my first mail. Basically
the device tries all the time to connect to the AP and it fails in most
cases to connect, a problem, which sounds very similar to what Borislav
Petkov mentioned in the "dire state of rtl driver in 3.7". By the way,
if you have a suggestion how to investigate connection problems (in my
case: often not possible to connect to the AP, even if the signal is
not very weak and when finally connected and the pings sometimes take
time in the order of 10^2 and the sometimes time in the order of 10^4
or even 10^5) which are there with both the vendor driver and the
native kernel driver, I would appreciate it.

With best regards,
Julian

[  432.490817] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=2)
[  433.213398] wlan0: deauthenticating from xx:xx:xx:xx:xx:xx by local choice (reason=3)
[  433.802119] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  435.792296] wlan0: authenticate with xx:xx:xx:xx:xx:xx
[  435.801209] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[  436.001282] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
[  436.154978] wlan0: authenticated
[  436.155474] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[  436.155492] rtl8192ce 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[  436.155499] rtl8192ce 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[  436.155998] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[  436.158343] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=4)
[  436.158478] wlan0: associated
[  436.158538] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  446.153705] ------------[ cut here ]------------
[  446.153765] WARNING: at net/wireless/mlme.c:517 cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()
[  446.153771] Hardware name: 30515YG
[  446.153775] Modules linked in: deflate zlib_deflate des_generic ecb sha512_generic sha1_generic hmac af_key xfrm_algo acpi_cpufreq mperf loop fuse arc4 btusb bluetooth radeon i2c_algo_bit drm_kms_helper ttm drm rtl8192ce rtlwifi rtl8192c_common crc16 uvcvideo videobuf2_vmalloc videobuf2_memops mac80211 snd_hda_codec_conexant videobuf2_core psmouse videodev cfg80211 i2c_piix4 snd_hda_codec_hdmi agpgart pcspkr evdev ehci_pci k10temp serio_raw i2c_core snd_hda_intel snd_hda_codec thinkpad_acpi nvram rfkill ac snd_hwdep snd_pcm snd_page_alloc snd_timer snd soundcore video processor battery wmi button sha256_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod rtsx_pci_sdmmc mmc_core sd_mod crc_t10dif thermal ohci_hcd ehci_hcd rtsx_pci microcode usbcore thermal_sys usb_common mfd_core ahci libahci libata scsi_mod atl1c
[  446.153946] Pid: 3708, comm: wpa_supplicant Not tainted 3.8.0-rc1+ #2
[  446.153951] Call Trace:
[  446.154007]  [<ffffffff810381e9>] ? warn_slowpath_common+0x79/0xc0
[  446.154033]  [<ffffffffa02af82d>] ? cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]
[  446.154057]  [<ffffffffa029d5ce>] ? nl80211_pre_doit+0x30e/0x400 [cfg80211]
[  446.154079]  [<ffffffffa029b7dd>] ? nl80211_disassociate+0xad/0xf0 [cfg80211]
[  446.154096]  [<ffffffff8135c8e9>] ? genl_rcv_msg+0x249/0x2c0
[  446.154105]  [<ffffffff8135c6a0>] ? genl_rcv+0x30/0x30
[  446.154114]  [<ffffffff8135c321>] ? netlink_rcv_skb+0x91/0xa0
[  446.154122]  [<ffffffff8135c68f>] ? genl_rcv+0x1f/0x30
[  446.154131]  [<ffffffff8135bc2c>] ? netlink_unicast+0x19c/0x220
[  446.154140]  [<ffffffff8135bfb3>] ? netlink_sendmsg+0x303/0x3c0
[  446.154149]  [<ffffffff8131ecdb>] ? sock_sendmsg+0x7b/0xb0
[  446.154160]  [<ffffffff81320534>] ? __sys_sendmsg+0x394/0x3b0
[  446.154169]  [<ffffffff8102bc32>] ? __do_page_fault+0x1b2/0x480
[  446.154179]  [<ffffffff81133bfc>] ? poll_select_copy_remaining+0xfc/0x150
[  446.154188]  [<ffffffff81322564>] ? sys_sendmsg+0x44/0x80
[  446.154199]  [<ffffffff81412752>] ? system_call_fastpath+0x16/0x1b
[  446.154204] ---[ end trace e5f2496b510ae2df ]---
