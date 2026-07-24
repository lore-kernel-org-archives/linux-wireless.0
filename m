Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AAD4334C0
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897305; cv=none; b=YQaJRyHtXupCjBgD1yrsd4JpVPF/0VJ/ybVrPMpLnpzbpH+MtH5i+kwPsD1m+GoUVzOzI6AaIWXy2bMTP7D07FdfYAz9EUkxxuKQYTvnl6F7hPFTGhY9eFwlqztclRQ3WbICd0k45OiTdBHJvzBy5tlWDiu7jWZ+eGBJPzo6l1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897305; c=relaxed/simple;
	bh=N/prlXJb8iYiwH0x0/vT0MxEb1qlaPQJB/KPA0YrxTk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQWV86nUS6saHvnFXfaNQo0wCYyrYcTdPai/zwEn8nTBBzSd9BX3pj7lx2kTGomu4F4mRoY8jnNqew8CsF+IFSheRESUXxQe9wZHe/VZIPlDJAULwAvRrHN5VBfBn4071WqI+s6SFLQwGdEQX47XNNKCKzYp8erSslMhvPEAnnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=VZpuxTJd; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="VZpuxTJd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g70GMcEVKgW5LY1ZTG/2+PacJHNySek/l97g0db/08Y=; b=VZpuxTJdqalnGhszpPwPLYaTOa
	1qMom8+dRktPuj62iZ+ol71oVsvJEHuAjkxlnmmb3/f1wbmF46Mw6Lh+LrhQqWKUB6+edjgJIwroK
	c7Jh2CU0PQ0XXH4c8Cft1O5vAiSbwZUb1tpC8T2iYB8TZy8laJLfAsxJa73H6ZXA9osc=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-25
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 27/29] wifi: mt76: set MT76_SCANNING when starting a hw scan
Date: Fri, 24 Jul 2026 12:48:11 +0000
Message-ID: <20260724124813.3961474-27-nbd@nbd.name>
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

The scan state bit is cleared by mt76_scan_complete(), but nothing ever
sets it: mt76_sw_scan() is only called for drivers without hw scan
support. As a result, all MT76_SCANNING checks are inert for drivers
using mt76_hw_scan(), including the DFS state handling in
mt76_phy_dfs_state() and the guard against manually triggered radar
detection while scanning.

Set the bit when the scan request is accepted. Since every channel
programmed while scanning now evaluates the DFS state as disabled and
stops the radar detector, re-program the operating channel at scan
completion regardless of the off-channel state, after the scanning bit
has been cleared. Otherwise a scan whose last visited channel was the
operating channel, or one that returned to it early because of
associated stations, would leave radar detection stopped until the
next channel switch.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 325638d587c9..3cb11689d4bf 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -16,10 +16,17 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 
 	clear_bit(MT76_SCANNING, &phy->state);
 
-	if (dev->scan.chan && phy->main_chandef.chan && phy->offchannel &&
+	/* Re-program the operating channel even when the scan never left it:
+	 * any channel set during the scan ran with MT76_SCANNING held, which
+	 * left DFS radar detection disabled
+	 */
+	if (phy->main_chandef.chan &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+		bool offchannel = phy->offchannel;
+
 		mt76_set_channel(phy, &phy->main_chandef, false);
-		mt76_offchannel_notify(phy, false);
+		if (offchannel)
+			mt76_offchannel_notify(phy, false);
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
@@ -211,6 +218,7 @@ int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	dev->scan.vif = vif;
 	dev->scan.phy = phy;
 	dev->scan.mlink = mlink;
+	set_bit(MT76_SCANNING, &phy->state);
 	ieee80211_queue_delayed_work(dev->phy.hw, &dev->scan_work, 0);
 
 out:
-- 
2.53.0

