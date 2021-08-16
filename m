Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8ADC432BE
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Aug 2021 21:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8A2D601FA
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Aug 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhHPV6y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Aug 2021 17:58:54 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:37794 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232067AbhHPV6y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Aug 2021 17:58:54 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id AF76C80F2;
        Mon, 16 Aug 2021 14:58:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com AF76C80F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1629151101;
        bh=QzhewY0v9UHOSCGBphcOgAuIUsQFyQhvTrJxQlixrh4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OcxpE5ZziqCudCQpKxriGk/3GhAJY5+XyWbEbiU9zqu9vVQQGB8L87uKumu4Ca5JC
         LTB0tzQ6kX/IFbyX/1+5FSz4T14g73hIdxzoNfar+eH4ZhEsruzCoHWEkq7oBMPFMo
         CDlWpsPiOoHvmxfL19+6a2XpSWoJZ8DSwufCTzg8=
Received: from [10.230.40.140] (unknown [10.230.40.140])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 2A8E91874BD;
        Mon, 16 Aug 2021 14:58:18 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] btbcm: add patch ram for bluetooth
To:     Angus Ainslie <angus@akkea.ca>, kernel@puri.sm
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-bluetooth@vger.kernel.org
References: <20210812165218.2508258-1-angus@akkea.ca>
 <20210812165218.2508258-3-angus@akkea.ca>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1cd0e008-9239-f430-7294-865d34795a2f@broadcom.com>
Date:   Mon, 16 Aug 2021 23:58:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812165218.2508258-3-angus@akkea.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 8/12/2021 6:52 PM, Angus Ainslie wrote:
> Bluetooth on the BCM43752 needs a patchram file to function correctly.
> 
> Signed-off-by: Angus Ainslie <angus@akkea.ca>
> ---
>   drivers/bluetooth/btbcm.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> index e5d706ed55ea..e4182acee488 100644
> --- a/drivers/bluetooth/btbcm.c
> +++ b/drivers/bluetooth/btbcm.c
> @@ -387,6 +387,7 @@ struct bcm_subver_table {
>   };
>   
>   static const struct bcm_subver_table bcm_uart_subver_table[] = {
> +	{ 0x1111, "BCM4362A2"	},	/* 000.017.017 */

Noticed Marcel applied this one already, but as I asked in earlier patch 
I would like to know why the commit message says 43752 but this entry 
says 4362? Still confused.

Regards,
Arend
