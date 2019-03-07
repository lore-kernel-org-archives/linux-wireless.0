Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94136C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 15:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6748C20652
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 15:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dsy4bVlR";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e6YztNP8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfCGPmO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:42:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfCGPmN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 10:42:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8A6D06016D; Thu,  7 Mar 2019 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551973332;
        bh=8hnLI+4unoiRoQDzhLXSHv9McOthhblpMhzL68deYBw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dsy4bVlR0CrDHM+W9ekV5ronf2h55awQutlrLN3pyOboFpswsVYSVpkYhCW2LJd4i
         BHSOxrU7jw7UQynq/PpDGyskOiwrQbz4IrVAKWx0VQX+N8cOgXi1gV/6Fu4NPgV/aH
         QVL/lYBmv74BoOnQJ445lX7OGCS5gCRoY4lE3Kn4=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E73A56016D;
        Thu,  7 Mar 2019 15:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551973329;
        bh=8hnLI+4unoiRoQDzhLXSHv9McOthhblpMhzL68deYBw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=e6YztNP8Rn2JFUd4gYPc9rTlREZ6gyw9vvLPpWimMrg2BiTmml2HnfNH8Do2egYRo
         TcUa/LTVxng2z6h+Cfkih5gRtw+JZar5KwODtaORfdxM96gFfy5iaOQzO8jVUDz53z
         irV0MyNwx/HsVEupKwyVx6HUSVFDcepPzctofGuM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E73A56016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julius Niedworok <julius.n@gmx.net>
Cc:     linux-wireless@vger.kernel.org, ga58taw@mytum.de, david@redhat.com,
        nc@net.in.tum.de, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
        <20190306200206.60916-1-julius.n@gmx.net>
Date:   Thu, 07 Mar 2019 17:42:04 +0200
In-Reply-To: <20190306200206.60916-1-julius.n@gmx.net> (Julius Niedworok's
        message of "Wed, 6 Mar 2019 21:02:05 +0100")
Message-ID: <87k1hazo6r.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Julius Niedworok <julius.n@gmx.net> writes:

> At Technical University of Munich we use MAC 802.11 TX status frames to
> perform several measurements in MAC 802.11 setups.
>
> With ath based drivers this was possible until commit d94a461d7a7df6
> ("ath9k: use ieee80211_tx_status_noskb where possible") as the driver
> ignored the IEEE80211_TX_CTL_REQ_TX_STATUS flag and always delivered
> tx_status frames. Since that commit, this behavior was changed and the
> driver now adheres to IEEE80211_TX_CTL_REQ_TX_STATUS.
>
> Due to performance reasons, IEEE80211_TX_CTL_REQ_TX_STATUS is not set for
> data frames from interfaces in managed mode. Hence, frames that are sent
> from a managed mode interface do never deliver tx_status frames. This
> remains true even if a monitor mode interface (the measurement interface)
> is added to the same ieee80211 physical device. Thus, there is no
> possibility for receiving tx_status frames for frames sent on an interface
> in managed mode, if the driver adheres to IEEE80211_TX_CTL_REQ_TX_STATUS.
>
> In order to force delivery of tx_status frames for research and debugging
> purposes, implement a debugfs option force_tx_status for ieee80211 physical
> devices. When this option is set for a physical device,
> IEEE80211_TX_CTL_REQ_TX_STATUS is enabled in all packets sent from that
> device. This option can be set via
> /sys/kernel/debug/ieee80211/<dev>/force_tx_status. The default is disabled.
>
> Co-developed-by: Charlie Groh <ga58taw@mytum.de>
> Signed-off-by: Charlie Groh <ga58taw@mytum.de>
> Signed-off-by: Julius Niedworok <julius.n@gmx.net>

[...]

> +	len = scnprintf(buf, sizeof(buf), "%d\n", (int)local->force_tx_status);

I wonder about the cast, is it guaranteed that a bool is always of the
same size as an int?

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1367,6 +1367,7 @@ struct ieee80211_local {
>  		struct dentry *rcdir;
>  		struct dentry *keys;
>  	} debugfs;
> +	bool force_tx_status;

[...]

>  #endif
>  
>  	/*
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 928f13a..717fa71 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2463,6 +2463,11 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
>  	if (IS_ERR(sta))
>  		sta = NULL;
>  
> +#ifdef CONFIG_MAC80211_DEBUGFS
> +		if (local->force_tx_status)
> +			info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
> +#endif
> +
>  	/* convert Ethernet header to proper 802.11 header (based on
>  	 * operation mode) */
>  	ethertype = (skb->data[12] << 8) | skb->data[13];
> @@ -3468,6 +3473,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
>  		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
>  	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT;
>  
> +#ifdef CONFIG_MAC80211_DEBUGFS
> +		if (local->force_tx_status)
> +			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
> +#endif

IMHO the ifdefs look pointless just to save four bytes. I would move
force_tx_status outside of ifdef in the struct so that the actual code
doesn't have ugly ifdefs.

-- 
Kalle Valo
