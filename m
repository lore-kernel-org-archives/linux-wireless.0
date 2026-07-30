Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C843630B5
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391255; cv=none; b=JmF/siOmw6EBWYaZSA4B4UuiD7JLeB+qAmmX7d2dBFB2PSges1TTrD7gubQuW/iCk2yUkQHg4pO+/xx9H2y6vWZu5Ezefo38Hx1Z4JSLKaz0uPIYUTO0Hf52FH7Qdjsf0FIZQBCauLmiECqUBYN8biNR96klvoho32FTDdIlWB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391255; c=relaxed/simple;
	bh=+04D/jzlHxdaNslMwuSL+uXX1drym0bcb86zwcd9/pk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gi14BqZZ8tQHWDDtdw9QW3jfaWmzu82HCco/2TV8fq4IA8OSI/gX2gghpkg5N430obHBzP+VTj5AS2YuqnTrNYzN12tLWEIg5hqdcn3kuUwHaFkcyELt12yDLLYOaM0UdJmnx5SLK2GGy59ijZU6Cu1QEe4HAGgs+OF3nUKnRqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ftFa2HPc; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ftFa2HPc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=likSpT8dCQMy960HkROJciAORjvgwAGoV5V9YdtXq2c=;
	b=ftFa2HPcGN7k7KNtNBWzDCrL6zjankTiFZaQ1wUHIcrPaq83cHmeOosJNxu1KzRBIpQfZK
	nV6H0ufUYYaVzPl9/78b/5RJkdIq1RsAy78m/OiiJ4QGxbha4SHqtw17h5ycaglS1yw3OU
	SS7sD2iQKgktjiPJaH1jLWMIbZSXTlI=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v2 4/4] staging: rtl8723bs: fix NULL deref on bcmc station lookup in defrag path
Date: Thu, 30 Jul 2026 14:00:00 +0800
Message-Id: <20260730060000.1944670-5-cong.yi@linux.dev>
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

In recvframe_chk_defrag(), when a fragment's transmitter address is unknown
(no associated station) and the frame is not a data frame, the code looks
up the broadcast/multicast station with rtw_get_bcmc_stainfo() and
immediately dereferences the result to obtain defrag_q, without a NULL
check. rtw_get_bcmc_stainfo() (a thin wrapper around rtw_get_stainfo())
can return NULL, for example if the bcmc station has not been or is no
longer allocated.

Every other call site of rtw_get_bcmc_stainfo() in the driver checks the
return value; this one was missed. A fragment with an unknown transmitter
address received from the network (e.g. an injected/rogue management
fragment) could thus trigger a NULL pointer dereference panic.

Check the return value and set pdefrag_q = NULL when no bcmc station is
available, consistent with the adjacent data-frame branch (the later code
already handles pdefrag_q == NULL).

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 86c5e2c4e7ddd..ffcee431caf55 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -1146,7 +1146,10 @@ static union recv_frame *recvframe_chk_defrag(struct adapter *padapter, union re
 
 		if (type != WIFI_DATA_TYPE) {
 			psta = rtw_get_bcmc_stainfo(padapter);
-			pdefrag_q = &psta->sta_recvpriv.defrag_q;
+			if (psta)
+				pdefrag_q = &psta->sta_recvpriv.defrag_q;
+			else
+				pdefrag_q = NULL;
 		} else {
 			pdefrag_q = NULL;
 		}
-- 
2.25.1

