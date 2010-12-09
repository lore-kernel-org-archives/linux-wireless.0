Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56900 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab0LINr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 08:47:28 -0500
Message-ID: <4D00DDEA.7040907@hauke-m.de>
Date: Thu, 09 Dec 2010 14:47:22 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compile problem in ath9k with ATH_DBG_WARN_ON_ONCE
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got an compile problem in drivers/net/wireless/ath/ath9k/main.c

This is caused by commit ff9f0b639f33c92a89b0799263ab625444be6ee1
	ath9k: skip ATH9K_INT_TIM_TIMER when we are idle
and d7fd1b50a51be3fe6554fbab8953fa8a3ff4009b
	ath9k: Make DMA warning in ath_stoprecv WARN_ON_ONCE.

If CONFIG_ATH_DEBUG=y is set ATH_DBG_WARN_ON_ONCE uses WARN_ON_ONCE and
returns something, but if CONFIG_ATH_DEBUG is not set it does not return
anything. Now ATH_DBG_WARN_ON_ONCE is used in the boolean expression in
an if case and is not returning anything and causes a compile error.

  CC [M]  /drivers/net/wireless/ath/ath9k/main.o
/drivers/net/wireless/ath/ath9k/main.c: In function ‘ath_isr’:
/drivers/net/wireless/ath/ath9k/main.c:769: error: expected expression
before ‘do’
make[5]: *** [/drivers/net/wireless/ath/ath9k/main.o] Error 1
make[4]: *** [/drivers/net/wireless/ath/ath9k] Error 2

Hauke
