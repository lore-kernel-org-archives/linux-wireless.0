Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4779C001E0
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 11:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjHBLqy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbjHBLqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 07:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF63926A1
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 04:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5433961938
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 11:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03809C433C7;
        Wed,  2 Aug 2023 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690976811;
        bh=5yK34ad/T3Jg2QEHhRuCarIVLq7/ED+M2l6b1OU90f0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=rVYnivjT4a5jGrDPVvdoda7FiLqtamsC2oryPuAmK7tB5kQfigqzWQcEVKax9/LL0
         /nS9t0kUudVHYHOnRFqFELol2JGTBAE2TM4bw9RDVIfq6cMMIrcPr0Ipbu/17YrkEv
         BSxs6jjk8DLwTj5nxsh2pvQbJerMv8grHSVLRna4ULXdaHjZszGmXHj9XGKi+nLPWi
         VWhT+2vpVGx5ByN1LhZSl1q6uLY6eH56fFFSUYBt1VpGXWW5fpFZhB6jbspYWutszT
         U62an32WfLidcNQQHVSU6PG/t5wleAdkxinwrGxLliUidO+kh4tk4HBOYNmhnZlopx
         NtHNri4EXDDXA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Wen Gong <quic_wgong@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] wifi: ath11k: update regulatory rules when
 interface added
References: <20230607094810.26707-1-quic_wgong@quicinc.com>
        <20230607094810.26707-5-quic_wgong@quicinc.com>
Date:   Wed, 02 Aug 2023 14:46:49 +0300
In-Reply-To: <20230607094810.26707-5-quic_wgong@quicinc.com> (Wen Gong's
        message of "Wed, 7 Jun 2023 05:48:09 -0400")
Message-ID: <87r0olvf86.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <quic_wgong@quicinc.com> writes:

> When wlan boot up, WMI_REG_CHAN_LIST_CC_EXT_EVENTID is sent from
> firmware at an early stage, the interface mode is not decided at
> this point, then ath11k select reg rules of AP mode as default.
>
> After interface is created, it is exactly decided AP/station mode,
> then ath11k need to update reg rules to the exact one.
>
> Tested-on: WCN6855 hw2.0 PCI
> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

What about mesh mode? The commit log mentions nothing about that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
