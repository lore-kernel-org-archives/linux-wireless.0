Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E124519A7
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147685; cv=none; b=deEkBqaOJLAoklwCHnxUnSBHhXiufF6s9RJZcLtuT6EHGfza6aFgdoEStVvgIiveKDXpfZkkl+YYrcc0eh6woVWwe33IvXM47XOQaUyQNitCa6z1LirmG0DSTu+osYabELrM8mtSZY4vhm9kA9gOtFUU+4QYhPSiAYMZLFjXZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147685; c=relaxed/simple;
	bh=cX5vYA1yppjnG+KB4eBqVjvQx7SleYZKmL8toVX6VKg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n0qLGl2t0ohzjd9T9tQhFwxLPYjL6MxyUPZhrdytd9SK4KobwY8ChWH2g0GgznpjYvbyZ8R1HmsWGB0hKzRmOhNtFQHvQOOC9eW3SlERUg30B2gPsUqfpLeqxN+LUXZg2zLEa6i2iHQ/aGa1zUMyTMMglLfoRTRLy6sf/msLN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Wy1CjopV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Wy1CjopV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7EenzE132705, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147680; bh=7K/6YwBnHQUHzaMNo/EndMpku6B/u7f8cCCDMUb1e04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Wy1CjopV0X1J0AP/GVJzSq+8idHgKnfipsK4Z3g1Cat6WjExmSgt7BLVVhXE7REpx
	 eVz5vHbBDYxX6xWASCB+FNChm1eJ2vnupCobNO6ze1X72LjAHiXgYtNn4/4GCS51Xk
	 mFJheER9etwI+6oi5M3ERXoybSC7jCp79Q9xq+3gu6fbMwMukBHMCHwJC33o0jyrK9
	 aFjgUkUEue3zA2Ks96QNQ5lBL6H2B9JneUAhLa70Ce4XN9HFr9gnzX3aP9e+99nF61
	 FvXWW3qkgXuRzfttr5tk8xLcNzMDOFtCAZGWgAOzGuT/TA21ffZgeYbf57zBphVaSl
	 dPtizfMZzANmw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7EenzE132705
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:14:40 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:14:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/7] wifi: rtw89: coex: log FCX report version mismatch without dropping
Date: Wed, 23 Sep 2026 15:13:48 +0800
Message-ID: <20260923071354.50864-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923071354.50864-1-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

_chk_btc_report() validated the reported firmware struct version only
for the control report, so a version mismatch on any other report type
was copied in silently and left no trace, making a ver_defs or firmware
version error hard to diagnose.

Read the reported fver, which is the leading field of every report
struct, and when it differs from the driver-selected version set the
per-type bit in fver_mismch and emit a debug line. The length-valid
report is still processed, because the driver must stay compatible with
every released firmware and a mismatch usually points at a ver_defs
entry that needs fixing rather than a report that should be discarded.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 305d8edb0d4d..d3f9ef02e982 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1866,6 +1866,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 	u32 cnt_leak_slot, bt_slot_real, bt_slot_set, cnt_rx_imr;
 	u8 i, j, val = 0, val1, val2;
 	u32 *bt_cnt, start_idx;
+	const u8 *rpt_fver;
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], %s(): index:%d\n",
@@ -2181,6 +2182,21 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 	memcpy(pfinfo, rpt_content, pcinfo->req_len);
 	pcinfo->valid = 1;
 
+	/*
+	 * fver is the leading field of every report struct. A mismatch
+	 * vs the driver-selected version means ver_defs needs a fix, so
+	 * flag it for debug but keep processing the length-valid report.
+	 */
+	rpt_fver = pfinfo;
+	pcinfo->rsp_fver = rpt_fver[0];
+	if (pcinfo->rsp_fver != pcinfo->req_fver) {
+		pfwinfo->fver_mismch |= BIT(rpt_type);
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s(): %d rsp_fver:%d!=req_fver:%d\n",
+			    __func__, rpt_type, pcinfo->rsp_fver,
+			    pcinfo->req_fver);
+	}
+
 	switch (rpt_type) {
 	case BTC_RPT_TYPE_CTRL:
 		if (ver->fcxbtcrpt == 1) {
-- 
2.25.1

