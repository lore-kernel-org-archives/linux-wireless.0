Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:46649 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0HORLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:11:08 -0400
Received: from localhost (mail0.scram.de [78.47.204.202])
	by localhost (Postfix) with ESMTP id 4D91BB0400E
	for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 18:52:45 +0200 (CEST)
Received: from mail.scram.de ([78.47.204.202])
	by localhost (amavis.colab.de [88.198.23.89]) (amavisd-new, port 10024)
	with ESMTP id j5go8d00X16x for <linux-wireless@vger.kernel.org>;
	Sun, 15 Aug 2010 18:52:37 +0200 (CEST)
Received: from [192.168.95.10] (p57A6B8CD.dip.t-dialin.net [87.166.184.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: scram287)
	by mail.scram.de (Postfix) with ESMTPSA id 87117B0400D
	for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 18:52:37 +0200 (CEST)
Message-ID: <4C681B53.9080100@scram.de>
Date: Sun, 15 Aug 2010 18:52:35 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 4addr mode promisc problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in the current implementation of mac80211 4addr mode, bridging a 
wireless interface to a wired one doesn't work as expected due to 
promisc mode forwarding frames sent to a different "AP" to higher 
layers...

Given this setup:

A -wireless link- AP -4addr mode link- B -ethernet- C

If I now ping C from A (all ARP entries are already set up), I get 
exactly one response back.

This is what's happening:

A sends echo request to AP:
Frame Addr1=AP, Addr2=A, Addr3=C
AP adds CAM entry A=wlan0
B adds CAM entry A=wlan0.sta1

AP sends echo request to B
Frame Addr1=B, Addr2=AP, Addr3=C, Addr4=A

B doesn't have CAM entry for C, forwards echo request to eth0.

C replies with echo reply on eth0.
B adds CAM entry C=eth0

B hat CAM entry of A, sends echo reply to wlan0.sta1
Frame Addr1=AP, Addr2=B, Addr3=A, Addr4=C

AP sends echo reply to A
Frame Addr1=A, Addr2=AP, Addr3=C
B updates CAM entry C=wlan0.sta1

Here the problem happens. B receives the frame from AP to A. It 
can't decrypt the frame but it still updates the CAM entry and any 
future packet from A to C won't be forwarded to eth0 anymore.

IMHO, promisc mode on an interface with 4addr mode should only 
affect addr3 processing, but not addr1. The current behaviour looks 
like a bug to me.

Config on B (needs iw patch sent by me two weeks ago):

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet manual
     pre-up iw wlan0 set 4addr on

auto eth0
iface eth0 inet manual

auto br0
iface br0 inet dhcp
     bridge_ports wlan0 eth0
     bridge_fd 0
     bridge_stp off
     wpa-ssid <my ssid>
     wpa-psk  <my password>
     wpa-bridge br0
     wpa-iface  wlan0

Thanks,
Jochen
