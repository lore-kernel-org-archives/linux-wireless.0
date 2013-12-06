Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:39817 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab3LFLLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:11:54 -0500
Message-ID: <52A1B0B4.9060703@huawei.com> (sfid-20131206_121159_345395_5BBAB54C)
Date: Fri, 6 Dec 2013 19:10:44 +0800
From: Wang Weidong <wangweidong1@huawei.com>
MIME-Version: 1.0
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: fix build warning of used uninitialized variable
References: <52A15777.5000508@huawei.com>
In-Reply-To: <52A15777.5000508@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013/12/6 12:49, Wang Weidong wrote:
> nl80211.c: In function __cfg80211_wdev_from_attrs
> nl80211.c:77: warning: wdev_id may be used uninitialized in this function
> 

Sorry. My complier version is too low so that I got this warning.
Just ignore it.

Regards.
Wang

> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>  net/wireless/nl80211.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 138dc3b..6894229 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -74,7 +74,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
>  	struct wireless_dev *result = NULL;
>  	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
>  	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
> -	u64 wdev_id;
> +	u64 wdev_id = 0;
>  	int wiphy_idx = -1;
>  	int ifidx = -1;
>  
> 


