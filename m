Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A763750D7
	for <linux-wireless@vger.kernel.org>; Fri,  6 Mar 2026 23:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839426; cv=none; b=oZPVlC6Z7CAETwZFavCutuJHM5EafHEOHIiCrO/RLTppPAQTEBNUjmx+wGl5vmKhsaUS34wMo7WtN8Yrsq3JjMOkCDY7b55+GNQAxzxM0c5m/uDQixu4pZN5BK9c22C0wRRx0+94XKqQNhfStAsXuNR+CLMb82+p+BkvZC157/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839426; c=relaxed/simple;
	bh=hponGLUfeo373opIabJrczW4FDADkBKMEjQHdDmSzIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7dCCThknoQr29nA7SxiQjiyKVT+ILWhfMkAJkTRlc+XCzrL7bhC5Ktzg57HnAMKfa082styQx97dAh8b+EFFlhwNcLEnbI5EgadNmHuAtswxZucKqmBv2/i4wapTMR/n4ywFmqW2LzzjpVzB2K3GoNqLUAyAr7lEz/hZInTENY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40ede943bf0so2759080fac.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2026 15:23:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772839424; x=1773444224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PrlATq/D6VsacUIKx37oVLOAJoVj59zJ+W+tciW1eZM=;
        b=ewHYPr6JzrhuC04zGF02Vvh8ZWMkHDDI584SZaP6ugU2m0DQoLDSC+LuOHS5avpYP7
         +NO0t0M6clrV+r9laa0lInnuiKq9FbxAHr321RsCG0rsSfSsiBjFWxnZ1JzCWNfM/hLy
         djpuNumjsd+/o4dY5jYojilA8Y8PtcK/rfdD52Mr+W6LSBD8rOJz+ndh/4Kxnwru0x0a
         zngeHLNvz5GavSbj53rSeXP8kJmRekp6Ll4at/UGhng9AXtjU63sjDcD2SehoHOTMIvc
         KDlGKpy7ccTkHhBFqcRQOntW0Ut+JJeP57w0foAXWfaOWEFK10SUQGGyhG3f7I4jQ4vK
         RCgQ==
X-Gm-Message-State: AOJu0Yx4bGXovc+5scZEQM5/fnRb+pLXIncfdflue9c3NQPApKsCC8oU
	vCEQSYgwsEuTzKEmRXda/RBMtr88YG4fr3pZbwxk/v7p3b/slTbydPC5nmiFLw==
X-Gm-Gg: ATEYQzy0L63OH7KQ68/QyUgxqmlhK9lEZ0p1Vg9trTZHN1juHwoa91kGpgvANLWmrFH
	f3UB9qR/coJ8gz5szDrFwKz8NmT60D9vZAU76DxZ2DBXhZWSFQo0kl9Kj2560T5364o/9Kd1HBJ
	CcRW00Bez0Gm0CfFuwQ9sHcBO41oLotNcjQ6Sbibn8c1Mk3Eh0b1JQ3tFnvLYwAe/ztisvKQZjh
	oDH1C9xWDfQ64Y/AkoHtSR9jztC4H8WA3I45pnZudogk2WNv5CltMt4KLnmPEEIrif0xFgUTBsG
	FYEd0jhYQpz8zSBPYAjJtf5ebRK2Tgq1Rspx+cdmekQs36C+SONZ5O008VoIfVxcUn/eiwbG2+Y
	6JnNDM0kQL9ty2qM2dqljlmLA0iyYL6gQXgzqbrxWaI/04cvdxtFAnMIlURuk/XE3FGnytHV5dH
	gVxJTB3rNCP1RH/OwCCqVMLTRGI0nHVgILsTlSBfYZe8spCT8=
X-Received: by 2002:a05:6870:8808:b0:409:57ae:54e4 with SMTP id 586e51a60fabf-416e3ebf34bmr2140349fac.9.1772839424105;
        Fri, 06 Mar 2026 15:23:44 -0800 (PST)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-416e65b1c82sm2572344fac.5.2026.03.06.15.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 15:23:43 -0800 (PST)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 13/19] wifi: mt76: mt7925: make WCID cleanup unconditional in sta_remove_links()
Date: Fri,  6 Mar 2026 17:22:32 -0600
Message-ID: <20260306232238.2039675-14-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306232238.2039675-1-sean.wang@kernel.org>
References: <20260306232238.2039675-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Drop the dead pri_link check in mt7925_mac_sta_remove_links() and
perform WCID cleanup unconditionally.

mlink->pri_link is already cleared before the test, making the branch
ineffective. This matches the actual teardown behaviour and simplifies
the remove path.

No functional change intended.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 151dc79f7c12..584d989fb4e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1221,10 +1221,8 @@ mt7925_mac_sta_remove_links(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		mlink->sta = NULL;
 		mlink->pri_link = NULL;
 
-		if (link_sta != mlink->pri_link) {
-			mt76_wcid_cleanup(mdev, wcid);
-			mt76_wcid_mask_clear(mdev->wcid_mask, wcid->idx);
-		}
+		mt76_wcid_cleanup(mdev, wcid);
+		mt76_wcid_mask_clear(mdev->wcid_mask, wcid->idx);
 
 		if (msta->deflink_id == link_id)
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
-- 
2.43.0

