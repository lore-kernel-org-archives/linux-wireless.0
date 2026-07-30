Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACFF2E738C
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391253; cv=none; b=kXn+NX2SRt6dj6fr4BXiD8fqutePIT5AHiL2lzPfky4+ZQBDuyFR5RDzow/qQiv/b1TEwN3mtzBwJxqujQWaWwM+Q80m7XTI5k6jjcrQzKi7GcP7UMvQFmMXWFTt/pYXc3fj2UZwd8KwXyP/UJ0rAugaxdQ3j7JlWtJfuBdlnac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391253; c=relaxed/simple;
	bh=sh0cK31CqP3rFU+JNVSzwAUoi6TTM7qyx/bj1IEU3gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mGe1FQ4bSm58IoVSaQON8u09SajMDN5cyOkTYUkwMbsY16z8QiK3yfPJxKi9ggwqLzHbzUlmo1dGKaZ4MoLkYbCeaMqG+wlM8UkpD7US/4Z0a9RbB2NO4kFNk9UA/wXfTicSc2QHOxtCmhvT+Ewj2NSozeDXhdURy4M0QWbv7Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VKhAuSjK; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VKhAuSjK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tgN5oBKicJ7KNhlJcF9OIXncn3QsGd64Tgwkels3ifI=;
	b=VKhAuSjKpKnL1T4YERVywD1BMlFnQjph9ogdSye8DwqWcG9Kbae5FIGWW7RJBQOC1E37s+
	ka6f6wFi48YluS7p6O1H+8jkLbOisyBTAedO1cKGzo2ZWicoR3PtBUX1/Oq5pwPMfD8dCP
	ifuGCvX4ghS+I0zxL23gIHPgo4LVwBw=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v2 2/4] staging: rtl8723bs: fix double free when register_netdev() fails
Date: Thu, 30 Jul 2026 13:59:58 +0800
Message-Id: <20260730060000.1944670-3-cong.yi@linux.dev>
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

