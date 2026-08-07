Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C71471268;
	Fri,  7 Aug 2026 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109176; cv=none; b=gNCfLT5LVjgZZ3+2MUzuvj7xx0QHb/OOQlj0UtKqlxeuKv9oCiA/ZnglFPeYMDeU5HHfW7U7FfEtx43LXEip6nmnK0jiO4+LgxfklgNuO5W6z7w8t1QNYyfkekqshIHg7MWAXxnnUgk8e8gpnv95Uyu6KmCsTIhrKuKPwLXZS14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109176; c=relaxed/simple;
	bh=nf9sfgQLJFbE7maGhb1GnjFTOuGCSzxevoQprhbdVE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BD/XK5zdtamQ8c6p5sRwqj/NA/aGVwg3fRSPvDvsfv09TtMopq2LKyMCaTP7ZpqL9PxnVKBQGg9qdYdfs1kuFij2niESI0Y4Mq4QOPOTuFALMoPcNU+PLrUSjs2YzbJ23ipoI3E+9hJ1kED+BOqni6uORtTdhxSCkGf0Ahqdxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8888a52e926311f1aa26b74ffac11d73-20260807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:baf4a427-08f5-4fe1-a5e8-59a2ba4101bf,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:bce982092b24597f7f162aeaad791073,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8888a52e926311f1aa26b74ffac11d73-20260807
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 732117332; Fri, 07 Aug 2026 21:26:01 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: jeff.chen_1@nxp.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it,
	arend.vanspriel@broadcom.com,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 1/2] wifi: nxpwifi: protect sta_list against concurrent add and delete
Date: Fri,  7 Aug 2026 21:25:53 +0800
Message-Id: <20260807132554.888706-2-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260807132554.888706-1-lilinmao@kylinos.cn>
References: <20260807132554.888706-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_del_sta_entry() unlinks an entry from priv->sta_list without
holding priv->sta_list_spinlock.  The comment above it gives the
reason: the function is only reached from cfg80211_ops.del_station,
which runs under the wiphy mutex.

That mutex serialises this callback against other users of the same
lock, including wiphy_work items.  It covers neither of the two other
writers of the same list:

  nxpwifi_add_sta_entry()    from nxpwifi_uap_event_sta_assoc()
  nxpwifi_del_all_sta_list() from nxpwifi_uap_event_bss_idle()

Both run from nxpwifi_process_event() on the driver's main work queue,
a plain workqueue that never takes the wiphy lock, and both take
sta_list_spinlock around their update.  A station associating, or the
BSS going idle, can therefore modify priv->sta_list while a hostapd
del_station is walking it and unlinking an entry.

Take the lock here too.  As the traversal then runs under the write
lock, list_for_each_entry() replaces the _rcu variant, matching
nxpwifi_del_all_sta_list().

The same call path reaches nxpwifi_get_sta_entry() without
rcu_read_lock().  Entries are freed with kfree_rcu() and every other
caller holds it, so take it around the lookup as well.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 2 ++
 drivers/net/wireless/nxp/nxpwifi/util.c     | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 5cc8cdf594d3e..939177bcc6cde 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -1539,9 +1539,11 @@ nxpwifi_cfg80211_del_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	eth_zero_addr(deauth_mac);
 
+	rcu_read_lock();
 	sta_node = nxpwifi_get_sta_entry(priv, params->mac);
 	if (sta_node)
 		ether_addr_copy(deauth_mac, params->mac);
+	rcu_read_unlock();
 
 	if (is_valid_ether_addr(deauth_mac)) {
 		ret = nxpwifi_uap_sta_deauth(priv, deauth_mac);
diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index bbfefb81d8d3b..ae8444a141058 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -1041,19 +1041,23 @@ nxpwifi_set_sta_ht_cap(struct nxpwifi_private *priv, const u8 *ies,
 	}
 }
 
-/* Delete a station from list; called under cfg80211 mutex. */
+/* Delete a station from list. */
 
 void nxpwifi_del_sta_entry(struct nxpwifi_private *priv, const u8 *mac)
 {
 	struct nxpwifi_sta_node *node;
 
-	list_for_each_entry_rcu(node, &priv->sta_list, list) {
+	spin_lock_bh(&priv->sta_list_spinlock);
+
+	list_for_each_entry(node, &priv->sta_list, list) {
 		if (!memcmp(node->mac_addr, mac, ETH_ALEN)) {
 			list_del_rcu(&node->list);
 			kfree_rcu(node, rcu);
 			break;
 		}
 	}
+
+	spin_unlock_bh(&priv->sta_list_spinlock);
 }
 
 /* Delete all stations from list. */
-- 
2.25.1

