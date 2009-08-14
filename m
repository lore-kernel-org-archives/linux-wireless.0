Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZHND6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 23:58:21 -0400
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
 event
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1250157249.21250.0.camel@johannes.local>
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
	 <1250157249.21250.0.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 11:58:21 +0800
Message-Id: <1250222301.4972.31.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-13 at 17:54 +0800, Johannes Berg wrote:
> On Thu, 2009-08-13 at 17:23 +0800, Zhu Yi wrote:
> > When we receive a successful status in CFG80211_SME_CONNECTED state,
> > it is a roam event. We should mark it as a success result.
> 
> But there's a cfg80211_roamed() call for that? Can the driver not tell
> the difference? It also sends a different event (ROAMED rather than
> CONNECTED) to userspace.

The device notifies both when it begins to roam and after the new
association is made. Yes, I think I missed the cfg80211_roamed call for
the real roam event. But there is still a reassociation path that the
above situation could happen (__cfg80211_connect_result is called while
in CFG80211_SME_CONNECTED state). Or do you think we should suppress
reassoc event from driver?

Actually, the code in __cfg80211_connect_result() has already handled
the (wdev->sme_state == CFG80211_SME_CONNECTED) case. The problem is
wdev->current_bss is set to NULL but leaves wdev->sme_state still as
CFG80211_SME_CONNECTED. So I think the patch is still valid, but needs a
better description.

Thanks,
-yi

