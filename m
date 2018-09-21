Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36697 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbeIUPOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 11:14:30 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] ath5k: Remove unused BUG_ON
Date: Fri, 21 Sep 2018 02:25:48 -0700
Message-Id: <20180921092547.28414-1-natechancellor@gmail.com> (sfid-20180921_112643_559266_23C2BA5E)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clang warns that the address of a pointer will always evaluated as true
in a boolean context:

drivers/net/wireless/ath/ath5k/debug.c:1031:14: warning: address of
array 'ah->sbands' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        BUG_ON(!ah->sbands);
               ~~~~~^~~~~~
./include/asm-generic/bug.h:61:45: note: expanded from macro 'BUG_ON'
#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
                                            ^~~~~~~~~
./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
# define unlikely(x)    __builtin_expect(!!(x), 0)
                                            ^
1 warning generated.

Given that this condition is always false because of the logical not,
just remove it to fix the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/142
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/ath/ath5k/debug.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index e01faf641288..94f70047d3fc 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -1028,8 +1028,6 @@ ath5k_debug_dump_bands(struct ath5k_hw *ah)
 	if (likely(!(ah->debug.level & ATH5K_DEBUG_DUMPBANDS)))
 		return;
 
-	BUG_ON(!ah->sbands);
-
 	for (b = 0; b < NUM_NL80211_BANDS; b++) {
 		struct ieee80211_supported_band *band = &ah->sbands[b];
 		char bname[6];
-- 
2.19.0
