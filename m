Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7629D384CCA;
	Wed, 29 Jul 2026 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291978; cv=none; b=YACDs6xOx2gJNZfCRj383njU0s/gg7Y1ms+1Lr4L8gg5FIjC0zA/s0slnMKRee9xOrD9jlsBz2rkMDo4U6S3lpe5ZV7vF7Jzj9pWEdI1fUHLnWI8UM6aoMeOkrYS7gcv49x943ndfBgXIAjWWM+QgurJkXtsXhZIUcVnZWn+uRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291978; c=relaxed/simple;
	bh=wVe5+mn5qO+xX7gOPjL/cKVzya3+/hzPWH/ttH6sEEo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZzBt6ORxKexOrhlek67tEpGRrFBAfqwQLoCuPVfFLfIGc6MrBoBG4tTdQtwzgNNriyU+4/hayMkXxEGBwDbk9a9b80O4QQW9JMHP3oOCQHGtLSmJF21jOt2oyr8FxGaGC26+lDC1iWuYDuX3a9RPHT58Va2XziHQno/p/mV4S34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pZg9G1Wo; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pZg9G1Wo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QRTVVf8d7Axz/S3rNeJ+7xMa1Fbg7NLzg3mU1f2ku6Q=;
	b=pZg9G1Wozqlai5t0Za8hrFmM199IeBZ7NhLOYQZIWxi0r2NJ3TfgaASAwbFd3MWKZt0edS
	4ZOjWpQRKOI1fE8erg8q++nLC4Q6heYMkq6Mhg9B0vaNCvNV9naJKrOFSbKVMS2cR95NKT
	tkzbXQvmOMVswE6bpz+hIdElmjdzc1g=
From: Yi Cong <cong.yi@linux.dev>
To: gregkh@linuxfoundation.org
Cc: linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH 0/4] staging: rtl8723bs: fix several memory-safety bugs
Date: Wed, 29 Jul 2026 10:25:05 +0800
Message-Id: <20260729022509.2863634-1-cong.yi@linux.dev>
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

 drivers/staging/rtl8723bs/core/rtw_cmd.c     |  6 ++++++
 drivers/staging/rtl8723bs/core/rtw_recv.c    |  5 ++++-
 drivers/staging/rtl8723bs/os_dep/os_intfs.c  | 10 ++++++----
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c |  2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.25.1

