Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62418 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbAOROx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 12:14:53 -0500
Message-ID: <54B7F58B.7010604@lwfinger.net> (sfid-20150115_181457_824975_2C7E9407)
Date: Thu, 15 Jan 2015 11:14:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?6LCt5p2t5rOi?= <troy_tan@realsil.com.cn>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH for 3.19 2/3] rtlwifi: Fix handling of new style descriptors
References: <1421257036-5382-1-git-send-email-Larry.Finger@lwfinger.net>	<1421257036-5382-3-git-send-email-Larry.Finger@lwfinger.net>	<877fwoxo7g.fsf@kamboji.qca.qualcomm.com>	<C11178B3EB8EC446A461ADCC3E27182146C9A9F8@rsex2.realsil.com.cn> <87y4p4w8wb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4p4w8wb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2015 06:00 AM, Kalle Valo wrote:
> Hi Troy,
>
> please avoid top-posting.
>
> 谭杭波 <troy_tan@realsil.com.cn> writes:
>
>> You can find get_available_desc here:
>>
>> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/
>> pci.c
>> index e25faac..a62170e 100644
>> --- a/drivers/net/wireless/rtlwifi/pci.c
>> +++ b/drivers/net/wireless/rtlwifi/pci.c
>> @@ -578,6 +578,13 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int
>> prio)
>>                  else
>>                          entry = (u8 *)(&ring->desc[ring->idx]);
>>
>> +               if (rtlpriv->cfg->ops->get_available_desc &&
>> +                   rtlpriv->cfg->ops->get_available_desc(hw, prio) <= 1) {
>> +                       RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_DMESG,
>> +                                "no available desc!\n");
>> +                       return;
>> +               }
>
> I don't see rtlpriv->cfg->ops->get_available_desc set here, only being
> called?

Only one of the drivers (rtl8192ee) needs to implement that routine, which is 
the reason it is checked for non-NULL before it is called. The implementation is 
in patch 3 in file rtl8192ee/sw.c where it says:

@@ -241,6 +239,7 @@ static struct rtl_hal_ops rtl8192ee_hal_ops = {
  	.set_desc = rtl92ee_set_desc,
  	.get_desc = rtl92ee_get_desc,
  	.is_tx_desc_closed = rtl92ee_is_tx_desc_closed,
+	.get_available_desc = rtl92ee_get_available_desc,
  	.tx_polling = rtl92ee_tx_polling,
  	.enable_hw_sec = rtl92ee_enable_hw_security_config,
  	.init_sw_leds = rtl92ee_init_sw_leds,

Larry



