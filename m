Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266D2E737D
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 04:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719078; cv=none; b=uDYy+1cxZuAulpQFyJmcxGC37qlpBbBiCmQRZXQqigs+kbs8idl+UTRiD86hyYGfN3Hctmw1zAswZ80FWVyA9aqnegHypoGLZLparf0D4ZqWCNpDmZrB1CU0BTy6vvpUsWJbe50Ov0KxeCg1ZGDzCNDnsCxQ6BS0jZsUhnIgIG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719078; c=relaxed/simple;
	bh=/g9FNVpJFBTGteq2CpSMswCcminucOoC+wL4dgF/P4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gaC2Z9AmEp0LWp2n41FLHGdeuN4gGtziEP1+jsxJXPgmL4dzpFnZN0OEwV+WLNsler/nUkK7lqTwgCZRZJdY4nvOngeJflYwod5pRup+iwatB8i0vX2Wz3vFcLCUN3ek4y3uWTmm5loExgjvyTb3yi5SfTWQsr50CzgF/y3kpsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=JzV68nQW; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="JzV68nQW"
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CBA8D3FC15
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 04:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1787719065;
	bh=RYhyGaWYmpci56QhJSuWVc944fdh64JWw/7VVEY/WQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=JzV68nQWsfORF3qNKEvOtpwr1ABOvX3CK5TIaFGZCRvs23PHiIRDLq4fzzLcdNYQQ
	 E26yh+St3jbZlisIlB05T4FuLPZK/pmWzBRVp2+7mMXbOUrMwaTSYSQkH+sMfOEoE8
	 bs1+um86oXtgsH7nT9EGMA9IOskzKqRpdbKbMwPDqetgv0Mei4gIDuP2zgstiBAsIL
	 KHynBj5xcNlMT6Eu4b13OpYtDL4wvZtXqd7lNDC5ou21qaHyxXaDI0YPA/CakQlkHr
	 MjZhafSzfxDYj/YT2uIDR2mGn8NYjrWkB7VZqLauVJK2oRQQjS65JMEeLXVT0fVZg0
	 KmYUZ0Ho9yx4aqYIPdHxthehupdxvfPXlrl1QN2somPnqYLjk2kqPLDup99h2/dGzs
	 J7j2UYH9IGfaXvR7TDPLYCSAUe4OBMbUlhQqSjT/yfciuadSxTDOjG7kGF9iW7YY+u
	 Nnhpwb9whccraxcC4urUGI5rP1cIjKDfaWYnn6HIP9eP1naq9JsEZoS5UBDBaTDKp7
	 TVT13w3H9yZh+qp59Nsl4BGejWx5u7um8K/Wxr6hSYT0Ioo0dKGk2f/kFMitxIeenY
	 K2UTKoW6wuYX/d9z8bSLtTQSyqtrF9eQAE/y/qYXqrbin0pKhy8XViYe4UPkjLMTPH
	 d2R5al5HWA4ZdWsst8C0UP38=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so523835a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 21:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787719064; x=1788323864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYhyGaWYmpci56QhJSuWVc944fdh64JWw/7VVEY/WQ0=;
        b=MCY7yrf+/FYXcfa9Le/Tppsbk7cgP36/w/ESMYbh5qBszQuuKHPMVgAMVNGTlMf9vr
         qMhIX/WqC4jzg7wetMn8DRN2D2/pzvRYw7yESg0nEctUI9sRI4VAQkJJ41FPKu/wC3y9
         4DccadzheX4SSCmpLwm668QLHmQg5ro77qKtfpVaiKRzwEt+RWrGVr7vURTGpv0/vGsh
         GJElvgLwiqMF5vLIPU1Vcg2a+t8a/4NRUFtL5g2zMCxbz/lh/oZvOmS9XzcJRXiOATOM
         JPgUE7q/RDwRtfYsVOie/KW9oey5H6Sks0FG9hzjnI5rJ2V/MLI10hpGEBG2dzY2DcK6
         P4Iw==
