Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59712 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1KKTDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:03:35 -0500
Received: by gyc15 with SMTP id 15so3197538gyc.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Nov 2011 11:03:34 -0800 (PST)
Message-ID: <4EBD7183.3080008@lwfinger.net> (sfid-20111111_200339_375598_86D6474A)
Date: Fri, 11 Nov 2011 13:03:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix warning in ieee80211_probe_client
References: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2011 12:32 PM, John W. Linville wrote:
>    CC [M]  net/mac80211/cfg.o
> net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
> net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function
>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> ---
>   net/mac80211/cfg.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c2416fb..1d82d2b 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2564,7 +2564,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
>   	struct sk_buff *skb;
>   	int size = sizeof(*nullfunc);
>   	__le16 fc;
> -	bool qos;
> +	bool qos = NULL;
>   	struct ieee80211_tx_info *info;
>   	struct sta_info *sta;

Shouldn't the initialization for a bool be "false"? Doesn't checkpatch.pl 
complain about that? I know it does if you try to initialize a pointer to 0 
rather than NULL.

Larry

