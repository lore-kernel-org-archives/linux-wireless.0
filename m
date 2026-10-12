Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BDE1BD00C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 01:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767850; cv=none; b=Mv3Fh3Ign5K9B4dvWUGfbOAEzgRhgjg2xq/4N5rnwF3cpmqNVwFxl3yO7WukGYGzno7fNkNHWX2eB/+8EIJyfaWYR2bptkdRxkD3GSEwVBV5VZ3AvugT42EvWZpNGL5v1jtOsgceUtm37bNr9sKCOiUz4zcP2WopXwRfULiblS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767850; c=relaxed/simple;
	bh=7kws1t0+OCMulxLDUmtqw4aouqi4XUPlxhuO/6QqJ9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuhSbJoswyZKJhyxx7vn2o9vxd8gKQhjpaL2sbj3mh0EjPkbMIeqgYwJCl8tne2ZMSwmJyk3g/52K6zpri2h7aP2UA8OT616x4nP8CNJgqvObmBnQft5o3xE3da4dX24x4v6yVghyOjQEDZEesnIPuZ6U6NNIv3zurR+wFv6Izs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcepv8Yd; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcepv8Yd"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e49fbf92aaso6997585ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 18:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791767848; x=1792372648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PpSzp8c5pJJFbIeKLl4M+fiD9xp5gg6CBYnIJJD7qs4=;
        b=lcepv8YdzbVogWdESUiKECg7nSrBlKNPxQW85zieOLGPkjYyYNwy1k/SHkbDKEMfvg
         er6W6HP17geFUawoH3+kd9zHCm+uYm2VgFUfax83TdjQ4cS0nkPMn/Rz03vwi3q+M3wS
         FL1biPnLKy1ZTTvaV5YmjwGuJJILe3EUOegv+bmAOySTzDiWqiJPwOFvHWOG44jvba/n
         X0MMAqOTzdX46IcyR0RLemuMgcZlzHH4s4zYbZ9NFk7UH9DYPgiAFTBGFdWACz5jEfiu
         CoGUQs8AMFqUkvsVTk+BPCRC+6eaiAMYo7O5ry0mAV3P/ta7cengOJi4oXEPutjk+Qj+
         0tRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791767848; x=1792372648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpSzp8c5pJJFbIeKLl4M+fiD9xp5gg6CBYnIJJD7qs4=;
        b=frQbaqBBZbaPNzNIFZlSQqEtA1sOMJA3sCWaUc8mEOky/H5QXQH2JTHejPjpn5sPXy
         TyKkxSRVtEtdnFw887I0vYE2TRrTgh9Eb01j0Ua0PnWgNaeRmAmQk2Rklz971MDW92o8
         dERsusWoJEbh2wSVDO709J3effgpZ+UAq7GI7n8DIkSTZjblcsEKXMw+dowSBfR9gNPn
         qm7FlBgfkGhQ1rkxsdorqRa5sHWktZSQQexj+OeslcuuO/RH7NNLKP0zgYHInKM9WYPd
         8ZWSeaGMbV/cUmQJMR9P5svf/JlCWGfHnt2vON+6l4tqU07JsGG3jqpWHyqnri1V83/S
         o+BQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLV8ctKKvHFbNuk35hubRYTT7f5dp/CEEpXZSTABTU+m73ESzKFX8YBRr94sI23DJw9LghXdfOMxxvheh0SA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKuTrJlVQKwrmn/PrFJKlC4FccyZGoaEBuB3X7YL5IuFU+zkaP4
	YeQQqJQic8atWKvBe8bEn3Cf+X3rc+rj0htJLdR2uOB5DYX92tWmuMXO
