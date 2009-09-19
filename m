Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:62711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZISB3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 21:29:49 -0400
Received: by fg-out-1718.google.com with SMTP id 22so661245fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 18:29:52 -0700 (PDT)
Subject: AR9285 not working after resume
From: Christopher <c.krooss@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 19 Sep 2009 03:29:55 +0200
Message-Id: <1253323795.2144.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, I'm using the ath9k-build 2009-09-15 with my Atheros AR9285.
After resuming from suspend-to-RAM, my connections are all disconnected
(as expected), but on reconnect wicd hangs on authenticating.
dmesg shows "ADDRCONF(NETDEV_UP): wlan0: link is not ready" and:


        ------------[ cut here ]------------
        WARNING:
        at /home/build/compat-wireless/compat-wireless-2009-09-15/net/wireless/mlme.c:96 cfg80211_send_rx_assoc+0x199/0x250 [cfg80211]()
        Hardware name: K50IJ               
        Modules linked in: aes_i586 aes_generic i915 drm i2c_algo_bit
        ath9k mac80211 ath cfg80211 rfkill ipv6 fuse fan
        cpufreq_powersave cpufreq_ondemand acpi_cpufreq uvcvideo
        freq_table arc4 ecb videodev usb_storage v4l1_compat
        snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
        snd_seq_device snd_pcm_oss snd_mixer_oss i2c_core
        snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
        snd_timer uhci_hcd snd iTCO_wdt iTCO_vendor_support soundcore
        ehci_hcd snd_page_alloc intel_agp agpgart video psmouse atl1e
        usbcore asus_laptop output sr_mod serio_raw evdev cdrom pcspkr
        battery button processor thermal ac led_class sg rtc_cmos
        rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod ahci libata
        scsi_mod [last unloaded: rfkill]
        Pid: 1525, comm: phy0 Not tainted 2.6.31-ARCH #1
        Call Trace:
         [<c10466fa>] ? warn_slowpath_common+0x7a/0xc0
         [<f8cd5899>] ? cfg80211_send_rx_assoc+0x199/0x250 [cfg80211]
         [<c1046760>] ? warn_slowpath_null+0x20/0x40
         [<f8cd5899>] ? cfg80211_send_rx_assoc+0x199/0x250 [cfg80211]
         [<f8d3459e>] ? ieee80211_sta_work+0x8ee/0x15e0 [mac80211]
         [<c100239d>] ? __switch_to+0xbd/0x1a0
         [<c103bc94>] ? finish_task_switch+0xf4/0x130
         [<c1305309>] ? schedule+0x2d9/0x990
         [<f8d33cb0>] ? ieee80211_sta_work+0x0/0x15e0 [mac80211]
         [<c105d1ef>] ? worker_thread+0x11f/0x280
         [<c1062f90>] ? autoremove_wake_function+0x0/0x60
         [<c105d0d0>] ? worker_thread+0x0/0x280
         [<c1062b3c>] ? kthread+0x8c/0xa0
         [<c1062ab0>] ? kthread+0x0/0xa0
         [<c10048e7>] ? kernel_thread_helper+0x7/0x10
        ---[ end trace dca41fa40e008850 ]---
        ------------[ cut here ]------------

Arch Linux 2.6.31, Asus X5DIJ Laptop, Wifi running great at 150 Mbit/s.
Is this related to the connecting-error? I'd be glad to test anything
you throw at me.

DIDI2002

