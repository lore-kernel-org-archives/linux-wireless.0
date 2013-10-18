Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:41060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802Ab3JREL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 00:11:26 -0400
Message-ID: <1382069482.22110.164.camel@joe-AO722> (sfid-20131018_061145_669214_AD943076)
Subject: Re: [PATCH 00/23 v2] cleanup: introduce
 br/netdev/netif/wiphy_<foo>_ratelimited() and use them to simplify code
From: Joe Perches <joe@perches.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 21:11:22 -0700
In-Reply-To: <1382068363-10088-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1382068363-10088-1-git-send-email-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(resending to lists only because of multiple X's in the subject line)

On Fri, 2013-10-18 at 11:52 +0800, Kefeng Wang wrote:
> v1-v2:
> 
>   Introduce macro br/netdev/netif/wiphy_XXX_ratelimited() according
>   to Joe Perches's advice. The macros are similar to net_XXX_ratelimited()
>   which is more clarifying than net_ratelimited_function(), then use them
>   to simplify code.

There are some conceptual differences between these
implementations and other <foo>_ratelimited uses.

For every other subsystem but net, there is a per-location
struct ratelimit_state.

Here you've made the global net_ratelimit_state replace all
of these individual structs so there is some new interaction.

Dunno if that's good or bad.



