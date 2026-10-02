Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E730043B3E3
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926300; cv=none; b=j6/7ltDkm2Z/c3CvMhXlk0PFnND4/MmSkFUx0a6gR4B5MhGAr3rcYbwrJ4Gx6wqL1y2bj8HZpjJ6xfN0Yza61XJVIAGEV+BklZqo5J6vTQCWho9Hpx21kNY8o6vGsI2EIxv8x3GMXUJwiW2ApBjPpNhjpXZrqfaMRQY2eSnF0oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926300; c=relaxed/simple;
	bh=QAc8xqolKMhnFc4n2h5Lc4/VRYS9pH6wKkjG4TYq/OU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrinPltREErLXNrGczu0spv04+/W3pG9u27Vm8aDt2Ab2A3WSn0ydrYBzwYI2DH3rl2UNoVAcALvgT+xvnoReG4CnXrDon8q1HipqnLbs3gD46y5NSW/Y275JQlqtF7zUYV94kKhSRtYBlrLaTYLpyEHm9LFAYHqxtlPyMTmGXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=zDOIZWp2; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="zDOIZWp2"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccc02279so4376121a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 00:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790926293; x=1791531093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CfNgV+Movfd08NzXFyzavOI5VoeEpH3sAI7z4dm43oI=;
        b=zDOIZWp2OSXu9FFUQZET8XtEBKlD84TbdcNCFmu9raQSC+/zrFuNefOPGxc0yK9SK4
         /ZC8jBeSuHtMGltnJQYtnkZnNPXi2chh+qAhK8pVh3PgNZyzDPeM3mQ9Nz2Mp2ZScCUt
         +tkv0XaJtYNI1u5qayLgEz1ZoeNkqV+PzLSSMhbaTZJD67wrPq1roQ1CIIGncgkoE1WS
         o68ouRQlMLmGssnFElGq5zNtbVqlDq/5JKDkBO0wHw/acJQQoV/7hm2uvntWfQdnP95l
         2FNZQw61ZP/OfTJz8cD+qgpGEnJiMOgcz8ophg0nFaI8sDMzszWMDsGHcf89/h6C8zB/
         6C7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790926293; x=1791531093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CfNgV+Movfd08NzXFyzavOI5VoeEpH3sAI7z4dm43oI=;
        b=NyXYUvayNDQZCy56znibeO4Q0Qi7/tQg3jQ48QSNG0QIdvrzOUxsL96XprjoI7OMeo
         OlsUFvu9s6HwEJ38RxGHkugC5bIMNeNT2/O/HFLu72NuSVTMB4aSaRQ3EnQKfWO/Kk76
         F8AO2lSyFP5WD4nQWGnrLscJ1fh1giv863N/emO4o9tlkaPFLQ/X2BAlUyheALv25r0o
         eLSG6PCudpxUHGCthLXLopj84dEZNpR6sfY5x6EnoIZzsn6wEpPgQ9ilAm6wFDWjl41A
         U0yY+IiD3hDq4NQlwqK5A+rL329vP0L2wrnlpwcOVlluygpJaidof9kE3E0DT2jnTEZn
         GlYw==
X-Gm-Message-State: AFq9FYIawFaABrVF7AtE0idQcasz6FMUlfsy53822zoTgYF29WC3WMJt
	Y3YYSWWsh/UIwSrqqcrW9DAIp+AhCArRmKSpbhOHS5abkujEchZoLs1qe+k9zc6XmQQuiEdKztf
	6aILmis8=
X-Gm-Gg: AYBFou1UqsJToSQ4Gaxjzu+Cbsh1ml2Nx5liovaJ48riE6QlTHs8luApESqmvoyaXX8
	N5TwOpjQd1QFzN1X6v7NE22A+hIhy1tuquh1zkJdaN73sZTUg/hfCoxjXpY1xQVX8BL57ozxRy1
	rwuhf4S1piszm2NErgHW16Y2F3/nz5iVIsNDUSAwV9a4DTCU5RwqWSZrWhBXg0aWABayCTdkm3N
	aFco8UF04lyOBvP7fHfDw/0cHT717cUXKMYGugFFaE8WzRfQ8ASuTY3AVzcGAiG1+h1xDRYxh78
	LeKVIZvj6wkJurFwb9P1RVHU5eeRy85iZDn22YTPsJA3AeNPvuLIO/952TqWY/ZDjvRILUBwthX
	UdqiLvEpHEW2FcWDNMwmQP9bUD7fUe/sdCohrpxsqHadkIU8LpKCwkDM3wnBql//0E+WTgY4cZ/
	g21opgI98S3V/y9YvV/5AgOIH7WlzWM65R9pm2NiGuhXhEaM6f/mY3a+NoD5vZD6v++KBXRcYcv
	zArz3v7Ll2qdDmKQr5imagwG4cxA7Hlp84tHXCUEAZV0DjehvXXrwlksnJQX4cm9+qjhISvoKx/
	9v0=
