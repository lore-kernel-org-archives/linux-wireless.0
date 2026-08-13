Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9030414A15;
	Thu, 13 Aug 2026 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609411; cv=none; b=UjvFQ8aSU6+alfEsSZAZQCN+tnzvy2/9cbCa2cOu5oARybc5oMq3YWP3rMTRCyZz+//4AhuMW3MBv45ZEF+pY6d8+7J1Y98ajdWzkCrxEyiOm1HvkYSPBlksrDNnTpX41Xf5agmHsu326zckzRHsLf9lohEZErrNxhDpJ/k06bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609411; c=relaxed/simple;
	bh=hF1a0Y6lOJm7iA2dFbur1YquVnlb2C++Wv0JRPEAgOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FHYh1kAAYYj6y20nwr1qPIn2Ja1W+X58LUP/TnoRj1Iejo11PdWvwwzb9WafxGb1lLa1F+H08WnU6NU588q8TAlXLgIicWnxTdv6SV0n1MPnXqju+nwWfsbROnZNxmf0QC65y8uIuyLFKcEl42KGcbVwTIjx5vHQxzpkOzj2Rfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3ed2213a96f011f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:85e73a2b-710b-4f1b-a761-de25a621d486,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:283f105edddc1f09ef27d1275b0461a9,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3ed2213a96f011f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 716133087; Thu, 13 Aug 2026 16:23:21 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 1/3] wifi: nxpwifi: wait for the wakeup timer before the adapter is freed
Date: Thu, 13 Aug 2026 16:23:13 +0800
Message-Id: <20260813082315.1390321-2-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813082315.1390321-1-lilinmao@kylinos.cn>
References: <20260813082315.1390321-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_adapter_cleanup() stops adapter->wakeup_timer with
timer_delete(), which does not wait for a running callback.  The
callback goes on using the adapter: wakeup_timer_fn() sets
adapter->hw_status, walks the command queues through
nxpwifi_cancel_all_pending_cmd() and calls adapter->if_ops.card_reset().
Both paths that reach nxpwifi_adapter_cleanup() free the adapter right
afterwards, through nxpwifi_free_adapter() in nxpwifi_remove_card() and
in the nxpwifi_add_card() error unwind.

Use timer_delete_sync() so the callback has finished before the adapter
is released.

mwifiex fixed the same issue in commit ae5e95d41574 ("wifi: mwifiex: fix
use-after-free in mwifiex_adapter_cleanup()").

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/init.c b/drivers/net/wireless/nxp/nxpwifi/init.c
index b128fc9fe31a2..69b27fce5ce65 100644
--- a/drivers/net/wireless/nxp/nxpwifi/init.c
+++ b/drivers/net/wireless/nxp/nxpwifi/init.c
@@ -328,7 +328,7 @@ static void nxpwifi_invalidate_lists(struct nxpwifi_adapter *adapter)
 static void
 nxpwifi_adapter_cleanup(struct nxpwifi_adapter *adapter)
 {
-	timer_delete(&adapter->wakeup_timer);
+	timer_delete_sync(&adapter->wakeup_timer);
 	nxpwifi_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);
 	wake_up_interruptible(&adapter->hs_activate_wait_q);
-- 
2.25.1

