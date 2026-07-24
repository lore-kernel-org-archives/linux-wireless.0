Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28F942D75B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=fI5Cx825Opn8A2cAx+DuToiWooe17mC89eyX7DcWmkQ0HWKKxXHa6szuygFvH8aK26PeY2d8KxY7dgnFiEP4WxuVhcl5afJ/N8L69Q4MJCa1tBkTwE2TYfhJtE1//0W7KVeWALhViG8o+Ctc+0tnf4pblYgGcNowv4l47uRnrrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=rPMnX5bIB8rNeEQZdYE0FK1TBubOms75zYsswT59XS0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTWydYgb7LvScci5FEApSqpkMRjHQkxW58Na7uGcki33GCJb+siL/9cmfxJanqWxUCsvvphNti0NZi2I5yGDaIvUcHHCD+Oa0zUVokmf7IWzhOk6X227wTqKZiqdSK5eyG8xY3ruwd4SzvdOmIUr/AYmTPE7jvlHGPkGqrEctL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=f+2y5F3p; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="f+2y5F3p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TSC07gfhSw5v5x3lstWHxtk0Y+HvkJ8ZD9HHFNra+PE=; b=f+2y5F3p7HBLZmMY3ZZX/kssOf
	X9+88HPF3e7A6/dUcZ6+n2DJt/mQueAV4iRCiLW6F/+2p+sn0opceg9QGj2evcUkaKF8E7MqhjU08
	pqBTtFKYh51YXTpS1bvBFBDD0m6qiF8npWtYxUda3ZATucNpjqo+pnJ9jj05ajYYoMBc=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK7-006LeO-0a
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:19 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 21/29] wifi: mt76: mt7996: select net_setup_tc handler at runtime
Date: Fri, 24 Jul 2026 12:48:05 +0000
Message-ID: <20260724124813.3961474-21-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chad Monroe <chad@monroe.io>

The net_setup_tc callback is chosen at compile time and the WED
handler shadows the NPU one when CONFIG_NET_MEDIATEK_SOC_WED is
enabled. mt76_wed_net_setup_tc() returns -EOPNOTSUPP without an
active WED device, so on boards using the Airoha NPU with a WED
enabled kernel the tc offload block is never bound and PPE flow
offload for wireless traffic is silently disabled.

Dispatch on the active offload backend instead: use the WED handler
when a WED device is attached and fall back to the NPU handler
otherwise. Builds without MT76_NPU keep the old behavior through the
mt76_npu_net_setup_tc() stub.

Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f436109ac0a8..ce7aede6201e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2443,6 +2443,23 @@ mt7996_net_fill_forward_path(struct ieee80211_hw *hw,
 	return 0;
 }
 
+#if defined(CONFIG_NET_MEDIATEK_SOC_WED) || defined(CONFIG_MT7996_NPU)
+static int
+mt7996_net_setup_tc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    struct net_device *netdev, enum tc_setup_type type,
+		    void *type_data)
+{
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
+		return mt76_wed_net_setup_tc(hw, vif, netdev, type,
+					     type_data);
+#endif
+	return mt76_npu_net_setup_tc(hw, vif, netdev, type, type_data);
+}
+#endif
+
 static int
 mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u16 old_links, u16 new_links,
@@ -2570,10 +2587,8 @@ const struct ieee80211_ops mt7996_ops = {
 #endif
 	.set_radar_background = mt7996_set_radar_background,
 	.net_fill_forward_path = mt7996_net_fill_forward_path,
-#ifdef CONFIG_NET_MEDIATEK_SOC_WED
-	.net_setup_tc = mt76_wed_net_setup_tc,
-#elif defined(CONFIG_MT7996_NPU)
-	.net_setup_tc = mt76_npu_net_setup_tc,
+#if defined(CONFIG_NET_MEDIATEK_SOC_WED) || defined(CONFIG_MT7996_NPU)
+	.net_setup_tc = mt7996_net_setup_tc,
 #endif
 	.change_vif_links = mt7996_change_vif_links,
 	.change_sta_links = mt7996_mac_sta_change_links,
-- 
2.53.0

