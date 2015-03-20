Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:35472 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbCTR4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 13:56:38 -0400
Received: by webcq43 with SMTP id cq43so88026592web.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 10:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550C55F9.20600@lwfinger.net>
References: <1426847493-5722-1-git-send-email-ap420073@gmail.com>
	<550C55F9.20600@lwfinger.net>
Date: Sat, 21 Mar 2015 02:56:37 +0900
Message-ID: <CAMArcTVgL8EFA-HTM1+kvaex3Gx56_yov+Rat0ap6Fg6OtH=AA@mail.gmail.com> (sfid-20150320_185641_827889_0C3E0980)
Subject: Re: [PATCH] rtlwifi: Change REG_CR+2 to MSR
From: "ap420073 ." <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-03-21 2:16 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/20/2015 05:31 AM, Taehee Yoo wrote:
>>
>> I changed REG_CR+2 and (MSR) to MSR because MSR is defined as (REG_CR +
>> 2).
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  | 4 ++--
>>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8192ee/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8723be/hw.c  | 2 +-
>>   drivers/net/wireless/rtlwifi/rtl8821ae/hw.c  | 4 ++--
>>   9 files changed, 11 insertions(+), 11 deletions(-)
>
>
> I'm not sure this change contributes much to the readability of the code. It
> certainly does not change the object code; however,
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Larry
>
>
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
>> index edc2cbb..ecd383f 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
>> @@ -885,7 +885,7 @@ static bool _rtl88ee_init_mac(struct ieee80211_hw *hw)
>>
>>         rtl_write_word(rtlpriv, REG_CR, 0x2ff);
>>         rtl_write_byte(rtlpriv, REG_CR+1, 0x06);
>> -       rtl_write_byte(rtlpriv, REG_CR+2, 0x00);
>> +       rtl_write_byte(rtlpriv, MSR, 0x00);
>>
>>         if (!rtlhal->mac_func_enable) {
>>                 if (_rtl88ee_llt_table_init(hw) == false) {
>> @@ -1277,7 +1277,7 @@ static int _rtl88ee_set_media_status(struct
>> ieee80211_hw *hw,
>>                          mode);
>>         }
>>
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr | mode);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if (mode == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> index 43b2b20..d310d55 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> @@ -1364,7 +1364,7 @@ static int _rtl92cu_set_media_status(struct
>> ieee80211_hw *hw,
>>                          "Network type %d not supported!\n", type);
>>                 goto error_out;
>>         }
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if ((bt_msr & MSR_MASK) == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
>> b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
>> index 133e395..adb8107 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
>> @@ -497,7 +497,7 @@ int rtl92c_set_network_type(struct ieee80211_hw *hw,
>> enum nl80211_iftype type)
>>                          "Network type %d not supported!\n", type);
>>                 return -EOPNOTSUPP;
>>         }
>> -       rtl_write_byte(rtlpriv, (REG_CR + 2), value);
>> +       rtl_write_byte(rtlpriv, MSR, value);
>>         return 0;
>>   }
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
>> index 01bcc2d..f49b60d 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
>> @@ -1126,7 +1126,7 @@ static int _rtl92de_set_media_status(struct
>> ieee80211_hw *hw,
>>                 break;
>>
>>         }
>> -       rtl_write_byte(rtlpriv, REG_CR + 2, bt_msr);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if ((bt_msr & MSR_MASK) == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
>> index db230a3..da0a612 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
>> @@ -1510,7 +1510,7 @@ static int _rtl92ee_set_media_status(struct
>> ieee80211_hw *hw,
>>                          mode);
>>         }
>>
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr | mode);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if (mode == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
>> index dee88a8..12b0978 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
>> @@ -1204,7 +1204,7 @@ static int _rtl92se_set_media_status(struct
>> ieee80211_hw *hw,
>>         if (type != NL80211_IFTYPE_AP &&
>>             rtlpriv->mac80211.link_state < MAC80211_LINKED)
>>                 bt_msr = rtl_read_byte(rtlpriv, MSR) & ~MSR_LINK_MASK;
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr);
>>
>>         temp = rtl_read_dword(rtlpriv, TCR);
>>         rtl_write_dword(rtlpriv, TCR, temp & (~BIT(8)));
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
>> index b3b0947..67bb47d 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
>> @@ -1183,7 +1183,7 @@ static int _rtl8723e_set_media_status(struct
>> ieee80211_hw *hw,
>>                          mode);
>>         }
>>
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr | mode);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if (mode == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> index b469983..b681af3 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> @@ -1558,7 +1558,7 @@ static int _rtl8723be_set_media_status(struct
>> ieee80211_hw *hw,
>>                          mode);
>>         }
>>
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr | mode);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if (mode == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
>> index 2a0a71b..8704eee 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
>> @@ -423,7 +423,7 @@ void rtl8821ae_get_hw_reg(struct ieee80211_hw *hw, u8
>> variable, u8 *val)
>>                 *((u16 *)(val+4)) = rtl_read_word(rtlpriv, REG_BSSID+4);
>>                 break;
>>         case HW_VAR_MEDIA_STATUS:
>> -               val[0] = rtl_read_byte(rtlpriv, REG_CR+2) & 0x3;
>> +               val[0] = rtl_read_byte(rtlpriv, MSR) & 0x3;
>>                 break;
>>         case HW_VAR_SLOT_TIME:
>>                 *((u8 *)(val)) = mac->slot_time;
>> @@ -2178,7 +2178,7 @@ static int _rtl8821ae_set_media_status(struct
>> ieee80211_hw *hw,
>>                 return 1;
>>         }
>>
>> -       rtl_write_byte(rtlpriv, (MSR), bt_msr);
>> +       rtl_write_byte(rtlpriv, MSR, bt_msr);
>>         rtlpriv->cfg->ops->led_control(hw, ledaction);
>>         if ((bt_msr & 0xfc) == MSR_AP)
>>                 rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>>
>

okay, thanks a lot for your review.
