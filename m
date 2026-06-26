Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847ED30D411;
	Fri, 26 Jun 2026 11:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782472749; cv=none; b=L0MGWNwFUpf63m7jqoRlGthUSvF7xMmDd4Ah60jI8jMLjn3fqI1zuj0zJOX46vpXX6t07mSY6WuNliGVVtkvMo4oo8qEkVdK7JmRZEuZ/qPpTipY/0ECOe2S2b+ZrCzbMULPyNzN4nrp7r6SpqllCjubsm7CcCwxOXSlTIw2TPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782472749; c=relaxed/simple;
	bh=QCdv/xm6S2363B4trKyY8X3EUb53sYrWR7Oxe4/NgMY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=DlFUqY6eDWUubMM79uhavP8btzeBomF794XCx+q4eDGghup2qO3+CwhuU2IIEgCHUyhlf3cYNxcxBhCBi7NDwNh5wRoC4os92iKN7nshLqbFLIhvmQB+GdJ4u9qlRKOWUgJ3R3OJjW7v9XwEUXgiH82+YNSckEQuEAcUc7sXHhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=qHdGsyIg; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="qHdGsyIg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782472745;
	bh=QCdv/xm6S2363B4trKyY8X3EUb53sYrWR7Oxe4/NgMY=;
	h=From:Date:Subject:To:Cc:From;
	b=qHdGsyIgPdn2LKWQO8Mj/EsuPkZ0nBYV7UAmW8atHgFi/b6Vu3BwFcdeSAexbCUHv
	 goaImA6aOWkfoablor+nfdM3Hl7u+WFtpJovAMmXeR43txY+852QGj3OYUywUAByLN
	 nXJGMJhcA+csPtjAmXULZiPhkKdw0FX9MiFe2F0JRGfXrESHdWzOKrCsZB3xi3BTWb
	 XQ1AmRQYN1yPKEBXNXH5D+fkMrQN8rHVK/LoYnn3bEm/yAopHsQgQucJxYjlgI3n4b
	 Jjq85mw/kGWDwg7oiGI1P9O7yJYJGelVs7NU7Xmj4gNszpU7Qn3CwzJ6iAxz12DM2A
	 LiICGfAX81DsA==
