Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9049DC282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 697232063F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfDHL4s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:56:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53550 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfDHL4s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 07:56:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDStK-0005d8-6W; Mon, 08 Apr 2019 13:56:46 +0200
Message-ID: <648ce8473bf0155f4e306d09daa29d5e3cb4a259.camel@sipsolutions.net>
Subject: Re: [PATCHv2 2/2] mac80211: Implement API to configure station
 specific rssi threshold
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 13:56:45 +0200
In-Reply-To: <1549361181-6237-3-git-send-email-tamizhr@codeaurora.org>
References: <1549361181-6237-1-git-send-email-tamizhr@codeaurora.org>
         <1549361181-6237-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +++ b/net/mac80211/cfg.c
> @@ -3889,6 +3889,110 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
>  	return drv_abort_pmsr(local, sdata, request);
>  }
>  
> +void sta_mon_rssi_config_free(struct sta_info *sta)
> +{
> +	if (sta->rssi_config) {
> +		kfree_rcu(sta->rssi_config, rcu_head);
> +		sta->rssi_config = NULL;
> +	}
> +}

This looks wrong, you should use RCU_INIT_POINTER()?

And you should do it the other way around I think? I.e.

 old = sta->rssi_config;
 RCU_INIT_POINTER(sta->rssi_config, NULL);
 kfree_rcu(old, rcu_head);


>  /*
>   * The bandwidth threshold below which the per-station CoDel parameters will be
>   * scaled to be more lenient (to prevent starvation of slow stations). This
> @@ -623,6 +650,7 @@ struct sta_info {
>  
>  	struct cfg80211_chan_def tdls_chandef;
>  
> +	struct sta_mon_rssi_config *rssi_config;

Please add documentation (as built bot pointed out shortly after patch
posting!)

johannes

