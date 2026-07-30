Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D3C2C8
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391255; cv=none; b=hYZbH8S1R/6chUiopZDBJe4lY+REqtRi3r9xEU3rV8AFu6rkLSUu2KwOZO6Qz3yAj4yz+03VgkTAm6j8yVn58LubVFhIqOzL/w2/cb0EZ/xtcL/IJedLDStUvYOU04cckJrWgVwp2rbkc5oPLEvo5VHakkeA3slUf6ObzEvS7HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391255; c=relaxed/simple;
	bh=f46phlbJp4xOCbYm0Rz6TMa0h9MPOPUwcjUWCOtdlbU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A8LR1sIb22ikt3wjYP/qVRulZR+WQsgKMxFU6lJ/iG/Q1ybmPgHiG0WCxbz6rFaIhTxgYfjD2tUrWoc3CwfltRpJ8vEqMRS4d+dGrPYcn/qk0BSq5yNjFM0jxd32NtsTbvUCEyzj4kmbAguN8oKRr3y7esLjGWyls8Gi8aqw4gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xEDN0djb; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xEDN0djb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pEOlnZk1zo3OWh1B04mzdNRV4W0dMMt67+s7CACH6g4=;
	b=xEDN0djb6C4Nehe7X3IM0i9g8eZq//ahG6YPpBrmknDQBzyqthE3oewTjfdJmSGMA6Z6Xx
	0vSWM4QPk79LrAfOYfQjUUtrNLDNrSpQIi0xdGs5wswXrC7zED35W2hdVFexVgVb5LCt3V
	XvSXwGBMbLFSxmGqYFS/iuiE8fUS2n0=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v2 3/4] staging: rtl8723bs: fix NULL deref in c2h_wk_callback() on alloc failure
Date: Thu, 30 Jul 2026 13:59:59 +0800
Message-Id: <20260730060000.1944670-4-cong.yi@linux.dev>
In-Reply-To: <20260730060000.1944670-1-cong.yi@linux.dev>
References: <20260730060000.1944670-1-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yi Cong <yicong@kylinos.cn>

When the SDIO interrupt handler cannot allocate a c2h event buffer
(GFP_ATOMIC under memory pressure) it pushes NULL onto c2h_queue as a
"needs re-read" marker and wakes c2h_wk. In c2h_wk_callback(), if the
re-allocation also fails, c2h_evt stays NULL and execution falls through
to rtw_hal_c2h_valid(adapter, c2h_evt), whose underlying macro dereferences
c2h_evt->id, causing a NULL pointer dereference panic.

C2H interrupts are produced by firmware/network events at runtime, so this
is reachable under memory pressure. Add a `continue` in the re-allocation
failure branch to give up this event instead of dereferencing NULL.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/staging/rtl8723bs/core/rtw_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index b932670f5d63a..e9b1136dbf668 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -1716,7 +1716,8 @@ static void c2h_wk_callback(struct work_struct *work)
 					kfree(c2h_evt);
 					continue;
 				}
-			}
+			} else
+				continue;
 		}
 
 		/* Special pointer to trigger c2h_evt_clear only */
-- 
2.25.1

