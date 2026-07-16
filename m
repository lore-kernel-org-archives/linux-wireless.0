Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126319CD0A
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 00:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784161084; cv=none; b=QAkYhWSrGCXaA6JTIwKvd8/vvt6h7fZrJ/C+3lHhVogt/Q7RxdgDPjM9sfAgaYE4/RrH+YDRZ3XrxEuih04OaKu/D530QgZnyNCOl2tuvyMHTcY8Zl7Wkl07JwJR7sxCtrqbvpbIU4t9Acrwa0rgy+kSG4r+L63vcwvgGPR8rPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784161084; c=relaxed/simple;
	bh=g17dHcWS+jsSUKoyhr2RQjmSJNm6P0XrFpUqfAE87gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPKZQVxKGuph+eIYPPtJ64LdiCBe5iDgCt4EfXcazGmvCw4j6N/Xsat244NLYHy3XLZWKytZlePpzNYNNmvzVWzK6xN1wLL5xbYSiMy+6neImmBmo+RtINh/aZgPZvUp1Znvcan9LcdNrB6yvBEmCpACfqEyff2QaMsNWkt5HAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d77tdbP3; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d77tdbP3"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493ba701891so21718015e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 17:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784161080; x=1784765880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q2GsLfGNapFzMWQG14eqqxipuP9UERarjO5kgcBEMgo=;
        b=d77tdbP3hDwfcRIukQhLeQUjS3HY3SGvC8npHsXR1e+MWb3r/axB4FtYMS4qh2A66+
         TzULNp7P+mJiMSXLwDQUK24is3jPfzN3qi+WIdl6ErRhBnptAzFU56p6sBfAofp+5/21
         rh0ihjzUPnUnVduU7TBqUQivn5zDmeI8WK/tDkzmWJMTCSsN9s7+W10o5pVEFG/3Fem9
         xFgSIeKK6Mbu7WYRENuxrsALSijHqZXsx/B5P06lf98Lm+tyWHADu+8JtfsvocLw3xNa
         DRIrGiw3il9y1PHafm0OO3SeYjRG7GqfUt99Acu8qccWH8cGXT5AWUXr1nQ0x74ju7ka
         NxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784161080; x=1784765880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q2GsLfGNapFzMWQG14eqqxipuP9UERarjO5kgcBEMgo=;
        b=PT/g05n8glpXMAvGdndovbuYPbheosqpGyG4r/x40oArJZk2gH1JP3H8DkHGS1rAiH
         eHwXJw18U3ixtgNTJo6eAYIt9JtFVMOPU2X7s88xP+o4q3Jc/gwNNhvdiAoWyAYGPzUx
         Hff9i8HqrFKB95MRxpX2e/++X3b2NDzzRJjpFYxUqblQm26tHXJmDdbmqzxT+KaCEh+C
         +mKezZOw6IVLoWdZhrcs0Q5nzniGyAhgrCHbypPQlCCCdslaXQArBbJazV4Hc9DLSIJc
         5m3JsKyBKYYnai1hgUBv/jJgtUP+A537fNu0vQQD5nQtGiWjf4EizsLwjxeUTsDUzq6z
         HCOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpZf9wS3GWAPt9JE+yXtlOtyWHk42xv0JN5dZY1y2tG0wz4VoU++t7pcK3m0GG7xx028zir8D5x42P2g5d7Zw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFjyVMPd0r8KXdxezc/ou1nQhx54V6JeCGtreF6Qx5QoD5+n7r
	Nl1xI8XhSZYwXL+RiwwHlSWlnVDkB82gQISbBDvLKtTpt7TeXxsYfUcO
X-Gm-Gg: AfdE7cmBQpaBb6INZb7Kx6HxB61QuRo/X3xNqeYQyMufbm+UX/6w0EGLMUpzsWbIOiC
	04GyZ6iBtdbZj1msk59qRVWLt8w+2xcHLlxdPiQhViya73aTezCavl/GILbq0V/G8swmb5vB6hB
	4gXNyKWwuBlM4jDLx8phOgoD0VC/S1J4BD7Df0s/384dcrKg+FmhiyEErtT5qCpUVOJG6nubvbH
	0JEgAE28tc35IsXLWX1IMdq01/P8mxCa5uAO2m0aHasbLrTvSbR3Lf3yMpSTDE4m/eZ5zVrAUUs
	N5BiINv++PW7yz+MPtpAxxn0TDSrdWH2sTqKNY7uzzC5PYxH1WHZgY+vdZ4sc7a7mSMeqJwXGFC
	dhZ324Q58vhm6fg//i9hqlwrwk2753FclbYrpeSrqgSqBXt3JoYjih0RflYLmeMBoMxKuGkkp0r
	EhlOpg7f2d3LTamooiI/4GtilhC99A/z5WoO4kV1Gc1S49sI46ER4XaeWQc7Ku0LIZZNBxX1/J0
	rZ18DDr
