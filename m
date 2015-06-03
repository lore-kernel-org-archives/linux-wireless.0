Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:37293 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbFCPkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 11:40:51 -0400
Received: from smtp26.msg.oleane.net (smtp26.mail.priv [172.17.20.148])
	by smtp-out06.msg.oleane.net with ESMTP id t53F6736009931
	for <linux-wireless@vger.kernel.org>; Wed, 3 Jun 2015 17:06:07 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp26.msg.oleane.net (MTA) with ESMTP id t53Ek1N3001334
	for <linux-wireless@vger.kernel.org>; Wed, 3 Jun 2015 16:46:01 +0200
Subject: ATH10K and VLAN
Date: Wed, 3 Jun 2015 16:46:01 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A31901A71F95@sbs2003.acksys.local> (sfid-20150603_174057_250004_AFD8D9AA)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I'm testing to send a VLAN frame through ATH10K device.
	I'm using compat wireless 2015-03-09 from openWRT. The ATH10K firmware used is 10.2.4.45

	My test platform is:
		Pc1 : IP 10.101.4.3 (without VLAN)
			VLAN 1 : IP 192.168.5.1

		Equipment in AP mode. The netdev is bridged with eth0

		Equipment in client mode with WDS mode enables. The client is connected to the AP. The netdev is bridged with eth0.
		AP and client use ATH10K wireless card.

		PC2: IP 10.101.4.4 (without VLAN)
			VLAN 1 : IP 192.168.5.2

		The PC1 is connected to the equipment in AP mode and the PC2 is connected to the equipment in client mode.
	

	I can ping from PC1 to PC2 without vlan (ping 10.101.4.4).
	I cannot ping from PC1 to PC2 with VLAN.
	With tcpdump I checked the vlan frame is sent to the netdev but this frame is not send to the air.

	Is it possible to send a VLAN frame through ATH10K? If no, is it a driver limitation or firmware limitation?
		
	Thanks for your help.

Cédric.



