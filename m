Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30862F4A05
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785460807; cv=none; b=TcRYUfFV2Ysg1/dMpjplHb3lD6R5KspZTOqkJYHokQGrlk4CJ21AtVbyFffn1j8vpLZnvKCzwwh3EU2lHfZB4fU/2uuvTS7IJFPTdOEZRaxgAG6FJmuY1deMuBlOpFWk18olJuzr/E6MNpGO6QKtdP2PxiIm8Dhkfw8RTxkYuXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785460807; c=relaxed/simple;
	bh=/1G65/0RGWqgYt6TvQ0u8uwK//Jr7KOjKUmITCD2xpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IAKT61xM9NzrljQG6hhXUC8LSONtv5EUw+SqIQdtG1iu+zWy/u8ZJjNWsL3iGSpXaM1ycoXy0blrjXWBIKweF53RcYKamejjMQVaN+XPoN+FHNek4T5PlOtSxwdxaM3T8kHvy9dG40mHyTp+RHBredhN7r0LkiwLn6nW5NBSsq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V34RUJJq; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V34RUJJq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785460800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1SjDezo3u50GFBkzPXvGQqu6t8Eum3WQXRXk4DRobfs=;
	b=V34RUJJqI2WzEzM5jycvNGBPqDWtsNDpx/jqdhrY9CaenAV/W59klc1KZywkNImrB8EFZp
	exRrl6cW67f4CdV6ZGB8PBNY8GtR+UmhHexWVwi0j9Aht34owXtrErKm7/1Q0sgocH4uf8
	OvNq5ACRx3gRb5qPXUqOQ/BkzgaXaUM=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org,
	error27@gmail.com
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v3 4/4] staging: rtl8723bs: fix NULL deref on bcmc station lookup in defrag path
Date: Fri, 31 Jul 2026 09:18:56 +0800
Message-Id: <20260731011856.2006363-5-cong.yi@linux.dev>
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
Assisted-by: GLM:5.2
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