X-Gm-Gg: AYBFou1yhgrvRZDpn2ha2+bH5Cat+Gm9sOyBB3jHWVpqwBY0nj6FOXrrFACDqqA102W
	emSNp7WGCg2NliBgt2EqW5qHJD3AA3lgWx/O9BqmBsnuMDLiZLlQ9Tyg0BF+w8gnqaHd9rkuXTA
	bh+ecmYNWNPaJo12n03dyFryK4+8nfAZkijZjLmBUYd3652yEtc/p9aDCr1gB3OQx71g0k0aNOT
	jI+jCzcHUWM4AoIYkBfAeX/RBgihY1MUjBzca7Cp9LCakh7miwM1SwuZEtZRQhVZYBckycIw7lM
	qnrOMLjybiFshNt9foU4fiK4ZEqLVl41eFFX5YGeslYhTsw0h1zSlN1fQs/B4+5LCRB2MBzQ2pV
	Lr3MBhALU/K8PVGN10v4oi0IgO1S5gnVJIPkiKv3UjJwjgIk58CooyZI1tocxOqQcfW1BbYF58K
	ePFJu1ow7op/njUkWf08wONfpiFG8tbuPXRQcTEGimwXcc/0FUVjh0o5DTcJzvcIfqc/k27m5kl
	eKTRkZFI+WdgX77BlhzeGOm7naZdnDeyzxOCQlQiRzSBVQXKE901d93EFpcNArbIBlyO7JyNwC7
X-Received: by 2002:a17:90b:380a:b0:3a8:cb54:e132 with SMTP id 98e67ed59e1d1-3ab3ae2c453mr7026542a91.49.1791767848498;
        Sun, 11 Oct 2026 18:17:28 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38dd5864sm13743307a91.8.2026.10.11.18.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:17:27 -0700 (PDT)
Sender: Yuyang Huang <uyoko90@gmail.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Shuah Khan <shuah@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v11 2/6] net: change netdev_hw_addr_list count through helpers
Date: Mon, 12 Oct 2026 10:17:03 +0900
Message-ID: <20261012011707.3378-3-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012011707.3378-1-sigefriedhyy@gmail.com>
References: <20261012011707.3378-1-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The count of a netdev_hw_addr_list is changed in several places of
dev_addr_lists.c and a few drivers read it directly. The next patch
needs to account every change of the count of dev->mc.

Add __hw_addr_count_add(), __hw_addr_count_inc(), __hw_addr_count_dec()
and __hw_addr_count_reset(), use them for every change of the count
and rename the field to _count so that a direct write stands out.
Readers keep using netdev_hw_addr_list_count() and the netdev_uc_count()
and netdev_mc_count() helpers, the few that read the field directly
are converted. No functional change.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  4 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |  8 ++--
 include/linux/netdevice.h                     |  7 ++-
 net/core/dev_addr_lists.c                     | 44 ++++++++++++++-----
 net/core/dev_addr_lists_test.c                | 18 ++++----
 net/mac80211/driver-ops.h                     |  2 +-
 6 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 2cf3365b96364..bb72c08337211 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -573,14 +573,14 @@ static void octeon_mgmt_set_rx_filtering(struct net_device *netdev)
 
 	memset(&cam_state, 0, sizeof(cam_state));
 
