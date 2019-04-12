Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23897C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4D842171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LWqwdbDB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Je0uAuzj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfDLNRb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:17:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfDLNRa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:17:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 239A36155F; Fri, 12 Apr 2019 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075050;
        bh=g/9vZyc0PHJGnOiBuDtmKUW611eqAtC2G9PU69d3G24=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LWqwdbDBKSmQt71Mx3ZoWtwXc27QDioM0JHUJ86ONPMb1EJao42LKsyUqzqyOcfD0
         puCBZwt+8B5LrahUOgG78xvym9l47Zg/Kv9V/EF0Uk44JXZCmSHuTI9ziINsHUAAa/
         WzjsNM3ahYFkWp6IDpz2WLLQiPLFi0Utbz3hAgX8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A39DA6155C;
        Fri, 12 Apr 2019 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555075049;
        bh=g/9vZyc0PHJGnOiBuDtmKUW611eqAtC2G9PU69d3G24=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Je0uAuzj6h8WfyeU6Pwt2rfcByPAlBHrJ/PRRqE+gkNBXFCH8Cpn+rXRzU48B1kjc
         mIrI3tcpNi5F/DS4QaxRBjo8IDMLoMyLIf6J/HyT7bUDGMtL6WAci62qmWMuvuNCd6
         Xuy2Zbk+lDrs4sYBgpoH+hIx2qpL9XDJj8iDcns8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A39DA6155C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 6/6] ath10k: sdio: replace skb_trim with explicit set of skb->len
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
        <20190409190851.4557-7-erik.stromdahl@gmail.com>
Date:   Fri, 12 Apr 2019 16:17:26 +0300
In-Reply-To: <20190409190851.4557-7-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Tue, 9 Apr 2019 21:08:51 +0200")
Message-ID: <87zhovcqhl.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This patch fixes a bug with padding of the skb data buffer.
> Since skb_trim can only be used to reduce the skb len, it is useless when
> we pad (increase the length of) the skb. Instead we must set skb->len
> directly.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/sdio.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
> index 3eb241cb8a25..989e3f563f3d 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -1496,7 +1496,12 @@ static int ath10k_sdio_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
>  		skb = items[i].transfer_context;
>  		padded_len = ath10k_sdio_calc_txrx_padded_len(ar_sdio,
>  							      skb->len);
> -		skb_trim(skb, padded_len);
> +		/* FIXME: unsure if just extending the skb len is the right
> +		 * thing to do since we might read outside the skb->data
> +		 * buffer. But we really don't want to realloc the skb just to
> +		 * pad the length.
> +		 */
> +		skb->len = padded_len;

Good catch! But I don't think you can modify skb->len directly like
that. There is skb_pad() but that doesn't change skb->len, so that most
likely needs more changes. So maybe skb_put() is the safest here?

-- 
Kalle Valo
