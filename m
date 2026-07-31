Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47390221D96
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509914; cv=none; b=eH6Uwrkx44+LpjpwhvgoxgSDPrQeTE6fZpmuG8ZBkWMCgCdJh07zJM+BLPa/S4f4ynhAut5zcGDFcQdUSwKk4Dg1FYHv9FklcceOz9UhsIuKXydaoSxl2qoMsh5FUHtOU3dq+NfDU6g4uTc+DxZeAwGoFUioST6ujYDlPGV0MgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509914; c=relaxed/simple;
	bh=UEJSreDqe9iezmfULq/cN7ocz2yQdBaU1ssw8+geyzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DvHopMcPuRf9yU/4bzDMjNFMeqGZdsmVKUS1QHbZczBmEYyvZyCwk+swfyf+8ikF9MzuBzgwq5M8rI7usQVoF2cnVOgBTfb4Yx1iMeGUB+7GpQ2kN5OA+/unn4cD3pavzaRDPpbdKpI5a1DQuKPXCfn/quk1/WE6aRJTKgyzzio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qRR2fXHv; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qRR2fXHv"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f752b3423so981102f8f.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785509911; x=1786114711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fOkuna8tbHEYxapex9XJjFmWsjd27rKeJXMC9tHNkGk=;
        b=qRR2fXHvxd4VH+qOwUwlDAvi0WdReiIfnHjKR7yu/2KJBoZ1Bk+0jEqVYdcvQRnzgd
         6iG8HxDHpT/aNPP8pEBuUFcBwf9se+hahxie9FKTj+y1E8FAIv5+nsFLPSepocwfL18C
         hrkfp7rvChkl0XOzloAFlnYqjiyF/bGC/YU2HHW5Tl/Swt0s0q/BcfsaIVH1DCAVEOmw
         OHGgBiNbR/abSz7AOWLKNuMMtWwuyTL7xljNdfVnt5xqvVPqkeOo60+Xne+dma0yvMsW
         6XR/J8agxmyTcjo3tZxowM4go/fXUyN3C/EK25H34LKLhMLWHnEnjGhmWRvDVCbKEjgp
         RMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785509911; x=1786114711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fOkuna8tbHEYxapex9XJjFmWsjd27rKeJXMC9tHNkGk=;
        b=IhgFD0X7Nm6248ua6co3Z0C3DcAiqUjjhZMujNGFubm6eL5a8GYoUDeq43jI58RufM
         oxCa+Z5Q+UzNU0Ek80MdyGuWS81ekZK8l6J9gpn11358A0F2u3e3unKOsJ+EH+TwIucs
         gaBEou6LYHQQUed7NCouO10abLhNaVyzf2rph3Ygvl21MX1/l4UG/11zztnY0URLD57c
         i84xZcRlviakB2WneHIyIX0m3i5i2vEp3vqFgIuWFxrotD9tIXR3kB7ycOJSrvRh4i3W
         sih5af1k/1+lSl9dBy2RI/KHBmMTBSBi8w1ZgPy5GCZ0OyDPTpVDjEMBeqtSzsokB722
         EWwg==
X-Gm-Message-State: AOJu0YzwC0wMH+/HiS7WtrqGnWef2R1qJZ8s9o/GajOHBYASplLkiRBy
	mfWw/bSoEJOUorFzrpT4sNDRVYoof983bFjnfIXnZ0UL8/cSG3C3b696
X-Gm-Gg: AR+sD13S6AY3Xp9MhTUqxmVPx7GHJk0QrTfLEFTxftFlhDRe/yR0YzKWweaiUKTilXe
	lPW5y7NmwFdKk0Fe4oIvT3SEd9H7/PvEFUao8WzLhdRDWQ3qX1wJ3lF3opvSd5h+oZAqaZRHwCY
	LoTRXTBHY2UMwsz2/9Q296wpRfCWvpe+UnSQxUjKh6bfbHhICu1IlJkmf3WOUWWsC/ppYVw2yqk
	+XyiofkVbKHuLkspyA2AMRXsdjhKnL82Ap2i4IywwN5XjceuX1Sw+LZTFHIG/4Dil670oSIYLeE
	GJj3eUMM0OHRoGw7gbDVCBvPeFVTJVgln+vCnG+ZvjMq1i59Rqm2Hd2i9bzIkMkBJdVJ5Jp9cvY
	Y8uV8YHBZ2KGHN+11QCxYc5g5WAZAOE8a3o5p/KgQSeqU2mKJVeVlbWMdbAT9Qra9XbiTHyQMcR
	17p/JG9pCt0nEOlZ/ZpGNQGIDbvCCcHbIItogSHE7YHlBipBGkIA5XxYAVMiCPB9h2joQkXoSQx
	36d4hLPfIWSA6czMGmg5A==
X-Received: by 2002:a05:6000:2f84:b0:47f:9ac6:ca60 with SMTP id ffacd0b85a97d-47fd726220emr53142f8f.0.1785509911380;
        Fri, 31 Jul 2026 07:58:31 -0700 (PDT)
Received: from syracuse.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cf404sm5881665f8f.1.2026.07.31.07.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 07:58:30 -0700 (PDT)
From: Nicolas Escande <nico.escande@gmail.com>
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-current v3] wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()
Date: Fri, 31 Jul 2026 16:58:30 +0200
Message-ID: <20260731145830.769811-1-nico.escande@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mac80211 removes a sta, it calls .sta_state() which in turn calls
ath11k_mac_station_remove(). In that function we clean up both peers &
arsta related resources.

But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
assumes that all driver related resources are cleaned up beforehand. This
cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
in fact free arsta->rx_stats / tx_stats.

This extract the arsta cleanup from ath11k_mac_station_remove() into a
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

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
---
v3:
	- changed the fixes to the first one that introduced the issue
	- addressed the commit message nits from review
	- fixed the Tested-on to include hw version
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

