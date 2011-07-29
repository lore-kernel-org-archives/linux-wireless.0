Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:35779 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab1G2HSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 03:18:08 -0400
Date: Fri, 29 Jul 2011 10:17:43 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mesh HWMP: PREQ node queue full
Message-ID: <20110729071742.GB24030@tarshish> (sfid-20110729_091812_531768_EE8CBB5A)
References: <20110728065111.GA6734@sapphire.tkos.co.il>
 <CAPjQAd_KCc+TtTMeJmhD8WdqooUHWqttdASDpwB0DdrXfXWkRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPjQAd_KCc+TtTMeJmhD8WdqooUHWqttdASDpwB0DdrXfXWkRA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

On Thu, Jul 28, 2011 at 11:47:44AM -0700, Javier Cardona wrote:
> Thanks for reporting.  Is 02:92:ca:39:48:72 the address of the mesh
> gate or the address of the external proxied node?

This is the MAC address of the mesh gate (i.e. the other AP). What is 
"external proxied node"?

baruch

> On Wed, Jul 27, 2011 at 11:51 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> > Hi linux-wireless list,
> >
> > I'm testing the mesh capabilities (specifically, MPP) of the latest kernel
> > (3.0). My driver is ath9k on AR9390 chip. My two APs are configured
> > identically as follows:
> >
> > ----- mesh.sh start
> > #!/bin/sh
> >
> > iw dev wlan1 interface add mesh0 type mp mesh_id wavmesh
> > ip link set mesh0 addr $(cat /etc/network/mesh0.mac)
> >
> > brctl addbr br0
> > brctl addif br0 eth0
> > brctl addif br0 mesh0
> >
> > ifconfig mesh0 down up
> > ifconfig eth0 0.0.0.0
> > ifconfig br0 up
> > ----- mesh.sh end
> >
> > When transferring traffic from a machine behind one eth0 to a machine behind
> > the other eth0, I see the following on the console (of both APs, only
> > different MACs):
> >
> > Mesh HWMP: sending PREP to 02:92:ca:39:48:72
> > Mesh HWMP: sending PREQ to 02:92:ca:39:48:72
> > Mesh HWMP: received PREP from 02:92:ca:39:48:72
> > Mesh HWMP: received PREQ from 02:92:ca:39:48:72
> > Mesh HWMP: PREQ is for us
> > Mesh HWMP: replying to the PREQ
> > Mesh HWMP: sending PREP to 02:92:ca:39:48:72
> > mesh_queue_preq: 40 callbacks suppressed
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> > Mesh HWMP: PREQ node queue full
> >
> > Any suggestion?
> >
> > baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
