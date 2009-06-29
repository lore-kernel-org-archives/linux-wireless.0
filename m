Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49206 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZF2JAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 05:00:54 -0400
Received: by fxm18 with SMTP id 18so816329fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2009 02:00:55 -0700 (PDT)
MIME-Version: 1.0
Reply-To: javier.galvez@entel.upc.edu
In-Reply-To: <145d4e1a0906290158y4710d68ej270907f297335d42@mail.gmail.com>
References: <145d4e1a0906290158y4710d68ej270907f297335d42@mail.gmail.com>
Date: Mon, 29 Jun 2009 11:00:54 +0200
Message-ID: <145d4e1a0906290200v4a45d83esf8eab021f6d094f9@mail.gmail.com>
Subject: Using a Debian box as an AP with wireless testing and hostapd
From: =?ISO-8859-1?Q?Javier_G=E1lvez_Guerrero?=
	<javier.galvez@entel.upc.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi all,

I'm trying to use my Debian box as an AP using the latest wireless
testing kernel (2.6.30-wl) and a WiFi card Asus WL-138G v2 PCI but I'm
experiencing a weird problem, hope you can guide me through it.

First, I'll tell what and how I setup it. I downloaded the wireless
testing kernel and installed it (make && make modules && make
modules_install && make install), prepared the boot images and updated
the grub; fine. Next I installed compat-wireless, wireless regdb,
crda, libnl, hostapd and iw following this tutorial
(http://acx100.erley.org/git.html), with slight modifications: install
some missing packages (m2crypto, libgcrypt-dev and libssl-dev) and,
after installing compat-wireless, 'make unload' as suggested by the
'make install' output.

The problem is that, after rebooting, I miss the wlan0 interface
forever (I checked with the b43 driver prior to installing the
wireless testing kernel that I could get the wlan0 attached and
properly working). I always get these messages during boot time and
when trying to modprobe the corresponding modules:

...
[   14.024804] cfg80211: exports duplicate symbol __dev_addr_unsync
(owned by kernel)
[   14.073839] parport_pc 00:09: reported by Plug and Play ACPI
[   14.073940] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   14.203976] mac80211: Unknown symbol cfg80211_ibss_wext_giwessid
[   14.204327] mac80211: Unknown symbol cfg80211_send_assoc_timeout
[   14.204805] mac80211: Unknown symbol cfg80211_ibss_wext_siwessid
[   14.205483] mac80211: Unknown symbol cfg80211_scan_done
[   14.206193] mac80211: Unknown symbol cfg80211_wext_siwfrag
[   14.206498] mac80211: Unknown symbol cfg80211_send_auth_timeout
[   14.206945] mac80211: Unknown symbol cfg80211_wext_giwrts
[   14.207193] mac80211: Unknown symbol regulatory_hint_11d
[   14.207436] mac80211: Unknown symbol cfg80211_send_deauth
[   14.207679] mac80211: Unknown symbol cfg80211_wext_giwscan
[   14.208182] mac80211: Unknown symbol cfg80211_wext_giwname
[   14.208688] mac80211: Unknown symbol cfg80211_wext_siwmlme
[   14.209039] mac80211: Unknown symbol cfg80211_wext_siwencodeext
[   14.209385] mac80211: Unknown symbol cfg80211_wext_giwmode
[   14.209869] mac80211: Unknown symbol cfg80211_wext_giwrange
[   14.210531] mac80211: Unknown symbol cfg80211_classify8021d
[   14.210777] mac80211: Unknown symbol wiphy_register
[   14.211020] mac80211: Unknown symbol wiphy_new
[   14.211266] mac80211: Unknown symbol cfg80211_put_bss
[   14.211545] mac80211: Unknown symbol cfg80211_wext_siwrts
[   14.212538] mac80211: Unknown symbol cfg80211_ibss_joined
[   14.212998] mac80211: Unknown symbol cfg80211_wext_giwfrag
[   14.213381] mac80211: Unknown symbol cfg80211_hold_bss
[   14.213697] mac80211: Unknown symbol cfg80211_ibss_wext_siwfreq
[   14.214056] mac80211: Unknown symbol cfg80211_michael_mic_failure
[   14.214310] mac80211: Unknown symbol cfg80211_send_rx_auth
[   14.214820] mac80211: Unknown symbol cfg80211_ibss_wext_giwap
[   14.215325] mac80211: Unknown symbol wiphy_unregister
[   14.215775] mac80211: Unknown symbol cfg80211_send_disassoc
[   14.216194] mac80211: Unknown symbol ieee80211_radiotap_iterator_init
[   14.216545] mac80211: Unknown symbol cfg80211_get_bss
[   14.216886] mac80211: Unknown symbol __ieee80211_get_channel
[   14.217235] mac80211: Unknown symbol rfc1042_header
[   14.217835] mac80211: Unknown symbol cfg80211_wext_siwmode
[   14.218275] mac80211: Unknown symbol ieee80211_data_to_8023
[   14.218524] mac80211: Unknown symbol cfg80211_send_rx_assoc
[   14.218776] mac80211: Unknown symbol ieee80211_radiotap_iterator_next
[   14.219072] mac80211: Unknown symbol ieee80211_channel_to_frequency
[   14.219322] mac80211: Unknown symbol cfg80211_wext_siwretry
[   14.219571] mac80211: Unknown symbol cfg80211_wext_giwtxpower
[   14.220085] mac80211: Unknown symbol cfg80211_wext_giwretry
[   14.220721] mac80211: Unknown symbol ieee80211_hdrlen
[   14.221059] mac80211: Unknown symbol cfg80211_wext_siwscan
[   14.221409] mac80211: Unknown symbol cfg80211_ibss_wext_siwap
[   14.221747] mac80211: Unknown symbol cfg80211_inform_bss_frame
[   14.222243] mac80211: Unknown symbol ieee80211_frequency_to_channel
[   14.222703] mac80211: Unknown symbol cfg80211_unhold_bss
[   14.222952] mac80211: Unknown symbol bridge_tunnel_header
[   14.223318] mac80211: Unknown symbol cfg80211_ibss_wext_giwfreq
[   14.223767] mac80211: Unknown symbol cfg80211_wext_siwencode
[   14.224039] mac80211: Unknown symbol cfg80211_unlink_bss
[   14.224288] mac80211: Unknown symbol wiphy_free
[   14.224606] mac80211: Unknown symbol cfg80211_wext_giwencode
[   14.224890] mac80211: Unknown symbol cfg80211_wext_siwtxpower
[   14.488924] b43: Unknown symbol ieee80211_get_response_rate
[   14.490682] b43: Unknown symbol ieee80211_free_hw
[   14.491589] b43: Unknown symbol ieee80211_alloc_hw
[   14.492239] b43: Unknown symbol ieee80211_register_hw
[   14.492930] b43: Unknown symbol __ieee80211_get_radio_led_name
[   14.493187] b43: Unknown symbol ieee80211_generic_frame_duration
[   14.493441] b43: Unknown symbol ieee80211_wake_queue
[   14.494261] b43: Unknown symbol __ieee80211_get_tx_led_name
[   14.494514] b43: Unknown symbol ieee80211_tx_status_irqsafe
[   14.494760] b43: Unknown symbol wiphy_rfkill_set_hw_state
[   14.495293] b43: Unknown symbol __ieee80211_get_rx_led_name
[   14.496713] b43: Unknown symbol ieee80211_ctstoself_get
[   14.498008] b43: Unknown symbol ieee80211_stop_queue
[   14.498758] b43: Unknown symbol __ieee80211_get_assoc_led_name
[   14.499044] b43: Unknown symbol wiphy_rfkill_start_polling
[   14.500087] b43: Unknown symbol ieee80211_unregister_hw
[   14.500855] b43: Unknown symbol ieee80211_hdrlen
[   14.501125] b43: Unknown symbol ieee80211_rts_get
[   14.501445] b43: Unknown symbol ieee80211_beacon_get
[   14.502682] b43: Unknown symbol ieee80211_rx_irqsafe
...

And if I try to launch the hostapd process (hostapd -dd
/etc/hostapd.conf) I get this error according to the previous issue:

# hostapd -dd /etc/hostapd.conf
Configuration file: /etc/hostapd.conf
ctrl_interface_group=0
nl80211: 'nl80211' generic netlink not found
nl80211 driver initialization failed.
wlan0: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory


I would like to know what should I've done or where is my mistake.
Some missing headers? Any missing kernel option in .config? I'm quite
interested in getting this environment ready to perform some
networking trials, so I hope you can help me in solving this.


Thans for your time,
Javi
