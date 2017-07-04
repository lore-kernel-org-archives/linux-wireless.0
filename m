Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35182 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdGDQ11 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 12:27:27 -0400
Received: by mail-oi0-f68.google.com with SMTP id l130so23899770oib.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jul 2017 09:27:27 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Remove unused dummy function
To: Souptick Joarder <jrdr.linux@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20170628123233.GA10039@symbol-HP-ZBook-15>
 <CAFqt6zY_1R2TLcRgACgYXToUjuaOjMFL411e4tYgssyJqg4Tqg@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f510b678-f8a5-3361-0bab-551e58ed0a77@lwfinger.net> (sfid-20170704_182732_014649_484334A0)
Date: Tue, 4 Jul 2017 11:27:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAFqt6zY_1R2TLcRgACgYXToUjuaOjMFL411e4tYgssyJqg4Tqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2017 07:22 AM, Souptick Joarder wrote:
> Any Comment for this patch ?

If you keep bugging me about your patches, I will automatically NACK them.

I have more important things to do than reviewing your patches.

FYI, Chaoming Li no longer works on these drivers.

Larry

> 
> On Wed, Jun 28, 2017 at 6:02 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> Removing unused dummy function
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> ---
>>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c  |  2 +-
>>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 12 ------------
>>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h |  3 ---
>>   3 files changed, 1 insertion(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
>> index 96c923b..62d9214 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
>> @@ -173,7 +173,7 @@ static bool rtl92cu_get_btc_status(void)
>>          .rx_urb_num = RTL92C_NUM_RX_URBS,
>>          .rx_max_size = RTL92C_SIZE_MAX_RX_BUFFER,
>>          .usb_rx_hdl = rtl8192cu_rx_hdl,
>> -       .usb_rx_segregate_hdl = NULL, /* rtl8192c_rx_segregate_hdl; */
>> +       .usb_rx_segregate_hdl = NULL,
>>          /* tx */
>>          .usb_tx_cleanup = rtl8192c_tx_cleanup,
>>          .usb_tx_post_hdl = rtl8192c_tx_post_hdl,
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
>> index 41422e4..25a081c 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
>> @@ -436,13 +436,6 @@ void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb)
>>          _rtl_rx_process(hw, skb);
>>   }
>>
>> -void rtl8192c_rx_segregate_hdl(
>> -       struct ieee80211_hw *hw,
>> -       struct sk_buff *skb,
>> -       struct sk_buff_head *skb_list)
>> -{
>> -}
>> -
>>   /*----------------------------------------------------------------------
>>    *
>>    *     Tx handler
>> @@ -675,8 +668,3 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
>>          RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD, "H2C Tx Cmd Content",
>>                        pdesc, RTL_TX_DESC_SIZE);
>>   }
>> -
>> -bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
>> -{
>> -       return true;
>> -}
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
>> index 487eec8..15a66c5 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
>> @@ -385,8 +385,6 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
>>                             struct ieee80211_rx_status *rx_status,
>>                             u8 *p_desc, struct sk_buff *skb);
>>   void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb);
>> -void rtl8192c_rx_segregate_hdl(struct ieee80211_hw *, struct sk_buff *,
>> -                              struct sk_buff_head *);
>>   void rtl8192c_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
>>   int rtl8192c_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
>>                           struct sk_buff *skb);
>> @@ -404,6 +402,5 @@ void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
>>   void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
>>                               u8 *pdesc, bool b_firstseg,
>>                               bool b_lastseg, struct sk_buff *skb);
>> -bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
>>
>>   #endif
>> --
>> 1.9.1
>>
> 
