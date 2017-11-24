Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:38358 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdKXSal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 13:30:41 -0500
Received: by mail-ot0-f195.google.com with SMTP id b49so19415267otj.5
        for <linux-wireless@vger.kernel.org>; Fri, 24 Nov 2017 10:30:41 -0800 (PST)
Subject: Re: [PATCH v3] rtlwifi:rtl8723ae:add the function name to the
 printouts
To: venkat.prashanth2498@gmail.com, linux-wireless@vger.kernel.org
Cc: chaoming_li@realsil.com.cn
References: <1511523680-5033-1-git-send-email-venkat.prashanth2498@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0eb729bf-80eb-f01c-834b-e95cc83cef91@lwfinger.net> (sfid-20171124_193053_414634_F1A3BABA)
Date: Fri, 24 Nov 2017 12:30:40 -0600
MIME-Version: 1.0
In-Reply-To: <1511523680-5033-1-git-send-email-venkat.prashanth2498@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2017 05:41 AM, venkat.prashanth2498@gmail.com wrote:
> From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> 
> Prefer and make it generic by using %s and __func__
> to print function name
> 
> Change Log:
> 
> v2:
> a. RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
> The function name is not necessary in above code
> according to conditions as mentioned in comments.
> 
> b. modified the commit message according
> to suggested comments.
> 
> c. fixed the alignment issues.
> 
> v1:
> a. Sign-off line is saperated from subject
> line from earlier patch version.
> 
> Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com> > ---

Please read the documentation on submitting a patch. In the present format, the 
change log becomes part of the permanent commit. Generating patches is a lot 
like make sausage. No one wants the details. Place any information you want 
known to the maintainer and reviewers beneath the --- divider, and follow it 
with another divider. Such info is available to interested parties, but will be 
stripped out when the patch is commited.

In addition, your commit message does not accurately describe the change.

I hope you remove GregKH from any wireless patches that are NOT in staging!

NACK

Larry

>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> index f713c72..09c4e14 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> @@ -389,7 +389,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
> 
>   	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
>   		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -			 "DMA mapping error\n");
> +			 "%s():DMA mapping error\n", __func__);
>   		return;
>   	}
>   	if (mac->opmode == NL80211_IFTYPE_STATION) {
> @@ -498,7 +498,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
>   		if (ieee80211_is_data_qos(fc)) {
>   			if (mac->rdg_en) {
>   				RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -				"Enable RDG function.\n");
> +				"%s():Enable RDG function.\n", __func__);
>   				SET_TX_DESC_RDG_ENABLE(pdesc, 1);
>   				SET_TX_DESC_HTC(pdesc, 1);
>   			}
> @@ -557,7 +557,7 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
> 
>   	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
>   		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -			 "DMA mapping error\n");
> +			 "%s():DMA mapping error\n", __func__);
>   		return;
>   	}
>   	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
> --
> 1.9.1
> 
> 