Received: from [192.168.1.156] (unknown [100.64.1.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mattl)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 87C2C17E0180;
	Fri, 26 Jun 2026 13:19:05 +0200 (CEST)
From: Matthew Leach <matthew.leach@collabora.com>
Date: Fri, 26 Jun 2026 12:19:01 +0100
Subject: [PATCH v2] wifi: rtw89: regd: stop gating 6GHz on the ww domain
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-rtw89-6ghz-regd-fixes-v2-1-beeb3fdb60ba@collabora.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4XM2jFtIaW68j8Mi9IOUIPUtIgPw
 r9bMC5dntzHmSFScBThmM0QaHLR+SGB2GVgOj20hM4mBsGEZJJLDONDHVC23RsDtRYb96SIVjW
 KS6VYbRmk7S3QFqTpufpyvNcXMuN6tjY6F0cfXpt44mvv5yj/OCaOHPPclkWhWWm5PBnf97r2Q
 e+Nv0K1LMsHxJaiL9AAAAA=
X-Change-ID: 20260616-rtw89-6ghz-regd-fixes-d8f816880bd0
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel@collabora.com, Zong-Zhe Yang <kevin_yang@realtek.com>, 
 Matthew Leach <matthew.leach@collabora.com>
X-Mailer: b4 0.15.2

The driver maintains its own block_* bitmaps on top of cfg80211's
regulatory enforcement. These bitmaps are indexed by the position of an
entry in the active regd_map (either the built-in rtw89_regd_map or the
table loaded from a firmware element).

The ww domain is handled outside the regd_map; it lives in a standalone
rtw89_ww_regd object, and rtw89_regd_get_index() returns the
RTW89_REGD_MAX_COUNTRY_NUM sentinel for it. Every block_* lookup site
guards against that sentinel and bails out, which means none of the
block_* checks ever apply to ww. The 6GHz check therefore treats ww as
unconditionally blocked at the driver layer, independently of whatever
cfg80211/wireless-regdb permit.

Make ww a first-class entry in the regd_map instead:

- Reserve slot 0 of rtw89_regd_map for the ww entry and drop the
  standalone rtw89_ww_regd object.
- In rtw89_recognize_regd_from_elm(), reserve slot 0 of the
  firmware-loaded map for ww and populate it from the built-in
  definition via the new rtw89_regd_static_ww_entry() helper.
- Drop the rtw89_regd_is_ww() special case in rtw89_regd_get_index()
  and identify ww by alpha2 so the check works for entries in either
  map.
- Have rtw89_regd_find_reg_by_name() return NULL on miss instead of
  silently substituting ww. Callers that need the previous "fall back
  to ww" behaviour (rtw89_regd_notifier_apply()) now do so explicitly
  against the active map's slot 0, and rtw89_regd_get_index_by_name()
  translates NULL into the RTW89_REGD_MAX_COUNTRY_NUM sentinel so the
  existing "unknown alpha2" branches in the block_* setup paths
  remain.

With ww at a real index the driver's block_* checks apply uniformly for
all bands and cfg80211 / wireless-regdb become the sole source of truth
for what is permitted on the ww domain.

Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
---
Changes in v2:
- Re-word the commit message, clarifying the motivation behind the
  patch (removing the explicit 6GHz disablement).
- Re-work the patch to play nicely with firmware loaded regulatory
  tables by reserving slot 0 in both static and firmware regulatory lists
  for the WW domain.
- Link to v1: https://patch.msgid.link/20260617-rtw89-6ghz-regd-fixes-v1-1-33d744a07d16@collabora.com

To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   |  6 ++++--
 drivers/net/wireless/realtek/rtw89/regd.c | 32 +++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index fd29dbbb120d..dc9eae2cee69 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -7862,6 +7862,7 @@ void rtw89_chip_cfg_txpwr_ul_tb_offset(struct rtw89_dev *rtwdev,
 bool rtw89_legacy_rate_to_bitrate(struct rtw89_dev *rtwdev, u8 legacy_rate, u16 *bitrate);
 int rtw89_regd_setup(struct rtw89_dev *rtwdev);
 int rtw89_regd_init_hint(struct rtw89_dev *rtwdev);
+const struct rtw89_regd *rtw89_regd_static_ww_entry(void);
 const char *rtw89_regd_get_string(enum rtw89_regulation_type regd);
 void rtw89_traffic_stats_init(struct rtw89_dev *rtwdev,
 			      struct rtw89_traffic_stats *stats);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 17704f054727..77f320cae01b 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1347,10 +1347,11 @@ int rtw89_recognize_regd_from_elm(struct rtw89_dev *rtwdev,
 {
 	const struct __rtw89_fw_regd_element *regd_elm = &elm->u.regd;
 	struct rtw89_fw_elm_info *elm_info = &rtwdev->fw.elm_info;
-	u32 num_ents = le32_to_cpu(regd_elm->num_ents);
 	struct rtw89_regd_data *p;
 	struct rtw89_regd regd;
-	u32 i = 0;
+	/* +1 because we reserve index 0 for WW */
+	u32 num_ents = le32_to_cpu(regd_elm->num_ents) + 1;
+	u32 i = 1;
 
 	if (num_ents > RTW89_REGD_MAX_COUNTRY_NUM) {
 		rtw89_warn(rtwdev,
@@ -1373,6 +1374,7 @@ int rtw89_recognize_regd_from_elm(struct rtw89_dev *rtwdev,
 		return -ENOMEM;
 
 	p->nr = num_ents;
+	p->map[0] = *rtw89_regd_static_ww_entry();
 	rtw89_for_each_in_regd_element(&regd, regd_elm)
 		p->map[i++] = regd;
 
diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 28466cb35ea2..27ac87374e6e 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -21,10 +21,8 @@ void rtw89_regd_notifier(struct wiphy *wiphy, struct regulatory_request *request
 
 static_assert(BITS_PER_TYPE(unsigned long) >= NUM_OF_RTW89_REGD_FUNC);
 
-static const struct rtw89_regd rtw89_ww_regd =
-	COUNTRY_REGD("00", RTW89_WW, RTW89_WW, RTW89_WW, 0x0);
-
 static const struct rtw89_regd rtw89_regd_map[] = {
+	COUNTRY_REGD("00", RTW89_WW, RTW89_WW, RTW89_WW, 0x0),
 	COUNTRY_REGD("AR", RTW89_MEXICO, RTW89_MEXICO, RTW89_FCC, 0x0),
 	COUNTRY_REGD("BO", RTW89_FCC, RTW89_FCC, RTW89_NA, 0x0),
 	COUNTRY_REGD("BR", RTW89_FCC, RTW89_FCC, RTW89_FCC, 0x0),
@@ -316,12 +314,12 @@ static const struct rtw89_regd *rtw89_regd_find_reg_by_name(struct rtw89_dev *rt
 			return &regd_ctrl->map[i];
 	}
 
-	return &rtw89_ww_regd;
+	return NULL;
 }
 
 static bool rtw89_regd_is_ww(const struct rtw89_regd *regd)
 {
-	return regd == &rtw89_ww_regd;
+	return !memcmp(regd->alpha2, "00", 2);
 }
 
 static u8 rtw89_regd_get_index(struct rtw89_dev *rtwdev, const struct rtw89_regd *regd)
@@ -331,9 +329,6 @@ static u8 rtw89_regd_get_index(struct rtw89_dev *rtwdev, const struct rtw89_regd
 
 	BUILD_BUG_ON(ARRAY_SIZE(rtw89_regd_map) > RTW89_REGD_MAX_COUNTRY_NUM);
 
-	if (rtw89_regd_is_ww(regd))
-		return RTW89_REGD_MAX_COUNTRY_NUM;
-
 	return regd - regd_ctrl->map;
 }
 
@@ -342,6 +337,10 @@ static u8 rtw89_regd_get_index_by_name(struct rtw89_dev *rtwdev, const char *alp
 	const struct rtw89_regd *regd;
 
 	regd = rtw89_regd_find_reg_by_name(rtwdev, alpha2);
+
+	if (!regd)
+		return RTW89_REGD_MAX_COUNTRY_NUM;
+
 	return rtw89_regd_get_index(rtwdev, regd);
 }
 
@@ -721,7 +720,7 @@ int rtw89_regd_init_hint(struct rtw89_dev *rtwdev)
 		return -EINVAL;
 
 	chip_regd = rtw89_regd_find_reg_by_name(rtwdev, rtwdev->efuse.country_code);
-	if (!rtw89_regd_is_ww(chip_regd)) {
+	if (chip_regd && !rtw89_regd_is_ww(chip_regd)) {
 		rtwdev->regulatory.regd = chip_regd;
 		rtwdev->regulatory.programmed = true;
 
@@ -743,6 +742,11 @@ int rtw89_regd_init_hint(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
+const struct rtw89_regd *rtw89_regd_static_ww_entry(void)
+{
+	return &rtw89_regd_map[0];
+}
+
 static void rtw89_regd_apply_policy_unii4(struct rtw89_dev *rtwdev,
 					  struct wiphy *wiphy)
 {
@@ -859,7 +863,15 @@ static void rtw89_regd_notifier_apply(struct rtw89_dev *rtwdev,
 				      struct wiphy *wiphy,
 				      struct regulatory_request *request)
 {
-	rtwdev->regulatory.regd = rtw89_regd_find_reg_by_name(rtwdev, request->alpha2);
+	const struct rtw89_regd *regd = rtw89_regd_find_reg_by_name(rtwdev, request->alpha2);
+
+	if (!regd) {
+		/* Fallback to WW domain if name not found. */
+		regd = &rtwdev->regulatory.ctrl.map[0];
+	}
+
+	rtwdev->regulatory.regd = regd;
+
 	/* This notification might be set from the system of distros,
 	 * and it does not expect the regulatory will be modified by
 	 * connecting to an AP (i.e. country ie).

---
base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
change-id: 20260616-rtw89-6ghz-regd-fixes-d8f816880bd0

Best regards,
--  
Matt

