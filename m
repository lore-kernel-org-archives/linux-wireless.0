Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7C34AAE3
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2026 06:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776147786; cv=none; b=Ql6yI1LHeWNJT1WYEiKfPMYwMVdAedAHUF7WUnqpvl2TtcZiqb59f/xujNF62acDjpcEhlWbtQxhYOmQ8lUq1bansoaAZR3jVVDJ1riVi7jLrDzg81uAsB0ZWjBJcrEIoYSa6S0Nxs60RaKNLWkjiGo4RNVLXw8Zcp4AtbHW/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776147786; c=relaxed/simple;
	bh=q/JlWAX/Q++sAlSzFVms3ITDu86bJV8K96631MQUPig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7pjx/CzBjiHDVLuPFlFrOJ860YybHjrd1aTOmWLP+5es6Q2/v/GcNlZ91H95IraCg5N5KvuiwfYJTFOBrTbEBjniCUbYgxixTPIOOYa2hoTQetkyzVL/Qbablz8G1bWyPjxQ/f+ThRwvS0tTN5AWjJheR83kLQZKHFgpTHytRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZqqrKy3L; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZqqrKy3L"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63E6MxgO61508660, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776147779; bh=yjp3ZX+7l6NlfjFVqgC+ClnwTjMV+dJgmsyGcEfzA84=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ZqqrKy3LDS8M/IDo5zNdz/WkLIED6rvL2EODm+yScOv40Yg2Jtdhdnh1ZcGpIKUaJ
	 FAt43Tm56oj8bq5XAi0i7VKSsCqgwRXPjEHbgZ+FqgPwRS873cZPPhvfapz/Aba2Mc
	 jQiCmZmWmn3wc+4dENbrBcvFcU3XQtuIprkPFayGJN3LMZUjUTzYa+395nxgVO1+ku
	 VADfqDL3FfgPtZ9I04ctxGD0VcbM0j/I3JlKdcf1QCeqqIrMLcbHPXaYsS4XGsNx0R
	 9bhjjhiStG4h9ErKszHwrRZ6uUOxofNH4C9OJrF0mZVf8fLgjmXKAy8cSq6IC9enzO
	 BIu4dUd6r+PLw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63E6MxgO61508660
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 14:22:59 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Apr 2026 14:22:59 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 14 Apr 2026 14:22:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 14 Apr 2026 14:22:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <Jes.Sorensen@gmail.com>
Subject: [PATCH rtw-next 3/3] wifi: rtlwifi: validate action frame size before using in _rtl_pci_tx_isr()
Date: Tue, 14 Apr 2026 14:22:29 +0800
Message-ID: <20260414062229.21047-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260414062229.21047-1-pkshih@realtek.com>
References: <20260414062229.21047-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Since TX action frames might be malformed, validate the size before using.

Tested on RTL8723BE.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 9cc0a871ea3c..73018a0498b4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -505,9 +505,10 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 			}
 		}
 		if (ieee80211_is_action(fc)) {
-			struct ieee80211_mgmt *action_frame =
-				(struct ieee80211_mgmt *)skb->data;
-			if (action_frame->u.action.action_code ==
+			struct ieee80211_mgmt *action_frame = (void *)skb->data;
+
+			if (skb->len >= IEEE80211_MIN_ACTION_SIZE(action_code) &&
+			    action_frame->u.action.action_code ==
 			    WLAN_HT_ACTION_SMPS) {
 				dev_kfree_skb(skb);
 				goto tx_status_ok;
-- 
2.25.1

