Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27112 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1AMFRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 00:17:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 21:17:22 -0800
Date: Thu, 13 Jan 2011 10:46:30 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
CC: Sujith <m.sujith@gmail.com>,
	Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110113051630.GC8836@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <19757.58191.865301.805439@gargle.gargle.HOWL>
 <AANLkTimK2AkRYnZk70TNt5YWEzNPCoPHpT=pu1B6JZPN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTimK2AkRYnZk70TNt5YWEzNPCoPHpT=pu1B6JZPN@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 13, 2011 at 12:30:03AM +0530, Björn Smedman wrote:
> 2011/1/12 Sujith <m.sujith@gmail.com>:
> > Björn Smedman wrote:
> >> Also, perhaps more applicable to the commit log than the patch, how
> >> can opmode be properly handled in multi-vif cases? I mean let's say I
> >> have two AP vifs and then change one into STA, is the opmode then STA?
> >> Compare that to the case where I have two STA vifs and change one into
> >> AP; so again I have one AP and one STA vif but this time opmode is AP,
> >> right? I can see how I can be wrong about these examples but I can't
> >> really see how the opmode concept can be properly handled in multi-vif
> >> cases.
> >
> > The opmode should be calculated every time an interface is created/destroyed.
> >
> > If an AP vif is already present when a STA is added, the opmode remains as AP.
> > if a STA vif is changed into AP mode, then the opmode should be changed to AP,
> > along with disabling PS for other STA interfaces.
> > If an AP is present and a STA is added, the beacon interval can't be different.
> > And there are a few other conditions as well...
> 
> Thank you Sujith for the clarification. When you lay out the cases it
> makes more sense. But there are still border cases, like e.g. adding
> first a STA and then an AP interface. If I read main.c correctly the
> opmode will then be STA and the AP vif will be broken, right?

Yes. opmode is set to the type of first vif added. Thats wrong. I should
be changed on AP/IBSS type interface addtion.
> Wouldn't it be better to keep counts of number of vifs by type and
> e.g. activate SWBA if (adhocvifs > 0 || apvifs > 0) and similar? Then
> it wouldn't mater in which order vifs are added, removed and changed.
It is not necessary to keep counter for ap/adhoc vifs. instead of that,
I reused nbcnvifs counter.

--
Rajkumar