X-Forwarded-Encrypted: i=1; AHgh+Rq17B++uJOmU5XEp3C1fBAN06lmQIAw3i/dpb6UPJm1CmPk6KSV6tfcef3dEkFD7dqZOFkbQ175c9/0E2RIDg==@vger.kernel.org
X-Gm-Message-State: AFuF++k7TWBBdFlhsvsx56BgcBI8nDvyy5op0f4HNlMIToHS4HARgeQ8
	dolTCPERZwWaBNUPm/OY2V+771RnJUGmxQraU2QOvVOTFe+hj9W9xm8WVB56YE9kfjTEdzt1S3A
	Pexg44DfFxCcEJMFvwMKsbx3ImEdwbRlDcaLWgEbcav/3ZToYRDm3b1Ai2zYWaF3FjnM0zQVPwy
	GsNdcE56xU
X-Gm-Gg: AR+sD10Ht0SQZ3UkvObKU66kGRFKWeb4dBTDc/qluIkz1Mt6B6D7+8LStAImbtgT3Xa
	dcaRvKnAJrIBDdONL9ChdT1ukBH7W7suq00fezD45ksboR7KOEXjA0hqbLU/WOcBntm2OnRWIiT
	6xBeGzGgX4HHG0XdzjMf3xtAqNsCkFqezoz62FTkfWcj08tpaypdw1w/b2KngWdyt2+R1p4CJMV
	AK2NTZQFAl2w9tQBRJY9DtEzO/VvZx+xxy2skWx/+0Klkux9t94UalStw6a+vpJ0o/SSQ711lrz
	zt5D/QB1l9lQpcGaht8XPByp6xE5OME5MNUIEUHmNGo8G3qHmJSgPOFh70mm221sBa8mcgZVFRZ
	129MEKRmR/WNrqhe5AI7ea36GTdOU7QC23VgGnwxE12ZLcRGc5DMQ+C3gOPhLL77durvR6UFGxq
	kMUtR7SIli1UZ1avrYi2Z62UJjO4sWJnSwiXycVw==
X-Received: by 2002:a17:90b:1fc3:b0:38e:9eb2:9d43 with SMTP id 98e67ed59e1d1-3966d5c1384mr8499004a91.16.1787719063987;
        Tue, 25 Aug 2026 21:37:43 -0700 (PDT)
X-Received: by 2002:a17:90b:1fc3:b0:38e:9eb2:9d43 with SMTP id 98e67ed59e1d1-3966d5c1384mr8498836a91.16.1787719063361;
        Tue, 25 Aug 2026 21:37:43 -0700 (PDT)
Received: from u-ThinkPad-X1-Extreme-Gen-4i ([103.155.100.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396689fa52csm2423547a91.12.2026.08.25.21.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 21:37:42 -0700 (PDT)
From: Aaron Ma <aaron.ma@canonical.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Mehmet Basaran <mehmet.basaran@canonical.com>,
	ElXreno <elxreno@gmail.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Jack Kao <jack.kao@mediatek.com>,
	Aaron Ma <aaron.ma@canonical.com>,
	Michael Lo <michael.lo@mediatek.com>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support)
Subject: [PATCH] wifi: mt76: mt7925: restore the legacy BSS after MLO teardown
Date: Wed, 26 Aug 2026 12:36:58 +0800
Message-ID: <20260826043658.2255553-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing the last link of an MLD interface leaves the firmware with the
MLD BSS and DEV entry: the removal loop skips the deflink, and the
hweight16(mvif->valid_links) fallback reads the stale pre-update
valid_links, which is still non-zero. The entry keeps the per-link MAC
address, so every subsequent legacy association fails authentication
until the interface is removed or the module is reloaded.

Remove the deflink BSS and add it back as a legacy BSS on the transition
to zero links.

Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index e7e6d20848d27..bb93008d3d75e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2036,6 +2036,21 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mvif->valid_links = new_links;
 
+	/* The firmware would keep the MLD BSS and DEV entry: the removal
+	 * loop skips the deflink and the hweight16() fallback above reads
+	 * the stale pre-update valid_links. Restore the legacy BSS.
+	 */
+	if (old_links && !new_links) {
+		mt792x_mac_link_bss_remove(dev, &mvif->bss_conf,
+					   &mvif->sta.deflink);
+		err = mt7925_mac_link_bss_add(dev, &vif->bss_conf,
+					      &mvif->sta.deflink);
+		if (err < 0) {
+			mt792x_mutex_release(dev);
+			return err;
+		}
+	}
+
 	mt792x_mutex_release(dev);
 
 	return 0;
-- 
2.53.0

