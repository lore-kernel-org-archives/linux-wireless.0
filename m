Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870BC231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543010; cv=none; b=VQqG8m4uIBAO49Qdnv0qno4UvcnjoGmfs2iqUzgE81AgkjS3NufFsZzRgnM4GxstqAaQMQugTGWTFiOmfYvmWKR+l95Ek2TwijJIih3E7Q3A8Ha1GgrFtAvJ9mdAsQzc7iAeIbCSJsnr3ESrXzUolRSSu1vAC0hbOshCJ2vimj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543010; c=relaxed/simple;
	bh=nH5eJK7diJA9NyHsQQ/GdoNMKzGq6Hp2pqZq7PUeOTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBgECyQiICwlWRMSlH9LSzPLmtxUJjMhqlsRepvKXW9Nn9NSeFJyP5Swoo7ibIj+JHkc+EQJ1hwqcKAysLQ7y31fzt0DVBbz3/QZmja7FPGGgLduSoKjQzszFh4Eztkk9b9Cc9MkHQOccR6Ys9TwgFzoU+JY+q0ex7DuDLWGg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-674784a9f64so775119d50.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543008; x=1791147808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tnVe5wEQo3FDnPgMfTarlYCeiDz8F+kBL76gyVnRNvs=;
        b=n6ziDcHbn8AsQW/nRvLvTVST+2GUBDC+Rw0uLCwf4VcSWCwZqFwO/FVUafGWmf0ODL
         ol8hiL5yUbZan9amLcS5njZe7FAGbwzZw7KSJ92t536soySBcpZBcY9pmDSyPVuD686v
         c6pr8dIVxfWIBRyOjE4ilwFZ0ZpGkWV0IATwXYzj/HoI2XvxQLhbyky8MxIlzpdlq2W+
         Q/rYxLUurGuTY/3TxA/FnulPg6cWtqHy3qiddGOPb0hZj4Rr/4AFDgIlh+0+rrxd934P
         TK3rQL8hH1aewhzRdMPDHsArpcSBtKsmeGjyTC/kPVTkhmec9bouLYZ4zex4owWEQ5x4
         DATw==
X-Gm-Message-State: AFq9FYIwqdgVbRgUwAKs3hz80AyuxbN4LO2v1pIvAohSz9Rel2E+scaW
	sK3ZHE4UrzkSMtd9bVYC2NUUpo1ooz5Kc30TCLB0zKLnneVonSAc16CJ
X-Gm-Gg: AYBFou2Cl487BoAl8qW3X/VCVR2Oi6JCOWhrNU7DeLXI34lMLhDW/4T67gJnNrERNG2
	lHAXpuTQx49n41DsDq4cMAZjXksw34F3ojjmrNtyAX9V7wEGmGd64rsTlPUbK/xSoFugDYSmH9N
	qYRbzdv6sBwsmgpttY11SILMrPUbKtPp1w6SRQDmQKs37s3AO+EDZQcL91BtCzqFxgh2TwN5RbY
	hmq2xSRAaYrqZhsheNWxbcgz2D4lV3lK/uMvUCwOdz1Ofo7zIW/DiZRpNlfpdhn5hFm7Dor6b8+
	cCHJy585UpCz7gegXOGTbIa2gHtsSl539gnyYh4eFAh2fAuwk0ah2v7ney99bzBeN14pwiTy8KO
	m6IymPTGZsNJm0qEksq5B+MiUiCu6n0B9uolwHOZg/xK+oJcuLjjbxJok2tJzlK3noXDbIpcXyg
	WgvFQVPQng6p45kxmSP0RxkdwOHXPxskGxlrnKYCKaHN1Af7AQVl0GhAAjAwhaGagtIR1EETs+k
	W+mndwAQREH3MgxnTva+s37xtgurJFaEEpOkTMv6T9rKeomtAG9/vNhm/OQtIxvME3u2Vw=
X-Received: by 2002:a53:d017:0:b0:675:3363:676e with SMTP id 956f58d0204a3-67533636cfamr1249316d50.10.1790543008270;
        Sun, 27 Sep 2026 14:03:28 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:26 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 03/23] wifi: mt76: mt7925: implement NAN MAC address randomization
Date: Sun, 27 Sep 2026 16:02:45 -0500
Message-ID: <20260927210306.737669-4-sean.wang@kernel.org>
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

