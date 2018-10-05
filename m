Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F240AC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 19:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C653520875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 19:09:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C653520875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbeJFCJ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 22:09:58 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:57254 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJFCJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 22:09:57 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id B4E3E40A30A;
        Fri,  5 Oct 2018 12:09:50 -0700 (PDT)
Subject: Re: [PATCH] ath10k: htt_rx: Fix signedness bug in
 ath10k_update_per_peer_tx_stats
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20181005184245.GA11700@embeddedor.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <3a55bec6-d20d-f500-e741-b228a86b7117@candelatech.com>
Date:   Fri, 5 Oct 2018 12:09:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <20181005184245.GA11700@embeddedor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/05/2018 11:42 AM, Gustavo A. R. Silva wrote:
> Currently, the error handling for the call to function
> ath10k_get_legacy_rate_idx() doesn't work because
> *rate_idx* is of type u8 (8 bits, unsigned), which
> makes it impossible for it to hold a value less
> than 0.
>
> Fix this by changing the type of variable *rate_idx*
> to s8 (8 bits, signed).

There are more than 127 rates, are you sure this is doing
what you want?

Thanks,
Ben

>
> Addresses-Coverity-ID: 1473914 ("Unsigned compared against 0")
> Fixes: 0189dbd71cbd ("ath10k: get the legacy rate index to update the txrate table")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index f240525..edd0e74 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2753,7 +2753,8 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
>  				struct ath10k_per_peer_tx_stats *peer_stats)
>  {
>  	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
> -	u8 rate = 0, rate_idx = 0, sgi;
> +	u8 rate = 0, sgi;
> +	s8 rate_idx = 0;
>  	struct rate_info txrate;
>
>  	lockdep_assert_held(&ar->data_lock);
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

