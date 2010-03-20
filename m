Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49586 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab0CTB2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 21:28:46 -0400
Received: by wyb38 with SMTP id 38so1776353wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 18:28:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 20 Mar 2010 02:28:44 +0100
Message-ID: <2d0a357f1003191828g2d133a06qd8902785ae015cd0@mail.gmail.com>
Subject: [ath9k_htc] Wrong kernel config parameters in wiki?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

a person asked on IRC about ath9k_htc support.

First question:
Has the patch from [1] already entered one of the wireless-* GIT repositories?

I could apply the ath9k_htc patch against 2.6.34-rc1-git9.

The kernel config parameters in wiki [2] seems to be wrong to me:

CONFIG_ATH=m
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_HTC=m

Checking here:

$ grep CONFIG_ATH .config
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set

Should CONFIG_ATH=m be replaced by one/both of these ones?

$ grep CONFIG_ATH .config | grep COMMON
CONFIG_ATH_COMMON=m
CONFIG_ATH9K_COMMON=m

File drivers/net/wireless/ath/ath9k/Kconfig says:
...
config ATH9K_HTC
       tristate "Atheros HTC based wireless cards support"
       depends on USB && MAC80211
       select ATH9K_HW
       select MAC80211_LEDS
       select LEDS_CLASS
       select NEW_LEDS
       ---help---
	 Support for Atheros HTC based cards.
	 Chipsets supported: AR9271

	 For more information: http://wireless.kernel.org/en/users/Drivers/ath9k_htc

	 The built module will be ath9k_htc.
...

Maybe the confusion results from drivers/net/wireless/ath/Kconfig:

menuconfig ATH_COMMON
	tristate "Atheros Wireless Cards"
...

IMHO setting CONFIG_ATH9K_HW=m and CONFIG_ATH9K_HTC=m should be enough.

Who can clarify?

Thanks in advance.

Kind Regards,
- Sedat -

References:
------------------
[1] https://patchwork.kernel.org/patch/82299/
[2] http://wireless.kernel.org/en/users/Drivers/ath9k_htc#Configuring_your_kernel
[3] http://wireless.kernel.org/en/users/Drivers/ath9k_htc
