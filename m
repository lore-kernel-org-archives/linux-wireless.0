Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34758 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032852Ab2CPPGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:06:19 -0400
Message-ID: <4F6356E8.3050906@openwrt.org> (sfid-20120316_160624_740098_36570DF8)
Date: Fri, 16 Mar 2012 16:06:16 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k:  Support ethtool getstats api.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <1331853606-28434-4-git-send-email-greearb@candelatech.com>
In-Reply-To: <1331853606-28434-4-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-16 12:20 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This returns many of the values that formerly could
> only be obtained from debugfs.  This should be an
> improvement when trying to access these counters
> programatically.  Currently this support is only
> enabled when DEBUGFS is enabled because otherwise
> these stats are not accumulated.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
I don't really like the idea just throwing every random counter into
ethtool. Many of these counters are actually quite misleading, not
properly tracked, or not even updated properly, and thus do not deserve
to be made visible through ethtool.

I think before something gets exported that way, it should be made clear
what it's for and what the limitations are.

- Felix
