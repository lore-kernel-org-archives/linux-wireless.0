Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56265 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753528AbZIOU1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 16:27:08 -0400
Message-ID: <4AAFF89D.1000804@gmx.de>
Date: Tue, 15 Sep 2009 22:27:09 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: handle overflow in tsf_low register during get_tsf
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar9170_op_get_tsf: handle a carry from register TSF_L into TSF_H
by reading TSF_H twice.  We also get rid of the mutex here
and use read_mreg.

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
 drivers/net/wireless/ath/ar9170/cmd.c  |    3 +--
 drivers/net/wireless/ath/ar9170/cmd.h  |    1 +
 drivers/net/wireless/ath/ar9170/main.c |   30 +++++++++++++++++-------------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/cmd.c b/drivers/net/wireless/ath/ar9170/cmd.c
index f57a620..cf6f5c4 100644
--- a/drivers/net/wireless/ath/ar9170/cmd.c
+++ b/drivers/net/wireless/ath/ar9170/cmd.c
@@ -72,8 +72,7 @@ int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val)
 	return err;
 }
 
-static int ar9170_read_mreg(struct ar9170 *ar, int nregs,
-			    const u32 *regs, u32 *out)
+int ar9170_read_mreg(struct ar9170 *ar, int nregs, const u32 *regs, u32 *out)
 {
 	int i, err;
 	__le32 *offs, *res;
diff --git a/drivers/net/wireless/ath/ar9170/cmd.h b/drivers/net/wireless/ath/ar9170/cmd.h
index a4f0e50..826c45e 100644
--- a/drivers/net/wireless/ath/ar9170/cmd.h
+++ b/drivers/net/wireless/ath/ar9170/cmd.h
@@ -44,6 +44,7 @@
 int ar9170_write_mem(struct ar9170 *ar, const __le32 *data, size_t len);
 int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val);
 int ar9170_read_reg(struct ar9170 *ar, u32 reg, u32 *val);
+int ar9170_read_mreg(struct ar9170 *ar, int nregs, const u32 *regs, u32 *out);
 int ar9170_echo_test(struct ar9170 *ar, u32 v);
 
 /*
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c1f8c69..3457cd2 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2190,22 +2190,26 @@ static u64 ar9170_op_get_tsf(struct ieee80211_hw *hw)
 {
 	struct ar9170 *ar = hw->priv;
 	int err;
-	u32 tsf_low;
-	u32 tsf_high;
 	u64 tsf;
+#define NR 3
+	static const u32 addr[NR] = { AR9170_MAC_REG_TSF_H,
+				    AR9170_MAC_REG_TSF_L,
+				    AR9170_MAC_REG_TSF_H };
+	u32 val[NR];
+	int loops = 0;
+
+	while (loops++ < 100) {
+		err = ar9170_read_mreg(ar, NR, addr, val);
+		if (WARN_ON(err))
+			return 0;
+		if (val[0] == val[2])
+			break;
+	}
 
-	mutex_lock(&ar->mutex);
-	err = ar9170_read_reg(ar, AR9170_MAC_REG_TSF_L, &tsf_low);
-	if (!err)
-		err = ar9170_read_reg(ar, AR9170_MAC_REG_TSF_H, &tsf_high);
-	mutex_unlock(&ar->mutex);
-
-	if (WARN_ON(err))
-		return 0;
-
-	tsf = tsf_high;
-	tsf = (tsf << 32) | tsf_low;
+	tsf = val[0];
+	tsf = (tsf << 32) | val[1];
 	return tsf;
+#undef NR
 }
 
 static int ar9170_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-- 
1.6.0.4

