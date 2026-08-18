Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718C19B5A3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059596; cv=none; b=cWvlyZ43/gS4rLTxT0j0LlXTRxycpad1Myxk45+jYj7S94ZadH1aiDUTRjg5VEazMfNuYkdzkBvs0ZQgIPvxlTgfwHm6xInC2bKsShOsaCbc9rAZU7MawNNiU00nBbndB3jj0x574YRfNLJlVp2mzV9xTb04GCAiXLJTf81vIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059596; c=relaxed/simple;
	bh=6Fl1wIU4U/rKXdb2Fc4vogB4NQpLilj+tG1m91XbSSw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHY5ts0yQX0NsFvEmA7U7hv/XfgaxQKNW2ZV7MmCxxAjUbx6Po62soFbfmlq3dXtY6qPTRCYbekgt1M99jsN0CjyNmko28KQak8dfRTrY+ojcCL1w7wGIe02Kz3kRGwbCZVfYVIR2pWL3L4dkj2BYT+du4NjiSSO29Cyzk9U5WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Bsa/nJGQ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Bsa/nJGQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wyBEc/iZ8tmRiDs//Zs31Q0lfy9NroKkJo0yUaDS87s=; b=Bsa/nJGQypvVsKpPU8Y3suF50U
	PXd4rKt1NQm40VibhK07HO0gsFdsZ8fPwYvh/B7iauEeBG7OFEREWJaVvJPpFFmXrf8L7Ascl6ZGt
	l1cW2hApeavT0zSkoNL5MearJwV0k6Am0qbVKg+D+ie3jY82putz0F2PuV5CNYP9KwuM=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wwJOd-002b0i-3C
	for linux-wireless@vger.kernel.org;
	Tue, 18 Aug 2026 14:58:28 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 4/5] wifi: mt76: clear offchannel state if a scan has no channel to restore
Date: Tue, 18 Aug 2026 12:58:24 +0000
Message-ID: <20260818125825.395538-4-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818125825.395538-1-nbd@nbd.name>
References: <20260818125825.395538-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_scan_complete() restores the operating channel only if the phy has one.
__mt76_set_channel() is the only function that clears phy->offchannel.
A phy can run a scan while it has no operating channel. A 6 GHz radio with
no configured interface is one example. After such a scan, the flag stays
set.

mt76_txq_schedule_list() skips each TXQ whose wcid points to a phy in this
state. All traffic for the stations on that band stops. The frames stay in
the mac80211 queues. They do not reach the hardware, and no counter shows
them. Only an unrelated channel set clears the flag.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 ++
 drivers/net/wireless/mediatek/mt76/scan.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 1d2635672ac3..903f3a420e4c 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -330,6 +330,8 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 		mt76_offchannel_notify(phy, false);
+	} else {
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 3594b599662d..c8c4d096c809 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -29,6 +29,13 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 		if (offchannel)
 			mt76_offchannel_notify(phy, false);
+	} else {
+		/* A phy that has no operating channel has nothing to restore,
+		 * but the flag also gates the TX queues of every station whose
+		 * wcid points at this band, so leaving it set stalls them until
+		 * something else happens to set a channel.
+		 */
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-- 
2.53.0

