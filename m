Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB7A35E95A;
	Thu, 13 Aug 2026 08:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609409; cv=none; b=NG5c2iqeV3lqnzE7zfohwn2Qv2+rkfrffpKunWZkF7LXI/Cjrd2beHyMJoXasFSre9bN5wSIzxNl4PvHn0zF/Y0lULcy2YYmHPGb30tf/JV1G0i+b1NmGDh8eMD3M2n63GFVeQYWNRNcqqAiDmZK6+Go1sStH0j88m0Zp8AF1g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609409; c=relaxed/simple;
	bh=GQGBzA4KIDt4hlyTepBRMKquSzlQ+NVAQGuJjH0ldfo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kVPsg4gIK48hdRJPd18F+g/MBSFH43GGZ1GUI0hiaANl/RnZMQR4I2AMntxS3Xlp+fSNCn+cKPYaiMC5NHp6vNqreyvqGXn35lNM7SJiGFk7jD/xqezd+i589Q0rhpwV77vWpyfy8n46UozsBfABvMRX3gBmTKumNseor/VhjW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3dd447ae96f011f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8dae6a3c-55e1-4995-8b58-92b04efe1c40,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:41b4b50ac0508f95b3bca86d90f9cd39,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3dd447ae96f011f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1548865638; Thu, 13 Aug 2026 16:23:19 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 0/3] wifi: nxpwifi: three fixes mwifiex already made
Date: Thu, 13 Aug 2026 16:23:12 +0800
Message-Id: <20260813082315.1390321-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi was copied from mwifiex before it was submitted, and some of
the bugs mwifiex has fixed since then are still here.  Each of these
three is the nxpwifi side of a fix mwifiex already carries; the upstream
commit is named in each patch.

Patch 1: a running wakeup timer callback keeps using the adapter after
it is freed (mwifiex: ae5e95d41574).

Patch 2: the A-MSDU buffer is leaked when the RA list disappears in the
middle of aggregation (mwifiex: 990a73dec3fd).

Patch 3: survey data is reported out of memory that was never
initialised (mwifiex: 0e20450829ca).

The three are independent and touch different files, so they can be
taken in any order.

Found by inspection; there is no IW61x hardware here to test on.

Linmao Li (3):
  wifi: nxpwifi: wait for the wakeup timer before the adapter is freed
  wifi: nxpwifi: free the aggregation buffer when the RA list disappears
  wifi: nxpwifi: zero the channel statistics array

 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c | 1 +
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 5 +++--
 drivers/net/wireless/nxp/nxpwifi/init.c     | 2 +-
 drivers/net/wireless/nxp/nxpwifi/main.c     | 4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.25.1

