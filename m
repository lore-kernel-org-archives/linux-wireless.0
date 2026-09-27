Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21277231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543013; cv=none; b=ZsmCu2CSmoOI7a9bXR35JFQZM/HeAOeAzr8rRTCdp0k/JOYyOsdic5Qic9678rYufeOlDPBY8QErJvkbD02Oy/r82FGYWIwbycjrXMHcnMhxAlODJ7E3S2rOC77/jFrbvN2dw7deWwUVy3ozMn4iiRXZDxgDuZtFi8G/Y6LO4Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543013; c=relaxed/simple;
	bh=nb/uBbDaAqzBT1c6zEJCH40ieGeDawOJmXfx8Q4HnFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbBsypDXt7N5Y1iVV8Cq57eAA1hsDoa7jY4EMLBEhl34LTX9GCAK4JKvF48JVQNykzyaDRE8BOdv0IIkJ/AY1x9/PFuN572hGD1CkrXqJxp4K0r8NUBKiT8k6uRf1xPKdRsGERIWi6tds2S9dppwUcXJVqb8ZW/BZJm5JQk4U7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so19519417b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543011; x=1791147811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b/j2sk0Gu0f7kgmwf66bENo3rsyXQHCPfjXxZSmJeG4=;
        b=mDC395vEBZIQCfWGf2hHnHsh6DzGICWYctyDFwjdJOMk8WVQ7rfKJXGF7Ha70DDM1C
         8ynRyQzCUQJxG6TQ9Rg0/hRTjh1ngL5Unf/h3YvTyzQLL9PGEs9UoXDKVDwsTxje+z/x
         UMadg0qy4URrByCC3kc/rsApZ0GkNPMHmHzukoqQaBqwG/CfyOw479D0iZj1KR9vbEer
         UtV9css6Pn18yhYZ4sBWTdsYbGSWippvuNbknhyqWDdRvtHVX7liMFrTsHKOWWEpEYkm
         nhUR9eMr+/xmECVmbYZ6oUKOHrs6kSDUBW+SPEMNjNLfq9Ix4cyzq8lTvIDjfcsClw2P
         1Zdw==
X-Gm-Message-State: AFq9FYLpqyFhRt5mmGMym0m083o9UauwwHyuJ3j9SuaCi8Rtm67BVxP2
	UfNsT0fRQxSuBgX5CUtjPI3Mx2ApB+U31wJM4fU6kPfIEpFfqbg64MpD
X-Gm-Gg: AYBFou0/1ds61nqHNz8Rht1RgTalvTEW/+q+zceeoO37P+2m2lTs7E4UdxWUaafu9YC
	jGcKLp1B4hCVIh1IG6vWR/Zb5rAqDS+eBXYCTXDPuzSAUur5xYvpUPVacMpMgPTzSqdJqia934Q
	i4rr1XPpfkPzfBpodKsPziYhdxl1yvudOS4ctZ+KS7++HBLMu/tnEkpSvx7EmTqCINIvy2x/93Y
	bLDMnLn1YXeqUlYutyx/EXLOEz2HWEh7W7JsoBL+h/hXoEVkZYei8FSaoU6aXau1gPTjXK304zX
	SWp78XJVg8rCQGG3wJqxhtx0JrqcMefNuvGi1/xtBfadwkw5rSkxo8QO8+MQ5lFdFfy8RGqX0Ed
	/F2IikMiBN7+vcjDB6H5Qz4itFZ/2clJ/jw3152FwWnJBK5IifnwYpS8eqiJUP0c9JxdcUbTkoN
	jai1IS/Juy8kbhXxv/e9X4888QOVAf2lHjCksm/4PJBMAEc69FhRFrDphh2RIsdSyjV3YlA1itI
	yQWHMDHFQkSD1lBkvY8h67SLV1yTx9NzLQL+imqwO2R+4RL7FyUohqnq8k1yB8EpvqT+Q==
X-Received: by 2002:a05:690c:e3e1:b0:854:b86b:d206 with SMTP id 00721157ae682-8a6461b8773mr59308197b3.12.1790543011011;
        Sun, 27 Sep 2026 14:03:31 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:29 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 04/23] wifi: mt76: mt7925: wire up NAN MAC randomization lifecycle
Date: Sun, 27 Sep 2026 16:02:46 -0500
Message-ID: <20260927210306.737669-5-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengwei Yu <chengwei.yu@mediatek.com>

Start mac_rand_work in mt7925_add_interface() and stop it in
mt7925_remove_interface() so the work item added by prior patches
is usable and cannot outlive its vif.

INIT_DELAYED_WORK() is unconditional across all vif types, matching
how csa_work is already initialized unconditionally -- mvif->nan
exists on every mt792x_vif so there is nothing NAN-specific to guard.

mt7925_nan_stop_mac_randomization() is called before
mt792x_mutex_acquire(), not inside it: the work function takes the
same dev mutex, so cancel_delayed_work_sync() while holding it would
deadlock. This follows the same ordering mt792x_unassign_vif_chanctx()
uses for csa_work.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index c882952f5df1..3e1c223e8da6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -480,6 +480,12 @@ mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	if (vif->type == NL80211_IFTYPE_NAN)
 		dev->nan_vif = vif;
+
+	if (vif->type == NL80211_IFTYPE_NAN ||
+	    vif->type == NL80211_IFTYPE_NAN_DATA)
+		INIT_DELAYED_WORK(&mvif->nan.mac_rand_work,
+				  mt7925_nan_mac_rand_work);
+
 out:
 	mt792x_mutex_release(dev);
 
@@ -493,6 +499,15 @@ mt7925_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	struct mt792x_bss_conf *mconf;
 
+	/*
+	 * Stop before taking the dev mutex: mt7925_nan_mac_rand_work()
+	 * acquires it too, so cancel_delayed_work_sync() would deadlock
+	 * against a concurrently running instance if called while held.
+	 */
+	if (vif->type == NL80211_IFTYPE_NAN ||
+	    vif->type == NL80211_IFTYPE_NAN_DATA)
+		mt7925_nan_stop_mac_randomization(vif);
+
 	mt792x_mutex_acquire(dev);
 
 	if (dev->nan_vif == vif)
-- 
2.43.0

