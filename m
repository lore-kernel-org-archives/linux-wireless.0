Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D8D54774
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291973; cv=none; b=SoukW3QKx2nHS3y2/1w3jaT6PLU5igLz1janpxDx959gMI1nn288CSG/d16HWzJlSLQk3zJfYd/KiRTPG6QkSKHW7A690IAtpeUyhjQdS21IwzQdRxHXgiUypASgJukdwaY3c2W+CG0sZI7PD7ydvWcHI0TUa23dvsqUAGYsG1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291973; c=relaxed/simple;
	bh=rJ5gkuJJTCWKhczkEk71zfPFb/fRSECE0TBf+zAQPaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q0hONIvZWFOfoh1jC6i+ZmTlTPQxxFJwIDptAARwOpGrZvdXg4OEX10ViwMWCF10swzL0CWnPlDjrtcQpqgRid62KowxG1qL7SJSBPNnPubK/qCwZMHuuiAE08blWUgcRDC7YQz3yOMf9XKYHyYjq9SMS32Of8gIEJbH1zH+dRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NV9FBrbx; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NV9FBrbx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pic5dVPEn0Kcm/eA5y2w5lDa3uK4+vPtXmqUgqeF360=;
	b=NV9FBrbxvFPr0jvY1tGePPi8RAdJJ7oVR70bizwH3ttaVSqAaob7Ef5CAsNfB1BAi7euRG
	eSuqlGMj8/v6UUDTNYnsWZzmNS1RMhYZYDJvUcuLwVSZ70g8A2u4ZWUna5qQ6LOMZMS5Ft
	h7w59obZm08QnDR6Fqk+cSvJ1A5oJUY=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 1/4] staging: rtl8723bs: free HalData with vfree, not kfree
Date: Wed, 29 Jul 2026 10:25:06 +0800
Message-Id: <20260729022509.2863634-2-cong.yi@linux.dev>
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

In the probe error path of rtw_sdio_if1_init(), HalData is released with
kfree(), but it is allocated with vzalloc() in rtw_hal_data_init(). Freeing
a vmalloc allocation with kfree() is undefined behaviour and can corrupt
the allocator.

Use rtw_hal_data_deinit() instead, which calls vfree() and is the matching
deallocator used on the normal tear-down path. It also NULLs the pointer
and clears hal_data_sz, making it safe to call here.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index c43a0391a5ca..f7ec09310ce9 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -286,7 +286,7 @@ static struct adapter *rtw_sdio_if1_init(struct dvobj_priv *dvobj, const struct
 
 free_hal_data:
 	if (status != _SUCCESS && padapter->HalData)
-		kfree(padapter->HalData);
+		rtw_hal_data_deinit(padapter);
 
 	if (status != _SUCCESS) {
 		rtw_wdev_unregister(padapter->rtw_wdev);
-- 
2.25.1