X-Received: by 2002:a05:600c:2e15:b0:493:eb71:5cc6 with SMTP id 5b1f17b1804b1-493f88280bamr133149225e9.27.1784161080431;
        Wed, 15 Jul 2026 17:18:00 -0700 (PDT)
Received: from localhost.localdomain ([151.251.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e9a7bbsm17503925e9.13.2026.07.15.17.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 17:18:00 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	kees@kernel.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	bhelgaas@google.com,
	error27@gmail.com,
	s.kerkmann@pengutronix.de,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v3] wifi: mwifiex: replace one-element arrays with flexible array members
Date: Thu, 16 Jul 2026 03:17:28 +0300
Message-ID: <20260716001728.57799-1-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <202607150932.F2A0836@keescook>
References: <202607150932.F2A0836@keescook>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace deprecated one-element arrays with flexible array members.
CONFIG_FORTIFY_SOURCE reports the following warning when
one-element arrays are used as variable-length buffers:

sta_cmd.c:1033 mwifiex_sta_prepare_cmd
memcpy: detected field-spanning write (size 84) of single field
"domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)

Convert affected structs to use flexible array members.
- Preserve existing wire layouts.
- Use DECLARE_FLEX_ARRAY() for structs inside affected unions.

Tested-on: WRT3200ACM, OpenWrt
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
Thank you for your help!
Please backport to 6.18 and 6.12, which are used by OpenWrt.

v3:
- resend, please ignore v2 (corrupted by mail client)

v2:
- restore the unions and use DECLARE_FLEX_ARRAY
  for the flexible arrays inside
- restore use of sizeof(*member) instead of sizeof(struct)

 drivers/net/wireless/marvell/mwifiex/fw.h      | 18 +++++++++---------
 drivers/net/wireless/marvell/mwifiex/join.c    |  8 ++++----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index e9e896606912..93561116959a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -823,7 +823,7 @@ struct chan_band_param_set {
 
 struct mwifiex_ie_types_chan_band_list_param_set {
 	struct mwifiex_ie_types_header header;
-	struct chan_band_param_set chan_band_param[1];
+	struct chan_band_param_set chan_band_param[];
 } __packed;
 
 struct mwifiex_ie_types_rates_param_set {
@@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
 	struct mwifiex_ie_types_header header;
-	u8 tsf_data[1];
+	u8 tsf_data[];
 } __packed;
 
 struct mwifiex_cf_param_set {
@@ -903,8 +903,8 @@ struct mwifiex_ibss_param_set {
 struct mwifiex_ie_types_ss_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_cf_param_set cf_param_set[1];
-		struct mwifiex_ibss_param_set ibss_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_cf_param_set, cf_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ibss_param_set, ibss_param_set);
 	} cf_ibss;
 } __packed;
 
@@ -922,8 +922,8 @@ struct mwifiex_ds_param_set {
 struct mwifiex_ie_types_phy_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_fh_param_set fh_param_set[1];
-		struct mwifiex_ds_param_set ds_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
 	} fh_ds;
 } __packed;
 
@@ -1383,7 +1383,7 @@ struct host_cmd_ds_802_11_snmp_mib {
 	__le16 query_type;
 	__le16 oid;
 	__le16 buf_size;
-	u8 value[1];
+	u8 value[];
 } __packed;
 
 struct mwifiex_rate_scope {
@@ -1551,7 +1551,7 @@ struct mwifiex_scan_cmd_config {
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
 	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
 	 */
-	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
+	u8 tlv_buf[];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
 } __packed;
 
@@ -1683,7 +1683,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
-	struct ieee80211_country_ie_triplet triplet[1];
+	struct ieee80211_country_ie_triplet triplet[];
 } __packed;
 
 struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 5a1a0287c1d5..a83f4d081fe2 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
 	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
-	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
-	memcpy(&phy_tlv->fh_ds.ds_param_set,
+	phy_tlv->header.len = cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));
+	memcpy(phy_tlv->fh_ds.ds_param_set,
 	       &bss_desc->phy_param_set.ds_param_set.current_chan,
-	       sizeof(phy_tlv->fh_ds.ds_param_set));
+	       sizeof(*phy_tlv->fh_ds.ds_param_set));
 	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
 
 	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
 	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
-	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
+	ss_tlv->header.len = cpu_to_le16(sizeof(*ss_tlv->cf_ibss.cf_param_set));
 	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
 
 	/* Get the common rates supported between the driver and the BSS Desc */
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 623ddde8c8e5..071f7cb305e1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
-				- 1 + S_DS_GEN);
+				+ S_DS_GEN);
 
 	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-- 
2.55.0

