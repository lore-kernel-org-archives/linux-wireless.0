Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:18485 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbYLDWj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 17:39:28 -0500
Subject: Re: [RFC] mac80211: remove WARN_ON() from ieee80211_hw_config
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1228429761.5692.54.camel@johannes.berg>
References: <> <1228425905-15666-1-git-send-email-reinette.chatre@intel.com>
	 <1228427824.5692.52.camel@johannes.berg>
	 <1228429462.28477.77.camel@rc-desk>
	 <1228429761.5692.54.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 14:40:25 -0800
Message-Id: <1228430425.28477.80.camel@rc-desk> (sfid-20081204_233931_641270_DCA1503B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-04 at 14:29 -0800, Johannes Berg wrote:
> On Thu, 2008-12-04 at 14:24 -0800, reinette chatre wrote:
> 
> > > I suppose the probability of the beacon interval changing is rather low,
> > > but should we propagate the error in that case rather than just using
> > > -EINVAL?
> > 
> > I do not understand. By returning -EINVAL the error is propagated up to
> > nl80211 from where the call came.
> 
> Ah, but the error code is lost, the driver might have returned -EBUSY or
> something. I'm not sure we want to pass that up, it might be better not
> to, not sure.

I see. I am not familiar with the upper layers, but giving them insight
into the failure may be useful. I'll change patch to do this.

Thank you very much

Reinette

