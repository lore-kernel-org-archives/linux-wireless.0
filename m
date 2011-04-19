Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51303 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1DSVMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 17:12:05 -0400
Received: by pvg12 with SMTP id 12so49025pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 14:12:05 -0700 (PDT)
Message-ID: <4DADFAA0.7010205@lwfinger.net>
Date: Tue, 19 Apr 2011 16:12:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Carl J. Richell" <carl@system76.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi: rtl8192ce: LED initialization
References: <11019945.17539.1303243029113.JavaMail.root@mail>
In-Reply-To: <11019945.17539.1303243029113.JavaMail.root@mail>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2011 02:57 PM, Carl J. Richell wrote:
> Hi wireless developers,
>
> The patch at the following link fixes the wireless LED on rtl8192ce devices.
>
> http://marc.info/?l=linux-wireless&m=130247823800466&w=2
>
> However, there is the following Error when compiling against 2.6.38 in Ubuntu natty:
>
> "
> drivers/net/wireless/rtlwifi/rtl8192ce/led.c: In function ‘_rtl92ce_init_led’:
> drivers/net/wireless/rtlwifi/rtl8192ce/led.c:40:6: error: ‘struct rtl_led’ has no member named ‘ledon’
> make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192ce/led.o] Error 1
> "
>
> The driver compiles correctly and the LED works after commenting out the offending line:
>
> wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
>
> static void _rtl92ce_init_led(struct ieee80211_hw *hw,
> 			      struct rtl_led *pled, enum rtl_led_pin ledpin)
> {
> 	pled->hw = hw;
> 	pled->ledpin = ledpin;
> /*	pled->ledon = false; */
> }
>
> Is this an appropriate fix?

The patch was made for 2.6.39.

For 2.6.38, the routine _rtl92ce_init_led() does not exist, thus some of the 
other changes in rtl8192ce from .38 to .39 have been put into the driver, but 
not all. Your change should be OK.

Larry

