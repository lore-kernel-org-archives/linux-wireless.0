Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515271A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726491; cv=none; b=NGaLo2Ub0tIR7QZaJHwabn7X9/CnSokumOsS9Hf/GbSMhF9g/rRt5sFm3HKND2cvaVSa3aiS04Z1Fwk1G44+UFQCEdsIhaOJN9+Uz80uGIOslYzBpw0bDutbvpj979NUZ0AvoEKwniMXfBZqGW2v07ER8IS/YJnNgynxjDxmwfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726491; c=relaxed/simple;
	bh=InBGqfDYbaw3ZZ0l4kWpKLss8l5cdlsYCC+FzwXP8YY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1WEbOZiC98X8ghxNtb0ZtvPnkTgADut79Lodus2E08HALRdC6AZ/FLRNpaVK6T1nAYun+Xr1jr1Pe2O6X06jK87P+aSAqFswnkuxoKQu1UNs5VcoY9Sn32uG3gB1xygTjhVpCJr7plLbCBquNx1WF56mGFT4DeXb4duZV40Yik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LSgUGdqr; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LSgUGdqr"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fQP51353033, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726487; bh=sNxWT7jb+uCCCINoXL6JaGnsO0DFBtCcDSc2oq3+4/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=LSgUGdqrsMbJpivOgq6PR2l+Quqa64UfQQpiY5T4NeYAC4d2/vk3eeG/th1PnSyBQ
	 PhwnSdLFoz8xe/Fd8qeWMQZLV3Gax3wG7GFRVHLPGDoo9wAndHkn3r6vbWIrxCg+fC
	 2J4ydjTNCLMO9hrZqgkUk6EkuOHdirTaGHH3hPPrP3Vc8HpsF5WKfs1XZaLJdX3z1N
	 b6Woufxjylu98fdRgheXv6m40htdUNTpKHwSWI23koe1Ie6wxrvVd8hAoMLy4ogTaT
	 9YsnlXOKoL0GGnxWAp3P0F4hRNEomHpe9F8yef7tqwhGmeUHH0qRvyGc4j8jsXux9j
	 A13w6h+2BGcCw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fQP51353033
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:26 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:27 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 03/14] wifi: rtw89: allow two station interfaces in SCC
Date: Wed, 26 Aug 2026 14:40:50 +0800
Message-ID: <20260826064101.58892-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Hsiao-Yung Chen <henchy.chen@realtek.com>

The single-channel interface combination previously permitted only one
STATION interface, alongside one P2P or AP interface. Raise the STATION
limit to two so that a STA + STA combination is allowed in the single
channel concurrency (SCC) case.

This enables concurrent dual-STA use cases on the same channel, such as
having one STA interface connected to an AP router for Internet access,
while the second STA interface connects to another local peer/device for
dedicated media/data streaming.

Benchmark results on RTL8922DE in 6 GHz / 80 MHz SCC mode (UDP):

                STA1 alone      SCC STA1+STA2   STA2 alone
UDP TX (Gbps)   0.95            0.52 + 0.49     0.99
UDP RX (Gbps)   0.95            0.56 + 0.46     0.95

Signed-off-by: Hsiao-Yung Chen <henchy.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 397ebbfcac09..24275c2250e7 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -167,7 +167,7 @@ static struct ieee80211_rate rtw89_bitrates[] = {
 
 static const struct ieee80211_iface_limit rtw89_iface_limits[] = {
 	{
-		.max = 1,
+		.max = 2,
 		.types = BIT(NL80211_IFTYPE_STATION),
 	},
 	{
-- 
2.25.1

