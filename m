Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63297 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1CGCOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:50 -0500
Received: by gxk8 with SMTP id 8so1465250gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:50 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16273.903585.68122@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:41 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 19/34] ath9k_htc: Sync MGMT/DATA packet headers with firmware
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
index 5f30d91..294feb1 100644
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
1.7.4.1

