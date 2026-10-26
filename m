Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792987117;
	b=taa6qoIZeUNj/6Hj/Kzioy3NEfDLKoDQGLo+AuCs9Y4Yqbi2QJdeoZ9WrwG851Puu0w/
	 4HebYPevATFieOeMGXyFb9JEXCE8kV+yYoZv7r+YVOey691zOktx/MfODTgJq0VVTlA7Q
	 fGPIwtAm5WdUBEAfgNQXV2SCDcxK+GG5ukPx/zwo4G1JF+2IRnILHQ2dgd8Nu1NIqdTah
	 dO1WpRzo7JEZzbD6JSpURmEpR7b5BjI7EWwUzMUfiZI3J9sN4l/hCCUP5rKWveNP1KUyO
	 ASs9QN88K0JV/VQtIeyPbABUGXEAt7pQYJJoQp6V+RYRfS4+8/iAAT9u8vVGZvJXv8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792987117;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4CMPivMj5lPjl2wG/BuDRaWBDMCf5JHQJ05QDbYwmzA=;
	b=j1vqgzjIz2WKEZu52EBUz+SFHdeP2//SWhF7Q3O3ya6iwLH/JQVDLxc0UI8deFlskPFH
	 YRiZFDb+mznnWfcT+mEr2KHnyvCv/1bFki7Za8huJRyvo3iLPfoytZt0eUIZy6aF/huvb
	 jSTQofReg0NZU/ej2zEMrufnffYnhGwdcdGum0Iq3ftFwNLdZaQP4YNclodSsg57Jesca
	 bl4xnwrXQTk34ICmB8v8SCB1naCRrFd2mW6X8m/hg8kpc2cd7Yei4x3mjk5xEetYGv/Ky
	 vimppIC3Tqq6ta9b1gdyyegEkkY6M+iudsWM0f51MVEt2B7VbMSHOxKtMW2MXkiv0Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oCXOCegf;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6896A606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 03:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6896A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oCXOCegf
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so4309239eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 20:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792987116; x=1793591916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4CMPivMj5lPjl2wG/BuDRaWBDMCf5JHQJ05QDbYwmzA=;
        b=oCXOCegfXtSJnIur9YIJyxMDv7keBYCBjuq7AVdDTAh/4F6DAzfQQe0n8p4rb+Oa80
         Bkp74PGWnQ23Rb/jGswQChL2d8asovc1Di0c35Fc/OGdXZws9q5gL2wmZRXXkw1f+SfW
         jKJrBPiCQH9yp2HCr7KJqktINFKeAiY5pQdX2wU6VCmcRvE5ocu1B/9ue1L5awD+wn8T
         hhOEhDovFmwX/A8ghtMDNmApmra6ibY9XnaONvAhLnP5/wP3gKi1KYNQTwnN+rMjZidC
         ItAK+oCqTxdmqc9cjMUeHoRZRI6Q6YHTKEkfmPuRd5xUg01K3TNLQBvYWwF/t3ChVwWY
         W6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792987116; x=1793591916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4CMPivMj5lPjl2wG/BuDRaWBDMCf5JHQJ05QDbYwmzA=;
        b=h0YoKNiStXZCnbGn9+dZppxb3OGU0Kigg7HtCmEtriLsFx5zr/ItzySk32QopFsk8o
         lh9e4Noce3lQ579OOXQ7iIukuWrkTR2RTHgwG4l8olAKA4dnK5SCijKSynRwPSkeTd7F
         hTs3WOLupi/doeiY4FLOj5g2BjhmxGsFA9OITL80pfIxV/sAUATbOCofKE5P7L+Dlhfo
         4bLeS4u3dCwsLN2OFkDJ2Uk6Ep5omysC53cquSv1QwfRFci4qpQFFADELNGmH1RETRqR
         SW1W8SrqNpb4SCielD3lxon/EN8kXYC0kWPt3cFcMHy9nI5YbU3MuqJSE0Gco0KZQrSo
         YF0g==
X-Forwarded-Encrypted: i=1; AKwUvBytbQcoXhcmLCyQXa7BL4+GD+IaINKw86SntFXLCCsbGT2mjWfW9esmbqvzbgEfQaAdmyU1+s8BW4h94IcKrw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIsK/k4uHRVhT1osXCg45OVFEbpSU471tLxMml0EYrY1phK2aza
	jhKuM9tSDRnY7GqPay0BzVgO9WKEwGzfWeuqP6sd1vTQmIPG8bYO4RLvkn+Q6yHX
