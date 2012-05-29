Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:38706 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2E2SNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 14:13:38 -0400
Received: from smtp26.msg.oleane.net (smtp26.mail.priv [172.17.20.148])
	by smtp-out03.msg.oleane.net with ESMTP id q4TFw7MC022305
	for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 17:58:07 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp26.msg.oleane.net (MTA) with ESMTP id q4TFbbS6016948
	for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 17:37:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: Power save state while scanning on-channel vs performance
Date: Tue, 29 May 2012 17:37:35 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319012CA12D@sbs2003.acksys.local> (sfid-20120529_201341_059967_908D9542)
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I am using an OpenWrt eth/wifi 802.11n bridge (with AR9160). In order to
test performance during scan, I configured the wpa_supplicant so that it
is scanning the current channel every second.

I used to use compat-wireless-2011-08-26.
With it, I was able to do an IPERF / UDP at 110 Mbps without loss (from
client to AP).

I recently updated to compat-wireless-2012-04-17;
now IPERF loses frames even when limited to 40 Mbps (from client to AP).
Using the Wireshark sniffer I noticed that each time mac80211 sends a
scan probe, it switches the client to power save mode for as long as 130
ms.

Can someone tell me if the power save mode is related to the data loss,
or is there something I am missing here ?

Thanks, 

Jean-Pierre Tosoni

