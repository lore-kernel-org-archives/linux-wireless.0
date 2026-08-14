Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494F445DF4A
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 10:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704849; cv=none; b=OpK6C/0aI33KU5RkqYBYucG6si9Hi98oTVOsxxNWpVC84k4n+Fmj/cvvVYm5Aj2cAG7DWCc7M2zr1LDaTCq8wSJQs5LR6r/ldxeHOJNmwEQtEQTTmCXSha7tdf3jXTRl0VVsSAku35PBvLpefMJ3IJEgSxcUNU3A1zSoazEa4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704849; c=relaxed/simple;
	bh=otNevKNPjmGQ8hQocf0jIYx9y7s7VhT/vzqqX5vdSV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keTdUJYMEC91AhILih5zjK8iKJppOmO8VztK8gdyGfoH0hG7MiQIkY1odWgmmaRlb057sZ1QDVyLRY0hN4vAWxnxdsdjoRoD4s82LBfg33LrNjD2L9AlYJuZ/Rc1G0n92pHiBugLs5A+g0XHL6f7PiWBGThWRa7cul4LPX6C4no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FJaN02pG; arc=none smtp.client-ip=91.218.175.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FJaN02pG"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=otNevKNPjmGQ8hQocf0jIYx9y7s7VhT/vzqqX5vdSV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786704842; v=1; x=1787309642;
 b=FJaN02pGYR7K+IHFug66ykMQt/GvRs9sXABhuQGaR7XERA/LIlBnfjoqDlHq0xVL9OF2Jx4k
 QXYG1CgkXaD9bL2ACbP66kYYAhy78UOtgAWUJDcmI5haq86dtE/Lq4gykLFp3iwX49yWdMaGIrk
 49k8Q46u1jn5I3N8fakCOALg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (46.239.4.165)
	by smtp.migadu.com with ESMTPS id 674134dbe00d38be;
	Fri, 14 Aug 2026 10:54:02 +0000
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
Subject: [PATCH v5 2/6] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Fri, 14 Aug 2026 10:53:22 +0000
Message-ID: <20260814105327.6687-3-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814105327.6687-1-luka.gejak@linux.dev>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
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
---
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

