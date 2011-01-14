Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32698 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab1ANSN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:13:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 10:13:40 -0800
Date: Fri, 14 Jan 2011 23:43:12 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110114181309.GA11920@vmraj-lnx.users.atheros.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <4D2E0653.7040606@openwrt.org>
 <20110113051849.GD8836@vmraj-lnx.users.atheros.com>
 <4D2F0ADF.1040009@openwrt.org>
 <20110113163513.GA9291@vmraj-lnx.users.atheros.com>
 <4D2F2D22.6070301@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4D2F2D22.6070301@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 13, 2011 at 10:19:38PM +0530, Felix Fietkau wrote:
> On 2011-01-13 5:35 PM, Rajkumar Manoharan wrote:
> > On Thu, Jan 13, 2011 at 07:53:27PM +0530, Felix Fietkau wrote:
> >>  On 2011-01-13 6:18 AM, Rajkumar Manoharan wrote:
> >>  >  On Thu, Jan 13, 2011 at 01:21:47AM +0530, Felix Fietkau wrote:
> >>  >>   On 2011-01-12 10:06 AM, Björn Smedman wrote:
> >>  >>   >   On Wed, Jan 12, 2011 at 3:30 PM, Rajkumar Manoharan
> >>  >>   >   <rmanoharan@atheros.com>    wrote:
> >>  >>   >>    The commit ""ath9k: Add change_interface callback" was failed
> >>  >>   >>    to update of hw opmode, ani and interrupt mask. This leads
> >>  >>   >>    to break p2p functionality on ath9k. And the existing add and
> >>  >>   >>    remove interface functions are not handling hw opmode and
> >>  >>   >>    ANI properly.
> >>  >>   >>
> >>  >>   >>    This patch combines the common code in interface callbacks
> >>  >>   >>    and also takes care of multi-vif cases.
> >>  >>   >
> >>  >>   >   How does your patch handle the race condition between the interface
> >>  >>   >   change done in process context and the beacon tasklet triggered by
> >>  >>   >   SWBA?
> >>  >>   >
> >>  >>   >   Also, perhaps more applicable to the commit log than the patch, how
> >>  >>   >   can opmode be properly handled in multi-vif cases? I mean let's say I
> >>  >>   >   have two AP vifs and then change one into STA, is the opmode then STA?
> >>  >>   >   Compare that to the case where I have two STA vifs and change one into
> >>  >>   >   AP; so again I have one AP and one STA vif but this time opmode is AP,
> >>  >>   >   right? I can see how I can be wrong about these examples but I can't
> >>  >>   >   really see how the opmode concept can be properly handled in multi-vif
> >>  >>   >   cases.
> >>  >>   I think opmode should be handled as follows:
> >>  >>   If there is at least one AP interface, opmode should be AP, regardless
> >>  >>   of what the other interfaces are set to.
> >>  >>   If there is no AP vif, opmode can be set to the primary vif type.
> >>  >>
> >>  >  Correct. this RFC patch does the same.
> >>  Really? I don't see that being handled properly, it still seems to
> >>  overwrite ah->opmode based on a single vif type for some types.
> >>  Also, there is no reason to have a WDS opmode in ath9k_hw. WDS is
> >>  typically used along with AP mode interfaces, and where it is not, the
> >>  AP opmode should be used for ath9k_hw anyway.
> > Instead of setting opmde as AP for WDS, it is better to handle WDS
> > case in ath9k_hw.
> Why? Right now I don't even see any NL80211_IFTYPE_WDS handling in 
> ath9k_hw, and I can't think of anything that should be handled 
> differently in ath9k_hw compared to the AP opmode.
For WDS station, what should be the interface type? Forgive if I'm wrong.
> >>  Maybe it would be a good idea to clean this up and first limit the
> >>  number of different types that we pass to ath9k_hw (i.e. only AP, ADHOC,
> >>  STA). Later we can make a separate enum for that to avoid passing the
> >>  type as-is entirely.
> > Just to stick with the currently supported interfaces list, WDS also included.
> >>  I think the mesh point opmode has no place in ath9k_hw. Right now it is
> >>  treated like ad-hoc, but I think that's completely wrong. Mesh should
> >>  behave just like AP mode, as no ad-hoc style TSF synchronization should
> >>  be done by the hardware, and 802.11s mesh nodes do not compete for
> >>  beacon transmission.
> > This is a different issue and it has to be addressed in separate patch.
> I agree.
> 
> - Felix
