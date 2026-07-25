Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87AC2D9ED1
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784944060; cv=none; b=maoXfxj7eRxF9U3IUNLQKAeYNXChuzq+mSnwR7F3/YUuB1NumhxxSTK54U+/2poDtErq9jM/vJS5HC4OcJceTZd+hcptWvg/Yw9I+03qE1+sp4JtLDeDvlA5hIY44KpsMIycOrdJ1EwUgVC2SLfHug9rG7QkYQZTSURYwtRX7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784944060; c=relaxed/simple;
	bh=6xKAh6E4WLp9QISyYYX1OVDeYsMFNbN68FcKZgcDOVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hjeagcJTwtN0XzxyEaF+NOUyyWEXahn61OchX8pgrUD4a48pKQQyjACvPtB/yHkM+jul4fOfF4Iz5UuuEEtimacpZ53Oxg1FeQo98SjSWvt+2nfUfBZQqwrkhr3HbfX507/o8+NNxk5ED9NKkfp3ZUD1640N2JLz0turp1X6egk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ptX6a8wV; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ptX6a8wV"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7ec6815f0f8so156787a34.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784944057; x=1785548857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nxam113cCiGb2Bxb3oppPtZB3TkRP3OfdaVNSdcmXQ=;
        b=ptX6a8wVetrLwRh6Q2fRFkTI7ylaAYmsmqCxIu67WBsAfhT1boshBkzlSq2pSPzr1W
         drcDNhFxxguwAnruy5/SnPEHaNmGdHgzAh77UzADzcbQzHlKSq7Ch70hQhaG0pHIOG7V
         sqsxreuKjl2piPAZNC8eSmwUWpo04pC5mydQA8g9A7PX6hngwfEu9kcILNPIlDwhojjV
         TANOqkuJOzqY2zAZVDN7o99DDrAidprTbftoJyZrTQ8N2nc0M3RcJL9HqqxMb8AaW5hL
         dPVIlbEq46hwKMUweIi3LUvEKcGwMRIlELRyBf7ZGBZHcVfrucWbwm0Y/XThWPTnr0B3
         2mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784944057; x=1785548857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nxam113cCiGb2Bxb3oppPtZB3TkRP3OfdaVNSdcmXQ=;
        b=Hg2WF9r2a/C+QAVtmGTlpdAQGSef2kHd+gOc1awCIOPiddHWl+6BeBSgeRXVhOVyKP
         RYMh82Gnlxm/n9lhLPCb9TcrvYiLMVZ6o0bS4me7NuE4P6J5DSJNkKewRweI6V8L4xXr
         Sfgv3RwXqCWiJThAauuEwwWs73f6d1gdIOzfHLc1vOnETQ9sKuGbRhDFp/dbHPmusD9S
         BreJ3DNEGwZX5+0K4UY9C8ekcghPDo9DhLa5z+tIh0jzPMVXaoEQHyif9bhnv8ubmE2L
         l8CXiLUv0d4/G2kQ5SlVw7bjXugJoiMjuk/Y4lKhFsFI+d9OeZjT7xWLWH+HRZFI3ZC4
         KTNA==
X-Gm-Message-State: AOJu0YyVpfAiLi7PwPQVZRm3Q9z3qA7vw4wS4YI6fLCigymJAjr8waVl
	XC9QP/kNe0ikBlAo+jTWJACzNbWsYskmYxW9ITe6rcN61kL00Qc8f36T
X-Gm-Gg: AR+sD10xvz78/oT3g1eCZ5T65kRNAdIn/9xoJxZFq/Ri5Hmdjqg/WKnIla6iyGZUPNT
	IEVayLO6yK6FHrtAEzOj4tOJtgraQjj/JliKL+QnaUei0wNBNdNhw0EImZgieZI8LI72moQnyIG
	H9qtm3N2K7xeupktSQmsZU1SdiSoDvisCjzqPhdAiq70CzQIE8OtP/FkCS1bLwWzE5u7rVpwfWi
	XfDfYBjDSnQEXlZninuFSSAb+/On9+vwJ8gc0a1QcKD82whDpvXouOrPzblrqS3Czij0WCQCdVv
	c4pMyNV8BKTq5j9HGouXDyhwXT97iPSzuOt4UU+l77ROYj5CoymFl+EV5k6guRFBCpwd06j8cXc
	ae+/Mzn2AThG22Y4kWtWehdbxWaTt245SsEKZA2GzLrO4g2jiTlkIgNyf5ZkUxYrYfU/7LEpW05
	lDEgHc+uPu/P720G7zbFTNFa4nw5edKY9w5ntiE9p5ALDKKZcob0M21kmwuicGRBQ6ebOgPwyS7
	Sgz
X-Received: by 2002:a05:6830:902:b0:7dc:d6b1:48b7 with SMTP id 46e09a7af769-7ee78c1ce7fmr412403a34.1.1784944057377;
        Fri, 24 Jul 2026 18:47:37 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee2a03d30asm7348058a34.18.2026.07.24.18.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 18:47:36 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>
Subject: [PATCH v2] wifi: brcmfmac: cyw: set a unique cookie for mgmt tx
Date: Fri, 24 Jul 2026 20:44:11 -0500
Message-ID: <20260725014411.170340-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set cookie using an increasing atomic counter. Avoids mismatches of completion
events later in brcmf_notify_mgmt_tx_status, where packet_id != vif->mgmt_tx_id
is checked.

Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
---
v2: split into separate patch and set cookie to atomic counter instead
of packet_id directly.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 2c59b5e57..ab4ff0cd6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -23,6 +23,8 @@
 #define MGMT_AUTH_FRAME_DWELL_TIME	4000
 #define MGMT_AUTH_FRAME_WAIT_TIME	(MGMT_AUTH_FRAME_DWELL_TIME + 100)
 
+static atomic_t brcmf_cyw_mgmt_tx_id = ATOMIC_INIT(0);
+
 static int brcmf_cyw_set_sae_pwd(struct brcmf_if *ifp,
 				 struct cfg80211_crypto_settings *crypto)
 {
@@ -123,7 +125,7 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!ieee80211_is_auth(mgmt->frame_control))
 		return brcmf_cfg80211_mgmt_tx(wiphy, wdev, params, cookie);
 
-	*cookie = 0;
+	*cookie = atomic_inc_return(&brcmf_cyw_mgmt_tx_id);
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 
 	reinit_completion(&vif->mgmt_tx);
-- 
2.55.0
