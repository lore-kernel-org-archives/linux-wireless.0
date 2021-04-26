Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70515C433B4
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Apr 2021 19:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3968860FD9
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Apr 2021 19:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhDZTaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Apr 2021 15:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbhDZT37 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Apr 2021 15:29:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D9C061574
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2021 12:29:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lb6ux-000MWe-MS; Mon, 26 Apr 2021 21:29:15 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Harald Arnesen <harald@skogtun.org>,
        Arend van Spriel <aspriel@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH] brcmfmac: don't take RTNL if already locked
Date:   Mon, 26 Apr 2021 21:29:07 +0200
Message-Id: <20210426212905.6b0f78581429.I2ee37448e499091b3ec0b23d642e3113ef670a8e@changeid>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We should not take the RTNL if we come here already with the
RTNL held, so don't take it again.

The Fixes tag below might not be completely accurate, that
might just have made the problem obvious by showing that the
function can be called with RTNL already held.

Fixes: b50ddfa8530e ("brcmfmac: fix lockup when removing P2P interface after event timeout")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ea78fe527c5d..ce9d8781b62b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -926,9 +926,11 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 	if (ifp->ndev) {
 		if (bsscfgidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
-				rtnl_lock();
+				if (!locked)
+					rtnl_lock();
 				brcmf_netdev_stop(ifp->ndev);
-				rtnl_unlock();
+				if (!locked)
+					rtnl_unlock();
 			}
 		} else {
 			netif_stop_queue(ifp->ndev);
-- 
2.30.2

