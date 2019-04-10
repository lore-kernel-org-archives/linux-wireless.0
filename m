Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA390C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 10:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874FA2075B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 10:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kkVoDF5+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aAb+DzIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfDJKYX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 06:24:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfDJKYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 06:24:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1301060FE9; Wed, 10 Apr 2019 10:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554891862;
        bh=G8bbal+rrptjsE56ul4bmk6zQq3DK+FRq/GNuukRXQw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kkVoDF5+vtjQp2NSizIEPR72xO6NJSQxMjSTzTM5yzYSvBVnQOMAKkqY9yHAei8FH
         6VOAtSnhhEbt9Psj9xZshK1tsH84oJDp7kcxb0VWJQq6MgtR9OnzkM8kJ/NVIXkVW5
         8AlG1kQ3Ipo/H4zTH9voJ+v1RSpC6OQ73INc9wTU=
Received: from [10.204.79.83] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A6BD6044E;
        Wed, 10 Apr 2019 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554891861;
        bh=G8bbal+rrptjsE56ul4bmk6zQq3DK+FRq/GNuukRXQw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aAb+DzIgPXxR4NxNV7+BgkhmP0G86v6/3U1rTUEA+SCWUtjcrUM6EiU+OPlhlgDme
         J7VMHt6YqFR383QqC/cbmcqantvIdu/sjE2l5/2wb5cLH/grQGwkEYaa579pDLUQgd
         Ch/j2kiDmYxukwTmwIEryJOjn6Hc5kVIdvPRmtrI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A6BD6044E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH][V2] brcmfmac: fix leak of mypkt on error return path
To:     Colin King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190409114333.24342-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <abf52609-f92a-9044-ac8d-b69b3bf93ade@codeaurora.org>
Date:   Wed, 10 Apr 2019 15:02:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190409114333.24342-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 4/9/2019 5:13 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently if the call to brcmf_sdiod_set_backplane_window fails then

Fix this one extra then pointed by Sergie.
otherwise looks good to me.

Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> then error return path leaks mypkt. Fix this by returning by a new
> error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
> mypkt.  Also remove redundant check on err before calling
> brcmf_sdiod_skbuff_write.
>
> Addresses-Coverity: ("Resource Leak")
> Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>
> V2: Remove  redundant check on err before calling
> brcmf_sdiod_skbuff_write, kudos to Dan Carpenter and Arend Van Spriel
> for spotting this.
>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index ec129864cc9c..60aede5abb4d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -628,15 +628,13 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
>   
>   	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
>   	if (err)
> -		return err;
> +		goto out;
>   
>   	addr &= SBSDIO_SB_OFT_ADDR_MASK;
>   	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
>   
> -	if (!err)
> -		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
> -					       mypkt);
> -
> +	err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr, mypkt);
> +out:
>   	brcmu_pkt_buf_free_skb(mypkt);
>   
>   	return err;
