Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA102417DE;
	Thu, 20 Aug 2026 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787213810; cv=none; b=OubYwE5sryuykIYp2llhS7alRIl+8rx3Om2baSfIS/nqzGmu98+EvcU6sS2UKEFFps36lTSr6UfKE/lOAIYgFViI7fbgxMf6iqAIowxvIBqgbOReEi2zxqLYYd3cYGN86ww3n2JQhXph53ddZqHwwc7qWI92/ZimJxiIQjJ7CbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787213810; c=relaxed/simple;
	bh=p8Hb3MUT9JPCxbkMQKjmxKDTAj7tWNQcVAlhcnnBBE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HHe/8LlCYWVBMefKytkYNQgv8Ag6bKU3cJBNyT7aq75BbtA8moqZI5ejsmP5s2XlPbJGme8bFBWypN61P9JQ0/wolvQjy2nCdRoYiJwtWyFc7tIgynQGQ0xmI9YXDwVtS+2PHg1SJDXHh1kXeC/nMBQP8ghou9zANzsl4nBZXcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 79943a369c6f11f19a56ed5b684f684d-20260820
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:80ccb9cf-0415-40e9-8404-fd96dc9c789f,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:494d2e8d99387016cd2a6a18feb22b32,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|136|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 79943a369c6f11f19a56ed5b684f684d-20260820
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 217391990; Thu, 20 Aug 2026 16:16:42 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 2/2] wifi: nxpwifi: handle authentication frame allocation failures
Date: Thu, 20 Aug 2026 16:16:34 +0800
Message-Id: <20260820081634.4043666-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820081634.4043666-1-lilinmao@kylinos.cn>
References: <20260820081634.4043666-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_cfg80211_authenticate() allocates the buffer it builds the
management frame in and never checks the result:

	mgmt = kzalloc(frame_len, GFP_KERNEL);

	skb = dev_alloc_skb(...);
	if (!skb) {
		...
		return -ENOMEM;
	}
	...
	memcpy(mgmt->da, req->bss->bssid, ETH_ALEN);

On allocation failure the memcpy() a dozen lines later dereferences NULL.
The same sequence leaks mgmt when dev_alloc_skb() fails: that path
returns without freeing it, while the success path drops it after
nxpwifi_form_mgmt_frame().

Bail out when the allocation fails, and free it before returning on the
skb error path.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 1f46e4f0157e7..fe9d1b14ddd3e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -3414,6 +3414,8 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 	pkt_len = frame_len + ETH_ALEN;
 
 	mgmt = kzalloc(frame_len, GFP_KERNEL);
+	if (!mgmt)
+		return -ENOMEM;
 
 	skb = dev_alloc_skb(NXPWIFI_MIN_DATA_HEADER_LEN +
 			    NXPWIFI_MGMT_FRAME_HEADER_SIZE +
@@ -3421,6 +3423,7 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 	if (!skb) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "allocate skb failed for management frame\n");
+		kfree(mgmt);
 		return -ENOMEM;
 	}
 
-- 
2.25.1

