Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40482 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344Ab2AMPfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 10:35:12 -0500
Received: by eekd4 with SMTP id d4so1101237eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2012 07:35:10 -0800 (PST)
Subject: [RESEND][PATCH] carl9170: remove eeprom data injection option
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 13 Jan 2012 16:35:05 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201201131635.06398.chunkeey@googlemail.com> (sfid-20120113_163520_572369_E893863E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the early days, this was a quite useful software
feature for testing different regdomains and chain
configurations without adding debugfs cruft into
the driver. Nowadays, the driver's phy code seems
to be stable and there's no need for it anymore.
Therefore I decided to removed altogether.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 -
 drivers/net/wireless/ath/carl9170/fw.c       |   33 --------------------------
 drivers/net/wireless/ath/carl9170/main.c     |    4 ---
 3 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 6cfbb41..f0f44c3 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -593,7 +593,6 @@ int carl9170_get_noisefloor(struct ar9170 *ar);
 
 /* FW */
 int carl9170_parse_firmware(struct ar9170 *ar);
-int carl9170_fw_fix_eeprom(struct ar9170 *ar);
 
 extern struct ieee80211_rate __carl9170_ratetable[];
 extern int modparam_noht;
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 3de61ad..cffde8d 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -389,39 +389,6 @@ carl9170_find_fw_desc(struct ar9170 *ar, const __u8 *fw_data, const size_t len)
 	return (void *)&fw_data[scan - found];
 }
 
-int carl9170_fw_fix_eeprom(struct ar9170 *ar)
-{
-	const struct carl9170fw_fix_desc *fix_desc = NULL;
-	unsigned int i, n, off;
-	u32 *data = (void *)&ar->eeprom;
-
-	fix_desc = carl9170_fw_find_desc(ar, FIX_MAGIC,
-		sizeof(*fix_desc), CARL9170FW_FIX_DESC_CUR_VER);
-
-	if (!fix_desc)
-		return 0;
-
-	n = (le16_to_cpu(fix_desc->head.length) - sizeof(*fix_desc)) /
-	    sizeof(struct carl9170fw_fix_entry);
-
-	for (i = 0; i < n; i++) {
-		off = le32_to_cpu(fix_desc->data[i].address) -
-		      AR9170_EEPROM_START;
-
-		if (off >= sizeof(struct ar9170_eeprom) || (off & 3)) {
-			dev_err(&ar->udev->dev, "Skip invalid entry %d\n", i);
-			continue;
-		}
-
-		data[off / sizeof(*data)] &=
-			le32_to_cpu(fix_desc->data[i].mask);
-		data[off / sizeof(*data)] |=
-			le32_to_cpu(fix_desc->data[i].value);
-	}
-
-	return 0;
-}
-
 int carl9170_parse_firmware(struct ar9170 *ar)
 {
 	const struct carl9170fw_desc_head *fw_desc = NULL;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f06e069..cbc833c 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1931,10 +1931,6 @@ int carl9170_register(struct ar9170 *ar)
 	if (err)
 		return err;
 
-	err = carl9170_fw_fix_eeprom(ar);
-	if (err)
-		return err;
-
 	err = carl9170_parse_eeprom(ar);
 	if (err)
 		return err;
-- 
1.7.8.2

