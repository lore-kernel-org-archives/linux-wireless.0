Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E6632B105
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787675632; cv=none; b=TBAuxYP4RfEywWWie30jT01CP0Cs1fQUu1fX38bI9jBtlja9vU8eDwr1RIc0TbYnX66TY0I8+/xNRvIhuPhyTSCXuEF3Ba5pg/8HQei9KBgRyupK640tsuAN0FVAwcZKfL8YhIg+mx3tIzlbsJi92J4/kQ53hR66u13ToV5G97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787675632; c=relaxed/simple;
	bh=DiOGOpl0QG4buanFLERsD8lty/dx/TzQI96ocpbG2ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fseZSDJicxs4i7BD26+Y97G1xrScYEtL2b1NjncHd8l58BQ+++E4vkrSLcg+MIPjc+JYNJUovz9ZhMjtn++xnKuE/r9MAx+JNPJ+hFpqMmM2mBhLI1k0S9FeBtCcbpTmD2v3iGgzRM60F+Pum2z0DvweB6SH4GuQ2QWlZ5E+gM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YBUDC9t8; arc=none smtp.client-ip=95.215.58.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YBUDC9t8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DiOGOpl0QG4buanFLERsD8lty/dx/TzQI96ocpbG2ik=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787675621; v=1; x=1788280421;
 b=YBUDC9t8T47Hnzosob8Xe8wmP++EBrWVXeWlCVrFD6MWcu/UStjPDiwrEmZqvyc8Igp7YNux
 URY/thsP3L/uHxAWObTLNs7UNuMFs2HOYpohPqTYjPdEEsHZiUUZozBkRLhWL7R5y9rg+vMoyj0
 Tjgz+iIuPmzKUdwCus7sh3H0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (109.165.152.75)
	by smtp.migadu.com with ESMTPS id 952e58b13f5a4e06;
	Tue, 25 Aug 2026 16:33:41 +0000
X-Mizu-Trace-ID: 952e58b13f5a4e06
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v8 2/6] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Tue, 25 Aug 2026 16:33:10 +0000
Message-ID: <20260825163314.1590-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825163314.1590-1-luka.gejak@linux.dev>
References: <20260825163314.1590-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

Like the RTL8703B, the RTL8723BS reports receive descriptors with a zero
packet length, which the vendor driver drops outright. rtw88 already
flags these as having no PSDU for the RTL8703B, so extend the same
handling rather than passing an empty frame up.

This is gated on the SDIO interface rather than the chip id, because it
has only been observed there; the USB variant is not known to do it.

Co-developed-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v8: none.
    Changes in v7: none.
    Changes in v6: none.
    Changes in v5: the zero length test now evaluates pkt_stat->pkt_len
    first, so the unlikely case short circuits before the chip test.

 drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 01fd299abb7f..fde21c840ac0 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 
 	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
 
-	/* Rtl8723cs driver checks for size < 14 or size > 8192 and
-	 * simply drops the packet.
+	/*
+	 * Rtl8723cs and rtl8723bs drivers check for size < 14 or size > 8192
+	 * and simply drop the packet.
 	 */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8703B && pkt_stat->pkt_len == 0) {
+	if (pkt_stat->pkt_len == 0 &&
+	    (rtwdev->chip->id == RTW_CHIP_TYPE_8703B || rtw_is_8723bs(rtwdev))) {
 		rx_status->flag |= RX_FLAG_NO_PSDU;
 		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
 	}
-- 
2.53.0