-	if ((netdev->flags & IFF_PROMISC) || netdev->uc.count > 7) {
+	if ((netdev->flags & IFF_PROMISC) || netdev_uc_count(netdev) > 7) {
 		cam_mode = 0;
 		available_cam_entries = 8;
 	} else {
 		/* One CAM entry for the primary address, leaves seven
 		 * for the secondary addresses.
 		 */
-		available_cam_entries = 7 - netdev->uc.count;
+		available_cam_entries = 7 - netdev_uc_count(netdev);
 	}
 
 	if (netdev->flags & IFF_MULTICAST) {
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 956cb578bf37c..d3343113cea50 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -704,17 +704,17 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		return;
 
 	if (dev->flags & IFF_ALLMULTI ||
-	    dev->mc.count > WILC_MULTICAST_TABLE_SIZE) {
+	    netdev_mc_count(dev) > WILC_MULTICAST_TABLE_SIZE) {
 		wilc_setup_multicast_filter(vif, 0, 0, NULL);
 		return;
 	}
 
-	if (dev->mc.count == 0) {
+	if (netdev_mc_empty(dev)) {
 		wilc_setup_multicast_filter(vif, 1, 0, NULL);
 		return;
 	}
 
-	mc_list = kmalloc_array(dev->mc.count, ETH_ALEN, GFP_ATOMIC);
+	mc_list = kmalloc_array(netdev_mc_count(dev), ETH_ALEN, GFP_ATOMIC);
 	if (!mc_list)
 		return;
 
@@ -727,7 +727,7 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		cur_mc += ETH_ALEN;
 	}
 
-	if (wilc_setup_multicast_filter(vif, 1, dev->mc.count, mc_list))
+	if (wilc_setup_multicast_filter(vif, 1, netdev_mc_count(dev), mc_list))
 		kfree(mc_list);
 }
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f61c972313095..3d9e3a70ca5c9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -252,13 +252,16 @@ struct netdev_hw_addr {
 
 struct netdev_hw_addr_list {
 	struct list_head	list;
-	int			count;
+	/* Only changed through the __hw_addr_count_* helpers after
+	 * __hw_addr_init()
+	 */
+	int			_count;
 
 	/* Auxiliary tree for faster lookup on addition and deletion */
 	struct rb_root		tree;
 };
 
-#define netdev_hw_addr_list_count(l) ((l)->count)
+#define netdev_hw_addr_list_count(l) ((l)->_count)
 #define netdev_hw_addr_list_empty(l) (netdev_hw_addr_list_count(l) == 0)
 #define netdev_hw_addr_list_for_each(ha, l) \
 	list_for_each_entry(ha, &(l)->list, list)
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 08528ca0a8b31..d615192d1c3b1 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -16,6 +16,26 @@
 
 #include "dev.h"
 
+static void __hw_addr_count_add(struct netdev_hw_addr_list *list, int value)
+{
+	list->_count += value;
+}
+
+static void __hw_addr_count_inc(struct netdev_hw_addr_list *list)
+{
+	__hw_addr_count_add(list, 1);
+}
+
+static void __hw_addr_count_dec(struct netdev_hw_addr_list *list)
+{
+	__hw_addr_count_add(list, -1);
+}
+
+static void __hw_addr_count_reset(struct netdev_hw_addr_list *list)
+{
+	list->_count = 0;
+}
+
 /*
  * General list handling functions
  */
@@ -125,7 +145,7 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 	rb_insert_color(&ha->node, &list->tree);
 
 	list_add_tail_rcu(&ha->list, &list->list);
-	list->count++;
+	__hw_addr_count_inc(list);
 
 	return 0;
 }
@@ -161,7 +181,7 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 
 	list_del_rcu(&ha->list);
 	kfree_rcu(ha, rcu_head);
-	list->count--;
+	__hw_addr_count_dec(list);
 	return 0;
 }
 
@@ -492,14 +512,14 @@ void __hw_addr_flush(struct netdev_hw_addr_list *list)
 		list_del_rcu(&ha->list);
 		kfree_rcu(ha, rcu_head);
 	}
-	list->count = 0;
+	__hw_addr_count_reset(list);
 }
 EXPORT_SYMBOL_IF_KUNIT(__hw_addr_flush);
 
 void __hw_addr_init(struct netdev_hw_addr_list *list)
 {
 	INIT_LIST_HEAD(&list->list);
-	list->count = 0;
+	list->_count = 0;
 	list->tree = RB_ROOT;
 }
 EXPORT_SYMBOL(__hw_addr_init);
