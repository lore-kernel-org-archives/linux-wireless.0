Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0H3TQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:25 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so3422616eyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/10] rt2x00: Update rt2800 comments regarding AMPDU and PACKET_ID in TXWI
Date: Mon, 30 Aug 2010 21:12:47 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com>
In-Reply-To: <201008302112.25578.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302112.48658.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 5c006a7..70a5cb8 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1953,6 +1953,8 @@ struct mac_iveiv_entry {
  * TX_OP: 0:HT TXOP rule , 1:PIFS TX ,2:Backoff, 3:sifs
  * BW: Channel bandwidth 20MHz or 40 MHz
  * STBC: 1: STBC support MCS =0-7, 2,3 : RESERVED
+ * AMPDU: 1: this frame is eligible for AMPDU aggregation, the hw will
+ *        aggregate consecutive frames with the same RA and QoS TID.
  */
 #define TXWI_W0_FRAG			FIELD32(0x00000001)
 #define TXWI_W0_MIMO_PS			FIELD32(0x00000002)
@@ -1976,7 +1978,9 @@ struct mac_iveiv_entry {
  * WIRELESS_CLI_ID: Client ID for WCID table access
  * MPDU_TOTAL_BYTE_COUNT: Length of 802.11 frame
  * PACKETID: Will be latched into the TX_STA_FIFO register once the according
- *           frame was processed. 0: Don't report tx status for this frame.
+ *           frame was processed. If multiple frames are aggregated together
+ *           (AMPDU==1) the reported tx status will always contain the packet
+ *           id of the first frame. 0: Don't report tx status for this frame.
  */
 #define TXWI_W1_ACK			FIELD32(0x00000001)
 #define TXWI_W1_NSEQ			FIELD32(0x00000002)
-- 
1.7.2.2

