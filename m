Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:41146 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbCML5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 07:57:14 -0400
Received: from smtp05.msg.oleane.net (smtp05.mail.priv [172.17.20.114])
	by smtp-out05.msg.oleane.net with ESMTP id t2DBvC3g032172
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2015 12:57:12 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp05.msg.oleane.net (MTA) with ESMTP id t2DBXiDZ016430
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2015 12:33:45 +0100
Subject: ARP dropped during WPA handshake
Date: Fri, 13 Mar 2015 12:36:42 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319019FECAF@sbs2003.acksys.local> (sfid-20150313_125719_609678_A0E41E7C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My test plateforme is very simple, One sta (with openwrt), one AP and a
computer connected to the AP.
I launch iperf on the sta and power up the AP.

With wireshark I can observe 1 s delay between the frame EAPOL 4/4 and
the arp request sent by the sta. I can observe the delay only if my sta
uses architecture with more 1 cpu.

When the sta received the Authentication response, mac80211 sets the
iface on UP state. This state allows wpa_supplicant to send the EAPOL
frame for WPA handshake but other frames are dropped.

If an arp request is sent by the local ip stack during the WPA handshake
this arp will be dropped and we need to wait the end of arp timeout (1
s).

Have you any suggestion / pointer to fix this issue?

Thanks for your help.

Cedric Voncken


