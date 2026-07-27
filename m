Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C45E42376A
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169694; cv=none; b=uFbJjG3Bn6El9LbLUJoVW5M5RXwuJdZCb3eu+CaEDvo4NaZwBmpC7NHNokJBPp8Vvl1kLzGL43UmLSzDa1tJ3flQAGI6NKT67A2tDEoWqcQt2adZGMSe4HDdF2dR+X4G0iNraC0SUdkisOXygKPkaXZushQqVaI8tZ6gKGjZNCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169694; c=relaxed/simple;
	bh=W+5xqSWWb7fq6zjVvaO0AbN67rkt0beQoWCElJCO+ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thOGbXZXWRj7eVq6KEtBGpb+9aZTpvUmVVrNO+RW+boeu6vsFKO0Ecy0oqoPXb7hAizKJNK0jrAW2PdBMPLVHfZXP8+8eTtcrQq2Q2OuoK8B3Yi8epUFazkXMvTdoibwB3eC3ZscevcBklxjc9bDwXHBTLvFSAirR/Fo7o5VbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K19VTROr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K19VTROr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785169692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qU4mury5dUC+mV/3udjq3v/PsV2Tq2IdSkugGkcQ0og=;
	b=K19VTROra16I9fQ7D/JiVWlSoLMF3RgZIC38Tca5qTGXIgjpWzk0Gb5pC8ZhSaoNuJOF+/
	947xzoP3n/tBsFfEOFexRQw14JGdIyULQipXKmW2aPKbfCkEEjsC93pNPWAPCRXrSifUZ7
	bBw0N1HoI6cAf/VPrlKfGXy3tEazPSc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-ipH0MB74PUaAKsD6Z2KgJA-1; Mon,
 27 Jul 2026 12:28:06 -0400
X-MC-Unique: ipH0MB74PUaAKsD6Z2KgJA-1
X-Mimecast-MFC-AGG-ID: ipH0MB74PUaAKsD6Z2KgJA_1785169685
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CAA918001F9;
	Mon, 27 Jul 2026 16:28:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 30F52429;
	Mon, 27 Jul 2026 16:28:02 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 1/5] wifi: ath12k: fix MLO station firmware crash recovery
Date: Mon, 27 Jul 2026 18:27:44 +0200
Message-ID: <20260727162748.963275-2-jtornosm@redhat.com>
In-Reply-To: <20260727162748.963275-1-jtornosm@redhat.com>
References: <20260727162748.963275-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

ATH12K_FLAG_RECOVERY is cleared too early in
ath12k_core_reconfigure_on_crash(), before mac80211 runs
ieee80211_reconfig(). By the time mac80211 calls back into the driver
(sta_state, change_vif_links, set_key), the RECOVERY flag is already false,
so the driver treats recovery callbacks as normal operations.

This causes several problems during MLO recovery:

- ath12k_mac_op_sta_state() tries to activate MLO links during the
  AUTH->ASSOC transition, calling ieee80211_set_active_links()
  recursively, which triggers a WARNING at net/mac80211/link.c.

- ath12k_mac_op_change_vif_links() processes link removal during
  reconfig, causing inconsistent state.

- ath12k_mac_set_key() fails with "cannot install key for non-existent
  peer" because peers do not exist yet during reconfig. Keys will be
  re-established during normal reconnection after
  ieee80211_hw_restart_disconnect() triggers a fresh association.

- ath12k_mac_flush() waits for pending TX to complete, but after a
  firmware crash the TX will never complete, causing a 20 second timeout.

- ath12k_mac_station_remove() calls ath12k_bss_disassoc() and
  ath12k_mac_vdev_stop() which send WMI commands to dead firmware,
  causing timeouts that delay recovery.

- ath12k_clear_peer_keys() tries to look up and clear peer keys, but
  peers are already gone after firmware crash.

- ath12k_dp_rx_ampdu_stop() dereferences per-link station state that
  may not be valid during crash teardown.

- ath12k_peer_mlo_link_peers_delete() sends WMI peer delete commands
  for each MLO link peer. With dead firmware these time out and can
  trigger cascading resets.

