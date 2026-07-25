Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF5BE63
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784943544; cv=none; b=ApwZTBMNi5HbK/Wrvsy1sqXGs9qMWr/t+H9M/M6EGqt+GZOXQvuXs6rTNW7HM8oIY0LrOZfaVzUs/F5QC9qLnGd5e4bBdmns6y35ae8t7//0d4XMV0tA/xmeXE/5qWUuJIy9bnoZ6ZKD+MfUbQufmczezExYvx4q+R/ehKED9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784943544; c=relaxed/simple;
	bh=nhJB1o3/CftC74m/SJ7OOWafTqa/vTIxBKtN0cwNfC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i76ZJXBpwoywelbo9ka3vc02HxlUb0i/J5WX0wiYMyCFSxQk+LSIdK7ZQgGIX9tYwjzVR6E4cAzyIPmhtI2cbAKIQwbqpxp7oMkLlZhvHWxoj5j44q79gMrmnbaoxdnGCTxja8JSGNBCMapx/qHACFZaOprNztkx0cUvoWs8Wfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n8RWApPP; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8RWApPP"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4a450c8ddffso98654b6e.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784943541; x=1785548341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xcYSfZGUx9sUchaQp0uiGsngi9HwNJwG+1+PdhVxlSU=;
        b=n8RWApPPiNavLQwTUSqX1O7QBEE1JfKMfE6Lx9NJjOd88WgLOXmwrUaWWitAYXvWit
         6SjDPJR895lWuRn3q+j3y6v8OWG/BXXguFzUK++OEpqvDJIaBE3gckTi4wIxM2S3HPFa
         1aigT9mpvG6VX4WzjCwOSPrtKLRCdSp2cHMBVpUfeIFaCKVBObiJzzN5FoWgOfsDKaQz
         A32vFkIxCLT+euHUrYVlr2XEXjlf/xtbEZFxaCynuabD4QQbjLbiNHEz92D20/vflL4S
         3boJIJyO/hUNQGPmv6D7bmceCktlvav59hkLADDIQqIhF4wsnI+D8iKFHD0CFXhmYhq1
         pSRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784943541; x=1785548341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xcYSfZGUx9sUchaQp0uiGsngi9HwNJwG+1+PdhVxlSU=;
        b=X2TvsNty3kQ8nEoJbN3dIdJ+euBfeWrddwHpen3ls5rmlPYvCn4RpuOGVy6gosatpP
         Y6ZJz760P71i9AiwaJLXh03b76DAcFNrgY+sqLr+2WeHtDF1Bw4wCoro/W0QOgGsLf9B
         uFBmGN2+WbzKJ0+Juw29EjUePosIhr5iEBPFsHPEo0Bnm1fXPA77Dl8JNTYcaxDgnF+D
         PzGZY9+OfJ85phSltgt4zVd3cAR9dbESkddXdE1Am1eTa8yFl6XTWr67513r4Va8Ir+o
         KJj0iPxVTSDwpx1fs51qSYvyxuzG0MubpI1wOqnh0mhgiJnLUk2dcPRogYwWqIbW4kG8
         JEUw==
X-Gm-Message-State: AOJu0YwIS0SvfIdewJfasz7HvgIjF8wZVZl4sWJGlgzR0RKk8+Lfu8Ps
	TN93V3WOLdHB89KkmxMrnIFtJ7YY445/0hSgwwMEbVPcv5SAgagx5QES
X-Gm-Gg: AR+sD10HOMQtiRYgVQ47AdJyhlrDH4yQC2m9HDUlKv7/Fkuorgn91HN/Z5yDzytxsSh
	So6qroPdNBDk5DGrtawTcycbBeALpVzhmRpJoEGJbSHKqVN4YaLRKBssqbEoWMTrxj+wM6CXHru
	moknjOHGEbL8V68jTQ2mhbypdhwwCTTzXPvR48tN4zLMjAg0nQIUE/dYRUrlu+jlDoVfF/Tl11+
	xrpY2HUiYQheEM76bDd2XjdxnM0pPV1nSbFLNlyG53/N45vrIEvEAVoHNVryohESQEHdSdNu4ja
	wHBY9vQdEe7IMIkFmeoRMlANrH5qpOErTJlw0dysLBKL57Cs4GnkwfVymYgAS6g9zWq3bfDej2A
	dAEcHfjUYiWDaHjk4IIFs87/Wo+lk9trI1Uc7RDEjhjplWUhkzr3FO+N8xv6y0IMGSpnp1/Vkwa
	GOSoAQXcgfeEUpvAkdNasnRkXhvRUUjuewyy9MqPQcf24BioeKgHqGri3ku7P8nIGErxKQEnqAR
	s14
X-Received: by 2002:a05:6808:2388:b0:497:da5f:d5c3 with SMTP id 5614622812f47-4ab6a1e912bmr607781b6e.6.1784943541506;
        Fri, 24 Jul 2026 18:39:01 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ab2cd31929sm5643564b6e.4.2026.07.24.18.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 18:39:00 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>
Subject: [PATCH v2] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Fri, 24 Jul 2026 20:35:28 -0500
Message-ID: <20260725013528.169218-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero out auth_status on initialization. Otherwise, garbage will
leak from the stack to the firmware (when ssid is less than 32 bytes
and/or when params->pmkid is set). Then, pass the params->pmkid to the
firmware (without it, the firmware caches a garbage PMKID on successful
authentication and denies a subsequent association request that includes
the PMKID).

Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
---
v2: Split into a separate patch

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5..2c59b5e57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -208,6 +208,8 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 	ifp = netdev_priv(dev);
 	drvr = ifp->drvr;
 	if (params->status == WLAN_STATUS_SUCCESS) {
+		if (params->pmkid)
+			memcpy(auth_status.pmkid, params->pmkid, WLAN_PMKID_LEN);
 		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
 	} else {
 		bphy_err(drvr, "External authentication failed: status=%d\n",
-- 
2.55.0
