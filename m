Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED72C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA46206B7
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA46206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbeLEO6f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:58:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41746 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeLEO6f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 09:58:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUYdF-0000uX-Oi; Wed, 05 Dec 2018 15:58:33 +0100
Message-ID: <24665c3e0e7e970eb8cd63dad57e2b0b3097cfcc.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 2/2] mac80211: Add support for Extended Key ID
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 05 Dec 2018 15:58:32 +0100
In-Reply-To: <20181111110235.14213-3-alexander@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
         <20181111110235.14213-3-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> + * @IEEE80211_KEY_FLAG_RX_ONLY: Set by mac80211 to indicate that the key
> + *      must not be used for TX (yet).

I'm not sure that's relevant, since you have one key pointer for TX?

> + * @IEEE80211_KEY_FLAG_SET_TX: Set by mac80211 to indicate that a previously
> + *      installed key with IEEE80211_KEY_FLAG_RX_ONLY should take over TX also.

That also doesn't seem relevant ...

Oh, all of this is for HW offloads?

I _think_ I would prefer to have new key ops instead. Now you'd have 

SET_KEY / <empty flags>
SET_KEY / RX_ONLY
SET_KEY / SET_TX

but I think maybe

SET_KEY
SET_KEY_RX_ONLY
KEY_ENABLE_TX

would make more sense?

> +	if (pairwise && params->flag == NL80211_KEY_SET_TX) {
> +		mutex_lock(&local->sta_mtx);
> +		sta = sta_info_get_bss(sdata, mac_addr);
> +
> +		if (!sta ||
> +		   !(key = rcu_dereference(sta->ptk[key_idx])) ||

indentation here is off by one

> +		   !(key->conf.flags | IEEE80211_KEY_FLAG_RX_ONLY)) {

that makes no sense, should be & I guess

> -	/* PTK only using key ID 0 needs special handling on rekey */
> -	if (new_key && sta && ptk0rekey) {
> +	/* PTK rekey without Extended Key ID needs special handling */
> +	if (new_key && pairwise && sta &&
> +	    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID)) {
>  		local = old_key->local;
>  		sdata = old_key->sdata;

This seems wrong, even if you have ext key ID support and everything,
but you do 0 -> 0 rekeying, then you still need all the special handling
(in fact also then if you go 1->1!). So it seems you'd instead want to
see if you're going from a TX key to a TX key with the same key ID, and
then you don't need this flag at all.

> +++ b/net/mac80211/sta_info.c
> @@ -350,6 +350,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	sta->sta.max_rx_aggregation_subframes =
>  		local->hw.max_rx_aggregation_subframes;
>  
> +	sta->ptk_idx = NUM_DEFAULT_KEYS - 1;

That makes no sense? Why should it be 3? That's invalid anyway?

johannes

