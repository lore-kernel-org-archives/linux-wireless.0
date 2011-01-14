Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42486 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933167Ab1ANTZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 14:25:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 11:24:42 -0800
Date: Sat, 15 Jan 2011 00:54:14 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>, <greearb@candelatech.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Handle interface changes properly
Message-ID: <20110114192414.GA12090@vmraj-lnx.users.atheros.com>
References: <AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
 <4D2E0653.7040606@openwrt.org>
 <20110113051849.GD8836@vmraj-lnx.users.atheros.com>
 <4D2F0ADF.1040009@openwrt.org>
 <20110113163513.GA9291@vmraj-lnx.users.atheros.com>
 <4D2F2D22.6070301@openwrt.org>
 <20110114181309.GA11920@vmraj-lnx.users.atheros.com>
 <4D30944A.30100@openwrt.org>
 <20110114185317.GA12051@vmraj-lnx.users.atheros.com>
 <4D309EC2.2060409@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D309EC2.2060409@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 15, 2011 at 12:36:42AM +0530, Felix Fietkau wrote:
> On 2011-01-14 7:53 PM, Rajkumar Manoharan wrote:
> > On Fri, Jan 14, 2011 at 11:52:02PM +0530, Felix Fietkau wrote:
> >>  On 2011-01-14 7:13 PM, Rajkumar Manoharan wrote:
> >>  >  On Thu, Jan 13, 2011 at 10:19:38PM +0530, Felix Fietkau wrote:
> >>  >>   On 2011-01-13 5:35 PM, Rajkumar Manoharan wrote:
> >>  >>   >   Instead of setting opmde as AP for WDS, it is better to handle WDS
> >>  >>   >   case in ath9k_hw.
> >>  >>   Why? Right now I don't even see any NL80211_IFTYPE_WDS handling in
> >>  >>   ath9k_hw, and I can't think of anything that should be handled
> >>  >>   differently in ath9k_hw compared to the AP opmode.
> >>  >  For WDS station, what should be the interface type? Forgive if I'm wrong.
> >>  There is no WDS station opmode. 'WDS station' is a regular station
> >>  interface with 4-addr mode enabled. It needs no special handling in ath9k.
> > still not convinced. Then what is the point mac80211 is informing about
> > WDS type to drivers. mac itself can pass it as AP type like what it
> > is doing for p2p GO.
> The WDS type is something else. If you have two APs, you can link them 
> together with a separate WDS vif on each side pointing at the remote MAC 
> address of the other node.
> I think that when we use ah->opmode, we should only use it for very 
> generic operating modes:
> 
> AP: no TSF sync, beacon tx can be enabled.
> ADHOC: TSF sync against IBSS cell, beacon tx can be enabled
> STATION: TSF sync against one AP, only station beacon timers for PS.
> 
> Only the above distinctions are relevant for ath9k_hw, everything else 
> is handled by the driver/stack. There is no reason for adding extra 
> checks to ath9k_hw for mesh and WDS, since they work best with 
> ah->opmode set to AP, and there is nothing extra on the *hardware* side 
> that should be configured there via a different opmode. That's why I 
> think leaking the mac80211 interface types to ath9k_hw is a bad idea.
Thanks for your detailed explanation. And meanwhile Ben is also
fixing hw mode based on vif counter. It would be better if he make
use this thread and address the same.

Ben,
Any comments.

--
Rajkumar
