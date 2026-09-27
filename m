Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7483C414F
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543077; cv=none; b=JpkFQIROdapkh3r3BoaUi/bUd+cRSGPPAOOKYrKJ49gyV9GHepiX7V5fHERJckDTVa2IKjlZwC295zoHmQUc6ybHx+gBsZ62IGwoUqVWheqyE7RCru/Sqpd08amEX6oztT+VuhnzKwjiDJgMrpmkoRsYTu3NxknH8TbPyEUM5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543077; c=relaxed/simple;
	bh=n86N9fYMshG+n5J7EPJLFt88T3nf9owei3ykZrRLPSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sptVXXWuX13UL9wTkSw5yZxNrhdDIpLgaZxtQ3vyHYccVW7HHDs/ShIkBpS0CWvWg7IKMlVqeLFAclm9F9ZyDGlWzoRXF7eovsj9vmy2fqcVppsBIKR91mau+wIYG4uS7cXf/62SXnP5vuv1Ufr+AEhCB2i5wXpHAs1A+XnUJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8aa1a918093so4279467b3.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543075; x=1791147875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rGJ5BIfE5g0JsujlWA3TifXgWDdlNNIsWYHnjmSe2xU=;
        b=jGPvdFdXbdVraLVvaXYFUuRifdzHA8PRe7ujNemZEL9xOTCTUS/ai+NJINu0PwN2Al
         6pBxiLw8fvLoiINzlVyKAZbbU4AfUYheZ4R4VQpC7xMzPrTZ4w26zYn2YRz6zDivzUOz
         pJUR8sHAwwm6DQR1pJQLCTcf1mmlV7fpUp9asoVMFr149MK4+Jw26ixB/gqiHnc69sG1
         5kXzPw5S0jnXNAMt/vrehrgLjWt3407YrUR2Y2W92+omBlwHyjK6RvXELctataaGawoa
         IgSrVwCWgzfAJUAFevP9KRNjhcxviPLn28NFs8ZSzZKjK28/xtqz6kp7fMATruLVFp/8
         JR7A==
X-Gm-Message-State: AFq9FYLNFSJAY1JTCIULRzrEDZBYJDiYsoWC9FPaZQDiUXhrsL2r3zKQ
	SrBTimuSCMWDSsCTVlIZAtrl57sQTEV7LA9xiniQkBC9ao1vaE6UNEec
X-Gm-Gg: AYBFou0Mt263czPk3qs76rGwmX3d7gkHrZjFQiGlDOCry5wuIHBiq8wKj2NdxxaMdzo
	/NLiWWJLJ7InbFisrMou4OeN8zvfwKA6nzOi4bavKUHUwBhz2INdXvPJMVUSRbNHvuLJd5h02n5
	IC22i41iGJeJveBreALDvkTBx6Wq5bXzaV5E6NCWrBF7dcFvqNC8M3BKRJNzNkKrWDpyIoQaQNh
	dqqg2ua+Q5lvJw7betoOvLBPvW9/4bupB6yXMEMo8ldO8Ncnmn1aUZf7ycx6KwtZ27H1qjaA2ri
	HqgVKtfAhM0/Z54FoMbjBt3V4YsR+yrrVOBVLzByBQPn0+x0gHidoq+/ikEeNcJvAgXIEwY/r3n
	3+SsZyrUFTZSxUXgafDya7DkEn4j16u5gwg1dU1qa2oVkJLMV7shOq2hngvtX3VmOMhZ/GJQpTB
	mwze+DaeKup5r9dK/rapVNvt7decvgL0UmS47k9fWq7xNYPZzE02spe55FvzqCmCWMI74dB41QV
	8P/0j6Tr7SoU54L7ECNlgtjJYzH2MmnKXRKic5aHxU+1zA6D0/QkITYFrXXjdiqfs5itQ==
