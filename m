Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725A6C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E87E2080D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfBFLWw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:22:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55806 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727501AbfBFLWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:22:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCx-0001ED-5E; Wed, 06 Feb 2019 13:17:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:16 +0200
Message-Id: <20190206111721.29283-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/15] mac80211: allow CSA to self with immediate quiet
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Currently, due to some buggy APs that continue to include
CSA IEs after the switch, we ignore CSA to same channel.
However, some other APs may do CSA to self in order to have
immediate quiet. Allow it. Do it only for beacons.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad963204ece9..5f9290f5b892 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1332,7 +1332,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (cfg80211_chandef_identical(&csa_ie.chandef,
-				       &sdata->vif.bss_conf.chandef)) {
+				       &sdata->vif.bss_conf.chandef) &&
+	    (!csa_ie.mode || !beacon)) {
 		if (ifmgd->csa_ignored_same_chan)
 			return;
 		sdata_info(sdata,
-- 
2.20.1

