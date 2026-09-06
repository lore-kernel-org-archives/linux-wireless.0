Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA431279903
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701705; cv=none; b=IqNrtjTlr5w4Llya9KgmSfS524GeB+pM0B2W+vBAyzSnxWHyy0eumDrkwsOlSIeP8ooa9mEQ15oM62/XH5tdt7KQtNi81z0wUtaz47yaiNe42hRJlPRoibecVmcmF6IieAMvm7UEEy0wfOTNak7jZ8tJMTiSqyg83G2eAPT8ym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701705; c=relaxed/simple;
	bh=RP7+QZuqwKo7iKb8y6Gdo1jz0U3Pom6m4HZQwMmwvCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bj4jskKtng5oylsJ1wdTIBKcNRaHOBzIpJnnfI77nT0zAdnJbnNs6nLsPMFkxNTaQYVtTQLx2NiVz6KQoybbG2rClEWJVWUfpo87YM7UhHZhpXd0D2cHU5I2Xdion6bOwwoubHd27CD7LMSEH5XlzL+fZ2wkbC8Ti4U7oNwCw/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=GKi7lf1h; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="GKi7lf1h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=6l
	cWjDdIW9Rr2FLGobuIY2NsKXwnZl4vqb5P2sn8Vrw=; b=GKi7lf1hloW4Ij0BMt
	aRuLYYBath17sgb5shScp8Eq6b/wf9li8ykmufyDv66bUQiqtLgSdTnHfeGdKr9s
	Aql33nhp58QH9kybOP0+Tq4fOFCmioIyM/YWMjQ9xyFl0V2uTm22FJ2EMPDP8uKA
	v48ddb81f4dwDN2028oepohGE=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCXpcv3a51q3rYGRQ--.38511S2;
	Sun, 06 Sep 2026 21:34:49 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com
Subject: [PATCH] p54: validate firmware descriptor RX range
Date: Sun,  6 Sep 2026 21:34:44 +0800
Message-ID: <20260906133444.946-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCXpcv3a51q3rYGRQ--.38511S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4kXr47Ary3Zw1UZF45trb_yoW8CFWrpF
	WUCayfKrW7KF47X393JFsxAFy5J3WkJF17WFyxZ3Z0qF13Ar1vqF1YvFWUZw15CrZayrWa
	9r1Utw17Grs0yaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uho7_UUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4RobxGqda-oeTgAA3S

The BR_CODE_DESCR parser reads fields through rx_keycache_size without
checking that the record contains those fields. The record length is
measured in 32-bit words, so the fields accessed by the parser require at
least five words.

It also subtracts the RX offset from rx_end without checking the result.
Reject descriptors that are too short, underflow the offset, or produce an
empty RX range before updating the driver state.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/intersil/p54/fwio.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index a3d9053f0..5d82e0a43 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -79,9 +79,26 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =
 				(struct bootrec_desc *)bootrec->data;
-			priv->rx_start = le32_to_cpu(desc->rx_start);
-			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			u32 rx_start, rx_end;
+
+			if (len < DIV_ROUND_UP(offsetofend(struct bootrec_desc,
+							   rx_keycache_size),
+						       sizeof(*bootrec->data))) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor is too short\n");
+				return -EINVAL;
+			}
+
+			rx_start = le32_to_cpu(desc->rx_start);
+			rx_end = le32_to_cpu(desc->rx_end);
+			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor has invalid RX range\n");
+				return -EINVAL;
+			}
+
+			priv->rx_start = rx_start;
+			priv->rx_end = rx_end - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
 			priv->privacy_caps = desc->privacy_caps;
-- 
2.34.1

