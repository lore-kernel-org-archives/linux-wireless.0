Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657665;
	b=4eDmrbRMURWAx+3Y/VtMwPEodxmWnFf1piw9EcSVRUKgi2l6em9x43YSQ7X4i3YYfT9e
	 uVoCkD6tVV+iHkbBQv68DPZxR8EdVr8pc8mpL+aqy480BegEew4xnuuloUsgqcctpyiAH
	 2oEXBWSvDAV/06AY4uenlpkPvS0K+zq+0uF/tOjXgNOSt87ABIXVT/PfNW9Il+Ca0dmvp
	 KhpTp4b5O9CsxUdcZn8c8ClYm3JMxE1pwTBtd2cGvyOHR7Kyjbkhn8QNjs26w5BZEHzVX
	 EtE6EnI5HkA1KhhWYbpiLyOHid7+p3JJgb5Rotu9NY1PMoglAc9evJSZBGuBlFhyNdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657665;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILf63+xkNPHQ4126QQZcu+0mjcEJemAjqi/VnEaKeSo=;
	b=YXtJpze4Y++VWqHVCacb+ddF5T+zUL529BULPVHiDe6ThVFam6fMYVHEMKxY6tOj1Clq
	 JNVPpv28LdCD8Y/na396jqoTCgVft/3pC3VAdXWwajeBWDejA0o/MofnNJucAAnvTMnz7
	 hF/vK+LZ6YEVGJZN5yIcDnd83xK6vs1fj2R2OP0/8jJjyfeLKg04z9Hx6Rh6SIMxHIlR9
	 SmGEWjlq0nIrv/EDpqmENrHRprbO5gtKYygqrZNO1WoCQIdXyBA0IrPjf/cEcQ7zSDI9C
	 /iTI+0tlQjatqx3X3hVdhHR3Jeme/bBGRWomFBqJo/vTuo6hTCx+x6xBphl6kxhdmrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kr6NPXin;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D404606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=kr6NPXin
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=ILf63+xkNPHQ4126QQZcu+0mjcEJemAjqi/VnEaKeSo=; t=1793657664; x=1794867264; 
	b=kr6NPXin/qyfVvwKcvLcDCl9MFzzvRUBLdTeLk4Lwm6fzGhVLDRdhupVlwZTmWPYN4vHmrnbsEP
	6tGes8hPyi50lM8uM6EIfkhQ7TRadtPK3JYBXEMn+nTa/2nIPdqTyWWejyhCS0EbE8DYaX+IZtjj2
	SREmI9P9TY3Y27AM+gpHmY1BwWp+vSByfRtlhkLOaWZdEmqjK4P5iIdlD0/iW0bd1uRRjbICdWLaB
	j5O81LQHF0ra6g8+BmlFDscw4Z3SNTvAOHdl7ZVAPPD+Nq4imFe9pYqVxCO+LIy7OyyN0VQLvpppU
	A6We9T3TVQAxTkhLk0ne1LBDwaFgTp1qQBNA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0IH-000000023Es-1sNE;
	Mon, 02 Nov 2026 23:14:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: move flush fallback into drv_flush_sta()
Date: Mon,  2 Nov 2026 23:14:19 +0100
Message-ID: <20261102231419.4ba107276a39.I8e484338e2eac6a6ac782069d76816aa919282d5@changeid>
X-Mailer: git-send-email 2.56.0
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

From: Johannes Berg <johannes.berg@intel.com>

When the flush_sta operation doesn't exist, the code
falls back to flushing the interface queues. Move the
fallback into the drv_flush_sta() wrapper to have it
available to future callers too.

While at it, pass the right sdata.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.c | 25 ++++++++++++++++++++++++-
 net/mac80211/driver-ops.h | 25 ++++---------------------
 net/mac80211/sta_info.c   |  7 +------
 3 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1f3e0765a8ab..f3d0b39720e9 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright 2015 Intel Deutschland GmbH
- * Copyright (C) 2022-2025 Intel Corporation
+ * Copyright (C) 2022-2026 Intel Corporation
  */
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -709,3 +709,26 @@ int drv_link_sta_statistics(struct ieee80211_local *local,
 
 	return 0;
 }
+
+void drv_flush_sta(struct ieee80211_local *local,
+		   struct ieee80211_sub_if_data *sdata,
+		   struct sta_info *sta)
+{
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	sdata = get_bss_sdata(sdata);
+
+	if (sdata && !check_sdata_in_driver(sdata))
+		return;
+
+	if (!sta->uploaded)
+		return;
+
+	trace_drv_flush_sta(local, sdata, &sta->sta);
+	if (local->ops->flush_sta)
+		local->ops->flush_sta(&local->hw, &sdata->vif, &sta->sta);
+	else
+		ieee80211_flush_queues(local, sdata, false);
+	trace_drv_return_void(local);
+}
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 78230779e7fb..0edaaab7ac52 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -2,7 +2,7 @@
 /*
 * Portions of this file
 * Copyright(c) 2016 Intel Deutschland GmbH
-* Copyright (C) 2018-2019, 2021-2025 Intel Corporation
+* Copyright (C) 2018-2019, 2021-2026 Intel Corporation
 */
 
 #ifndef __MAC80211_DRIVER_OPS
@@ -710,26 +710,9 @@ static inline void drv_flush(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_flush_sta(struct ieee80211_local *local,
-				 struct ieee80211_sub_if_data *sdata,
-				 struct sta_info *sta)
-{
-	might_sleep();
-	lockdep_assert_wiphy(local->hw.wiphy);
-
-	sdata = get_bss_sdata(sdata);
-
-	if (sdata && !check_sdata_in_driver(sdata))
-		return;
-
-	if (!sta->uploaded)
-		return;
-
-	trace_drv_flush_sta(local, sdata, &sta->sta);
-	if (local->ops->flush_sta)
-		local->ops->flush_sta(&local->hw, &sdata->vif, &sta->sta);
-	trace_drv_return_void(local);
-}
+void drv_flush_sta(struct ieee80211_local *local,
+		   struct ieee80211_sub_if_data *sdata,
+		   struct sta_info *sta);
 
 static inline void drv_channel_switch(struct ieee80211_local *local,
 				      struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..5e46dcd2ae82 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1489,12 +1489,7 @@ static int _sta_info_move_state(struct sta_info *sta,
 			 */
 			if (local->ops->set_key) {
 				synchronize_net();
-				if (local->ops->flush_sta)
-					drv_flush_sta(local, sta->sdata, sta);
-				else
-					ieee80211_flush_queues(local,
-							       sta->sdata,
-							       false);
+				drv_flush_sta(local, sta->sdata, sta);
 			}
 
 			ieee80211_clear_fast_xmit(sta);
-- 
2.56.0

