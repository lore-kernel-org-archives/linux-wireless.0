Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA8C29ACC5
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785460798; cv=none; b=VFme5llzLmfr5b8J+N0u8VVa2zxUI5Z/lZb2hbw0YxuzbA68ZuYEjv/d5W8xZlx2NK3GB/tjV4wGD2ksP80XCAk8T5kesj0zfoZL3RICQVXgWV+uLvUNHLBWY1w088XYA3FFcL9W3cXD9DUCu2xQEmOSjaO6SrsVZSG+PaLACjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785460798; c=relaxed/simple;
	bh=47e8b0WdNaEk4DooyC6qfw7+a4EBXQUIyJCmrzaFF5A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LtmuQMvkW0T82nShNHdSzhjH8XBSd56HZtjFUHoxJ8AQZC2I1jpQ9siBtqfdZkrdQtS9fOcKuq/vvRVwFRh8aIv5943nnzSVTsSa+/d7QCSLwqa7gvUsGKpF1u6bGWqR1IKS3KX3z8ZVMNYUpr/Jzy2WU22Rgu+hlwfNDja5m7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gTG3Sioe; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gTG3Sioe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785460793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wXHPrSho6azgZZFSVUejZWoRGeUy3dDCZgU8B46t7FU=;
	b=gTG3Sioekhliqb9ChSprbt7Dkp14qN/JzvJmI52pEsnJrF8lwEb2aWMxAweZEbuRSXTFCv
	eMRVTHUC/tqHtnwPwLrCouppJRylm1tpO+eLjDi7BOL0ataYGH1SJyRKyd0+oICp8crjoz
	3Lu/QjqxaBJAI3zUhDN6KbliqOhTdoA=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org,
	error27@gmail.com
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v3 1/4] staging: rtl8723bs: free HalData with vfree, not kfree
Date: Fri, 31 Jul 2026 09:18:53 +0800
Message-Id: <20260731011856.2006363-2-cong.yi@linux.dev>
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

In the probe error path of rtw_sdio_if1_init(), HalData is released with
kfree(), but it is allocated with vzalloc() in rtw_hal_data_init(). Freeing
a vmalloc allocation with kfree() is undefined behaviour and can corrupt
the allocator.

Use rtw_hal_data_deinit() instead, which calls vfree() and is the matching
deallocator used on the normal tear-down path. It also NULLs the pointer
and clears hal_data_sz, making it safe to call here.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Assisted-by: GLM:5.2
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index c43a0391a5ca7..f7ec09310ce98 100644
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

