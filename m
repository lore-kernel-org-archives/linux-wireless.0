Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A309C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 11:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4481F2083D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 11:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4481F2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbeKFUzs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 15:55:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40386 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeKFUzs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 15:55:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gJzZW-0001j8-Aw; Tue, 06 Nov 2018 12:31:02 +0100
Message-ID: <12abed50303117c884151fd918cc283ed6d1549f.camel@sipsolutions.net>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Date:   Tue, 06 Nov 2018 12:31:01 +0100
In-Reply-To: <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
         <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +static const struct nla_policy
> +nl80211_attr_tid_policy[NL80211_ATTR_TID_MAX + 1] = {
> +	[NL80211_ATTR_TID] = { .type = NLA_U8 },
> +	[NL80211_ATTR_TID_RETRY_CONFIG] = { .type = NLA_FLAG },
> +	[NL80211_ATTR_TID_RETRY_SHORT] = { .type = NLA_U8 },
> +	[NL80211_ATTR_TID_RETRY_LONG] = { .type = NLA_U8 },
> +};
> +
> +static int nl80211_set_tid_config(struct sk_buff *skb,
> +				  struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct nlattr *attrs[NL80211_ATTR_TID_MAX + 1];
> +	struct nlattr *tid;
> +	struct net_device *dev = info->user_ptr[1];
> +	const char *peer = NULL;
> +	u8 tid_no;
> +	int ret = -EINVAL, retry_short = -1, retry_long = -1;
> +
> +	tid = info->attrs[NL80211_ATTR_TID_CONFIG];
> +	if (!tid)
> +		return -EINVAL;
> +
> +	ret = nla_parse_nested(attrs, NL80211_ATTR_TID_MAX, tid,
> +			       nl80211_attr_tid_policy, info->extack);
> +	if (ret)
> +		return ret;
> +
> +	if (!attrs[NL80211_ATTR_TID])
> +		return -EINVAL;

Why not allow configuring multiple at the same time, and make TID_CONFIG
an array of

 tid => [config attrs, i.e. retry cfg/short/long]

If not, then you should probably use NLA_POLICY_RANGE() for it.

johannes

