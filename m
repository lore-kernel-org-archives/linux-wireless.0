Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.system76.com ([173.14.1.49]:41112 "EHLO mail.system76.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1DSUDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 16:03:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.system76.com (Postfix) with ESMTP id 5B518B24002
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 13:57:10 -0600 (MDT)
Received: from mail.system76.com ([127.0.0.1])
	by localhost (mail.system76.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ck-yr8xwL7nr for <linux-wireless@vger.kernel.org>;
	Tue, 19 Apr 2011 13:57:09 -0600 (MDT)
Received: from mail.system76.com (localhost [127.0.0.1])
	by mail.system76.com (Postfix) with ESMTP id 3F047B24001
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 13:57:09 -0600 (MDT)
Date: Tue, 19 Apr 2011 13:57:09 -0600 (MDT)
From: "Carl J. Richell" <carl@system76.com>
To: linux-wireless@vger.kernel.org
Message-ID: <11019945.17539.1303243029113.JavaMail.root@mail>
In-Reply-To: <30703261.17529.1303241985428.JavaMail.root@mail>
Subject: rtlwifi: rtl8192ce: LED initialization
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi wireless developers,

The patch at the following link fixes the wireless LED on rtl8192ce devices.

http://marc.info/?l=linux-wireless&m=130247823800466&w=2

However, there is the following Error when compiling against 2.6.38 in Ubuntu natty:

"
drivers/net/wireless/rtlwifi/rtl8192ce/led.c: In function ‘_rtl92ce_init_led’:
drivers/net/wireless/rtlwifi/rtl8192ce/led.c:40:6: error: ‘struct rtl_led’ has no member named ‘ledon’
make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192ce/led.o] Error 1
"

The driver compiles correctly and the LED works after commenting out the offending line:

wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
 
static void _rtl92ce_init_led(struct ieee80211_hw *hw,
			      struct rtl_led *pled, enum rtl_led_pin ledpin)
{
	pled->hw = hw;
	pled->ledpin = ledpin;
/*	pled->ledon = false; */
}

Is this an appropriate fix?

Best Regards,


Carl Richell
