Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64580 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1ALRXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 12:23:07 -0500
Received: by pva4 with SMTP id 4so109275pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 09:23:07 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <19757.58191.865301.805439@gargle.gargle.HOWL>
Date: Wed, 12 Jan 2011 22:52:23 +0530
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Handle interface changes properly
In-Reply-To: <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
	<AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Björn Smedman wrote:
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
> 
> Also, perhaps more applicable to the commit log than the patch, how
> can opmode be properly handled in multi-vif cases? I mean let's say I
> have two AP vifs and then change one into STA, is the opmode then STA?
> Compare that to the case where I have two STA vifs and change one into
> AP; so again I have one AP and one STA vif but this time opmode is AP,
> right? I can see how I can be wrong about these examples but I can't
> really see how the opmode concept can be properly handled in multi-vif
> cases.

The opmode should be calculated every time an interface is created/destroyed.

If an AP vif is already present when a STA is added, the opmode remains as AP.
if a STA vif is changed into AP mode, then the opmode should be changed to AP,
along with disabling PS for other STA interfaces.
If an AP is present and a STA is added, the beacon interval can't be different.
And there are a few other conditions as well...

And you are right, interface management is not protected with the beacon tasklet...

Sujith
