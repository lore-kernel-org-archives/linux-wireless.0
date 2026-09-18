Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1FF374735
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 08:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720451; cv=none; b=GHw4L3QNJOymxeCflc2MM90kIy6gZG6tRs3FT0rVoemQgotY+arNpmawHAVb2CmB4PcwwchRWWWDUrX3Kpzm1z4A09T2ybBkcxFSZEOJJkyG1FkaFmLXXVf97oRSWhbL8wpQTKv0jcKMVCapAKyJDZcSwzzTepBExvNFvl7F5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720451; c=relaxed/simple;
	bh=RCOLIY0RX/6JYCt+hqo19Ifmz7D057vrvzA1BTGwZtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LOhiF0LXdkWHVm+x414ht4UDWqioFJ9tWERI47AvAlmBQu/V9ZUxbcpPgiO6WtAUFP8aBZ+uLOs9nDpp0Qapw5lPW66hrG7NKvxqsCReqys6/h5e5yj7xU0nvSNzSGltHConAIKdRBgAAvNUuVmKB27FIuSVksuVps4iBtAdAwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Jfe7NSXQ; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Jfe7NSXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=aD
	27I3Cs6MN0Ui9OPNMNpHd6VvHGpDuP+nwWqZxC2Yo=; b=Jfe7NSXQUkCDlPIzO9
	cEGHO0+MKOOGfrDj9aAwo0tJZQ4dVAsmq+iaLmbpd77G7MKYj/Au+ylKF9rttXfj
	5BkWwz+8bR9I9EzQOKYZE6BOyFWarjQ30WuzF5oWRDukeDJYch18day32wa7AsP5
	GxcOs7pbL94bESsD8LkX1aUqo=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD35SFv96xqkZHxBA--.148S2;
	Fri, 18 Sep 2026 16:33:55 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org
Cc: chunkeey@gmail.com
Subject: [PATCH v2] p54: validate firmware record lengths
Date: Fri, 18 Sep 2026 16:33:49 +0800
Message-ID: <20260918083349.891-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD35SFv96xqkZHxBA--.148S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr13WFy7tw4DuF4DCr4UJwb_yoW5CryDpF
	WYkay3JFWqka13X3s5Jrs7Aw45Ja1ftFW7XFyIvasxXF13Ar1rX34FyFWkZrn0krySyryf
	C3yUta47uFsIyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UWHqxUUUUU=
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC-hPfiWqs93PQaAAA3B

The p54 firmware parser accesses component ID and component version
records without checking that their lengths cover the fields being read.
A malformed record can therefore make the parser read past the record.

Validate the component ID and component version record lengths before
accessing their data. The descriptor record is also checked against the
shortest descriptor length found in the supported firmware images.

Reject descriptor values that underflow the RX offset or produce an empty
RX range before updating the driver state.

Assisted-by: LLM Codex
Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/intersil/p54/fwio.c | 42 +++++++++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index a3d9053f043c..f028a7bfa734 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -52,6 +52,13 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
+			if (len < sizeof(struct bootrec_comp_id) /
+				sizeof(*bootrec->data)) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component ID is too short\n");
+				return -EINVAL;
+			}
+
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
@@ -72,16 +79,41 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			if (len < DIV_ROUND_UP(sizeof(struct bootrec_comp_ver),
+					       sizeof(*bootrec->data))) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component version is too short\n");
+				return -EINVAL;
+			}
+
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
-				fw_version = (unsigned char *) bootrec->data;
+			if (strnlen((unsigned char *)bootrec->data,
+				    sizeof(struct bootrec_comp_ver)) <
+				    sizeof(struct bootrec_comp_ver))
+				fw_version = (unsigned char *)bootrec->data;
 			break;
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

