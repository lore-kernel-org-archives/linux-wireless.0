Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3J1M6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 08:58:18 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: fix null dereference on efuse_word on kmalloc fail  returns NULL
Date: Mon, 28 Oct 2013 12:58:12 +0000
Message-Id: <1382965092-12556-1-git-send-email-colin.king@canonical.com> (sfid-20131028_135822_173197_35F7A773)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

kmalloc on efuse_word can return null, leading to free'ing of
elements in efuse_word on the error exit path even though it has not
been allocated.  Instead, don't free the elements of efuse_word if
kmalloc failed.

Also, kmalloc of any of the arrays in efuse_word[] can also fail,
leading to undefined contents in the remaining elements leading to
problems when free'ing these elements later on.  So kzalloc efuse_word
to ensure the kfree on the remaining elements won't cause breakage.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rtlwifi/efuse.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 838a1ed..66f0b2d 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -262,9 +262,9 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 			    sizeof(u8), GFP_ATOMIC);
 	if (!efuse_tbl)
 		return;
-	efuse_word = kmalloc(EFUSE_MAX_WORD_UNIT * sizeof(u16 *), GFP_ATOMIC);
+	efuse_word = kzalloc(EFUSE_MAX_WORD_UNIT * sizeof(u16 *), GFP_ATOMIC);
 	if (!efuse_word)
-		goto done;
+		goto out;
 	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
 		efuse_word[i] = kmalloc(efuse_max_section * sizeof(u16),
 					GFP_ATOMIC);
@@ -378,6 +378,7 @@ done:
 	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++)
 		kfree(efuse_word[i]);
 	kfree(efuse_word);
+out:
 	kfree(efuse_tbl);
 }
 
-- 
1.8.3.2

