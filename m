Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:32828 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdKTRET (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 12:04:19 -0500
Received: by mail-ot0-f194.google.com with SMTP id s12so8205943otc.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 09:04:19 -0800 (PST)
Subject: Re: [PATCH v1] rtlwifi:rtl8723ae: Fix embedded function names with
 __func__
To: venkat.prashanth2498@gmail.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org
Cc: chaoming_li@realsil.com.cn
References: <1511182437-5870-1-git-send-email-venkat.prashanth2498@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <0a8893ae-b39f-da34-ddda-a0a447717ce2@lwfinger.net> (sfid-20171120_180423_407583_D3BC6C70)
Date: Mon, 20 Nov 2017 11:04:16 -0600
MIME-Version: 1.0
In-Reply-To: <1511182437-5870-1-git-send-email-venkat.prashanth2498@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2017 06:53 AM, venkat.prashanth2498@gmail.com wrote:
> From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
> 
> Prefer and make it generic by using %s and __func__ to print functions name
> instead of embedding functions name in print statements
> 
> Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>

What changed between the first one you sent, and the second that you labeled 
"V1". The reviewers should not have to discover that for themselves.

Certainly adding the function name to the printouts might be useful; however, 
your commit message says "instead of embedding functions name". That is 
obviously not true. None of the changes ever included the function name in the 
message.

There are other comments shown below.

> 
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> index f713c72..bd56bb6 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> @@ -389,7 +389,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
>   
>   	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
>   		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -			 "DMA mapping error\n");
> +			 "%s():DMA Mapping Error", __func__);
>   		return;
>   	}
>   	if (mac->opmode == NL80211_IFTYPE_STATION) {
> @@ -498,7 +498,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
>   		if (ieee80211_is_data_qos(fc)) {
>   			if (mac->rdg_en) {
>   				RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -					 "Enable RDG function.\n");
> +			"%s():Enable RDG function.\n", __func__);

The above line fails to align the continuation statement. Always run 
scripts/checkpatch.pl on all your submissions.

>   				SET_TX_DESC_RDG_ENABLE(pdesc, 1);
>   				SET_TX_DESC_HTC(pdesc, 1);
>   			}
> @@ -537,7 +537,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
>   		SET_TX_DESC_BMC(pdesc, 1);
>   	}
>   
> -	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
> +	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "%s():\n", __func__);

This one is NOT an error condition. Why would the function name be needed here? 
If the user has DBG_TRACE turned on, then the function where a COMP_SEND message 
is emitted will be known. The code is bloated enough already.

>   }
>   
>   void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
> @@ -557,7 +557,7 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
>   
>   	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
>   		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
> -			 "DMA mapping error\n");
> +			 "%s():DMA Mapping Error", __func__);
>   		return;
>   	}
>   	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
> 

The patch needs more work. NACK.

Larry
