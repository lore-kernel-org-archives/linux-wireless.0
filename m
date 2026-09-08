Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E458F083
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788887138; cv=none; b=AYw0J4uxpVjclJYIHNgsD7e05HYhAS76y/NSq5MI6nwqZVzY9lWrvUPQSgD7G8BEsFlWdIBe8a8vpANUaNYeCq6QiyZXv8kIhZRzVIhr70819o9sWvh5adq03bX8RpYSwqFrl03scFI4FjY7MFbJtKSrbOP8Tcv85BAR1wjisBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788887138; c=relaxed/simple;
	bh=XgSPVedMOyKZx0hD9D5eSQiDvn54bm23acHsJcZwnPs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S6KWBPNU+w4B7QiWZZKajnirM9SV09xY9JKGvTqCZWMtRIhifUm0Gry0InxFKVSkkKS2URJ3udwjMCSkphN8e3YaTjDN3zkVPyrlqrYi8wQ+hdXQsH3L2l4gH3CUv+o665WVChxM0/39fTDo1PAaXJ2y3eYsAP6cYy5zoSTjmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PK7he5rd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TLMXrSTm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PK7he5rd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TLMXrSTm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788887135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uIROfkEXMmiaOqUCdHyBQ6VVSwBDCHIdpWTf5XleH3U=;
	b=PK7he5rdi2aUMfwEtwhfswSsy7rHniBgpPiluusGQS1082C+XDRIIpM9zRVD8jhtRgpD/l
	0dfDQdnGZlWE7gDHD6xC7/WWNzae1za6AsWCpHk8CrMnvTEjNbXwBP+12lylxH77k2PbzA
	BIuUZ+YXKCTlAaR8Ud6an3b4SG58qlM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-lzKHG3XAOTKA_EJSrhKDEw-1; Tue, 08 Sep 2026 13:05:34 -0400
X-MC-Unique: lzKHG3XAOTKA_EJSrhKDEw-1
X-Mimecast-MFC-AGG-ID: lzKHG3XAOTKA_EJSrhKDEw_1788887133
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-499b99a8a10so41790225e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 10:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788887133; x=1789491933; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uIROfkEXMmiaOqUCdHyBQ6VVSwBDCHIdpWTf5XleH3U=;
        b=TLMXrSTmtG50UQntXPNwO8ILcUgtrKkCVDUP7PJhFEkaUhlxGW/16/QL3VTSJwCXPc
         E9yaq/QD4AvCnTEoRE56gbtwT/pwURMtQhdHPh3Iv0Nn4RpkuPEs/o1wDgeD4mwv1Rus
         Hm6i2syw6a4YNNUNwp1dYwWAjoA6OlduX0lfB3ATAqELvBpvMghtVQgmUZ1TV9v1jrYR
         w1H6p/VgZF0pvPlwaipjcNDxJqts8RSjj/HPB/+Nm7BCGyWY1yJT3uO0QsB47Q3LNWus
         ZITy4Gv4UiSq4qoYSKfhYaXWNPknQLFz/6VwhE9DOFsNNPUppqoYa/Zc/pWxdyYOQnIa
         P+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887133; x=1789491933;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uIROfkEXMmiaOqUCdHyBQ6VVSwBDCHIdpWTf5XleH3U=;
        b=tU6PeJtytsdKdv+G6Em9dwIYsc6p3G970Z85hOEITBf7SCd2xVq15gibgYO+MQSlks
         LaMtQOFsZSYGAAbsBot7gB9hIDPd2mBWteoFxctVgAqyFcBVwarf3Njb8vPoBHwQgj77
         Ov2/fLnIoz9c/Pj4WXN4rO8aZot33agidpbCYqzHbOrfIroMKTgPratJV+mq3T4nnzAH
         T98XrRLN0Vs41+LdRYjqcsZ9iqnIMZgbllzZGWQzUG1hj3PxgDaptsu1Jv87frPHHhGH
         BxBBCjBK2sTilDsrQ+3MvppG6T0bD1ecmQy+QDw75f3ABJBrR7AejTd2uF33+/QeEMXu
         ZQPA==
X-Forwarded-Encrypted: i=1; AKwUvByfWxFDR9gfzjcBDwD+fvsGfUCmGFmdb+Y1eoTtaMM+TfItBA2rgn0Y894hxLHTkvBu/OuarEDltY76m1hilQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mfZQAZbdHTE4yYsmLHehowziTChXl23Jfz6mr2aBS800vDLiWG
	vVpHO1D1MYY5lnPwtsQ59TIN5rOEZTDMxmkpLxH2bit/7hwCU1R1SW0Bc3IfNQodMfEAlTa6WiF
	e5tZe0EFTNojUyYwbG4XlUZW9yYz2O+ivBIc+VCgHyl9Q0RXmWu/U9vkDkWG2d8ME69pZ
