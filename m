Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190262;
	b=ra9tjnm5Sy7XJ5ROtVBfrhJ6WIQoPLCX/+d39N4JrzljF8JSs5fcMn3lEyZU8Fn1lv+t
	 MYtpKWYiQRjwyptFL926XkGgKhaERHtIK5018eEFkEX8MVM6EOOnPWIYD/5OsueyWCfxF
	 WvTYIEhAe+O1VK5gw5WXwEdC+Oq+NZ/hciffx0hmlHhHZR1ulNVDHFmnNbAKRLFibYNtn
	 AAvXDAx8jAQ9gKktonlC8vuvM4e5AWSCyjIA4H9+OkMypezK226IhrG1U3lQ38RrOy5zV
	 tABUuMVNaD+YEecChVuhgwlCPrt+0BEy1Rcm+rWZUneLR7RFjDk7u0ZtO3HW+hwfDag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190262;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K5vpZoULNWPY0nNXF2bwgd0LIfCV2zRfwk1BzTyIMeU=;
	b=a/BiaTC14Aea+BiLl3fCA/YqMoKXCCVwyFrWZ/iJ+fE4rs5XntVMfTq1LIW7ElzORXJn
	 +qDgBcMpkr2Rt64GNudYnfUU0W0Zlilksb8yR4sVNkJ2l/6MzpatoY69Z9Y1aK3Ob7rUd
	 dc23qJK0RucxHyhlqAs4SW3QEMNUDn7ATlSkzmB9/8Y56d5LKCmO9/UQHsyoib3t+RQud
	 Z6n7kgpL67tktnkLVhUmdRjEUUWOSj5S2cNKD0pC2Z5X1sjMJS6ozI5+B0z50gGW0cgvC
	 1mFW7Iark6fKFygUOlgxvzFkFuXuuz3asO+jD+8Ms0RYA/WfzncxgOQ0zsl5QQFZpJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="qCZq/FAy";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B48360A2610
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B48360A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qCZq/FAy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K5vpZoULNWPY0nNXF2bwgd0LIfCV2zRfwk1BzTyIMeU=; b=qCZq/FAyddKqyLI7x2Z592PVuj
	39v+AU0OPlRFqnlbSGgOqWjGS+qmJZsJzR39j0lR3e1O/N9//sK/z6BCmN4p7F/GvldwILXLqIJtD
	NQmWsCzJpNhQdyzW/rYWUmXfq0SKtRvCgYH8+AXHdVxKbDK/4O8vH+2qUVKPh/BhaDv8=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-14
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 19/25] wifi: mt76: restart the beacon monitor of a link that gets a chanctx again
Date: Wed, 28 Oct 2026 13:23:57 +0100
Message-ID: <20261028122403.796394-19-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_vif_link_remove() keeps a station link when its chanctx is
unassigned, for example when mac80211 deactivates the link. The link
keeps its beacon_mon_interval and the beacon_mon_last of its last
beacon. When the link is activated again, mt7996_vif_link_add() takes
the reuse branch, which does not touch the beacon monitor. Unless a
beacon on that link arrives first, the next mt76_beacon_mon_check()
reports a beacon loss for the stale timestamp, and the station
disconnects:

  sta-mld0: CTRL-EVENT-BEACON-LOSS
  sta-mld0: CTRL-EVENT-DISCONNECTED bssid=a0:ad:9f:70:fb:4a reason=4 locally_generated=1

Reset beacon_mon_last whenever a link gets a chanctx, which
mt76_switch_vif_chanctx() already did after a channel switch. Do it
before the link points to the chanctx, since mt76_beacon_mon_check()
runs without dev->mutex and can see the link while vif_link_add() waits
for the firmware.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 --
 drivers/net/wireless/mediatek/mt76/mt76.h    | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index a44773b9a49e..da111d37c4f5 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -258,8 +258,6 @@ int mt76_switch_vif_chanctx(struct ieee80211_hw *hw,
 		}
 
 		mt76_vif_link_ctx_set(mlink, v->new_ctx);
-		if (mlink->beacon_mon_interval)
-			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 	}
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 42a1f84c5ca9..fb1b99f56e9c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2171,6 +2171,9 @@ static inline void
 mt76_vif_link_ctx_set(struct mt76_vif_link *mlink,
 		      struct ieee80211_chanctx_conf *conf)
 {
+	if (conf && mlink->beacon_mon_interval)
+		WRITE_ONCE(mlink->beacon_mon_last, jiffies);
+
 	/* pairs with smp_load_acquire() in mt76_vif_link_phy() */
 	smp_store_release(&mlink->ctx, conf);
 }
-- 
2.47.3

