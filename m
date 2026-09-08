Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E14C563FB9
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874201; cv=none; b=axMvCX80d6tCU+4d+mGpm1L1gyue+0OJ+tWBfiHqvWUu7VNwboX1SMQno95nabXJKB3xCPQ2nGrZXy0wGc3ePdV8isLj5vj0b3aWcCTLHfLUwvy9BAU0dRAGiLs/UJMahWWcENUPrATt3WkLoetRkHxOVcqfCcNsYasM6B3u83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874201; c=relaxed/simple;
	bh=pj7G8hGWOYrz8BYJYMu4gorGGocx/OpcaEvOKht0G58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKTZEPWouodwBZMpEUE6MDxDj/PDUT71oXqiuTl6hHBo2AT/YXRjIyZs3aL2NGQrWiCIRh5AUyfq2dSAHsdZt/AEoW8E1savn5gcYUBH10ZtCPahavqVZWTelvxl7Xhs1L2Hu49tO0Gns2Kic+Kgf0khCv4jl61sMVals7qvOFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i/bw5e5O; arc=none smtp.client-ip=95.215.58.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i/bw5e5O"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pj7G8hGWOYrz8BYJYMu4gorGGocx/OpcaEvOKht0G58=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874186; v=1; x=1789478986;
 b=i/bw5e5Oby7sDlsQeI9YvgqOBN62rJXKBLXa7NLGbV3n4ZOVGsyPs7/8OakA+Jz7oXJl9mlp
 sLvaFL0qfhIyzMzeYnV6z42nMDXBQGdiNY8H7bAxFhrv4ensKeKGIMaQckehPkRZjqhzfbWb3ks
 GXylCxsbYYU8zd72yROF38zQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 12519f327f5f0f4e;
	Tue, 08 Sep 2026 13:29:46 +0000
X-Mizu-Trace-ID: 12519f327f5f0f4e
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v10 3/6] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Tue,  8 Sep 2026 15:29:23 +0200
Message-ID: <20260908132926.68976-4-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908132926.68976-1-luka.gejak@linux.dev>
References: <20260908132926.68976-1-luka.gejak@linux.dev>
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
    Changes in v10: none.
    Changes in v9: none.
    Changes in v8: none.
    Changes in v7: none.
    Changes in v6: none.
    Changes in v5: none. Restored in v4 after being dropped in v2, because
    testers on slower ARM SDIO hosts hit the warning that commit
    c80788f7c5ae already fixes for the RTL8723DU.

 drivers/net/wireless/realtek/rtw88/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 8786bbb421c2..4e110a457e71 100644
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

