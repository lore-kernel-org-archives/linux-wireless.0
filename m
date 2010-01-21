Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18861 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab0AUQho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 11:37:44 -0500
Subject: Re: [PATCH 1/1] mac80211: tell driver when dtim change detected
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1264091564.11396.58.camel@johannes.local>
References: <1264089090-7014-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264091564.11396.58.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 08:34:13 -0800
Message-Id: <1264091653.7735.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Agree, only iwlwifi use the dtim information now, but not sure it will
be always true. Yes, we should recalculate the internal power save when
it happen, I will make the changes and re-submit

On Thu, 2010-01-21 at 08:32 -0800, Johannes Berg wrote:
> On Thu, 2010-01-21 at 07:51 -0800, wey-yi.w.guy@intel.com wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > In current implementation, mac80211 send dtim_period update to driver during
> > association, but if no NetworkManager or similar application perform scan
> > operation, plus tim_ie is not part of probe response; mac80211 will not get
> > beacon with dtim information later, then  mac80211 will not pass the 
> > information to driver for update.
> 
> Good catch.
> 
> > Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
> > allow driver make correct dtim adjustment if dtim_period change detected.
> 
> I don't think this is the right place or the right thing to do though,
> this seems like an implementation detail from iwlwifi -- it only (and
> maybe only it) uses the DTIM interval for power saving.
> 
> However, the internal power saving stuff from mac80211 should also be
> recalculated if this happens, and then we can probably call it a PS
> change?
> 
> johannes

