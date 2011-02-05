Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dspam.koyote.com ([204.11.31.20]:2819 "EHLO vopmail.neato.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1BEV5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Feb 2011 16:57:39 -0500
Received: from fl-server.ewol.com (unverified [66.209.47.174]) by vopmail.neato.net
  (Vircom SMTPRS 5.0.916.3) with ESMTP id <B0808884863@vopmail.neato.net> for <linux-wireless@vger.kernel.org>;
  Sat, 5 Feb 2011 15:46:21 -0600
Received: from [192.168.2.6] (nm.ewol.com [192.168.2.6])
	by fl-server.ewol.com (8.14.1/8.14.1) with ESMTP id p15LkIM2009997
	for <linux-wireless@vger.kernel.org>; Sat, 5 Feb 2011 16:46:19 -0500
Subject: 4addr station in a bridge gives 'received own source address'
 errors
From: Steve Brown <sbrown@cortland.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 14:46:17 -0700
Message-ID: <1296942377.27336.29.camel@nm.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an AP and 2 stations. The wifi interfaces on the stations are in
bridges. Pinging from one station to the other generates this error.
This does not occur if the station interfaces are not in a bridge.

The bridge puts the station wifi interface in promiscuous mode. After
instrumenting the bridge code, the following seems to be happening. In
the case of a frame sent from S1->AP->S2, S1 also receives the AP->S2
frame. When that frame is converted to 802.3, S1 is the source address
and the bridge code complains.

I don't understand why the station interface needs to be in promiscuous
mode. The 4addr frames would seem to make this unnecessary.

As a test, I ignored promiscuous mode for stations in the ath9k driver
(a hack) and the messages disappeared. The setup then functions as a
client bridge in that computers hooked to one station can ping computers
connected to the other station.

I think this is a bug.

Steve

