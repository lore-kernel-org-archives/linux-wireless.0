Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40110 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FWJ0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 05:26:09 -0400
Received: by fxm10 with SMTP id 10so2924231fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 02:26:07 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: "Juuso Oikarinen" <juuso.oikarinen@nokia.com>
Subject: Re: [PATCH 2/2] nl80211: Add option to adjust transmit power
References: <1277284358-11014-1-git-send-email-juuso.oikarinen@nokia.com>
 <1277284358-11014-2-git-send-email-juuso.oikarinen@nokia.com>
Date: Wed, 23 Jun 2010 12:26:00 +0300
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
From: "Artem Mygaiev" <joculator@gmail.com>
Message-ID: <op.veqxtlvunp38ce@conquistador-pc.synapse.com>
In-Reply-To: <1277284358-11014-2-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Juuso

A very minor comment - why do you need 'idx' here? Can't you just directly
access array by NL80211_* index without adding an index variable?

> +	if (info->attrs[NL80211_ATTR_WIPHY_TX_POWER_SETTING]) {
> +		enum nl80211_tx_power_setting type;
> +		int idx, mbm = 0;
> +
> +		if (!rdev->ops->set_tx_power) {
> +			return -EOPNOTSUPP;
> +			goto bad_res;
> +		}
> +
> +		idx = NL80211_ATTR_WIPHY_TX_POWER_SETTING;
> +		type = nla_get_u32(info->attrs[idx]);
> +
> +		if (!info->attrs[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] &&
> +		    (type != NL80211_TX_POWER_AUTOMATIC)) {
> +			result = -EINVAL;
> +			goto bad_res;
> +		}
> +
> +		if (type != NL80211_TX_POWER_AUTOMATIC) {
> +			idx = NL80211_ATTR_WIPHY_TX_POWER_LEVEL;
> +			mbm = nla_get_u32(info->attrs[idx]);
> +		}
> +
> +		result = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
> +		if (result)
> +			goto bad_res;
> +	}

-- 
Best regards,
Artem
