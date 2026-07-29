Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A069451993
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785350240; cv=none; b=e3SGEJHXfSGl1BhtwPVAAdOC8Pjs/RtlEWSkvhixU75ku38msKv/F48FIRfNXHMU7pR+4gU6LgnYHwWrlqitCd+SsGVjg2Hug+CjGspwTLhdRKBdbkT/Cete15NNo4LqJPXb0ksC2EpwHM0f47tR2eCQH1ZEAPEF7b8aEGpA0Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785350240; c=relaxed/simple;
	bh=4P98aSbKBGaFkCj+9Z8F4SQSSnqALgFeDj729JAeHgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LMoWSfkjy1NFplCzDLW65il05KtmGExPxtQWoASSSGUZbWa9KC4sdBUw+ctvaL8gO06fwLGYaW+6tmNY8sTlNMlIQd6iCWOA83U09CbqQVm5v2rn6WtJ3Mh1+N5H8wrsHp44RauL3EWtv1GpyeBgDTykco43H8cVovGyUxLss78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwEZ0xkA; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwEZ0xkA"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbb85186d43so657331a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 11:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785350239; x=1785955039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TKiRLVwj3NSxN3gEZDV7xpth8PKqEmNyRu0ElNGl93A=;
        b=PwEZ0xkASSYe674ENRaXsVu9D5lUQjcKXrCTNqHJLiHWX4sqo9EZ2/VomqGePiODK6
         5fFnbHWBU92MpTOkHoWgikiS+PlNqygQC/yScvv1uYyiWDSMNe5rQbImbvCZvWELQarF
         ysEgXEwzSIWf3rOYnLphsGkBrRXrxI5nEZZMs3vxX/UnRoBjS+XmocsUF+YhzGxZRyUu
         unwdwCLKwu2cfqR1GiDMWFuc8g93uB/G8EmVCvJfmpCgFyiI/02h+qico23lixDuPiM3
         5zerkbmaXFvr+uzGbTZckwdkE4HJQ73WldgkojKc6gpcFpbu8dm6lOCj+r4ql1UcUpVs
         3vJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785350239; x=1785955039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TKiRLVwj3NSxN3gEZDV7xpth8PKqEmNyRu0ElNGl93A=;
        b=S/KdcKA+FHF7z7Sxa2DP0BokGUBJDL+tWF90IHIFtOhM1tx6Q/WqA23QY1LeGFVWrj
         qG7oZtErdykTwKsx1KJT+iZQpvgBTmNb0cKbYD3KoMOKyGfZzcNdQtl+StaCqqYv8VPz
         LyCHjqDPln0frJpyJSBjocueVyKVs+SfkHA9JYudvRByokeTdoNdiD/9HnS/xqVyizCC
         dgKjrcVHJ7VBwFrrcVZd3MwArjbrVOdioZQ503icr5Pz+9vske+lmT6O3I6bk0hW1Mgp
         rV0vsxP9+3aRsZtqSnRhdF59Z6Xz3ml1D/hETf44GJ61Tt5hFJyOwTCFXTTyShsjhnvv
         VhAQ==
X-Gm-Message-State: AOJu0YywVKh0xYXK7iXnio6xxUh/O8ZzGrigxIyveoDek+6Mf91lcfq2
	PZpriMtoV+zvXsswtAbop44iRwWS3p9coMRGsVR7uheMVWiSUzzmtKRLH06EFiqf
X-Gm-Gg: AR+sD11LlUHmjs7r0wztaESzlX6/00zwJsm0PR4koaJ8RPTxyJndvnBvsU62+jcqlKM
	Yldk95vp65fH5mTX/a2MFqp1lVCqazfF6xcqQf+VvepIDnJsNwnW76A0wJT4k5zhRvVbEF2zpoG
	+9nZaxiVsLM6oPF3Z9l58prNqUVxUQffwX7C0kP2tW2KpnrWWVyWWsrlhRCyjQXNR3qE5lOQ4E7
	cmW/j4sBCW/hfeeh/R4KguhgGr073tVDn2SVc5xiqYl0N7sjedGs4eABCPIHDVDxG0nHym2q9J1
	zJPnCERY9Xjdwe3wGTYTT/anmnGGveNWrNOMLZCV6OrjHM1EXLrJnEKZq2ZlcnirAlsiJsktNtE
	ml8zjZU5lgM81pZKh4xaVTRpa0oR+c5nRQtbbg/o1Hh0/bI+B3q4FcFw6gv/sfVZIMFpMz+xLq/
	6C4Wq77aD/QqlIX2K8xOqtfwdiqTADTdIuyBw8nelIjIzUtgRpc18ol+n91h1PsvxtbfJBzYl81
	JC5qTe+mf5cgAkS4atenMO7QW0H18hcsDaQ0U4HwEaPF9sjJYx+rd9wWdo5MLBeaWjVzjWikTXT
	kUV7NrJhK9PNYEoinrm4VBVCdly7TWW8CV1Sxg==
