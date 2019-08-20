Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA1C3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35352230F2
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfHTQwv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:52:51 -0400
Received: from nbd.name ([46.4.11.11]:60572 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfHTQwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 12:52:51 -0400
Received: from pd95fd754.dip0.t-ipconnect.de ([217.95.215.84] helo=[192.168.45.104])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1i07NJ-0006bl-RF; Tue, 20 Aug 2019 18:52:49 +0200
Subject: Re: [PATCH 02/49] ath11k: add Kconfig
To:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
 <1566316095-27507-3-git-send-email-kvalo@codeaurora.org>
From:   John Crispin <john@phrozen.org>
Message-ID: <f5af5ff4-63d6-6b94-6c04-8436f955985a@phrozen.org>
Date:   Tue, 20 Aug 2019 18:52:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1566316095-27507-3-git-send-email-kvalo@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 20/08/2019 17:47, Kalle Valo wrote:
> ---
>   drivers/net/wireless/ath/ath11k/Kconfig | 34 +++++++++++++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
> new file mode 100644
> index 000000000000..26bf98fa648e
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath11k/Kconfig
> @@ -0,0 +1,34 @@
> +config ATH11K
> +        tristate "Qualcomm Technologies 802.11ax chipset support"
> +        depends on MAC80211 && HAS_DMA

    ^^ space vs tab here

     John

> +	depends on REMOTEPROC
> +	depends on ARCH_QCOM || COMPILE_TEST
> +	select ATH_COMMON
> +	select QCOM_QMI_HELPERS
> +        help
> +          This module adds support for Qualcomm Technologies 802.11ax family of
> +	  chipsets.
> +
> +          If you choose to build a module, it'll be called ath11k.
> +
