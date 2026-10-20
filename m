Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792481273;
	b=ImnbybOq469gE4rxloipMG/g4NUcqTz+6deNKVRwfORNANv4r0O4pYaESuMWlO5YYN5W
	 bZqOFhz+BVW4E+tIkzD6/B+e48VxyXhOKqqEVyfsIk+Nv0TQM41ms0JoBj2HU+suugwaT
	 pkV/y8ES9iv49papPGv9dqqjwoP2OLkmicxSAaoKep88hsgPoDOVaRRNo6P9w1I8nADx6
	 9qpE2Zvrwi4nw4i+cm2NTDtSgcgOgkOLeK1TcGTN+ezq/E4taf/7fB1EIg+oSV1/zGXw2
	 gAV9+GSJpSV4BnSMs/TvDYm6zNHWSg8Q04xiad8A2RO8SwdYg/3vZeZqiNTg9srFLaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792481273;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5gyxteyqC/XSbkUMoXJxSrRym4eYIwlmz8NIHe1F1rY=;
	b=yZXpd3wF/T/kces92iwSrXm7/6jzC4LEe0uOjVD6lnU2Hdmzdzws4U+OaI745zO83IHI
	 o8dYdyd1wr7/tCc9/6x0DmQRRevY3csEMZyX1zvNfPAQEsLN3mxYv1nTiyiX9Gz3LQu8v
	 3i8tn1cBcvN8w7xTabmmZz8yh/VAvzsqMLQs+mGO4YLFEJL+khiMJahdCDUT0jIo0BXu0
	 JFPZwwuDPKBH8h6Ru14z5yFUOVB5DvEw/bm0JAOxd1ujJ5tere8g1P9Fu3FdTI7YzzTdP
	 J5Do3riXLYf6H+A8YK2SjvL5ljIet25lx+RFDpf+/J9NIf8ofJyYoMX9oc/cT3xgfkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lbB2HP9w;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3E8606A32E
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 07:27:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE3E8606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=lbB2HP9w
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso968692a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 00:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1792481272; x=1793086072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5gyxteyqC/XSbkUMoXJxSrRym4eYIwlmz8NIHe1F1rY=;
        b=lbB2HP9wObIR+/95KwfZWannwlInnVJYWEVTbHx0qdlLg/9wYfqrqUxR0XlQ9gwLht
         fdGi3U9gkBnxg1S0whK1Xmfro6jXnnDZ+Mrgt3vA9emFl7pmX1l5yZFAFKXu2aK/EFGt
         nbGjIO5elfugJnM+E9+DcFnh/5b5yLyVSlwkOPOEfoMLaIFB7Vy7FRRb2XdsK95ieFKF
         vnWw+wffTYvV1z3Xfv+zsRYZ+I/pxenWjP37Cunn86bp8jghWPU577vGxVgLG1YwiBzm
         zu20R8VAUTGjKqPVgmU1US7JH8Kl+ASGv8DkFH821C18T4rKoUaMEHDqhJraXEbfTzJB
         qXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792481272; x=1793086072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5gyxteyqC/XSbkUMoXJxSrRym4eYIwlmz8NIHe1F1rY=;
        b=DoZ4kQKv1igydann3XX/8HFoOpoB+8BSqWJh9CYpBWQmSAQVJ5gVlAtN5Uv4zpaGUM
         ULTj+oMmmhBWxMgCNINu1sa5+jQ//XmxmqaTTFGvmSHrKCUE1ryb4sGChffUbbFwLjGz
         AVvSu0eVrqBAknaiyPj1X0j2huMvmF/cYp+0lwJL5Nl+teiv/ig/YORF07h8koxVfkDF
         ul80tdYrZ+VJpZQTno5RKZzeoMUMID7F6O3aPzfEcaF030uQmELdgH8BXb0TPkmc3Zus
         CQgrvHl56KqTt3KHGZMblVDlZUXPTh9OAmYBOTeuPeCDHJQdz8TgOyCze9UbBaDdmEdu
         21hQ==
