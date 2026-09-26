Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490623ED60;
	Sat, 26 Sep 2026 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437760; cv=none; b=Kyc92q+lXVsPZ+scPBsjxqdx4IJCmPKO8WDzvjXWDOVRfEC5zbimHiY6qcB+LuSDjF7tzCjlhzHcMDv9AO+Aq6PjZx++1oE6O2Jp9mU7/aCbgtXb033z0KoanVRrpWhkqRUGj15A1rO0XjQwjsTjTtqCFWmPbzkIuCDTQXQ/6BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437760; c=relaxed/simple;
	bh=fIXEboZYjbeXwrBTDT8fDzoBrwlT9Y6G7a/1BdOU4ws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SlYGCCZ2ky8IGn95tWN14HHniy6a4qB0kRciYMZgcEjyb6zSNFS8oVFPmaTfkkmFLAgzL6N30EWJiYBeo2SBObBxukhy/4axo/sBQy6mhCkDYg0Ylb/6dWzXdAGSzsPn9JSOQMOm8dZV28FMosl7/Hcz5FzowJq7DtifF9kvTtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Ygh9xE04; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Ygh9xE04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=hQ
	SBijeCpBYLcmXHo8ZBtBfG17pFXPWD63/WDXYEp+k=; b=Ygh9xE04CCBs0hCRY6
	JuiFqoojNAsotCc8qxvUCesaXXFHh2wYpGewVDFhmj7kpOglz6F2GfSN3HsLHcXp
	Be2OHqsmhdNlyHWsuYAlInbDj5L1WIilNYtFC/Aqdz/Ime1tdGJLIbBJFybkayrO
	/upgxUPdoqFzw62a4C/HDycDI=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F4pL6bdqlpIIBA--.11355S3;
	Sat, 26 Sep 2026 23:48:29 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/5] wifi: ath10k: avoid IDR mutation during TX cleanup
Date: Sat, 26 Sep 2026 23:48:20 +0800
Message-Id: <20260926154824.75224-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926154824.75224-1-yaojiale02@163.com>
References: <20260926154824.75224-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F4pL6bdqlpIIBA--.11355S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr13ZF1xGF15AF1DtFy5urg_yoW8Wr1UpF
	W8uwsFvFy8Ar17Zr48J3WxGFn8Xan3Gw4a9rWDua4rKr1rCr10gFW5Kas0qrWUtFW5C3W7
	uF4Ut3srGw1ktFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piiiSXUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzg0WUGq36U0gjwAA3T

ath10k_htt_flush_tx_queue() walks pending_tx with idr_for_each().
Its callback calls ath10k_txrx_tx_unref(), which removes the current
entry from pending_tx through ath10k_htt_tx_free_msdu_id().

idr_for_each() keeps radix-tree iterator state across the callback.
Removing the current entry can therefore invalidate that state and
make the remaining walk unsafe.

Use idr_for_each_entry(), which starts a fresh lookup after each
callback.  The current entry can then be removed safely, while the
following idr_destroy() continues to release the IDR itself.

Fixes: 89d6d83565e9 ("ath10k: use idr api for msdu_ids")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index e46f579d745d..9993c5a2f96c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -535,8 +535,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 
 static void ath10k_htt_flush_tx_queue(struct ath10k_htt *htt)
 {
+	struct sk_buff *msdu;
+	int msdu_id;
+
 	ath10k_htc_stop_hl(htt->ar);
-	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
+
+	idr_for_each_entry(&htt->pending_tx, msdu, msdu_id)
+		ath10k_htt_tx_clean_up_pending(msdu_id, msdu, htt->ar);
 }
 
 void ath10k_htt_tx_stop(struct ath10k_htt *htt)
-- 
2.34.1

