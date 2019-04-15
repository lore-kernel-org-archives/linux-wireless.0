Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A051C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A33E20652
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TIzGpWiL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="irVo9uPQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfDORYM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:24:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfDORYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 13:24:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 449D861706; Mon, 15 Apr 2019 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555349051;
        bh=oh7YWw1cYnAchV930hWRnFutUkJA00RQBzsADpVRLvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TIzGpWiLtBuxGi7LGfiYzkhsAw/MjaUglAg5TDsr/CDqFBew6lat6VANzRTe1KrGK
         H6mii8Hp8asHqKvelCYFucpw/arA5SI4yvn+fRGJXHD1b5AX1OAZ18TjBgkSqTjoKb
         Jhm0V2Eh8rjBzT/tp3VMPfmjndRyejgQQEQ1K2Ko=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id A24DF616FE;
        Mon, 15 Apr 2019 17:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555349050;
        bh=oh7YWw1cYnAchV930hWRnFutUkJA00RQBzsADpVRLvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=irVo9uPQni+1kJnUeekm08IGN9qTvUANE/g54rOIWOKnnoUi2u8q1KnQgH/Hw/l5I
         7w0FePr6lVlI29lLTQDHNx78rlQxJNGaEyCB1m9X/p4kf9vawtvdUvEQ4EnK2CJ5ND
         LzDiugJHlPehGrXs8U327TPr2Kq6848OacgWe0wY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Apr 2019 20:24:10 +0300
From:   merez@codeaurora.org
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wil6210: fix potential out-of-bounds read
In-Reply-To: <20190415145646.GA16597@embeddedor>
References: <20190415145646.GA16597@embeddedor>
Message-ID: <514f4e102c3cbbd59f4ba0805b091b36@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-15 17:56, Gustavo A. R. Silva wrote:
> Notice that *rc* can evaluate to up to 5, include/linux/netdevice.h:
> 
> enum gro_result {
>         GRO_MERGED,
>         GRO_MERGED_FREE,
>         GRO_HELD,
>         GRO_NORMAL,
>         GRO_DROP,
>         GRO_CONSUMED,
> };
> typedef enum gro_result gro_result_t;
> 
> In case *rc* evaluates to 5, we end up having an out-of-bounds read
> at drivers/net/wireless/ath/wil6210/txrx.c:821:
> 
> 	wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
> 		     len, gro_res_str[rc]);
> 
> Fix this by adding element "GRO_CONSUMED" to array gro_res_str.
> 
> Addresses-Coverity-ID: 1444666 ("Out-of-bounds read")
> Fixes: 194b482b5055 ("wil6210: Debug print GRO Rx result")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/ath/wil6210/txrx.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