- HAL srng source ring operations (ath12k_hal_srng_src_num_free,
  ath12k_hal_srng_src_get_next_entry, ath12k_hal_srng_access_end)
  may attempt MMIO access to hardware that is no longer responsive
  if TX paths race with the crash. Guard these to prevent potential
  hard lockups on unresponsive hardware.

These issues were observed during sporadic firmware crashes in MLO
operation. To allow systematic testing and reproduction, the debugfs
simulate_fw_crash interface was used to trigger controlled firmware
crashes during active MLO connections with traffic.

Fix by moving clear_bit(ATH12K_FLAG_RECOVERY) from
ath12k_core_reconfigure_on_crash() to ath12k_mac_op_reconfig_complete(),
so the flag stays set through the entire mac80211 reconfig phase. Add
ATH12K_FLAG_RECOVERY checks in change_vif_links, set_key, and sta_state
to skip operations that are invalid during recovery. Add
ATH12K_FLAG_CRASH_FLUSH checks in mac_flush, station_remove,
clear_peer_keys, dp_rx_ampdu_stop, peer_mlo_link_peers_delete, and the
HAL srng source ring helpers to return immediately when the firmware is
dead.

Tested on WCN7850 with MLO (Wi-Fi 7).

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/net/wireless/ath/ath12k/core.c  |  2 --
 drivers/net/wireless/ath/ath12k/dp_rx.c |  3 +++
 drivers/net/wireless/ath/ath12k/hal.c   | 10 ++++++++++
 drivers/net/wireless/ath/ath12k/mac.c   | 19 +++++++++++++++++--
 drivers/net/wireless/ath/ath12k/peer.c  |  6 ++++++
 5 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 742d4fd1b598..5c3883b19da1 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1410,8 +1410,6 @@ static int ath12k_core_reconfigure_on_crash(struct ath12k_base *ab)
 	if (ret)
 		goto err_hal_srng_deinit;
 
