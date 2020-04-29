Return-Path: <SRS0=wwyj=6N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14721C83000
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 14:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F05AD20B80
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 14:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgD2OO6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbgD2OO6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Apr 2020 10:14:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5CC03C1AD
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2020 07:14:57 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jTnUG-001wZ3-5h; Wed, 29 Apr 2020 16:14:56 +0200
Message-ID: <a9bc44dcb782d3fd37311db511c943f7828821b2.camel@sipsolutions.net>
Subject: Re: [PATCH 1/5] mac80211: Random MAC address for a Management frame
 exchange
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 29 Apr 2020 16:14:54 +0200
In-Reply-To: <20200425155713.25687-1-jouni@codeaurora.org>
References: <20200425155713.25687-1-jouni@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2020-04-25 at 18:57 +0300, Jouni Malinen wrote:

> +++ b/net/mac80211/offchannel.c
> @@ -955,6 +955,12 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  		IEEE80211_SKB_CB(skb)->hw_queue =
>  			local->hw.offchannel_tx_hw_queue;
>  
> +	/* remember a random MAC address for Management frame exchange */
> +	if (wiphy_ext_feature_isset(wiphy,
> +				    NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA) &&
> +	    !ether_addr_equal(mgmt->sa, wdev_address(wdev)))
> +		memcpy(local->mgmt_tx_rand_addr, mgmt->sa, ETH_ALEN);
> +
>  	/* This will handle all kinds of coalescing and immediate TX */
>  	ret = ieee80211_start_roc_work(local, sdata, params->chan,
>  				       params->wait, cookie, skb,

This feels wrong to me. It seems it should be made part of the roc work
item, and only copied over when that item actually starts, and also used
to not coalesce different items if they specify conflicting temporary
addresses.

> @@ -971,6 +977,9 @@ int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
>  {
>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>  
> +	/* stop using the random MAC address for Management frame exchange */
> +	eth_zero_addr(local->mgmt_tx_rand_addr);
> +
>  	return ieee80211_cancel_roc(local, cookie, true);

Similar here, not clear that the ROC item even started yet at this
point.

It seems to me it needs to be pushed a layer deeper, say into
ieee80211_handle_roc_started() and ieee80211_offchannel_return() or so.

johannes

