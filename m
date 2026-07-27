Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0630017DFE7
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 00:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112239; cv=none; b=FfoX6V6C1KKBgcpWZ/powrhaBkC7N1bC8eVJv437uzL90EepmolFwgIUQ78NL3lRLg+gx1wlI3mBlmS1TpDUqWxscPpkEfp7/2vZNiFoyDOd/Z0aexM0hMdrgqxi02KaFdQNQiuDRxh2cUVaV8OgJIcWO1IvOLx58stNOv7nMsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112239; c=relaxed/simple;
	bh=zGpoeMUqWCnLlgmvPinB+FYL3e9l85Y04G+0Nvs+GEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AI1+AQdjF1v1PFUIqJ1MoyqBy0ZWEaw0CYZm7o3D4TU9+8R/Po1XPnRGmOcwzlKHD+imUVTQGIHlmQtAFtu1J4JhfmOFs/dQ0aiiQOIIxi2j40mNgjj4b90iuBQntI83kabTazXAVCnWTmTghYFOxYD51rEyBa/R90zQxfl4nMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WjE7NrS8; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WjE7NrS8"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84864086bfeso2008387b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 17:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785112237; x=1785717037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c+zwgRiRyLzUY+zGpFZNenRIdI2xKiE4RqGqKlfD/Kc=;
        b=WjE7NrS8A3zmPU7He2Lx/RJBH2y9j4+nLIJmx0N/G8dqOR7BG+jKqCTe/GXDjx6gOd
         RiunRdIRtLVSi1/jM4sDjG0iwj/+mYK5na8MPrK1A0LQFUYw1y3e4bb8ds7tHbClqBOD
         1DK0+C8875ZZ/xqbhhkiH0N7HDhV5QsiBKMCcQka8WQBwM1JnWc+DnNqEEK8WX/vnJWL
         Dim2lybQ6ICBiBsivZgXmrIjl95wgriSHMiKkXkkqAYCZrU+yIDNeqv6Z66auDliYIhV
         CEfF1mKga39MS1JyvTiWnpUiZSUoDHNIISn/D5+0Up2biR6cZMLAB72Kp6n9paLHydH3
         a7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785112237; x=1785717037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c+zwgRiRyLzUY+zGpFZNenRIdI2xKiE4RqGqKlfD/Kc=;
        b=i6QrbBUbDFUJED5S3ZF+7gt+d9sDO9ckhRbVwOCa+6dEYWvlk6pmKs2DHUDlNNqnKr
         /6Eq3adqUal7jjwkoOUpiFFu7UYzrrjIAbglf4YP3cptu4oXPV7dIrUUJu3Rws9KHdXm
         aFLx7y4HCeHiySEas9fqESbKoLI9dL4iJWWRi65CBdcOMANYRrdt+64wfbooldpXHAnE
         4zWGjPu5zezhxTFBh7mqoWQzHAw6Ok8wRnvVvguvUga9JP4gD2wcazJVv9vddM6fT72f
         wD+k7Mt9A+o3PrhlvSIXaeflUawZ6HZPW/z8ktcFcCYgq14lM9QyTNkV0dtFlvdXh05X
         LD5Q==
X-Gm-Message-State: AOJu0Yxni4xIQVaC9ANN556defOGl1QSnP/zkXD730buxPyOaZFYkx26
	tuKzGFHY8DVWneoEtCst22cZmqxExxqGVCljOZ9srgr2seoY2F1yBuCjCbpjGg==
X-Gm-Gg: AR+sD13o5crkVUpZ3PC21k3eIliF5BgASRvwA/uw7J8W6MlM2Rr82tkuFA93oW3C2gg
	GEDhlAfr8GKAEjdSV1+7cT5zcAWYkf5P0ISxPibXenp9QYYCVrDVxiKvhw+tRvXCEWRvdqyB1rH
	mo4VSoXq9KMj4rSJeYS8LVSL5BDi7uC8WBhtkjyd2SIYXMjGoV+4ffvpj0uJZm/O7c+pwgEgWjR
	LOQtHQqNlk65ihMRG29oOhLI0F0sjoD8qrIYnXDrSEvXF10pAmjYpJTEbPamN4Ee2N9t8QhTjnv
	A35TuBHm8bcszVaeVPYV5LaUgTsv6ZfkGHvFQNAVHqg2zrH3yG1MBgqb/WIWzKlo7YUDMzmrapL
	en0czel8FrCzmHIXCurawUYMWpsamOAtTqCFuoBrPnpoh0AU2EYGlYAZRbQtWOIW3Oa3W91E4Eq
	xX8cjfeA/Nb7ckXFc8qX/Z5X0gUwl+PUSUaqz7fci3hWMRtLXec+MwZhq6t1o6KFXq9tEAXkOgv
	M0UECC3BeZZLVLqLhqvnzFF1X02bCBcvASiyQuT5qaU4r0EGK1VFN9rl7zJMRauxQ==
