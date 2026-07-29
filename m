Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDC43CEFA;
	Wed, 29 Jul 2026 08:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313518; cv=none; b=ZlPQ3p70TObE9Y1yKNgztGcdtlkoGQuehXNjQ7BmGDmkqkH9vmKaGg6Se8UyHHngDdXdOWy5bP6ADlYSj6bpezHMZZncxPdmqnVfyyDlUD5w+e9e8YzPNYb541YiPzuKE1eNVgGAK9gIoSMGt6oF4zEwQtktNso1R8OVhZdQqZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313518; c=relaxed/simple;
	bh=IdqIoqCKixC1ksvru8F2pUqsncTnV5LX1YYdA7vQWIs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sQ/5OdiKq+wFPboFUoUcUL88BQdPa20X3EbC+nso4fIaGog/GG1i7N9H3+kQzxVbtXTUjiUsC6o9nf2G9snDscEbMPI3OIkvKx4LA4fmMx+5zYLZidkWQ4l5XQBdotKa77FGsNLRzSHgami1W9bJtEnPIjkbL93+OeI1M4EoL7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: fe5fec9c8b2611f1aa26b74ffac11d73-20260729
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:60f41381-f140-4bb6-9017-cd01fc173593,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:92e21074aa81b7d161f7b5d5cb251a8e,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fe5fec9c8b2611f1aa26b74ffac11d73-20260729
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 224814004; Wed, 29 Jul 2026 16:25:01 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH] wifi: nxpwifi: bound uAP association event IEs to the event buffer
Date: Wed, 29 Jul 2026 16:24:57 +0800
Message-Id: <20260729082457.1897303-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_uap_event_sta_assoc() exposes the association request IEs that
the firmware reports in the uAP association event, which the driver
copies into the fixed-size event_body[] buffer.

event->len is supplied by firmware and is not validated. A value smaller
than the header underflows the subtraction used for assoc_req_ies_len,
while a larger value can make the IE range extend beyond event_body[].
Subsequent IE parsing can then read past the adapter object.

Validate both bounds before using the firmware-reported length.

nxpwifi was derived from mwifiex before commit f0858bfc7d3c ("wifi:
mwifiex: bound uAP association event IEs to the event buffer") and
retains the same unchecked length. Apply the equivalent bounds check
here.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/uap_event.c | 22 ++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/uap_event.c b/drivers/net/wireless/nxp/nxpwifi/uap_event.c
index ed8e24ae9c0a7..9f717a3d7ec5d 100644
--- a/drivers/net/wireless/nxp/nxpwifi/uap_event.c
+++ b/drivers/net/wireless/nxp/nxpwifi/uap_event.c
@@ -107,11 +107,29 @@ nxpwifi_uap_event_sta_assoc(struct nxpwifi_private *priv)
 			len = ETH_ALEN;
 
 		if (len != -1) {
+			u16 evt_len = le16_to_cpu(event->len);
+
 			sinfo->assoc_req_ies = &event->data[len];
 			len = (u8 *)sinfo->assoc_req_ies -
 			      (u8 *)&event->frame_control;
-			sinfo->assoc_req_ies_len =
-				le16_to_cpu(event->len) - (u16)len;
+
+			/*
+			 * event->len is reported by the device firmware
+			 * and is not otherwise validated. Reject a length
+			 * that underflows the header or that would place
+			 * the association request IEs outside the fixed
+			 * event_body[] buffer.
+			 */
+			if (evt_len < len ||
+			    (u8 *)&event->frame_control + evt_len >
+			    adapter->event_body + MAX_EVENT_SIZE) {
+				nxpwifi_dbg(adapter, ERROR,
+					    "invalid STA assoc event length\n");
+				kfree(sinfo);
+				return -EINVAL;
+			}
+
+			sinfo->assoc_req_ies_len = evt_len - (u16)len;
 		}
 	}
 	cfg80211_new_sta(priv->netdev->ieee80211_ptr, event->sta_addr, sinfo,

base-commit: 3652b49adac266a3d27cb41cdfdb7d8790fc3633
-- 
2.25.1

