Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37820 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2FWRuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 13:50:46 -0400
Received: by ghrr11 with SMTP id r11so2204349ghr.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jun 2012 10:50:45 -0700 (PDT)
Date: Sat, 23 Jun 2012 12:50:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Brcmsmac driver woes, possible regression?
Message-ID: <20120623175040.GE2495@burratino> (sfid-20120623_195051_169427_AA32D022)
References: <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120610224902.GB3419@burratino>
 <20120611063014.GA4579@stt008.linux.site>
 <CAKprTDHYMyDwvxA52Z9zxP75ZUY5=FfCGPTZZg9ZxTxReFj7pQ@mail.gmail.com>
 <20120619180335.GA19354@burratino>
 <CAKprTDGM8TJC51Bqideeg447+qR5YnfihgORUFdJL_hW9YHiTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAKprTDGM8TJC51Bqideeg447+qR5YnfihgORUFdJL_hW9YHiTw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

Camaleón wrote[1]:
> 2012/6/19 Jonathan Nieder <jrnieder@gmail.com>:
>> Camaleón wrote:

>>> Update: I've been running kernel 3.2.2-1 over 4 days (since last
>>> Saturday until today) and still haven't experienced any disconnection.
>>
>> Interesting.  I wonder if the workaround in f96b08a7e6f6 (brcmsmac:
>> fix tx queue flush infinite loop, 2012-01-17) has too short a timeout
>> and is backfiring.
>
> Mmm...
>
>> How about this patch, for 3.2.y kernels?  I suggest the following
>> steps for testing:
>
> (...)
>
> Thanks for the detailed steps.
>
> I've planned to start debugging over the weekend because I have more
> spare time for this but the last (yesterday?) set of updates for
> wheezy have left the system in a very bad shape. Is not only that N-M
> is reconnecting very often (!) but gnome-shell and mail-notification
> are segfaulting as crazy horses.
>
> I'm attaching the syslog.
>
> There is also a "new" segfault coming from "net/wireless/mlme.c" (I
> say "new" because I don't recall this file was involved in the past
> :-?) so given the current state of the system I'm a bit reluctant of
> running more test at least for now. Let's see if an upcoming update
> restores the sanity to the system. I'll keep you informed.

Just realized upstream was not in the cc.  Moving to there.

If I understand correctly, these symptoms are similar to those you
experienced with 3.2.9-1.  So there is no reason to believe
f96b08a7e6f6 is the source of the trouble after all.  The problem must
originate somewhere else.  Right?

Syslog at [1].

Thanks,
Jonathan

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=230;bug=664767

