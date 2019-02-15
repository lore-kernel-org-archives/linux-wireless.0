Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F253EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25CE21929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436698AbfBOLuQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:50:16 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38928 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfBOLuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:50:14 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guc0S-00068L-Mc; Fri, 15 Feb 2019 12:50:12 +0100
Message-ID: <c64a7a722fefe698e86dbc61ab4d6d2e087ae853.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 05/12] mac80211: Mark A-MPDU keyid borders for
 drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:50:10 +0100
In-Reply-To: <20190210210620.31181-6-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-6-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> The intent of the wording was probably written without considering
> Extended Key IDs. At least it makes no sense for me to forbid mixing
> MPDUs using keyid 0 and 1 in one A-MPDU. 

I think it may make sense - reprogramming the hardware engines may take
some time, and doing that in the middle of the A-MPDU may not be
feasible? You don't just have to load the key (that you need to do
anyway) but also extract the status? I dunno, I'm more handwaving, but
it doesn't make sense to add such a requirement when only one key index
can be used to start with.

> The code is assuming that the driver is not aggregating MPDUs more than
> 5s apart. We probably don't have wait nearly so long but I'm not sure
> what is the minimum time.

OTOH, if you have a lot of BE/VI/VO traffic BK might be starved even
longer than that, technically indefinitely.

> +static struct ieee80211_key debug_noinline
> +*ieee80211_select_sta_key(struct ieee80211_tx_data *tx)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
> +	struct sta_info *sta = tx->sta;
> +	struct ieee80211_key *key;
> +	struct ieee80211_key *next_key;
> +
> +	key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
> +
> +	if (likely(sta->ptk_idx_next == INVALID_PTK_KEYIDX))
> +		return key;
> +
> +	/* Only when using Extended Key ID the code below can be executed */
> +
> +	if (!ieee80211_is_data_present(hdr->frame_control))
> +		return key;
> +
> +	if (sta->ptk_idx_next == sta->ptk_idx) {
> +		/* First packet using new key with A-MPDU active*/
> +		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
> +		ieee80211_check_fast_xmit(tx->sta);

I'm not convinced you can call this from this context? It looks safe
though, but it's really strange in a way.

> +	info->flags &= ~IEEE80211_TX_CTL_AMPDU;

Like you say above, I don't think this really makes a lot of sense. If
we don't have any free bits I guess we should try to find some ...

johannes