-	clear_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags);
-
 	return 0;
 
 err_hal_srng_deinit:
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..473855ded8a7 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -751,6 +751,9 @@ int ath12k_dp_rx_ampdu_stop(struct ath12k *ar,
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
+	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
+		return 0;
+
 	arsta = wiphy_dereference(ath12k_ar_to_hw(ar)->wiphy,
 				  ahsta->link[link_id]);
 	if (!arsta)
diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index 071cb5d30931..6d3f4bca46a3 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -376,6 +376,9 @@ int ath12k_hal_srng_src_num_free(struct ath12k_base *ab, struct hal_srng *srng,
 
 	lockdep_assert_held(&srng->lock);
 
+	if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))
+		return 0;
+
 	hp = srng->u.src_ring.hp;
 
 	if (sync_hw_ptr) {
@@ -419,6 +422,9 @@ void *ath12k_hal_srng_src_get_next_entry(struct ath12k_base *ab,
 
 	lockdep_assert_held(&srng->lock);
 
+	if (unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))
+		return NULL;
+
 	/* TODO: Using % is expensive, but we have to do this since size of some
 	 * SRNG rings is not power of 2 (due to descriptor sizes). Need to see
 	 * if separate function is defined for rings having power of 2 ring size
@@ -524,6 +530,10 @@ void ath12k_hal_srng_access_end(struct ath12k_base *ab, struct hal_srng *srng)
 {
 	lockdep_assert_held(&srng->lock);
 
+	if (srng->ring_dir == HAL_SRNG_DIR_SRC &&
+	    unlikely(test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)))
+		return;
+
 	if (srng->flags & HAL_SRNG_FLAGS_LMAC_RING) {
 		/* For LMAC rings, ring pointer updates are done through FW and
 		 * hence written to a shared memory location that is read by FW
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 51c4df32e716..c559ced9e524 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4278,6 +4278,9 @@ ath12k_mac_op_change_vif_links(struct ieee80211_hw *hw,
 
 	lockdep_assert_wiphy(hw->wiphy);
 
+	if (old_links && test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags))
+		return -EINVAL;
+
 	ath12k_generic_dbg(ATH12K_DBG_MAC,
 			   "mac vif link changed for MLD %pM old_links 0x%x new_links 0x%x\n",
 			   vif->addr, old_links, new_links);
@@ -5956,6 +5959,9 @@ static int ath12k_clear_peer_keys(struct ath12k_link_vif *arvif,
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
+	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
+		return 0;
+
 	spin_lock_bh(&dp->dp_lock);
 	peer = ath12k_dp_link_peer_find_by_vdev_and_addr(dp, arvif->vdev_id, addr);
 	if (!peer || !peer->dp_peer) {
@@ -6031,6 +6037,8 @@ static int ath12k_mac_set_key(struct ath12k *ar, enum set_key_cmd cmd,
 		spin_unlock_bh(&dp->dp_lock);
 
 		if (cmd == SET_KEY) {
+			if (test_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags))
+				return 0;
 			ath12k_warn(ab, "cannot install key for non-existent peer %pM\n",
 				    peer_addr);
 			return -EOPNOTSUPP;
@@ -7045,7 +7053,8 @@ static int ath12k_mac_station_remove(struct ath12k *ar,
 
 	wiphy_work_cancel(ar->ah->hw->wiphy, &arsta->update_wk);
 
-	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA) {
+	if (ahvif->vdev_type == WMI_VDEV_TYPE_STA &&
+	    !test_bit(ATH12K_FLAG_CRASH_FLUSH, &ar->ab->dev_flags)) {
 		ath12k_bss_disassoc(ar, arvif);
 		ret = ath12k_mac_vdev_stop(arvif);
 		if (ret)
@@ -7795,7 +7804,8 @@ int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	 * about to move to the associated state.
 	 */
 	if (ieee80211_vif_is_mld(vif) && vif->type == NL80211_IFTYPE_STATION &&
-	    old_state == IEEE80211_STA_AUTH && new_state == IEEE80211_STA_ASSOC) {
+	    old_state == IEEE80211_STA_AUTH && new_state == IEEE80211_STA_ASSOC &&
+	    !test_bit(ATH12K_FLAG_RECOVERY, &ah->radio[0].ab->dev_flags)) {
 		/* TODO: for now only do link selection for single device
 		 * MLO case. Other cases would be handled in the future.
 		 */
@@ -12596,6 +12606,9 @@ static int ath12k_mac_flush(struct ath12k *ar)
 	long time_left;
 	int ret = 0;
 
+	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ar->ab->dev_flags))
+		return -ESHUTDOWN;
+
 	time_left = wait_event_timeout(ar->dp.tx_empty_waitq,
 				       (atomic_read(&ar->dp.num_tx_pending) == 0),
 				       ATH12K_FLUSH_TIMEOUT);
@@ -13494,6 +13507,8 @@ ath12k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 	for_each_ar(ah, ar, i) {
 		ab = ar->ab;
 
+		clear_bit(ATH12K_FLAG_RECOVERY, &ab->dev_flags);
+
 		ath12k_warn(ar->ab, "pdev %d successfully recovered\n",
 			    ar->pdev->pdev_id);
 
diff --git a/drivers/net/wireless/ath/ath12k/peer.c b/drivers/net/wireless/ath/ath12k/peer.c
index 2681a047d4d5..e96eb78bbc0c 100644
--- a/drivers/net/wireless/ath/ath12k/peer.c
+++ b/drivers/net/wireless/ath/ath12k/peer.c
@@ -297,6 +297,12 @@ int ath12k_peer_mlo_link_peers_delete(struct ath12k_vif *ahvif, struct ath12k_st
 	if (!sta->mlo)
 		return -EINVAL;
 
+	/* During firmware crash, peers are already gone. Skip WMI peer delete
+	 * to avoid timeouts that delay recovery and can trigger cascading resets.
+	 */
+	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ah->radio[0].ab->dev_flags))
+		return 0;
+
 	/* FW expects delete of all link peers at once before waiting for reception
 	 * of peer unmap or delete responses
 	 */
-- 
2.54.0

