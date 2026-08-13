Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115C36B93C;
	Thu, 13 Aug 2026 08:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609411; cv=none; b=VCFA2+siBv7yHlgyYP8SHyjfhULQLtaU9mdHjqxzMDPv8orPv3FsOmO6Eg65xKQjUaoX2MZWINBa9ACWuR1ky80iHngbB/T+6x3hJXZMMXjiI4t1taLdLW/8Z9ISy1sDQ2AJinU8zUJsFu6QOxvNMV1FnnAQQkx9q9+7//npHDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609411; c=relaxed/simple;
	bh=V8iufdE/Qu2vO8v9vJPMDhg0T6pd6TTK+ELI3S4anDY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XZhH1QEOlBn3+CBbcQLCcbxgv/PgK6aMI1LPdWMA9uMe45UrY2sOEIsCXf3e/QY75h3l5cNc3n1IsmCjWRo/Y7ZVDNZHmQRRH3+yVGth2qMT84AAHNhacdqLq6+unVRZIxPWnlVPbLx729TcJ9jsFMrcS/uJwRkwBsskFxuq0eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3fae703696f011f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f8c38671-2144-42b6-9f85-a8895b2623a1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:4d4ef381cc9e27c2f46cba813b709050,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3fae703696f011f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1004004295; Thu, 13 Aug 2026 16:23:22 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 2/3] wifi: nxpwifi: free the aggregation buffer when the RA list disappears
Date: Thu, 13 Aug 2026 16:23:14 +0800
Message-Id: <20260813082315.1390321-3-lilinmao@kylinos.cn>
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

nxpwifi_11n_aggregate_pkt() drops ra_list_spinlock while it copies each
subframe, so it rechecks the RA list after taking the lock again.  The
check inside the aggregation loop returns without releasing the
skb_aggr it has been filling, leaking one tx_buf_size buffer along with
the subframes already aggregated into it.

Release skb_aggr there, the way the same check on the -EBUSY path
already does.

mwifiex fixed the same issue in commit 990a73dec3fd ("wifi: mwifiex: Fix
memory leak in mwifiex_11n_aggregate_pkt()").

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n_aggr.c b/drivers/net/wireless/nxp/nxpwifi/11n_aggr.c
index be7080f2a6ce7..54933c42c960d 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n_aggr.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n_aggr.c
@@ -168,6 +168,7 @@ nxpwifi_11n_aggregate_pkt(struct nxpwifi_private *priv,
 
 		if (!nxpwifi_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_bh(&priv->wmm.ra_list_spinlock);
+			nxpwifi_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -ENOENT;
 		}
 
-- 
2.25.1

