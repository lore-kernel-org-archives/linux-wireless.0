Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD2D50B437
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898617; cv=none; b=BpOwKwUdIiPggvaFOksgfZHMU2H3+gNu+CdKwXN4TkMOExkA7itb8q13XKyUevkDA8e3B3Qd7C890hp/khvrJgv915Iao/jwanI1p+QAxWG+4LtpnOiWWWXyWh+xMmGNXNVtY7taK2P+u+sWKDuMjAWTR8Fhb1PQhiElY4Olf6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898617; c=relaxed/simple;
	bh=YwK8kV8m0+KDvkT0Igh4gwMM5lng/VseIL+orDRDLjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDaZAj9nyMzzf36uOdQOrBExoQgjMb1ZROp2lFgYyg7dChPt7HxoUj5jxKOQASnhdxZ0CMnT7I+QjTeiF4qAt3AlYY++4D1B+MJNPc5ibljwmb+6wnt3maXnsRwduHIGtjBHxh+rQZZAPwQjqHasEdOeg4DjCrZJEKmLSJlAx8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LAQYTqMz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LAQYTqMz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=TUtS6bODoHWqlxOg8+udxZB9NnZ0q+ReKy97E+mQA18=;
	t=1791898614; x=1793108214; b=LAQYTqMzFRJ8PaNqdUHpsl0yNhvJv2SF63L9EQ0WZv2lLOB
	TXuDwLRXxeIhFYe2Cf4FmaXhGJrvYlCvFc5v+Gwq8IUpQDsDrArVZJDUVqYCygbB+0/LMhI35MX4j
	u0awlhaUxgPcOQdN+KhSFhGu/Rezv8DfA49ptrsXm+NLHXtbI6MSpZklOIcHHvRv2CyciLNuQRq6Q
	inoi3pbu4jmU2hFyIL6Kc7Lwa7nk+j13JQ4okmtovRiU3290E1UpUNOwDyMTd0QOagC8NLYkpTvzM
	6tnOGj3SW1bvnEkni/vU66yeGUk6jp2gBXpjTctvOnhWE0dgrnPXlnu9rmx9wfsQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgQ-0000000HRBK-1eDy;
	Tue, 13 Oct 2026 15:36:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 04/10] wifi: mac80211: don't apply NPCA/DBE while being disabled
Date: Tue, 13 Oct 2026 15:25:16 +0200
Message-ID: <20261013153640.44d0b018547d.I688322203e8516243ab484cb9fd9aebcf50dbe8c@changeid>
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

If during association NPCA or DBE are currently enabled
but in the process of being disabled via UHR Parameters
Update, don't enable them in the first place.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b17fd100f657..eebdd8a12f52 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -194,11 +194,14 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	const struct ieee802_11_elems *elems = data->elems;
 	const struct ieee80211_uhr_operation *uhr_oper = elems->uhr_operation;
 	struct cfg80211_chan_def *chandef = data->chandef;
+	const struct ieee80211_uhr_param_update_tuple *tuple;
 	struct cfg80211_chan_def npca_chandef = *chandef;
 	const struct ieee80211_sta_uhr_cap *uhr_cap;
 	const struct ieee80211_uhr_npca_info *npca;
 	const struct ieee80211_uhr_dbe_info *dbe;
 	struct cfg80211_chan_def dbe_chandef;
+	bool npca_being_disabled = false;
+	bool dbe_being_disabled = false;
 
 	if (elems->frame_type == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
 		int dbe_bw_mhz;
@@ -228,6 +231,26 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	if (!elems->uhr_cap)
 		return false;
 
+	for_each_uhr_param_update_tuple(elems->uhr_param_upd,
+					elems->uhr_param_upd_len,
+					tuple) {
+		u8 mode = u8_get_bits(tuple->control,
+				      IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID);
+
+		/* ignore enabling/updates - handle from beacons later */
+		if (tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE)
+			continue;
+
+		switch (mode) {
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+			npca_being_disabled = true;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+			dbe_being_disabled = true;
+			break;
+		}
+	}
+
 	npca = ieee80211_uhr_npca_info(uhr_oper);
 
 	if (npca && !(elems->uhr_cap->mac.mac_cap[0] &
@@ -241,7 +264,8 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
 					 &npca_chandef, npca) ||
 	    cfg80211_chandef_add_npca(sdata->local->hw.wiphy,
-				      &npca_chandef, npca)) {
+				      &npca_chandef,
+				      npca_being_disabled ? NULL : npca)) {
 		sdata_info(sdata,
 			   "AP UHR NPCA settings invalid, disabling UHR\n");
 		return false;
@@ -252,8 +276,10 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(!uhr_cap))
 		return false;
 
-	if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)
+	if (uhr_cap->mac.mac_cap[0] & IEEE80211_UHR_MAC_CAP0_NPCA_SUPP) {
+		/* no-op if NPCA wasn't present or being disabled */
 		*chandef = npca_chandef;
+	}
 
 	dbe = ieee80211_uhr_oper_dbe_info(uhr_oper);
 	if (dbe) {
@@ -312,6 +338,9 @@ ieee80211_determine_ap_chan_uhr(struct ieee80211_sub_if_data *sdata,
 
 	dbe_chandef = *chandef;
 
+	if (dbe_being_disabled)
+		dbe = NULL;
+
 	if (cfg80211_chandef_add_dbe(&dbe_chandef, dbe)) {
 		sdata_info(sdata,
 			   "AP UHR DBE settings invalid, disabling UHR\n");
-- 
2.56.0

