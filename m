Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACDBC4332F
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Nov 2022 09:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKIJOy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKIJOS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2022 04:14:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318CB2251F
        for <linux-wireless@vger.kernel.org>; Wed,  9 Nov 2022 01:12:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC8F3B81D51
        for <linux-wireless@vger.kernel.org>; Wed,  9 Nov 2022 09:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A42C433D6;
        Wed,  9 Nov 2022 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667985156;
        bh=8NzWCPjkAoa+RpKYFyCspWjzDZCZhOrqsXKUEyReREI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jxENUgkLMCrH+diHRalJM9zwlo1NtzJfbaJ/1jMOUs8/JJy2XGqkeYs4sW2BUePT9
         xfaHrMuhz+re/ox/2oFEtwhB6WpgrQjVdRDfMspviA54mZnZLaWNJszq2i8CNGK6jd
         BmXeTUzRAElHl0sGlnkJvhI5usiqj+EPk+XI5+m0cQZ98gRHJ898w3dCdh4EBN6kA/
         b4ejIVJRbggvR8bAcxB1Ex/gJ7sHc0/o+XkDyMBS6c6jQa7HXvU0wtkALHRAu0LBzV
         GCN3763QQ0N5vyvrnWOUH3kfvft/eALwSYId8wIGkH4ECZCqdIpj/t/KbuFo7r87VG
         dYCiWx4IeKkmg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     <linux-wireless@vger.kernel.org>, <ath12k@lists.infradead.org>
Subject: Re: [PATCH 07/50] wifi: ath12k: add dbring.c
References: <20220812161003.27279-1-kvalo@kernel.org>
        <20220812161003.27279-8-kvalo@kernel.org>
        <d9403714-d7ef-3a7c-0448-e5b2b0a60c34@quicinc.com>
        <87v8odjv1f.fsf@kernel.org>
Date:   Wed, 09 Nov 2022 11:12:32 +0200
In-Reply-To: <87v8odjv1f.fsf@kernel.org> (Kalle Valo's message of "Fri, 21 Oct
        2022 14:06:04 +0300")
Message-ID: <875yfocwzj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

>>> +int ath12k_dbring_buf_setup(struct ath12k *ar,
>>> +			    struct ath12k_dbring *ring,
>>> +			    struct ath12k_dbring_cap *db_cap)
>>> +{
>>> +	struct ath12k_base *ab = ar->ab;
>>> +	struct hal_srng *srng;
>>> +	int ret;
>>> +
>>> +	srng = &ab->hal.srng_list[ring->refill_srng.ring_id];
>>> +	ring->bufs_max = ring->refill_srng.size /
>>> +		ath12k_hal_srng_get_entrysize(ab, HAL_RXDMA_DIR_BUF);
>>> +
>>> +	ring->buf_sz = db_cap->min_buf_sz;
>>> +	ring->buf_align = db_cap->min_buf_align;
>>> +	ring->pdev_id = db_cap->pdev_id;
>>> +	ring->hp_addr = ath12k_hal_srng_get_hp_addr(ar->ab, srng);
>>> +	ring->tp_addr = ath12k_hal_srng_get_tp_addr(ar->ab, srng);
>>
>> s/ar->ab/ab/ in both of the above since you already have ab = ar->ab
>
> This is still not fixed.

This is now fixed.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
