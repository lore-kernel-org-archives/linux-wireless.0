Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C569C001E0
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 16:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjHBQy7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjHBQyo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 12:54:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91695E53
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 09:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B6F6194E
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 16:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C002C433C8;
        Wed,  2 Aug 2023 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690995270;
        bh=A2OruOp+lJC1+M5+VpWcfMzRWKAKt+bR0nx1v+/4O/M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kny19TAcHybABvRt1Rhy4fqlLq0E3v3v7M4AAFjXHGn9Shag3S1BMy7I9JwhK1vv9
         Q4LPmWEzhlU8NignCZieIvNZoBWgHEMoNjVN3CCMk3Ki1HNfhuYRy71ChKggBVrXqe
         rhZaGKyzkfmzbF5obxpcTCw9amx8NzRirw3VChAtYxLU7KbYHrrCSS71+S7GX74Y5R
         r83D90lDaa5gDFGc6BI+LfgfdqDaAVDrzs1EFYuVDJnejSpnmLj1ESxDecWXuaSY6v
         7YRxv7W0PB9NtqPNPa2rxE1iJ4teSYbkj1gx7cj5dmVI81nhLvZJcnWuJDn45pUes/
         nnq5theb2oFow==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath12k: Fix a NULL pointer dereference in
 ath12k_mac_op_hw_scan()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230726092625.3350-1-quic_wgong@quicinc.com>
References: <20230726092625.3350-1-quic_wgong@quicinc.com>
To:     Wen Gong <quic_wgong@quicinc.com>
Cc:     <ath12k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <quic_wgong@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169099526747.463701.13168373572998934165.kvalo@kernel.org>
Date:   Wed,  2 Aug 2023 16:54:29 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <quic_wgong@quicinc.com> wrote:

> In ath12k_mac_op_hw_scan(), the return value of kzalloc() is directly
> used in memcpy(), which may lead to a NULL pointer dereference on
> failure of kzalloc().
> 
> Fix this bug by adding a check of arg.extraie.ptr.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
> 
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

8ad314da54c6 wifi: ath12k: Fix a NULL pointer dereference in ath12k_mac_op_hw_scan()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230726092625.3350-1-quic_wgong@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

