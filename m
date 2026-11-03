Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723047;
	b=t631ixqzjfg1TSA5CVkh4yLS1pHgNNA+L1iyIDfUwQCjzEZZ85Uvi2YcrsHD0fpyBJnn
	 44HL4x/UVInvKE0TQ24ygoCNsChvSSGjpCweyBJzGITLzHcnM/59eDYH2flLrGGJDzd2c
	 VXAugpBvI9FbmzmV+YWSHVJKXcvF9e7ikHuNMCvexJkB7lT1KfoNlCjuLuj+UkJCBR5Jq
	 nNXKR5Wl84T/8RMkuxkDFRtfLr2/Udfb/5PQdNSDbOpRxFSd2BY9l3oFie6keYESL+g0x
	 3457g5v14aNgbJXsTzXZ9a8JRMFEskYkV6eF41cwIDk23LK8Ab2LnjsOT/B67VAWXrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723047;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VY2EBIRMvieJ+PONwXTi3e08H17KEe9u3+TaTxxHuNY=;
	b=SWiAd8Zw2FKX/kOBdt/8kBF2m+8pwsft3YM+UqzTFMpCDXa9szpHh3sIGAgmgF1c2qbV
	 +E0kPR0W9KI1iMKPhUnA5IFSl7ZqrfEXW6dIJT6UZjVWL53XmR98ZVKVzxDdHBj/dzhRL
	 WVnXmNF3wsXIEGPvPHClEE8OCp6lYRRGTI+ys91VAabbeLfox518mE+YikpLW3gV72LfT
	 ymL6v8kURCorjWq4SND1ZiAexngUSZ0HgbSWypmWZwyKV1PwNpKBttFEAFFOjHYHUkrGD
	 MrQs/TfcURHIAOCY8f8m28RKjDzlLYBlXmZlgUl1XnKSPUo7XGsoimq9WrcQTUenESQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=lZvriQ26;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B80606A328
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B80606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=lZvriQ26
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VY2EBIRMvieJ+PONwXTi3e08H17KEe9u3+TaTxxHuNY=; b=lZvriQ265EQ5pCGsehuMsi/b5Q
	+QptP9YxaDIF3uSKRTO3/MRVUR1H6hPJ/tBJkkAj7sBvkSqpM+w/Allfy61Ew3QUZtDUrci3WUt70
	mEfl7960VIhTSs3Ajtx52Lh2bBSm7NgowPTo0J6GU9Fyqyma52vGRUep2tjfYyKvFJz0=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIl-00FDFp-2C;
	Tue, 03 Nov 2026 17:23:59 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 04/18] wifi: ieee80211: add the QoS Characteristics element
Date: Tue,  3 Nov 2026 17:23:37 +0100
Message-ID: <f264205bfa8795f68fe4eb51f3ea24ee3d96e9b4.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the definitions of the 802.11be QoS Characteristics element, which
an SCS descriptor can carry, and a check of the element. The check
compares the length with the optional fields that the presence bitmap
announces, and checks the dependencies between these fields and the
direction.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211-eht.h | 129 +++++++++++++++++++++++++++++++++++-
 include/linux/ieee80211.h     |   1 +-
 2 files changed, 130 insertions(+)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index cada6270f60a..baf107f22787 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -1392,4 +1392,133 @@ static inline u32 ieee80211_eml_trans_timeout_in_us(u16 eml_cap)
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
+ *	matches its presence bitmap, and whose optional fields agree with
+ *	each other and with its direction
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
+	/* The LinkID is present exactly when the Service Start Time is */
+	if (!(present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID) !=
+	    !(present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME))
+		return false;
+
+	/* Only a direct link stream carries a Medium Time */
+	if (present & IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME &&
+	    ieee80211_qos_char_direction(qc) != IEEE80211_QOS_CHAR_DIR_DIRECT)
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
index da7dec87b0e0..3404afbebdd1 100644
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
