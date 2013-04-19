Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.msg.oleane.net ([62.161.4.28]:60781 "EHLO
	smtp28.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601Ab3DSPEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 11:04:50 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp28.msg.oleane.net (MTA) with ESMTP id r3JF4lLp028527
	for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 17:04:47 +0200
Subject: Mutli vif in mesh mode
Date: Fri, 19 Apr 2013 17:04:46 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local> (sfid-20130419_170454_922057_42DDBFCB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I try to setup 2 mesh node on the same wireless card.
I am using the ath9k driver from Compat 2013-02-22 (openwrt package).

The command line sequence is
Create mesh node 1
	iw phy0 interface add wlan0 type mp
	iw wlan0 set channel 44 HT20
	ifconfig wlan0 up
	iw wlan0 mesh join test

Create mesh node 2
iw phy0 interface add wlan1 type mp
iw wlan1 set channel 44 HT20
ifconfig wlan1 hw ether 00:09:90:aa:11:22 up
iw wlan1 mesh join test2

With wireshark and air pcap adapter, I cannot see the beacon for the
second mesh node.
If I  execute each mesh node separately, it works correctly (I see the
beacon on wireshark)

Is it possible to execute 2 mesh node on one ath9k wireless card?

Cedric Voncken 

