Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792936921;
	b=ZjGgLVukx/XLoVPuuYa7yIRj/dav5bXl6+QRvSwij0ZW1yii8LjKdIX8ZlhCdKWV9A3n
	 93DQICa/1n54rdrZaVwTgFZcq162xiYob8mSS4+YY3CvyOQVUIN/G5NtUsWv4cJxIJ56F
	 DfdO1PvwuPmpEq2ulUoS+CArOTsZnBbc1sbcvYIzRMx51dsOS43P9a3FkCRJfwuHkoW9l
	 YwaHa3sPUcYcf95zpGzQNvz+dLAe8DFo1K6G9VRIhnjRtiNNukCrbuHI86PYkNKrV4z9E
	 ywiKfzVqd2iAD0Wv9mH+uvsC8ALI1wYl2n6BoU/ZNJAB53W5UHApo0OaVotqZIC3eag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792936921;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vrMXt1z7sqI2rPBLPoXnJ9DxZ7jNjEuTfkEKdCrv0eo=;
	b=Wql5ajYlmDc862niIMDClctpwOcqg76M4goPq/LA4N1CJtS/kJYZnxUPvTxuHULjMqkU
	 aYyQAxwNW12AWYciWBP6spaiqIg7CZrwmYt1bPZrvSZEZ2IzHDkAb/GVoGzjPE0O+xR4K
	 7m90nXD0GcLd+/TtvnuYY3n18KbTO0p5WC7wDk1qeH9zFJz85thwm+F1k2WLB7EPLtZoS
	 ypuUMaM8q6meZ/XoHl32SwOx78fhx/u/liql6JDrRSTTmFTVDroAjbGQaypSTo3zLciCb
	 Ef9Lv9p+82DqMFWpbP5OGNCX8U8TWsWE0TTXKz+EVhH6R97C6oZE+vXBE8KXcJup7qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qTIefrEl;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A1606A329
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 14:02:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F7A1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qTIefrEl
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3550c917fd3so3379659eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 07:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792936920; x=1793541720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vrMXt1z7sqI2rPBLPoXnJ9DxZ7jNjEuTfkEKdCrv0eo=;
        b=qTIefrElyFSBonKz3NWQEjyMYd2mF5liGilEmC2qnXcQs2bY8gzLi0n9lTS9i4yVw0
         IjWK+TrbICAO6Mjq4nUDMZM901xSQYWk8PCuUpR0X536VWB+2yoQcMa0lsT8Dq8FSL2j
         B2f20NHADJ2PA19gm48G1ZHuvHaoUNIBmaAZsR0TQdpzQWpNl+wY7zQe2CfC+7woBY/D
         EftUZEBtRWub5um0Ham7K+9R9HcEm247U9pswSPkDaads3zr/S1BS3NuBc5fDmh8dK0R
         T3jEXlgigFcirNCJh09dvo95zsHuICwitlsUTGlVTwzVHkt2aLo/sDUDu/QI0OZ+jxJ1
         lSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792936920; x=1793541720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrMXt1z7sqI2rPBLPoXnJ9DxZ7jNjEuTfkEKdCrv0eo=;
        b=i1V/7yOFAZXaCz2WFMkD8gTYjjzyIGtK7TNNGnLSnZsX87QXc2qV/GqXyveRHHvs3S
         YgHKwJTSnqXCnDJxsMtUHnDrDgzZo3uCk/GMJRp6zsLQuhzpxt/YY4NhLNiatx3NcByi
         IXRgkDIy3P3RfXMTWgevn7G1LJZr5XUYJC8/NJWpuSh+JaKIR4LqbTOGoxAqDYn5Y32C
         7awKOndwG/YQEKketgtzjWOGiMXNCwcW8jLuqEUVyM5QOeLBZoBGo19o6ShYB5gnu62I
         ztwAJ/m41eIvFL/bStU0VHwwAYB6mxXbhEhwKCrFXM6WREUbcWzpxde2uqd+0iNyE3iK
         0jdA==
X-Forwarded-Encrypted: i=1; AKwUvBwL6ZhK+A8mXFj1Trh+u+RFZoS2+/phVh7CkQj1VoEOMmst4VTQoA1W9OrA5YizZvhH0IG8aMCNscMTxlUueA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIJSVXvZOvInlZqllzx3YCMmIVJIVaorUhz4OYKVuHlolrhZCq2
	q+Lhd7PhPGh1CXUfSB8VYLwF6le11r+5TZD3JUqrKemZisM+PqwzfN44
X-Gm-Gg: AYBFou2VZ4zxhOmMV3/+QkRCIGT5XNn0AK8+y2uu1AHiXIt2yg2LPlZ+AZg7eqZSDFn
	CjnadHIpOHECmQrjtPYYP3UyalF3AJZFcg+P7MZrjOKC9zffeaJvR9/TIQnt7n5Cr8C9h8k5syK
	FKluDOR9AWCvmltsfJ0j/48TRuJUF82KkAfEYrFPbQdElIr+yGClhM5jZPXWcta0dDA12w/s03f
	3GskksiVBTYmPUIkaUPOVuKBewOsM//oMENRev/7FOlKoMiEko0xEJgG3EmzMcEEkxQxu6nByTk
	7IEnXmZVuhoqJpWfOAUoh2nUxt9RLGMPQYtE5IAbawwpI7wfCaNBCzZHuur6/1lL1i5CrWwmHcR
	xb7fZyN0MBsRsCG9EH8JgJRHR47woVYCDgghW/XqzXTS6D7g2ARWgIWUEIBueSTlyMYJI8lKxcI
	5Y+I7mID7SOULwASY6Ac+UwCsrSPcGX31wKE7CVxLHChpTkR5axHQke37/CLEJyqHNkbFX9MzKI
	8Ruu2ojYsNzbiYIpjPNzx3Hr7rCUdf/+tVrb7L6oD8lhkYtwc6CbxVUuzBvYtq67yVKQuxkeNzx
	g0uVB01QD4KkcdgqmH2JXRywbRvuTt8vWZ32Y2w=