X-Received: by 2002:a05:690c:c4fa:b0:8a9:c6bc:fa55 with SMTP id 00721157ae682-8a9c6bcfccemr11756137b3.92.1790543074872;
        Sun, 27 Sep 2026 14:04:34 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:33 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 23/23] wifi: mt76: mt7925: always deliver the joined-cluster event through the deferred work
Date: Sun, 27 Sep 2026 16:03:05 -0500
Message-ID: <20260927210306.737669-24-sean.wang@kernel.org>
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

A JOINED_CLUSTER arriving while nan.started is already set is sent to
mac80211 directly, but a deferred STARTED_CLUSTER may still be in flight:
NAN_START holds the wiphy lock, so the deferred work has often already
snapshotted and cleared its pending bits and now sleeps on that lock
before it can deliver STARTED. The directly sent JOINED then reaches
userspace first and the late STARTED overwrites it, so the supplicant
keeps the stale self cluster for the whole session and its RX filters
reject the real cluster's SDFs (10 forced-split bring-ups out of ~600
showed this inversion on the bench).

Route JOINED through the deferred work unconditionally. The work always
delivers STARTED before JOINED, so firmware event order is preserved no
matter when the events land, and the extra scheduling hop on an idle
work is negligible for this once-per-session event.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 36 +++++++++----------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 77a91a9ee4d4..4e3c531a8d4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -709,31 +709,29 @@ mt7925_nan_mcu_handle_de_event(struct mt792x_dev *dev, struct tlv *tlv)
 		return;
 	}
 
-	/* JOINED_CLUSTER has the same race as STARTED_CLUSTER above: the
-	 * firmware joins an existing cluster from inside its start-up passive
-	 * scan, so the event can land while NAN_START is still running and
-	 * nan.started is not set yet. Defer it the same way instead of
-	 * dropping it - a lost join leaves userspace unaware of the cluster it
-	 * is in and service discovery never completes.
-	 */
-	if (!dev->nan_vif || !ieee80211_vif_nan_started(dev->nan_vif)) {
-		spin_lock_bh(&dev->nan_deferred_lock);
-		memcpy(dev->nan_joined_cluster_id, cluster_id, ETH_ALEN);
-		set_bit(MT7925_NAN_DEFERRED_JOINED_CLUSTER,
-			&dev->nan_deferred_pending);
-		spin_unlock_bh(&dev->nan_deferred_lock);
-		ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
-		return;
-	}
-
 	dev_dbg(dev->mt76.dev, "nan: anchor_master_rank=%*phN\n",
 		NAN_ANCHOR_MASTER_RANK_NUM, de_evt->anchor_master_rank);
 
 	dev_dbg(dev->mt76.dev, "nan: own_nmi=%pM master_nmi=%pM\n",
 		de_evt->own_nmi, de_evt->master_nmi);
 
-	/* joined an existing cluster, not a self-anchored new one */
-	ieee80211_nan_cluster_joined(dev->nan_vif, cluster_id, false, GFP_KERNEL);
+	/* JOINED_CLUSTER has the same race as STARTED_CLUSTER above (the
+	 * firmware joins from inside its start-up passive scan, so the event
+	 * can land while NAN_START is still running), and it can also race
+	 * the work that is about to deliver a deferred STARTED_CLUSTER -
+	 * userspace keeps the last event it sees, so a directly sent JOINED
+	 * would be overwritten by the stale self cluster for the whole
+	 * session. Always deliver JOINED through the work, which sends
+	 * STARTED before JOINED.
+	 */
+	dev_dbg(dev->mt76.dev, "nan: deferring JOINED_CLUSTER cluster=%pM\n",
+		cluster_id);
+	spin_lock_bh(&dev->nan_deferred_lock);
+	memcpy(dev->nan_joined_cluster_id, cluster_id, ETH_ALEN);
+	set_bit(MT7925_NAN_DEFERRED_JOINED_CLUSTER,
+		&dev->nan_deferred_pending);
+	spin_unlock_bh(&dev->nan_deferred_lock);
+	ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
 }
 
 /* Runs the deferred NAN MCU events in process context; takes wiphy_lock
-- 
2.43.0

