Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD25C46E007
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320389; cv=none; b=Ks6Km98//OKAeb8VhE/c4kdP/8iZsl7oSPbuYWN9Q5d2KIO/bz9hPZHzS19Tz3MY/8pvqe+utvWDwOQaPh8g2e/Oj4n19SBpAwBafkbmR5v8cPvpbkzSXWIoYln5Q65hDcKJiTAlM8pSVeX/a5N2/R2mD62C/9nCVj77wHZqlR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320389; c=relaxed/simple;
	bh=Rikyxy+b4Zsektk4+C2B9bMEUYNI7N/qxmZtB42Fnbk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATplkYjRIxrj3uLHhZZ5/Fp8QyEWwiNc3Kdqcz/Dnk1qNUUrVk91r8D081WbS5yoQGygtjTBpx6OXjUVuU2K9H0EyhM/Cj1uibV+ivsuW9KLLcLpfedmP/XMYW4roF9/EUl5UshWu2EhXGQm1IgfzLmZpYUTC2rTHVJ2CKj/18Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=gUx0rEIt; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="gUx0rEIt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1PRoGXAbREfvUhX8UgQKk7ddkKUKHIXNdZzwp/OFRqk=; b=gUx0rEIt98WoZhlTfROLGLe3Kq
	klNSGav3YLcKLolxrX4eZUqcHEsLyhsXQSa7ZJTY4FWoRv7wTes7YB5+1wrJdbsG7xsETWcLhdK75
	fo2DSnlfhpwIf3JC0SBTTkp2IdAhIq4Flsn8VODAAVlBRd62ettQfXcMTp7KIvLAwry8=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGF-00HAg3-11
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 23/27] wifi: mt76: mt7996: set up block ack sessions on station links added later
Date: Tue,  6 Oct 2026 22:59:32 +0200
Message-ID: <20261006205936.669125-23-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_ampdu_action() sends STA_REC_BA to the links that the station
has when mac80211 starts a session. A link that is brought up later
gets no STA_REC_BA, so it transmits without aggregation and, as a
recipient, is not set up for hardware reordering. mac80211 does not
start the sessions again when a link is added.

Send STA_REC_BA for each running TX and RX session on the links that
mt7996_mac_sta_change_links() brings up. For an RX session, use the
current head of the reorder window, which mt76_rx_aggr_start() keeps
on the default link, as the starting sequence number.

That head moves only when the host reorders: with hardware RRO, mt7996
marks the frames as already aggregated and mt7996_mac_fill_rx() skips
the host reorder state; with WED or the NPU active,
mt76_rx_poll_complete() does not call mt76_rx_aggr_reorder(). The
driver has no MCU query for the current window. In those modes, stop
the RX sessions with ieee80211_stop_rx_ba_session() instead, so that
the originator sets up new sessions, which then reach all links through
the regular IEEE80211_AMPDU_RX_START path.

Fixes: ef3f5941e560 ("wifi: mt76: mt7996: rework mt7996_ampdu_action to support MLO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 81 ++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 324d3b195a3f..89e9ef855a78 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1614,6 +1614,85 @@ mt7996_mac_sta_links_set_keys(struct mt7996_dev *dev,
 	}
 }
 
+static bool
+mt7996_rx_reorder_host(struct mt7996_dev *dev)
+{
+	return !mt7996_has_hwrro(dev) &&
+	       !mtk_wed_device_active(&dev->mt76.mmio.wed) &&
+	       !mt76_npu_device_active(&dev->mt76);
+}
+
+static u16
+mt7996_mac_sta_ba_rx_ssn(struct mt7996_dev *dev, struct mt7996_sta *msta,
+			 unsigned int tid)
+{
+	struct mt76_rx_tid *tid_rx;
+	u16 ssn;
+
+	tid_rx = mt76_dereference(msta->deflink.wcid.aggr[tid], &dev->mt76);
+	if (!tid_rx)
+		return msta->ba_rx[tid].ssn;
+
+	spin_lock_bh(&tid_rx->lock);
+	ssn = tid_rx->head;
+	spin_unlock_bh(&tid_rx->lock);
+
+	return ssn;
+}
+
+static int
+mt7996_mac_sta_links_ba_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, unsigned long links)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	u16 rx_restart = 0;
+	unsigned int tid;
+	int err;
+
+	if (!links)
+		return 0;
+
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
+		struct ieee80211_ampdu_params params = {
+			.sta = sta,
+			.tid = tid,
+		};
+
+		if (msta->ba_tx_mask & BIT(tid)) {
+			params.ssn = msta->ba_tx[tid].ssn;
+			params.buf_size = msta->ba_tx[tid].buf_size;
+			params.amsdu = msta->ba_tx[tid].amsdu;
+			err = mt7996_mcu_add_tx_ba(dev, &params, vif, links,
+						   true);
+			if (err)
+				return err;
+		}
+
+		if (!(msta->ba_rx_mask & BIT(tid)))
+			continue;
+
+		/* without host reordering, the reorder head stays at the
+		 * session start, so have the originator set up a new session
+		 */
+		if (!mt7996_rx_reorder_host(dev)) {
+			rx_restart |= BIT(tid);
+			continue;
+		}
+
+		params.ssn = mt7996_mac_sta_ba_rx_ssn(dev, msta, tid);
+		params.buf_size = msta->ba_rx[tid].buf_size;
+		params.amsdu = msta->ba_rx[tid].amsdu;
+		err = mt7996_mcu_add_rx_ba(dev, &params, vif, links, true);
+		if (err)
+			return err;
+	}
+
+	if (rx_restart)
+		ieee80211_stop_rx_ba_session(vif, rx_restart, sta->addr);
+
+	return 0;
+}
+
 static int
 mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta, unsigned long links,
@@ -1672,7 +1751,7 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			return err;
 	}
 
-	return 0;
+	return mt7996_mac_sta_links_ba_add(dev, vif, sta, new_links);
 }
 
 static void
-- 
2.47.3

