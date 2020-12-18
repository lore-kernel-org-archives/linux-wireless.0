Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2EEC4361B
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA8A23B86
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Dec 2020 19:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgLRTY3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Dec 2020 14:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730082AbgLRTY2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Dec 2020 14:24:28 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F95BC0617A7
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2020 11:23:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v2so2105650pfm.9
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2020 11:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eero.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RtiyhyBkL4tfd0RAGR/mPDiJQVNxW+PMiUHl3EQBP/w=;
        b=RinV89pA5JcUZowGG657O+HY/Gtx+v7rGrcbd8GB03LBGrMc6G9skx56mHEOK6VTiD
         r/wlKvMZtUI4aEKrqDXpkBBITMrU8CIMtyy9OVu133431dsZjxliXpMvtUyBz3ntFaiN
         avVWK7yWl+DEWqXF2Eg9YqJHaaGcqxJSfBw0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RtiyhyBkL4tfd0RAGR/mPDiJQVNxW+PMiUHl3EQBP/w=;
        b=Ltbj2oPFS1eaZomRgSTh+AR6VZfpPRF9gDC8kxSjsKc5riQivroQLjx3Udqjc8k/7d
         oxYXx+7fYbfjWb57ZtbtiXixjLeTBxIH/5O/iscPiR7W8FtRuzc+LVjnG8dr/TJx44pq
         AeHGY63qAVtXiSdf8elAvs+nJj8o45xeTb1+sDKll6bwZOzOhPyXpPhiOsebeKfE9nUJ
         309F1fHbam1jgbZOxGCRIXa5oOeRfBJAPGkw0RQFNaXUOk8zeXzoY3o8jjQ//kaeASMZ
         IEL2jgYOBRyBoVWOMcByAjVAQE2rdfv0ZBfdI0LcHT7IF2z/ofbGituFUlFDq68HZkrs
         erYQ==
X-Gm-Message-State: AOAM5338Wwe0rv/en/qAb9rcP8BjRWS0IpmYHqdq3nPaoPcEI8MYlrm4
        PLv4JQugeqbbJ+LTs0HxfBzCw6yzR9e1Bfex
X-Google-Smtp-Source: ABdhPJx/AP5DkoyJQ+EP9RmbLoqe5jtY9waPKfIHojLEl6YmcUPmFecZjyAFwGtl6+gddayD8Wo3yA==
X-Received: by 2002:a63:c644:: with SMTP id x4mr5527568pgg.421.1608319427564;
        Fri, 18 Dec 2020 11:23:47 -0800 (PST)
Received: from [192.168.4.200] (c-76-102-118-9.hsd1.ca.comcast.net. [76.102.118.9])
        by smtp.gmail.com with ESMTPSA id z10sm9562004pfr.204.2020.12.18.11.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 11:23:46 -0800 (PST)
Subject: Re: [PATCH] ath11k: Update tx descriptor search index properly
To:     Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
References: <1608305041-21946-1-git-send-email-periyasa@codeaurora.org>
From:   Peter Oh <peter.oh@eero.com>
Message-ID: <959ea12a-e35b-5867-c55e-7f62e2956b09@eero.com>
Date:   Fri, 18 Dec 2020 11:23:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1608305041-21946-1-git-send-email-periyasa@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 12/18/20 7:24 AM, Karthikeyan Periyasamy wrote:
> Tx descriptor search index field should be updated with hw peer id
> and not by AST Hash. Incorrect search index causes throughput degradation
> in all the platforms. so updated the search index field with hw peer id,
> which is a common change applicable for all the platforms.
>
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01492-QCAHKSWPL_SILICONZ-1
>
> diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
> index b69e7eb..f49abefa 100644
> --- a/drivers/net/wireless/ath/ath11k/peer.c
> +++ b/drivers/net/wireless/ath/ath11k/peer.c
>
> @@ -309,7 +310,11 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
>   
>   	peer->pdev_idx = ar->pdev_idx;
>   	peer->sta = sta;
> -	arvif->ast_hash = peer->ast_hash;
> +
> +	if (arvif->vif->type == NL80211_IFTYPE_STATION) {
> +		arvif->ast_hash = peer->ast_hash;
> +		arvif->ast_idx = peer->hw_peer_id;
> +	}

How about non STATION type?


Thanks,

Peter

