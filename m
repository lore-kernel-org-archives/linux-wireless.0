Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488E746C859;
	Fri, 14 Aug 2026 12:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710507; cv=none; b=RtsnAPxWw0LxPKQWir1Oe+4MIN4G41y5gOpDz/9H53oWG3j06h1eLFiBymnkib5eCrKpAbg/KMMH7+omS++AvCzAwduERYHXt0IW/cTOe0c2MpObJA/eqnIm0n703UOnlg1aaLJKHDdptcMqv9Xa9LQMK39G+aTH5y3JULnAlLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710507; c=relaxed/simple;
	bh=lzkWAFAEM5ZUpn7TE98LwjsTtc4ludonkbm3ESilUWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uy9x/YOzQTZiLAy1YLaAxmYCANcNb8JdjAgkrgF+BkA4Squz+8klKVw1sSKmUGX0ZkLM0xaqYowtxsj7XsobYeeKogfaG8ILrIf+gExyuoWNCuCmt+bMB+5KBKJe+WnLuxTu/oPvQiE18qOHnxKJwTx3le/A2uJRrigCwjzn1NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a054ac1697db11f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:80524ab1-acb7-411a-a404-bffb664c1fc1,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:81179d32ce9a0963e74b9ff468a2bbe1,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a054ac1697db11f1aa26b74ffac11d73-20260814
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1351507832; Fri, 14 Aug 2026 20:28:16 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 1/3] wifi: nxpwifi: validate the length of the VDLL indication event
Date: Fri, 14 Aug 2026 20:28:08 +0800
Message-Id: <20260814122810.2999536-2-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814122810.2999536-1-lilinmao@kylinos.cn>
References: <20260814122810.2999536-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_process_vdll_event() reads the ten-byte struct vdll_ind_event
that follows the four-byte event cause without checking that the event
is long enough to hold it.  The receive path does not guarantee that:
nxpwifi_sdio_decode_rx_packet() takes the event cause from the first
four bytes and hands the skb on whatever its length is, copying an
event body only when there is one.

A short event therefore makes the driver read past the end of the
buffer and then act on the type, offset and block length it finds
there.

Check the length before the header is dereferenced.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/util.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index bbfefb81d8d3b..549661ca049a0 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -1255,15 +1255,24 @@ int nxpwifi_process_vdll_event(struct nxpwifi_private *priv,
 			       struct sk_buff *skb)
 {
 	struct nxpwifi_adapter *adapter = priv->adapter;
-	struct vdll_ind_event *vdll_evt =
-		(struct vdll_ind_event *)(skb->data + sizeof(u32));
-	u16 type = le16_to_cpu(vdll_evt->type);
-	u16 vdll_id = le16_to_cpu(vdll_evt->vdll_id);
-	u32 offset = le32_to_cpu(vdll_evt->offset);
-	u16 block_len = le16_to_cpu(vdll_evt->block_len);
 	struct vdll_dnld_ctrl *ctrl = &adapter->vdll_ctrl;
+	struct vdll_ind_event *vdll_evt;
+	u16 type, vdll_id, block_len;
+	u32 offset;
 	int ret = 0;
 
+	if (skb->len < sizeof(u32) + sizeof(*vdll_evt)) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "VDLL IND: event too short: %u\n", skb->len);
+		return -EINVAL;
+	}
+
+	vdll_evt = (struct vdll_ind_event *)(skb->data + sizeof(u32));
+	type = le16_to_cpu(vdll_evt->type);
+	vdll_id = le16_to_cpu(vdll_evt->vdll_id);
+	offset = le32_to_cpu(vdll_evt->offset);
+	block_len = le16_to_cpu(vdll_evt->block_len);
+
 	switch (type) {
 	case VDLL_IND_TYPE_REQ:
 		nxpwifi_dbg(adapter, EVENT,
-- 
2.25.1

