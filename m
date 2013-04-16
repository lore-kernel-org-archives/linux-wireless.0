Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:50457 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935660Ab3DPTzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 15:55:46 -0400
Received: from smtp02.msg.oleane.net (smtp02.mail.priv [172.17.20.111])
	by smtp-out05.msg.oleane.net with ESMTP id r3GGl1Fu019859
	for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 18:47:01 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp02.msg.oleane.net (MTA) with ESMTP id r3GGQUa8028129
	for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 18:26:30 +0200
Subject: ath9k null ppointer
Date: Tue, 16 Apr 2013 18:26:29 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A3190152C875@sbs2003.acksys.local> (sfid-20130416_215550_174434_58E8F852)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to use a mesh network with security (meshd/authsae).
I am using :
	- openwrt with the latest mac80211 package from openwrt
(2013-02-22).
	-  the Thomas Pedersen patch to add the authsae package in my
openwrt source tree
(http://permalink.gmane.org/gmane.linux.drivers.mesh.open80211s/2530)
(Use the latest version, because I sent a patch in meshd this morning,
without it the HT mode should not correctly enable)
	- AR9xx wirless card
	- Kernel 3.3.8 on power PC (mpc 8314)

When I configure the meshd daemon to use the HT mode, I have a null
pointer in ath9k (That work correctly without HT mode).

In the file, drivers/net/wireless/ath/ath9k in the function
ath_tx_aggr_wakeup the ac pointer is null.

Do you know why this pointer can be null?

Cedric Voncken 



