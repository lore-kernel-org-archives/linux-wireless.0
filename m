Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32A37BE7F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291976; cv=none; b=N7PR01NVLau5d2h5D4PsTNzpRXRU1r/YITlW1OJFu08H+ePkOTwIVIC8HjWKbZyVM8dJYY5Y7XAJXvnHz+4HqTaprNSF7QxKjMmFtEE4fEezxOJj66yWqP3HwYLeXsG6bJMqOol9kyM95ypm+2pOjLi9hjZ4EWebxkYsB5Ntzgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291976; c=relaxed/simple;
	bh=zF6YoE/yBdmKDJcc3SJ0T7je2ZUvt7AGbg3abjei0oE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gb+9Mz4Du3JBNn7PvcHGGlOWJlpGDjzeW9zdEZkp4I9NveRqWcyXLCDcFy84FCkGuV+sWY5/WZbPJyYmdyoK/GqZRPgh7EG1M6xHvszBYIgsMl/xazRaAMP+4miWRASj8dpa/v74Nux57KPFFvbD/6XMwUL8riDy7vtglSg9vSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d8j36hGT; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d8j36hGT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOww1CW2gzlfykDc+YZA1H6ylSC0vfFwHkzPaFviuRE=;
	b=d8j36hGTfIQ5FJmTMT9lOWJetol55Y0FzGukV2DJB0+a7F6rcVVQnHfy4ObbQhwsz6Wvob
	6RHYCdSRskxeoh09GH8ItG4X/NsDjwSsJrTdUmrsBY7MTmqGE6Uj6EtH/UpYyCeU6cy/do
	jgZtLkqvroWWxwmZt5U6OCGNquHlGyE=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 3/4] staging: rtl8723bs: fix NULL deref in c2h_wk_callback() on alloc failure
Date: Wed, 29 Jul 2026 10:25:08 +0800
Message-Id: <20260729022509.2863634-4-cong.yi@linux.dev>
In-Reply-To: <20260729022509.2863634-1-cong.yi@linux.dev>
References: <20260729022509.2863634-1-cong.yi@linux.dev>
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
 drivers/staging/rtl8723bs/core/rtw_cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index b932670f5d63..8dc700b9f2e9 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -1716,6 +1716,12 @@ static void c2h_wk_callback(struct work_struct *work)
 					kfree(c2h_evt);
 					continue;
 				}
+			} else {
+				/* Give up this event; re-allocation failed. Falling
+				 * through would dereference the NULL c2h_evt in
+				 * rtw_hal_c2h_valid() below.
+				 */
+				continue;
 			}
 		}
 
-- 
2.25.1

