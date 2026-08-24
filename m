Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0D3B2FF9
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 06:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787553569; cv=none; b=RB1VzTLH3VEgvVhLfdWSP7WmHOdrGRWT9noj67ukgC9+iXU2EnVe2R/WqiUiw6dMNN7Zqf8mgP5YwgRj+ZqvUKYCV8d9BrBCzgherYZdHEi3lXI6J1Wcwtkd6ZSi5fdHohYPHUtcMAn7cXlRlfGowbdmZCHMYzmGkkIhM6O0vjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787553569; c=relaxed/simple;
	bh=cVNOTWGFcnfDjhPfRxcVEJXc0ZsmmzHR8eh3J7A0nbg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X0kb9qa+LLgWS0S+AHDViBQxXt87kXjz+uuVpJ0IMPUkLjKJtrTJ7x2hsLJM5GmYsxCweckg+feWygNvN7UmyQnjcREGa6Ala48g02yfvsnFBMCrIZwZFDdPmOa5NI7uMUoECUUss5q9kVWLKNAcr0OCcAS5dK4mC2NPjdYvyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nOlGz40V; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nOlGz40V"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a36982a875so4567691a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 23:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787553566; x=1788158366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jmoWXHrDnA23JLWWtCSyfUihNpLNYm4fQ0qRhiSEvQ=;
        b=nOlGz40VwT1ZXFeOhP+V0y08hk3Ik7pTvBMSnti+pF0f0o13svqFzoWE4W/vTwguID
         XqJYmSbZrK+oIguPcF4TY7pevxs0vjX+0DxeLRlMNhRyZ3WETId0uAf+1vFRX5lq+R6f
         3v+dGVqnYX4MuN5hWCUKCaCMl/6DjCUzeIWoJ8YRLhbBolsJqLp532yTCHwvLey3G5+O
         nUKy1/cSJgM8RT+APh+UxiWe/rrM21V/W01xmN+RHdlqM3lS+33SIRlsRG1PAS2HeKlJ
         RAtPuIgf1PIVMMEq88hz3tYaopHOoPCqRn3CEtomUygr60c9reaOuJMW+p20Y3vtBCN1
         S4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787553566; x=1788158366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jmoWXHrDnA23JLWWtCSyfUihNpLNYm4fQ0qRhiSEvQ=;
        b=WwDUTmiDsOVIJpN4l6DMM1Q1caEar1IkYI2faqhbFEueAakCg4bVigElnEU7iIyvlY
         h0fK+viTJhZHh5H0XPxePTSLoK4KNV9kIgY/7kQykhgM1S/3l3YZEoh2zohN1HCQdpQF
         5OpZzJUSPxpqY1UKy4PdyYtbPrLJ+Da851gMP5sFuswLw5AMqjDzi+OgKvNDwArmNnX5
         oX8fte2xsEp8/lLqOsim5VGdSQLuVBrQfWRCAbog7JeU3l2GP2D6flQ4sIKZ3t04Ki7P
         9FpxLi9xQhf25sYbX0RtVzN63ksmhuupLGrO6DaoKF8YEvseIEC6KyBT0VEFyPgq+COo
         MGew==
X-Forwarded-Encrypted: i=1; AHgh+RpBkRB4vW1L5EKRT3QGfuN3TCXauzRhew/6aG3L74y5Cm8WLXW8dmxOnVPINo5aiesXcUyZls0qBTU0ksGxTg==@vger.kernel.org
X-Gm-Message-State: AFuF++npwUnwZK8mdI6OghLfuO9l+mljeXYqmuCFlet4M75GEfzZiTD7
	adc5lqUFyPG6uwlz2UFEuS2gygtoYUkNd0A9RJRAkgHEw40D7yRoR8eh