X-Gm-Gg: AYBFou2j8uNWXoCLpvKstvL623gaTocmV8TwM4YVuyKmaDRsDC0DwFW2ZL++d2wT0Gr
	u92IPjdEW7fFsGePO6pIdP9DEWNh/o67o9NxpIzLJdgoSFHh+AePrrkqTXlRFy/aggKfRjOG2hV
	g1SGN/i4wSEmoiR3snWr4hs2458afWxNZHIJyaj2d3CEiFAka1Z+KMA3bVSWJwmS0ZaBe2/s5TL
	fARsIlnL0NcfUGMHhWz/4zk9VC0fKxrRWNDib1x9JQ/gJK1jKtW0oIp//67KJRjgakhTR1pz0WA
	1lsKmczuzVS7fczrcqEVKcFLHhPZm4/2Rfa9uKitqMlg0o04AwKGEzEgAw2/mKoxYcZoMkrBw00
	Vrhtt/4/qSAmKRWaABGuMFJET
X-Received: by 2002:a05:600c:b8d:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-49d1754e950mr91094875e9.4.1788887132786;
        Tue, 08 Sep 2026 10:05:32 -0700 (PDT)
X-Received: by 2002:a05:600c:b8d:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-49d1754e950mr91094415e9.4.1788887132337;
        Tue, 08 Sep 2026 10:05:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf75cd8d0sm381078745e9.2.2026.09.08.10.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:05:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id A91959B9279; Tue, 08 Sep 2026 19:05:30 +0200 (CEST)
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <kvalo@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: ath9k: Clean up device initialisation guards
Date: Tue,  8 Sep 2026 19:05:18 +0200
Message-ID: <20260908170520.112946-1-toke@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The ath9k driver has a couple of guards against the RX path running
until device initialisation has completed. However, they are problematic
for several reasons:

- They use smp_wmb() paired with a data_race() annotation, instead of
  the idiomatic smb_store_release()/smb_load_acquire() pair.

- The guard in ath9k_wmi_event_tasklet() is weirdly late in the
  function.

- There are two of them when there's really no reason the rx init gets
  to run before the whole initialisation is complete.

Consolidate the guards on the single ath9k_htc_priv->initialized
variable and use smb_store_release()/smb_load_acquire() to access it.
Move the store into ath9k_init_device() to make sure it's set in all
paths in the driver.

Fixes: 24355fcb0d4c ("wifi: ath9k: delay all of ath9k_wmi_event_tasklet() until init is complete")
Fixes: b0ec7e55fce6 ("ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  7 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  8 ++------
 drivers/net/wireless/ath/ath9k/wmi.c          | 12 ++++++------
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6c33e898b300..4d2b75d0212e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -281,7 +281,6 @@ struct ath9k_htc_rxbuf {
 struct ath9k_htc_rx {
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
-	bool initialized;
 };
 
 #define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..911eaa4f776a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -910,6 +910,9 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	ath9k_init_leds(priv);
 	ath9k_start_rfkill_poll(priv);
 
+	/* signal completion to ath9k_htc_rxep() and ath9k_wmi_event_tasklet() */
+	smp_store_release(&priv->initialized, true);
+
 	return 0;
 
 err_world:
@@ -966,10 +969,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 
 	htc_handle->drv_priv = priv;
 
-	/* Allow ath9k_wmi_event_tasklet() to operate. */
-	smp_wmb();
-	priv->initialized = true;
-
 	return 0;
 
 err_init:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bed7ea2425a0..95f48c7dca15 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1141,8 +1141,8 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
 	unsigned long flags;
 
-	/* Check if ath9k_rx_init() completed. */
-	if (!data_race(priv->rx.initialized))
+	/* Check if ath9k_init_device() completed. */
+	if (!smp_load_acquire(&priv->initialized))
 		goto err;
 
 	spin_lock_irqsave(&priv->rx.rxbuflock, flags);
@@ -1200,10 +1200,6 @@ int ath9k_rx_init(struct ath9k_htc_priv *priv)
 		list_add_tail(&rxbuf->list, &priv->rx.rxbuf);
 	}
 
-	/* Allow ath9k_htc_rxep() to operate. */
-	smp_wmb();
-	priv->rx.initialized = true;
-
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b043..44e91815a159 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -146,6 +146,12 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	u16 cmd_id;
 
+	/* Check if ath9k_init_device() completed. */
+	if (!smp_load_acquire(&priv->initialized)) {
+		tasklet_schedule(t);
+		return;
+	}
+
 	do {
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		skb = __skb_dequeue(&wmi->wmi_event_queue);
@@ -155,12 +161,6 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 		}
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
-		/* Check if ath9k_htc_probe_device() completed. */
-		if (!data_race(priv->initialized)) {
-			kfree_skb(skb);
-			continue;
-		}
-
 		hdr = (struct wmi_cmd_hdr *) skb->data;
 		cmd_id = be16_to_cpu(hdr->command_id);
 		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-- 
2.55.0

