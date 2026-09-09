Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14732AE68
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937259; cv=none; b=qD+fkPUFMYCVKRYQoHduSJnQw3lcMSd3cC2SbWgnn3P/4Ag2F5NeTDofzkos6aqV7nB/TD5RBmNiMMMabWkejQgLWdIErCmwrEilqtXzO0BK+eoJCDQEZUn/8gOHvCIkk57yzQhLENa7zoQLl5g050AGzPGbZjCGu87/o/YrnjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937259; c=relaxed/simple;
	bh=mcqAq10fC0OyWF080x06eRK06Zmee5URbS/mcayDnUw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LClbLZVA5JcikEGmNQWkbXG2r/c9He10vOSdqO9pC71cLxCf8BWGQl0pk2lX3HBs+ioF+1RHye5Z+5iD0/NL8B3nhpwN38fgtPqfNKP6qiqJ79bK9kwCujvrOrQYw2HZl6F7RToWyXQWNE5/h2l9zzH4fNV8MxZua7o1lq7YYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=cS/Lo+wu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="cS/Lo+wu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68970r6C2356344, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937254; bh=gsEIoBB7aL+QFhKmfyiOrqLwofs+sQ1C4uwRXygZJC8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=cS/Lo+wu66GfmqAzFzMdFF61mhBxOVgiKMSum8fhD0546tz+SDHQ8Cl+p5UFlEXto
	 enZBuo9Owk8djLa27fFwo3UM5D7CSplDXS8TfKP4KX5grT1VEMSdjmM47refAd62ST
	 fsSMK113grGvRQ32m6uCvD1tmtlHPNrU9who1mUn2zctufTOcxrFds0BX9QthDFxtl
	 ernmTomJTbwm0PMwNxzO7kN4Xe1Auzh85Rx8VUd8UIQ5PbL0pqHJdd4a4xNn1lyp5W
	 SDDQWD0m6L2rQUEhJ1jzRpFlGvLc446VEJcY8a1iAHe0qeXs01el4jvFHQuCntyK8A
	 ENX6HrhsmAkQg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68970r6C2356344
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:00:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:54 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:00:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:00:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 04/15] wifi: rtw89: modify active scan rule for 6GHz band
Date: Wed, 9 Sep 2026 14:59:53 +0800
Message-ID: <20260909070004.35353-5-pkshih@realtek.com>
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

From: Po-Hao Huang <phhuang@realtek.com>

Remove the cancellation of active scan with specific SSID when receiving
beacons/probe responses of that SSID. Per IEEE Std 802.11ax 26.17.2.3.3,
only active scan of direct BSSID should be cancelled. Previously the
cancellation causes hidden AP under same ESS couldn't be found.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 572d9c65a2dd..8ab15ee1b155 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2579,7 +2579,6 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 	struct list_head *pkt_list = rtwdev->scan_info.pkt_list;
 	struct rtw89_pktofld_info *info;
-	const u8 *ies = mgmt->u.beacon.variable, *ssid_ie;
 	bool queue_work = false;
 
 	if (rx_status->band != NL80211_BAND_6GHZ)
@@ -2590,21 +2589,10 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 		return;
 	}
 
-	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len);
-
 	list_for_each_entry(info, &pkt_list[NL80211_BAND_6GHZ], list) {
 		if (ether_addr_equal(info->bssid, mgmt->bssid)) {
 			info->cancel = true;
 			queue_work = true;
-			continue;
-		}
-
-		if (!ssid_ie || ssid_ie[1] != info->ssid_len || info->ssid_len == 0)
-			continue;
-
-		if (memcmp(&ssid_ie[2], info->ssid, info->ssid_len) == 0) {
-			info->cancel = true;
-			queue_work = true;
 		}
 	}
 
-- 
2.25.1

