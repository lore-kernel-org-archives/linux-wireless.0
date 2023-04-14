Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B481C77B6F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 09:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDNJ4f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 05:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDNJ4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 05:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DA41FFE
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 02:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F297C64602
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 09:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21274C433EF;
        Fri, 14 Apr 2023 09:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681466192;
        bh=q0JP82xXUEYPRS0rvBdelk+iC70bwSMB/e1SYuII/Vk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HrJyDfWc/GZyD5PS8BEgnIOwokgKrIKCqaiXBvwDy9RlKNyiylPnhvvzA+QSrtQMt
         /dgNZVmmCLk6ZFFv4WSZ1YhWDTLKT08hLVKDtqW5zvS2McSMqznU7LHFKKw9l2pCZj
         aMdgGPCE2u2YMUxJetqQIjPfnT1H7CdNZUM8S0HXI8QjbVcLiH3kIW1LIl9JikDvkB
         WZ9jhJHCIXZsNfrufJsbA5CWHE77NsEh30ujUQor0U8Q/NaSGXniYX2dEE4vaS7j8M
         RO6LdgQDiX+eJDz8ywgFfUe1qcqJS52S+nSyDZJBuNpNCeJ7J+9jg36PD6+N2x1PMq
         UWzvmis0frGUg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
Cc:     <ath11k-bounces@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Abinaya Kalaiselvan <quic_akalaise@quicinc.com>
Subject: Re: [PATCH] wifi: ath11k: Add rx histogram stats
References: <20230405132804.226681-1-quic_mkenna@quicinc.com>
Date:   Fri, 14 Apr 2023 12:56:28 +0300
In-Reply-To: <20230405132804.226681-1-quic_mkenna@quicinc.com> (Maharaja
        Kennadyrajan's message of "Wed, 5 Apr 2023 18:58:04 +0530")
Message-ID: <87zg7ass6r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <quic_mkenna@quicinc.com> writes:

> Add peer specific debugfs support to store and
> display peer rx stats info like HE, VHT, HT,
> legacy and NSS.
> Also, add a debugfs knob to reset rx stats
> specific to the peer.
>
> This helps  to debug the throughput related
> issues in the UL traffic(STA to AP) by getting
> the segregated rx_stats info like HE, VHT, HT etc,.
>
> There is no addition of new debugfs_file here to get
> these segregated stats. The exising rx_stats is enhanced
> to get these stats.
>
> Usage:

This isn't right:

To:     <ath11k-bounces@lists.infradead.org>

Please use the correct address and resubmit as v2.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
