Return-Path: <SRS0=C9SN=YM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A93DCA9EAB
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 22:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42211222BD
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 22:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfJSWXn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Oct 2019 18:23:43 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:36824 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfJSWXn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Oct 2019 18:23:43 -0400
Received: from [141.134.114.20] ([141.134.114.20])
        by albert.telenet-ops.be with bizsmtp
        id FaPg210020SUBdp06aPgDP; Sun, 20 Oct 2019 00:23:41 +0200
Subject: Re: [PATCH] rtlwifi: rtl_pci: Fix problem of too small skb->len
To:     Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Stable <stable@vger.kernel.org>
References: <20191019190222.29681-1-Larry.Finger@lwfinger.net>
From:   "ian.schram" <ian.schram@telenet.be>
Message-ID: <05f25c80-51a9-bfad-ea4a-3c17b0eecf64@telenet.be>
Date:   Sun, 20 Oct 2019 00:23:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191019190222.29681-1-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,


This patch doesn't appear to do anything? The increased length is not actually
used, is a part of the patch missing?


ps: superficial reading, i am not hampered by any specific knowledge of this driver.

On 2019-10-19 21:02, Larry Finger wrote:
> In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
> only"), buffers whose length is too short cause a WARN_ON(1) to be
> executed. This change exposed a fault in rtlwifi drivers, which is fixed
> by increasing the length of the affected buffer before it is sent to
> mac80211.
> 
> Cc: Stable <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Kalle,
> 
> Please send to v5.4.
> 
> Larry
> ---
> 
>   drivers/net/wireless/realtek/rtlwifi/pci.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
> index 6087ec7a90a6..bb5144b7c64f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -692,7 +692,10 @@ static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
>   		dev_kfree_skb_any(skb);
>   	} else {
>   		struct sk_buff *uskb = NULL;
> +		int len = skb->len;
>   
> +		if (unlikely(len <= FCS_LEN))
> +			len = FCS_LEN + 2;
>   		uskb = dev_alloc_skb(skb->len + 128);
>   		if (likely(uskb)) {
>   			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
> 
