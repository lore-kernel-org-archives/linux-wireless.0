Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16818C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E559E20656
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfDZJch (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:32:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54278 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfDZJcf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:32:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxDc-0007iI-1U; Fri, 26 Apr 2019 11:32:32 +0200
Message-ID: <dc5568ea0d115f1b6f74a460322f7b1465dd34cb.camel@sipsolutions.net>
Subject: Re: [PATCHv5 2/9] nl80211: Add new netlink attribute for TID
 speicific retry count
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:32:31 +0200
In-Reply-To: <1553592550-15282-3-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
         <1553592550-15282-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-26 at 14:59 +0530, Tamizh chelvam wrote:
> 
> @@ -13288,6 +13291,37 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
>  			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_NOACK]);
>  	}
>  
> +	if (nla_get_flag(attrs[NL80211_ATTR_TID_CONFIG_RETRY])) {
> +		if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +				NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG))
> +			return -ENOTSUPP;
> +
> +		if (peer && !wiphy_ext_feature_isset(&rdev->wiphy,
> +				NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG))
> +			return -ENOTSUPP;
> +
> +		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_RETRY;
> +		if (attrs[NL80211_ATTR_TID_CONFIG_RETRY_SHORT]) {
> +			tid_conf->retry_short =
> +			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RETRY_SHORT]);
> +			if (tid_conf->retry_short >
> +					rdev->wiphy.max_data_retry_count)
> +				return -EINVAL;
> 
Forgot to comment on that before (perhaps also in the first patch), but
having extended error messages for this would be very useful.

johannes

