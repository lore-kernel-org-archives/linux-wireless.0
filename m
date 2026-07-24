Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7480D3DA7E6;
	Fri, 24 Jul 2026 10:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889435; cv=none; b=N/8/sHyrOqvbUm30ThUs/tAQIXWs5TtLr7wboYzxj3xdfFmPjzV1gyUuLBArhjCy+P8IN5yh/mRspldioU4aoM9Lhvzm+V26ngL+GYeJVfEInTmZaeSLpDklJ+C02GJhmVOC2P8Es+jHG5YBtghZEVzvAeU9IKblTt+WuKEd83Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889435; c=relaxed/simple;
	bh=R/i/aHgpKv3Scl17qepOTnnc2xP+h6vITMgwSn+nm3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ohz0Nbm2J4fIeIhPUqSJqKhS+DfpcysKKlcR44lVsLKJWkJHjmHABLojRowMg+Pl89xwgTjx7AhrC3F+w9G8cCoyqysJ2aSpeV/56OamBRRRHCZ0ssezsBiHmwNjIKhIiUzpLk9vX7dbpggcFAY0KtCQq3UMxAOVM44Lyekzp8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9c6c06e4874b11f1aa26b74ffac11d73-20260724
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6338399d-df22-42db-b359-a5659eb6d23a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:6ba0d886da9cc77b5f940ce638163862,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9c6c06e4874b11f1aa26b74ffac11d73-20260724
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1864914623; Fri, 24 Jul 2026 18:37:04 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next] wifi: nxpwifi: reject zero-length extension elements in beacon IEs
Date: Fri, 24 Jul 2026 18:36:56 +0800
Message-Id: <20260724103656.2494129-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_update_bss_desc_with_ie() dispatches on elem->data[0] for
WLAN_EID_EXTENSION without checking that the element has a payload.
A well-formed extension element carries at least the element ID
extension byte, but nothing enforces that in the IE stream, and the
loop accepts a zero-length element because its header alone fits.
elem->data[0] then reads the byte after the element, which is past the
kmemdup()ed IE buffer when that element ends the stream.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index bb3ce2b6f4b9..b77056983e83 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -1255,6 +1255,9 @@ int nxpwifi_update_bss_desc_with_ie(struct nxpwifi_adapter *adapter,
 				(u16)(current_ptr - bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_EXTENSION:
+			if (!element_len)
+				return -EINVAL;
+
 			elem = (struct element *)current_ptr;
 
 			switch (elem->data[0]) {
-- 
2.25.1

