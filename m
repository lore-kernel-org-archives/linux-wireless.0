Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47281 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbKWEMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 23:12:51 -0500
Date: Sun, 22 Nov 2015 20:12:50 -0800
From: Olav Haugan <ohaugan@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net,
	kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: implement set_coalesce callback
Message-ID: <20151123041250.GA30745@codeaurora.org> (sfid-20151123_051319_271751_A4BC27C8)
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
 <1445712652-19327-2-git-send-email-ohaugan@codeaurora.org>
 <1446199251.3261.22.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446199251.3261.22.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-10-30 11:00:51, Johannes Berg wrote:
> On Sat, 2015-10-24 at 11:50 -0700, Olav Haugan wrote:
> > implement set_coalesce ieee80211_ops callback. Add default
> > wiphy_coalesce_support rules for 9k. These rules are not being used 
> > by 9k since 9k can just toggle coalesce as on/off.
> > 
> This seems extremely strange to me - like you're trying to abuse
> set_coalesce, intended for coalescing certain classes of low-importance
> packets, for a completely different purpose (interrupt coalescing)?
> 
Hmm, yes. We misunderstood how this API is used. Do you have any
suggestion for how to accomplish what we are trying to do? We can't just
add a new public user space API for this functionality.

-- 
.Olav

The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
