Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49072C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0646F2243E
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 19:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Hif/eBaS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0646F2243E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbeKNFbs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 00:31:48 -0500
Received: from nbd.name ([46.4.11.11]:49254 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbeKNFbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 00:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VVwheOmJ0HtnQrpzGpHRkT744EN2WDSNVG06B2DUsiU=; b=Hif/eBaSJ7ObGLOHOu21a0aclb
        Eg+DpEnfcFSoybf2Zihb9MuESYArPDeY640U8nRbueYWL7KKt2csfbfPlAAlPGVtiI+VQFH6J8uEK
        8/oU25XLyJ2XTrbXOaTB1UV8PHo1bnX8fDw5LZlREqDzGUczYHB6SRnAdVkkI1BDj9ZI=;
Received: by maeck.lan (Postfix, from userid 501)
        id BD6AD452EBC7; Tue, 13 Nov 2018 20:32:13 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Subject: [PATCH] mac80211: ignore tx status for PS stations in ieee80211_tx_status_ext
Date:   Tue, 13 Nov 2018 20:32:13 +0100
Message-Id: <20181113193213.87628-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make it behave like regular ieee80211_tx_status calls, except for the lack of
filtered frame processing.
This fixes spurious low-ack triggered disconnections with powersave clients
connected to an AP.

Fixes: f027c2aca0cf4 ("mac80211: add ieee80211_tx_status_noskb")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/status.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index aa4afbf0abaf..a794ca729000 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -964,6 +964,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			/* Track when last TDLS packet was ACKed */
 			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
 				sta->status_stats.last_tdls_pkt_time = jiffies;
+		} else if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+			return;
 		} else {
 			ieee80211_lost_packet(sta, info);
 		}
-- 
2.17.0

