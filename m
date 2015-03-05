Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41678 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbbCEPwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 10:52:41 -0500
Received: by wiwl15 with SMTP id l15so4086729wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2015 07:52:40 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Marek Lindner <marek@open-mesh.com>
Subject: Re: [RFC] mac80211: lock rate control
Date: Thu, 05 Mar 2015 16:52:36 +0100
Message-ID: <4955461.tuO2xra8Dr@bentobox> (sfid-20150305_165248_134790_BBAFDA49)
In-Reply-To: <1425569832-22373-1-git-send-email-johannes@sipsolutions.net>
References: <1425569832-22373-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 05 March 2015 16:37:12 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Both minstrel (reported by Sven Eckelmann) and the iwlwifi rate
> control aren't properly taking concurrency into account. It's
> likely that the same is true for other rate control algorithms.
> 
> In the case of minstrel this manifests itself in crashes when an
> update and other data access are run concurrently, for example
> when the stations change bandwidth or similar. In iwlwifi, this
> can cause firmware crashes.
> 
> Since fixing all rate control algorithms will be very difficult,
> just provide locking for invocations. This protects the internal
> data structures the algorithms maintain.
> 
> I've manipulated hostapd to test this, by having it change its
> advertised bandwidth roughly ever 150ms. At the same time, I'm
> running a flood ping between the client and the AP, which causes
> this race of update vs. get_rate/status to easily happen on the
> client. With this change, the system survives this test.
> 
> Reported-by: Sven Eckelmann <sven@open-mesh.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks a lot for the patch. This is mostly what I had in mind when asking for 
the correct lock.

I will ask if it is possible to test this patch in an affected network. But I 
am quite sure that this will not be possible before next week. And your test 
already sounds quite nice.

Kind regards,
	Sven
