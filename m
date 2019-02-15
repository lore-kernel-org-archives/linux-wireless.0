Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E92FC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A2E21B1A
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394001AbfBOLJx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:09:53 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38236 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389957AbfBOLJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:09:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gubNP-0004y0-KM; Fri, 15 Feb 2019 12:09:51 +0100
Message-ID: <0519f25cf73d8a91202e40b08e94de8d2520411e.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 04/12] mac80211: Compatibility Extended Key ID
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:09:50 +0100
In-Reply-To: <20190210210620.31181-5-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-5-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> +		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
> +		/* Activate Rx crypto offload after max 10s when idle */
> +		ieee80211_queue_delayed_work(&local->hw, &sta->ext_key_compat_wk,
> +					     round_jiffies_relative(HZ * 10));
> +	}

Is there much point in this?

> +		if (unlikely(rx->key->flags & KEY_FLAG_RX_SW_CRYPTO)) {
> +			rx->key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
> +			cancel_delayed_work(&rx->sta->ext_key_compat_wk);
> +			ieee80211_queue_delayed_work(&rx->local->hw,
> +						     &rx->sta->ext_key_compat_wk, 0);
> +		}

We'll almost certainly do it from here, so never exercise the other
path?

johannes

