Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:57102 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3AHLbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 06:31:38 -0500
Received: from smtp08.msg.oleane.net (smtp08.mail.priv [172.17.20.117])
	by smtp-out06.msg.oleane.net with ESMTP id r08BVaIm001103
	for <linux-wireless@vger.kernel.org>; Tue, 8 Jan 2013 12:31:36 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp08.msg.oleane.net (MTA) with ESMTP id r08BB52A019558
	for <linux-wireless@vger.kernel.org>; Tue, 8 Jan 2013 12:11:05 +0100
Subject: RE: missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first reassociation in 802.11R
Date: Tue, 8 Jan 2013 12:11:04 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319014B7055@sbs2003.acksys.local> (sfid-20130108_123142_580099_93DD6C6E)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

	I dug a little more on this problem and I found that hardware encryption is disabled after the first roam because ieee80211_key_enable_hw_accel fails on the following test :
		if (sta && !sta->uploaded) 
			goto out_unsupported;

	After the first roam, sta->uploaded is tested before sta_info_move_state sets it to true.

	At the first association/authentication :
	1) sta_info_move_state sets sta->uploaded to true
	2) ieee80211_key_enable_hw_accel test it and find it true --> hardware decoding

	When the station changes from an AP to another :
	1) ieee80211_key_enable_hw_accel test it and find it false --> software decoding
	2) sta_info_move_state sets sta->uploaded to true

	Please find below a log showing the callstack when setting sta->uploaded to true or testing it to be false.

Initial association with 90:a4:de:aa:42:94
==========================================

[   31.476547] wlan0: authenticate with 90:a4:de:aa:42:94
[   31.485307] wlan0: send auth to 90:a4:de:aa:42:94 (try 1/3)
[   31.493419] wlan0: authenticated
[   31.515858] wlan0: associate with 90:a4:de:aa:42:94 (try 1/3)
[   31.531967] wlan0: RX AssocResp from 90:a4:de:aa:42:94 (capab=0x11 status=0 aid=1)
[   31.539870] Set set sta->uploaded to true Call Trace:
[   31.546413] [c783bd00] [c0008178] show_stack+0x4c/0x158 (unreliable)
[   31.552943] [c783bd40] [c9162d00] sta_info_move_state+0x150/0x334 [mac80211]
[   31.560106] [c783bd60] [c918fea8] cleanup_module+0x338/0x26d0 [mac80211]
[   31.566916] [c783be20] [c9181124] ieee80211_sta_rx_notify+0x1e8/0x250 [mac80211]
[   31.574423] [c783bee0] [c9181688] ieee80211_sta_rx_queued_mgmt+0x464/0x548 [mac80211]
[   31.582363] [c783bf10] [c916b964] ieee80211_ibss_leave+0x162c/0x16cc [mac80211]
[   31.589745] [c783bf50] [c00302d4] process_one_work+0x1f0/0x344
[   31.595629] [c783bf80] [c0030da0] worker_thread+0x1b8/0x2d0
[   31.601265] [c783bfb0] [c0034d48] kthread+0x80/0x84
[   31.606206] [c783bff0] [c000d324] kernel_thread+0x4c/0x68
[   31.611877] wlan0: associated
[   35.916785] Test sta->uploaded (successful)
[   35.922490] Test sta->uploaded (successful)

Roaming to 90:a4:de:aa:41:ed
============================

