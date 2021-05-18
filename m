Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE74C433ED
	for <linux-wireless@archiver.kernel.org>; Tue, 18 May 2021 11:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27DAA610FA
	for <linux-wireless@archiver.kernel.org>; Tue, 18 May 2021 11:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243308AbhERLS4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 May 2021 07:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbhERLS4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 May 2021 07:18:56 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D3EC061573
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2021 04:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YWIOjiaBpbdUgeRNWpsSftzM0rNUGXuC8WZElBYWACU=; b=g4nYkcZq1mWI9uAbox+Xl5Razq
        dJ06cMsKGR11Cxcxo1L0x51VcdOZXASBrEXY4AdFR2tY7B4jFjWzO7SqUuAdvBNn80k4oUMANt83q
        kAebDqAant8PsljyxA1RKZyHaKdh0lj892c7x6laNRku0A4JKg4/vWxaUwX13HsLInG0=;
Received: from p54ae9ff2.dip0.t-ipconnect.de ([84.174.159.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lixjD-0007ER-1f; Tue, 18 May 2021 13:17:35 +0200
To:     Philipp Borgers <borgers@mi.fu-berlin.de>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20210518110755.43077-1-borgers@mi.fu-berlin.de>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 1/2] mac80211: do not use low data rates for data frames
 with no ack flag
Message-ID: <f80ba91c-88d4-3064-6861-5f9510b4fb69@nbd.name>
Date:   Tue, 18 May 2021 13:17:34 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518110755.43077-1-borgers@mi.fu-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2021-05-18 13:07, Philipp Borgers wrote:
> Data Frames with no ack flag set should be handle by the rate controler.
> Make sure we reach the rate controler by returning early from
> rate_control_send_low if the frame is a data frame with no ack flag.
> 
> Signed-off-by: Philipp Borgers <borgers@mi.fu-berlin.de>
> ---
>  net/mac80211/rate.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index 63652c39c8e0..4f5b35a0ea28 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -391,11 +391,16 @@ static bool rate_control_send_low(struct ieee80211_sta *pubsta,
>  				  struct ieee80211_tx_rate_control *txrc)
>  {
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) txrc->skb->data;
>  	struct ieee80211_supported_band *sband = txrc->sband;
>  	struct sta_info *sta;
>  	int mcast_rate;
>  	bool use_basicrate = false;
>  
> +	if (ieee80211_is_data(hdr->frame_control) &&
> +			(info->flags & IEEE80211_TX_CTL_NO_ACK))
> +		return false;
Frames with IEEE80211_TX_CTL_HW_80211_ENCAP set have no 802.11 header,
so please change the check something like this:

	if ((info->flags & IEEE80211_TX_CTL_NO_ACK) &&
	    ((info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) ||
	     ieee80211_is_data(hdr->frame_control)))

Same applies to the other patch.
There are other places in the code where this kind of change needs to be
done, but it would be good if at least newly added code handles it properly.

- Felix
