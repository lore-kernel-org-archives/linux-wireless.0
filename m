Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE6C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 796212081B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfBFLYr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:24:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55824 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728463AbfBFLYr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:24:47 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCx-0001ED-R6; Wed, 06 Feb 2019 13:17:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:17 +0200
Message-Id: <20190206111721.29283-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/15] mac80211: ignore quiet mode in probe
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Some buggy APs keep the CSA IE in probes after the channel
switch was completed and can silence us for no good reason.
Apply quiet mode only from beacons. If there is real channel
switch going on, we will see the beacon anyway.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5f9290f5b892..6d1e7e6f1c21 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1295,7 +1295,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!res) {
 		ch_switch.timestamp = timestamp;
 		ch_switch.device_timestamp = device_timestamp;
-		ch_switch.block_tx = csa_ie.mode;
+		ch_switch.block_tx =  beacon ? csa_ie.mode : 0;
 		ch_switch.chandef = csa_ie.chandef;
 		ch_switch.count = csa_ie.count;
 		ch_switch.delay = csa_ie.max_switch_time;
@@ -1388,7 +1388,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	sdata->vif.csa_active = true;
 	sdata->csa_chandef = csa_ie.chandef;
-	sdata->csa_block_tx = csa_ie.mode;
+	sdata->csa_block_tx = ch_switch.block_tx;
 	ifmgd->csa_ignored_same_chan = false;
 
 	if (sdata->csa_block_tx)
@@ -1422,7 +1422,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	 * reset when the disconnection worker runs.
 	 */
 	sdata->vif.csa_active = true;
-	sdata->csa_block_tx = csa_ie.mode;
+	sdata->csa_block_tx = ch_switch.block_tx;
 
 	ieee80211_queue_work(&local->hw, &ifmgd->csa_connection_drop_work);
 	mutex_unlock(&local->chanctx_mtx);
-- 
2.20.1

