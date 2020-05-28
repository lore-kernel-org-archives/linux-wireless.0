Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB4FC433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 12:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9863206C3
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 12:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbgE1MdY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 08:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389279AbgE1MdX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 08:33:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80D4C05BD1E
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 05:33:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeHir-004qw5-6y; Thu, 28 May 2020 14:33:21 +0200
Message-ID: <68fbee40ce84c50fe137659d124071634bc38ab1.camel@sipsolutions.net>
Subject: Re: [RFC 08/10] mac80211: add HE 6 GHz Band Capability element
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Date:   Thu, 28 May 2020 14:33:20 +0200
In-Reply-To: <20200528114415.535bddb18860.I3f9747c1147480f65445f13eda5c4a5ed4e86757@changeid> (sfid-20200528_114501_495096_0027A921)
References: <20200528114415.3596a1eedb31.Ic15e681a0e249eab7350a06ceb582cca8bb9a080@changeid>
         <20200528114415.535bddb18860.I3f9747c1147480f65445f13eda5c4a5ed4e86757@changeid>
         (sfid-20200528_114501_495096_0027A921)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-05-28 at 11:44 +0200, Johannes Berg wrote:
> 
> +void ieee80211_ie_build_he_6ghz_cap(struct ieee80211_sub_if_data *sdata,
> +				    struct sk_buff *skb)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_supported_band *sband;
> +	const struct ieee80211_sband_iftype_data *iftd;
> +	enum nl80211_iftype iftype = ieee80211_vif_type_p2p(&sdata->vif);
> +	u8 *pos;
> +	u16 cap;
> +
> +	sband = local->hw.wiphy->bands[NL80211_BAND_6GHZ];

Err, no. Of course I need to use ieee80211_get_sband() like you did.

johannes

