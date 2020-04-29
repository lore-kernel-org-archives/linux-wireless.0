Return-Path: <SRS0=wwyj=6N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3828BC83000
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 14:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2025521D93
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 14:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgD2O2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2O2f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Apr 2020 10:28:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8663C03C1AD
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2020 07:28:34 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTnhR-001wya-5u; Wed, 29 Apr 2020 16:28:33 +0200
Message-ID: <56500fd2b7c6b54e904567ba27171542027f2aea.camel@sipsolutions.net>
Subject: Re: [PATCH 03/10] nl80211: add HE 6 GHz Band Capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 29 Apr 2020 16:28:31 +0200
In-Reply-To: <1587768108-25248-4-git-send-email-rmanohar@codeaurora.org>
References: <1587768108-25248-1-git-send-email-rmanohar@codeaurora.org>
         <1587768108-25248-4-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-04-24 at 15:41 -0700, Rajkumar Manoharan wrote:
> Define new structures for HE 6 GHz band capabilities as per

per?

>  include/linux/ieee80211.h    | 57 ++++++++++++++++++++++++++++++++++++++++++++
>  include/net/cfg80211.h       |  2 ++
>  include/uapi/linux/nl80211.h |  6 +++++
>  net/wireless/nl80211.c       | 14 +++++++++++

This is a bit mixed up, I'd prefer the raw ieee80211.h definitions in a
separate patch.

> +	[NL80211_ATTR_HE_6GHZ_CAPABILITY] = {
> +		.type = NLA_EXACT_LEN_WARN,
> +		.len = NL80211_HE_6GHZ_CAPABILITY_LEN,
> +	},

Shouldn't use _WARN for a new attribute. Just reject it if userspace
gets it wrong.

> @@ -6177,6 +6185,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
>  			return -EINVAL;
>  	}
>  
> +	/* Ensure that HT/VHT capabilities are not set for 6 GHz HE STA */
> +	if (params.he_6ghz_capa) {
> +		params.ht_capa = NULL;
> +		params.vht_capa = NULL;
> +	}

IMHO better to reject (with a message)

johannes