X-Received: by 2002:a05:7300:8aa0:b0:35c:ceb0:8bf9 with SMTP id 5a478bee46e88-369e84e00acmr6241494eec.38.1792936920256;
        Sun, 25 Oct 2026 07:02:00 -0700 (PDT)
Received: from Gris-Laptop (gia.grisge.info. [67.230.185.89])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369f4164886sm9280272eec.7.2026.10.25.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 07:01:59 -0700 (PDT)
From: Gris Ge <cnfourt@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Gris Ge <cnfourt@gmail.com>,
	stable@vger.kernel.org,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt7925: fix NULL dereference in CSA worker
Date: Sun, 25 Oct 2026 22:01:18 +0800
Message-ID: <20261025140123.12056-1-cnfourt@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`mt7925_csa_work()` checks `dev->new_ctx` before taking `dev->mt76.mutex`,
but the pointer is re-read and dereferenced after
`mt792x_mutex_acquire()`. That check and the later use are not serialized
against a concurrent teardown, which can clear the pointer in between:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:mt7925_csa_work+0x83/0x160 [mt7925_common]
  RAX: 0000000000000000

`mt7925_remove_chanctx()` clears `dev->new_ctx` without synchronization
against the worker. During a channel switch mac80211 frees the reserved
channel context (calling `drv_remove_chanctx()`) before
`drv_abort_channel_switch()`/unassign can cancel the worker, so it can run
with a context that was just cleared.

`mt7925_channel_switch_rx_beacon()` is serialized with the writers by the
wiphy mutex; the worker is not.

Protect `dev->new_ctx` with `dev->mt76.mutex` in add_chanctx() and
remove_chanctx(), and validate it under the lock in `mt7925_csa_work()`.
Keep a local pointer for both firmware calls so the context can neither
become NULL nor be freed while it is being used.

Reproduced the panic by injecting CSA-less "abort" beacon, works well
after patched.

Fixes: 7900da40e315 ("wifi: mt76: mt7925: introduce CSA support in non-MLO mode")
Cc: stable@vger.kernel.org # 7.1+
Signed-off-by: Gris Ge <cnfourt@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 15d95ad32636..fb5f9aa3534d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2020,7 +2020,9 @@ mt7925_add_chanctx(struct ieee80211_hw *hw,
 {
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
+	mutex_lock(&dev->mt76.mutex);
 	dev->new_ctx = ctx;
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
@@ -2031,9 +2033,10 @@ mt7925_remove_chanctx(struct ieee80211_hw *hw,
 {
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 
+	mutex_lock(&dev->mt76.mutex);
 	if (dev->new_ctx == ctx)
 		dev->new_ctx = NULL;
-
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static void
@@ -2509,11 +2512,13 @@ static int mt7925_switch_vif_chanctx(struct ieee80211_hw *hw,
 
 void mt7925_csa_work(struct work_struct *work)
 {
+	struct ieee80211_chanctx_conf *ctx;
 	struct mt792x_vif *mvif;
 	struct mt792x_dev *dev;
 	struct ieee80211_vif *vif;
 	struct ieee80211_bss_conf *link_conf;
 	struct mt792x_bss_conf *mconf;
+	bool roc_started;
 	u8 link_id, roc_rtype;
 	int ret = 0;
 
@@ -2525,26 +2530,27 @@ void mt7925_csa_work(struct work_struct *work)
 	if (ieee80211_vif_is_mld(vif))
 		return;
 
-	if (!dev->new_ctx)
-		return;
-
 	link_id = 0;
 	mconf = &mvif->bss_conf;
 	link_conf = &vif->bss_conf;
 	roc_rtype = MT7925_ROC_REQ_JOIN;
 
 	mt792x_mutex_acquire(dev);
-	ret = mt7925_set_roc(mvif->phy, mconf, dev->new_ctx->def.chan,
-			     4000, roc_rtype);
-	mt792x_mutex_release(dev);
-	if (!ret) {
-		mt792x_mutex_acquire(dev);
-		ret = mt7925_mcu_set_chctx(mvif->phy->mt76, &mconf->mt76, link_conf,
-					   dev->new_ctx);
+	ctx = dev->new_ctx;
+	if (!ctx) {
 		mt792x_mutex_release(dev);
+		return;
+	}
 
+	ret = mt7925_set_roc(mvif->phy, mconf, ctx->def.chan, 4000, roc_rtype);
+	roc_started = !ret;
+	if (!ret)
+		ret = mt7925_mcu_set_chctx(mvif->phy->mt76, &mconf->mt76, link_conf,
+					   ctx);
+	mt792x_mutex_release(dev);
+
+	if (roc_started)
 		mt7925_abort_roc(mvif->phy, mconf);
-	}
 
 	ieee80211_chswitch_done(vif, !ret, link_id);
 }
-- 
2.56.0

