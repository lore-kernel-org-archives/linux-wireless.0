Return-Path: <SRS0=sjgz=7Y=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A724CC433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jun 2020 16:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8972D206A4
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Jun 2020 16:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFKQoU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Jun 2020 12:44:20 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:47058 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgFKQoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jun 2020 12:44:19 -0400
Received: from legolas.fritz.box (unknown [87.147.49.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 8D550580065;
        Thu, 11 Jun 2020 18:44:17 +0200 (CEST)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] mac80211: skip mpath lookup also for control port tx
Date:   Thu, 11 Jun 2020 18:44:10 +0200
Message-Id: <20200611164410.606859-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using 802.1X over mesh networks, at first an ordinary
mesh peering is established, then the 802.1X EAPOL dialog
happens, afterwards an authenticated mesh peering exchange
(AMPE) happens, finally the peering is complete and we can
set the STA authorized flag.

As 802.1X is an intermediate step here and key material is
not yet exchanged for stations we have to skip mesh path lookup
for these EAPOL frames. Otherwise the already configure mesh
group encryption key would be used to send a mesh path request
which no one can decipher, because we didn't already establish
key material on both peers, like with SAE and directly using AMPE.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 net/mac80211/tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9ce658141f5..c87472c0239f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -576,7 +576,8 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 	if (unlikely(tx->sdata->control_port_protocol == tx->skb->protocol)) {
 		if (tx->sdata->control_port_no_encrypt)
 			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO |
+				       IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
 		info->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 	}
 
@@ -5370,8 +5371,10 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	    proto != cpu_to_be16(ETH_P_PREAUTH))
 		return -EINVAL;
 
-	if (proto == sdata->control_port_protocol)
-		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+	if (proto == sdata->control_port_protocol) {
+		ctrl_flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO |
+			      IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
+	}
 
 	if (unencrypted)
 		flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-- 
2.27.0

