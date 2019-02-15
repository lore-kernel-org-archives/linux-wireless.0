Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8C1217F5
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfBOKoZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:44:25 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38020 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388008AbfBOKoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:44:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guayl-0004N4-4S; Fri, 15 Feb 2019 11:44:23 +0100
Message-ID: <0541dec472c83b173a486a924983a450ede7e923.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: probe unexercised mesh links
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, kevinhayes@google.com,
        julanhsu@google.com
Date:   Fri, 15 Feb 2019 11:44:21 +0100
In-Reply-To: <1550152570-13051-3-git-send-email-rmanohar@codeaurora.org>
References: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
         <1550152570-13051-3-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>  void __ieee80211_subif_start_xmit(struct sk_buff *skb,
>  				  struct net_device *dev,
> -				  u32 info_flags);
> +				  u32 info_flags,
> +				  u32 ctrl_flags);

I'd feel better if we could avoid all this, but if you really can't then
I guess we should split this out to a separate patch.

>  
> +	/* Allow injected packets to bypass mesh routing */
> +	if (info->control.flags & IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP)

unlikely?

> +int ieee80211_probe_mesh_link(struct wiphy *wiphy, struct net_device *dev,
> +			      const u8 *dest, const u8 *buf, size_t len)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +	struct sta_info *sta;
> +	struct sk_buff *skb;
> +	struct ethhdr *ehdr;
> +
> +	if (len < sizeof(*ehdr))
> +		return -EINVAL;
> +
> +	mutex_lock(&local->sta_mtx);
> +	sta = sta_info_get_bss(sdata, dest);
> +	mutex_unlock(&local->sta_mtx);
> +
> +	if (!sta)
> +		return -ENOENT;

better add a comment here that the locking is fine because you only
check *existence* and don't use the sta pointer for anything else

> +	ehdr = (struct ethhdr *)buf;
> +	if (!ether_addr_equal(ehdr->h_dest, dest) ||

that check could be in cfg80211, but then why even bother passing the
"dest" separately?

> +	    !ether_addr_equal(ehdr->h_source, sdata->vif.addr) ||

probably this one too

> +	    is_multicast_ether_addr(ehdr->h_dest))

this one too

But also, ehdr isn't packed I think, you might have alignment issues
here as you don't know how the netlink message looks like? I think?

> +	if (ehdr->h_proto != htons(ETH_P_802_3))
> +		return -EINVAL;

same here

> +	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);

you should make it a bit bigger so header conversion will fit, I guess?

johannes

