Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3FF2EC0A2
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249974; cv=none; b=GMXt5LAlPZ7w8P3MKi2dgE/emhLkKPqCNUlsPG/+0RrIDI07QQZMbbPijljqguGaRnXjs6zgvA2kwIw0gosY+ivwhZLEJ34GnBXOPgq2QgtKRV5VU1QFLsIzKQlnrhL9+AY7jPJ7J66rqYxU1hqn2JcgWS5IMNnxXPsbMA3wLuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249974; c=relaxed/simple;
	bh=1LOZSaWG2uzh/DCffSMH3rPaWMoMWYdMtKwtKAk9vLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5IlWZkzZGgX43gT6GTeg3gNRg7+sKnjtGlJZjqDYsoaq8nzFyq/zjmeD2rvEdLQrQgOcWvkknHs7CFgsz8IEBZ3cOR+Bc41MyYARzRCoAj4EZa+xCFRgqO1f8g961FdkYpxsvebZ7BPNeqirDf5y/qhO23uUYPA0CjG4IHPtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gsYj0v/j; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gsYj0v/j"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cc61541f8cso17523995ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249973; x=1785854773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=POsjIjDcCC462oWMC0mdIwmmpFMmh7BPTqtWNG7cxHZ8Hwp56OFF3QFPDmNVputaW8
         XdMULXpSH1TGs7aThGzdZ5eZfiIRLEgGD61rxUhdo6gv8hX9tPthDQ+MqfFxQn/fZ9nS
         6a58MfKcC5Eglk3RTWx7fLu3nOwSl1C4pfzko8k+T1ARqkDrU7MDV2wcbM76C4ScSK4o
         vSouum97AHcZjdzdPtFsUPdg1vkp093f+1YqOEnBUvviUPnqCdEUL9M/7qmbb8GD8WJz
         wFYTzQQNrtdSmlocis4PFvMdTLmqdmHelj5/feCULigyfFL1SRI60uhQD1HcybwFdcpG
         Z8ig==
X-Gm-Message-State: AOJu0Yy2AYKoXq+UAqcdfHNrQd+h82SHKnyqpkMsY0m7r9hMQtlv3DnA
	N91jmgZvD3WhPiO00dMTSrTTiYyyRkSoRuQVKr9tWfq7ak1yqtKudjGz8NNkOTspjZ/z/58Mk2V
	BU44kcitFyDQgt9/UodYgwhBnMq+3kBqyt7lKPNgJnlLEDSRzF/BeF9RjWM+r00DDlfxFM73/AK
	AtMxGqGAYmVnUQUoLiKJpOyv1e3D8Oz0Dw/LUu76ne3yBlI/Sy8FqGSgIGKuGSQ2xHp5uYxmINZ
	SydQBTgUsUfhPlNUUUa4YVIpXBV
X-Gm-Gg: AR+sD13pgZiM9vOjjgRhKNDpaF6hY+sAK0Kh2jvP49sPYqhXHnO9J4N9TV0acwC1s5Y
	pYspY4V2Cl68oAvfJmC6Td+Gh/Tseon6Bsv6XC4r2VJG8yI7dVQqUHJTu40G+mgseDNvIKk+MAG
	hzLn5PPzc4V0H4OmSgO2g8PLjbmfnMbk1cvGgOhzzsLa1XVIwCG7tY+On66iaqeY8Rlo4vh5qBs
	NSD83ecro5ZwWBbuJmllzTJI/+WNiHpUIgqWtJoDNxfYEgDYMP33alm37FelPFHbcUH90SDlFlY
	9GPZLpbgT1HQKc844HCw5aKLsVrDxMY0GY4k7TTp8PYgRlxTIvGgmnG5ox72H2fdlnJY5TEf+Px
	vsz7MFOgk28ya2sVrE7HpG4v6jsgO4HSMz/tiRm6X3iCOjPetp9CkCCsyjvk5jcfZa1ytMl3YQ3
	7E61i1FwSwgw6ik8PSp4kKYJod5kaa4ztfYx9cyzE=
X-Received: by 2002:a17:903:18d:b0:2cf:8aa7:7810 with SMTP id d9443c01a7336-2d015af440amr29521865ad.2.1785249972605;
        Tue, 28 Jul 2026 07:46:12 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cfde5b54desm10600695ad.16.2026.07.28.07.46.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:12 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e63df032bso118410585a.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249970; x=1785854770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vw8UsAkLTYYubS2GArrnvTGyTO7xTPOjCEXxf9oqMpo=;
        b=gsYj0v/ju06vXQsjDWr9PssLowmZIkEYw0UqqBC/rC5dnKV2zm1FgLIFpPHZoKoCZ2
         vTafXICu/iq2k6THxgmQrPrtknj6H+XyrvxgKUXI4pdJLJZkt5VUJB6Cbua5o0f9Zsd9
         3jz9i2kIHr/YVSqZ23quHNfx/DEy4wA7JdAyw=
X-Received: by 2002:a05:620a:6019:b0:92e:5c59:f364 with SMTP id af79cd13be357-933026e0036mr237312785a.34.1785249970453;
        Tue, 28 Jul 2026 07:46:10 -0700 (PDT)
X-Received: by 2002:a05:620a:6019:b0:92e:5c59:f364 with SMTP id af79cd13be357-933026e0036mr237308285a.34.1785249969785;
        Tue, 28 Jul 2026 07:46:09 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:09 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 07/12] wifi: wilc1000: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Tue, 28 Jul 2026 16:45:44 +0200
Message-ID: <20260728144549.2207061-8-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop generating cookies by incrementing inc_roc_cookie in
remain_on_channel() and via get_random_u32() in mgmt_tx(). Use the
pre-assigned cookie from cfg80211 instead. Remove the now-unused id
local variable from remain_on_channel().

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 6654fce4ded8..7c19ad34fda5 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1106,18 +1106,13 @@ static int remain_on_channel(struct wiphy *wiphy,
 	int ret = 0;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	struct wilc_priv *priv = &vif->priv;
-	u64 id;
 
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
 		netdev_dbg(vif->ndev, "Required while in AP mode\n");
 		return ret;
 	}
 
-	id = ++priv->inc_roc_cookie;
-	if (id == 0)
-		id = ++priv->inc_roc_cookie;
-
-	ret = wilc_remain_on_channel(vif, id, chan->hw_value,
+	ret = wilc_remain_on_channel(vif, *cookie, chan->hw_value,
 				     wilc_wfi_remain_on_channel_expired);
 	if (ret)
 		return ret;
@@ -1125,8 +1120,7 @@ static int remain_on_channel(struct wiphy *wiphy,
 	vif->wilc->op_ch = chan->hw_value;
 
 	priv->remain_on_ch_params.listen_ch = chan;
-	priv->remain_on_ch_params.listen_cookie = id;
-	*cookie = id;
+	priv->remain_on_ch_params.listen_cookie = *cookie;
 	priv->p2p_listen_state = true;
 	priv->remain_on_ch_params.listen_duration = duration;
 
@@ -1170,7 +1164,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const u8 *vendor_ie;
 	int ret = 0;
 
-	*cookie = get_random_u32();
 	priv->tx_cookie = *cookie;
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
-- 
2.54.0

