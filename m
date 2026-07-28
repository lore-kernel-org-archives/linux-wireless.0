Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC25324B31
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785254608; cv=none; b=GgQEGwSR1HO4CCwUZ4jtVotSWNXU69Gf4mFYbt8k3xPxCSNvKFgrBAnDBpowMNMz2h/mUu4iv3Ee2SU9DEJx/sZIe1d0CiSU/dk6D1yhAJz06wRM62skezzBETw4ly4Vph+bay/ESRVldxqqjOgtGeVpCWOtb2RmQPS824u8deg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785254608; c=relaxed/simple;
	bh=Xi3SeIZwe8/p9QLBPSEm5OUzDFqo3g8aPpOql9GrtLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KG6vCyZbVrpGxi3cF70xQ+RUJUvCuIr9thHXhLK8f1Catt9ACTymOG/YGcXA6eGGJd/YL1NPXddRxdl607UxPEX/n8tCpZBEp34l7VBJeY9cp2pahEWzUy/ndBci1lfcnAgITyQEcKNWNzKQGsD4vxZ881pV1wZbb0o9/l0qLso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JE4yFaNR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JE4yFaNR"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso20925365e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 09:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785254605; x=1785859405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9kHCUyLF0kHDD8ILRj4/H/sMOeT2Xi/hZ4Ns4Kmdsok=;
        b=JE4yFaNRm6GPBz48y8U9/htrnXIaeX9n97th/PJpGuv6eBhj8w34T436BayOqN/oDj
         SjnDcnUtnwyVLoAwOlrjFsNJhza4J/+6qUAjmae5yzra6EluZxZe1hMz3EtF9jgSh0V7
         JmyA+voZCzhpuReTJyJXR/7faVWYWeN8TLQ5lG8zzDwXqODskGcXtlNh5hd4NISNpRUg
         LFtaHkvv6BnZ8xQOfxBa8UHtqQPO9SlD0MRa5cBW05KBBSqm6Zx87mLJzxervj35JH2I
         d/qEvQAnLFAgeQRWv9lm/YVpND+ZtF5enBA8ezYCOXYkxG9T7IsANzUtp9T/1tnxd/mN
         XWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785254605; x=1785859405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9kHCUyLF0kHDD8ILRj4/H/sMOeT2Xi/hZ4Ns4Kmdsok=;
        b=dWUQW6GUr0Wvkdi20feaHTfP9Yz6/dpUdlH2akBcOdLFUozCmoZMGq33nlkYGBN/hr
         y/QregNafERFWgbzz1jI2ehsJ6JYKgfMO0jgJAPVmyRTwDzvHrDONsdm7Xmkx60QYzcT
         qpllHzmCEELnrWuwvbJNzaueRwetjm9aIqcKGTVMTzo/mx2V0OhsYhXJ5bBtEQMGreQy
         6ksMP6mnKebKWmLBKpgzdDkujTu5gudBBjkmCOIO4FXyeioCBOx9UsPbJua0YnUPqMZg
         z9aHhqfMeefW+gLF32reUffOiyy0CV2AMjllwjwn+lQO6Aa0aHq74sLnaTYsE5WHuuiZ
         JwIQ==
X-Gm-Message-State: AOJu0YzcCzQASyt6+6fR8KHzdkT0g0/gab2UL1P9QQCcWjBhaAPCP5hF
	EE0kY7GwSIu7wYTTEGUgiXDmv3k/mxU0orHplhwYRRTRBVGPiejD3pKd
X-Gm-Gg: AR+sD11BuZa8WnlnYbpVwpuhTL/im1vWGCtB1bWYB1MyxM+5HH4nAhrPMdqawm13CyY
	Inzr7kFInkv1c+43oU2W5Q0lb2HiQ7DPcZPsY9QhNapiCr8J3N2C62HDGHPqqoqFA/Dtqz6Jo98
	aDud/OowJ9p45e1eq2GsYpKsUyzffAfQ1JvfheoGz1KELtFWGt90RoGiZdioAyXzxz5IgL+H1Sa
	o9Aqw4k6WHM0Giz0CRkzfVSWdYphiZwWfa63iwN9e81FaywD6Lnn0LpWBxZvxFjrBaEnY+6sczf
	G5Y35jKtDedAgt0PfLtRyOvi+XQR89/k4oPtxbvX3V8Em/ACOJ4nK844G++Zziea/BLGPSCH9Q2
	LG8Xb4sscZ4JR5R+cFoNenFDon9Y3MIUeOE7gummw14gsOio2bqU/+AIGq3794g+TGdjrhuUuxr
	chZfH1B6Gr+1BmSaasvsCSusTDP2dGlYLKtxE=