X-Received: by 2002:a17:90b:2f45:b0:3a4:f146:5440 with SMTP id 98e67ed59e1d1-3a6ce98e12emr2063814a91.60.1790926292356;
        Fri, 02 Oct 2026 00:31:32 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc9f7383535sm583243a12.20.2026.10.02.00.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 00:31:32 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	benjamin.berg@intel.com,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH RFC wireless-next] wifi: mac80211: correct rx freq handling for S1G
Date: Fri,  2 Oct 2026 17:29:54 +1000
Message-ID: <20261002072954.1168872-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6d531b9af16e ("wifi: mac80211: rework RX packet handling") reworked
Rx frame handling with a specific focus on MLD, but it also introduced
some changes for non-MLD interfaces. Previously when a station was
looked up (either because the driver did not pass one or handling
a management frame) it was done via hdr->addr2 and that was it. Now
the received frames frequency is validated against the links
control channel alongside the station lookup.

S1G has a unique feature where the control or primary channel can
either be 1MHz or 2MHz. However there is _always_ a 1MHz primary.
S1G drivers advertise these 1MHz primaries but it means if a 2MHz
primary is used the control channel inside the chandef may not be
the channel used to pass management frames. As a result, the rework
causes the following two issues on an S1G link:

1. When data frames are passed to mac80211 without a station (for
   example using ieee80211_rx_ni()) the frames rx status frequency
   is compared against the 1MHz control frequency used by the link
   via ieee80211_rx_valid_freq. Since the rx status reported is of
   the center frequency of transmission (i.e either the operating
   channel or the 2MHz primary in the case of multicast/EAPOL etc.)
   these frames are _all_ dropped.

2. In the case of protected management frames such as ADDBA, deauths
   etc. the station is always looked up so it does not matter if a
   station is passed from the driver, the frequency conversion against
   the 1MHz control channel will always fail and these frames will be
   dropped.

For regular, unprotected management frames such as assoc requests,
auth etc. these frames don't depend on a station and are matched via
BSSID so are unaffected by this change.

