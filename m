Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C549C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB3820880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QyAF1Yed";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c1Q/yPiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfA1J30 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:29:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfA1J30 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:29:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 529B9609C6; Mon, 28 Jan 2019 09:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548667764;
        bh=qGuerIQs79sritRTlP8CHosiqMEi2F7ufAIK6ZFvE0M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QyAF1YedWuQkeb1N5wwfDhEPMiP65sFK3Pq5dKEeDSLl/PR9mFoGg8bu6BSilxagL
         JFOWMUxv87hLQMuMOKMtjeSm4mEGIAfbF6kE47jIlnpjLbYkzbagf3WCDLJZTZkT27
         +/aZG6GjbZ04hnCDjlFp80VmxsOfV3rKS9ha334Y=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D754C6098A;
        Mon, 28 Jan 2019 09:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548667762;
        bh=qGuerIQs79sritRTlP8CHosiqMEi2F7ufAIK6ZFvE0M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=c1Q/yPiYw9efLNMABoxOfwXdPcl2YofQJr3R1FrpJvXIW0K25DPXhbRLZ9f4BJ2p9
         oTQJHVm8rVjnv67tasXOWCv8usORJkn6m7TkhkgHrVD8bvoRsaQGs6KM9uQQvODfB7
         Yfjctm0myDgbfEn4ux6D4BnBX7JkUtRGc3SPi4jw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D754C6098A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Siva Rebbagondla <siva8118@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: Re: [PATCH 2/5] rsi: add hci detach for hibernation and poweroff
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
        <1548397802-12180-3-git-send-email-siva8118@gmail.com>
Date:   Mon, 28 Jan 2019 11:29:18 +0200
In-Reply-To: <1548397802-12180-3-git-send-email-siva8118@gmail.com> (Siva
        Rebbagondla's message of "Fri, 25 Jan 2019 11:59:59 +0530")
Message-ID: <87d0oh166p.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Siva Rebbagondla <siva8118@gmail.com> writes:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>
> As we missed to detach HCI, while entering power off or hibernation,
> an extra hci interface gets created whenever system is woken up, to
> avoid this we added hci_detach() in rsi_disconnect(), rsi_freeze(),
> and rsi_shutdown() functions which are invoked for these tests.
> This patch fixes the issue
>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 +++++++++++++++++++--
>  drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 ++++++
>  2 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> index b412b65e..59ff778 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> @@ -1131,7 +1131,12 @@ static void rsi_disconnect(struct sdio_func *pfunction)
>  
>  	rsi_mac80211_detach(adapter);
>  	mdelay(10);
> -
> +#ifdef CONFIG_RSI_COEX
> +	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
> +		rsi_bt_ops.detach(adapter->priv->bt_adapter);
> +		adapter->priv->bt_adapter = NULL;
> +	}
> +#endif

Ifdefs are ugly, avoid them as much as possible. Would this work:

        if (IS_ENABLED(CONFIG_RSI_COEX) &&
            adapter->priv->coex_mode > 1 &&
            adapter->priv->bt_adapter)

BTW, why do you need the ifdef anyway, isn't it enough to check for
coex_mode?


-- 
Kalle Valo
