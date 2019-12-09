Return-Path: <SRS0=UTNx=Z7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SPACE_RATIO autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03290C43603
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 19:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB398206E0
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 19:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g+ubyZbd";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CClNepi/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfLITr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:47:57 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:51956
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbfLITr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Dec 2019 14:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575920876;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=P1m0j0XGFyovvK7fT8FKAKKgAru998yHIVdxJadEKwE=;
        b=g+ubyZbd9/hmtA4yOkxI083/StHCgDrjCdzkiOjdYLHo0h0liDbPq7yjI78r+2dl
        EFTPGeipouZYe6+wnGqQn/rdpTUkNApR4Jnl2qzzVzFm/VnF7EACMzAL/nSmlb6byXw
        hf3OpxdUhmswz7NysKoX1irmFlLQ9jCSohjerW+k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575920876;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=P1m0j0XGFyovvK7fT8FKAKKgAru998yHIVdxJadEKwE=;
        b=CClNepi/3eSzYrXWmTHBZVd1CzN/U2EOIm19lYFNID7XNiBMPcTNHr5blTD+Paup
        9G52Vf8jyy13jxBCTCKDQAEpa090yKwCG9AP898VLqumsqKcUsbtdbxpVdfY1NYFMP/
        KnyFTePxpVKAXQRXQjVqZcuWnOoi+/LdusMpqvis=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 9 Dec 2019 19:47:56 +0000
From:   pradeepc@codeaurora.org
To:     John Crispin <john@phrozen.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH V2 8/9] ath11k: optimise ath11k_dp_tx_completion_handler
In-Reply-To: <20191204181745.27297-9-john@phrozen.org>
References: <20191204181745.27297-1-john@phrozen.org>
 <20191204181745.27297-9-john@phrozen.org>
Message-ID: <0101016eec3439d6-e9a65da0-17a1-48dd-8962-e5c9ded95375-000000@us-west-2.amazonses.com>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.09-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> @@ -828,10 +827,7 @@ void ath11k_dp_free(struct ath11k_base *ab)
>  			     ath11k_dp_tx_pending_cleanup, ab);
>  		idr_destroy(&dp->tx_ring[i].txbuf_idr);
>  		spin_unlock_bh(&dp->tx_ring[i].tx_idr_lock);
> -
> -		spin_lock_bh(&dp->tx_ring[i].tx_status_lock);
> -		kfifo_free(&dp->tx_ring[i].tx_status_fifo);
> -		spin_unlock_bh(&dp->tx_ring[i].tx_status_lock);
> +		kfree(&dp->tx_ring[i].tx_status);
>  	}
"kfree(&dp->tx_ring[i].tx_status)"  --> 
"kfree(dp->tx_ring[i].tx_status)"