To fix, we can reuse the logic implemented in 31e7681da78d ("wifi:
mac80211: correctly initialise S1G chandef for STA") where we find
the sibling 1MHz and calculate the 2MHz center frequency. For the
ocassional protected management frames this is fine, obviously it
is still ideal for drivers to pass the station directly to mac80211
such that the lookup avoids needing the extra work of finding the
2MHz center frequency.

Fixes: 6d531b9af16e ("wifi: mac80211: rework RX packet handling")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---

A followup question:

1. is rx_status->freq always meant to be the control channel? For
   management frames obviously makes sense but for data frames
   sent on a wider channel wouldn't this be set to the operating
   channel? Especially for i.e sniffer? The mm81x driver reports
   it like this but maybe it should just report the control channel?
   I guess my confusion stems from that if we have a data frame
   wouldn't we compare against the chandefs frequency? Or am I
   misunderstanding something?

Thanks,
lachlan

---
 include/net/mac80211.h     |  2 ++
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 36 ++-----------------------------
 net/mac80211/rx.c          | 43 ++++++++++++++++++++++++++++++++------
 4 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb9f8e14b3b6..b2a7857f9503 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1741,6 +1741,8 @@ enum mac80211_rx_encoding {
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  *	This field must be set for management frames, but isn't strictly needed
  *	for data (other) frames - for those it only affects radiotap reporting.
+ *	For S1G, when operating on a 2MHz primary channel, this may be the
+ *	center frequency of the 2MHz primary rather than the 1MHz primary.
  * @freq_offset: @freq has a positive offset of 500Khz.
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1430527d216c..2ad93cb462ad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2012,6 +2012,9 @@ void ieee80211_clear_fast_rx(struct sta_info *sta);
 
 bool ieee80211_is_our_addr(struct ieee80211_sub_if_data *sdata,
 			   const u8 *addr, int *out_link_id);
+bool __ieee80211_rx_valid_freq(struct wiphy *wiphy,
+			       struct ieee80211_rx_status *status,
+			       const struct cfg80211_chan_def *chandef);
 
 /* AP code */
 void ieee80211_ap_rx_queued_frame(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3a17d1ccd32a..8a07d14b4c43 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8091,38 +8091,6 @@ static bool ieee80211_mgd_ssid_mismatch(struct ieee80211_sub_if_data *sdata,
 	return memcmp(elems->ssid, cfg->ssid, cfg->ssid_len);
 }
 
-static bool
-ieee80211_rx_beacon_freq_valid(struct ieee80211_local *local,
-			       struct ieee80211_mgmt *mgmt,
-			       struct ieee80211_rx_status *rx_status,
-			       struct ieee80211_chanctx_conf *chanctx)
-{
-	u32 pri_2mhz_khz;
-	struct ieee80211_channel *s1g_sibling_1mhz;
-	u32 pri_khz = ieee80211_channel_to_khz(chanctx->def.chan);
-	u32 rx_khz = ieee80211_rx_status_to_khz(rx_status);
-
-	if (rx_khz == pri_khz)
-		return true;
-
-	if (!chanctx->def.s1g_primary_2mhz)
-		return false;
-
-	/*
-	 * If we have an S1G interface with a 2MHz primary, beacons are
-	 * sent on the center frequency of the 2MHz primary. Find the sibling
-	 * 1MHz channel and calculate the 2MHz primary center frequency.
-	 */
-	s1g_sibling_1mhz = cfg80211_s1g_get_primary_sibling(local->hw.wiphy,
-							    &chanctx->def);
-	if (!s1g_sibling_1mhz)
-		return false;
-
-	pri_2mhz_khz =
-		(pri_khz + ieee80211_channel_to_khz(s1g_sibling_1mhz)) / 2;
-	return rx_khz == pri_2mhz_khz;
-}
-
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 				     struct ieee80211_hdr *hdr, size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -8176,8 +8144,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		return;
 	}
 
-	if (!ieee80211_rx_beacon_freq_valid(local, mgmt, rx_status,
-					    chanctx_conf)) {
+	if (!__ieee80211_rx_valid_freq(local->hw.wiphy, rx_status,
+				       &chanctx_conf->def)) {
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3990b7a7299..9a29928a3a52 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5318,11 +5318,41 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	dev_kfree_skb(skb);
 }
 
-static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
+bool __ieee80211_rx_valid_freq(struct wiphy *wiphy,
+			       struct ieee80211_rx_status *status,
+			       const struct cfg80211_chan_def *chandef)
+{
+	u32 pri_khz = ieee80211_channel_to_khz(chandef->chan);
+	u32 rx_khz = ieee80211_rx_status_to_khz(status);
+	struct ieee80211_channel *sibling;
+
+	if (rx_khz == pri_khz)
+		return true;
+
+	/* Any non-S1G case from here is not a valid freq */
+	if (!cfg80211_chandef_is_s1g(chandef))
+		return false;
+
+	if (!chandef->s1g_primary_2mhz)
+		return false;
+
+	/*
+	 * Find the sibling 1MHz channel of the 2MHz primary to calculate
+	 * the 2MHz primary center frequency.
+	 */
+	sibling = cfg80211_s1g_get_primary_sibling(wiphy, chandef);
+	if (!sibling)
+		return false;
+
+	return rx_khz == (pri_khz + ieee80211_channel_to_khz(sibling)) / 2;
+}
+
+static bool ieee80211_rx_valid_freq(struct ieee80211_rx_status *status,
+				    struct ieee80211_link_data *link)
 {
 	struct ieee80211_chanctx_conf *conf;
 
-	if (!freq || link->sdata->vif.type == NL80211_IFTYPE_NAN ||
+	if (!status->freq || link->sdata->vif.type == NL80211_IFTYPE_NAN ||
 	    link->sdata->vif.type == NL80211_IFTYPE_NAN_DATA)
 		return true;
 
@@ -5330,7 +5360,8 @@ static bool ieee80211_rx_valid_freq(int freq, struct ieee80211_link_data *link)
 	if (!conf || !conf->def.chan)
 		return false;
 
-	return freq == conf->def.chan->center_freq;
+	return __ieee80211_rx_valid_freq(link->sdata->local->hw.wiphy, status,
+					 &conf->def);
 }
 
 /*
@@ -5430,7 +5461,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				continue;
 
 			link = &sta->sdata->deflink;
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!ieee80211_rx_valid_freq(status, link))
 				continue;
 
 			if (rx_data_pending) {
@@ -5454,7 +5485,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			sdata =	sta->sdata;
 			link = rcu_dereference(sdata->link[link_sta->link_id]);
 
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!ieee80211_rx_valid_freq(status, link))
 				continue;
 
 			if (rx_data_pending) {
@@ -5524,7 +5555,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		 * RX using the station.
 		 */
 		if (link_sta && link &&
-		    ieee80211_rx_valid_freq(status->freq, link)) {
+		    ieee80211_rx_valid_freq(status, link)) {
 			if (rx_data_pending) {
 				ieee80211_prepare_and_rx_handle(&rx, skb, false);
 				rx_data_pending = false;
-- 
2.43.0

