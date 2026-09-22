Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68452530DE9
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072032; cv=none; b=ZV8eo7TI3kiJT+1Z8ewqrolRZzMGkpiDpLgAKpvKTGGs/+gM5EdkCyIzo2TZMJmZafIMT/C7gXQLL4OdfR3kiYMKUTcyAiGpk+wZNbxDHvR8EMtlh0lM82JX8Qrz3z5t36ADwr9lOTDxTnmVDJTxu8bKTat0TUQd+ncYY7S8caQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072032; c=relaxed/simple;
	bh=dy/gKPluhR0h1uM8L3iH80MbVZXvykDwVkXT1gBVcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR6TqpOzEnJlBw+bQZ1h5if0EQC6RToCdIMkHxHbUhHXOf7IlXcwGnu0AW3nFSz0437sz2xYvxioLLukUnafow9lgPjQZZead5FeBwK5wY1IvKHHyZPdG91k/N1r48LCTftwfPc0l3a45d40UMMfjPpmBCYL5PUnu577XXXHlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ip5wIvL8; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ip5wIvL8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jSRdhd4xuwCBkw0ByxN+JOcfFdpxdb3aXHlD4E7NDMo=; b=ip5wIvL8F/9Q8jXxPRcBopNpA/
	e1ogAtYjgxpVvyDn7snroFn/aalbkcAtSV36wbzC+3iINfjDG+h6eh6jmMtpqphQvpHkIWzliz5uE
	Ch+9pO+sj+07zTsv7mBnarM6A41W6B/v/ASkqqSsSkqj+P0AmU7DtOEF57u9R6jMvnHY=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVT-00807z-04;
	Tue, 22 Sep 2026 12:13:47 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 04/16] wifi: ieee80211: add the QoS Characteristics element
Date: Tue, 22 Sep 2026 12:13:31 +0200
Message-ID: <b4acd8a03375e099bfc2e22c0d3d7bcf8208f85c.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the element structure with accessors for the direction and the
presence bitmap, and ieee80211_qos_char_size_ok(), which checks that
the element length matches the optional fields that the presence
bitmap announces. The accessors read the fixed part only, so they are
safe to use once that check passed.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211-eht.h | 125 +++++++++++++++++++++++++++++++++++-
 include/linux/ieee80211.h     |   1 +-
 2 files changed, 126 insertions(+)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index a699d108eee6..92fa7efdf156 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -1385,4 +1385,129 @@ static inline u32 ieee80211_eml_trans_timeout_in_us(u16 eml_cap)
 				 _data + ieee80211_mle_common_size(_data),\
 				 _len - ieee80211_mle_common_size(_data))
 
