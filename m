Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55590 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0LIOPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:15:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath: fix build break with ATH_DBG_WARN_ON_ONCE
Date: Thu,  9 Dec 2010 09:12:07 -0500
Message-Id: <1291903927-5406-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4D00DDEA.7040907@hauke-m.de>
References: <4D00DDEA.7040907@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Description by Hauke:

"If CONFIG_ATH_DEBUG=y is set ATH_DBG_WARN_ON_ONCE uses WARN_ON_ONCE and
returns something, but if CONFIG_ATH_DEBUG is not set it does not return
anything. Now ATH_DBG_WARN_ON_ONCE is used in the boolean expression in
an if case and is not returning anything and causes a compile error.

  CC [M]  /drivers/net/wireless/ath/ath9k/main.o
/drivers/net/wireless/ath/ath9k/main.c: In function ‘ath_isr’:
/drivers/net/wireless/ath/ath9k/main.c:769: error: expected expression
before ‘do’
make[5]: *** [/drivers/net/wireless/ath/ath9k/main.o] Error 1
make[4]: *** [/drivers/net/wireless/ath/ath9k] Error 2"

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 3eb95e2..45d4d91 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -272,7 +272,7 @@ ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
 	return 0;
 }
 #define ATH_DBG_WARN(foo, arg...) do {} while (0)
-#define ATH_DBG_WARN_ON_ONCE(foo) do {} while (0)
+#define ATH_DBG_WARN_ON_ONCE(foo) ({ 0; })
 
 #endif /* CONFIG_ATH_DEBUG */
 
-- 
1.7.3.2

