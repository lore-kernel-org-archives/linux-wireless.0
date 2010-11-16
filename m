Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0KPXoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:44:24 -0500
Subject: Re: [PATCH 1/2] cfg80211: add support for setting the ad-hoc
 multicast rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4CE3150A.7000300@openwrt.org>
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
	 <1289946423.3673.13.camel@jlt3.sipsolutions.net>
	 <4CE3150A.7000300@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:45:55 -0800
Message-ID: <1289951155.3673.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-17 at 00:34 +0100, Felix Fietkau wrote:
> On 2010-11-16 11:27 PM, Johannes Berg wrote:
> > On Thu, 2010-11-11 at 15:07 +0100, Felix Fietkau wrote:
> > 
> >> +	if (info->attrs[NL80211_ATTR_MCAST_RATE])
> >> +		ibss.mcast_rate =
> >> +			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
> > 
> > That should really check that the rate is supported, and maybe that it's
> > a basic rate.

> But what about band changes then?

Yeah but what about them? You don't handle them anyway -- should maybe
do a per-band setting? Basically right now you end up ignoring the rate
if it's not available.

johannes

