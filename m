Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62476 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1HCQfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 12:35:11 -0400
Received: by pzk37 with SMTP id 37so325448pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 09:35:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110729071742.GB24030@tarshish>
References: <20110728065111.GA6734@sapphire.tkos.co.il> <CAPjQAd_KCc+TtTMeJmhD8WdqooUHWqttdASDpwB0DdrXfXWkRA@mail.gmail.com>
 <20110729071742.GB24030@tarshish>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 3 Aug 2011 09:34:46 -0700
Message-ID: <CAPjQAd8gHCZTcG-Ejd7PyHWEE3aZLWQ_KW007PSZB0R2UAS+0w@mail.gmail.com> (sfid-20110803_184108_943726_B78F797E)
Subject: Re: Mesh HWMP: PREQ node queue full
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 12:17 AM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi Javier,
>
> On Thu, Jul 28, 2011 at 11:47:44AM -0700, Javier Cardona wrote:
>> Thanks for reporting.  Is 02:92:ca:39:48:72 the address of the mesh
>> gate or the address of the external proxied node?
>
> This is the MAC address of the mesh gate (i.e. the other AP).

We'll look into it.

> What is "external proxied node"?

The node outside the mesh you were trying to reach.

Javier

> baruch
>
>> On Wed, Jul 27, 2011 at 11:51 PM, Baruch Siach <baruch@tkos.co.il> wrote:
>> > Hi linux-wireless list,
>> >
>> > I'm testing the mesh capabilities (specifically, MPP) of the latest kernel
>> > (3.0). My driver is ath9k on AR9390 chip. My two APs are configured
>> > identically as follows:
>> >
>> > ----- mesh.sh start
>> > #!/bin/sh
>> >
>> > iw dev wlan1 interface add mesh0 type mp mesh_id wavmesh
>> > ip link set mesh0 addr $(cat /etc/network/mesh0.mac)
>> >
>> > brctl addbr br0
>> > brctl addif br0 eth0
>> > brctl addif br0 mesh0
>> >
>> > ifconfig mesh0 down up
>> > ifconfig eth0 0.0.0.0
>> > ifconfig br0 up
>> > ----- mesh.sh end
>> >
>> > When transferring traffic from a machine behind one eth0 to a machine behind
>> > the other eth0, I see the following on the console (of both APs, only
>> > different MACs):
>> >
>> > Mesh HWMP: sending PREP to 02:92:ca:39:48:72
>> > Mesh HWMP: sending PREQ to 02:92:ca:39:48:72
>> > Mesh HWMP: received PREP from 02:92:ca:39:48:72
>> > Mesh HWMP: received PREQ from 02:92:ca:39:48:72
>> > Mesh HWMP: PREQ is for us
>> > Mesh HWMP: replying to the PREQ
>> > Mesh HWMP: sending PREP to 02:92:ca:39:48:72
>> > mesh_queue_preq: 40 callbacks suppressed
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> > Mesh HWMP: PREQ node queue full
>> >
>> > Any suggestion?
>> >
>> > baruch
>
> --
>                                                     ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
