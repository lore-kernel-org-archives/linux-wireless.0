Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C90935C188;
	Sat, 10 Oct 2026 03:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791603461; cv=none; b=cunMKApEV8xDU6fUMDOViNQVZhgAmleLHpZ0bCeDh94mC7xyjkzyjPoTv63b2eq5URkgWBUDMbBsBF/ZtFDRpmFrVeiVa0k/HBG7KkHOsal2bcubbkWFACDLJalO92UpsRzn4jilL2gb45j6QtovHzDuem8S5hvRxLGRBPvLu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791603461; c=relaxed/simple;
	bh=qLuq52sVyaXL0hZV+8p1iXM+i+inClZIOaaolKSt/uM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GI7tGdkz6QSRFpXD2k6nrkeQHVzxwLRH5C0FbSjReAFy1Ea8x2Orsk80duxGip2OApvPYbq9EdrQh64C9Rh3Lj3OvHrj101K7QBQKHXKn1AQufplw7RQZTE9qCznaWQtjzS5KTTi+rMacykVi1I1MSAe40UjcaIMZZLW7koWAX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mXCrTGPY; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mXCrTGPY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=lO
	/QH7ZRnkZvoesH5huRieOf4VJUe/ytN8DPICc2Gx8=; b=mXCrTGPYUgZSTJMdM+
	jhw4bky8qDanUQ2EJ19eMI1CWD1bh9eaKf5pY2NPWqB//nNk0SE1dBYTW+1hseFM
	DycN2lPq00zIi2KBaWBonsO2qJPkeoLUgJcIs7R3VP1SLqGQnYIij9lUd/A/gEQS
	7VxWuUm7h+9QKi7jySYbJ7foY=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAHxLj5sslqgLLEDQ--.65101S2;
	Sat, 10 Oct 2026 11:37:30 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com,
	linux-kernel@vger.kernel.org,
	Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v3] p54: validate firmware record lengths
Date: Sat, 10 Oct 2026 11:37:24 +0800
Message-ID: <20261010033724.1924-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAHxLj5sslqgLLEDQ--.65101S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr13WFy7tw4Duw4DJFWfAFb_yoW5urW5pF
	Wj9ay3JFWDC3W3X3s5Jrs7AFW5Ja1fJFW7XFy0q3ZxWF13Ar1Fq34YyFWkZwn0krySy3ya
	krWUta17CF4DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UiNV9UUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4Rr3oWrJsvridwAA3T

The p54 firmware parser accesses component ID and component version
records without checking that their lengths cover the fields being read.
A malformed record can therefore make the parser read past the record.

Validate the component ID and component version record lengths before
accessing their data. The descriptor record is also checked against the
shortest descriptor length found in the supported firmware images.

Reject descriptor values that underflow the RX offset or produce an empty
RX range before updating the driver state.

Assisted-by: LLM Codex
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
Changes in v3:
- Simplify the component ID length check to its one-word format.
- Use a local bootrec_comp_ver pointer for version record access.
- Express the 24-byte version minimum as six 32-bit words.

 drivers/net/wireless/intersil/p54/fwio.c | 45 ++++++++++++++++++++----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index a3d9053f043c..b19d054441b8 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -52,6 +52,12 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
+			if (len != 1) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component ID has invalid length\n");
+				return -EINVAL;
+			}
+
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
@@ -71,17 +77,44 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 				return -ENODEV;
 			}
 			break;
-		case BR_CODE_COMPONENT_VERSION:
+		case BR_CODE_COMPONENT_VERSION: {
+			struct bootrec_comp_ver *desc =
+				(struct bootrec_comp_ver *)bootrec->data;
+
+			if (len < 6) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component version is too short\n");
+				return -EINVAL;
+			}
+
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
-				fw_version = (unsigned char *) bootrec->data;
+			if (strnlen(desc->fw_version, sizeof(desc->fw_version)) <
+			    sizeof(desc->fw_version))
+				fw_version = (unsigned char *)desc->fw_version;
 			break;
+		}
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =
 				(struct bootrec_desc *)bootrec->data;
-			priv->rx_start = le32_to_cpu(desc->rx_start);
-			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			u32 rx_start, rx_end;
+
+			/* 0xa is the shortest descriptor in supported firmware. */
+			if (len < 0xa) {
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

