Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47554 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751399AbcJZFaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 01:30:07 -0400
Message-ID: <1477459800.4059.1.camel@sipsolutions.net> (sfid-20161026_073010_485942_925002B9)
Subject: Re: [PATCH 2/8] mac80211: Allow AUTH_DATA to be used for FILS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 07:30:00 +0200
In-Reply-To: <1477435357-8495-3-git-send-email-jouni@qca.qualcomm.com>
References: <1477435357-8495-1-git-send-email-jouni@qca.qualcomm.com>
         <1477435357-8495-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  	if (req->auth_data_len >= 4) {
> -		__le16 *pos = (__le16 *) req->auth_data;
> -		auth_data->sae_trans = le16_to_cpu(pos[0]);
> -		auth_data->sae_status = le16_to_cpu(pos[1]);
> +		if (req->auth_type == NL80211_AUTHTYPE_SAE) {
> +			__le16 *pos = (__le16 *) req->auth_data;
> +			auth_data->sae_trans = le16_to_cpu(pos[0]);
> +			auth_data->sae_status = le16_to_cpu(pos[1]);
> +		}
>  		memcpy(auth_data->data, req->auth_data + 4,
>  		       req->auth_data_len - 4);
>  		auth_data->data_len += req->auth_data_len - 4;

Hmm. Do we really want to still skip the first four bytes of the data
userspace passed? That seems a bit strange to me. The docs in nl80211.h
do say it that way now, but should we really include a dummy
Authentication transaction sequence number field?

johannes
