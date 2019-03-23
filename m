Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5455C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 834742148D
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 20:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="WDTCNEvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfCWUt2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 16:49:28 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:47396 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbfCWUt2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 16:49:28 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 7F1A4C8E
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 20:49:26 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gk_yW2BhYSrG for <linux-wireless@vger.kernel.org>;
        Sat, 23 Mar 2019 15:49:26 -0500 (CDT)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 50ABACA3
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 15:49:26 -0500 (CDT)
Received: by mail-it1-f197.google.com with SMTP id w200so5193142itc.8
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 13:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jZwkQfR3PdlNoXCLSo9JqoN1IY9HWnStGvd4CfPoCLk=;
        b=WDTCNEvDYeHNuFTrfa4TPC09Fu0vREKReKMuP2wjC37czRlsLKfd/pxB/LDO27foDv
         MvTNzVT0PufjpHZZy0bxFWfat1yLay6fAyv6iNrQDGCfQP7Z6zB8n5zKltp5Mwc2fyCg
         5hlGvZbxVRTf0GDLqKoqt5oDO3McgKr9t8FpWuL6rmBrKFjd5zKXSNI4uVI4dtFRfL5+
         51sdQWT6Kpgt6O1CvIe2VOWr1bPsFh+nk8tNsH/xSSFa465SYNlDP2HIoN1cqcOZzMn+
         cJIBnh7m5/X6qSiee/6RPwp8lobXNAVO7rod1ZN1T4mn3fRLshe9rX06HkRcV2TL6NSH
         srAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jZwkQfR3PdlNoXCLSo9JqoN1IY9HWnStGvd4CfPoCLk=;
        b=ojCULi8BWzKZdnU0H9sVvGSzrJJ4A5Asp8D4a8qOiYLS95Bi2nuEyprcMG+iPgK2WP
         M1I0lZhTm4aSKTP0rPGxg39/H4gjT2sMaPzMBawEpFl+a2Tkzvkd2oalCgiWjjIUPy7/
         lC4S54mIicWD5MCUz69w/oxNTKtIxsnwHJTOORysu1olEJEFdE0f7vZXM4seFi2J+Z3o
         sr1JaeniZoxSfrXkYGR8eRGwSEkZ/2CfKo0DzBNYK9bGvAj51qWyAa0Mu4/E3r29s5mj
         vQ54slPKkTr7KcPdLtG72S8KDaOEHdpEabHSpwMxlXui+m4eDRj8qa4BrztcWypuoKuO
         QjFQ==
X-Gm-Message-State: APjAAAVMbJcopdlNwJLfDSP00r8ViSXxKdOUgNVNy6rfZrTtca6wKtUl
        z7DCC+tZyZ1jPK5ucdjZSB37vu28rgPT2nciHiQXUfEMDzoa8Jxu/ZT6cIuKDkVShwcG5rDe/z5
        tLhrNT4jZMaoNJNpExIrNDi4qwf2V528=
X-Received: by 2002:a24:fcc1:: with SMTP id b184mr3035566ith.160.1553374165885;
        Sat, 23 Mar 2019 13:49:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXy6m2reLTCXl+O7yWe+NWwnoGE7LDXgFSbXHHbTcJojRUjqijrg3cYIpsOLv2n2gQutSjQQ==
X-Received: by 2002:a24:fcc1:: with SMTP id b184mr3035558ith.160.1553374165652;
        Sat, 23 Mar 2019 13:49:25 -0700 (PDT)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id w14sm3256529iol.32.2019.03.23.13.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Mar 2019 13:49:25 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] rsi: Fix NULL pointer dereference in kmalloc
Date:   Sat, 23 Mar 2019 15:49:16 -0500
Message-Id: <20190323204916.8368-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kmalloc can fail in rsi_register_rates_channels but memcpy still attempts
to write to channels. The patch replaces these calls with kmemdup and
passes the error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>

---
v1: Fix kmalloc failure by displaying a message. Change it to return the
error upstream, suggested by Joe, Johannes.
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 30 ++++++++++++---------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 831046e760f8..49df3bb08d41 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -188,27 +188,27 @@ bool rsi_is_cipher_wep(struct rsi_common *common)
  * @adapter: Pointer to the adapter structure.
  * @band: Operating band to be set.
  *
- * Return: None.
+ * Return: int - 0 on success, negative error on failure.
  */
-static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
+static int rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 {
 	struct ieee80211_supported_band *sbands = &adapter->sbands[band];
 	void *channels = NULL;
 
 	if (band == NL80211_BAND_2GHZ) {
-		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
-		memcpy(channels,
-		       rsi_2ghz_channels,
-		       sizeof(rsi_2ghz_channels));
+		channels = kmemdup(rsi_2ghz_channels, sizeof(rsi_2ghz_channels),
+				   GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
 		sbands->band = NL80211_BAND_2GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_2ghz_channels);
 		sbands->bitrates = rsi_rates;
 		sbands->n_bitrates = ARRAY_SIZE(rsi_rates);
 	} else {
-		channels = kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);
-		memcpy(channels,
-		       rsi_5ghz_channels,
-		       sizeof(rsi_5ghz_channels));
+		channels = kmemdup(rsi_5ghz_channels, sizeof(rsi_5ghz_channels),
+				   GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
 		sbands->band = NL80211_BAND_5GHZ;
 		sbands->n_channels = ARRAY_SIZE(rsi_5ghz_channels);
 		sbands->bitrates = &rsi_rates[4];
@@ -227,6 +227,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	sbands->ht_cap.mcs.rx_mask[0] = 0xff;
 	sbands->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	/* sbands->ht_cap.mcs.rx_highest = 0x82; */
+	return 0;
 }
 
 static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
@@ -2064,11 +2065,16 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->available_antennas_rx = 1;
 	wiphy->available_antennas_tx = 1;
 
-	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
+	status = rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);
+	if (status)
+		return status;
 	wiphy->bands[NL80211_BAND_2GHZ] =
 		&adapter->sbands[NL80211_BAND_2GHZ];
 	if (common->num_supp_bands > 1) {
-		rsi_register_rates_channels(adapter, NL80211_BAND_5GHZ);
+		status = rsi_register_rates_channels(adapter,
+						     NL80211_BAND_5GHZ);
+		if (status)
+			return status;
 		wiphy->bands[NL80211_BAND_5GHZ] =
 			&adapter->sbands[NL80211_BAND_5GHZ];
 	}
-- 
2.17.1

