Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B1CC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9144320818
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 13:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZhXG5eka";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZhXG5eka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfDLNIm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:08:42 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfDLNIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 09:08:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7D66E61570; Fri, 12 Apr 2019 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555074521;
        bh=snlaGf/jcZFuhN021UZmo7MyXEQpxVOeHJTGRtPqNco=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZhXG5ekaPxZIK0dY6M/vt4G1IAl6TQQZw7GotV/bKuddXoE46SoCogaSBw+EEWV7s
         NU7hcAGMF6w417t8gb0hV7wpQB9nALUAOkNRgO9JQc7nFS/sq6SES4g2p6ax8csotp
         3kn0ZegQ47SNrTrUAVNm4T5SSMkn72DEaDNrB0yA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F333961344;
        Fri, 12 Apr 2019 13:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555074521;
        bh=snlaGf/jcZFuhN021UZmo7MyXEQpxVOeHJTGRtPqNco=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZhXG5ekaPxZIK0dY6M/vt4G1IAl6TQQZw7GotV/bKuddXoE46SoCogaSBw+EEWV7s
         NU7hcAGMF6w417t8gb0hV7wpQB9nALUAOkNRgO9JQc7nFS/sq6SES4g2p6ax8csotp
         3kn0ZegQ47SNrTrUAVNm4T5SSMkn72DEaDNrB0yA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F333961344
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: Re: [PATCH 3/6] ath10k: sdio: read RX packets in bundles
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
        <20190409190851.4557-4-erik.stromdahl@gmail.com>
Date:   Fri, 12 Apr 2019 16:08:37 +0300
In-Reply-To: <20190409190851.4557-4-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Tue, 9 Apr 2019 21:08:48 +0200")
Message-ID: <874l73e5gq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> From: Alagu Sankar <alagusankar@silex-india.com>
>
> The existing implementation of initiating multiple sdio transfers for
> receive bundling is slowing down the receive speed.
>
> Instead of having one sdio transfer for each packet in the bundle, we
> read all packets in one sdio transfer.
>
> This results in significant performance improvement on some targets.

Do you have any numbers? Before and after would be nice to know.

> +static int ath10k_sdio_mbox_rx_fetch(struct ath10k *ar)
>  {
>  	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
> +	struct ath10k_sdio_rx_data *pkt = &ar_sdio->rx_pkts[0];
>  	struct sk_buff *skb = pkt->skb;
>  	int ret;
>  
> -	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
> -				 skb->data, pkt->alloc_len);
> -	pkt->status = ret;
> -	if (!ret)
> +	ret = ath10k_sdio_read(ar, ar_sdio->mbox_info.htc_addr,
> +			       skb->data, pkt->alloc_len);
> +	if (ret) {
> +		ar_sdio->n_rx_pkts = 0;
> +		ath10k_sdio_mbox_free_rx_pkt(pkt);
> +	} else {
> +		pkt->status = ret;
>  		skb_put(skb, pkt->act_len);
> +	}

With this you can avoid the else branch:

if (ret) {
	ar_sdio->n_rx_pkts = 0;
	ath10k_sdio_mbox_free_rx_pkt(pkt);
        return ret;
}

> -static int ath10k_sdio_mbox_rx_fetch(struct ath10k *ar)
> +static int ath10k_sdio_mbox_rx_fetch_bundle(struct ath10k *ar)
>  {
>  	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
> +	struct ath10k_sdio_rx_data *pkt;
>  	int ret, i;
> +	u32 pkt_offset = 0, pkt_bundle_len = 0;
> +
> +	for (i = 0; i < ar_sdio->n_rx_pkts; i++)
> +		pkt_bundle_len += ar_sdio->rx_pkts[i].alloc_len;
> +
> +	if (pkt_bundle_len > ATH10K_SDIO_READ_BUF_SIZE) {
> +		ret = -ENOMEM;
> +		ath10k_err(ar, "bundle size (%d) exceeding limit %d\n",
> +			   pkt_bundle_len, ATH10K_SDIO_READ_BUF_SIZE);

As this is a recoverable case please use ath10k_warn(). And would
-ENOSPC be more descriptive error?

> +		goto err;
> +	}
> +
> +	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
> +				 ar_sdio->sdio_read_buf, pkt_bundle_len);
> +	if (ret)
> +		goto err;
>  
>  	for (i = 0; i < ar_sdio->n_rx_pkts; i++) {
> -		ret = ath10k_sdio_mbox_rx_packet(ar,
> -						 &ar_sdio->rx_pkts[i]);
> -		if (ret)
> -			goto err;
> +		struct sk_buff *skb = ar_sdio->rx_pkts[i].skb;
> +
> +		pkt = &ar_sdio->rx_pkts[i];
> +		memcpy(skb->data, ar_sdio->sdio_read_buf + pkt_offset,
> +		       pkt->alloc_len);
> +		pkt->status = 0;
> +		skb_put(skb, pkt->act_len);

Shouldn't you call first skb_put() and then memcpy()?

-- 
Kalle Valo
