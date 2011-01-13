Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27018 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1AMFJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 00:09:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 21:08:57 -0800
Date: Thu, 13 Jan 2011 10:38:28 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110113050828.GA8836@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 12, 2011 at 10:36:28PM +0530, Björn Smedman wrote:
> On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > The commit ""ath9k: Add change_interface callback" was failed
> > to update of hw opmode, ani and interrupt mask. This leads
> > to break p2p functionality on ath9k. And the existing add and
> > remove interface functions are not handling hw opmode and
> > ANI properly.
> >
> > This patch combines the common code in interface callbacks
> > and also takes care of multi-vif cases.
> 
> How does your patch handle the race condition between the interface
> change done in process context and the beacon tasklet triggered by
> SWBA?
If you look at the patch, while removing/changing AP/IBSS interface,
SWBA interrupt was disabled and beacon tasklet is killed before
releasing beacon slot. The SWBA will enabled again in the presence
of beaconing interface.
> 
> Also, perhaps more applicable to the commit log than the patch, how
> can opmode be properly handled in multi-vif cases? I mean let's say I
> have two AP vifs and then change one into STA, is the opmode then STA?
If you have any AP vifs, then opmode will always be AP type. STA mode
will be set only if there is no beaconing interface.
> Compare that to the case where I have two STA vifs and change one into
> AP; so again I have one AP and one STA vif but this time opmode is AP,
> right? I can see how I can be wrong about these examples but I can't
> really see how the opmode concept can be properly handled in multi-vif
> cases.
If you are changing STA->AP, then opmode also changed to AP type though
you have other STA interfaces.

--
Rajkumar
