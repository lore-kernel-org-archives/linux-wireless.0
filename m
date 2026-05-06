Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6488A3F1645
	for <linux-wireless@vger.kernel.org>; Wed,  6 May 2026 13:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778073020; cv=none; b=VkUhISGJ/1M90UVUZ7AELwqtwyZOFOL/n1I4T+zcOdg1NaQWqO/x+cRJF3GkiYJQHl/mqL1ECRhLWfVkiKvbWl7xcgwLsig5/UMvkYuBSGav89Py+09R6RVPbrp2YeHdB/aMFDuKlKMkai19wFUO1v0EWIYMYCbzSl/8ttUKZOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778073020; c=relaxed/simple;
	bh=LakTdlohBU08T7xmUOqFP4BBLimXuzh0MTss6+FBbi4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQe+90PsakSlM1WEI8yDqJz2vW+4vXF04qEHYWixrD7SSY/KiBuAXnYh+WA6R1nluPgN0v/nX0BvgU3hRThn+s9uQgqY633b+OKVL7BQBS17C8PRKMQFHOYDrFjdwtheEG3t1c3I8/zLAQGJZ2ZKoO5XLuxvc0W+sy29KEYXcHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QqWnNhqC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QqWnNhqC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 646DAGRz81986838, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778073016; bh=j+4wyj3x+ub7f+4KQrmV0UCHF5gGN/9tN0TnUly3QzQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=QqWnNhqCfQw9BLP5GuXXJmXk8osK6fRgjihfupx6uFORVjTqUSo+PmGZ09kqfOGJ8
	 KraJWmyOqs3/pvBm5rdNsTaklxlHliDWAKR5pfAl8ZgmIcK95Vn5SiYsoXrl4ONDP6
	 N8nsPI+wcGR3hOScuh1Knv8z21wXILjAts/LICiUzXDmj5wHZoOD8F55wx0DvUPBQg
	 No2eKYgnHtfWuBdlr1GukB7KjDlEU581AGd30VWU6yKzMuv9ehdgBGwKTKaPMIcA5t
	 XAK3vlyl6y4z6U84oQn4e6CwPNexYFfva26hJmbdkXYIlUriMim4ifSloqZTuNc636
	 6DfUmZjCByYRg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 646DAGRz81986838
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 6 May 2026 21:10:16 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 6 May 2026 21:10:15 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 6 May 2026 21:10:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 03/14] wifi: rtw89: SNIFFER_MODE bit along IEEE80211_CONF_MONITOR
Date: Wed, 6 May 2026 21:09:49 +0800
Message-ID: <20260506131000.1706298-4-pkshih@realtek.com>
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

The SNIFFER_MODE bit can ignore filter rules, and receive packets to
driver, so set the bit to accept all packets.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index b72f6661fbd1..2c6711133c80 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -356,6 +356,11 @@ static void rtw89_ops_configure_filter(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (rtwdev->hw->conf.flags & IEEE80211_CONF_MONITOR)
+		rtwdev->hal.rx_fltr |= B_AX_SNIFFER_MODE;
+	else
+		rtwdev->hal.rx_fltr &= ~B_AX_SNIFFER_MODE;
+
 	rx_fltr = rtwdev->hal.rx_fltr;
 
 	/* mac80211 doesn't configure filter when HW scan, driver need to
-- 
2.25.1

