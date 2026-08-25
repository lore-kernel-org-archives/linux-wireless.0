Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CA2490C02
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 23:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699926; cv=none; b=s/E9yZ8+rmK0/q1DfKI01mqncaL0Gwg/BwA91hOCYogeHx7Hv4IZQCtI0j+GszAP897UsAO3me62GUKLE0unS2h3HwUrKe0QJlQN3xO8FKcDxeEwYaRDgrWjkHNEjbPrcYCK1EGesd1EJ1Qagn8tGNIan7ajyULRwwKjUuxNPrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699926; c=relaxed/simple;
	bh=HXB4bVWiYtHeNKcVwR0OXbtBoIIb+b9e4Qe725FgQXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3/Z1txlYBgUm8EXYceYuspuJU61rJ/QH6D8QEuWGNeMaIe4J/NOc8RmfiB+MAAtv4EjmZNUOo4duWyubsCZL4ygfUMl1ZXZraeWjQqn79DuMM5zuLjz0rePHrSaYFbbYiJOaRaHamZugoczIOdFfACQew3cav8gUGYC2xHcdW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bnhn/Hze; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bnhn/Hze"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso2667635e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787699922; x=1788304722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YHt6N3XaltucIJM+1NviMsc1T4gCEHtkC9VE85Ji+gA=;
        b=bnhn/Hze4weblyA0PwecxTBSLRrV1pLD/hGGbEFfOZ8lE8gu+f2nbGKiuTQRBfiyj0
         Q8rwogik3TknvMuGrmc4sYsKVsnNNth84HaViYXqAMryaTcK2W0T87qpU1JYIbi0T+Ly
         Vvtid3LwzOOU4bEnUJxGInmqsI6fEjkuUCYiS07SzvpE8NUDjfHwIakKZ0aHjWQI3rLJ
         Uk1G/b6IDg2rYztArjD6h9qLzuC82SBJpjWorQbQS7hG2XYN13a9evXEB4KVplkXYIWV
         M7VHM8nuOqQpc/q7+p1AoNcz8cvZRyPVo1k/LXtqezaXE02sShX6Axcj9V2Hq5AmLfLe
         4a8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787699922; x=1788304722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YHt6N3XaltucIJM+1NviMsc1T4gCEHtkC9VE85Ji+gA=;
        b=tZ31orIQW276+8vq2FbjP4MsD+vTU+bwakC3jWDfyJ+ndKho/7i7s1yq4+ywE8QEnA
         ajcotHVfaJTeiOLMtCPovy9OijvhhLjY+Er/BZ2nmP2ceqKuZLQb+c7WKybQ4gEG9uIv
         JXmsHajf0t8p2maRt5UN3l0s87M+BL1JKqvdXIesIhQymjhjbYq5Z4xxxbAFw5yRhCry
         IXRVIEpWCH6iOnOkEoDjESQtkXq+QcEO88bOK7+Ot1PdPPJMU/frU45jHhuhSxvDDjgi
         zpvJjE6LMMzh+izY1pS9bu+kfdOMsgKA8NESjF3cA77MWaw6lopxUJ3Qg/3RvseBuZTP
         m+mw==
X-Forwarded-Encrypted: i=1; AHgh+Rpjnq4iD5UN/CZb+h+I9qUUqpbRSuy0RbFa4Gptst24HiOT9hztGBSyoIdXnhnweJzvqGoCx33I+6I1J/Hnag==@vger.kernel.org
X-Gm-Message-State: AFuF++mPe6KUQ1mixnbf1IKJ1ulOnSzhQkAqQ6zMwNc/WyCuhekpcpZh
	fNBTXAIR6Piqi84iL4cITuATrPONTPdOo0o9qViR6ZXU9pACr319wZj0/zESqg==
X-Gm-Gg: AR+sD117M2QyDm3/TAZi4wed5eERusfxLzCfKZjPGgZgGatSLkynJH9hU2uz0OhUosW
	hQJzMO/QNIDDoP4C4fHMB+fn9/Y/c2ja+rB7HGVe+DmhMDumDbKhp7rGlbKTOWp1ks4FxcmsYl4
	/ICeLV2VjZsTgSY2G05Koc/O0PMecOaNoVKqR56I3koOjMUPI1kL7IOtdry4wCIvVNCvLiO8mR2
	3RJfqmlmRMAKzFuGfYiby/qUHR+LabwRsIkEhl91VdjSQ9XwzEznHMSoiy2ihIqyx1VK1yKjEGa
	yvvfnEi3PSf31/RRQP7h2aD+PS3Wme15JL6ZPElvGvO/SJdjeCrJFTE0d2yjA9ePos9QqWVWaBn
	f+kPPDdpCcFHF482y5OYOYIHYSH2WnlZCNU3QcpvCWp7lUDCCfdfOgvuIaoHqjZrrZoNfL4TXZ7
	eCsuJPJVtUwt9WvKRJeRBkUNOsHe0PcxrZ0Kcbrn0KKduBhlVqsuvkIuSSDJ4xQegyIV+nTi+iD
	EU4N+AxN4etLuFYLfPSp5lQV0I7/Q3Yx4LXxE4vMj9IRWGzLOt7MUK21AU=
X-Received: by 2002:a05:600c:3acf:b0:499:db5a:1049 with SMTP id 5b1f17b1804b1-499dc70246bmr21444865e9.8.1787699922559;
        Tue, 25 Aug 2026 16:18:42 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e279e8b7sm864017f8f.7.2026.08.25.16.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 16:18:41 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH wireless-next 2/2] wifi: nxpwifi: do not delete Rx reorder entries under RCU
Date: Wed, 26 Aug 2026 00:17:10 +0100
Message-ID: <20260825231834.244783-3-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825231834.244783-1-devnexen@gmail.com>
References: <20260825231834.244783-1-devnexen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RCU guard is declared in the body of the per-TID loop, so it is still
held across the teardown pass. nxpwifi_del_rx_reorder_entry() flushes the
Rx workqueue and deletes the reorder timer synchronously, both of which
sleep, so a station deauthenticating from the AP splats under
CONFIG_DEBUG_ATOMIC_SLEEP.

Scope the guard to the collection walk. The teardown does not need RCU: it
serialises on priv->rx_reorder_tbl_lock[] and frees with kfree_rcu().

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Assisted-by: Claude:claude-opus-5
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
index 65b628411543..87cf2ec85991 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
@@ -205,11 +205,12 @@ void nxpwifi_11n_del_rx_reorder_tbl_by_ta(struct nxpwifi_private *priv, u8 *ta)
 		return;
 
 	for (i = 0; i < MAX_NUM_TID; i++) {
-		guard(rcu)();
-		list_for_each_entry_rcu(tbl, &priv->rx_reorder_tbl_ptr[i], list) {
-			if (!memcmp(tbl->ta, ta, ETH_ALEN)) {
-				INIT_LIST_HEAD(&tbl->tmp_list);
-				list_add_tail(&tbl->tmp_list, &to_delete);
+		scoped_guard(rcu) {
+			list_for_each_entry_rcu(tbl, &priv->rx_reorder_tbl_ptr[i], list) {
+				if (!memcmp(tbl->ta, ta, ETH_ALEN)) {
+					INIT_LIST_HEAD(&tbl->tmp_list);
+					list_add_tail(&tbl->tmp_list, &to_delete);
+				}
 			}
 		}
 
-- 
2.55.0

