Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBE03DB31A;
	Thu, 20 Aug 2026 08:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787213813; cv=none; b=pSLIGhi8RRwBowY6NMIIJxwQ/ZKu/5qgUNSdprc23P1/7gU0EXm8wgLO2Ju5M+PvN1v7hVuddUuq4tOepSCw7BHeNVDmrQDk1aZOJjMEytsgKMCeLOCBogUgSRvmKzCMkkOQphuq/HD/t+mJFCbxzSpwsJJxqyuWDyWAMRpmOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787213813; c=relaxed/simple;
	bh=FGYPx0LRJKfb0iYwBEjvpnDCvg2zwbNQhANX4tN50tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tU7i7Q+Fm8N+VSmYuAwLGJWWpxdKSu3v3v1LzpoG1Crvtj6v8//6R4dUg+QhKcvqrBLWHOd7MteMYexE2F5hJ3Okg5hOdbBSZ9PhPVnK5ZcLSVK/CoVppYKyP/NFlfEcjHTnJLrD42p3Y1eqKrzsEmy+LcIKzilhJajEL4XYUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 78dbb8949c6f11f19a56ed5b684f684d-20260820
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:0dcc9456-f667-44fb-a6c8-525331257e3d,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:c0c7c1aca98761d0803e44c9f586bc3c,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|136|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78dbb8949c6f11f19a56ed5b684f684d-20260820
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1663575881; Thu, 20 Aug 2026 16:16:40 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 1/2] wifi: nxpwifi: fix the authentication frame length handling
Date: Thu, 20 Aug 2026 16:16:33 +0800
Message-Id: <20260820081634.4043666-2-lilinmao@kylinos.cn>
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

nxpwifi_cfg80211_authenticate() builds a 3-address management frame in a
temporary buffer and hands it to nxpwifi_form_mgmt_frame(), which copies
it into the skb and splices in address4.  The frame length is tracked in
a single u16 that conflates the two lengths, and it gets both wrong.

Truncation.  req->ie_len and req->auth_data_len are both size_t.  The IE
policy caps req->ie_len at IEEE80211_MAX_DATA_LEN, but
NL80211_ATTR_AUTH_DATA only has a four-byte minimum length policy.  Since
nla_len is a u16, a single authentication data attribute can carry up to
65531 bytes, enough for the combined frame length to exceed U16_MAX
before it is assigned to pkt_len.  With auth_data_len == 65510 and no IEs
the length wraps to 6, kzalloc(6) succeeds, and the memcpy() below then
writes 65506 user-provided bytes past a 6-byte heap object.

Geometry.  NXPWIFI_MGMT_HEADER_LEN is 30, which is the 24-byte 3-address
header plus the address4 that the firmware expects.  The temporary buffer
only holds a struct ieee80211_hdr_3addr, so six of the bytes accounted
for are never used, and passing that length to nxpwifi_form_mgmt_frame()
makes it append ETH_ALEN on top of a length that already included it.
The skb is sized without those six bytes, so the last skb_put_data()
overruns the tailroom by exactly ETH_ALEN.  It usually goes unnoticed
because SKB_DATA_ALIGN() rounding leaves slack.  The driver's other
caller of the helper, nxpwifi_cfg80211_mgmt_tx(), adds ETH_ALEN to the
skb size before allocating and passes the 3-address length, which is what
this path should do too.

Keep the two lengths apart.  frame_len is the 3-address frame the driver
builds: it sizes the temporary buffer and is what the helper is told.
pkt_len is what the firmware sees, frame_len plus address4: it sizes the
skb and goes into tx_info.  Computing frame_len in size_t and rejecting
anything that cannot be represented once ETH_ALEN is added removes the
wrap.

The value handed to the firmware is unchanged, so this is not a
behavioural change for frames that were already valid.  A tighter 802.11
bound may make sense, but that depends on the firmware's frame format and
is a separate decision.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index 5cc8cdf594d3e..1f46e4f0157e7 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -3323,6 +3323,7 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 	struct nxpwifi_adapter *adapter = priv->adapter;
 	struct sk_buff *skb;
 	u16 pkt_len, auth_alg;
+	size_t frame_len;
 	int ret;
 	struct ieee80211_mgmt *mgmt;
 	struct nxpwifi_txinfo *tx_info;
@@ -3396,13 +3397,23 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 
 	nxpwifi_cancel_scan(adapter);
 
-	pkt_len = (u16)req->ie_len + req->auth_data_len +
-		NXPWIFI_MGMT_HEADER_LEN + NXPWIFI_AUTH_BODY_LEN;
+	frame_len = req->ie_len + req->auth_data_len +
+		sizeof(struct ieee80211_hdr_3addr) + NXPWIFI_AUTH_BODY_LEN;
 
 	if (req->auth_data_len >= 4)
-		pkt_len -= 4;
+		frame_len -= 4;
 
-	mgmt = kzalloc(pkt_len, GFP_KERNEL);
+	/* nxpwifi_form_mgmt_frame() inserts address4, so the frame handed to
+	 * the firmware is ETH_ALEN longer than the one built here.
+	 */
+	if (frame_len > U16_MAX - ETH_ALEN) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "auth frame too long: %zu bytes\n", frame_len);
+		return -EINVAL;
+	}
+	pkt_len = frame_len + ETH_ALEN;
+
+	mgmt = kzalloc(frame_len, GFP_KERNEL);
 
 	skb = dev_alloc_skb(NXPWIFI_MIN_DATA_HEADER_LEN +
 			    NXPWIFI_MGMT_FRAME_HEADER_SIZE +
@@ -3448,7 +3459,7 @@ nxpwifi_cfg80211_authenticate(struct wiphy *wiphy,
 		memcpy((u8 *)varptr, req->ie, req->ie_len);
 	}
 
-	nxpwifi_form_mgmt_frame(skb, (const u8 *)mgmt, pkt_len);
+	nxpwifi_form_mgmt_frame(skb, (const u8 *)mgmt, frame_len);
 	kfree(mgmt);
 	priv->auth_flag = HOST_MLME_AUTH_PENDING;
 	priv->auth_alg = auth_alg;
-- 
2.25.1

