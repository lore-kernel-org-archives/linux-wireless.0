Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7582472AE
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543042; cv=none; b=T8tT3GkjHh1sCTTDsexg5NRbYD0x+igQXPfxRpV5R/QnXAmtZyTKnDSIVhkeidgTO/ol6k4XSAzqH4waQrjAxrw1+ctpvoa48pKWC+gbNuFuNTlJv2LPx4eWWGbrJDoa0yl6lwmVVmpz41EL1L4LAiQLCBJystrGHGwyMWktKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543042; c=relaxed/simple;
	bh=p5Ya4V+IM4LW1JeEl8YghJGIuKeaNFNyJJeicNbaa+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvwDjBnvrvtKyc6ipaQlyoVrEVU8c5liPy+XoF7yQEwtn3qaYtRr1BN5AflRtZSjc9wUVALZS0zMWTL3YMswe3LUlPx/Z9mR/UF/unQ5Vy03if+f40d7ouYYyrzNFgH9r7AT4yqtVoqDKuVRzpR7g+rGAKUWZdCXhkG7Bsvn/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8aa75b33a26so2826237b3.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543040; x=1791147840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8TTonhnwGQ3c4+ryD77q2DmYJVEgRAWoW9sUOCsWdn8=;
        b=SzuOL9MfhcaRNxIbtdbn81i5LDK1d2DRCHiDU0aSMN61OL/QW6QRQZArhU0lBS5WXJ
         5u/OwhHZ27iLVWrisegrffI4uqV8mnvw9wKAf2c+XCDDAVXVgi8+BatqWUIu6isbbCdT
         NW76y/3/Nmkc1ptnshFLB9Sfx8ymyYZ0N69nbXMOYnqMavDg1nNk7dmqUnAHbjPwto+4
         4UfHDHBtxgar9gZLjguZhAXQuULACp0qbNYJRedIOFDdxrA3u3VssIREcdvGq8DWURg+
         6rSzRR5IlFw1lJTzliR/EECuwfNjKrvcnwh56cNinsZPJOcIKXYj0x2VKgdMzEIZ5eqK
         fpcQ==
X-Gm-Message-State: AFq9FYIMDFjDFCGYnkGhLtuLmtJ94yfahb3K+wyNJzMENfQUAkBuGbK0
	OlHybYxpdYgdml5qEOFyih93khTPSS7puSazUUup8pj47OEmf5wy4/P/
X-Gm-Gg: AYBFou2WL3nR7103lRZ/kh5Tep4QAyJeP4HTkCkC7dZAJMjZ+Ssma+5AtKE3sBU2xwy
	xB6LEE6SGPMlLbApjnRi/mzw2DGxttWPukXUPQCBoAnxjXyiADfiX7k6EARNn23t9m9k8DwMqVl
	WifW2AjV2i0YshjRYJNlom0BJKjbW1h86tzKQ+ZfiIwHHyjAlZzudfFAMN8RQV8lty0jt1rPvSA
	v9dDp5kSVoHM/whi+XKbdEfGU+UrfOSWJMTmslIzfHAc0O2IDNWMlVOk31qFMvp41QiQMmSw4dv
	6o9ETlmM1upcXSyP/K9wLYAdQPKRkHAUdGDjq1KpwBmNp2ZESUxWhw/DcU4yRakLAdF+68sYqnb
	yMefcXVvqGYo7UolJWpUp0JT6p7jwp492orj1IwYlMIzHzBZNCsVc3lkhHPbWq/naNh/d2gu3CE
	PWVvAUgd1APj6lGUjX+ekqmpgEivXHdoGRbZ83IACSiuLg7xlk6bLyTwR34UdBUQijcM+0Muq9K
	33CWh9gR8ihrxr8Hat0WyWQfa5bsd6xXtEZMweDMmKGV0+PdsyctUPbEXWH82AKT9fBjA==
X-Received: by 2002:a05:690c:660b:b0:8a4:b228:26bb with SMTP id 00721157ae682-8a64860b2c2mr55294797b3.8.1790543039743;
        Sun, 27 Sep 2026 14:03:59 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:58 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 11/23] wifi: mt76: mt7925: do not disable RX NAPI twice on unload
Date: Sun, 27 Sep 2026 16:02:53 -0500
Message-ID: <20260927210306.737669-12-sean.wang@kernel.org>
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

mt7925e_unregister_device() disables every RX NAPI and then calls
mt792x_dma_cleanup(), whose mt76_dma_cleanup() disables them again.
The second napi_disable() spins waiting for NAPI_STATE_SCHED, which the
first one already set and nobody will clear, so module unload hangs in
D state and the module refcount underflows to -1; only a reboot recovers.

Drop the redundant loop and leave the RX NAPI teardown to
mt76_dma_cleanup(), making driver hot-reload work again.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 24585c992ff5..09153d624fd5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -40,7 +40,6 @@ static int mt7925e_init_reset(struct mt792x_dev *dev)
 
 static void mt7925e_unregister_device(struct mt792x_dev *dev)
 {
-	int i;
 	struct mt76_connac_pm *pm = &dev->pm;
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
@@ -50,8 +49,12 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
-	mt76_for_each_q_rx(&dev->mt76, i)
-		napi_disable(&dev->mt76.napi[i]);
+	/* Do not disable the RX NAPIs here: mt76_dma_cleanup(), reached below
+	 * via mt792x_dma_cleanup(), disables them as part of the generic
+	 * teardown. Disabling twice makes the second napi_disable() wait
+	 * forever for NAPI_STATE_SCHED to clear, hanging module unload in D
+	 * state with the module refcount left at -1.
+	 */
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
-- 
2.43.0

