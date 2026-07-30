Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FF8368291
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785420157; cv=none; b=OVI2CcIXUEWTSt8HaF7UQs/V3aCYT3tAkeU4RLmqk14MPmEqPFxzUs/DX7V6HOLRQcfaUDg2MYNVbQiwaFx3lA54ix0n/ab/OEBh/5l+xd9zBVmNEM+bgMyYQdtfnUlC1ax+6btAen4vd2styVAppUTi0ITWVrDITPbhIES7rhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785420157; c=relaxed/simple;
	bh=sn1xQmi2P+vO5J6vGYpFn/FyigZ1jFZImmcpkoK+rm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k3NCn1TQcrWqPQuRqOwDQtJHU6CYsepvDLAA5rM4bMYYheHf9JMHmM4pENVqSUO94SJxXcLHxdpw4MRx7mpnkkS/5DsjShymiqqGSgwYKXQvLkyJDIMOl/GQpsaKaukRNhu987Go3tX7BeKUi7RTK50eyP2BiIEGjup52q/3p/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4ObzGI8; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4ObzGI8"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso1425360f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785420154; x=1786024954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVONJagphCYgvWyOuOSu9ImQNoUm/arR9Ke6F2TkUIk=;
        b=l4ObzGI8Tr3JIx+FoL2P8opRyM3nIcTbqs5vRQjBh7KwZwWe2o6ouFp5tIhnhQ8QiU
         3Kfp64+i4ZVaU54xgxcP1PbMp50iTwbff1ihPRM67mwiNhIqOH8rNKp2DhmBZHBnpC1+
         zlWGoWkBwO/0L+8ZybkwAPLvEeOst/FnwSbYvkIp8vItClWfIqphPj+ywGU8jSY38Ayj
         yWO2RRgkDVM14nbtQprF+Unu3FyE9DHGH/5XgM25WdbH06eZvY5W2UewGCMqor+8Gn5s
         1KIGCdc4WrFzOM2nKuProA+1WWj2DsmmeW4VHp0WSMnTa7NP8i04qRylIYaLmgveyq3o
         J+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785420154; x=1786024954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVONJagphCYgvWyOuOSu9ImQNoUm/arR9Ke6F2TkUIk=;
        b=FEZsTpxugufWDGFWcBYH/vhYlWPhyNeS4D/RLlQ+8gRB3iQnPSq+Mmj48hezwVweNM
         VssSIXlFJCdmYAE26eDYMToSTCzxaBVwidQ1e1T2/qBZWMTUeBwUokzQC2th1UiKEjhm
         0igqQ0GaDji3nIECB55+dfyiNrfG7Q5z4kB6YCVA0cwnNMLTXNgbcO0uazy9PV0fIuir
         UN4+Il+3y5w2EEpu5a0Wxv4XTzYq71xa7Bj1X05rOeNAj9nX2LA92hxUHLKPcLb47To0
         bJcWxRLKvl7RlmJZ0hRbA07qT/d/Dl5WHn/T5k1KnE+mlgs+2Rx0YMp6Lwh+TNMqSVvE
         MhKA==
X-Gm-Message-State: AOJu0Yz+oZYseBfwJQ/pmvkDdcqnbaUUgOrPJ1aAku7F10o2mRKQbsY+
	p1eqqwlRBVoG4r7hIauNJdbxTe88X2CVfStm2eWjn9zvaDDxC7a+2CX1
X-Gm-Gg: AR+sD11Mk4S6Fc3fdQrvvQx9P+Ovv0W8kNfWDgl+EzXi6AM+ze/sg1oAmCTP6Q7dVAg
	YdjuKeZs424GxMMVpjfpba/DWSydZ5AI06QqUBwp7etIX7lriYIU8JKegMstH0vQzjx7Kh9nW15
	JZqskoftiwNySo/BF9NlVKXoaVyo9EoqLGTDLYM8O1xstkIKj5M/uJokqg4MNbmv3NnLCumeos8
	d0alw75+L8k7I/ieyum0nqS+h9GS80fK7X6f5T+IBGrYXw8ePxOqyvCIarlUU4v48/4xRjhuWC3
	/RV7JtI20vveEvMIvhf1Q+iNqkhietD1p4t6iB1LU0j+so4jkep88H03Z/ydRxtPlU+IUf/1T2p
	Nuqrvn+rm3kA6HfbDQhcbsfPjepc3k3vzjzBzEIXcDFm7wYtc2vZejsP1BNo9BGR7pphPVM/dEm
	fJKjHLaoRJ/zc8+14Lp1HjGDUBqxDzahXNoUeMzgF4WdLNGOSADWeXWIe+DoB2LtNUPP8l+mLjg
	t0hOLau4kNulGK0PHU2pg==
X-Received: by 2002:a5d:5f55:0:b0:47f:873a:6ae7 with SMTP id ffacd0b85a97d-47fc81fbfa7mr3928041f8f.41.1785420153485;
        Thu, 30 Jul 2026 07:02:33 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88e3c73sm6973351f8f.10.2026.07.30.07.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:02:33 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-current v2] wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()
Date: Thu, 30 Jul 2026 16:02:32 +0200
Message-ID: <20260730140232.133500-1-nico.escande@gmail.com>
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
 Note: this problem is in fact older that the referenced commit, but as
 it would need another patch to backport to older kernel and the leak is
 quite minimal & seldom happens, I was hopping to not have to do it.

v2:
	- rebased on ath/master
	- no code change
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

