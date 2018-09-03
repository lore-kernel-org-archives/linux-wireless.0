Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59126 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeICNtQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 09:49:16 -0400
Message-ID: <1535966988.3437.24.camel@sipsolutions.net> (sfid-20180903_113000_668764_9329E810)
Subject: Re: [PATCH v2 1/3] cfg80211: support FTM responder
 configuration/statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Mon, 03 Sep 2018 11:29:48 +0200
In-Reply-To: <1535745418-31336-2-git-send-email-pradeepc@codeaurora.org>
References: <1535745418-31336-1-git-send-email-pradeepc@codeaurora.org>
         <1535745418-31336-2-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +struct cfg80211_ftm_responder_params {
> +	u8 *lci;
> +	u8 *civic;

These should be const

> +	[NL80211_ATTR_FTM_RESPONDER] = { .type = NLA_FLAG},

missing a space, but didn't we also say it should be NLA_U8 or so
(allowing the values 0/1) in order to allow later updating this to be
changed on the fly to enable/disable while the AP is already operating,
through the "change beacon" command?

> @@ -4378,7 +4406,7 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
>  	if (!wdev->beacon_interval)
>  		return -EINVAL;
>  
> -	err = nl80211_parse_beacon(info->attrs, &params);
> +	err = nl80211_parse_beacon(rdev, info->attrs, &params);

In fact you sort of parse it here, but it would get disabled when the
attribute isn't always included by userspace, which is a bit annoying.

So better make the API to the driver be s8 also, indicating -1 for no
change, and use u8 (0/1) for the userspace API to enable here having "no
changes"?

johannes