[   85.789911] wlan0: authenticate with 90:a4:de:aa:41:ed
[   85.798547] wlan0: send auth to 90:a4:de:aa:41:ed (try 1/3)
[   85.811848] wlan0: authenticated
[   85.821399] Test sta->uploaded not successful Call Trace:
[   85.828395] [c7247b10] [c0008178] show_stack+0x4c/0x158 (unreliable)
[   85.834901] [c7247b50] [c917ab24] ieee80211_iter_keys+0x1b8/0x2f4 [mac80211]
[   85.842062] [c7247b70] [c917b338] ieee80211_key_link+0x10c/0x150 [mac80211]
[   85.849153] [c7247b90] [c9171084] ieee80211_aes_cmac_key_free+0x2424/0x3780 [mac80211]
[   85.857200] [c7247bb0] [c90df3a8] cfg80211_probe_status+0x2f58/0x69a4 [cfg80211]
[   85.864659] [c7247bf0] [c01e6f40] genl_rcv_msg+0x1d0/0x20c
[   85.870198] [c7247c40] [c01e6384] netlink_rcv_skb+0x64/0xd4
[   85.875850] [c7247c60] [c01e6d5c] genl_rcv+0x28/0x3c
[   85.880873] [c7247c70] [c01e5db0] netlink_unicast+0x160/0x200
[   85.886668] [c7247cb0] [c01e6140] netlink_sendmsg+0x224/0x2a0
[   85.892477] [c7247d00] [c01b530c] sock_sendmsg+0x8c/0xa8
[   85.897845] [c7247dd0] [c01b643c] __sys_sendmsg+0x1fc/0x2c0
[   85.903472] [c7247ef0] [c01b7e00] sys_sendmsg+0x40/0x74
[   85.908781] [c7247f40] [c000e5c4] ret_from_syscall+0x0/0x38
[   85.914460] --- Exception: c01 at 0x48272594
[   85.914472]     LR = 0x48294b64
[   85.927994] wlan0: associate with 90:a4:de:aa:41:ed (try 1/3)
[   85.938062] wlan0: RX AssocResp from 90:a4:de:aa:41:ed (capab=0x11 status=0 aid=1)
[   85.945767] Set set sta->uploaded to true Call Trace:
[   85.952347] [c783bd00] [c0008178] show_stack+0x4c/0x158 (unreliable)
[   85.958851] [c783bd40] [c9162d00] sta_info_move_state+0x150/0x334 [mac80211]
[   85.966034] [c783bd60] [c918fea8] cleanup_module+0x338/0x26d0 [mac80211]
[   85.972852] [c783be20] [c9181124] ieee80211_sta_rx_notify+0x1e8/0x250 [mac80211]
[   85.980360] [c783bee0] [c9181688] ieee80211_sta_rx_queued_mgmt+0x464/0x548 [mac80211]
[   85.988300] [c783bf10] [c916b964] ieee80211_ibss_leave+0x162c/0x16cc [mac80211]
[   85.995678] [c783bf50] [c00302d4] process_one_work+0x1f0/0x344
[   86.001568] [c783bf80] [c0030da0] worker_thread+0x1b8/0x2d0
[   86.007197] [c783bfb0] [c0034d48] kthread+0x80/0x84
[   86.012141] [c783bff0] [c000d324] kernel_thread+0x4c/0x68
[   86.017755] wlan0: associated
[   86.036470] Test sta->uploaded

	At this state I am not sure where the problem is located : kernel or wpa_supplicant 
	Can someone provide me with a hit on how to work it out ?

Wireless driver : ath9k (AR9160)
Compat-Wireless = 2012-09-07 (OpenWRT package) 
WPA_Supplicant  = 20120910 (OpenWRT package) 
Linux Kernel : 3.3.8

Thank in advance,

Cédric DEBARGE

-----Message d'origine-----
De : Cedric Debarge 
Envoyé : mercredi 26 décembre 2012 11:10
À : linux-wireless@vger.kernel.org
Objet : missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first reassociation in 802.11R

Hi all,

	I am not sure if this is the right place to post my question. Please forgive me if not.

	I am experiencing performance issue with 802.11R roaming between two AP with wpa_supplicant ( WPA2 + EAP-TLS).
	When wpa_supplicant leaves the first AP and successfully associates and authenticates with the second one, data frames coming undecrypted from the radio card (RX_FLAG_DECRIPTED flag not set in ieee80211_rx_status) and consumes a lot of CPU time in ieee80211_rx_h_decrypt to decrypt it.

	status->flag at the beginning of ieee80211_rx_h_decrypt :
		0x282 (RX_FLAG_HT | RX_FLAG_MACTIME_MPDU |  RX_FLAG_DECRYPTED) before the first roam
		0x280 (RX_FLAG_HT | RX_FLAG_MACTIME_MPDU) after the first roam
 	
	Is this behavior correct ? if not, can you give me some clue how to work it out ?

	I can provide wpa_supplicant logs if needed.

Wireless driver : ath9k (AR9160)
Compat-Wireless = 2012-09-07 (OpenWRT package) 
WPA_Supplicant  = 20120910 (OpenWRT package) 
Linux Kernel : 3.3.8

	Thank in advance.

Best regards,

Cédric DEBARGE