X-Gm-Gg: AYBFou1vw4MxQCPxWmjU1VwMoTtd6aERyvWEjO0rDToBpQbsROtxVd0kugR7IrKR5Lv
	DpWJKQqQcs/6KHfq2uZ0HQdRAfs6Mub+SRnW7oaVFIys7EWCnc1sjliWxyqBPgHqirG9SyKeyqi
	BGOf4suSMFP8/3Bt5SiXJxw4XSvoBOYadDD79rsITXJ8kKRMkACS6tktxygu3EHsTfVz5mM8GNq
	RiaasOWWtgGbBvcdRw2uCdp0IfsNdBP7ONYgCLGfcrnkAPZtYSY8XaNz4AJsX976IyGRqs+I0Py
	2plIYxgHrAg2AaTiqcS2jdeMFcaEzCZcA71fmyDmHewp6eNlT1quNNmEJYJoDzAwZ1e1zwQsvO+
	PKR9HGDUfCOanftLEorTSIn5P5A0maGhuqNBMPPHJZFy/1Oj35ePQ4NfAKE0FFaDiyfgebBibEt
	3cFiKJu02hdEnA4AhhT50Q7n1FAOc2m0wXwOQK1FNPpU5Jn6ib851gVVSAqTPMQ9pMTdKYF1DPu
	iC7MAJJE8IXJ1ieHWBJoy4pEYN5QbzaQGPKoMg/U7ZxjW53mFk4aDtDc9uM/T3c4AAtjplQWJo7
X-Received: by 2002:a05:7301:3a9c:b0:367:50ee:f7e0 with SMTP id 5a478bee46e88-369e86148fcmr8329355eec.39.1792987116386;
        Sun, 25 Oct 2026 20:58:36 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8db7e73sm21652837eec.20.2026.10.25.20.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 20:58:35 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next] wifi: cfg80211/mac80211: apply HE OBSS PD settings on beacon update
Date: Sun, 25 Oct 2026 20:58:03 -0700
Message-ID: <20261026035803.2630025-1-dencity7@gmail.com>
X-Mailer: git-send-email 2.47.3
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

hostapd puts NL80211_ATTR_HE_OBSS_PD into NL80211_CMD_SET_BEACON as well
as NL80211_CMD_START_AP, but cfg80211 parses it only when the AP starts.
A change of the spatial reuse parameters therefore reaches the beacon
but not the driver, and the only way to apply it is to restart the AP,
which disconnects all stations.

Parse the attribute in the AP update path and apply it in
ieee80211_change_beacon() when it differs from the current settings.

Assisted-by: LLM
Signed-off-by: John Macias <dencity7@gmail.com>
---
Tested on OpenWrt (backports 7.2) with hostapd changing he_spr_sr_control and
he_spr_non_srg_obss_pd_max_offset at runtime (SET + UPDATE_BEACON):

- ath11k (IPQ8074): without the patch the driver is never called; with it,
  ath11k reprograms the OBSS PD threshold on every change.
- ath12k (IPQ5332 + QCN6432, and QCN9274): toggling non-SRG OBSS PD at
  runtime turns the firmware's spatial reuse on and off (htt_stats
  OBSS_PD_STATS: 0 -> 74 -> 0 non-SRG opportunities in 15 s runs).

 include/net/cfg80211.h | 3 +++
 net/mac80211/cfg.c     | 7 +++++++
 net/wireless/nl80211.c | 7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f773856c1..e373fb32d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1668,12 +1668,15 @@ struct cfg80211_ap_settings {
  * @fils_discovery: FILS discovery transmission parameters
  * @unsol_bcast_probe_resp: Unsolicited broadcast probe response parameters
  * @s1g_short_beacon: S1G short beacon data
+ * @he_obss_pd: OBSS Packet Detection settings, applied if @he_obss_pd.enable
+ *	is set
  */
 struct cfg80211_ap_update {
 	struct cfg80211_beacon_data beacon;
 	struct cfg80211_fils_discovery fils_discovery;
 	struct cfg80211_unsol_bcast_probe_resp unsol_bcast_probe_resp;
 	struct cfg80211_s1g_short_beacon s1g_short_beacon;
+	struct ieee80211_he_obss_pd he_obss_pd;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9608c07bc..619052ebd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2118,6 +2118,13 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 		changed |= BSS_CHANGED_HE_BSS_COLOR;
 	}
 
+	if (params->he_obss_pd.enable && link_conf->he_support &&
+	    memcmp(&params->he_obss_pd, &link_conf->he_obss_pd,
+		   sizeof(params->he_obss_pd))) {
+		link_conf->he_obss_pd = params->he_obss_pd;
+		changed |= BSS_CHANGED_HE_OBSS_PD;
+	}
+
 	ieee80211_link_info_change_notify(sdata, link, changed);
 	return 0;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d790e204a..38a707aca 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7708,6 +7708,13 @@ static int nl80211_parse_ap_update(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
+	attr = attrs[NL80211_ATTR_HE_OBSS_PD];
+	if (attr) {
+		err = nl80211_parse_he_obss_pd(attr, &params->he_obss_pd);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.47.3

