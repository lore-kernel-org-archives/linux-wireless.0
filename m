Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E30388E6E
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291978; cv=none; b=at/PeF81ZpAjhGpI9jR5B1KIqqzF11D/0FzcjVm4NSXX9mgzz3+7GYgHWdZhwhehrE9VUSSkett0K5Ve5pMbvITEJkovDOSNpVRKlXNAFQwfdEjsiPfijjTJDiX5HxeoKGHlk2FS26evRpdEuG08pNA42UJ3smZm7i9B2AYPNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291978; c=relaxed/simple;
	bh=0RFhXtuij4YBbpC1GMYgiFrjAG/walVSS6JDkvCEgDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QQi7Ag3KrI4qokQEuTBbNeNDh1dcrCpBUAWvaOvPiht5Og0tV5bCX85O21EItbJZ1kPvZIduOOdQUB0q8JtXDd3QttcH/8WYhxLshex/gd0SSSCXlzp2t6RTKJRbM+cz21Bj5Yk/zw/o71zpuGS2YDhx4nDY0A7F+TyugqMgBNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sZQGaefc; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sZQGaefc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXpTGAzYFF9ox6b7v63Hc44Q/WHE4k8yGW0XTSCrH6c=;
	b=sZQGaefcJCtfYFh/AnQBw7GbzincGQafG9lqPWr4UX9/F5RJW8pJH7YiPS5ROQu/gOKsCa
	+sSwTSFblQD8qEJMe5mwWkiYp92g6D7Xt6Lf+Of/dEKPmakS99uEAfYyqI6HoOPYpe/xhD
	q/OACKqjh/aF1kKm5yzqD1NtNU+++EY=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 4/4] staging: rtl8723bs: fix NULL deref on bcmc station lookup in defrag path
Date: Wed, 29 Jul 2026 10:25:09 +0800
Message-Id: <20260729022509.2863634-5-cong.yi@linux.dev>
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
index 86c5e2c4e7dd..ffcee431caf5 100644
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

