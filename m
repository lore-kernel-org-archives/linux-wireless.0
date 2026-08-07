Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4425144236E;
	Fri,  7 Aug 2026 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109177; cv=none; b=p5+68efhtW5NQaLefSMxtTqfCIm7oursDqXV6h6nvQ4453eIjjYgb7LfwHgoV7HfnUNhoLo1eEDqQ+uWlfl1GW/qehqdG3t3TnAQIlehiidbzhb7m6X5MJmARnRCkgIpP+ry4vsTpJdNlIH+x2w0JFl5SJHaU8d8JqTRrDxWGn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109177; c=relaxed/simple;
	bh=OMAm8tO8cS0Dtk0h1Y6sYN/8CoX3lwDvC51nox9xyPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gO6OQqhiJj+pDWYAvG14zoBuIb/kZjjEkHm5kkCAskGrzbV3489UiujW2mSrfc3HmDE1O/QmxcgzeT87DyVp6kySgAZumR8/RI7UVzNpxKZnYqSrbQMtR04fXudBYsx0ln6gPIZvyPYb58f72q9WPKSYx4oRw1JusIhBMIY0BxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 899aa1a6926311f1aa26b74ffac11d73-20260807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:18bd7d5e-f794-4207-8566-8ffc4ee8f26c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:a7dca455ddfcfede81dc95e720c445a6,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 899aa1a6926311f1aa26b74ffac11d73-20260807
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1058212058; Fri, 07 Aug 2026 21:26:03 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: jeff.chen_1@nxp.com,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it,
	arend.vanspriel@broadcom.com,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 2/2] wifi: nxpwifi: delete the station entry on the uAP deauth event
Date: Fri,  7 Aug 2026 21:25:54 +0800
Message-Id: <20260807132554.888706-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260807132554.888706-1-lilinmao@kylinos.cn>
References: <20260807132554.888706-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a station leaves, the firmware reports EVENT_UAP_STA_DEAUTH.
nxpwifi_uap_event_sta_deauth() tears down the reorder, BA and WMM state
for that peer but leaves its nxpwifi_sta_node on priv->sta_list.

Nothing else removes it.  cfg80211_del_sta() only reports the departure
upwards, it does not call back into cfg80211_ops.del_station, and that
callback is the only caller of nxpwifi_del_sta_entry().  The entry
therefore survives until the BSS goes idle and
nxpwifi_del_all_sta_list() drops everything.

Until then the departed station still looks associated to the driver.
nxpwifi_handle_uap_rx_forward() finds the stale node for that address,
treats the frame as intra-BSS traffic and requeues it for transmission
instead of passing it up the stack, so traffic for that address is
misrouted.  The list also keeps one entry per station that has ever
associated, and a station that comes back reuses the stale node along
with its old statistics.

mwifiex, which nxpwifi was derived from, deletes the entry in the same
event handler.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/uap_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/uap_event.c b/drivers/net/wireless/nxp/nxpwifi/uap_event.c
index 9f717a3d7ec5d..f053a5db01ab7 100644
--- a/drivers/net/wireless/nxp/nxpwifi/uap_event.c
+++ b/drivers/net/wireless/nxp/nxpwifi/uap_event.c
@@ -75,6 +75,7 @@ nxpwifi_uap_event_sta_deauth(struct nxpwifi_private *priv)
 		nxpwifi_del_tx_ba_stream_tbl_by_ra(priv, deauth_mac);
 	}
 	nxpwifi_wmm_del_peer_ra_list(priv, deauth_mac);
+	nxpwifi_del_sta_entry(priv, deauth_mac);
 
 	return 0;
 }
-- 
2.25.1

