Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D156EE71D2D
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Sep 2023 13:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjI2NSW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjI2NSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2023 09:18:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D50E7
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2023 06:18:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA30C433C8;
        Fri, 29 Sep 2023 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695993499;
        bh=6eCocSUXWWHZqvMeL461G2ax4/sd6yLCuIpByV7gpgA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W0kUAD67zjoz8TpDNUCmCqzvkKZ5S/ZaWL0sg2YmC/Y76uiOfpaCPyXp0X7VyfUIg
         vGrO6geS6aoaeQV/ajGS6Uae8UHl7rzTBYHZ7AM5LkF0KFZtZ6qeM/plz186WDbp3G
         LQ3jvudGfKciE9ezSdqwo5L3bk0FUbYZ2uTeOx7xGgoriHG+pW2QBL0+et2A0kgbiX
         RZMztvijFaWju3o+3WZ5Y9wND32Y7VKyzyuKtf8IZmgs0U7MSi9ik3mfjqUAeKKP7l
         TijbepUzz4DO2D+e8YNtEOO3g+k90PFHSg7sNbU1/pUAsBnL0pPWUG67heNXXhB9yJ
         p6RyWdtcgNb+A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 09/13] wifi: ath11k: fill parameters for vdev set tpc
 power
 WMI command
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230920082349.29111-10-quic_wgong@quicinc.com>
References: <20230920082349.29111-10-quic_wgong@quicinc.com>
To:     Wen Gong <quic_wgong@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <quic_jjohnson@quicinc.com>, <quic_wgong@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169599349616.3629319.16079411629041044676.kvalo@kernel.org>
Date:   Fri, 29 Sep 2023 13:18:18 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <quic_wgong@quicinc.com> wrote:

> Prepare the parameters which is needed for WMI command WMI_VDEV_SET_TPC_POWER_CMDID.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
> 
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

And this also added new warnings:

drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_mac_fill_reg_tpc_info':
drivers/net/wireless/ath/ath11k/mac.c:7791:13: error: variable 'oper_freq' set but not used [-Werror=unused-but-set-variable]

drivers/net/wireless/ath/ath11k/mac.c:7731: Possible repeated word: 'the'
drivers/net/wireless/ath/ath11k/mac.c:7755: Possible repeated word: 'the'

I fixed them in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=c9f905ac838d9a7d79adb49951c7b0579d020c0a

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230920082349.29111-10-quic_wgong@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

