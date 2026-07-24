Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CCF44780A
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917156; cv=none; b=H6pBYcFo0IWq+RSm9RWyWmlTrZn4XDwiBAitZkJN3OtoBb4ZH3szEygaGn45fRJHDpYX2B/9Nhe8mJjcV12lzBm4fEN5gl6PG4hXtz+gzjXWeK379+v4BWtoAQMjr7BR4YqtdoeBcJFefDatfy10Da2YZeysyK9beLh9rd+Dm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917156; c=relaxed/simple;
	bh=A0r02T1IIDTr/Syvh4ovNcWgFP6CZrcME4o47xLWRFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+tsIHOJxwmouL6OulOfKkIropaWb7tKGf1Ab4c5Gb+RT8ZpTJA85r09dqZMRVmMP3pslJKeX5c6QbbsD2tHysYkTh1bHthJYyNLKo8xbolYUKH+rVYFfL/KUFXgFac4dGhlv2uTieaCDoh1HDBkJNjfzmUwyC5AChmcLFlh4m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MnDb8pWo; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MnDb8pWo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3tM6f9KUkyefXMF2g+jFt7QGhBvMIqTNsY0XkbSVh4M=;
	b=MnDb8pWoi8S4AMNgOdP27nEJPZoVkhQgFJUlUzpXe6o//0jF44YkOAhUHpWXWv7Rw2MgUK
	kICp0SHQefI59pAJyeTmsE2iwN5E8MWnaKYoCMj617sq4n1FvlceTw7ow4U03NG3RXBXmM
	Qas+ugPM5ClimptmcaBEALQ6WibeZ10=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 04/19] wifi: rtw88: fw: handle the RTL8723BS management TX reports
Date: Fri, 24 Jul 2026 20:18:43 +0200
Message-ID: <20260724181858.192903-5-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
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

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 18 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 945fedcd375b..a81ff15218e1 100644
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
@@ -365,6 +374,15 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
 		rtw_coex_info_response(rtwdev, skb);
 		break;
 	case C2H_WLAN_RFON:
+		/* On 8723BS SDIO with v41 firmware, C2H 0x32 carries a scan TX
+		 * report, not a WLAN_RFON event: defer it to rtw_fw_c2h_cmd_handle().
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
index 48ad9ceab6ea..6927d2041d24 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -54,6 +54,10 @@ enum rtw_c2h_cmd_id {
 	C2H_BT_MP_INFO = 0x0b,
 	C2H_BT_HID_INFO = 0x45,
 	C2H_RA_RPT = 0x0c,
+	/* 8723BS SDIO vendor v41 firmware management TX report (0x32 is
+	 * reported as C2H_WLAN_RFON, handled per-chip in the C2H dispatch).
+	 */
+	C2H_VENDOR_TX_RPT = 0x12,
 	C2H_HW_FEATURE_REPORT = 0x19,
 	C2H_WLAN_INFO = 0x27,
 	C2H_WLAN_RFON = 0x32,
-- 
2.55.0

