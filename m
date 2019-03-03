Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7FEC43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 17:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8CF420835
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 17:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfCCR0L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 12:26:11 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:51778 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfCCR0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 12:26:11 -0500
Received: from 79.184.253.110.ipv4.supernova.orange.pl (79.184.253.110) (HELO aspire.rjw.lan)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.213)
 id 97e9ea3eed2ba731; Sun, 3 Mar 2019 18:26:09 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
Date:   Sun, 03 Mar 2019 18:24:33 +0100
Message-ID: <2884043.Jv1Mn93hE8@aspire.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ath10k_mac_vif_chan() always returns an error for the given vif
during system-wide resume which reliably triggers two WARN_ON()s
in ath10k_bss_info_changed() and they are not particularly
useful in that code path, so drop them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/net/wireless/ath/ath10k/mac.c
===================================================================
--- linux-pm.orig/drivers/net/wireless/ath/ath10k/mac.c
+++ linux-pm/drivers/net/wireless/ath/ath10k/mac.c
@@ -5705,7 +5705,7 @@ static void ath10k_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_MCAST_RATE &&
-	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
+	    !ath10k_mac_vif_chan(arvif->vif, &def)) {
 		band = def.chan->band;
 		rateidx = vif->bss_conf.mcast_rate[band] - 1;
 
@@ -5743,7 +5743,7 @@ static void ath10k_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
+		if (ath10k_mac_vif_chan(vif, &def)) {
 			mutex_unlock(&ar->conf_mutex);
 			return;
 		}

