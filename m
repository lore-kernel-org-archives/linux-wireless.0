Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149EA30FC26
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147721; cv=none; b=LVze9WctVa6vM32uYcvkx3n0H10NVtAQPD2XTMRMmo/kP168W/E6xdWjAcqrtgh0iHg3SZBEPyb0at2CUJl6x8igzvZzsZtfLQ4aH6FW7ncnQH0jGG9tkY7m0AB/wHxLoW5AJYGL7XEJaZsGbdSfklABT7G028lvAe0Tornafs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147721; c=relaxed/simple;
	bh=H25qvH+dptQjXpA2wsMVDKYLkOUAGnT+p8ujMj585CI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjkyjYQ+GvWR7laTO5IK609dOpjxLz2iADpHTjAqF9NQkbSE0WaaGcPtwlFzvF4TdWqxCsj3kWUlFfNuOxZxV+wXZYmi1JzXssZb1hWwC9avpwZdH59Kj1b7p7z/mfZ+01cc/SA4gL2rpaqFu/qV/eXGJje62lSz61GWdnsgfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BFjzTPtk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BFjzTPtk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7FGZn8132921, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147716; bh=jRkHjbuvuQUj7apuGAdqPE7Pd9H2ElK278LGbok74LQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=BFjzTPtkrFWAvCPaUghTUtBNW/T7HTikosMgl8aL6dYoDrcWG2IJCbIEK0ybPCPWE
	 c0kc7FCXQ6KWGgHjeO3dOsBAtHh187yfOjbN54h0EGMprUqKrmS+44Bbp0UKTO4OnM
	 3172kMsS+dp62L6ODri5jTsFgwqTans09Bt4Qm7C5InGXEBXqaPZzeD826rBGvPUBZ
	 eVbUUavLIooEE3Re/owk3/bJjlbRTYYQtcCnN8IlMFIavkNiEr23tHmc09h67VKQmh
	 FwwgcsHwCzvRBDZ3yNQlTiayW5sARSAa0kdtq5Qbba3u33tgvUxkCsnmNej85ZZEzk
	 phH9ARIaLcsUQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7FGZn8132921
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:15:16 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:15:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:15:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:15:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 7/7] wifi: rtw89: coex: batch PTA init with masked IO offload
Date: Wed, 23 Sep 2026 15:13:54 +0800
Message-ID: <20260923071354.50864-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923071354.50864-1-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

On USB, the register writes in coex init cannot be fully batched
into a single H2C because the write32 IO offload only carries
MASKDWORD, i.e. a full-dword overwrite. Read-modify-write helpers
derive the new value from a driver-side read that cannot observe
other writes still queued in the same pack region, so packing a
same-register sequence would drop bits. mac_coex_init_v1() and
btc_set_wl_pri() were thus left outside the pack region and issued
as separate H2C commands, costing hundreds of ms.

Add write8_mask/write16_mask/write32_mask to the IO ops. For the raw
IO path, these ops are implemented as direct read-modify-write on the
hardware. For the firmware offload path, they forward the field mask
to the FW so it can perform the read-modify-write server-side,
removing the dependency on a driver-side read of a register whose
new value may still be queued.

Extract the raw read-modify-write bodies of write8_set, write16_set,
write32_set, write8_clr, write16_clr, write32_clr, write8_mask,
write16_mask, and write32_mask into rtw89_raw_write*() helpers,
grouping raw_* variants before the io-dispatching thin wrappers.
Replace the original functions with thin wrappers that dispatch
through rtwdev->io, removing the inline capability checks. With that
in place, extend the 8852c PTA init pack region to cover
mac_coex_init_v1() and btc_set_wl_pri().

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     | 118 ++++++++++++++----
 drivers/net/wireless/realtek/rtw89/fw.c       | 112 +++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       |   8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |   4 +-
 4 files changed, 213 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 128667fb95b0..762d0db8b721 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -7591,6 +7591,18 @@ struct rtw89_io_ops {
 	void (*phy_write32)(struct rtw89_dev *rtwdev, u32 addr, u32 data);
 	void (*write_rf)(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_path,
 			 u32 addr, u32 mask, u32 data);
+	void (*write8_set)(struct rtw89_dev *rtwdev, u32 addr, u8 bit);
+	void (*write16_set)(struct rtw89_dev *rtwdev, u32 addr, u16 bit);
+	void (*write32_set)(struct rtw89_dev *rtwdev, u32 addr, u32 bit);
+	void (*write8_clr)(struct rtw89_dev *rtwdev, u32 addr, u8 bit);
+	void (*write16_clr)(struct rtw89_dev *rtwdev, u32 addr, u16 bit);
+	void (*write32_clr)(struct rtw89_dev *rtwdev, u32 addr, u32 bit);
+	void (*write8_mask)(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			    u8 data);
+	void (*write16_mask)(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			     u16 data);
+	void (*write32_mask)(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			     u32 data);
 };
 
 struct rtw89_dev {
@@ -8183,57 +8195,93 @@ static inline void rtw89_write32(struct rtw89_dev *rtwdev, u32 addr, u32 data)
 }
 
 static inline void
