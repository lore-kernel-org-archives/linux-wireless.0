Return-Path: <SRS0=P4PU=5N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC15C43331
	for <linux-wireless@archiver.kernel.org>; Sat, 28 Mar 2020 13:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D234220716
	for <linux-wireless@archiver.kernel.org>; Sat, 28 Mar 2020 13:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="FZWwRBXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgC1NyR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 28 Mar 2020 09:54:17 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:49569 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgC1NyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Mar 2020 09:54:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585403656; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=yVfOL4H/XVfBZS3Hie5qNuHE+E6CVqQ2grlwD0rNTTY=; b=FZWwRBXkFCd8Q6/ugUA5pxsIKeWM94St8e31weXEk9cTxZmL+JlVwEL12WxdsVTVmpcLJE+1
 07yRTRBRWxnLU2cP81p4LoUGrDOVphoGY+JGAu4a1QUoz5aNMQPF2mcI5wviaHupDvPYhuxl
 yoNoIgU0bEBMdk04IGo3B2pNGec=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7f56ff.7fa6fe6ece30-smtp-out-n04;
 Sat, 28 Mar 2020 13:54:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B0255C433BA; Sat, 28 Mar 2020 13:54:06 +0000 (UTC)
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38E82C433F2;
        Sat, 28 Mar 2020 13:54:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38E82C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh Chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] mac80211: fix channel switch trigger from unknown mesh peer
Date:   Sat, 28 Mar 2020 19:23:24 +0530
Message-Id: <1585403604-29274-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tamizh chelvam <tamizhr@codeaurora.org>

Previously mesh channel switch happens if beacon contains
CSA IE without checking the mesh peer info. Due to that
channel switch happens even if the beacon is not from
its own mesh peer. Fixing that by checking if the CSA
originated from the same mesh network before proceeding
for channel switch.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 net/mac80211/mesh.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d09b3c7..36978a0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1257,15 +1257,15 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
 			mesh_neighbour_update(sdata, mgmt->sa, &elems,
 					      rx_status);
+
+		if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
+		    !sdata->vif.csa_active)
+			ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 	}
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
-
-	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
-	    !sdata->vif.csa_active)
-		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1373,6 +1373,9 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(pos, len - baselen, true, &elems,
 			       mgmt->bssid, NULL);
 
+	if (!mesh_matches_local(sdata, &elems))
+		return;
+
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
-- 
1.7.9.5
