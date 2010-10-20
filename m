Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26112 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0JTOAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 10:00:07 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 06:59:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath: make ath_hw_set_keycache_entry() static
Date: Wed, 20 Oct 2010 06:59:37 -0700
Message-ID: <1287583178-2963-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287583178-2963-1-git-send-email-lrodriguez@atheros.com>
References: <1287583178-2963-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this sparse warning:

  CHECK   drivers/net/wireless/ath/key.c
drivers/net/wireless/ath/key.c:110:6: warning: symbol
'ath_hw_set_keycache_entry' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/key.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 1e9aa32..62e3dac 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -108,9 +108,9 @@ static bool ath_hw_keysetmac(struct ath_common *common,
 	return true;
 }
 
-bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
-				 const struct ath_keyval *k,
-				 const u8 *mac)
+static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
+				      const struct ath_keyval *k,
+				      const u8 *mac)
 {
 	void *ah = common->ah;
 	u32 key0, key1, key2, key3, key4;
-- 
1.7.0.4

