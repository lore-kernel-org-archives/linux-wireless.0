Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:38366 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1DMFwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:52:47 -0400
Received: by pxi2 with SMTP id 2so180423pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:52:47 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15040.267311.154514@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:25:12 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 22/40] ath9k_htc: Sync MGMT/DATA packet headers with firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Add a new cookie field that would be filled by the host.
This can be used to match the TX status WMI event with
the appropriate packet.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 3af8a58..3185fe7 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -85,7 +85,8 @@ struct tx_frame_hdr {
 	__be32 flags; /* ATH9K_HTC_TX_* */
 	u8 key_type;
 	u8 keyix;
-	u8 reserved[26];
+	u8 cookie;
+	u8 pad;
 } __packed;
 
 struct tx_mgmt_hdr {
@@ -95,7 +96,8 @@ struct tx_mgmt_hdr {
 	u8 flags;
 	u8 key_type;
 	u8 keyix;
-	u16 reserved;
+	u8 cookie;
+	u8 pad;
 } __packed;
 
 struct tx_beacon_header {
-- 
1.7.4.4

