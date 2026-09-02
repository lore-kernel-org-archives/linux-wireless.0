Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C256331A65
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327036; cv=none; b=WNNeIwFQU9bh1JpPV9hyzOGdx1qFVSFLwvDuk8w9BHr7yZj85OChvkSYZsyjLYcesJIy+GHOTzIJOl8G21VA6eJJcrFT1FWsIHyCIKEhLAq/42NkI+aq3uzs5at5PKfm+eTXXMwgmqR/SaMk4Fp+Lv+VGwOrxpN763D7eCOq9Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327036; c=relaxed/simple;
	bh=InBGqfDYbaw3ZZ0l4kWpKLss8l5cdlsYCC+FzwXP8YY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O9m0+do+OyEuWM8UrcDrhdsIMC1GInjB3I9fcQW1xlu/vprn57vYFOIJXDHKISvn0iA0ed8j6hxOzQjpGWcjusZB4Eq8q5HhQLHh/iWFKJLuPKJFGfIHhBS5QHJbPYnkRQ87OINhTZuhYaEUxmKu6vaYGaCsohB0lzIRnf3WhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=oToOjGVH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="oToOjGVH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825UWrD42368372, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327032; bh=sNxWT7jb+uCCCINoXL6JaGnsO0DFBtCcDSc2oq3+4/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=oToOjGVHsKQVW4p6Cng4BxBV/qHbfZVFo5qfjvfBwgn9LlVzG/VHLI9/TnO5bI6A2
	 P55WrK5QarfgIdvsErCLwUOGjCJZw3chN8ZU1WtTwmUjpdlKNhf8b1RqCC+JL0J/AY
	 6cuj16JYnXwMu9+vjtCzu0itnuAAQMDcNaROueJhjBwzXm+xNpfzqNV6YUQ+320xtV
	 BgHypZyeI8KdadarH5wYdaVXLKzeVwj8MFqLoBUHIAdbkBLYdVpep637vrfiBBLUOX
	 AV8bTj6LchihHM/NrmnjZ72sJxxwW7DP/l+SH9xrUCPp0iTuUld6DcCvaMBNadJSHw
	 GXhT+rHz1E20Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825UWrD42368372
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:32 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:31 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 03/14] wifi: rtw89: allow two station interfaces in SCC
Date: Wed, 2 Sep 2026 13:29:47 +0800
Message-ID: <20260902052958.50371-4-pkshih@realtek.com>
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

