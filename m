Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9FD3955C9
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787655001; cv=none; b=KijDsO7M2SQB/rrSHSLL3BDf6J4pjBhLgnAn5KNmuuNNipWlFoR96hbyH/KQHXKEgw6DMffHyzFSHxEvSo3N8JelaLJTYkNiIxGv+7i9VB7A7MD5FFD86MLd90GGZ13BRg84VU3EZG28v6qUpsNiPLia/TtfuP25GTK95bnezQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787655001; c=relaxed/simple;
	bh=oKsFKolW751cVh7WoVO7IbJoi9oC6RYNcmbiUQCNDmo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jMwgxEdYLbTQk558/0q3jtAqVFCH1WyulUNEW4ZgpQHSWEUqAR6h96KQDbzXiubinjOO1lN7VYrw9VNmE4aH8r0WFN+T0Bhodpu/z+niZbDVnOyZK3fTj7LUHwApiZ7CgELG9gFkxYH0I7jlzztfJHPm4r7m1uyIA/NruAZVIgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=INtUTQYK; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INtUTQYK"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so762031a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 03:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787654999; x=1788259799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RCa9jiLwlOAsAwXMXWcUM4Zdi0HPXNAMy8mFJLDxYHw=;
        b=INtUTQYKrq1s9CxXYAjJglq+ZYD9JFDZAn+fC88BrY5Lv3I9fRmpom/XlGAiPnOwoS
         lXA2jNKmzLpFQztDVJSoijua3dcv2R/KFcmbCj8l1LEIAG/TRUyemmZe/6FenlUdEjTr
         79GACv/PcDWS6wSiRK/e/p1BeNZ8XKkdPw+yBBA1VXfb6N0lmvItXojmXavyCpCkxluC
         YtFYnr/P5PVgVvUZONmpzunUPBcda83fOpcfqjuUinfJzXcZrMg/OgDQvDLLb/ZWyWM0
         jEdctYFn3DljohKZKkPoDgxtLseuXZ+Q4TS3jnhlsy1IMuzl7kdAXfyuWQ0AYw3fzF1y
         pxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787654999; x=1788259799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RCa9jiLwlOAsAwXMXWcUM4Zdi0HPXNAMy8mFJLDxYHw=;
        b=iaQX5sMCJmNGCn2yzM8mkjZwEiy4n0TlxoUD6TaNGKZd74bNeJkeGXZe8iK/46umSv
         5T78Klca0KbSPwUqQm+5ea6ij4J9KQ+jfBgvGU6NXr+lzGpvII9fUtBV+YcAc4WCAEU4
         zucsid0XCqu6xXEJ/eUyDWhchSzsfUT9PEpCoLW/E4F8rN6jWr2/3Aw+ao0LXmDq8Rjz
         ObpeWR7uz6fAbJuVIWxgyJYTA0nW+H/VyzsQiTWGvQEVj71C4ps7s76RrFHylCWKTLfu
         j9VKM0CNbbJCva3Oy5XZAXKUbq/0EKZZd2fe9UkbV6t+OXsv0nScRsL9Ysn7dIQ1xk/a
         xg7g==
X-Gm-Message-State: AFuF++ktjsdSHd98cLQVUPaAOfanldUynQDAa2Hxr48AOi3MUrx0o2d/
	gsH44+BPkSYgrckys7M4C49QFzwquhPakLEaS8BueZf5cUhhm+lQAtD4+Gcn+oxU
X-Gm-Gg: AR+sD11uH9uMHv5cImMfACDea/hfsYFFQUFewGQKGLYXlH0NqEv/x4IkkZCnBDPXEKe
	79iER6KSNz/QQDrWlTNK/PPiNQJhJ0aABQtshDIsLLR3cHnAdU87a7mBlM+zdOdD9ZjJqyi24Kn
	WrItNcSwnD47c6r7miFUjUQ0Mw+OnRXpNN9F+kD+l0UERU8cR6GApg9HyIH3o16WIhOuVdk2vOz
	Huhvu5jY9NaHd8/OZHZclwfPwVkvbqLi2VzvPApHN9/IpvDtAJ0YkJAE/vUHK0eXvB9bLYnl6uu
	WpII4/89YMgtfdcaaFb6k3kGBxgtlxrPbpAQl+THs1hc1y1a7i0ug2SgiirgfvquqO6K/cIv1yH
	sZls9ftSbgQZEho0/lNmSgVm1YjSUPKiSq7GtqDRqN7+RhFGpq0EN8ISTEzm7/s8fMa+n17W5Kk
	M8s6VbMTmQwx3V6800pUMWKYOOwAncfqdogv1OZT+xG+NPyDVV9r96H23L4rwTeldjzfpxAdr7a
	korS4Uf17ymzps+gqfiiGNMrwtp3qcZcUE3RnvQyJIRpovdky2PPFl9i59eeCxzBg3NQ6DNXgn0
X-Received: by 2002:a17:90b:2b48:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-39645b5b2e7mr6373642a91.9.1787654998871;
        Tue, 25 Aug 2026 03:49:58 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (114-25-106-150.dynamic-ip.hinet.net. [114.25.106.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645bbb87esm3479834a91.13.2026.08.25.03.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 03:49:58 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
To: linux-wireless@vger.kernel.org
Cc: error27@gmail.com,
	johannes@sipsolutions.net,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] wifi: nxpwifi: fix return value check in change_vif_to_sta/ap
Date: Tue, 25 Aug 2026 18:49:42 +0800
Message-Id: <20260825104942.5730-1-jeff.chen_1@nxp.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_change_vif_to_sta() and nxpwifi_change_vif_to_ap() both call
nxpwifi_set_bss_mode() without storing the return value, then check
'if (ret)' which tests the stale value from the previous call. The
'if (ret) goto done' is therefore dead code, and errors from
nxpwifi_set_bss_mode() are silently ignored.

Fix this by assigning the return value to ret, so the existing error
path works correctly.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-wireless/anwqp-LuExbRshYu@stanley.mountain/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 5cc8cdf594d3..ee022fa40990 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -844,9 +844,7 @@ nxpwifi_change_vif_to_sta(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
-
+	ret = nxpwifi_set_bss_mode(priv);
 	if (ret)
 		goto done;
 
@@ -888,9 +886,7 @@ nxpwifi_change_vif_to_ap(struct net_device *dev,
 	update_vif_type_counter(adapter, type, 1);
 	dev->ieee80211_ptr->iftype = type;
 
-	if (nxpwifi_set_bss_mode(priv))
-		return -1;
-
+	ret = nxpwifi_set_bss_mode(priv);
 	if (ret)
 		goto done;
 

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.34.1

