Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF4B45D5E3
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704855; cv=none; b=Ehj/c/R4J71Ngt0wjyRKZalS3SH9uLSL1lfyhFXJhpQW2xiGE4Y4Ged6+1oay8S7VgvAyw3l1UJ3Z+Ix8HxSWP6BU7Tx9PDKd4IzFkqhPoJYfhC7SQ8vv19Ag65lrid8GIrqsYCFaqoRnhxLE33vlXTO9vicru2+ZYDIiVoQtLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704855; c=relaxed/simple;
	bh=cb1ghMSjsMPV5UATzLYB2QEVJLv/pEmZ1lCn92KHN9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRhPV/ME8CIx9tulu/HpPAJOt4LRJEuX48Q8nIFVGFUp1FrOrOhoUf69eE7cwL0dviOvU46l1puX3L85buqxeHYcGeIwRS53wbyqmeP0SOBb7OdX2sHX3q06D2euvfbNMpwCsj03Yqt83VLaK7XlIc9A8JGoV7p17IbIHxZBoL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ktcMgqQ8; arc=none smtp.client-ip=95.215.58.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ktcMgqQ8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cb1ghMSjsMPV5UATzLYB2QEVJLv/pEmZ1lCn92KHN9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786704848; v=1; x=1787309648;
 b=ktcMgqQ84ir2q32C3DDrnPb93I7J/2uQ4tFrApIE0Gz31i3qL77BZ23JNHfNl0kiWRmpA+4h
 iFM5gFGmR2bxXuLprMJfHHS4vTtahBqukm5ooNaor2/RMN5ecHBAIx8ZEX0VpCN+UNVI2Upm8I1
 sPbOlf+hQ6YgPunnv641xnvE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (46.239.4.165)
	by smtp.migadu.com with ESMTPS id e24ab82240e9b20d;
	Fri, 14 Aug 2026 10:54:07 +0000
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
Subject: [PATCH v5 3/6] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Fri, 14 Aug 2026 10:53:23 +0000
Message-ID: <20260814105327.6687-4-luka.gejak@linux.dev>
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
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
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

