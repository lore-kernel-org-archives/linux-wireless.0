Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6FD503BDF
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898614; cv=none; b=b08eRTJdm8BAR1CMv+OqoaLPOwaKkIKFDVljEzGIpCqzEfYsYlXFIt5VHSz2C2qDqxYThHsv2VPsIOEi9a3SZ8S+QgBHvN8OuB+UBczV/VtqJxvhNqUzcPSyk1evM4uARAHVnpdZIdDSU5Gw7vABmrbMBrzeCtdzZJALo7OBxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898614; c=relaxed/simple;
	bh=yRwwseNy5XCbO3OJCfcf8Y+GcoI7wV8Ao4VzfoCKA6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eg1FOZUwvI5n6AaGa8mLUhuiUIMEHgdQzLL2NcgvHskmu8nKvI7GukDZ8giF7RQLL6+wlLS89jjAT53ez2iiC+Pvv9kWyxVJgBR4ZIWsPty2pW0PrhaYp5Y87+ZrSmw+FGSYGHjagcS/ygdrWnthlBAhLd0u0K32iaybVHonXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=YK7Rtd86; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YK7Rtd86"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=C1Xql1rukCVDvt2UrE4BsmOBnBR8CnO9xSf4wlGuiCM=;
	t=1791898613; x=1793108213; b=YK7Rtd86WzJ03Vy9t1+rzu9Pq8ouPaKmfs5zV1Nv4WOJn1I
	QpvHX0kzaNVtggdCRGW/jQDAffJebJ3Vv5j6L9ipDYhiEITNBTGk82BMPf+0/FSADd9Sivv2SB8/y
	bS/QOxfDmrIMo8amP64sjjTVw+9RuOj6q0mpTu3IHma+WNB3fvH1YZHzGv5k4TROnRAexeVcQ5GGW
	9HPWzYAyxWv/mIgJnxWhoJ5u/L016h7+gwlyPHHYcEYMEOZeNjY35ZPUiStnmAA/asiYg3G35T0v0
	23si0onbFfJMg3CRd7PyM7jY79ngj+3gOHj8MMXXh2tjOPsynAXL+2qB1pl79TXQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgV-0000000HRBK-0JKM;
	Tue, 13 Oct 2026 15:36:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 10/10] wifi: mac80211: fix UHR Mode Change Tuples
Date: Tue, 13 Oct 2026 15:25:22 +0200
Message-ID: <20261013153640.52edf72dbc6c.I0a68bcc8690cf94b4243b3e89455b1fd2cc5be20@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013133640.270974-12-johannes@sipsolutions.net>
References: <20261013133640.270974-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

