Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F21C3DD847
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787216686; cv=none; b=VvH6MICehD5lA1/rgdcXSR9rUBLH058ZjUn3Mh051tirA1ankqSS8WCUdRi911YA8ZvEk7UPL7yYOKWxv4jWsKZlnxhBrPKqB9YXPIa+zccDci90XvVFdz5tu93pF6ciMiNgIHbt7SCkFJq4q1wBgtKd7KxdrlokwBO9zjPPF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787216686; c=relaxed/simple;
	bh=jKIgg6GhlrWWaSsCBmHYu3j1doP9CSpu3aMoY4OjXis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ne4o70UnqGsfc6EbanrgHZv2j4/6ExvCt5ZI9gXJfbsah9dnStDMwnHRVHfUuo4ZuJZ7orRXLRBnYQc0EcoiIoNjFqq0Vy4aBT0v6JFb2a6Aws8DFfERz0Ro7uhb+tdONtAkfaK72pyEceDgaPkrPXoWbEx6Uedf9nSzuVkDl5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jzmDxnsl; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jzmDxnsl"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jKIgg6GhlrWWaSsCBmHYu3j1doP9CSpu3aMoY4OjXis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787216682; v=1; x=1787821482;
 b=jzmDxnsl36joDGlrtk4hkK+6/+Jo3vivq+7ciI7FKNqmx6qzzub/OaRL32lwiQXEZ7H4jZUn
 RLV0IQcDxUEBVDpZkkWXgQJsd2lFEDDsyN+fXNDSqtEaxdMrZpPxDlzWNNZvmluFCeveO3p68Rl
 LMHLahrWckiy0PE64PT1Ju2A=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 1a90c17562d2980f;
	Thu, 20 Aug 2026 09:04:42 +0000
X-Mizu-Trace-ID: 1a90c17562d2980f
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
Subject: [PATCH v7 3/6] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Thu, 20 Aug 2026 09:04:09 +0000
Message-ID: <20260820090412.19574-4-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820090412.19574-1-luka.gejak@linux.dev>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
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

Notes:
    Changes in v7: none.
    Changes in v6: none.
    Changes in v5: none. Restored in v4 after being dropped in v2, because
    testers on slower ARM SDIO hosts hit the warning that commit
    c80788f7c5ae already fixes for the RTL8723DU.

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

