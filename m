Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:54884 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1G1Gvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 02:51:47 -0400
Date: Thu, 28 Jul 2011 09:51:11 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: Mesh HWMP: PREQ node queue full
Message-ID: <20110728065111.GA6734@sapphire.tkos.co.il> (sfid-20110728_085152_730577_23967176)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless list,

I'm testing the mesh capabilities (specifically, MPP) of the latest kernel 
(3.0). My driver is ath9k on AR9390 chip. My two APs are configured 
identically as follows:

----- mesh.sh start
#!/bin/sh

iw dev wlan1 interface add mesh0 type mp mesh_id wavmesh
ip link set mesh0 addr $(cat /etc/network/mesh0.mac)

brctl addbr br0
brctl addif br0 eth0
brctl addif br0 mesh0

ifconfig mesh0 down up
ifconfig eth0 0.0.0.0
ifconfig br0 up
----- mesh.sh end

When transferring traffic from a machine behind one eth0 to a machine behind 
the other eth0, I see the following on the console (of both APs, only 
different MACs):

Mesh HWMP: sending PREP to 02:92:ca:39:48:72
Mesh HWMP: sending PREQ to 02:92:ca:39:48:72
Mesh HWMP: received PREP from 02:92:ca:39:48:72
Mesh HWMP: received PREQ from 02:92:ca:39:48:72
Mesh HWMP: PREQ is for us
Mesh HWMP: replying to the PREQ
Mesh HWMP: sending PREP to 02:92:ca:39:48:72
mesh_queue_preq: 40 callbacks suppressed
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full
Mesh HWMP: PREQ node queue full

Any suggestion?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