X-Gm-Message-State: AFq9FYKNWAehJLMaHAqRkTtG6UqoTRebQrnaVNXFt2hr14XTtxO63feO
	4KWOY3QzG8sjsnXxDKsIyJAN5nO0RD1jYS18+sr+ZSxr5G6rZbuLpa3GpGFzLBdCPqd7K06SGXi
	66uuyGK2Xhw==
X-Gm-Gg: AYBFou3INausxM+kaqaa7XFiMBYIpPXSbXjaaM3eYJAj07eI3ADdzeIg0KzefEBCZo4
	XZ+huNMQcARHoTjqr18NBANUzvoAMvuaHREIvUwlX2FLeir2oV0bp6VW77cHbD2/WmmChCi0o/v
	o7Uvwt7L/fVpR3+72OuJxqs5rVoVvMvjjOwiOl1VgsPYq8chOLVX+e6O1KCfy6dMHcYfkj8mTsW
	ErUmzTh85kprvBQuCwYWlSGyU57v4hS/Z+CQPVOMrBqClE3Qb8WYpCzMor06WlEK5kfqkhQ0qH6
	X+/Q7QCZfHvUZidy+mfXr57G//QLw4liFYMSKhKwfiZpDR3a2GaCYmwKlUi0hiQED+Uh3I7cYI3
	ZqTvDF2GRZfbHE8qDh3Gt6fAkzF7nAwSX0Rm4qWOuTSzjGqtYy5DLuQ8Y2lsd0V1kfOrE0E1hH9
	YTDq6vS8nTX5T62q0Qk6f24WuDZ4ECxqRgSeCJlj4DJhgVTi4e+290qD/q96LLfEj0eoNtbhUqr
	BRdS6AFQmmPWnx+L97941NpofLijoakKdnUCrxlbvkPA9WQCZ4cSKJWFT9Zaw0u
X-Received: by 2002:a17:90b:3d87:b0:3ac:9599:a689 with SMTP id 98e67ed59e1d1-3acef154517mr7624815a91.34.1792481271984;
        Tue, 20 Oct 2026 00:27:51 -0700 (PDT)
Received: from mma-spare.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad5d400505sm2718511a91.4.2026.10.20.00.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 00:27:51 -0700 (PDT)
From: Lewis O'Flynn <lewis.oflynn@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Lewis O'Flynn <lewis.oflynn@morsemicro.com>
Subject: [PATCH wireless-next] wifi: cfg80211: use self-managed regd after user hint
Date: Tue, 20 Oct 2026 18:27:08 +1100
Message-Id: <20261020072708.429946-1-lewis.oflynn@morsemicro.com>
X-Mailer: git-send-email 2.34.1
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

cfg80211 does not apply user or country element hints to self-managed
wiphys. However, once such a hint has been made, reg_get_regdomain()
returns the global regd instead of the self-managed wiphy's regd.
Callers of freq_reg_info(), such as mac80211's
ieee80211_regulatory_limit_wmm_params(), will therefore use the wrong
rule and may apply incorrect restrictions.

Always have reg_get_regdomain() return the wiphy's regd when it is
self-managed. This makes the behaviour after a hint consistent with the
behaviour before one, where reg_get_regdomain() returns the wiphy's own
regd.

Signed-off-by: Lewis O'Flynn <lewis.oflynn@morsemicro.com>
---
 net/wireless/reg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 50f50e768..5460b3117 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1147,11 +1147,13 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
 
 	/*
 	 * Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed or a user wants to help compliance further
+	 * IE has been processed or a user wants to help compliance further.
+	 * Self-managed wiphys always use their own regulatory domain.
 	 */
-	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
-	    wiphy->regd)
+	if (wiphy->regd &&
+	    ((wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) ||
+	     (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	      lr->initiator != NL80211_REGDOM_SET_BY_USER)))
 		return get_wiphy_regdom(wiphy);
 
 	return get_cfg80211_regdom();
-- 
2.34.1

