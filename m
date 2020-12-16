Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999A9C4361B
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 21:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDD422582
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 21:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgLPVFA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Dec 2020 16:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgLPVE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Dec 2020 16:04:59 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A0FC061794
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2020 13:04:19 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kpdy5-00AGy9-Qa; Wed, 16 Dec 2020 22:04:17 +0100
Message-ID: <a8c30051bd1e7a5efbb98d391eb46959d046a941.camel@sipsolutions.net>
Subject: Re: [PATCH 7/7] mac80211: add rx decapsulation offload support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date:   Wed, 16 Dec 2020 22:04:16 +0100
In-Reply-To: <20201216204316.44498-7-nbd@nbd.name>
References: <20201216204316.44498-1-nbd@nbd.name>
         <20201216204316.44498-7-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wait, another thing:

> +++ b/net/mac80211/iface.c
> @@ -798,10 +798,21 @@ static bool ieee80211_set_sdata_offload_flags(struct ieee80211_sub_if_data *sdat
>  		flags &= ~IEEE80211_OFFLOAD_ENCAP_ENABLED;
>  	}
>  
> +	if (ieee80211_hw_check(&local->hw, SUPPORTS_RX_DECAP_OFFLOAD) &&
> +	    ieee80211_iftype_supports_encap_offload(sdata->vif.type)) {
> +		flags |= IEEE80211_OFFLOAD_DECAP_ENABLED;

Why does decap depend on encap here?

johannes


