Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0974C652D
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767748; cv=none; b=boKRwBc66hWZ6FlcxqVbr9OMebGe2itNblB7ifpijHVTgXcTPJagHQ05lZbacDquGDZamdB1tITM0uT3/vN2h9Kgh3Oiuaf7pgVX78oApV4ASiVK8YL5o5G9GoYodsoTVeMYfTE+13OGsa09q6+zSWqx1QoPGlavyJmmtImLHfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767748; c=relaxed/simple;
	bh=o78ciCpXDfIYH1oy8QPsys44CTqq8XorYBGAwxuHHz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGzX34Fux5RzYZZQerbzRl518kogSDpxIOwcXj0bQk1CO2iFSYLJQeXetGBuS+5vtRXAgF60lXmqZdTjOF1+aqJHnLAlL5+DH5AXFrB9BqlKyDihL0uhIW7VbXYX+7oMI8bzEOj9/qL5VNKEWiEzwIu82/qaiww4lfUIfT0efSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdeSzfcb; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdeSzfcb"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so2172756a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 04:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767746; x=1791372546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NfOhX7KR77R3ls7z6JBoXar6xAjR5an9iT+KISorDCo=;
        b=KdeSzfcb4Mar/WV0Sb9KggQPGMvpWkkfpE/yA6eZjryTSMKA58M0fqR39tqb4/j8aS
         4kFlgQz/pf6zdM2LnCJ3fubYEjD9+cDDb9ymM5oM9yn8Lx+HyJb7nNcM+Sf0QqzKEJ/A
         rK6xFKf2xJsHpN5HyxHytj18DF5lfkuIvxAgR/8PCOml/75/vli0rfeYQmyENT8ikDgN
         P269DV/dke2z8aF+3O5v/yeLcxWI1GgM3tsaEW7EIFjpEZgIiSPk/YJQF3FgD0REHQ+0
         nV+1zXM8F5lxG1kFDxTr53O0lTPELGXvVhw9CAITsIvpEAcDi/IfDWatJy4sUJFjQq/b
         JpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767746; x=1791372546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NfOhX7KR77R3ls7z6JBoXar6xAjR5an9iT+KISorDCo=;
        b=nr22MYwPMUUK63hzOx/H7iuyLMsiN88c/o9FSbPA5O9zx7d4puS4PBM3gWaJwSxMm2
         qndTkILdF1hyyFV8aOaNrEleIaNaX5wnyTalH/Mmf0GixqbRodp9OEpjHCOfCr9/TRp7
         nsAU46n6/kBPDebEZbDfmE9WhPmajCPze8AYQxz3wZ+BXVNS6Ya8DahL0+90zG0iRH/q
         lYD6ne+5Dy6LSu9liXxgWPTUuwYEaRcJLgKLm+OkSpN9VIVEbE03qVzkURWhAir7PkCC
         mlvZRgUuaNZRJPv3pbXdnvZ/78I6o63s4W93/pChknZaL3PB2MwzMbaSUIpw4OkBK3tG
         OCgg==
X-Forwarded-Encrypted: i=1; AKwUvByJPey11k4zeGAmItXlp+kIpWYCcLUAdpjFn8HrOna86kGJ0aSJthTJxKxpWeg1ISSkryStQyR6Wx7yHFyu5Q==@vger.kernel.org
X-Gm-Message-State: AFuF++lYE29PQ94ZjzsRCWr4tb77RSVEVjTqFZqCRzMqVfEw1F1NoX3Y
	iZIBQDEMHGyffI8Gd8DlO0brr2rY/kntkhamPkK4Q8USC2obJnmHkpnK
X-Gm-Gg: AYBFou0vuAzjK2NLmrPTVBSZbH8Lv416YlQ/WBOJkHMuA7JYcw6ROXTMwlkppJ3RiAM
	8Uuc7wRdPwB5kXM5k7ECQGh5douiDlELYspZCDaGeU3gMrh8F57qwPHnhExB6dFJ0n0lJl8shtv
	QvDZtfR1ZcMqSP9ci+agOf4WEeEv0rKXjpObuzGygHyBQWnqz18ZzCnWvEQEIWWfJa60eigrBHq
	4BElnofw0rCE1W/5QcGusRzPwji43WMRi2b+3hQcGZkhvf/6gNN/8xeyhsZvBpXUtZn60pRilQB
	IA1tQB2yCBRnubUmIIUT0GFa9kIYWBEBooKqjjIAIqUF9NXfSTARn2gOZ90D+nj1lfMhvLC1DfG
	QBW+EM1+Sqkw771KfjlNhXRFWFkztfGkBOqkhNClYcPggURMR/YG5d3ulMB3aMjT4OmcX72H0s/
	vt42UVOf7S20MXZEHrOWAgOacWgWc25uxJoU7ObkXzNnAF1Uk6Of6fa0T1wU+v2RUTdovRTgnhC
	+HqTzNDdCx7IF3FIaQJ7MKgH+ns54lZg3r8UkJhe1qqhMdlukv7huc=
X-Received: by 2002:a05:6a20:244a:b0:3de:20c:e8e with SMTP id adf61e73a8af0-3de9e7b41d2mr1089860637.40.1790767745662;
        Wed, 30 Sep 2026 04:29:05 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan ([2400:2410:3f60:500:3fb:270c:7df4:18f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm712637a12.31.2026.09.30.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:29:05 -0700 (PDT)
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
Subject: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count through helpers
Date: Wed, 30 Sep 2026 20:28:38 +0900
Message-ID: <20260930112842.21323-3-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930112842.21323-1-sigefriedhyy@gmail.com>
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
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
---
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |  4 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |  8 ++--
 include/linux/netdevice.h                     |  5 ++-
 net/core/dev_addr_lists.c                     | 44 ++++++++++++++-----
 net/core/dev_addr_lists_test.c                | 18 ++++----
 net/mac80211/driver-ops.h                     |  2 +-
 6 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index c190fc6538d4c..5e3c379b24234 100644
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
index d037faff7c44b..97dc053f234cc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -252,13 +252,14 @@ struct netdev_hw_addr {
 
 struct netdev_hw_addr_list {
 	struct list_head	list;
-	int			count;
+	/* Only changed through the __hw_addr_count_* helpers */
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
index 08528ca0a8b31..23f5db99a702d 100644
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
+	__hw_addr_count_add(dst, src->_count);
+	__hw_addr_count_reset(src);
 }
 
 /**
@@ -532,11 +552,11 @@ int __hw_addr_list_snapshot(struct netdev_hw_addr_list *snap,
 	struct netdev_hw_addr *ha, *entry;
 
 	list_for_each_entry(ha, &list->list, list) {
-		if (cache->count) {
+		if (cache->_count) {
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

