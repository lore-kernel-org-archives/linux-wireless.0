Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CEC363C7A
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2026 07:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772177902; cv=none; b=oKe1zciFqU/8CkDzQG1h9GbL/cyckoKfJXywMnq64QKb8Hf1gkwg/ZPGno2mRvLN4RgoX81RlB1zz1EZhy1sRPR1q92UYrFRQyGNFMmhkB8cf62LwnsqCnFyvP2heEblZcM77VmYKSvfDFkppRhhH2YXBrlniez2Hns7+0jjEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772177902; c=relaxed/simple;
	bh=qEHEtWPTwEjx/rM2rwD8jxpopdIrFkr/+largJvAUfE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sVqM7awQZEap63uqnZcTnfLozW6Nx9y7zgn4cLiywHE2R7ZotGWG9ztIhDxPLExRczlrjGS+O9ZROfEI5+j03hmY9mTLhpKmyO5s9mjXv4KiJWKCxui4tSdx9RyZhIkWks+uakB31iw/cgwvSlJFuYRLx/G6lA1r+haYgV3hTbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EFi8bHPe; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EFi8bHPe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772177888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n+hAzO5R+G/H97tmPTKTMopAqg3gqO06j1bC/uSM2nw=;
	b=EFi8bHPegC39fzi14igvOY+6+vpmAxHH8rmnSWD84ZOYiEHhYXb+Iv6IGJ3I0wSRkvkW4E
	pl2AOZbL9kcLGcdr2CjKyePNcOVKQYm/h+cZGo0n0oDQGovT173hDKGhnAsbZX8LV2QHWQ
	wCc4QxD2JB4S1cnvKmZLHZO9bYZeq8I=
From: Yi Cong <cong.yi@linux.dev>
To: Jes.Sorensen@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtl8xxxu: fix potential use of uninitialized value
Date: Fri, 27 Feb 2026 15:37:08 +0800
Message-Id: <20260227073708.508772-1-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yi Cong <yicong@kylinos.cn>

The local variables 'mcs' and 'nss' in rtl8xxxu_update_ra_report() are
passed to rtl8xxxu_desc_to_mcsrate() as output parameters. If the helper
function encounters an unhandled rate index, it may return without setting
these values, leading to the use of uninitialized stack data.

Initialize 'mcs' to 0 and 'nss' to 1 at declaration to ensure safe defaults
(MCS 0, 1 spatial stream) are used even if parsing fails. Note that 'nss'
must be at least 1 to be valid.

Fixes: 7de16123d9e2 ("wifi: rtl8xxxu: Introduce rtl8xxxu_update_ra_report")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 794187d28caa..d0035960f8d4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -4820,7 +4820,7 @@ static void rtl8xxxu_set_aifs(struct rtl8xxxu_priv *priv, u8 slot_time)
 void rtl8xxxu_update_ra_report(struct rtl8xxxu_ra_report *rarpt,
 			       u8 rate, u8 sgi, u8 bw)
 {
-	u8 mcs, nss;
+	u8 mcs = 0, nss = 1;
 
 	rarpt->txrate.flags = 0;
 
-- 
2.25.1

