Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E344248D5
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439601; cv=none; b=es9LTMdgZY4EHcK+KfB1lrzepeuYMQFv+2tpj0M2Q8yc85AJvy73ZvV8WIyjfKkd5gkr/o0BNVYu1UOedJy8rBaovfcf3OHT+R7scqdj0sHLhDAuJzp+ltIlCEo7Hfwmh9JQJI1EckJx0QLDnjyzzvf40dr6Op/BKCoBJuiN5yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439601; c=relaxed/simple;
	bh=aYEhSErMUHMJF+BL3ou4EFarOMEm0VRKpbm8x6XblxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+RFDEsTb6gZp0400XioSS16kTGuF8zBVoQvAOz3M6J/Mu0qHS0saDpw9zHFfMDutwNZTj/1cT/R3E7e0b9LUmkmmJqITJ6fhZ/23yqDM0UDbsHgFxu3ZrFllvKmplid1kdxIsH3D+mAR3C7mAkaFhvtVq01mnYYWqAJtYluZ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lkTgZXQ5; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lkTgZXQ5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786439596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mffdGYS1Bb2k8B8GRHwSe8UcsBAOHejNXFPLEXMfCoU=;
	b=lkTgZXQ50uPJjkUaQzSO59v5uCuD/aleBngw9YwQEfog1++VcXIJlgKn5+Apa5hZ1Cfnzv
	eMojgLz3tx44jhe5S58eJd8VhSniMx+Jqy29pWrc5FVKiwwvjaBJ15gZIRL2dT5KwQ5GK5
	OiCvQ9en0vuNzI9ZgwULe3WWINozBIg=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 4/7] wifi: rtw88: fw: handle the RTL8723BS management TX reports
Date: Tue, 11 Aug 2026 09:12:00 +0000
Message-ID: <20260811091203.26841-5-luka.gejak@linux.dev>
In-Reply-To: <20260811091203.26841-1-luka.gejak@linux.dev>
References: <20260811091203.26841-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

The vendor firmware used by the RTL8723BS does not report management
frame transmission through C2H_CCX_TX_RPT. It uses event 0x12, and
reuses 0x32 for scan probe reports, which rtw88 otherwise treats as a
WLAN_RFON event and completes the LPS leave check with.

Route both events to the existing TX report handler for this chip, and
defer 0x32 to the worker instead of consuming it in the interrupt path,
so the reports are decoded and the LPS handshake is left alone. The
payload layout is the same as C2H_CCX_TX_RPT, so no separate decode is
needed.

Without this, testers on ARM SDIO boards see "failed to get tx report
from firmware" and "firmware failed to leave lps state" once power save
engages under load.

Reported-by: Peter Robinson <pbrobinson@gmail.com>
Closes: https://lore.kernel.org/all/CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com/
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 20 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..c85c0e3e60a9 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -317,6 +317,15 @@ void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	case C2H_CCX_TX_RPT:
 		rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
 		break;
+	case C2H_VENDOR_TX_RPT:
+	case C2H_WLAN_RFON:
+		/*
+		 * The RTL8723BS firmware reports management TX through these
+		 * two events instead, using the same payload layout.
+		 */
+		if (rtw_is_8723bs(rtwdev))
+			rtw_tx_report_handle(rtwdev, skb, C2H_CCX_TX_RPT);
+		break;
 	case C2H_BT_INFO:
 		rtw_coex_bt_info_notify(rtwdev, c2h->payload, len);
 		break;
@@ -365,6 +374,17 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
 		rtw_coex_info_response(rtwdev, skb);
 		break;
 	case C2H_WLAN_RFON:
+		/*
+		 * On 8723BS SDIO with v41 firmware, C2H 0x32 carries a scan TX
+		 * report, not a WLAN_RFON event: defer it to
+		 * rtw_fw_c2h_cmd_handle().
+		 */
+		if (rtw_is_8723bs(rtwdev)) {
+			*((u32 *)skb->cb) = pkt_offset;
+			skb_queue_tail(&rtwdev->c2h_queue, skb);
+			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
+			break;
+		}
 		complete(&rtwdev->lps_leave_check);
 		dev_kfree_skb_any(skb);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 48ad9ceab6ea..bdda78dc6462 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -54,6 +54,11 @@ enum rtw_c2h_cmd_id {
 	C2H_BT_MP_INFO = 0x0b,
 	C2H_BT_HID_INFO = 0x45,
 	C2H_RA_RPT = 0x0c,
+	/*
+	 * 8723BS SDIO vendor v41 firmware management TX report (0x32 is
+	 * reported as C2H_WLAN_RFON, handled per-chip in the C2H dispatch).
+	 */
+	C2H_VENDOR_TX_RPT = 0x12,
 	C2H_HW_FEATURE_REPORT = 0x19,
 	C2H_WLAN_INFO = 0x27,
 	C2H_WLAN_RFON = 0x32,
-- 
2.53.0

