Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D81417377
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439600; cv=none; b=u10rNYu9dJcC9wMZzIdaI8io9LNoBopmvdx4UCsTVK6P6NOBqU2zdIAXKzGi7KATW640Iv35YOlwrSihnD+ur+Wyne8of2Sq0cSovOjpGvuNsjBfmJeN50Y9/HzCr6lFxcBeNbk40Zru8I8VmJBvS5F/VRRfHmwQGd2vecyblDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439600; c=relaxed/simple;
	bh=XOpYD6I4JlkbBLnsmaDU2z1GtAYOgs2KWDmPkI4vHbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlBfJ904bWe2nANpZkC14t7Z/6EuGFgJmiiOvmF9IXvIrVNyvd9tpl/X6mJEXXfLtY3ab9OTWZgqSTRZbyEEply13ttm027sNyk3x4ubDiMKHpRfwrui4ZoBpmKbXABKHfU/t++HAHNW/z1ve5K/8Rkc05bUaf6bSgQxstqtJBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tvq0BwCv; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tvq0BwCv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786439593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uu7M6NtujFaEuvcioOiMlJdOPXugliUXHR5sYjd60P0=;
	b=tvq0BwCv+5B1n9iGaRk6O2WjLDDDWy9PFNbS3vYuqymnYHpIL4iL3kXXM0DwybcipZlaUA
	yL/E8+5gAE9Zpt+b9jlrYGOlPoTbEXZirhZFYF5uB7KRNuOhKwPl1h96V/ti0F4Fpx0wiI
	HEKjlIao9dnTllgRXIV7cOUYwAjRcGs=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 2/7] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Tue, 11 Aug 2026 09:11:58 +0000
Message-ID: <20260811091203.26841-3-luka.gejak@linux.dev>
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
index 01fd299abb7f..a9361ef4b93c 100644
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
+	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B || rtw_is_8723bs(rtwdev)) &&
+	    pkt_stat->pkt_len == 0) {
 		rx_status->flag |= RX_FLAG_NO_PSDU;
 		rtw_dbg(rtwdev, RTW_DBG_RX, "zero length packet");
 	}
-- 
2.53.0

