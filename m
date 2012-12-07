Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56678 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2LGWlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:41:53 -0500
Received: by mail-ie0-f181.google.com with SMTP id 16so2775229iea.12
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:41:53 -0800 (PST)
Date: Fri, 7 Dec 2012 17:33:43 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFCv3 1/5] {nl, cfg, mac}80211: set beacon interval and DTIM
 period on mesh join
Message-ID: <20121207223343.GD535@localhost> (sfid-20121207_234158_425083_ECB402D2)
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
 <1354918443-3076-2-git-send-email-marco@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354918443-3076-2-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 07, 2012 at 02:13:59PM -0800, Marco Porsch wrote:
> +	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
> +			setup.beacon_interval =
> +				nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
> +			if (setup.beacon_interval < 10 || setup.beacon_interval > 10000)
> +				return -EINVAL;
> +	}
> +
> +	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
> +			setup.dtim_period =
> +				nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
> +			if (setup.dtim_period < 1 || setup.dtim_period > 100)
> +				return -EINVAL;
> +	}

Indentation looks kind of messed up there, two tabs instead of one?

-- 
Bob Copeland %% www.bobcopeland.com
