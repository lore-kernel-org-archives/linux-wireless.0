Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62950 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760587AbYJJTXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:23:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 12:23:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Fix return code when ath9k_hw_setpower() fails on reset
Date: Fri, 10 Oct 2008 05:22:54 -0700
Message-ID: <1223641374-11872-2-git-send-email-lrodriguez@atheros.com> (sfid-20081010_212313_665507_9D996AC0)
In-Reply-To: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not reporting a status code back ath9k_hw_setpower() failed
during reset so lets correct this.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 372ae61..98bc25c 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -5892,8 +5892,10 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 		goto bad;
 	}
 
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-		return false;
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
+		ecode = -EIO;
+		goto bad;
+	}
 
 	if (curchan)
 		ath9k_hw_getnf(ah, curchan);
-- 
1.5.6.rc2.15.g457bb.dirty