X-Received: by 2002:a05:6a21:7106:b0:3c3:7f8f:88c9 with SMTP id adf61e73a8af0-3c8ba616cf1mr8675488637.54.1785350238739;
        Wed, 29 Jul 2026 11:37:18 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba63d2fesm1312154a12.27.2026.07.29.11.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 11:37:17 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be|_ptr)?\b)
Subject: [PATCHv2 wireless-next] wifi: nxpwifi: embed rx_reorder_ptr
Date: Wed, 29 Jul 2026 11:37:15 -0700
Message-ID: <20260729183715.691287-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rx_reorder_ptr is a dynamically allocated array which is done near the
main struct allocation. Combine the two to avoid freeing separately.

Also fix the type to what it actually is. void is normally used to avoid
casting but there's no need here.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: fix unused variable error
 .../net/wireless/nxp/nxpwifi/11n_rxreorder.c  | 23 +++++--------------
 drivers/net/wireless/nxp/nxpwifi/main.h       |  2 +-
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
index c5819f89b08c..65b628411543 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
@@ -171,7 +171,6 @@ nxpwifi_del_rx_reorder_entry(struct nxpwifi_private *priv,
 	list_del_rcu(&tbl->list);
 	spin_unlock_bh(&priv->rx_reorder_tbl_lock[tid]);
 
-	kfree(tbl->rx_reorder_ptr);
 	kfree_rcu(tbl, rcu);
 
 	atomic_set(&priv->adapter->rx_ba_teardown_pending, 0);
@@ -262,7 +261,6 @@ static void
 nxpwifi_11n_create_rx_reorder_tbl(struct nxpwifi_private *priv, u8 *ta,
 				  int tid, int win_size, int seq_num)
 {
-	int i;
 	struct nxpwifi_rx_reorder_tbl *tbl, *new_node;
 	u16 last_seq = 0;
 	struct nxpwifi_sta_node *node;
@@ -273,11 +271,16 @@ nxpwifi_11n_create_rx_reorder_tbl(struct nxpwifi_private *priv, u8 *ta,
 		nxpwifi_11n_dispatch_pkt_until_start_win(priv, tbl, seq_num);
 		return;
 	}
+
+	if (win_size <= 0)
+		return;
+
 	/* if !tbl then create one */
-	new_node = kzalloc_obj(*new_node, GFP_KERNEL);
+	new_node = kzalloc_flex(*new_node, rx_reorder_ptr, win_size);
 	if (!new_node)
 		return;
 
+	new_node->win_size = win_size;
 	INIT_LIST_HEAD(&new_node->list);
 	new_node->tid = tid;
 	memcpy(new_node->ta, ta, ETH_ALEN);
@@ -311,26 +314,12 @@ nxpwifi_11n_create_rx_reorder_tbl(struct nxpwifi_private *priv, u8 *ta,
 		new_node->flags |= RXREOR_INIT_WINDOW_SHIFT;
 	}
 
-	new_node->win_size = win_size;
-
-	new_node->rx_reorder_ptr = kcalloc(win_size, sizeof(void *),
-					   GFP_KERNEL);
-	if (!new_node->rx_reorder_ptr) {
-		kfree(new_node);
-		nxpwifi_dbg(priv->adapter, ERROR,
-			    "%s: failed to alloc reorder_ptr\n", __func__);
-		return;
-	}
-
 	new_node->timer_context.ptr = new_node;
 	new_node->timer_context.priv = priv;
 	new_node->timer_context.timer_is_set = false;
 
 	timer_setup(&new_node->timer_context.timer, nxpwifi_flush_data, 0);
 
-	for (i = 0; i < win_size; ++i)
-		new_node->rx_reorder_ptr[i] = NULL;
-
 	spin_lock_bh(&priv->rx_reorder_tbl_lock[tid]);
 	list_add_tail_rcu(&new_node->list, &priv->rx_reorder_tbl_ptr[tid]);
 	spin_unlock_bh(&priv->rx_reorder_tbl_lock[tid]);
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index 4abf80771be2..349dfa4d3f85 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -656,10 +656,10 @@ struct nxpwifi_rx_reorder_tbl {
 	int init_win;
 	int start_win;
 	int win_size;
-	void **rx_reorder_ptr;
 	struct reorder_tmr_cnxt timer_context;
 	u8 amsdu;
 	u8 flags;
+	struct sk_buff *rx_reorder_ptr[] __counted_by(win_size);
 };
 
 struct nxpwifi_bss_prio_node {
-- 
2.55.0