[...]
> Jun 23 12:43:28 stt300 kernel: [    0.000000] Linux version 3.2.0-1-686-pae (Debian 3.2.2-1) (ben@decadent.org.uk) (gcc version 4.6.2 (Debian 4.6.2-12) ) #1 SMP Wed Feb 1 09:39:41 UTC 2012
[...]
> Jun 23 12:44:37 stt300 NetworkManager[1478]: <info> Activation (wlan0/wireless): connection 'WLAN_B5' has security, and secrets exist.  No new secrets needed.
[...]
> Jun 23 12:44:38 stt300 kernel: [   88.476883] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[...]
> Jun 23 12:44:40 stt300 dhclient: bound to 192.168.0.150 -- renewal in 123164 seconds.
[...]
> Jun 23 12:59:05 stt300 wpa_supplicant[1514]: wlan0: WPA: Group rekeying completed with 00:23:f8:9d:ad:11 [GTK=TKIP]
[...]
> Jun 23 13:14:41 stt300 wpa_supplicant[1514]: wlan0: WPA: Key negotiation completed with 00:23:f8:9d:ad:11 [PTK=TKIP GTK=TKIP]
[...]
> Jun 23 13:29:05 stt300 wpa_supplicant[1514]: wlan0: WPA: Group rekeying completed with 00:23:f8:9d:ad:11 [GTK=TKIP]
[...]
> Jun 23 13:41:44 stt300 kernel: [ 3513.868441] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> Jun 23 13:41:44 stt300 kernel: [ 3513.868462] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
> Jun 23 13:41:44 stt300 kernel: [ 3513.868478] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
> Jun 23 13:41:45 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
> Jun 23 13:41:45 stt300 kernel: [ 3514.806036] cfg80211: Calling CRDA to update world regulatory domain
[...]
> Jun 23 13:41:45 stt300 kernel: [ 3514.825799] cfg80211: Calling CRDA for country: ES
> Jun 23 13:41:45 stt300 kernel: [ 3514.840865] cfg80211: Regulatory domain changed to country: ES
[...]
> Jun 23 13:41:46 stt300 NetworkManager[1478]: <info> (wlan0): supplicant interface state: disconnected -> scanning
> Jun 23 13:41:47 stt300 wpa_supplicant[1514]: wlan0: SME: Trying to authenticate with 00:23:f8:9d:ad:11 (SSID='WLAN_B5' freq=2437 MHz)
[...]
> Jun 23 13:41:49 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:47:28 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:47:30 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:49:35 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:49:38 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:50:24 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:50:31 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:51:33 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:51:35 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:54:54 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:54:56 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:58:59 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:59:01 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 13:59:49 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 13:59:52 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 14:01:29 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 14:01:42 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 14:06:57 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 14:07:27 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 14:07:27 stt300 kernel: [ 5057.456105] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 14:07:27 stt300 kernel: [ 5057.458183] ------------[ cut here ]------------
> Jun 23 14:07:27 stt300 kernel: [ 5057.458245] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
> Jun 23 14:07:27 stt300 kernel: [ 5057.458266] Hardware name: Compaq Mini CQ10-500            
> Jun 23 14:07:27 stt300 kernel: [ 5057.458276] Modules linked in: acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative parport_pc ppdev lp parport binfmt_misc uinput fuse loop uvcvideo arc4 videodev media brcmsmac joydev cordic crc8 brcmutil mac80211 hp_wmi cfg80211 snd_hda_codec_idt i915 snd_hda_intel sparse_keymap rfkill snd_hda_codec snd_hwdep snd_pcm rts_pstor(C) drm_kms_helper snd_page_alloc iTCO_wdt r8169 evdev snd_seq snd_seq_device snd_timer drm i2c_algo_bit snd uhci_hcd pcspkr psmouse serio_raw iTCO_vendor_support mii ehci_hcd usbcore i2c_i801 usb_common soundcore i2c_core ac battery wmi power_supply video processor button reiserfs sd_mod crc_t10dif ahci libahci libata scsi_mod thermal thermal_sys
> Jun 23 14:07:27 stt300 kernel: [ 5057.458528] Pid: 4002, comm: kworker/u:0 Tainted: G         C   3.2.0-1-686-pae #1
> Jun 23 14:07:27 stt300 kernel: [ 5057.458541] Call Trace:
> Jun 23 14:07:27 stt300 kernel: [ 5057.458569]  [<c1038328>] ? warn_slowpath_common+0x68/0x79
> Jun 23 14:07:27 stt300 kernel: [ 5057.458617]  [<f862ab97>] ? cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458638]  [<c1038346>] ? warn_slowpath_null+0xd/0x10
> Jun 23 14:07:27 stt300 kernel: [ 5057.458684]  [<f862ab97>] ? cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458737]  [<f87cbee7>] ? ieee80211_probe_auth_done+0x21/0x98 [mac80211]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458791]  [<f87cee5a>] ? ieee80211_work_work+0xda7/0xde4 [mac80211]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458814]  [<c12b8410>] ? __schedule+0x54b/0x55b
> Jun 23 14:07:27 stt300 kernel: [ 5057.458886]  [<f8753f2a>] ? intel_idle_update+0x33/0x18f [i915]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458908]  [<c10499e3>] ? process_one_work+0x112/0x1fa
> Jun 23 14:07:27 stt300 kernel: [ 5057.458959]  [<f87ce0b3>] ? free_work+0xd/0xd [mac80211]
> Jun 23 14:07:27 stt300 kernel: [ 5057.458980]  [<c104a6ee>] ? worker_thread+0xa9/0x122
> Jun 23 14:07:27 stt300 kernel: [ 5057.458999]  [<c104a645>] ? manage_workers.isra.23+0x13d/0x13d
> Jun 23 14:07:27 stt300 kernel: [ 5057.459018]  [<c104d02f>] ? kthread+0x63/0x68
> Jun 23 14:07:27 stt300 kernel: [ 5057.459036]  [<c104cfcc>] ? kthread_worker_fn+0x101/0x101
> Jun 23 14:07:27 stt300 kernel: [ 5057.459056]  [<c12be1be>] ? kernel_thread_helper+0x6/0x10
> Jun 23 14:07:27 stt300 kernel: [ 5057.459069] ---[ end trace da1b8e557d7583b2 ]---
> Jun 23 14:07:27 stt300 NetworkManager[1478]: <info> (wlan0): deactivating device (reason 'supplicant-timeout') [11]
[...]
> Jun 23 14:11:11 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 14:11:32 stt300 NetworkManager[1478]: <info> Activation (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
> Jun 23 14:12:49 stt300 kernel: [ 5379.399774] mail-notificati[2603]: segfault at 4c ip 08060113 sp bfa06b20 error 4 in mail-notification[8048000+5d000]
[...]
> Jun 23 14:22:10 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 14:22:13 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 15:08:28 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 15:08:31 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 15:24:27 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 15:24:30 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 15:27:40 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 15:27:42 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 15:29:51 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 15:30:25 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 15:30:25 stt300 NetworkManager[1478]: <info> (wlan0): device state change: activated -> disconnected (reason 'supplicant-timeout') [100 30 11]
> Jun 23 15:30:25 stt300 kernel: [10034.732100] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 15:30:25 stt300 kernel: [10034.733834] ------------[ cut here ]------------
> Jun 23 15:30:25 stt300 kernel: [10034.733895] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
> Jun 23 15:30:25 stt300 kernel: [10034.733916] Hardware name: Compaq Mini CQ10-500            
> Jun 23 15:30:25 stt300 kernel: [10034.733925] Modules linked in: acpi_cpufreq mperf cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative parport_pc ppdev lp parport binfmt_misc uinput fuse loop uvcvideo arc4 videodev media brcmsmac joydev cordic crc8 brcmutil mac80211 hp_wmi cfg80211 snd_hda_codec_idt i915 snd_hda_intel sparse_keymap rfkill snd_hda_codec snd_hwdep snd_pcm rts_pstor(C) drm_kms_helper snd_page_alloc iTCO_wdt r8169 evdev snd_seq snd_seq_device snd_timer drm i2c_algo_bit snd uhci_hcd pcspkr psmouse serio_raw iTCO_vendor_support mii ehci_hcd usbcore i2c_i801 usb_common soundcore i2c_core ac battery wmi power_supply video processor button reiserfs sd_mod crc_t10dif ahci libahci libata scsi_mod thermal thermal_sys
> Jun 23 15:30:25 stt300 kernel: [10034.734250] Pid: 4638, comm: kworker/u:0 Tainted: G        WC   3.2.0-1-686-pae #1
> Jun 23 15:30:25 stt300 kernel: [10034.734263] Call Trace:
> Jun 23 15:30:25 stt300 kernel: [10034.734294]  [<c1038328>] ? warn_slowpath_common+0x68/0x79
> Jun 23 15:30:25 stt300 kernel: [10034.734341]  [<f862ab97>] ? cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]
> Jun 23 15:30:25 stt300 kernel: [10034.734361]  [<c1038346>] ? warn_slowpath_null+0xd/0x10
> Jun 23 15:30:25 stt300 kernel: [10034.734404]  [<f862ab97>] ? cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]
> Jun 23 15:30:25 stt300 kernel: [10034.734457]  [<f87cbee7>] ? ieee80211_probe_auth_done+0x21/0x98 [mac80211]
> Jun 23 15:30:25 stt300 kernel: [10034.734512]  [<f87cee5a>] ? ieee80211_work_work+0xda7/0xde4 [mac80211]
> Jun 23 15:30:25 stt300 kernel: [10034.734534]  [<c12b8410>] ? __schedule+0x54b/0x55b
> Jun 23 15:30:25 stt300 kernel: [10034.734596]  [<f8747569>] ? i915_gem_retire_requests_ring+0xef/0x122 [i915]
> Jun 23 15:30:25 stt300 kernel: [10034.734660]  [<f8749a87>] ? i915_gem_retire_work_handler+0x41/0xf7 [i915]
> Jun 23 15:30:25 stt300 kernel: [10034.734683]  [<c10499e3>] ? process_one_work+0x112/0x1fa
> Jun 23 15:30:25 stt300 kernel: [10034.734735]  [<f87ce0b3>] ? free_work+0xd/0xd [mac80211]
> Jun 23 15:30:25 stt300 kernel: [10034.734756]  [<c104a6ee>] ? worker_thread+0xa9/0x122
> Jun 23 15:30:25 stt300 kernel: [10034.734775]  [<c104a645>] ? manage_workers.isra.23+0x13d/0x13d
> Jun 23 15:30:25 stt300 kernel: [10034.734793]  [<c104d02f>] ? kthread+0x63/0x68
> Jun 23 15:30:25 stt300 kernel: [10034.734812]  [<c104cfcc>] ? kthread_worker_fn+0x101/0x101
> Jun 23 15:30:25 stt300 kernel: [10034.734832]  [<c12be1be>] ? kernel_thread_helper+0x6/0x10
> Jun 23 15:30:25 stt300 kernel: [10034.734846] ---[ end trace da1b8e557d7583b3 ]---
[...]
> Jun 23 15:32:04 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 15:32:04 stt300 kernel: [10134.528104] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 15:32:04 stt300 kernel: [10134.528213] ------------[ cut here ]------------
> Jun 23 15:32:04 stt300 kernel: [10134.528272] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
[...]
> Jun 23 15:32:21 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 15:32:21 stt300 kernel: [10150.816183] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 15:32:21 stt300 NetworkManager[1478]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
> Jun 23 15:32:21 stt300 kernel: [10150.824142] ------------[ cut here ]------------
> Jun 23 15:32:21 stt300 kernel: [10150.824205] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
[...]
> Jun 23 15:32:33 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (auth) [id=0 id_str=]
[...]
> Jun 23 16:03:57 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:03:59 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:06:45 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:09:55 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 16:09:55 stt300 kernel: [12405.648116] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 16:09:55 stt300 NetworkManager[1478]: <info> (wlan0): supplicant interface state: associating -> disconnected
> Jun 23 16:09:55 stt300 kernel: [12405.664163] ------------[ cut here ]------------
> Jun 23 16:09:55 stt300 kernel: [12405.664225] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:366 cfg80211_send_assoc_timeout+0xbc/0xbe [cfg80211]()
[...]
> Jun 23 16:09:58 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:15:23 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:16:02 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 16:16:02 stt300 kernel: [12771.844163] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 16:16:02 stt300 kernel: [12771.856283] ------------[ cut here ]------------
> Jun 23 16:16:02 stt300 kernel: [12771.856347] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:366 cfg80211_send_assoc_timeout+0xbc/0xbe [cfg80211]()
[...]
> Jun 23 16:18:14 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 16:18:14 stt300 kernel: [12904.608165] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 16:18:14 stt300 kernel: [12904.608270] ------------[ cut here ]------------
> Jun 23 16:18:14 stt300 kernel: [12904.608329] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
[...]
> Jun 23 16:18:17 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:23:18 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:23:20 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:25:43 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:25:54 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Jun 23 16:25:54 stt300 kernel: [13364.012098] wlan0: deauthenticating from 00:23:f8:9d:ad:11 by local choice (reason=3)
> Jun 23 16:25:54 stt300 kernel: [13364.013700] ------------[ cut here ]------------
> Jun 23 16:25:54 stt300 kernel: [13364.013762] WARNING: at /build/buildd-linux-2.6_3.2.2-1-i386-9uGbTI/linux-2.6-3.2.2/debian/build/source_i386_none/net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x5d/0x6a [cfg80211]()
[...]
> Jun 23 16:25:56 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:26:35 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:26:38 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
> Jun 23 16:27:39 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:27:43 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
> Jun 23 16:27:43 stt300 NetworkManager[1478]: <info> (wlan0): supplicant interface state: 4-way handshake -> completed
> Jun 23 16:28:37 stt300 kernel: [13527.683194] gnome-shell[2591]: segfault at 2c ip b76b5c1f sp bf86b3a0 error 4 in libgnome-shell.so[b7677000+9d000]
> Jun 23 16:28:38 stt300 x-session-manager[1886]: WARNING: Application 'gnome-shell.desktop' killed by signal 11
[...]
> Jun 23 16:33:08 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4
[...]
> Jun 23 16:33:10 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-CONNECTED - Connection to 00:23:f8:9d:ad:11 completed (reauth) [id=0 id_str=]
[...]
