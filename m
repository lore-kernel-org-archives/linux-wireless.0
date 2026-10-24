Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=N8v/S+dScjCSn3W9fNIUXdOReT7lO834zxSInLAWY40eTsvCE2QsfihtS647SxrtuOc4
	 9N9C23qOzKgntl9Rl7jPWNue731hdS39icbKNMH8Uojx24FpH3CKwvuAOWdGRZfv437rZ
	 P98mABQL7PsQsosMtcEKb1/5cRsjCGiAQX47rHiIZkxHYbnuPtMDCxeSSyVfO8FRpSsll
	 ZciKHVTLItTR/crExoXbnA3b2eX4UlI+OKPlsMdBl1EZ4P1q2l7A8PMUcQDgZSxPI6kWD
	 YrNBx9IO/aZneuPQv0qRzDAfR/b27jgqV2/l7QacrKXGDJUEbK236HSB5pJfo+SXCiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4B7oaP1RVVGVXOEDPXwEDbbk2AY+Ysrca/c7jsrZ8js=;
	b=Gi2zj7ljYHYHBz9pUe0Jvp347Rgp6T64SvefSeVcVg1Qlg+Sy+7JWlM05cxjmgxF1Mlq
	 XLo2KOHGeImmscLF1/a/XzlxdaCleTOtx3PC6b6QwpSWqTj97fiUBK0xBxDBgWGousK7Q
	 WUdIjpPnAy/8wv49acIxhWrsjOm/rohJZHewKBdTuEJIlxYBvnhWjQ+tKi4FHfAcsVqP9
	 y3MShoyO6Xc4wLM1Ic5YKI7mAoqq4Mj+B+gnvi/JWPdYG41FhSbFGa1RTpkqChKQV86Fc
	 cr2Gme+PJcI7MDyD1jef2VTwWG9c3o4s/ebxD+3NOAQGKbRS4HFvOX2OlF5cR833wUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CQEr+gpM;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62983606A31F
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62983606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CQEr+gpM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4B7oaP1RVVGVXOEDPXwEDbbk2AY+Ysrca/c7jsrZ8js=; b=CQEr+gpMQGo2nxulQ3ijCK+xC6
	cWR9J4vrIiZ692u1HanneLgbnfk4gD8Jyc040QMnGwC+Ry40SRbUqUIrGtZd8m685hQ+1OYZCwBjn
	aESe5e53F33H8+hPHCbE2508eqWf8CVEdQdZQgRimykmX2DzZXI1LatmARFEiOxeLOYQ=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-2g
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 05/11] wifi: mt76: mt7996: validate radar, thermal and WED RRO event lengths
Date: Sat, 24 Oct 2026 09:19:21 +0200
Message-ID: <20261024071927.2279668-5-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024071927.2279668-1-nbd@nbd.name>
References: <20261024071927.2279668-1-nbd@nbd.name>
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

mt7996_mcu_rx_event() only guarantees the receive descriptor fields
used for dispatch. mt7996_mcu_rx_radar_detected(),
mt7996_mcu_rx_thermal_notify() and mt7996_mcu_wed_rro_event() then read
event fields after the descriptor without checking the event length. A
truncated event causes an out-of-bounds read.

Ignore events too short for the fields the handler reads, like the
other unsolicited event handlers do.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: 21f290884bc1 ("wifi: mt76: connac: add thermal protection support for mt7996")
Fixes: a5d028d66836 ("wifi: mt76: mt7996: add wed rro delete session garbage collector")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 9037520183f4..590931207d79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -544,6 +544,9 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt7996_mcu_rdd_report *r;
 
+	if (skb->len < offsetofend(struct mt7996_mcu_rdd_report, rdd_idx))
+		return;
+
 	r = (struct mt7996_mcu_rdd_report *)skb->data;
 
 	switch (r->rdd_idx) {
@@ -763,6 +766,10 @@ mt7996_mcu_rx_thermal_notify(struct mt7996_dev *dev, struct sk_buff *skb)
 	struct mt7996_mcu_thermal_notify *n;
 	struct mt7996_phy *phy;
 
+	if (skb->len < offsetofend(struct mt7996_mcu_thermal_notify,
+				   duty_percent))
+		return;
+
 	n = (struct mt7996_mcu_thermal_notify *)skb->data;
 
 	if (le16_to_cpu(n->tag) != THERMAL_NOTIFY_TAG)
@@ -819,7 +826,7 @@ mt7996_mcu_wed_rro_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
 	struct mt7996_mcu_wed_rro_event *event = (void *)skb->data;
 
-	if (!mt7996_has_hwrro(dev))
+	if (!mt7996_has_hwrro(dev) || skb->len < sizeof(*event))
 		return;
 
 	skb_pull(skb, sizeof(struct mt7996_mcu_rxd) + 4);
-- 
2.47.3

