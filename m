Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0306FC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89C520840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:49:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C89C520840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbeKIV3o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:29:44 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56784 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeKIV3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:29:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5Hz-0003qq-Av; Fri, 09 Nov 2018 12:49:27 +0100
Message-ID: <f1c8ce7daf62c60197da9cc62d550fdc1cac6303.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Implement API to configure station
 specific rssi threshold
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 12:49:26 +0100
In-Reply-To: <1539626250-769-3-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
         <1539626250-769-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-15 at 23:27 +0530, Tamizh chelvam wrote:
> 
> +		sta_mon_rssi_config_free(sta);
> +		sta->rssi_hyst = rssi_hyst;
> +		if (fixed_thold) {
> +			if (n_rssi_tholds > 2) {
> +				ret = -EINVAL;
> +				goto out;
> +			}

This might be slightly wrong, you free and then can still return an
error.

> +			if (n_rssi_tholds == 1) {
> +				sta->rssi_low = rssi_tholds[0];
> +				sta->rssi_high = rssi_tholds[0];
> +			} else {
> +				sta->rssi_low = rssi_tholds[0];
> +				sta->rssi_high = rssi_tholds[1];
> +			}
> +		} else {
> +			const s32 *rssi_tholds;
> +
> +			rssi_tholds = kmemdup(rssi_tholds,
> +					      n_rssi_tholds * sizeof(s32),
> +					      GFP_KERNEL);
> +			if (!rssi_tholds) {
> +				ret = -ENOMEM;
> +				goto out;
> +			}

Similarly here, I guess you should do the allocation (and other error
checking) before freeing.

> +			sta->rssi_tholds = rssi_tholds;
> +			sta->n_rssi_tholds = n_rssi_tholds;
> +			ieee80211_update_rssi_config(sta);



> +struct sta_mon_rssi_config {
> +};

Huh?


The commit log also makes it sounds like mac80211 actually *supports*
this, but clearly that's not the case. However you don't give any data
to the driver either, did you lose a patch along the way? Previously you
had patch 5 ("mac80211: Implement functionality to monitor station's
rssi cross event") and if I remember correctly I said you should squash
some, but now that's not here?

johannes

