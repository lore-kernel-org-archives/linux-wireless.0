Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570FD33DEFD
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=ciD3/0a6vcbIeoU5KQmBCRJRRDEvysAtcLapXGLXVCL85KKu606z+ynJsrXFzeeQVPqYJzwCYYiiO9ZD4w8VgvzWHaeiEMMFeX6HhttH63kIzF4nZcSKhIitUQY6HcBv7TrjdfEJ228Yi7JELXFtf6dDon/T09Vkq57xem3ewiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=GqTHq5S5FSiUkCllPpp8mR53yGoxf4Hfz+clxEHY9tk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0NQ+nMUawgyQMdw5yVBL9tGUs8Rg6w1yobMxI0+sjog6QLQ7+JHMuYD97lhpa9I+AjJ4+FACQYHHzLW3m3hx7hH0nRsjDAlvXwTOtkyYrm53v9tS+5VOvtzezkLxjQYP5v1OBQ5+kI9cLyw+UJQRxjdFu/mXbbbRLGXpW0vmac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=SgcB89x1; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="SgcB89x1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sPZ+/xPF5TaC5NdEGddxvNz7QjTGsFz0KhFzwvOcmQ4=; b=SgcB89x10tAH/q0FIQsR8+YsI3
	EGokvtbyCU9wkA+ReJxTUI2MZ75zQr1lAVxkjFyC5XnREpCO+kWpjPSOncuNyJtPyHJGgUZ7QDD/o
	2QVuiHMwuIWfiQKg4OdYDnHItv/e6lRi6OwRQcYMKwazRF7PZ0drv1q5ESPTQ+6MJpCc=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-1i
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 13/15] wifi: mt76: mt7915: update SKU power limits after changing antennas
Date: Mon, 27 Jul 2026 15:04:32 +0000
Message-ID: <20260727150434.1778520-13-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changing the antenna configuration updates the stream capabilities but
left the per-path SKU power limits and path delta compensation stale
until the next channel switch. Reapply the SKU table like mt7996
already does.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4783e5f52d22..a8286f8becf9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1158,6 +1158,7 @@ mt7915_set_antenna(struct ieee80211_hw *hw, int radio_idx, u32 tx_ant, u32 rx_an
 	mt76_set_stream_caps(phy->mt76, true);
 	mt7915_set_stream_vht_txbf_caps(phy);
 	mt7915_set_stream_he_caps(phy);
+	mt7915_mcu_set_txpower_sku(phy);
 
 	mutex_unlock(&dev->mt76.mutex);
 
-- 
2.53.0

