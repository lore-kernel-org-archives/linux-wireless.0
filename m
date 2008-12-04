Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32516 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbYLDWXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 17:23:24 -0500
Subject: Re: [RFC] mac80211: remove WARN_ON() from ieee80211_hw_config
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1228427824.5692.52.camel@johannes.berg>
References: <> <1228425905-15666-1-git-send-email-reinette.chatre@intel.com>
	 <1228427824.5692.52.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 14:24:22 -0800
Message-Id: <1228429462.28477.77.camel@rc-desk> (sfid-20081204_232328_303610_8EC84DC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-04 at 13:57 -0800, Johannes Berg wrote:
> On Thu, 2008-12-04 at 13:25 -0800, Reinette Chatre wrote:
> > ieee80211_hw_config can return an error when the hardware
> > has rfkill enabled. A WARN_ON() is too harsh for this
> > failure as it is a valid scenario. Only comment this warning
> > as we would like to have it back when rfkill is integrated into
> > mac80211.
> > 
> > Also reintroduce number of printks that will happen in this case.
> > 
> > This patch essentially reverts patch:
> > 5f0387fc3337ca26f0745f945f550f0c3734960f
> > "mac80211: clean up ieee80211_hw_config errors"
> > 
> > Things not reverted is the reintroduction of a comment
> > and debug statement.
> > 
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> > There are several places where ieee80211_hw_config's return code is not
> > checked. I did not change those as it appears to be intended considering
> > that the patch being reverted had nothing to do with them not using the
> > return code.
> > 
> > It may also be that in this patch only the second hunk be necessary. Please
> > provide feedback in this regard.
> 
> I suppose the probability of the beacon interval changing is rather low,
> but should we propagate the error in that case rather than just using
> -EINVAL?

I do not understand. By returning -EINVAL the error is propagated up to
nl80211 from where the call came.

> 
> The scanning hunks I don't really care about, though it does seem a
> little pointless to print something when changing channel fails, that
> must be one of the most obvious failure modes and also rather unlikely.
> Also, that might actually trigger with iwlwifi too in which case every
> scan would log it, and there can be lots of scans with NM over time.

I will remove these hunks.

Thank you

Reinette

