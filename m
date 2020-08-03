Return-Path: <SRS0=Ljpw=BN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A512CC433DF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 10:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892BB206D7
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 10:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgHCKSO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Aug 2020 06:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgHCKSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Aug 2020 06:18:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB86C06174A
        for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2020 03:18:11 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k2XXm-00Fckb-11; Mon, 03 Aug 2020 12:18:10 +0200
Message-ID: <b8455091e9ab4c0c3690dc3fadd000f1d1ca9165.camel@sipsolutions.net>
Subject: Re: [PATCH v3 1/2] nl80211: Unsolicited broadcast probe response
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aloka Dixit <alokad@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 03 Aug 2020 12:18:08 +0200
In-Reply-To: <20200715230514.26792-2-alokad@codeaurora.org>
References: <20200715230514.26792-1-alokad@codeaurora.org>
         <20200715230514.26792-2-alokad@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +/**
> + * enum nl80211_unsol_bcast_probe_resp_attributes - Unsolicited broadcast probe
> + *	response configuration. Applicable only in 6GHz.
> + *
> + * @__NL80211_UNSOL_BCAST_PROBE_RESP_INVALID: Invalid
> + *
> + * @NL80211_UNSOL_BCAST_PROBE_RESP_INT: Maximum packet interval (u32, TU).
> + *	Allowed range: 0..20 (TU = Time Unit). IEEE P802.11ax/D6.0
> + *	26.17.2.3.2 (AP behavior for fast passive scanning.

nit: that "(" never closes

> +	tmpl = tb[NL80211_UNSOL_BCAST_PROBE_RESP_TMPL];
> +	if (tmpl) {
> +		presp->tmpl = nla_data(tmpl);
> +		presp->tmpl_len = nla_len(tmpl);
> +	}
> 
So, hmm. Similar question here - what do you do without a template? Or
OTOH, why do you even need a template? Would you advertise something
that's *different* from the regular probe response template you already
get for offloaded probe request/response support?

johannes

