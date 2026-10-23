Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754014;
	b=UIHnGXi9epZEgjhtTWCSdpJVIbdCfKYb10WZGixhCA0Ox8MKvqEiCsuHm9dzK7iUnKKW
	 fAHkBXDX1bpa8atG+29uAIYPSaXbXPBTvWef6IXZyEIwsEQ1iE1EjkFWUkC/xcsAgcGQq
	 rHeaf24Pq28HeeSrXxq7VZ3uEt67R1sf33hURmBMaBNPkTrrV7F4pC36rZJiXtre/jqpE
	 3jYCt+rO0ihXHlsTHNFmwL8+FSJ/T+OxfT4KStoiXsTUDYGWaSNylhjhfXBRU+ByDtUig
	 ixh+9HbXtTawkdEawObF6OFnwU3htc4gqbo7i008IMAIcxqkLdMWQXVH5OR2ghpQUww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754014;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TQtrvrfvmC4T4Oydj/5Y5AiW/2WUKiaEyR/PboyfatY=;
	b=qGIOMMi5ZKxt3I7upeqW3Dr6bsLkMyl7ZcjS5nsG6Nq/whpvred8yUaImFpUoBqUlmU3
	 B6RcRJAsLZKcqpymaqCAxa9ADn6NkJ7Hi4EezNkbwyaR/2Ikzv8slibtX92zVuAn3X3qs
	 vkfwJCBC3R5tALF23gb/Okgyj+yN4JdnyraHW8qH3GbTvSftFNoKc7oihjIJ50GoQ7Ahn
	 qaY2MIeP93gNZ8FPOE1cq4x9V0eaK15N6GL6NHqZ82ysSkWadsvnQu5+oGBwZ5rurdV57
	 6UH9uxi2pfFZAVFBjDAPo837ksofaynHZyNcmA8YYoOsaxj59rJkgZ1rDrzeRyeNveA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=OUQtMX9M;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDCD606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEDCD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=OUQtMX9M
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TQtrvrfvmC4T4Oydj/5Y5AiW/2WUKiaEyR/PboyfatY=; b=OUQtMX9MtwOTRqGUaVJTpOEpBz
	PFs+2jyEikYq43hmx+VaAm+8plVt1nKf4zJnX2A0nF7WLYSv4HBwtpdhqKmZ/APh8qdaslm1K1hy9
	fN/uldqo3k3MC2nhm1WeOWQnOGpbG3zbBcXA7kKU3qTLDA2UCiG03tcDLY9o4jRatoV0=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKDD6-009eAh-1k
	for linux-wireless@vger.kernel.org;
	Fri, 23 Oct 2026 13:13:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 2/3] wifi: mt76: mt76x02: serialise wcid drop mask updates
Date: Fri, 23 Oct 2026 13:13:17 +0200
Message-ID: <20261023111318.2802233-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023111318.2802233-1-nbd@nbd.name>
References: <20261023111318.2802233-1-nbd@nbd.name>
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

mt76x02_mac_wcid_set_drop() changes one bit of an MT_WCID_DROP word,
which holds the drop bits of 32 stations, with an unlocked
read-modify-write. On MMIO devices it runs from the rx and tx paths,
concurrently with station add and remove in process context. One update
can thus overwrite another, and the hardware then discards all traffic
of a station until its next powersave transition.

Take mt76.lock around the update on MMIO devices. On USB devices, only
station add and remove reach it. Register access there can sleep, and
mt76.mutex already serialises both.

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 158aa356b710..457767bbd8b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -166,7 +166,8 @@ void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx,
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_setup);
 
-void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
+static void
+__mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 {
 	u32 val = mt76_rr(dev, MT_WCID_DROP(idx));
 	u32 bit = MT_WCID_DROP_MASK(idx);
@@ -176,6 +177,19 @@ void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
 
+void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
+{
+	/* USB register access can sleep, and mt76.mutex serialises USB callers */
+	if (!mt76_is_mmio(&dev->mt76)) {
+		__mt76x02_mac_wcid_set_drop(dev, idx, drop);
+		return;
+	}
+
+	spin_lock_bh(&dev->mt76.lock);
+	__mt76x02_mac_wcid_set_drop(dev, idx, drop);
+	spin_unlock_bh(&dev->mt76.lock);
+}
+
 static u16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 			const struct ieee80211_tx_rate *rate, u8 *nss_val)
-- 
2.47.3

