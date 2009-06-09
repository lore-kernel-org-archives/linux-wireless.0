Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1892 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZFIOrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:47:48 -0400
Subject: Re: [PATCH] mac80211: don't use master netdev name
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244557112.4672.20.camel@johannes.local>
References: <1244557112.4672.20.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 10:47:49 -0400
Message-Id: <1244558869.895.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-09 at 16:18 +0200, Johannes Berg wrote:
> Always use the wiphy name instead.

No objections against the patch.

Maybe we could use wiphy names for the network devices?  That is,
wmaster0 would become phy0 and so on.  Using two names for the same
thing is confusing.  What's better is that we won't have wmaster0
corresponding to phy1 after the driver is reloaded.  We'll have "phy1"
in both namespaces.

I wish we could hide those master devices using some "hidden network
device" attribute, but it's not happening.

-- 
Regards,
Pavel Roskin
