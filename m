Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:55862 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2LZKz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 05:55:59 -0500
Received: from smtp07.msg.oleane.net (smtp07.mail.priv [172.17.20.116])
	by smtp-out04.msg.oleane.net with ESMTP id qBQAUgZ4004468
	for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2012 11:30:42 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp07.msg.oleane.net (MTA) with ESMTP id qBQA9vbJ029928
	for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2012 11:09:57 +0100
Subject: missing RX_FLAG_DECRIPTED in ieee80211_rx_status after first reassociation in 802.11R
Date: Wed, 26 Dec 2012 11:09:56 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319014122EF@sbs2003.acksys.local> (sfid-20121226_115604_696053_595367C8)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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


