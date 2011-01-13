Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27050 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1AMFLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 00:11:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 21:11:19 -0800
Date: Thu, 13 Jan 2011 10:40:46 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110113051046.GB8836@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <19757.58191.865301.805439@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <19757.58191.865301.805439@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 10:52:23PM +0530, Sujith wrote:
> Björn Smedman wrote:
> > On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
> > <rmanoharan@atheros.com> wrote:
> > > The commit ""ath9k: Add change_interface callback" was failed
> > > to update of hw opmode, ani and interrupt mask. This leads
> > > to break p2p functionality on ath9k. And the existing add and
> > > remove interface functions are not handling hw opmode and
> > > ANI properly.
> > >
> > > This patch combines the common code in interface callbacks
> > > and also takes care of multi-vif cases.
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
> 
> The opmode should be calculated every time an interface is created/destroyed.
> 
> If an AP vif is already present when a STA is added, the opmode remains as AP.
> if a STA vif is changed into AP mode, then the opmode should be changed to AP,
> along with disabling PS for other STA interfaces.
> If an AP is present and a STA is added, the beacon interval can't be different.
> And there are a few other conditions as well...
> 
> And you are right, interface management is not protected with the beacon tasklet...
I dont see a race condition here because SWBA & beacon tasklet is disabled
before accessing beacon slot.

--
Rajkumar
