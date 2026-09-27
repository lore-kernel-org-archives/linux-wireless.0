Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2638736C
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543062; cv=none; b=PcxUQD8x0pMaMmS25szwarcotcO7nBw/vGhXEMtqtKzhvaFi5RslsjtDC6yQouYIHsRb9EnM4ABjGCDx2iLYfCrU/fWYJLQFtqvrrlfq78468Tdswkvwk0VPipbqGq1QfQBUhfdYYrQ7ww8O58GwbMYB8ABd57OW0y7rge1aOOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543062; c=relaxed/simple;
	bh=rQ0SahECWBWKxnJ6zkDAtVSZSZ9ihM0DPA0zL9NHHWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V67tZDHcSCHuzCFsPA2LhE/Mqy+BJGOwiZFCGnAfiSWEeZf2VAzntWX3FBu/6KZMHI2ynBDVPhxbLc2AqcjKH2AQMl/lUFsdwC9gcClGZpw7kBiOxQEGhVSKmIJgiFVgWc7f1/VrTgZ1SFZjnOGXF4q/KeoosBduACDS04c7ziI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8a8528427a8so7262007b3.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543059; x=1791147859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d8o/w5oQz/mdjVqAVnhnoJdfXPk/8JAmt24eFT+WbC4=;
        b=KlAGGHtm/alLD8ShYBRYGiCPUV54dZKjRfRuRhdoXBwZER66xdkAzSC/liFe6d5R2k
         c93Jbg5O+GD1xazfPH/cd+2G7lsziiarROpPLT/W6MSakaB00NPvG2wakV8JG6LZ4oVl
         SK/dUL0nF/3THBNZOJTFT1jMPC/I87+BtF6KVbBIR0DFzyc9Xf3M3ePRp4UJe5aXmHVe
         e8q3hez7C5WrXh/6qYZ9TrleYiaOMSj8SE2OJzIL8DAcdKRbJfX+zy6cxlhSghAeWPua
         MmOD9DvgRsPEC5pn9zwINkHWxHIaKpXQbs+lmSUqwlPtFLY9Zhbbs2lDR6wPP3pSfbuY
         vt3Q==
X-Gm-Message-State: AFq9FYJeEnHIu3xSNPyp5eXjNwGgUGBWefG8p1Jdl1zalGeuBIulW27W
	MaM2nzBq3kxhf52wv5sLfysAb03iogIj3mcCUMb/BT6f/GLzBZkOhb6s
X-Gm-Gg: AYBFou251dodB15k+haROmhAs3A6IignNVWQNtDa/uiAm858S1TUNerJdCAEBXFyztP
	0YLLXNPpkSGRLzJtfmHo0Aq3jy4WZB2r/Rm8KYNPVTaAI67dG5CuxqK184mIuFXpjOXBRcjVzR7
	d1Yf0BAhCqgnPTjyMAya1Tbtp6l3ZhRcIkUSNVVQohFQGTzcNuwLZlzIve3KROhXulkeNbhNJOy
	PdTvlGGiZ0+qskAqMFXmu+XN/xENQla2yh3h5TEUNFLBFfsAnJEl+1GUld07fMdOnqDM9x6bXhu
	rIus3UszX0N8QCymLUza59QRyNXpSf6/kAdgTSL+RnsQAooFiL314H3PTvRbc40HSwLTHPCfHq1
	ozsf1ogB5XDNE4y5d1bcGCZPH1YQBrn5AGKl2Tn8Mq+iTJPmyG/uaWx9EvCMHp6MfgiGG0SoOQ0
	LLxmA8BoPuqTh7eVUiitHc58kYbZQsP6uhEl8M7OJhp7Yyd8FC/SCQ6sY2SGNj+XFabr5esnnG2
	pUOZpWGLo7cKWOsxtsFV+ASh8JcnOjO/fnqLFUa0HSfcDPOegImP3wd2oqj26moT2POf3M=
X-Received: by 2002:a05:690c:7107:b0:894:b231:7a0c with SMTP id 00721157ae682-8a647275e4fmr57902327b3.0.1790543059548;
        Sun, 27 Sep 2026 14:04:19 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:18 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 18/23] wifi: mt76: mt7925: defer the NAN joined-cluster event out of NAN_START
Date: Sun, 27 Sep 2026 16:03:00 -0500
Message-ID: <20260927210306.737669-19-sean.wang@kernel.org>
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

From: Jacobs Wu <jacobs.wu@mediatek.com>

