Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE5367F4A
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327083; cv=none; b=H/GspAyGTwXZHtwxKQFFYg0cexHHHBsTWeY64GcrmodHjogh3IbwQUrq2Kqa3szJyMnLM84nNEQXHK7t9Ll5AA6MdVQoP1yC0DA14nd92YE4E6utcPoeLu/udOqCNTPfkLtPz4yMr/iNn/kDe+TG9rxPaSskwiFgTd4zoAjuiaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327083; c=relaxed/simple;
	bh=SxKY5PWx2B9SwMwX2P6y8ClMpkrs0xtwy7ZMiSVRRhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iryXBZQ2s7k+bycneJP7svemOawmNIqZye9RT1xmY+3EBe6m6/UQH0yWbT/D2YX8mY/7nqAmJLELaX9Sd6WV4RP11r37nKp2j9HYZHFwlks77kfqH6aJd9m17l1M08VZt1is/EYNwQteq8AlCr1HimbNOnqA62nf3jQISc5ETeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qAdQ8qiz; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qAdQ8qiz"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825VJ1u82368547, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327080; bh=79jvwb/j0/oGbJYeUDe0pGZR/iCPiLckGB66nf1H+Ck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qAdQ8qizQ+QXXUTs8bCXhv5Q4x87aCoSrhy1076cJ05VpIMvNjB5bw6/64C6hd9za
	 vwR27QTX37I9amsDPDwXsrT5arGOL/7P9tLiYSdYUlrHqp0bpTfN3NYzEEdgI/TWTW
	 ag8xWCzr/DrBm7fk0yfg+Mm+vzm4S18zUm+V+6T1sFPEshFnyMPbiHDJZtytX49xe3
	 QZtqVlTN4vODUOnKbmEAF5KaOiW5XgkC3zbjzWnjWmQth/rbhzEEC1JLUtvV6zjjqF
	 oK2LueYJsXA20dQRv5SCk1ifIYWJa05Yz2f7u8QDZoJiLXAfbQAfd6AhMR2PAie8WO
	 UR34F1/1UVuWA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825VJ1u82368547
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:31:20 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:31:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:31:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 12/14] wifi: rtw89: regd: check only active vifs when recalculating 6 GHz power type
Date: Wed, 2 Sep 2026 13:29:56 +0800
Message-ID: <20260902052958.50371-13-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Originally, recalculating 6 GHz power type iterates all vifs including
idle ones and takes an intersection. However, driver chanctx management
will treat idle vifs as ones who also use the first chanctx which might
be 6 GHz. Since idle vifs have no 6 GHz power type, default power type
will be taken for them. Then, intersection result would be the default
one. It means the strictest 6 GHz power type. So, fix it by iterating
only active vifs.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 14fab6b1a74a..942f55633942 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -1091,7 +1091,7 @@ static bool __rtw89_reg_6ghz_power_recalc(struct rtw89_dev *rtwdev)
 	int count = 0;
 	u8 index;
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
+	rtw89_for_each_active_rtwvif(rtwdev, rtwvif) {
 		rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id) {
 			chan = rtw89_chan_get(rtwdev, rtwvif_link->chanctx_idx);
 			if (chan->band_type != RTW89_BAND_6G)
-- 
2.25.1

