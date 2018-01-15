Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36546 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932200AbeAOMOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:14:34 -0500
Message-ID: <1516018472.410.16.camel@sipsolutions.net> (sfid-20180115_131438_809804_F6C78D64)
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 13:14:32 +0100
In-Reply-To: <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
> 
>  
> +	if (info->attrs[HWSIM_ATTR_PERM_ADDR]) {
> +		if (nla_len(info->attrs[HWSIM_ATTR_PERM_ADDR]) != ETH_ALEN) {
> +			pr_debug("mac80211_hwsim: MAC has wrong size\n");
> +			return -EINVAL;
> +		}

Oh, also - don't do this.

1) don't print, use NL_SET_ERR_MSG().

2) use the policy to validate lengths

> +		if (!is_local_ether_addr(
> +				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
> +			pr_debug("mac80211_hwsim: MAC is not locally administered\n");
> +			return -EINVAL;
> +		}

This doesn't really matter - it's purely virtual. I think we can avoid
that.

> +		if (get_hwsim_data_ref_from_addr(
> +				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
> +			pr_debug("mac80211_hwsim: perm MAC already in use\n");
> +			return -EINVAL;
> +		}

This is racy afaict - remove it and return a clash later when you fail
to insert the new radio.

johannes