X-Gm-Gg: AR+sD11VHFWF0GS2e8BGh3P2dl010/XpoCP5OftSUHt0oq//VfBBRJpxu2qlKtz2vQR
	G2ORQEX1QeoAdHbMUVGtmWpsr+diEEdJ/6OCa0oTAGgaddDCgaF0crkRjGXJxXma1VAh5kmQf0d
	VthQAZA+7UOl6XaUSolzIvy/NIiP07b+72AwN829ot9Y3qH/TbJidEDVrDc2TQ1T//t5P5YQX4g
	RNj0NhizZvRbX8u3JydtZXsR1UedP4vKoBT+WHn7nOxwE/WzbPHhHDZ9SpCkSdDpxQWNk/v3jo9
	73TjoKc5jp/iQCRmN7/yfMTM//ebX0vX7HbwocsvojPJk9dCgc8Pz0IOdRa3ik+MGAIhBZSWRH3
	e/pBaCk3jcJs+f9FPcWsf5dwYeHGp1fnCHr+E7kXPQOHqSu5JWM+73UyWcZroyYS1N6im9fo97G
	p4C2WEWKvw/l+3EUlwcHDmF3L+ljQqVg4eV7N9DYHFO9YC7jrVCWl+RcdOZMxl1OVUvAAJBtvZF
	swDM9sqdWvFKYvHDenjef66
X-Received: by 2002:a05:6402:a0c5:b0:6a1:f26d:ba78 with SMTP id 4fb4d7f45d1cf-6a42f1f2166mr28357198a12.11.1787553566338;
        Sun, 23 Aug 2026 23:39:26 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e00108asm10299140a12.2.2026.08.23.23.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 23:39:25 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	Valera Kozlov <valera.kozlov19@gmail.com>
Subject: [PATCH] wifi: mt76: mt7996: route disassoc frames to ALTXQ
Date: Mon, 24 Aug 2026 09:39:01 +0300
Message-ID: <20260824063901.311-1-valera.kozlov19@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If AP sends deauth or disassoc to a peer station while the station is
in power-save mode, the frame may queue in the normal ACQ and lead to
PLE hang, since the station won't wake up to receive it.

Deauth frames are already routed to MT_TXQ_PSD / ALTX0. Extend the
same handling to disassoc frames, and additionally route any frame to
a station that hasn't completed authorization (tx_info without
MT_WCID_TX_INFO_SET) to ALTX0 in mt7996_mac_write_txwi(), clearing the
flag again on MT76_STA_EVENT_DISASSOC so it gets re-armed on the next
association.

MediaTek's vendor tree has an equivalent fix, though written against
a newer MLO-aware version of this code that doesn't apply directly to
this tree:
https://github.com/mediatek/mtk-openwrt-feeds/commit/ed6924828479aaeadbb7c402ec390df26dcbd8bc

Signed-off-by: Valera Kozlov <valera.kozlov19@gmail.com>
---
 mt7996/mac.c  | 2 +-
 mt7996/main.c | 1 +
 tx.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/mt7996/mac.c b/mt7996/mac.c
index 570f85d7..10d4264c 100644
--- a/mt7996/mac.c
+++ b/mt7996/mac.c
@@ -932,7 +932,7 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	} else if (beacon) {
 		p_fmt = MT_TX_TYPE_FW;
 		q_idx = MT_LMAC_BCN0;
-	} else if (qid >= MT_TXQ_PSD) {
+	} else if (qid >= MT_TXQ_PSD || (!(wcid->tx_info & MT_WCID_TX_INFO_SET))) {
 		p_fmt = MT_TX_TYPE_CT;
 		q_idx = MT_LMAC_ALTX0;
 	} else {
diff --git a/mt7996/main.c b/mt7996/main.c
index 1afb926c..8d45af3e 100644
--- a/mt7996/main.c
+++ b/mt7996/main.c
@@ -1414,6 +1414,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				goto unlock;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
+			msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
 				mt7996_mac_twt_teardown_flow(dev, link,
 							     msta_link, i);
diff --git a/tx.c b/tx.c
index b863e449..6bcad275 100644
--- a/tx.c
+++ b/tx.c
@@ -689,6 +689,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		    !ieee80211_is_data_present(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
+		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
 			qid = MT_TXQ_PSD;
 
-- 
2.53.0

