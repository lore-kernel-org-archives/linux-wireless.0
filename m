Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3JBJBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:01:01 -0400
Message-ID: <1380704456.13329.8.camel@jlt4.sipsolutions.net> (sfid-20131002_110105_703788_84938009)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <c_duttus@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Wed, 02 Oct 2013 11:00:56 +0200
In-Reply-To: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com>
References: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-27 at 11:14 +0530, Sunil Dutt wrote:

> +	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
> +		params->supported_channels =
> +		     nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +		params->supported_channels_len =
> +		     nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);

It seems you should validate that the length is even, and at least 2?

> +	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
> +		params->supported_oper_classes =
> +		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +		params->supported_oper_classes_len =
> +		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);

Similarly here (with different rules)

Does this even make sense in set_station() rather than only
new_station()?

johannes

