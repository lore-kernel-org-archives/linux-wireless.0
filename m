Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50278 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaIZDS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 23:18:59 -0400
Received: by mail-pd0-f169.google.com with SMTP id p10so88146pdj.14
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 20:18:58 -0700 (PDT)
References: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com> <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8
Message-Id: <A48A8B9D-D2A1-43F0-9B3E-0FE29A5937FC@gmail.com> (sfid-20140926_051912_977200_84645DCF)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: jammy <benxuelan0402@gmail.com>
Subject: =?utf-8?Q?Re:_compile_Failed_in_openwrt_for_[PATCH]_=E2=80=9Cadd?=
 =?utf-8?Q?_support_for_ack_timeout_estimation_in_ath9k_driver_?=
 =?utf-8?Q?=E2=80=9D?=
Date: Fri, 26 Sep 2014 11:13:21 +0800
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have patch the file successful. I have not test it. The further question is：
The wifi card in my two boards are communicated with ad hoc mode，does the patches are useful for that？


from jammy's iPhone

在 2014年9月22日，20:59，Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> 写道：

>> Hi, all，
> 
> Hi,
> 
>> I have read the http://www.spinics.net/lists/linux-wireless/msg124980.html for patching the ath9k driver in compat-wireless-2014-05-22 in openwrt trunk, but when I patch, for example, “the [PATCH 01/10] ath9k: export methods related to ack timeout estimation”, it failed.
> 
> please use latest dynack patchset:
> http://www.spinics.net/lists/linux-wireless/msg127038.html
> 
>> the command window showed that：
>> patching file drivers/net/wireless/ath/ath9k/hw.h
>> Hunk #1 FAILED at 1080.
>> 1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/ath/ath9k/hw.h.rej.
>> 
>> i have checked the hw.h file, but I can not see anything wrong, how should i do further?
> 
> You should port dynack on compat-wireless-2014-05-22. E.g:
> 
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1080,6 +1080,10 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah,
> struct ath9k_channel *chan);
> void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
> void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
> 
> +void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us);
> +void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us);
> +void ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
> +
> #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
> static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
> {
> 
> this chunk will fail since OpenWRT uses CPTCFG_ATH9K_BTCOEX_SUPPORT
> insted of CONFIG_ATH9K_BTCOEX_SUPPORT
> 
>> another question is，if I patch them manualy，I can not see the dnyack choice in the menuconfig，what should I do then？
> 
> You should add dynack to OpenWRT mac80211 package Makefile
> 
>> I am waiting for your suggestions.
>> 
>> from jammy's iPhone--
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Regards,
> Lorenzo
> 
> -- 
> UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
> unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
> umount; make clean; sleep