-rtw89_write8_set(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+rtw89_raw_write8_set(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
 {
 	u8 val;
 
 	val = rtw89_read8(rtwdev, addr);
-	rtw89_write8(rtwdev, addr, val | bit);
+	rtw89_raw_write8(rtwdev, addr, val | bit);
 }
 
 static inline void
-rtw89_write16_set(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+rtw89_raw_write16_set(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
 {
 	u16 val;
 
 	val = rtw89_read16(rtwdev, addr);
-	rtw89_write16(rtwdev, addr, val | bit);
+	rtw89_raw_write16(rtwdev, addr, val | bit);
 }
 
 static inline void
-rtw89_write32_set(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+rtw89_raw_write32_set(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
 {
 	u32 val;
 
 	val = rtw89_read32(rtwdev, addr);
-	rtw89_write32(rtwdev, addr, val | bit);
+	rtw89_raw_write32(rtwdev, addr, val | bit);
 }
 
 static inline void
-rtw89_write8_clr(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+rtw89_write8_set(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+{
+	rtwdev->io->write8_set(rtwdev, addr, bit);
+}
+
+static inline void
+rtw89_write16_set(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+{
+	rtwdev->io->write16_set(rtwdev, addr, bit);
+}
+
+static inline void
+rtw89_write32_set(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+{
+	rtwdev->io->write32_set(rtwdev, addr, bit);
+}
+
+static inline void
+rtw89_raw_write8_clr(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
 {
 	u8 val;
 
 	val = rtw89_read8(rtwdev, addr);
-	rtw89_write8(rtwdev, addr, val & ~bit);
+	rtw89_raw_write8(rtwdev, addr, val & ~bit);
 }
 
 static inline void
-rtw89_write16_clr(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+rtw89_raw_write16_clr(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
 {
 	u16 val;
 
 	val = rtw89_read16(rtwdev, addr);
-	rtw89_write16(rtwdev, addr, val & ~bit);
+	rtw89_raw_write16(rtwdev, addr, val & ~bit);
 }
 
 static inline void
-rtw89_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+rtw89_raw_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
 {
 	u32 val;
 
 	val = rtw89_read32(rtwdev, addr);
-	rtw89_write32(rtwdev, addr, val & ~bit);
+	rtw89_raw_write32(rtwdev, addr, val & ~bit);
+}
+
+static inline void
+rtw89_write8_clr(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+{
+	rtwdev->io->write8_clr(rtwdev, addr, bit);
+}
+
+static inline void
+rtw89_write16_clr(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+{
+	rtwdev->io->write16_clr(rtwdev, addr, bit);
+}
+
+static inline void
+rtw89_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+{
+	rtwdev->io->write32_clr(rtwdev, addr, bit);
 }
 
 static inline u32
@@ -8275,46 +8323,66 @@ rtw89_read8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
 	return ret;
 }
 
+static inline void
+rtw89_raw_write8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u8 data)
+{
+	u8 orig, set;
+
+	orig = rtw89_read8(rtwdev, addr);
+	set = (orig & ~mask) | (data & mask);
+	rtw89_raw_write8(rtwdev, addr, set);
+}
+
+static inline void
+rtw89_raw_write16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u16 data)
+{
+	u16 orig, set;
+
+	orig = rtw89_read16(rtwdev, addr);
+	set = (orig & ~mask) | (data & mask);
+	rtw89_raw_write16(rtwdev, addr, set);
+}
+
+static inline void
+rtw89_raw_write32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u32 data)
+{
+	u32 orig, set;
+
+	orig = rtw89_read32(rtwdev, addr);
+	set = (orig & ~mask) | (data & mask);
+	rtw89_raw_write32(rtwdev, addr, set);
+}
+
 static inline void
 rtw89_write32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u32 data)
 {
 	u32 shift = __ffs(mask);
-	u32 orig;
-	u32 set;
 
 	WARN(addr & 0x3, "should be 4-byte aligned, addr = 0x%08x\n", addr);
 
-	orig = rtw89_read32(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
-	rtw89_write32(rtwdev, addr, set);
+	rtwdev->io->write32_mask(rtwdev, addr, mask, (data << shift) & mask);
 }
 
 static inline void
 rtw89_write16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u16 data)
 {
 	u32 shift;
-	u16 orig, set;
 
 	mask &= 0xffff;
 	shift = __ffs(mask);
 
-	orig = rtw89_read16(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
-	rtw89_write16(rtwdev, addr, set);
+	rtwdev->io->write16_mask(rtwdev, addr, mask, (data << shift) & mask);
 }
 
 static inline void
 rtw89_write8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u8 data)
 {
 	u32 shift;
-	u8 orig, set;
 
 	mask &= 0xff;
 	shift = __ffs(mask);
 
-	orig = rtw89_read8(rtwdev, addr);
-	set = (orig & ~mask) | ((data << shift) & mask);
-	rtw89_write8(rtwdev, addr, set);
+	rtwdev->io->write8_mask(rtwdev, addr, mask, (data << shift) & mask);
 }
 
 static inline u32
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 7cf51e78ce98..b1cfde6278c3 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -12923,6 +12923,15 @@ static const struct rtw89_io_ops rtw89_raw_io = {
 	.write8 = rtw89_raw_write8,
 	.write16 = rtw89_raw_write16,
 	.write32 = rtw89_raw_write32,
+	.write8_set = rtw89_raw_write8_set,
+	.write16_set = rtw89_raw_write16_set,
+	.write32_set = rtw89_raw_write32_set,
+	.write8_clr = rtw89_raw_write8_clr,
+	.write16_clr = rtw89_raw_write16_clr,
+	.write32_clr = rtw89_raw_write32_clr,
+	.write8_mask = rtw89_raw_write8_mask,
+	.write16_mask = rtw89_raw_write16_mask,
+	.write32_mask = rtw89_raw_write32_mask,
 	.phy_write8 = rtw89_raw_phy_write8,
 	.phy_write16 = rtw89_raw_phy_write16,
 	.phy_write32 = rtw89_raw_phy_write32,
@@ -13031,6 +13040,100 @@ void rtw89_fw_cmd_ofld_write32(struct rtw89_dev *rtwdev, u32 addr, u32 data)
 		rtw89_raw_io.write32(rtwdev, addr, data);
 }
 
+static void
+rtw89_fw_cmd_ofld_write8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			      u8 data)
+{
+	u32 dword_mask = RTW89_W8_MASK_OF_ALIGNED_ADDR(addr);
+	u32 shift = RTW89_W8_SHIFT_OF_ALIGNED_ADDR(addr);
+	struct rtw89_fw_cmd_ofld_arg cmd = {
+		.src = RTW89_FW_CMD_OFLD_SRC_MAC,
+		.type = RTW89_FW_CMD_OFLD_WRITE,
+		.offset = ALIGN_DOWN(addr, 4),
+		.mask = (mask << shift) & dword_mask,
+		.value = (data << shift) & dword_mask,
+	};
+	int ret;
+
+	ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
+	if (ret)
+		rtw89_raw_io.write8_mask(rtwdev, addr, mask, data);
+}
+
+static void
+rtw89_fw_cmd_ofld_write16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			       u16 data)
+{
+	u32 dword_mask = RTW89_W16_MASK_OF_ALIGNED_ADDR(addr);
+	u32 shift = RTW89_W16_SHIFT_OF_ALIGNED_ADDR(addr);
+	struct rtw89_fw_cmd_ofld_arg cmd = {
+		.src = RTW89_FW_CMD_OFLD_SRC_MAC,
+		.type = RTW89_FW_CMD_OFLD_WRITE,
+		.offset = ALIGN_DOWN(addr, 4),
+		.mask = (mask << shift) & dword_mask,
+		.value = (data << shift) & dword_mask,
+	};
+	int ret;
+
+	ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
+	if (ret)
+		rtw89_raw_io.write16_mask(rtwdev, addr, mask, data);
+}
+
+static void
+rtw89_fw_cmd_ofld_write32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask,
+			       u32 data)
+{
+	struct rtw89_fw_cmd_ofld_arg cmd = {
+		.src = RTW89_FW_CMD_OFLD_SRC_MAC,
+		.type = RTW89_FW_CMD_OFLD_WRITE,
+		.offset = addr,
+		.mask = mask,
+		.value = data,
+	};
+	int ret;
+
+	ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
+	if (ret)
+		rtw89_raw_io.write32_mask(rtwdev, addr, mask, data);
+}
+
+static void
+rtw89_fw_cmd_ofld_write8_set(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+{
+	rtw89_fw_cmd_ofld_write8_mask(rtwdev, addr, bit, bit);
+}
+
+static void
+rtw89_fw_cmd_ofld_write16_set(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+{
+	rtw89_fw_cmd_ofld_write16_mask(rtwdev, addr, bit, bit);
+}
+
+static void
+rtw89_fw_cmd_ofld_write32_set(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+{
+	rtw89_fw_cmd_ofld_write32_mask(rtwdev, addr, bit, bit);
+}
+
+static void
+rtw89_fw_cmd_ofld_write8_clr(struct rtw89_dev *rtwdev, u32 addr, u8 bit)
+{
+	rtw89_fw_cmd_ofld_write8_mask(rtwdev, addr, bit, 0);
+}
+
+static void
+rtw89_fw_cmd_ofld_write16_clr(struct rtw89_dev *rtwdev, u32 addr, u16 bit)
+{
+	rtw89_fw_cmd_ofld_write16_mask(rtwdev, addr, bit, 0);
+}
+
+static void
+rtw89_fw_cmd_ofld_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
+{
+	rtw89_fw_cmd_ofld_write32_mask(rtwdev, addr, bit, 0);
+}
+
 static void rtw89_fw_cmd_ofld_write_rf_ddv(struct rtw89_dev *rtwdev,
 					   struct rtw89_fw_cmd_ofld_arg *cmd,
 					   enum rtw89_rf_path rf_path, u32 addr, u32 mask,
@@ -13127,6 +13230,15 @@ static const struct rtw89_io_ops rtw89_fw_cmd_ofld_io = {
 	.phy_write16 = rtw89_fw_cmd_ofld_phy_write16,
 	.phy_write32 = rtw89_fw_cmd_ofld_phy_write32,
 	.write_rf = rtw89_fw_cmd_ofld_write_rf,
+	.write8_set = rtw89_fw_cmd_ofld_write8_set,
+	.write16_set = rtw89_fw_cmd_ofld_write16_set,
+	.write32_set = rtw89_fw_cmd_ofld_write32_set,
+	.write8_clr = rtw89_fw_cmd_ofld_write8_clr,
+	.write16_clr = rtw89_fw_cmd_ofld_write16_clr,
+	.write32_clr = rtw89_fw_cmd_ofld_write32_clr,
+	.write8_mask = rtw89_fw_cmd_ofld_write8_mask,
+	.write16_mask = rtw89_fw_cmd_ofld_write16_mask,
+	.write32_mask = rtw89_fw_cmd_ofld_write32_mask,
 };
 
 const struct rtw89_io_ops *
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 473278f6bbea..f8839d6cd3bb 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3281,8 +3281,12 @@ struct rtw89_h2c_cmd_ofld {
 #define RTW89_H2C_CMD_OFLD_W1_BASE_OFFSET GENMASK(31, 16)
 #define RTW89_H2C_CMD_OFLD_W2_VALUE GENMASK(31, 0)
 #define RTW89_H2C_CMD_OFLD_W3_MASK GENMASK(31, 0)
-#define RTW89_W8_MASK_OF_ALIGNED_ADDR(offset) (0xff << (((offset) & 0x3) << 3))
-#define RTW89_W16_MASK_OF_ALIGNED_ADDR(offset) (0xffff << (((offset) & 0x2) * 8))
+#define RTW89_W8_SHIFT_OF_ALIGNED_ADDR(offset) (((offset) & 0x3) << 3)
+#define RTW89_W16_SHIFT_OF_ALIGNED_ADDR(offset) (((offset) & 0x2) << 3)
+#define RTW89_W8_MASK_OF_ALIGNED_ADDR(offset) \
+	(0xff << RTW89_W8_SHIFT_OF_ALIGNED_ADDR(offset))
+#define RTW89_W16_MASK_OF_ALIGNED_ADDR(offset) \
+	(0xffff << RTW89_W16_SHIFT_OF_ALIGNED_ADDR(offset))
 
 #define RTW89_FW_CMD_OFLD_NR 125
 struct rtw89_fw_cmd_ofld_info {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 7649706b67e6..624f23b3f2a1 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2699,6 +2699,8 @@ static void rtw8852c_btc_init_cfg(struct rtw89_dev *rtwdev)
 		.direction = RTW89_MAC_AX_COEX_INNER,
 	};
 
+	rtw89_io_pack(rtwdev);
+
 	/* PTA init  */
 	rtw89_mac_coex_init_v1(rtwdev, &coex_params);
 
@@ -2706,8 +2708,6 @@ static void rtw8852c_btc_init_cfg(struct rtw89_dev *rtwdev)
 	chip->ops->btc_set_wl_pri(rtwdev, BTC_PRI_MASK_TX_RESP, true);
 	chip->ops->btc_set_wl_pri(rtwdev, BTC_PRI_MASK_BEACON, true);
 
-	rtw89_io_pack(rtwdev);
-
 	/* set rf gnt debug off */
 	rtw89_write_rf(rtwdev, RF_PATH_A, RR_WLSEL, RFREG_MASK, 0x0);
 	rtw89_write_rf(rtwdev, RF_PATH_B, RR_WLSEL, RFREG_MASK, 0x0);
-- 
2.25.1

