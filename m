Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72354C1B0D8
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7F02310E
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 12:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgLFMzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Dec 2020 07:55:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34948 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727395AbgLFMzt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Dec 2020 07:55:49 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kltZ5-003AHZ-3Y; Sun, 06 Dec 2020 14:54:59 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Date:   Sun,  6 Dec 2020 14:54:49 +0200
Message-Id: <iwlwifi.20201206145305.83470b8407e6.I739b907598001362744692744be15335436b8351@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206125450.564941-1-luca@coelho.fi>
References: <20201206125450.564941-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/11] mac80211: don't filter out beacons once we start CSA
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I hit a bug in which we started a CSA with an action frame,
but the AP changed its mind and didn't change the beacon.
The CSA wasn't cancelled and we lost the connection.

The beacons were ignored because they never changed: they
never contained any CSA IE. Because they never changed, the
CRC of the beacon didn't change either which made us ignore
the beacons instead of processing them.

Now what happens is:
1) beacon has CRC X and it is valid. No CSA IE in the beacon
2) as long as beacon's CRC X, don't process their IEs
3) rx action frame with CSA
4) invalidate the beacon's CRC
5) rx beacon, CRC is still X, but now it is invalid
6) process the beacon, detect there is no CSA IE
7) abort CSA

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 824dbba62794..b5967c215b0c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1493,6 +1493,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->csa_chandef = csa_ie.chandef;
 	sdata->csa_block_tx = csa_ie.mode;
 	ifmgd->csa_ignored_same_chan = false;
+	ifmgd->beacon_crc_valid = false;
 
 	if (sdata->csa_block_tx)
 		ieee80211_stop_vif_queues(local, sdata,
-- 
2.29.2