X-Received: by 2002:a05:600c:a00b:b0:495:515a:dad9 with SMTP id 5b1f17b1804b1-496c65a14b2mr36015295e9.37.1785254604651;
        Tue, 28 Jul 2026 09:03:24 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b18a9fsm106276f8f.32.2026.07.28.09.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 09:03:23 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-current] wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()
Date: Tue, 28 Jul 2026 18:03:22 +0200
Message-ID: <20260728160322.2773915-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mac80211 removes a sta, it calls .sta_state() which in turn calls
ath11k_mac_station_remove(). In that function we clean up both  peers &
arsta related resources.

But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
assumes that all driver related resources are cleanup up beforehand. This
cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
in fact free arsta->rx_stats / tx_stats.

So lets extract the arsta cleanup from ath11k_mac_station_remove() into a
new ath11k_mac_station_cleanup() and call it from both there and
ath11k_mac_peer_cleanup_all().

This should handle kmemleaks reports like:
	unreferenced object 0xffffff801ae66400 (size 1024):
	  comm "hostapd", pid 1306, jiffies 4295011565
	  hex dump (first 32 bytes):
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace (crc d61c08ec):
	    kmemleak_alloc+0x3c/0x50
	    __kmalloc_cache_noprof+0x2b0/0x3e0
	    ath11k_mac_op_sta_state+0x1dc/0xb10
	    drv_sta_state+0xac/0x6f8
	    sta_info_insert_rcu+0x314/0x5e0
	    sta_info_insert+0x14/0x38
	    ieee80211_add_station+0x10c/0x1a0
	    nl80211_new_station+0x3e8/0x680
	    genl_family_rcv_msg_doit+0xc0/0x120
	    genl_rcv_msg+0x1b4/0x258
	    netlink_rcv_skb+0x4c/0x108
	    genl_rcv+0x38/0x60
	    netlink_unicast+0x190/0x278
	    netlink_sendmsg+0x15c/0x370
	    ____sys_sendmsg+0x120/0x290
	    ___sys_sendmsg+0x70/0xa0

Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: 9d5f28c1366f ("wifi: ath11k: fix connection failure due to unexpected peer delete")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
 Note the problem this is in fact older that the referenced commit, but as
 it would need another patch to backport to older kernel and the leak is
 quite minimal & seldom happens, I was hopping to not have to do it.
---
 drivers/net/wireless/ath/ath11k/mac.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..ae91b57c8422 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -873,6 +873,22 @@ static int ath11k_mac_set_kickout(struct ath11k_vif *arvif)
 	return 0;
 }
 
+static void ath11k_mac_station_cleanup(struct ieee80211_sta *sta)
+{
+	struct ath11k_sta *arsta;
+
+	if (!sta)
+		return;
+
+	arsta = ath11k_sta_to_arsta(sta);
+
+	kfree(arsta->tx_stats);
+	arsta->tx_stats = NULL;
+
+	kfree(arsta->rx_stats);
+	arsta->rx_stats = NULL;
+}
+
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
 {
 	struct ath11k_peer *peer, *tmp;
@@ -885,6 +901,7 @@ void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
 	list_for_each_entry_safe(peer, tmp, &ab->peers, list) {
 		ath11k_peer_rx_tid_cleanup(ar, peer);
 		ath11k_peer_rhash_delete(ab, peer);
+		ath11k_mac_station_cleanup(peer->sta);
 		list_del(&peer->list);
 		kfree(peer);
 	}
@@ -9892,7 +9909,6 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
 {
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
-	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
 	int ret;
 
 	if (ab->hw_params.vdev_start_delay &&
@@ -9916,12 +9932,7 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
 			   sta->addr, arvif->vdev_id);
 
 	ath11k_mac_dec_num_stations(arvif, sta);
-
-	kfree(arsta->tx_stats);
-	arsta->tx_stats = NULL;
-
-	kfree(arsta->rx_stats);
-	arsta->rx_stats = NULL;
+	ath11k_mac_station_cleanup(sta);
 
 	return ret;
 }
-- 
2.55.0

