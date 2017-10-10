Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37928 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756688AbdJJTzK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 15:55:10 -0400
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
To: Jes Sorensen <jes.sorensen@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20171010193027.GA23108@embeddedor.com>
 <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <94264677-cf71-86d5-5220-413cfbac8e90@gmail.com> (sfid-20171010_230350_442592_B72A5534)
Date: Tue, 10 Oct 2017 12:55:02 -0700
MIME-Version: 1.0
In-Reply-To: <5f5f0f54-d901-90be-9025-0a1c4b909368@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2017 12:35 PM, Jes Sorensen wrote:
> On 10/10/2017 03:30 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
> 
> While this isn't harmful, to me this looks like pointless patch churn
> for zero gain and it's just ugly.

That is the canonical way to tell static analyzers and compilers that
fall throughs are wanted and not accidental mistakes in the code. For
people that deal with these kinds of errors, it's quite helpful, unless
you suggest disabling that particular GCC warning specific for that
file/directory?

> 
> Jes
> 
> 
>> Cc: Jes Sorensen <Jes.Sorensen@gmail.com>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> index 7806a4d..e66be05 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> @@ -1153,6 +1153,7 @@ void rtl8xxxu_gen1_config_channel(struct
>> ieee80211_hw *hw)
>>       switch (hw->conf.chandef.width) {
>>       case NL80211_CHAN_WIDTH_20_NOHT:
>>           ht = false;
>> +        /* fall through */
>>       case NL80211_CHAN_WIDTH_20:
>>           opmode |= BW_OPMODE_20MHZ;
>>           rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
>> @@ -1280,6 +1281,7 @@ void rtl8xxxu_gen2_config_channel(struct
>> ieee80211_hw *hw)
>>       switch (hw->conf.chandef.width) {
>>       case NL80211_CHAN_WIDTH_20_NOHT:
>>           ht = false;
>> +        /* fall through */
>>       case NL80211_CHAN_WIDTH_20:
>>           rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
>>           subchannel = 0;
>> @@ -1748,9 +1750,11 @@ static int rtl8xxxu_identify_chip(struct
>> rtl8xxxu_priv *priv)
>>           case 3:
>>               priv->ep_tx_low_queue = 1;
>>               priv->ep_tx_count++;
>> +            /* fall through */
>>           case 2:
>>               priv->ep_tx_normal_queue = 1;
>>               priv->ep_tx_count++;
>> +            /* fall through */
>>           case 1:
>>               priv->ep_tx_high_queue = 1;
>>               priv->ep_tx_count++;
>> @@ -5691,6 +5695,7 @@ static int rtl8xxxu_set_key(struct ieee80211_hw
>> *hw, enum set_key_cmd cmd,
>>           break;
>>       case WLAN_CIPHER_SUITE_TKIP:
>>           key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
>> +        /* fall through */
>>       default:
>>           return -EOPNOTSUPP;
>>       }
>>
> 


-- 
Florian
