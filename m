Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870B2348C7B
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937239; cv=none; b=DQWutWMsLDtHZ+AEumxLPF5RUX8LK99rNmgCFNEz1USfFcJO78ipAAmFPUKOeRo+KYkPa+mVZS2lBrEMdZxD4flcQZ4EaTwUQYYBk6/ogtFTXDvQ478o/c2zJvRA/2u0FEpzpMry6+bjvh83cyVn7HGypev2hVaOH8nSQU8ynfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937239; c=relaxed/simple;
	bh=doAh30KoTJpPOS+la9ylMAOhp0vx9SCLyEtsqO6cOB4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IP/gwfQ2NblzCcvsFrUqUtOiHDTYcPm91tpKd9diu+7pPbwvCV4ap0q8XSPmDJ/fmO2EnQ7SGuDSgU0rMc6FuNnVsg6LUBjtDGKE2AWjs90kmoVPvMDhnPoyfHSA/Cf651opIBrJGhkMaz78EuN0OwM9NomoFQAMrmYcRUWLnHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iG9GKzgW; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iG9GKzgW"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68970X9L0355968, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937234; bh=uDETJbqf0MZAo/xKKxLqieiHU/D3YpJ3PGoY+peYNpo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=iG9GKzgWaHmivjf2bslSvqCq5xBoDmLWCIMvkVH6eCP6D7LGHyssdVNrLWVSxLNNp
	 jtc/4vmQcxj0h7zds9uBUvTTfVkebgymc+l4yJrSsuPIfnat8M9M1mVdnC5X8L4n3z
	 fiCLvpIF0dtD6bomoQXOpQQ54v8t2RCNrKdRTSAPv4DxmWPt4vj+wG7DipcepI2Iet
	 czKSzrA7YXHsibmogRKvZ6eJqcnIea5DJWJZ5yf5Rh7iSsPh6IBtsZY5lFW79RHtZn
	 1EZfJ5O+mwKIMdLwKJpqWucgUqEZhJXiaKi2Geke/TUePH2G/ZN8FO4bvOrVTNgBwq
	 lCLFKUkgEYFJQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68970X9L0355968
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:00:34 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:33 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 01/15] wifi: rtw89: consider sta maximum AMSDU subframes number to decide TX work waiting
Date: Wed, 9 Sep 2026 14:59:50 +0800
Message-ID: <20260909070004.35353-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Consider the sta maximum AMSDU subframes as a factor to set agg_wait to 0
to avoid TX work waiting to yield better latency if real-time application
lets AMSDU off by

   iw dev wlan0 set tidconf tids 0xff amsdu off

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 501923d97971..c33b888bc0e3 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3221,6 +3221,17 @@ static void rtw89_phy_set_txpwr_limit_ru_ax(struct rtw89_dev *rtwdev,
 	}
 }
 
+static int get_max_agg_wait(struct ieee80211_link_sta *link_sta, u16 amsdu_len)
+{
+	struct ieee80211_sta *sta = link_sta->sta;
+	int max_agg_wait = amsdu_len / 1500 - 1;
+
+	if (sta->max_amsdu_subframes)
+		max_agg_wait = min(max_agg_wait, sta->max_amsdu_subframes - 1);
+
+	return max_agg_wait;
+}
+
 struct rtw89_phy_iter_ra_data {
 	struct rtw89_dev *rtwdev;
 	struct sk_buff *c2h;
@@ -3345,7 +3356,7 @@ static void __rtw89_phy_c2h_ra_rpt_iter(struct rtw89_sta_link *rtwsta_link,
 		*changed = true;
 	}
 
-	rtwsta_link->max_agg_wait = link_sta->agg.max_rc_amsdu_len / 1500 - 1;
+	rtwsta_link->max_agg_wait = get_max_agg_wait(link_sta, amsdu_len);
 }
 
 static void rtw89_phy_c2h_ra_rpt_iter(void *data, struct ieee80211_sta *sta)
-- 
2.25.1

