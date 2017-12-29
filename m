Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52785 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755286AbdL2Ibj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/11] rtlwifi: use kcalloc instead of multiply
Date: Fri, 29 Dec 2017 16:31:05 +0800
Message-ID: <20171229083112.31540-5-pkshih@realtek.com> (sfid-20171229_093323_205511_2CBE6A91)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Tobin C. Harding" <me@tobin.cc>

This is merged by Ping-Ke Shih from commit 85d309d53f7a ("staging:
rtlwifi: use kcalloc instead of multiply"), and original commit log
is reserved below.

checkpatch emits multiple warnings of type

WARNING:ALLOC_WITH_MULTIPLY: Prefer kcalloc over kzalloc with multiply

Replace two calls to kzalloc() with calls to kcalloc().

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index ef9acd466cca..35b50be633f1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -257,11 +257,11 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 			    sizeof(u8), GFP_ATOMIC);
 	if (!efuse_tbl)
 		return;
-	efuse_word = kzalloc(EFUSE_MAX_WORD_UNIT * sizeof(u16 *), GFP_ATOMIC);
+	efuse_word = kcalloc(EFUSE_MAX_WORD_UNIT, sizeof(u16 *), GFP_ATOMIC);
 	if (!efuse_word)
 		goto out;
 	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
-		efuse_word[i] = kzalloc(efuse_max_section * sizeof(u16),
+		efuse_word[i] = kcalloc(efuse_max_section, sizeof(u16),
 					GFP_ATOMIC);
 		if (!efuse_word[i])
 			goto done;
-- 
2.14.1
