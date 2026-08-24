Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCA925B094
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601192; cv=none; b=bk+K+C1mJxhUhDkGcCzvscEcWBsSddzQhK+jVDy/ZtwRJ4eLNAbsalda09KjpPfS/EHygNhsIqd1T2sjc/w/vCgPx6p8vG6jVXWwR1umt8538iYcKb3co34ufJpnj80e8bzbfuziAa2qYxS1TClYp5zBPmcm234ExXCjZ72hfXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601192; c=relaxed/simple;
	bh=XOIRJa+7yZ7tsMXAC7l6YHGpL7D/rYBCpDEBn2B1jic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It6DnQnaDWLDmvlev7r6RKIwfebf2ZLIm3++1d/3jKyACFVyS7+GehCTv0Pc/4YOfBjRhYLro/fRP/yYZGunPhNI2NHboNY6b2G2VEtKN34NhrIPbFTPD/d9hAGYlOVDvUmfSWeNUK9hzSkXaZexn6Ej4XKLMGB2tsGePLNo2U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44cedfaab6bso1928826fac.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601190; x=1788205990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q418RkM6qinLSHwTY7IgT/gNLjtyfu16DuBAIvo7lUM=;
        b=c4hoSMnsAdOKkki/4ycDYls6nsHCgz7ccBf/7ognYWuIoecmnfUE5dJnGRHIYu1VCY
         aeRf9PMH2G8Bm6pJ5G4xAd8Z4v997TKi79/wQ3kNWtxvbXRZbeJ7jSv2M625udFOzkCm
         gKmW+BanrBvoZINmr0qZqGJl5La7xT4chs0IEdeTFzc4E+JLhajNtNRuT64nLLd3UCNX
         +QcvWuL40XbP70LYLBMyrAFUhCzWljIySEAjL10kNIA1tS/UVYD7xCLr0q4KKZyhCEFi
         ebP2UzBFPDIQvA3lwNtqr6pwxamufrU1wStsw355WcS8sfCtMEit88cGIQzxHwsgzLkU
         ZaKg==
X-Gm-Message-State: AFuF++k130D7Umzzhy5ZyrqPz+v6NVnID0tDWY7ZFyKIIGmtTrkSSmv+
	tmecMTQqvq+Hqt9CXFvDvcsP1vyeniva0zkIweQduiwX/lTTw0AJsUVP
X-Gm-Gg: AR+sD10ldUcwRNa5vYlQl6QtEMrRgdzwGDoNpldb9SMfk+SecdbddSxCbp6eKM5aDcR
	m5imomTPCPRvvaqNT92MaYRxwTocpvms/YipKJKmDXcmyurNRpKXh39yI1KkW4xMulrVQdhTzlK
	XJpUf7gO+N/a2EUXdTfe4Y/jX3z7YLeERQap1r9pMbUS9iZNzEm+r2Bo1xb5L6xIbdMUIGVCOPQ
	V+HJr9dZAPbkSyQQjUzfacuX0ksH/aQf+76PdZ9ZpkAKfE9FX+ol1pc5x0e+vgVwB+WaKodg/0S
	dXJT0PM4WDXy3JrDG1vgDOrUDlt5NAIbt9P6IMaWwSOeXAADGrhO00GoZHlB7uqJpC+7etmwuVQ
	PjrAvLRrzWD87Vc3EzKd6v0JSPqMijtSYo/Trz6a8X8tafmFYz25ZdSsq8Yf7A+3d8gP3NvjYt1
	yHUUAvFLe5uLwlTRG5GtAKgrTaSVP7TeyZxZooBj5FBHOyugiOZLu6SUVClsaA/UmjecFR8Ief6
	rRKV62kwBASJpwbdrIO3Ts/aQs59jj2Dn16CHfjl/9X
X-Received: by 2002:a05:6870:c088:b0:45e:caa2:4ea with SMTP id 586e51a60fabf-4637fa671b8mr20227908fac.6.1787601190327;
        Mon, 24 Aug 2026 12:53:10 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:09 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 05/15] wifi: mt76: mt7925: drop unused NAN 2.4/5 GHz support config
Date: Mon, 24 Aug 2026 14:52:17 -0500
Message-ID: <20260824195227.12589-6-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

The config_support_5g/support_5g_val and config_2dot4g_support/
support_2dot4g_val fields in the NAN enable request are not used by the
firmware, so stop setting them and drop mt7925_nan_set_2g_support().

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index c04b12cbf076..5c6598a0f3b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -32,8 +32,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	if (!mt7925_regd_is_valid_channel(dev, NL80211_BAND_5GHZ, chan))
 		return;
 
-	req->config_support_5g = 1;
-	req->support_5g_val = 1;
 	req->config_5g_channel = 1;
 
 	if (chan->hw_value == NAN_5G_LOW_DISC_CHANNEL)
@@ -44,16 +42,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	req->channel_5g_val = cpu_to_le32(ch5g);
 }
 
-static void mt7925_nan_set_2g_support(struct mt7925_nan_enable_req_tlv *req,
-				      struct cfg80211_nan_conf *conf)
-{
-	if (!conf->band_cfgs[NL80211_BAND_2GHZ].chan)
-		return;
-
-	req->config_2dot4g_support = 1;
-	req->support_2dot4g_val = 1;
-}
-
 static void mt7925_nan_set_cluster_id(struct mt7925_nan_enable_req_tlv *req,
 				      const u8 *cluster_id)
 {
@@ -172,7 +160,6 @@ int mt7925_nan_enable(struct ieee80211_vif *vif,
 
 	p_nan_req_tlv->master_pref = conf->master_pref;
 
-	mt7925_nan_set_2g_support(p_nan_req_tlv, conf);
 	mt7925_nan_set_5g_channel(dev, p_nan_req_tlv, conf);
 	mt7925_nan_set_cluster_id(p_nan_req_tlv, conf->cluster_id);
 	mt7925_nan_set_dw_interval(p_nan_req_tlv, conf);
-- 
2.43.0