X-Received: by 2002:aa7:888a:0:b0:84a:2ec8:fca4 with SMTP id d2e1a72fcca58-84e5956e79emr5113735b3a.51.1785112237210;
        Sun, 26 Jul 2026 17:30:37 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5344e583sm2205464b3a.57.2026.07.26.17.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 17:30:36 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be|_ptr)?\b)
Subject: [PATCHv2 wireless-next] wifi: mwifiex: Use flexible array for RX reorder table
Date: Sun, 26 Jul 2026 17:30:35 -0700
Message-ID: <20260727003035.118047-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Embed the RX reorder pointer array in struct mwifiex_rx_reorder_tbl
instead of allocating it separately.

This ties the array to the reorder table lifetime and removes a
separate allocation and cleanup path.

Change the void pointer type to the proper one for clarity.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: void pointer to proper type
 .../wireless/marvell/mwifiex/11n_rxreorder.c  | 20 +++----------------
 drivers/net/wireless/marvell/mwifiex/main.h   |  2 +-
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 610ec8302adf..a266f09cb763 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -213,7 +213,6 @@ mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
 	list_del(&tbl->list);
 	spin_unlock_bh(&priv->rx_reorder_tbl_lock);
 
-	kfree(tbl->rx_reorder_ptr);
 	kfree(tbl);
 
 	spin_lock_bh(&priv->adapter->rx_proc_lock);
@@ -329,7 +328,6 @@ static void
 mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 				  int tid, int win_size, int seq_num)
 {
-	int i;
 	struct mwifiex_rx_reorder_tbl *tbl, *new_node;
 	u16 last_seq = 0;
 	struct mwifiex_sta_node *node;
@@ -344,10 +342,12 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		return;
 	}
 	/* if !tbl then create one */
-	new_node = kzalloc_obj(struct mwifiex_rx_reorder_tbl);
+	new_node = kzalloc_flex(*new_node, rx_reorder_ptr, win_size);
 	if (!new_node)
 		return;
 
+	new_node->win_size = win_size;
+
 	INIT_LIST_HEAD(&new_node->list);
 	new_node->tid = tid;
 	memcpy(new_node->ta, ta, ETH_ALEN);
@@ -381,26 +381,12 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->flags |= RXREOR_INIT_WINDOW_SHIFT;
 	}
 
-	new_node->win_size = win_size;
-
-	new_node->rx_reorder_ptr = kcalloc(win_size, sizeof(void *),
-					   GFP_KERNEL);
-	if (!new_node->rx_reorder_ptr) {
-		kfree(new_node);
-		mwifiex_dbg(priv->adapter, ERROR,
-			    "%s: failed to alloc reorder_ptr\n", __func__);
-		return;
-	}
-
 	new_node->timer_context.ptr = new_node;
 	new_node->timer_context.priv = priv;
 	new_node->timer_context.timer_is_set = false;
 
 	timer_setup(&new_node->timer_context.timer, mwifiex_flush_data, 0);
 
-	for (i = 0; i < win_size; ++i)
-		new_node->rx_reorder_ptr[i] = NULL;
-
 	spin_lock_bh(&priv->rx_reorder_tbl_lock);
 	list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
 	spin_unlock_bh(&priv->rx_reorder_tbl_lock);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 27559e2ddc31..8e6238c01aa6 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -708,10 +708,10 @@ struct mwifiex_rx_reorder_tbl {
 	int init_win;
 	int start_win;
 	int win_size;
-	void **rx_reorder_ptr;
 	struct reorder_tmr_cnxt timer_context;
 	u8 amsdu;
 	u8 flags;
+	struct sk_buff *rx_reorder_ptr[] __counted_by(win_size);
 };
 
 struct mwifiex_bss_prio_node {
-- 
2.55.0

