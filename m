Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3163A9630
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 03:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791428998; cv=none; b=ALn3K3KBoF29yz5ebx8X6YlAWMQzIgUqtKRuyc/3/aucH4mxrnT8Qi1bAtDkBhs9HIRBE8MPaeJBmFZ3m215aQsVFdHCnOTSy84NeLNrcjF3wHSP0qbQBlTGuOc2m9nLuXXGm3f3OVLMKEkHj/SDQL1laHWFcadJaNbuYBLNG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791428998; c=relaxed/simple;
	bh=OfVN41llBpMFZ/nU12qxPDyl71HdzpTDo7Q5OyKAoqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPKczTgZEnSXB/9AgW8k6nudYPZpv2eekj40aAWBspkZfZfAbs6zoIpDGiQ0lK0rEt0b2u+JlmAXM9IhutXxv+aRkgLiThzY0lEnsGt8T22aXhHcwvisemL/Z52o4nA4Wh8Xn007PCWM7I6cq+p5mqyDp5VECdVySeG3VV+vjnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=VMWV7wXE; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="VMWV7wXE"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso2271335a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 20:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791428996; x=1792033796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=spKh8pFge293zNDx3hUN966r9ssshC4S7DywUTuTeWw=;
        b=VMWV7wXEY9y+GCYXLaNPhPc8LQxPEOLzdZOmhZkIp2fEO+qWryvLQU2vBdDRU06jGG
         9rQbJgOdANrx0B+l97g7l0n26eUwsIO2PIbBL9lXD220JT+aHC0w6ljE0yOzw7O16R7o
         +dEpjGR9YCQb7DTuGX292t/yFN2Ocd1L73jgDNYRtb1ZP97JcNwQlAuLeK7hz6WlkeXu
         kJWW1H+YqnQAu6Q5N29/W52kjKvuSOoEkz7/0ASIsGwMTnzHIcYXF4MY7YBVxUNt0rXZ
         iRWwrrTy8LXyA9RuP7ZvZtAJpKiY8wyVU/jfrjZAqnUxAonndHqcMEBXBOL906tCORjI
         IFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791428996; x=1792033796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=spKh8pFge293zNDx3hUN966r9ssshC4S7DywUTuTeWw=;
        b=0rzmyiv5GxxqLdqWSUbp4ra+CwKTA3KJ+jMpiEr63GSOhjwW6na2DFc5bktZoGuDFh
         eSI2yYUunb2fwBfiX7ooQnVMLmYod/ezFQ+MlhFZ5xuhvwe9ouFQGEc7CNDpyyWzprke
         4RuOwEBRME2621FsJXY4t88P7NRx1qEDxw0GlnTA4+Wxvo0FWIMZ+x4/Bc4bOyX6bW1M
         TIfQ8JkAZ20ogY0+LYW70Ja/lVNWOG4q+/HoWLrRA6TQy7VF5VmyURPcj+iQ2MiQZ0yF
         gkYd+mjpKCMAe96dkY90WhYCrfveDMXymNjAcEFpt9qU+U4RIzxI+NU+uQ2aINriR5Cd
         PsHg==
X-Gm-Message-State: AFq9FYJI7h5hteenT4EhtfA3hMMldQ+CviBN3BjqtQewEqmmgKyVZ6jw
	c2oYDw2RqcILy5Hpqn8qpkQ4ow/6MXLFazZstsj9m7DBNGCctEpYKeQHtOYjoPXPDQM=
X-Gm-Gg: AYBFou13qnixUdtUer9Vq5wUSSaVnEIgMtwunBYsqXeTjYsTqno46Ok3tZpxR6Pjcd7
	RNCZTllGvAj6YDLTnVECnu6owJx6WhNfzCPFUXVDv3eAfPNOAUHUP6MsZt1uUqlJUaF/U8kCmuf
	CIIx4ReUP44vCEGKJERpxUuSyuvB24qFDWqce6D9beTecRRwpYGOfmqcpWI1U6nSoLFoUa2sS2B
	3ifu1y9RIjbCkr4rZ1oAkqjf/6sTnHPn2adv0YX7uOFqXbITcVUDh+yF87lD4CpX8DxD8CdPv96
	LNH2GkO7tUmRSxKuBEaAel6IkR0M9+9hXDRDPIpWC4hDmBYzXZMtrgyhOplRDjqqZqtGxhvmBY2
	VRPWuSUWd2HTEVhekA/TcBdf4qIrCOVu8WATW9YvJWOGCJpfOfVOCHnWRMluWqXCgrOVP4RpreN
	b5/wM+8+VYgpSFZD5hArshLO0jaymrYsHsf49j/aTB/XpWWqfXleZrpj6JxuG4NlK1Rc7Sbpxuq
	N962d/uzUend5T0WL/EMPz/aI3b7QZ5tY1tW01QXfq9/8c3sv2tP0lgDt910bseYz8P1aBy545M
	Y9m9LECjTKBp3Q==
X-Received: by 2002:a17:90b:53cb:b0:39e:6c69:f47e with SMTP id 98e67ed59e1d1-3a8a1e2c2ddmr3472451a91.61.1791428995499;
        Wed, 07 Oct 2026 20:09:55 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3aa0cbc6e23sm2149514a91.14.2026.10.07.20.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 20:09:54 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: set conn mode prior to parsing elements in beacon
Date: Thu,  8 Oct 2026 14:09:39 +1100
Message-ID: <20261008030939.474493-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008030939.474493-1-lachlan.hodges@morsemicro.com>
References: <20261008030939.474493-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_inform_bss() currently calls ieee802_11_parse_elems to
parse the beacon elements, which internally sets the params->mode
to IEEE80211_CONN_MODE_HIGHEST. This means any S1G specific parsing
is bypassed entirely (in the beacon case it is the shorter TIM)
and the beacon is marked as corrupt:

wlan0: operating as S1G STA
wlan0: associating to AP 0c:bf:74:00:30:fd with corrupt beacon
wlan0: associate with 0c:bf:74:00:30:fd (try 1/3)

In this case, we can simply call ieee802_11_parse_elems_full and
build the params locally (similar to most mlme paths) such that we
can set the conn mode to ensure the S1G specific parsing occurs.
Once this is done, the beacon is no longer considered corrupt:

wlan0: operating as S1G STA
wlan0: associate with 0c:bf:74:00:30:fd (try 1/3)

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/scan.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a4bca412e577..8a66d2e020f9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -68,6 +68,14 @@ void ieee80211_inform_bss(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct inform_bss_update_data *update_data = data;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
+	struct ieee80211_elems_parse_params params = {
+		.mode = cbss->channel->band == NL80211_BAND_S1GHZ ?
+				IEEE80211_CONN_MODE_S1G :
+				IEEE80211_CONN_MODE_HIGHEST,
+		.start = ies->data,
+		.len = ies->len,
+		.link_id = -1,
+	};
 	struct ieee80211_rx_status *rx_status;
 	struct ieee802_11_elems *elems;
 	int clen, srlen;
@@ -76,11 +84,11 @@ void ieee80211_inform_bss(struct wiphy *wiphy,
 	if (!update_data)
 		return;
 
-	elems = ieee802_11_parse_elems(ies->data, ies->len,
-				       update_data->beacon ?
-					IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON :
-					IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP,
-				       NULL);
+	params.type = update_data->beacon ?
+			      IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON :
+			      IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP;
+
+	elems = ieee802_11_parse_elems_full(&params);
 	if (!elems)
 		return;
 
-- 
2.43.0

