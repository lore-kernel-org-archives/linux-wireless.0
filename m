Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27133 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1AMFTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 00:19:53 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 21:19:35 -0800
Date: Thu, 13 Jan 2011 10:48:49 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110113051849.GD8836@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <4D2E0653.7040606@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4D2E0653.7040606@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 13, 2011 at 01:21:47AM +0530, Felix Fietkau wrote:
> On 2011-01-12 10:06 AM, Björn Smedman wrote:
> > On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
> > <rmanoharan@atheros.com>  wrote:
> >>  The commit ""ath9k: Add change_interface callback" was failed
> >>  to update of hw opmode, ani and interrupt mask. This leads
> >>  to break p2p functionality on ath9k. And the existing add and
> >>  remove interface functions are not handling hw opmode and
> >>  ANI properly.
> >>
> >>  This patch combines the common code in interface callbacks
> >>  and also takes care of multi-vif cases.
> >
> > How does your patch handle the race condition between the interface
> > change done in process context and the beacon tasklet triggered by
> > SWBA?
> >
> > Also, perhaps more applicable to the commit log than the patch, how
> > can opmode be properly handled in multi-vif cases? I mean let's say I
> > have two AP vifs and then change one into STA, is the opmode then STA?
> > Compare that to the case where I have two STA vifs and change one into
> > AP; so again I have one AP and one STA vif but this time opmode is AP,
> > right? I can see how I can be wrong about these examples but I can't
> > really see how the opmode concept can be properly handled in multi-vif
> > cases.
> I think opmode should be handled as follows:
> If there is at least one AP interface, opmode should be AP, regardless 
> of what the other interfaces are set to.
> If there is no AP vif, opmode can be set to the primary vif type.
>
Correct. this RFC patch does the same.

--
Rajkumar
