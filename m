Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD4247291
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785460803; cv=none; b=jq5DvTk22J8gzuVDFjLJNQeJmr9q4fpiuKhsYwFwhKqHKLXyRQtm9RgBv21rKUe8k+Sh9vgq3nlF6hbuKSfNOV7XN7MIk9XGxLae885AD9RQ+5FIUSMHndyaTAkzJzvEx6rWmZw0NDPBuiO2JgUFNImzWrOmzUoI3jaRoRQCW4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785460803; c=relaxed/simple;
	bh=FcgnHvf/nf59EDdmbipZWrJ+c6ayLiiQbkljh42e7Uk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jdJDtBQeu3ywI5ATe4XZqrBXuZZwP4KkRRdCM6M0k9YonKzFZtb9nAVfoSdFHGLjsaQ44FnHNDJtPMldLAnK9DxxQDBeAEhWIdKD9CuRx6w5OJ/ytjawoEv8Gn+4Ngoi9fYlw3kiE/ImR0/3WfJ3yoBZTuwo+t+pa0fhXGn2SLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OTxZn8Lq; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OTxZn8Lq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785460798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Afs96YJEbYAMJtEzntjOA/OwDoHOu0CZXDKx9MAXo9I=;
	b=OTxZn8Lq0aziEnqr/IMeKvehXIUKesnM/ZXg1NIFMyL9NLWagGZUpcTjC+SgHZHFwjQh9x
	nLUTQAc1IgPi4zWG7jJlFihSGKWcOS0yulB+7gQs/v+u/oWlgct6lSNsiCaL5jgk6+UMJp
	6giZCcB2SnsuGUNmvS1mR4hrwBJqFp4=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org,
	error27@gmail.com
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v3 3/4] staging: rtl8723bs: fix NULL deref in c2h_wk_callback() on alloc failure
Date: Fri, 31 Jul 2026 09:18:55 +0800
Message-Id: <20260731011856.2006363-4-cong.yi@linux.dev>
In-Reply-To: <20260731011856.2006363-1-cong.yi@linux.dev>
References: <20260731011856.2006363-1-cong.yi@linux.dev>
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
Assisted-by: GLM:5.2
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

