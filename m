Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA937BE95
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391258; cv=none; b=A0qVCAO4p67LTOcOIrnDrbyaQL1y+AqDbjlI0zmIRmV9UnvJiLug6LQORcUbZhmY7Al0ZsULu4nkYEfOV4tWWTsHNfAi8738yPz+42O4wpB5FgK2IOeBbPYeyGD0i6bBtZAQY+0eH2nKaP5bm+v9QhDX6iWXBcXA+AkFzURTTW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391258; c=relaxed/simple;
	bh=ynMYypmn5ysbWiN30VtMcICo3hX6NAlQlQjdlWjI4qo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p9C4yI0pztL8oelj/AJGkswwmqgwIxyDf2hvhbvXRCpisxOYfNlEdGyWaQUAhmPsNfulysDLfSYilsDZPGa0fG5C+uF1CuZ4ZUKrQaNaJUgynLHeEMbyncGKnS9xVvSq51dJBpu72mxFbeXdKc1+P7RUHjPhaF+/PEmj3bXGuhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FMY0IwKl; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FMY0IwKl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785391241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fZaxHH3KnRE/0ZxJ2fFGzrck1ahoFs+0wEpIO4BVcC0=;
	b=FMY0IwKlb5U1OaKoUW0qtY0KChcYOtZukLmgR2AxZ3qTFOkYJ4TWLe4RyZDMphtjX+rs3K
	pnK405CsxAeOI7FyYvpslBiNMkr93DpYWpMwvrgQ0e7TBIgVXrzc5ZE4I8g8oUd+QKkvX3
	xIbENp3InKH+UdYwNP4OsFB75X2D6UQ=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v2 0/4] staging: rtl8723bs: fix several memory-safety bugs
Date: Thu, 30 Jul 2026 13:59:56 +0800
Message-Id: <20260730060000.1944670-1-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yi Cong <yicong@kylinos.cn>

This small series fixes four memory-safety / resource-management bugs in
the rtl8723bs SDIO staging driver.

v2:
 - Remove some redundant comments in patch 2 and patch 3.

v1:
 - https://lore.kernel.org/all/20260729022509.2863634-1-cong.yi@linux.dev/

All four are tagged:

  Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")

  1/4 - kfree() used on a vzalloc() allocation (HalData) in the probe
        error path.
  2/4 - double free / UAF when register_netdev() fails: the error label
        frees objects that the caller also frees.
  3/4 - NULL deref in c2h_wk_callback() when the re-read allocation under
        memory pressure fails.
  4/4 - NULL deref on a bcmc station lookup in the 802.11 defrag path,
        reachable from a fragment with an unknown transmitter address.

Yi Cong (4):
  staging: rtl8723bs: free HalData with vfree, not kfree
  staging: rtl8723bs: fix double free when register_netdev() fails
  staging: rtl8723bs: fix NULL deref in c2h_wk_callback() on alloc
    failure
  staging: rtl8723bs: fix NULL deref on bcmc station lookup in defrag
    path

 drivers/staging/rtl8723bs/core/rtw_cmd.c     |  3 ++-
 drivers/staging/rtl8723bs/core/rtw_recv.c    |  5 ++++-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c  | 14 ++------------
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |  2 +-
 4 files changed, 9 insertions(+), 15 deletions(-)

-- 
2.25.1

