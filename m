Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562CE345725
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391253; cv=none; b=iWJ4EHOa3EduQXWsv3smB07E0yQpaDAgGoP4z0TinsL9DMyvT7YJ/vlCJIoqAVStUkmnpC7/3o1PxMxCpPOV0I4OnnppyLH4vnhAs2uqwRE7qraav0qObw8Fqkm4WnrrFC7d9FAf4qQkY9dM3S5j8OZx7sajEg1Pat34EeMpSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391253; c=relaxed/simple;
	bh=q0K6xPitBfP2o3qY55auZdD3wDZ8n/mfadI4HL0mz7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rYFH5IVxWffpc4pBRtwGb2LfvOrew6/gVqmgFsnlXEgfS/vNJ6cOpZ/tO0vsyZYRXMVO9RTfsWjS6mZoitDxVn8nMT+VPAZD8n0hVHM7/gGeftTL0QIVPBjVKnxzqwPEJFJWjLCbyOQtHNCA9pkwIia+YzNIJmPeBg1TYnIU6eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VW/MluUR; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VW/MluUR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXy/0n/B70zi/oeUOj36XGnf9SFOTN7QKouBHoyJw/Q=;
	b=VW/MluURZ/HTzac3Rit+3Fb4JbEOzMInJMU2n3U37rHoRdpbv0rR+7dH1MxA5OzSrsbPQf
	JuJYdXhX1UjgYoN/gjXmmbNQD48c0sANMY2hx9il6RtU32Xo1F8O9hhV2VCFG0uj2MnK5l
	MSFsuio2n88tAnoJqx9d+ft7wM1cOTc=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v2 1/4] staging: rtl8723bs: free HalData with vfree, not kfree
Date: Thu, 30 Jul 2026 13:59:57 +0800
Message-Id: <20260730060000.1944670-2-cong.yi@linux.dev>
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