@@ -509,8 +529,8 @@ static void __hw_addr_splice(struct netdev_hw_addr_list *dst,
 {
 	src->tree = RB_ROOT;
 	list_splice_init(&src->list, &dst->list);
-	dst->count += src->count;
-	src->count = 0;
+	__hw_addr_count_add(dst, netdev_hw_addr_list_count(src));
+	__hw_addr_count_reset(src);
 }
 
 /**
@@ -532,11 +552,11 @@ int __hw_addr_list_snapshot(struct netdev_hw_addr_list *snap,
 	struct netdev_hw_addr *ha, *entry;
 
 	list_for_each_entry(ha, &list->list, list) {
-		if (cache->count) {
+		if (netdev_hw_addr_list_count(cache)) {
 			entry = list_first_entry(&cache->list,
 						 struct netdev_hw_addr, list);
 			list_del(&entry->list);
-			cache->count--;
+			__hw_addr_count_dec(cache);
 			memcpy(entry->addr, ha->addr, addr_len);
 			entry->type = ha->type;
 			entry->global_use = false;
@@ -554,7 +574,7 @@ int __hw_addr_list_snapshot(struct netdev_hw_addr_list *snap,
 
 		list_add_tail(&entry->list, &snap->list);
 		__hw_addr_insert(snap, entry, addr_len);
-		snap->count++;
+		__hw_addr_count_inc(snap);
 	}
 
 	return 0;
@@ -604,14 +624,14 @@ void __hw_addr_list_reconcile(struct netdev_hw_addr_list *real_list,
 			if (delta > 0) {
 				rb_erase(&ref_ha->node, &ref->tree);
 				list_del(&ref_ha->list);
-				ref->count--;
+				__hw_addr_count_dec(ref);
 				ref_ha->sync_cnt = delta;
 				ref_ha->refcount = delta;
 				list_add_tail_rcu(&ref_ha->list,
 						  &real_list->list);
 				__hw_addr_insert(real_list, ref_ha,
 						 addr_len);
-				real_list->count++;
+				__hw_addr_count_inc(real_list);
 			}
 			continue;
 		}
@@ -622,7 +642,7 @@ void __hw_addr_list_reconcile(struct netdev_hw_addr_list *real_list,
 			rb_erase(&real_ha->node, &real_list->tree);
 			list_del_rcu(&real_ha->list);
 			kfree_rcu(real_ha, rcu_head);
-			real_list->count--;
+			__hw_addr_count_dec(real_list);
 		}
 	}
 
diff --git a/net/core/dev_addr_lists_test.c b/net/core/dev_addr_lists_test.c
index 260e71a2399f3..07c35a0af2b4d 100644
--- a/net/core/dev_addr_lists_test.c
+++ b/net/core/dev_addr_lists_test.c
@@ -291,7 +291,7 @@ static void dev_addr_test_snapshot_sync(struct kunit *test)
 	netif_addr_unlock_bh(netdev);
 
 	/* Real entry should now reflect the sync: sync_cnt=1, refcount=2 */
-	KUNIT_EXPECT_EQ(test, 1, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 1, netdev_uc_count(netdev));
 	ha = list_first_entry(&netdev->uc.list, struct netdev_hw_addr, list);
 	KUNIT_EXPECT_MEMEQ(test, ha->addr, addr, ETH_ALEN);
 	KUNIT_EXPECT_EQ(test, 1, ha->sync_cnt);
@@ -303,7 +303,7 @@ static void dev_addr_test_snapshot_sync(struct kunit *test)
 			   dev_addr_test_unsync);
 	KUNIT_EXPECT_EQ(test, 0, datp->addr_synced);
 	KUNIT_EXPECT_EQ(test, 0, datp->addr_unsynced);
-	KUNIT_EXPECT_EQ(test, 1, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 1, netdev_uc_count(netdev));
 
 	__hw_addr_flush(&cache);
 	rtnl_unlock();
@@ -351,7 +351,7 @@ static void dev_addr_test_snapshot_remove_during_sync(struct kunit *test)
 	/* Concurrent removal: user deletes ADDR_A while driver was working */
 	memset(addr, ADDR_A, sizeof(addr));
 	KUNIT_EXPECT_EQ(test, 0, dev_uc_del(netdev, addr));
