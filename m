Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D22DF6E9
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785460800; cv=none; b=rs/1yztlkM2zwPTznUx+jFYzbCiTrIqCrf/MC8lQi1lB8AEi/Zi2vPzBxe43wkN+VFwGAxnvzxYsA5Kl1zb8FmGEueDhnABqSh4YINW+you/+daK2RrpUeVGhQLNvuJSLz9v+Q7CqsqU8kzvIO0MgGRMzwKd2aDoh7mDg/UNiPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785460800; c=relaxed/simple;
	bh=lzpp4ZcV7xUZM+OdKpDiqol9PIFFFRauowiqPTQ6PBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tJzcE47GuOaA0ukyqsRkqgs0p/DDPmmvZCzzUayb0563ms9q1Cec6GN1QAcVXdLXdQt2Gvy6QX4V8yM4SXcZUlZ90I1mJiH/u/2ioAaUMMN+5dQBd0AyD8li5OfmvkmpbMuM2E+JNJMe9SjMJcbwFet/518WjtRLytlFRd+7G7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NG4fY7AF; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NG4fY7AF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785460795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bMElUg5mvhcb74SmfnOIwi6H8mT79uJYk5mlABd+2Nk=;
	b=NG4fY7AFGJBXXI+wIqj3vEXTAK3PV7MR4lzUrdyHo1u2kIfp1Y1IBEhGR9WbPDG/+uX1SY
	28i04SlotD9ZbfCXDkz0H14OJh+2q7ZxH5YHDR9QNYJq2CFOq3iO3/DMvL+qqBtfpC0obs
	yFdCh76yrgaGHtWxnIyTpC/rIuAFF3I=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org,
	error27@gmail.com
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v3 2/4] staging: rtl8723bs: fix double free when register_netdev() fails
Date: Fri, 31 Jul 2026 09:18:54 +0800
Message-Id: <20260731011856.2006363-3-cong.yi@linux.dev>
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

When register_netdev() fails, the error_register_netdev label in
_rtw_drv_register_netdev() frees the adapter and netdev via
rtw_free_drv_sw()/rtw_free_netdev() and then returns _FAIL.

The caller rtw_drv_init(), however, still holds a non-NULL if1 on this
failure path and jumps to free_if1, where rtw_sdio_if1_deinit() invokes
rtw_free_drv_sw() and rtw_free_netdev() again on the same already-freed
objects, resulting in a double free / use-after-free.

Drop the freeing from error_register_netdev and let rtw_sdio_if1_deinit()
perform the tear-down, which is the single owner for this path.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Assisted-by: GLM:5.2
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/staging/rtl8723bs/os_dep/os_intfs.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index f31196f54b3e0..84633a51e2db7 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -754,7 +754,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 
 static int _rtw_drv_register_netdev(struct adapter *padapter, char *name)
 {
-	int ret = _SUCCESS;
 	struct net_device *pnetdev = padapter->pnetdev;
 
 	/* alloc netdev name */
@@ -765,19 +764,10 @@ static int _rtw_drv_register_netdev(struct adapter *padapter, char *name)
 
 	/* Tell the network stack we exist */
 	if (register_netdev(pnetdev) != 0) {
-		ret = _FAIL;
-		goto error_register_netdev;
+		return _FAIL;
 	}
 
-	return ret;
-
-error_register_netdev:
-
-	rtw_free_drv_sw(padapter);
-
-	rtw_free_netdev(pnetdev);
-
-	return ret;
+	return _SUCCESS;
 }
 
 int rtw_drv_register_netdev(struct adapter *if1)
-- 
2.25.1

