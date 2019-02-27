Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE84BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 16:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A6872184A
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 16:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="msSR8KPg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfB0Q2C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:28:02 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:34828 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfB0Q2C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 11:28:02 -0500
Received: from ben-dt4.candelatech.com (firewall.candelatech.com [50.251.239.81])
        by mail2.candelatech.com (Postfix) with ESMTP id C898B40A5CB;
        Wed, 27 Feb 2019 08:27:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com C898B40A5CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1551284879;
        bh=fIKB+NSf2zXTj3lS4e9EF1OHbO9lzoOEYy/BpNkpdHI=;
        h=From:To:Cc:Subject:Date:From;
        b=msSR8KPgo3brjTFbKX56jv3/AJxtLsy+y1g6P+AZI3y4PxACOQK6ioROzPS06h5Ax
         FY6ydkQZmmBPcAQVrOSiehxg3SPIAU5H9O3/QOSgOhxlJWkmSVaNsU9d3DW+UQD1F8
         apwmp6nVrA8InvbmsfPOtkDY+ojBUS9zK0MJwtFs=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Free beacon buf later in vdev teardown.
Date:   Wed, 27 Feb 2019 08:27:56 -0800
Message-Id: <20190227162756.13048-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

My wave-1 firmware often crashes when I am bringing down
AP vdevs, and sometimes at least some machines lockup hard
after spewing IOMMU errors.

I don't see the same issue in STA mode, so I suspect beacons
are the issue.

Moving the beacon buf deletion to later in the vdev teardown
logic appears to help this problem.  Firmware still crashes
often, but several iterations did not show IOMMU errors and
machine didn't hang.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f70c48ec9464..c38561788791 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6142,10 +6142,6 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
-	spin_lock_bh(&ar->data_lock);
-	ath10k_mac_vif_beacon_cleanup(arvif);
-	spin_unlock_bh(&ar->data_lock);
-
 	ret = ath10k_spectral_vif_stop(arvif);
 	if (ret)
 		ath10k_warn(ar, "failed to stop spectral for vdev %i: %d\n",
@@ -6204,6 +6200,10 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 			peer->vif = NULL;
 		}
 	}
+
+	/* Clean this up late, less opportunity for firmware to access
+	   DMA memory we have deleted. */
+	ath10k_mac_vif_beacon_cleanup(arvif);
 	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
-- 
2.20.1

