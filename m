Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.44.157]:56672 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdKUTbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 14:31:24 -0500
Date: Wed, 22 Nov 2017 06:31:17 +1100
From: James Cameron <quozl@laptop.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [PATCH v2] mwifiex: do not support change AP interface to
 station mode
Message-ID: <20171121193117.GB5400@us.netrek.org> (sfid-20171121_203336_073063_0429617D)
References: <1511265815-13087-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511265815-13087-1-git-send-email-huxm@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 21, 2017 at 08:03:35PM +0800, Xinming Hu wrote:
> Firmware do not support change interface from micro-ap mode to
> station mode, forbidden this operation in driver accordingly.

"forbidden" should be "forbid", for correct tense.

"in driver" is redundant and can be removed.

"accordingly" is also redundant.

Perhaps "Firmware do not support change interface from micro-ap mode
to station mode, forbid this operation."

> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> ---
> v2: remove unnecessary sta/uap combo check(James Cameron)
> 
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 6e0d9a9..4d45df8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -1180,7 +1180,6 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
>  	case NL80211_IFTYPE_AP:
>  		switch (type) {
>  		case NL80211_IFTYPE_ADHOC:

Change interface type from micro-ap to adhoc is supported?

> -		case NL80211_IFTYPE_STATION:
>  			return mwifiex_change_vif_to_sta_adhoc(dev, curr_iftype,
>  							       type, params);
>  			break;
> -- 
> 1.9.1
> 

-- 
James Cameron
http://quozl.netrek.org/
