Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40021 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1G1SsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 14:48:04 -0400
Received: by pzk37 with SMTP id 37so4966261pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 11:48:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110728065111.GA6734@sapphire.tkos.co.il>
References: <20110728065111.GA6734@sapphire.tkos.co.il>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 28 Jul 2011 11:47:44 -0700
Message-ID: <CAPjQAd_KCc+TtTMeJmhD8WdqooUHWqttdASDpwB0DdrXfXWkRA@mail.gmail.com> (sfid-20110728_204809_209461_549141C3)
Subject: Re: Mesh HWMP: PREQ node queue full
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Baruch,

Thanks for reporting.  Is 02:92:ca:39:48:72 the address of the mesh
gate or the address of the external proxied node?

Javier

On Wed, Jul 27, 2011 at 11:51 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> Hi linux-wireless list,
>
> I'm testing the mesh capabilities (specifically, MPP) of the latest kernel
> (3.0). My driver is ath9k on AR9390 chip. My two APs are configured
> identically as follows:
>
> ----- mesh.sh start
> #!/bin/sh
>
> iw dev wlan1 interface add mesh0 type mp mesh_id wavmesh
> ip link set mesh0 addr $(cat /etc/network/mesh0.mac)
>
> brctl addbr br0
> brctl addif br0 eth0
> brctl addif br0 mesh0
>
> ifconfig mesh0 down up
> ifconfig eth0 0.0.0.0
> ifconfig br0 up
> ----- mesh.sh end
>
> When transferring traffic from a machine behind one eth0 to a machine behind
> the other eth0, I see the following on the console (of both APs, only
> different MACs):
>
> Mesh HWMP: sending PREP to 02:92:ca:39:48:72
> Mesh HWMP: sending PREQ to 02:92:ca:39:48:72
> Mesh HWMP: received PREP from 02:92:ca:39:48:72
> Mesh HWMP: received PREQ from 02:92:ca:39:48:72
> Mesh HWMP: PREQ is for us
> Mesh HWMP: replying to the PREQ
> Mesh HWMP: sending PREP to 02:92:ca:39:48:72
> mesh_queue_preq: 40 callbacks suppressed
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
> Mesh HWMP: PREQ node queue full
>
> Any suggestion?
>
> baruch
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