At least since D2.0 the mode change tuples are just a
single fixed octet, followed by an optional second one
and mode specific parameters when enabled. Fix parsing
and creation accordingly.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 49 +++++++++++++++++++++++------------
 net/mac80211/ap.c             |  8 +++---
 net/mac80211/mlme.c           | 20 ++++++++------
 3 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 1a1801783f2c..c6c89e4562f4 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -646,11 +646,14 @@ enum ieee80211_uhr_link_reconfig_notify_type {
 };
 
 enum ieee80211_uhr_mode_change_control {
-	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID		= 0x003f,
-	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE		= 0x0040,
-	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_UPDATE		= 0x0080,
-	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_LENGTH		= 0x0f00,
-	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_SPECIFIC		= 0xf000,
+	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID		= 0x3f,
+	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE		= 0x40,
+	IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_UPDATE		= 0x80,
+};
+
+enum ieee80211_uhr_mode_change_mode_length_specific_ctrl {
+	IEEE80211_UHR_MODE_CHANGE_MODE_LENGTH		= 0x0f,
+	IEEE80211_UHR_MODE_CHANGE_MODE_SPECIFIC_CTRL	= 0xf0,
 };
 
 enum ieee80211_uhr_mode_change_mode_id {
@@ -669,25 +672,39 @@ enum ieee80211_uhr_mode_change_mode_id {
 };
 
 struct ieee80211_uhr_mode_change_tuple {
-	__le16 control;
+	u8 control;
 	u8 variable[];
 } __packed;
 
-static inline int
-ieee80211_uhr_mode_change_tuple_size(const struct ieee80211_uhr_mode_change_tuple *tuple)
+static inline const struct ieee80211_uhr_mode_change_tuple *
+ieee80211_uhr_mode_change_tuple_next(const struct ieee80211_uhr_mode_change_tuple *tuple,
+				     size_t remaining)
 {
-	return sizeof(*tuple) +
-	       le16_get_bits(tuple->control,
-			     IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_LENGTH);
+	size_t needed = sizeof(*tuple);
+
+	if (remaining < needed)
+		return NULL;
+
+	if (tuple->control & IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE) {
+		needed += 1;
+		if (remaining < needed)
+			return NULL;
+
+		needed += u8_get_bits(tuple->variable[0],
+				      IEEE80211_UHR_MODE_CHANGE_MODE_LENGTH);
+		if (remaining < needed)
+			return NULL;
+	}
+
+	return (const void *)((const u8 *)tuple + needed);
 }
 
 #define for_each_uhr_mode_change_tuple(data, len, tuple)		\
 	for (tuple = (const void *)(data);				\
-	     (len) - ((const u8 *)tuple - (data)) >= sizeof(*tuple) &&	\
-	     (len) - ((const u8 *)tuple - (data)) >=			\
-		ieee80211_uhr_mode_change_tuple_size(tuple);		\
-	     tuple = (const void *)((const u8 *)tuple +			\
-				    ieee80211_uhr_mode_change_tuple_size(tuple)))
+	     ieee80211_uhr_mode_change_tuple_next(			\
+			tuple, (len) - ((const u8 *)tuple - (data)));	\
+	     tuple = ieee80211_uhr_mode_change_tuple_next(		\
+			tuple, (len) - ((const u8 *)tuple - (data))))
 
 struct ieee80211_uhr_parameters_update {
 	u8 countdown;
diff --git a/net/mac80211/ap.c b/net/mac80211/ap.c
index fe255891c35f..9a3122da84bc 100644
--- a/net/mac80211/ap.c
+++ b/net/mac80211/ap.c
@@ -271,10 +271,10 @@ ieee80211_rx_uhr_link_reconfig_req(struct ieee80211_sub_if_data *sdata,
 			for_each_uhr_mode_change_tuple(chg->data + 1,
 						       chg->datalen - 1,
 						       tuple) {
-				u8 id = le16_get_bits(tuple->control,
-						      IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID);
-				bool enabled = le16_get_bits(tuple->control,
-							     IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE);
+				u8 id = u8_get_bits(tuple->control,
+						    IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID);
+				bool enabled = u8_get_bits(tuple->control,
+							   IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE);
 
 				/* only handle DBE (for now?) */
 				if (id != IEEE80211_UHR_MODE_CHANGE_MODE_ID_DBE)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ba3c6ad590bc..91bd368acf62 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1549,7 +1549,7 @@ static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
 	       3 + sizeof(*mle) + sizeof(*common) +
 	       IEEE80211_MLD_MAX_NUM_LINKS *
 		(2 + sizeof(*per_sta) +
-		 3 + sizeof(*tuple) /* single tuple for each link */);
+		 3 + sizeof(*tuple) + 1 /* single tuple for each link */);
 
 	skb = alloc_skb(size, GFP_KERNEL);
 	if (!skb)
@@ -1603,7 +1603,7 @@ static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
 	memcpy(common->mld_mac_addr, sdata->vif.addr, ETH_ALEN);
 
 	for_each_link_data(sdata, link) {
-		u8 *subelem_len;
+		u8 *subelem_len, *mode_chg_len;
 
 		if (!(link_mask & BIT(link->link_id)))
 			continue;
@@ -1621,16 +1621,20 @@ static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
 		per_sta->sta_info_len = 1; /* includes itself */
 
 		skb_put_u8(skb, WLAN_EID_EXTENSION);
-		skb_put_u8(skb, 1 + sizeof(*tuple));
+		mode_chg_len = skb_put(skb, 1);
+		*mode_chg_len = 1 + sizeof(*tuple);
 		skb_put_u8(skb, WLAN_EID_EXT_UHR_MODE_CHG);
 		tuple = skb_put_zero(skb, sizeof(*tuple));
 		tuple->control =
-			le16_encode_bits(IEEE80211_UHR_MODE_CHANGE_MODE_ID_DBE,
-					 IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID);
+			u8_encode_bits(IEEE80211_UHR_MODE_CHANGE_MODE_ID_DBE,
+				       IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ID);
 
-		if (link->u.mgd.conn.dbe_enabled)
-			tuple->control |=
-				cpu_to_le16(IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE);
+		if (link->u.mgd.conn.dbe_enabled) {
+			tuple->control |= IEEE80211_UHR_MODE_CHANGE_CONTROL_MODE_ENABLE;
+			/* length 0 / nothing DBE specific */
+			skb_put_zero(skb, 1);
+			(*mode_chg_len) += 1;
+		}
 
 		ieee80211_fragment_element(skb, subelem_len,
 					   IEEE80211_MLE_SUBELEM_FRAGMENT);
-- 
2.56.0

