Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:20813 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3JUL0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 07:26:31 -0400
Message-ID: <52650F60.5080402@huawei.com> (sfid-20131021_132659_294651_FC025A6A)
Date: Mon, 21 Oct 2013 19:26:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <netfilter@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/23 v2] cleanup: introduce br/netdev/netif/wiphy_<foo>_ratelimited()
 and use them to simplify code
References: <1382068363-10088-1-git-send-email-wangkefeng.wang@huawei.com> <1382069482.22110.164.camel@joe-AO722>
In-Reply-To: <1382069482.22110.164.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18 12:11, Joe Perches wrote:
> (resending to lists only because of multiple X's in the subject line)
> 
> On Fri, 2013-10-18 at 11:52 +0800, Kefeng Wang wrote:
>> v1-v2:
>>
>>   Introduce macro br/netdev/netif/wiphy_XXX_ratelimited() according
>>   to Joe Perches's advice. The macros are similar to net_XXX_ratelimited()
>>   which is more clarifying than net_ratelimited_function(), then use them
>>   to simplify code.
> 
> There are some conceptual differences between these
> implementations and other <foo>_ratelimited uses.
> 
> For every other subsystem but net, there is a per-location
> struct ratelimit_state.

yes, but I think I just changed net subsystem. Macro DEFINE_RATELIMIT_STATE used
DEFAULT_RATELIMIT_INTERVAL and DEFAULT_RATELIMIT_BURST, so what do you think?
Could anyone give me some advises ?

> Here you've made the global net_ratelimit_state replace all
> of these individual structs so there is some new interaction.
> 
> Dunno if that's good or bad.
> 
> 
> 
> 
> 


