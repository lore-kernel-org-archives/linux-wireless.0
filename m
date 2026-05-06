Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B7407584
	for <linux-wireless@vger.kernel.org>; Wed,  6 May 2026 13:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778073081; cv=none; b=Efjzdmc/NkFYwUokqEzps0g6yc9wzHsPX+M7dyMQJolVZ3j901lsQf9sIvrRKt/sYAI2ks0n7krjacg4+oL1dLMha9LNrCU5fq5yx2aZaGI46aYeoO2hOhbMVKVJwAGVI+yNSVC2GvCiEJ2RoZezUVJ/4UnPXs3c9I3lgSXF+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778073081; c=relaxed/simple;
	bh=EdSnZ9SKGJm8rqoscR6ljgcX7fg2xu5JPNakpubwh2E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2B4YGgsEh4LEJOUhhbb5gDSF0xJ2rCxqiokHo07yXcswczi/QDbqpDENaiomlR7uYjMmCKL3fsyR9Rg1Xwru0+NsiMfPEOvo0v7lhOzme39o4Jid9+Z/NL/j5vsTgOA5K4XgL5z1NTbjm7doIvzRftkcQ4Ts9DFNvU6SVbPJQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=RK+uFT87; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="RK+uFT87"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 646DBEfbC1987214, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778073074; bh=RJoIU7SyAnhbVM/qgMP+cNLlTxGtC8o/1OqemzxlPlU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=RK+uFT87vjelDz8EHR1aCDwK99JHGopqDh4eaiRO6qEUFgOz3xmz2MEzgYxw9AMw9
	 K+uxeZhshdDwcRCmih4HfcosbtUNRMGbAQ5XNknVrOM6qHW0tNOaqwP1djyOZamaW+
	 POObETnmctoE3dy0cbUC8ODft/p0Np72EmiWKk/okv/ay5H5YNPjJ47nhTFNKq9ut9
	 3McL9VYMzyARZgLvjeQ+IYaOXVBhoHJ71yUOFu/sLFSZua6V1iZqKmfzQtf1WvD7Qu
	 M+OeUIRT8YbRyk7sfcXk3sM14cwVl8XWFcCBj/ffDNB+BtXGOpSGbZo2Pq5qep+xnS
	 DrsBvjIiCGvLQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 646DBEfbC1987214
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 6 May 2026 21:11:14 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 6 May 2026 21:11:14 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 6 May 2026 21:11:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 14/14] wifi: rtw89: check skb headroom before adding radiotap
Date: Wed, 6 May 2026 21:10:00 +0800
Message-ID: <20260506131000.1706298-15-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260506131000.1706298-1-pkshih@realtek.com>
References: <20260506131000.1706298-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The radiotap headroom is allocated only if IEEE80211_CONF_MONITOR is set.
However, it is potentially racing that SKB allocation without radiotap
headroom but adding radiotap from matched PPDU status of another SKB.
Add a check to avoid the case.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index c21737981b61..432d46dfd26a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3758,6 +3758,13 @@ static void rtw89_core_update_radiotap(struct rtw89_dev *rtwdev,
 	if (!(rtwdev->hw->conf.flags & IEEE80211_CONF_MONITOR))
 		return;
 
+	/*
+	 * At transient adding a monitor vif from a station vif, the headroom
+	 * might not include radiotap.
+	 */
+	if (unlikely(skb_headroom(skb) < RTW89_RADIOTAP_ROOM + NET_SKB_PAD))
+		return;
+
 	if (rx_status->encoding == RX_ENC_VHT)
 		rtw89_core_update_radiotap_vht(rtwdev, skb, rx_status, phy_ppdu);
 	else if (rx_status->encoding == RX_ENC_HE)
-- 
2.25.1

