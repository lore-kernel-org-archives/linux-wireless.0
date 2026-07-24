Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C133655C9
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917154; cv=none; b=UK8E2+qWF4HA1uMbfrOdpyizmMF8jEUTESp2q+tRrHxk603d4/b15keIjVFTQO+bRraq/tiw6rBylIn7F9b371KX4TGFfeqm2mGP3tI3RKAT3bphSb5BmHe3wPvVK4TD2J1eBU/5gHIFvretJQ6AFkt0QTbFD5sbCrKwToxZsfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917154; c=relaxed/simple;
	bh=Qbxr00DXRwGmipOMob2Vnwjphc0Z/w52oZLc4Fcq3ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCdOVODoLXvtARGSV6KxJSW4Q89NOaWhx9bVs3puGiGDEeSXOHXdIMNMWiCcHu4dAHpoBuDdPlN5DFtnvSq+62mxPf5gk0Ra9EI4a33oGioZNXJegYUM/JvVcLQFCyN7a+cMHPg66rAtH164YTq3tUqLqZUxlYsxbNKtmCSXTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kr6X4VYh; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kr6X4VYh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gnxEx/N9QKKg3eIUb2EOq1S45J90VQH3riJdxBeRyZo=;
	b=kr6X4VYhqSU+2yaNbVMjX/lzpFVcSvp4soKhWzgUzTh3h2tcse+FqEK2qqo8NdX+U0PNaZ
	n+5t3j1O/P0k6StDQrSkQqNbprcZf0RdGynI3Xf/J1qeXhp7mW4FuYwXau9tzB0NJH99B9
	R7sH63qFr7ZzydpbeDEDTcV3U4+qQy4=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 02/19] wifi: rtw88: rx: mark zero length packets on RTL8723B
Date: Fri, 24 Jul 2026 20:18:41 +0200
Message-ID: <20260724181858.192903-3-luka.gejak@linux.dev>
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

Like the RTL8703B, the RTL8723B reports receive descriptors with a zero
packet length, which the vendor driver drops outright. rtw88 already
flags these as having no PSDU for the RTL8703B, so extend the same
handling to the RTL8723B rather than passing an empty frame up.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/rx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index 01fd299abb7f..57facbc1b41f 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -253,10 +253,12 @@ static void rtw_rx_fill_rx_status(struct rtw_dev *rtwdev,
 
 	rtw_rx_addr_match(rtwdev, pkt_stat, hdr);
 
-	/* Rtl8723cs driver checks for size < 14 or size > 8192 and
-	 * simply drops the packet.
+	/* Rtl8723cs and rtl8723bs drivers check for size < 14 or size > 8192
+	 * and simply drop the packet.
 	 */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8703B && pkt_stat->pkt_len == 0) {
+	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B ||
+	     rtwdev->chip->id == RTW_CHIP_TYPE_8723B) &&
+	    pkt_stat->pkt_len == 0) {
 		rx_status->flag |= RX_FLAG_NO_PSDU;
 		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
 	}
-- 
2.55.0

