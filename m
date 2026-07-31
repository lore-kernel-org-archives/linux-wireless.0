Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E612FC893
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785460814; cv=none; b=htALsey8wnIbMv84ETPJrQb8pmiz1AJmT9uhxvFlSB6oaDfx3mpRYc+Eq+76E5UzVl+riYFoyZxF+gCIaETY5zfxb0GRk9EgzlMAqlxQgApb3pn4j1d+nQ8q5ka2Fw5ecZH65f8d6HSRSpRQJIo/gwQiSJ2j+eL/ebBNdwJjjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785460814; c=relaxed/simple;
	bh=LoG0bdqXL4wgqkjyjzoeEjyxC/e0EeE0bXymfYfn8oU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uP1Ny0DhFBKqcxSbyGxWKaVETS2p7hUcJ7Eyi50ufGp9lfXwM3O0mvQwc0Kua3Pm1Mq3WeDl56p2WIpXLJIUEq3I6Q+/Pwxd59/XpAOadOAhozfMLyRQcaNOCZPFEooEA17TGKVZFLZYZUyBLC3ghZ9wONuPepRruXUol4YYr9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WYhRYOyX; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WYhRYOyX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785460791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FIvLm4LsJjWsjvnIAe9hEaYfWn2Fo0uuSJBsUPgXB+k=;
	b=WYhRYOyXdRXlVAhgfpLBNV5ElbmJDUoP5rd086fWesNy4cwxkOFLofLfmpMz9mAq//OjHi
	yYWX79ciiqfF4R55qWgTLdc1giMBn/beiFIueMq7WE3o87FEFB+i4Q9yodG5CjQ4Ov4rnp
	swPopqjvTWNKbPUtIUSUP/p1wxWc52k=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org,
	error27@gmail.com
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH v3 0/4] staging: rtl8723bs: fix several memory-safety bugs
Date: Fri, 31 Jul 2026 09:18:52 +0800
Message-Id: <20260731011856.2006363-1-cong.yi@linux.dev>
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

v3:
 - Add tag "Assisted-by" for each patch.

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