-	KUNIT_EXPECT_EQ(test, 0, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 0, netdev_uc_count(netdev));
 
 	/* Reconcile: ADDR_A gone from real list but driver synced it,
 	 * so it gets re-inserted as stale (sync_cnt=1, refcount=1).
@@ -361,7 +361,7 @@ static void dev_addr_test_snapshot_remove_during_sync(struct kunit *test)
 				 &cache);
 	netif_addr_unlock_bh(netdev);
 
-	KUNIT_EXPECT_EQ(test, 1, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 1, netdev_uc_count(netdev));
 	ha = list_first_entry(&netdev->uc.list, struct netdev_hw_addr, list);
 	KUNIT_EXPECT_MEMEQ(test, ha->addr, addr, ETH_ALEN);
 	KUNIT_EXPECT_EQ(test, 1, ha->sync_cnt);
@@ -373,7 +373,7 @@ static void dev_addr_test_snapshot_remove_during_sync(struct kunit *test)
 			   dev_addr_test_unsync);
 	KUNIT_EXPECT_EQ(test, 0, datp->addr_synced);
 	KUNIT_EXPECT_EQ(test, 1 << ADDR_A, datp->addr_unsynced);
-	KUNIT_EXPECT_EQ(test, 0, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 0, netdev_uc_count(netdev));
 
 	__hw_addr_flush(&cache);
 	rtnl_unlock();
@@ -433,7 +433,7 @@ static void dev_addr_test_snapshot_readd_during_unsync(struct kunit *test)
 	 * stale entry and bumps refcount from 1 -> 2.  sync_cnt stays 1.
 	 */
 	KUNIT_EXPECT_EQ(test, 0, dev_uc_add(netdev, addr));
-	KUNIT_EXPECT_EQ(test, 1, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 1, netdev_uc_count(netdev));
 
 	/* Reconcile: ref sync_cnt=1 matches real sync_cnt=1, delta=-1
 	 * applied. Result: sync_cnt=0, refcount=1 (fresh).
@@ -444,7 +444,7 @@ static void dev_addr_test_snapshot_readd_during_unsync(struct kunit *test)
 	netif_addr_unlock_bh(netdev);
 
 	/* Entry survives as fresh: needs re-sync to HW */
-	KUNIT_EXPECT_EQ(test, 1, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 1, netdev_uc_count(netdev));
 	ha = list_first_entry(&netdev->uc.list, struct netdev_hw_addr, list);
 	KUNIT_EXPECT_MEMEQ(test, ha->addr, addr, ETH_ALEN);
 	KUNIT_EXPECT_EQ(test, 0, ha->sync_cnt);
@@ -528,7 +528,7 @@ static void dev_addr_test_snapshot_add_and_remove(struct kunit *test)
 	 * ADDR_B: refcount went from 2->1 via dev_uc_del (still present, stale)
 	 * ADDR_C: sync propagated (sync_cnt=1, refcount=2)
 	 */
-	KUNIT_EXPECT_EQ(test, 3, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 3, netdev_uc_count(netdev));
 	netdev_hw_addr_list_for_each(ha, &netdev->uc) {
 		u8 id = ha->addr[0];
 
@@ -553,7 +553,7 @@ static void dev_addr_test_snapshot_add_and_remove(struct kunit *test)
 			   dev_addr_test_unsync);
 	KUNIT_EXPECT_EQ(test, 0, datp->addr_synced);
 	KUNIT_EXPECT_EQ(test, 1 << ADDR_B, datp->addr_unsynced);
-	KUNIT_EXPECT_EQ(test, 2, netdev->uc.count);
+	KUNIT_EXPECT_EQ(test, 2, netdev_uc_count(netdev));
 
 	__hw_addr_flush(&cache);
 	rtnl_unlock();
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5f..e80731c59ef50 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -187,7 +187,7 @@ static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 {
 	u64 ret = 0;
 
-	trace_drv_prepare_multicast(local, mc_list->count);
+	trace_drv_prepare_multicast(local, netdev_hw_addr_list_count(mc_list));
 
 	if (local->ops->prepare_multicast)
 		ret = local->ops->prepare_multicast(&local->hw, mc_list);
-- 
2.43.0

