Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73147C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E20720825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E20720825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbeKIVZJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:25:09 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56764 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727596AbeKIVZJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:25:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5DY-0003lR-EL; Fri, 09 Nov 2018 12:44:52 +0100
Message-ID: <ca4bf715537f910af0ee6fa34f6be69b9e24b630.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] cfg80211: Add support to configure station specific
 RSSI threshold for AP mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 12:44:51 +0100
In-Reply-To: <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
         <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry for the delay in reviewing this.

> +	int	(*set_sta_mon_rssi_config)(struct wiphy *wiphy,
> +					  struct net_device *dev,
> +					  const u8 *addr,
> +					  const s32 *rssi_tholds,
> +					  u32 rssi_hyst, int rssi_n_tholds,
> +					  bool fixed_thold);
>  };

I think it might be better to pass all the last 4 arguments (rssi
related ones) as a struct? That's a pattern we typically have elsewhere
too, and it makes things easier to extend and also easier to pass
around.

> + * @NL80211_CMD_SET_STA_MON: This command is used to configure station's
> + *     connection monitoring notification trigger levels.
> + * @NL80211_CMD_NOTIFY_STA_MON: This is used as an event to notify
> + *     the user space that a trigger level was reached for a station.

Please describe the attributes to use with this.


> + * @NL80211_ATTR_STA_MON_FIXED_THOLD: Flag attribute is used with
> + *	%NL80211_CMD_SET_STA_MON to indicate driver that the monitoring
> + *	configuration is fixed limit or a moving range threshold.

This isn't really clear to me, what does it mean?

> +	if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))

Don't really need the parentheses in !(info->...)

> +	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, sta_mon,
> +			       nl80211_attr_cqm_policy, info->extack);

I *think* I made that a proper nested policy, check and then you can
remove passing it here.

> +void
> +cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
> +			     enum nl80211_cqm_rssi_threshold_event rssi_event,
> +			     s32 rssi_level, gfp_t gfp)
> +{
> +	struct sk_buff *msg;
> +
> +	if (WARN_ON(!peer))
> +		return;

Tracing for this might be nice too?

johannes

