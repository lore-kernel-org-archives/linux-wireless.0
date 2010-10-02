Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0JBJfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:42 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so2321956wwj.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:41 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/20] rt2x00: Update comment about the AMPDU flag in the TXWI
Date: Sat, 2 Oct 2010 11:33:42 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021132.44146.IvDoorn@gmail.com> <201010021133.18211.IvDoorn@gmail.com>
In-Reply-To: <201010021133.18211.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021133.43033.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

During testing with AMPDUs it turned out that the rt2800 hw will aggregate
consecutive frames with the same RA and TID when the first frame in a
possible aggregate has set AMPDU=1 in the TXWI. If a following frame has
set AMPDU=0 in its TXWI it might sill end up in the aggregate of the
previous frame. Update the comment accordingly.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2a9f402..eb8b6ca 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2003,7 +2003,13 @@ struct mac_iveiv_entry {
  *     duplicate the frame to both channels).
  * STBC: 1: STBC support MCS =0-7, 2,3 : RESERVED
  * AMPDU: 1: this frame is eligible for AMPDU aggregation, the hw will
- *        aggregate consecutive frames with the same RA and QoS TID.
+ *        aggregate consecutive frames with the same RA and QoS TID. If
+ *        a frame A with the same RA and QoS TID but AMPDU=0 is queued
+ *        directly after a frame B with AMPDU=1, frame A might still
+ *        get aggregated into the AMPDU started by frame B. So, setting
+ *        AMPDU to 0 does _not_ necessarily mean the frame is sent as
+ *        MPDU, it can still end up in an AMPDU if the previous frame
+ *        was tagged as AMPDU.
  */
 #define TXWI_W0_FRAG			FIELD32(0x00000001)
 #define TXWI_W0_MIMO_PS			FIELD32(0x00000002)
-- 
1.7.2.3

