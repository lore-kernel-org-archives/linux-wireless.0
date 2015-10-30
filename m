Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57555 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbbJ3KAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 06:00:54 -0400
Message-ID: <1446199251.3261.22.camel@sipsolutions.net> (sfid-20151030_110107_466107_5C084461)
Subject: Re: [PATCH 2/2] ath9k: implement set_coalesce callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Olav Haugan <ohaugan@codeaurora.org>,
	linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, kvalo@codeaurora.org,
	ath9k-devel@qca.qualcomm.com
Date: Fri, 30 Oct 2015 11:00:51 +0100
In-Reply-To: <1445712652-19327-2-git-send-email-ohaugan@codeaurora.org>
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
	 <1445712652-19327-2-git-send-email-ohaugan@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-10-24 at 11:50 -0700, Olav Haugan wrote:
> implement set_coalesce ieee80211_ops callback. Add default
> wiphy_coalesce_support rules for 9k. These rules are not being used 
> by 9k since 9k can just toggle coalesce as on/off.
> 
This seems extremely strange to me - like you're trying to abuse
set_coalesce, intended for coalescing certain classes of low-importance
packets, for a completely different purpose (interrupt coalescing)?

johannes
