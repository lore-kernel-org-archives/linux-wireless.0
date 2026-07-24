Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70F4156D1
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917155; cv=none; b=RMUDI708nWNNrBFfHhdzXHfSxVtN+J8F063/mCLoHZhdHzeeHreoGdtsZ/TcPcTpfIBwdk+UAJUx6h1iyppfgpFTKYynasJxAHjnILEiWVCRd8jyJu+qw2SA1+NruGivx9JDL6G7GFurB1eFd0POARp7pTc0lmirDkoqTLzEYr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917155; c=relaxed/simple;
	bh=MAdK/P5y63pjuoqzxN6thLpiSPjD61vVDG9Dr2QR3xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXS6EvwHWNwRL4wvjciZH/IJpm3Mh5N6berHTz0+DNI2sTmLoR6XV1ivxoDzpoSyKFqtr50MNifS21YGLYwCDYiSFAp00N7TFfiIYOKOWldsPubkteLaXzx/Mn4d7dMwQ2ds21pjrzYioqZZe8mcdUicZlx2PhJmfFjfqru9xzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vmVrosHV; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vmVrosHV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KkRZaLZcHD9YY93ZtU4XZzvhM6gZxDkFGnpAfTfcKQo=;
	b=vmVrosHVnXHhidS6LIaTmmJ0zN8mjt58Yscb4PjxL2nDKu9jLLWvJLmJkJq6YtxqYHIyLa
	1ReCuA//YBwFLFZA/boF4cHN9E0ONjhQunGJPy875DIhHdlW0Upv5mqzxrYf6VmS8T4f9t
	J0RPHh4P4JnZEoMQAgyoZjklWcs0f84=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 03/19] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Fri, 24 Jul 2026 20:18:42 +0200
Message-ID: <20260724181858.192903-4-luka.gejak@linux.dev>
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

On slow SDIO hosts the RTL8723BS firmware can take longer than the
default purge timeout to return a TX report, which leaves "failed to get
tx report" warnings behind even though the transfer succeeded. The
RTL8723D over USB already uses a longer timeout for the same reason, so
reuse it here.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 9d747a060b98..797c1e0402f2 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -208,8 +208,9 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
-	    rtwdev->hci.type == RTW_HCI_TYPE_USB)
+	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
+	     rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
+	    rtw_is_8723bs(rtwdev))
 		timeout = msecs_to_jiffies(2500);
 
 	mod_timer(&tx_report->purge_timer, jiffies + timeout);
-- 
2.55.0