The firmware can join an existing cluster from inside the passive scan it
runs at the start of NAN_START, so NAN_EVENT_ID_JOINED_CLUSTER lands while
the start path is still executing and ieee80211_vif_nan_started() is not
true yet. The handler dropped the event with a warning, leaving userspace
unaware of the cluster it had joined, and service discovery then never
completed: measured 4 failures in 12 NDP bring-ups on an MT7925 pair, each
one accompanied by exactly one dropped event on the joining side and none
on the side that created the cluster.

NAN_EVENT_ID_STARTED_CLUSTER already defers past NAN_START through
nan_deferred_work for the same reason; JOINED_CLUSTER is the other exit of
the same firmware warm-up branch and needs the same treatment. Queue it on
that work with its own cluster id, so a started and a joined event pending
at once cannot overwrite each other.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 20 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  1 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 715e080ce4ee..7aacfd6527e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -709,8 +709,20 @@ mt7925_nan_mcu_handle_de_event(struct mt792x_dev *dev, struct tlv *tlv)
 		return;
 	}
 
+	/* JOINED_CLUSTER has the same race as STARTED_CLUSTER above: the
+	 * firmware joins an existing cluster from inside its start-up passive
+	 * scan, so the event can land while NAN_START is still running and
+	 * nan.started is not set yet. Defer it the same way instead of
+	 * dropping it - a lost join leaves userspace unaware of the cluster it
+	 * is in and service discovery never completes.
+	 */
 	if (!dev->nan_vif || !ieee80211_vif_nan_started(dev->nan_vif)) {
-		dev_warn(dev->mt76.dev, "nan: joined-cluster event but NAN not started\n");
+		spin_lock_bh(&dev->nan_deferred_lock);
+		memcpy(dev->nan_joined_cluster_id, cluster_id, ETH_ALEN);
+		set_bit(MT7925_NAN_DEFERRED_JOINED_CLUSTER,
+			&dev->nan_deferred_pending);
+		spin_unlock_bh(&dev->nan_deferred_lock);
+		ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
 		return;
 	}
 
@@ -732,6 +744,7 @@ mt7925_nan_deferred_work(struct work_struct *work)
 {
 	struct mt792x_dev *dev = container_of(work, struct mt792x_dev,
 					      nan_deferred_work);
+	u8 joined_cluster_id[ETH_ALEN];
 	struct ieee80211_vif *vif;
 	unsigned long pending;
 	u8 cluster_id[ETH_ALEN];
@@ -740,6 +753,7 @@ mt7925_nan_deferred_work(struct work_struct *work)
 	pending = dev->nan_deferred_pending;
 	dev->nan_deferred_pending = 0;
 	memcpy(cluster_id, dev->nan_started_cluster_id, ETH_ALEN);
+	memcpy(joined_cluster_id, dev->nan_joined_cluster_id, ETH_ALEN);
 	spin_unlock_bh(&dev->nan_deferred_lock);
 
 	if (!pending)
@@ -753,6 +767,10 @@ mt7925_nan_deferred_work(struct work_struct *work)
 	if (test_bit(MT7925_NAN_DEFERRED_STARTED_CLUSTER, &pending))
 		ieee80211_nan_cluster_joined(vif, cluster_id, true, GFP_KERNEL);
 
+	if (test_bit(MT7925_NAN_DEFERRED_JOINED_CLUSTER, &pending))
+		ieee80211_nan_cluster_joined(vif, joined_cluster_id, false,
+					     GFP_KERNEL);
+
 	if (test_bit(MT7925_NAN_DEFERRED_SCHED_UPDATE_DONE, &pending))
 		ieee80211_nan_sched_update_done(vif);
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 415fd6b6f0e6..32740e3769d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -143,6 +143,7 @@ enum mt7925_nan_key_type {
  */
 enum mt7925_nan_deferred_event {
 	MT7925_NAN_DEFERRED_STARTED_CLUSTER,
+	MT7925_NAN_DEFERRED_JOINED_CLUSTER,
 	MT7925_NAN_DEFERRED_SCHED_UPDATE_DONE,
 };
 /* NAN 4.0 Table 79. Device Capability attribute format, Supported Bands */
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index ee462eab4028..8e1588970ac1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -446,6 +446,7 @@ struct mt792x_dev {
 	spinlock_t nan_deferred_lock;
 	unsigned long nan_deferred_pending;
 	u8 nan_started_cluster_id[ETH_ALEN];
+	u8 nan_joined_cluster_id[ETH_ALEN];
 };
 
 static inline struct mt792x_bss_conf *
-- 
2.43.0

