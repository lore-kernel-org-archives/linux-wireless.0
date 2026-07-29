Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54EE35294E
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291974; cv=none; b=iN3JnvERgnWbi6vGAmcuc+IHKt3+dKcWNJUKXKl8aZeO9bgpsCweABW8ODkUcWFD/4e9wkxeSL1VcPgyPUBY4fnxjSAvXoXAmkvJCwtzqTaNOWHpLcPUlRjw5h9Va5XnX6YvboIas5gjZYCAHwqt2lOJCVvPfeAEUG0FJv9pvio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291974; c=relaxed/simple;
	bh=anZdYTE6LO92KIpX3Bg7pdamIYmsZZL51JKIdVdQK0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CtONg9x92jAriY046LaNkYIpM9w8TQ7dFMS9FmO/HdFgyMR0nalnTvpUmT3FUwzzJa3Wln//RDi5eAoq483/TQ/Ax1eUoDeCK0h3MEPhIHYNg8Kmjr+Wo098LjMz/zfmFZZIrZwz3YM499/Zlkahi+jmzWeChbDSOGWZpa6VTJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PZ4CZjXV; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PZ4CZjXV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pVJcaDUVUpqpXUk2W5yqZXzQwkR9y7D8/eF6OH+plXs=;
	b=PZ4CZjXVElfbVHH1QonS7wLbP1sNygc0Fg7IxxZKXTt/uF9nfpbo6GYz+9lxuknJaciObm
	/lloZOxkT1k+8wwfMtAQANdpHdBG8uqf58Ybb8czjuLoALCnItHgHX/sHcQHUy8RBe4ZWs
	DGcyu9WkrCQagfcOgc8D0F/iN35v0So=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 2/4] staging: rtl8723bs: fix double free when register_netdev() fails
Date: Wed, 29 Jul 2026 10:25:07 +0800
Message-Id: <20260729022509.2863634-3-cong.yi@linux.dev>
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
 drivers/staging/rtl8723bs/os_dep/os_intfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index f31196f54b3e..ac401042faf4 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -773,10 +773,12 @@ static int _rtw_drv_register_netdev(struct adapter *padapter, char *name)
 
 error_register_netdev:
 
-	rtw_free_drv_sw(padapter);
-
-	rtw_free_netdev(pnetdev);
-
+	/* Let the caller (rtw_drv_init -> rtw_sdio_if1_deinit) release the
+	 * adapter and netdev. Freeing them here would lead to a double free:
+	 * rtw_drv_init() still holds a non-NULL if1 and calls
+	 * rtw_sdio_if1_deinit(), which invokes rtw_free_drv_sw() and
+	 * rtw_free_netdev() again on the already-freed objects.
+	 */
 	return ret;
 }
 
-- 
2.25.1

