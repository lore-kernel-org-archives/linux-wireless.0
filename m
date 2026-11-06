Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.31.26.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967637;
	b=gWlmQLDMtSANqzTgfU5gP8CFzybgBXb6SBz74gQ0p/7jy/aA1AbH99H1A71o3YLE3pn4
	 9bmoIPYQ1mmjq0HEpw3Y+v2xLX4UuqPx2SasArAjybANNduHqmn4jNYiXTUC6cjNWKDhL
	 sV6P99Kt6uM92XyY1vA5FxYSIhpg+lV6xZqtPrEsTczaQDXkKJcNGiu7n/N1Uip/bLvFq
	 Ok3ojsdpicw9CNaHoBrOI83MOerjaguJr8tfbrFYNXMiQFxEVMbWJGg6AEn/u4axfUsh7
	 KypQGC1rdIw2+v+4HxSL+9W4EI38mwS+rdI52DuyFKQoBIOasCHPyvGV3L/YAfhlFTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967637;
	h=DMARC-Filter:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer;
	bh=SfHCWdK/R6hFCAoqy3I3O/kaxO5mPuAnlKQhvji6+UE=;
	b=1deY/qGZ2f3GtScV4aEhWrr8nGIhJXPcJtZZ9cXE20Wf82URrZF+BHDl5rlUMxlfAFKX
	 Q7FqCYmhuJPS3YRFRN6WGGBau7hE+vCN90PZZbmi8VAqvuQ4eiMBeicrROf5eSeeGlIhX
	 h4BZwpmE3vesK+87AKPY1571MairSeNhpV20D4k1wyzJIDFm2kJSBkIBCxt9rNCAyI+iS
	 bNo6+L3yMQSDi3ohRxAxJkBZ+/zZUPSfx0wC0y8+0E0lp2lGuVtxczyCCEwjcmA11xlJC
	 rcpNiUjHP7kDpso1eMVtfxRkdsjCtCGfSNqK1xsT8X+H2/a+bgXcbgznr3SnyiWE5HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rudorff.com;
	spf=pass smtp.mailfrom=rudorff.com;
	arc=none smtp.remote-ip=193.31.26.27
Received: from rudorff.com (rudorff.com [193.31.26.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA2606A32C;
	Fri,  6 Nov 2026 12:20:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92DA2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rudorff.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rudorff.com
Received: from [127.0.0.1] (dynamic-2a02-3102-b60c-0d00-92f6-52ff-0000-04cc.310.pool.telefonica.de [IPv6:2a02:3102:b60c:d00:92f6:52ff:0:4cc])
	by rudorff.com (Postfix) with ESMTPSA id BF3A1404D7;
	Fri,  6 Nov 2026 13:20:34 +0100 (CET)
From: Christoph Rudorff <chris@rudorff.com>
Date: Fri, 06 Nov 2026 13:20:23 +0100
Subject: [PATCH v2] mac80211: fix ieee80211_set_antenna() return value
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-fix-set-antenna-v2-1-23889392e64a@rudorff.com>
X-B4-Tracking: v=1; b=H4sIAAbG7WoC/3WNwQ7CIBAFf6XZs2uApLR68j+aHlpYLCaCAdpoG
 v5dqGePk8ybt0OkYCnCtdkh0Gaj9a6AODWglsndCa0uDIIJyRmXaOwbIyWcXCLnJmyZYK1WvVS
 zhLJ6BSrKURzGH8d1fpBKNVONxcbkw+e43Hj1/tc3jhyJdVxLaTrTX25h1T4Yc1b+CWPO+QvjK
 oV8wgAAAA==
X-Change-ID: 20261016-fix-set-antenna-50205dc86cb6
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christoph Rudorff <chris@rudorff.com>, 
 "John W. Linville" <linville@tuxdriver.com>, 
 Bruno Randolf <br1@einfach.org>
X-Mailer: b4 0.16.0

Actually ieee80211_set_antenna() returns -EOPNOTSUPP in case the device is
"started". That is confusing. Return -EBUSY instead. That makes clear that
the device must be stopped beforehand.

Given an active wifi device:

$ iw phy0 set antenna 0x3
command failed: Operation not supported (-95)

expected output:
command failed: Device or resource busy (-16)

drv_set_antenna() later on will check if the driver supports it.

Fixes: 15d967532148 ("mac80211: Add antenna configuration")
Signed-off-by: Christoph Rudorff <chris@rudorff.com>
---
I was confused that none of my wifi devices can set_antenna.

Given a fresh inserted usb wifi device:

$ iw phy0 set antenna 0x3
command failed: Operation not supported (-95)

$ rfkill block wlan
$ iw phy0 set antenna 0x3

Oh, wonder, it works!

expected output:
$ iw phy0 set antenna 0x3
command failed: Device or resource busy (-16)

So fix the return value of ieee80211_set_antenna() and later on
drv_set_antenna() checks if the driver supports it.

This is a good candidate for backport. The patch is just a one liner.
---
Changes in v2:
- accelerated commit messages
- Link to v1: https://patch.msgid.link/20261016-fix-set-antenna-v1-1-e071d66f7f89@rudorff.com

To: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1753335eb9d..87a9ead7c638 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4920,7 +4920,7 @@ static int ieee80211_set_antenna(struct wiphy *wiphy, int radio_idx,
 	int ret;
 
 	if (local->started)
-		return -EOPNOTSUPP;
+		return -EBUSY;
 
 	ret = drv_set_antenna(local, tx_ant, rx_ant);
 	if (ret)

---
base-commit: 79a907609d53d5cd645b42c11550d295d43abf99
change-id: 20261016-fix-set-antenna-50205dc86cb6

Best regards,
--  
Christoph Rudorff <chris@rudorff.com>

