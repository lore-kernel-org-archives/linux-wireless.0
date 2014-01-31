Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaON4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 09:13:56 -0500
Message-ID: <1391177634.4141.24.camel@jlt4.sipsolutions.net> (sfid-20140131_151400_103529_F40773F2)
Subject: Re: [PATCH v3 4/6] cfg80211: Add an option to hint indoor operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Fri, 31 Jan 2014 15:13:54 +0100
In-Reply-To: <1390818118-27261-5-git-send-email-ilan.peer@intel.com> (sfid-20140127_112047_079973_9230A036)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
	 <1390818118-27261-5-git-send-email-ilan.peer@intel.com>
	 (sfid-20140127_112047_079973_9230A036)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 12:21 +0200, Ilan Peer wrote:

>  	switch (user_reg_hint_type) {
>  	case NL80211_USER_REG_HINT_USER:
>  	case NL80211_USER_REG_HINT_CELL_BASE:
> -		break;
> +		if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
> +			return -EINVAL;
> +
> +		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> +		return regulatory_hint_user(data, user_reg_hint_type);
> +	case NL80211_USER_REG_HINT_INDOOR:
> +		return regulatory_hint_indoor_user();
>  	default:
>  		return -EINVAL;
>  	}
>  
> -	r = regulatory_hint_user(data, user_reg_hint_type);
> -
> -	return r;
> +	return 0;

Isn't that "return 0" dead code now?

johannes

