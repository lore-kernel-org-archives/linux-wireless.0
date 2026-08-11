Received: from out-181.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5E425CF5
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439602; cv=none; b=jGFxCloVC4aYSb6IiFfgFqpolLmf9Ja2xJGIPC/QJicEomEjuOgjXRzOMvbooEiv4rkBycPbinYJ7215uG6VfcBQ+sihcGaJBQTl4L9lYi2AdYK+a0WkIZV9qY897iK+XcMBr/bEkpwIcdaSxY7JkUY+iMEEzohD+fFSRYnm2H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439602; c=relaxed/simple;
	bh=bBMtPwnUaSSmNaOEQTtaDgpifcganP+lIU5ruxDTC7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLibLaFONnAnz1K8Qlij7OjTRoWDeITWwvT11HEW3ulmIDhBcvfi3ASIfSDlQ0j8qPsf0dx4lQMEcrRYX86PKegAG4rY4SK9vZPes5z0eZYGu+OciC3aYHp8sCS7wqDzASLOhyEoBwjYZTt3myEBsuKiJ6XaYmkZtVooY3iSBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MRZCAp3r; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MRZCAp3r"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786439594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6IvYbmBDq80Dbn4/D/hp7UJyeiL7ht7xUCRZybelgYU=;
	b=MRZCAp3rlTrSojrleiWufvrjChig20JWHZWLgjRtrc6LEXcHvsBZNEwnG68CQC5x9mJ7y/
	8L1r2mpZWIRq67msCbrg9ZUEDZPXg39DmGsZlwO4E+7cBKu6g6vMGgOB66L579FrVVioxQ
	/IkCUUxan2l7p7ko03cOVCeq43V3jXg=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 3/7] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Tue, 11 Aug 2026 09:11:59 +0000
Message-ID: <20260811091203.26841-4-luka.gejak@linux.dev>
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

Commit c80788f7c5ae ("wifi: rtw88: increase TX report timeout to fix
race condition") raised the purge timeout to 2500 ms for the RTL8723DU,
because the firmware can stay off channel during background scans for
longer than the 500 ms default, which delays the TX reports and lets the
purge timer drop the tracking skbs. The host stack then reads the missing
status as loss and collapses TCP throughput.

The RTL8723BS runs the same vendor firmware over a slower SDIO host and
hits the same race. Testers on ARM SDIO boards see "failed to get tx
report from firmware" under load, with the same throughput collapse.
Extend the 2500 ms timeout to the RTL8723BS.

Reported-by: Peter Robinson <pbrobinson@gmail.com>
Closes: https://lore.kernel.org/all/CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com/
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
2.53.0

