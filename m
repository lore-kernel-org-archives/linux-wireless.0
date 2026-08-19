Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F03D6CD8
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124463; cv=none; b=K92v16hRyBWwgZs3J+eJgZs2MGSgEYJNt+a+rtyeyiGOw6yElhQe9qgm1i4N+0a/nrhOlsMkKQvH7bPyR6a1R10hFCynxPkdmSoWnviHZIFBvWKzvH1cqsr4SXr/xNJaIif3l8y6iZ4chxiglpEZPUaDXoDhFJ+Y7v6r5jrQJqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124463; c=relaxed/simple;
	bh=luoyv6Yy5hxUmWWX3IpwtUJB1/H2TrfkJauwBOFb+c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkLm9JvjrnXwJ27V92wo/sM96mQihTrPq4SSTr/A1a44xWpQ/ny5eZAM+s6zOMSwGbXZwpKwU0x+uxpiMIrCBFYGRMd7z+aE9ec0g0Yc/1hf8W7yC9UqwP6Mfkfk4ZtBiGwla34YE32cETo0IKaLRvy6yGj3eNC+YtDhqK4Ve3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=juWSk/Pz; arc=none smtp.client-ip=91.218.175.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="juWSk/Pz"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=luoyv6Yy5hxUmWWX3IpwtUJB1/H2TrfkJauwBOFb+c0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787124459; v=1; x=1787729259;
 b=juWSk/PzzKLZDZuFPUlhQrmBWFepaJ0Xs5PMPog5yvOfcnjE4whep1u+45QC1oWWpOEryggJ
 aXVKuqKUMiJQ66/PJWtiTd8+JE4IEliLjC4tSpCmO3ZYzzn5wZ+tpn2+qMfXZl6kQPnxlqyxszx
 yVq+tEcUf/LhFJuzfWTjdN2s=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id ae8ff4eedf61a9e9;
	Wed, 19 Aug 2026 07:27:39 +0000
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
Subject: [PATCH v6 3/6] wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
Date: Wed, 19 Aug 2026 07:27:14 +0000
Message-ID: <20260819072717.22648-4-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819072717.22648-1-luka.gejak@linux.dev>
References: <20260819072717.22648-1-luka.gejak@linux.dev>
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

