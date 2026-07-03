Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F08A3C9ED5
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 11:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079011; cv=none; b=LoBLyLNj2JITDkRGXOKjfdq/JinchJ4np8eHUO8jwa4Pb5yM3Op+Mo1vuftSDHrdNjqqnfCrvi5HAKvjRBQp0YC3LEZpv5E6CHGkq9vO3ZBIw1xGrp2lMGg3k47KNNpIMKKYy1OPv5Jo7Zrm2TgC3PyJ+MulVgeKoT6u6tJ3Zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079011; c=relaxed/simple;
	bh=3jPcnhX3b3yyMvIfuBsNMI5zH2/So/b6a/sJdBNYDuM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VwoFJV5Uhl/tSubSN86ZeP+1Kog8+FyXVD60uO9xLk4sTvvSZhsWFt4qKElohQ139bJ6kjAcKmclcvak7XyNIixc0d0wt05EbOb6i7NHbJCzn2jc+cCpMdf3XX6RmdCbS3q39/+ZpRYLtwb7jrUCO055K4AX/hmhEI+t+hIuppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IpvnDS6l; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IpvnDS6l"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 663BhSqK52637594, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783079008; bh=jYmg0YETt/L1tBbWsioowrCUXx34MLa+aN4ZatKBqXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=IpvnDS6l0I2WogEbptQkUtchDAZVsAZGQcspuCYs4JiLBqNz4eZ940+u4m/XovPmr
	 nATtmnTryLZOuey3ydvMlbak3QyzLw/UOfKnbiRnOACPS5eR/PdZBGhmouaJBtyOVI
	 newkNy4WiI6eZPHTvgSpDK45N4ML41VYJaS9JkjeWH8KsTLe2Ky1P9xMzz7Slt5HFY
	 xmkS4xWI+xBjZMpgl58OER+Z47ClwAqUH0MrEuCDdmZX2QZg+6Vb9bgvZ/AfmbyqVd
	 v+/RTBHQmBo3ubeXpk3utEt3Qbfu/7zqhsFOU77/dX3M8lyJNsK8rHa5QqgzDPmSE+
	 9Ml4izU/eQ7kQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 663BhSqK52637594
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 3 Jul 2026 19:43:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 3 Jul 2026 19:43:27 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 3 Jul 2026 19:43:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 3/9] wifi: rtw89: coex: Update TDMA descriptor for dual MAC
Date: Fri, 3 Jul 2026 19:43:05 +0800
Message-ID: <20260703114311.2609942-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260703114311.2609942-1-pkshih@realtek.com>
References: <20260703114311.2609942-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The mechanism needs information to know which MAC is coexisting with which
Bluetooth and when to enable TDMA with which MAC. So change an variable to
describe the binding target.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 15 ++++++++-------
 drivers/net/wireless/realtek/rtw89/core.h |  4 ++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 196bec751070..14cc62cf399d 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2288,9 +2288,9 @@ static void _append_tdma(struct rtw89_dev *rtwdev)
 	}
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
-		    "[BTC], %s(): type:%d, rxflctrl=%d, txpause=%d, wtgle_n=%d, leak_n=%d, ext_ctrl=%d\n",
+		    "[BTC], %s(): type:%d, rxflctrl=%d, txflctrl=%d, bind=%d, leak_n=%d, ext_ctrl=%d\n",
 		    __func__, dm->tdma.type, dm->tdma.rxflctrl,
-		    dm->tdma.txpause, dm->tdma.wtgle_n, dm->tdma.leak_n,
+		    dm->tdma.txflctrl, dm->tdma.bind, dm->tdma.leak_n,
 		    dm->tdma.ext_ctrl);
 }
 
@@ -3733,7 +3733,8 @@ static bool _check_freerun(struct rtw89_dev *rtwdev)
 
 #define _tdma_set_flctrl(btc, flc) ({(btc)->dm.tdma.rxflctrl = flc; })
 #define _tdma_set_flctrl_role(btc, role) ({(btc)->dm.tdma.rxflctrl_role = role; })
-#define _tdma_set_tog(btc, wtg) ({(btc)->dm.tdma.wtgle_n = wtg; })
+#define _tdma_set_rxflctrl(btc, rxflc) ({(btc)->dm.tdma.rxflctrl = rxflc; })
+#define _tdma_set_txflctrl(btc, txflc) ({(btc)->dm.tdma.txflctrl = txflc; })
 #define _tdma_set_lek(btc, lek) ({(btc)->dm.tdma.leak_n = lek; })
 
 struct btc_btinfo_lb2 {
@@ -9967,13 +9968,13 @@ static int _show_fbtc_tdma(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	p += scnprintf(p, end - p,
 		       " %-15s : ", "[tdma_policy]");
 	p += scnprintf(p, end - p,
-		       "type:%d, rx_flow_ctrl:%d, tx_pause:%d, ",
+		       "type:%d, rx_flow_ctrl:%d, txflctrl:%d, ",
 		       (u32)t->type,
-		       t->rxflctrl, t->txpause);
+		       t->rxflctrl, t->txflctrl);
 
 	p += scnprintf(p, end - p,
-		       "wl_toggle_n:%d, leak_n:%d, ext_ctrl:%d, ",
-		       t->wtgle_n, t->leak_n, t->ext_ctrl);
+		       "bind:%d, leak_n:%d, ext_ctrl:%d, ",
+		       t->bind, t->leak_n, t->ext_ctrl);
 
 	p += scnprintf(p, end - p,
 		       "policy_type:%d",
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 1e72c9b9f3b7..a0f6929873ab 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2354,8 +2354,8 @@ struct rtw89_btc_cx {
 struct rtw89_btc_fbtc_tdma {
 	u8 type; /* btc_ver::fcxtdma */
 	u8 rxflctrl;
-	u8 txpause;
-	u8 wtgle_n;
+	u8 txflctrl;
+	u8 bind;
 	u8 leak_n;
 	u8 ext_ctrl;
 	u8 rxflctrl_role;
-- 
2.25.1

