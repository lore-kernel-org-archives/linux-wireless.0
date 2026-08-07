Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33721469839;
	Fri,  7 Aug 2026 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109172; cv=none; b=l3wUGocstlHLBH1SqFJvtexpm/GAmfMFNF6dG65cy/Tj4PvPJDOVReT+Xud3v3mNjG1GDCOTL/awFFg1ZcGP7P/rjUtMDQS/NMFYYX8NVvuh5lh328D/2+8bNsJkXGgbvM8xr+8cW9Lf/MrGQjyuwLxi/r0x/vjNOi+F66WxuYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109172; c=relaxed/simple;
	bh=B8EodOW6yHcp8s6jCbqPZ4AtXSCjfCUi+TyoHkdW1Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gs+qTZlAyYsbkc5siU4PN8ZR2/m1mxUx2kSeSpPk97E2V5CAC90QQq1cxGDxFJphEPHCAili79NiIVu4OaTlweeoGheF1ojYIw7vg5Sq1LdpUTWDdQXqCSps4DfAQZTBfwt2L45XR7VJrJ4PRlWQfWPE3T2duBjFnDyzcL+lIXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 87040b12926311f1aa26b74ffac11d73-20260807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:091d5883-8a44-4e78-8003-ef36940a538c,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:55360a59baa345a743eb8ff705abea55,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 87040b12926311f1aa26b74ffac11d73-20260807
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1197302315; Fri, 07 Aug 2026 21:25:58 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: jeff.chen_1@nxp.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it,
	arend.vanspriel@broadcom.com,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 0/2] wifi: nxpwifi: fix sta_list locking and the deauth leak
Date: Fri,  7 Aug 2026 21:25:52 +0800
Message-Id: <20260807132554.888706-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes for priv->sta_list in the uAP path, both found by reading the
station list locking model rather than from a report.

Patch 1 restores the writer lock in nxpwifi_del_sta_entry().  The list
has three writers; two of them take sta_list_spinlock, the third relies
on the cfg80211 mutex instead.  That mutex does not cover the other two,
because they run from firmware events on the driver's main work queue,
which never takes the wiphy lock.

Patch 2 deletes the station entry when the firmware reports
EVENT_UAP_STA_DEAUTH.  Nothing removes it today, so a station that has
left stays on the list until the BSS goes idle, and frames addressed to
it are requeued as intra-BSS traffic instead of going up the stack.

The order matters.  Patch 2 adds a second caller of
nxpwifi_del_sta_entry(), and that caller runs on the main work queue.
With patch 1 in front of it the two deletion paths serialise on
sta_list_spinlock and only one of them unlinks the node; the other
finds nothing and returns.  Applied the other way round, patch 2 would
widen the race that patch 1 fixes.

Neither patch has been tested on hardware -- I have no IW61x.  Both are
derived from the code paths, and both restore behaviour that mwifiex,
which nxpwifi was derived from, already has.

Linmao Li (2):
  wifi: nxpwifi: protect sta_list against concurrent add and delete
  wifi: nxpwifi: delete the station entry on the uAP deauth event

 drivers/net/wireless/nxp/nxpwifi/cfg80211.c  | 2 ++
 drivers/net/wireless/nxp/nxpwifi/uap_event.c | 1 +
 drivers/net/wireless/nxp/nxpwifi/util.c      | 8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.25.1