+/**
+ * struct ieee80211_qos_char_elem - QoS Characteristics element
+ * @element_id: %WLAN_EID_EXTENSION
+ * @length: length of everything behind it
+ * @element_id_ext: %WLAN_EID_EXT_QOS_CHARACTERISTICS
+ * @control: control info, see %IEEE80211_QOS_CHAR_CTRL_*
+ * @min_service_interval: minimum service period interval, in microseconds
+ * @max_service_interval: maximum service period interval, in microseconds
+ * @min_data_rate: minimum data rate at the MAC SAP, in kilobits per second
+ * @delay_bound: targeted transport time of an MSDU, in microseconds
+ * @variable: the optional parameters that the presence bitmap names, in the
+ *	order of the %IEEE80211_QOS_CHAR_PRES_* bits
+ *
+ * The whole element, header included, because a device takes it unchanged.
+ */
+struct ieee80211_qos_char_elem {
+	u8 element_id;
+	u8 length;
+	u8 element_id_ext;
+	__le32 control;
+	__le32 min_service_interval;
+	__le32 max_service_interval;
+	u8 min_data_rate[3];
+	u8 delay_bound[3];
+	u8 variable[];
+} __packed;
+
+#define IEEE80211_QOS_CHAR_CTRL_DIRECTION		GENMASK(1, 0)
+#define IEEE80211_QOS_CHAR_CTRL_PRESENCE		GENMASK(24, 9)
+
+#define IEEE80211_QOS_CHAR_DIR_UPLINK			0
+#define IEEE80211_QOS_CHAR_DIR_DOWNLINK			1
+#define IEEE80211_QOS_CHAR_DIR_DIRECT			2
+
+#define IEEE80211_QOS_CHAR_PRES_MAX_MSDU_SIZE		BIT(0)
+#define IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME	BIT(1)
+#define IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID	BIT(2)
+#define IEEE80211_QOS_CHAR_PRES_MEAN_DATA_RATE		BIT(3)
+#define IEEE80211_QOS_CHAR_PRES_BURST_SIZE		BIT(4)
+#define IEEE80211_QOS_CHAR_PRES_MSDU_LIFETIME		BIT(5)
+#define IEEE80211_QOS_CHAR_PRES_MSDU_DELIVERY_INFO	BIT(6)
+#define IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME		BIT(7)
+
+/**
+ * ieee80211_qos_char_presence - QoS Characteristics presence bitmap
+ * @qc: the element
+ * Return: the Presence Bitmap Of Additional Parameters subfield, a bitmap of
+ *	%IEEE80211_QOS_CHAR_PRES_*
+ */
+static inline u16
+ieee80211_qos_char_presence(const struct ieee80211_qos_char_elem *qc)
+{
+	return u32_get_bits(le32_to_cpu(qc->control),
+			    IEEE80211_QOS_CHAR_CTRL_PRESENCE);
+}
+
+/**
+ * ieee80211_qos_char_direction - QoS Characteristics direction
+ * @qc: the element
+ * Return: %IEEE80211_QOS_CHAR_DIR_UPLINK, _DOWNLINK or _DIRECT
+ */
+static inline u8
+ieee80211_qos_char_direction(const struct ieee80211_qos_char_elem *qc)
+{
+	return u32_get_bits(le32_to_cpu(qc->control),
+			    IEEE80211_QOS_CHAR_CTRL_DIRECTION);
+}
+
+/**
+ * ieee80211_qos_char_size_ok - check a QoS Characteristics element
+ * @data: candidate octets, from the Element ID
+ * @len: length of @data
+ *
+ * Call this before the other accessors, which assume a valid element.
+ *
+ * Return: %true if @data holds a QoS Characteristics element whose length
+ *	matches its presence bitmap
+ */
+static inline bool ieee80211_qos_char_size_ok(const u8 *data, size_t len)
+{
+	const struct ieee80211_qos_char_elem *qc = (const void *)data;
+	size_t needed = sizeof(*qc);
+	u16 present;
+
+	if (len < needed)
+		return false;
+
+	if (qc->element_id != WLAN_EID_EXTENSION ||
+	    qc->element_id_ext != WLAN_EID_EXT_QOS_CHARACTERISTICS ||
+	    qc->length != len - 2)
+		return false;
+
+	present = ieee80211_qos_char_presence(qc);
+
+	if (present & ~GENMASK(7, 0))
+		return false;
+
+	if (ieee80211_qos_char_direction(qc) > IEEE80211_QOS_CHAR_DIR_DIRECT)
+		return false;
+
+	/* The LinkID refers to the Service Start Time, which must be present */
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID &&
+	    !(present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME))
+		return false;
+
+	if (present & IEEE80211_QOS_CHAR_PRES_MAX_MSDU_SIZE)
+		needed += 2;
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME)
+		needed += 4;
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID)
+		needed += 1;
+	if (present & IEEE80211_QOS_CHAR_PRES_MEAN_DATA_RATE)
+		needed += 3;
+	if (present & IEEE80211_QOS_CHAR_PRES_BURST_SIZE)
+		needed += 4;
+	if (present & IEEE80211_QOS_CHAR_PRES_MSDU_LIFETIME)
+		needed += 2;
+	if (present & IEEE80211_QOS_CHAR_PRES_MSDU_DELIVERY_INFO)
+		needed += 1;
+	if (present & IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME)
+		needed += 2;
+
+	return len == needed;
+}
+
 #endif /* LINUX_IEEE80211_EHT_H */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7959f96de562..722043d8bb2e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1826,6 +1826,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_EHT_MULTI_LINK = 107,
 	WLAN_EID_EXT_EHT_CAPABILITY = 108,
 	WLAN_EID_EXT_TID_TO_LINK_MAPPING = 109,
+	WLAN_EID_EXT_QOS_CHARACTERISTICS = 113,
 	WLAN_EID_EXT_BANDWIDTH_INDICATION = 135,
 	WLAN_EID_EXT_KNOWN_STA_IDENTIFCATION = 136,
 	WLAN_EID_EXT_NON_AP_STA_REG_CON = 137,
-- 
git-series 0.9.1