Add mt7925_nan_start/stop_mac_randomization() using a per-vif
delayed_work and period stored in struct mt792x_nan.

Per-vif (not per-dev) because the NAN iface combinations allow up
to two concurrent NAN_DATA vifs; a single dev-wide field would
silently lose randomization for the second NDI or let it overwrite
the first vif's pending work.

delayed_work (not timer_list) because the work function calls
mt7925_nan_set_nmi/ndi_address() which invokes mt76_mcu_send_msg()
with wait_resp=true; that can sleep, which is not allowed in softirq
context. This is consistent with scan_work, mlo_pm_work and ps_work
in this driver.

stop_mac_randomization() must be called without holding the dev
mutex since the work function acquires it. No caller is wired up
yet; the next patch does that in add/remove_interface.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 59 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  7 +++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  9 +++
 3 files changed, 75 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index abbd3f7b081c..0b94bd4005d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -745,6 +745,65 @@ int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
 	return 0;
 }
 
+void mt7925_nan_mac_rand_work(struct work_struct *work)
+{
+	struct mt792x_vif *mvif = container_of(work, struct mt792x_vif,
+					       nan.mac_rand_work.work);
+	struct mt792x_dev *dev = mvif->phy->dev;
+	struct ieee80211_vif *vif =
+		container_of((void *)mvif, struct ieee80211_vif, drv_priv);
+	bool is_nmi = (vif->type == NL80211_IFTYPE_NAN);
+	u8 addr[ETH_ALEN];
+	int ret;
+
+	mt792x_mutex_acquire(dev);
+
+	if (!mvif->nan.mac_rand_period_sec)
+		goto out;
+
+	eth_random_addr(addr);
+
+	ret = is_nmi ? mt7925_nan_set_nmi_address(vif, dev, addr)
+		     : mt7925_nan_set_ndi_address(vif, dev, addr);
+
+	if (ret)
+		dev_err(dev->mt76.dev,
+			"NAN: failed to randomize %s address: %d\n",
+			is_nmi ? "NMI" : "NDI", ret);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &mvif->nan.mac_rand_work,
+				     secs_to_jiffies(mvif->nan.mac_rand_period_sec));
+out:
+	mt792x_mutex_release(dev);
+}
+
+void mt7925_nan_start_mac_randomization(struct ieee80211_vif *vif,
+					u32 period_sec)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_dev *dev = mvif->phy->dev;
+
+	if (!period_sec)
+		return;
+
+	mvif->nan.mac_rand_period_sec = period_sec;
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &mvif->nan.mac_rand_work, 0);
+}
+
+/*
+ * Must be called without holding the dev mutex: mt7925_nan_mac_rand_work()
+ * acquires it, so cancel_delayed_work_sync() here would deadlock against a
+ * concurrently running instance of that work otherwise.
+ */
+void mt7925_nan_stop_mac_randomization(struct ieee80211_vif *vif)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	mvif->nan.mac_rand_period_sec = 0;
+	cancel_delayed_work_sync(&mvif->nan.mac_rand_work);
+}
+
 static int mt7925_nan_avail_ctrl_tlv(struct sk_buff *skb,
 				     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 9fd349e1cdab..191134825c3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -503,6 +503,13 @@ int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
 			       struct mt792x_dev *dev,
 			       const u8 *mac_address);
 
+void mt7925_nan_mac_rand_work(struct work_struct *work);
+
+void mt7925_nan_start_mac_randomization(struct ieee80211_vif *vif,
+					u32 period_sec);
+
+void mt7925_nan_stop_mac_randomization(struct ieee80211_vif *vif);
+
 void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 				    struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9722d840c1af..64cca8852359 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -181,6 +181,15 @@ struct mt792x_nan {
 
 	/* Connection index bitmap, up to NAN_MAX_CONN_CFG peers */
 	unsigned long conn_bitmap;
+
+	/*
+	 * NMI/NDI MAC address randomization. Kept per-vif (rather than a
+	 * single pointer on mt792x_dev) because up to two NAN_DATA vifs can
+	 * coexist (see if_limits_nan_mcc/scc), each needing its own
+	 * independent randomization period and pending work.
+	 */
+	struct delayed_work mac_rand_work;
+	u32 mac_rand_period_sec;
 };
 
 struct mt792x_vif {
-- 
2.43.0

