Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36479 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaIVM7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 08:59:35 -0400
Received: by mail-we0-f171.google.com with SMTP id k48so2867648wev.16
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 05:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com>
References: <509C5E93-4D6C-4CCE-A4F6-BA1CEC80AB98@gmail.com>
Date: Mon, 22 Sep 2014 14:59:33 +0200
Message-ID: <CAA2SeNKdOBTPnkz2y=WUFqa1sSUmxeMwDCHaT50TwL0O0uJfgQ@mail.gmail.com> (sfid-20140922_145938_831820_21BEB92A)
Subject: =?UTF-8?Q?Re=3A_compile_Failed_in_openwrt_for_=5BPATCH=5D_=E2=80=9Cadd_sup?=
	=?UTF-8?Q?port_for_ack_timeout_estimation_in_ath9k_driver_=E2=80=9D?=
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: jammy <benxuelan0402@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi, all，

Hi,

> I have read the http://www.spinics.net/lists/linux-wireless/msg124980.html for patching the ath9k driver in compat-wireless-2014-05-22 in openwrt trunk, but when I patch, for example, “the [PATCH 01/10] ath9k: export methods related to ack timeout estimation”, it failed.
>

please use latest dynack patchset:
http://www.spinics.net/lists/linux-wireless/msg127038.html

> the command window showed that：
>  patching file drivers/net/wireless/ath/ath9k/hw.h
> Hunk #1 FAILED at 1080.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/ath/ath9k/hw.h.rej.
>
> i have checked the hw.h file, but I can not see anything wrong, how should i do further?
>

You should port dynack on compat-wireless-2014-05-22. E.g:

--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1080,6 +1080,10 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah,
struct ath9k_channel *chan);
 void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);

+void ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us);
+void ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us);
+void ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
+
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
 {

this chunk will fail since OpenWRT uses CPTCFG_ATH9K_BTCOEX_SUPPORT
insted of CONFIG_ATH9K_BTCOEX_SUPPORT

> another question is，if I patch them manualy，I can not see the dnyack choice in the menuconfig，what should I do then？
>

You should add dynack to OpenWRT mac80211 package Makefile

> I am waiting for your suggestions.
>
> from jammy's iPhone--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
