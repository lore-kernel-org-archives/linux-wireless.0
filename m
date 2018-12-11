Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15A3C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 04:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 951782081B
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 04:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K8/qir+C";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IzRYcOAe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 951782081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbeLKE4V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 23:56:21 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbeLKE4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 23:56:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EC81860B7F; Tue, 11 Dec 2018 04:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544504180;
        bh=qa0/KGmy2+XgApv/BwF2KWlw/HYRLBKDORjacXMfZeQ=;
        h=From:To:Cc:Subject:Date:From;
        b=K8/qir+CFPQmTnYpkTBhCVS4EipmINkZC7nwn/HLfQ+nq8H2LDrWibqo2jRmkny38
         W2a30yOZHvD9gilofhcoDKvH84kxisgOTIwoxxbUMm9nscRsaF1addXlUHpjdrHGPl
         3zbl9G6ZYONF2x58dubcv2AeBfm+LZNqFT06rRck=
Received: from pradeepc-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pradeepc@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0234C60B73;
        Tue, 11 Dec 2018 04:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544504178;
        bh=qa0/KGmy2+XgApv/BwF2KWlw/HYRLBKDORjacXMfZeQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IzRYcOAeiz5RXZgOWDXF74amj7FVgyUjCf2e62ksd66uYGQu5Xe1DlOt6d7CzcyRw
         GlyEfcluF1PZlGTJnqu+s/D9kaseNJszVCzMJRpaLmwOVSo021AoJswUTT+rnu2Pnm
         1Yl8H43ZkGMaJGI6cLEYqIYPFCDAo6cj4tEJu8LE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0234C60B73
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pradeepc@codeaurora.org
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
Date:   Mon, 10 Dec 2018 20:56:11 -0800
Message-Id: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Pradeep kumar Chitrapu <pradeepc@codeaurora.org>

Invalid rate code is sent to firmware when multicast rate value of 0 is
sent to driver indicating disabled case, causing broken mesh path.
so fix that.

Tested on QCA9984 with firmware 10.4-3.6.1-00827

Fixes: cd93b83ad92 ("ath10k: support for multicast rate control")
Co-developed-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6771d8185af5..4546b73b2e45 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5486,8 +5486,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
 	u16 bitrate, hw_value;
-	u8 rate, basic_rate_idx;
-	int rateidx, ret = 0, hw_rate_code;
+	u8 rate, basic_rate_idx, rateidx;
+	int ret = 0, hw_rate_code, mcast_rate;
 	enum nl80211_band band;
 	const struct ieee80211_supported_band *sband;
 
@@ -5674,7 +5674,11 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_MCAST_RATE &&
 	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
 		band = def.chan->band;
-		rateidx = vif->bss_conf.mcast_rate[band] - 1;
+		mcast_rate = vif->bss_conf.mcast_rate[band];
+		if (mcast_rate > 0)
+			rateidx = mcast_rate - 1;
+		else
+			rateidx = ffs(vif->bss_conf.basic_rates) - 1;
 
 		if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY)
 			rateidx += ATH10K_MAC_FIRST_OFDM_RATE_IDX;
-- 
1.9.1

