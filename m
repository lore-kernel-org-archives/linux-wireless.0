Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXJFMDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:03:54 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:03:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/16] rt2x00: Remove radio check from rt2x00lib_toggle_rx
Date: Sat, 6 Oct 2007 14:12:13 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061412.14437.IvDoorn@gmail.com> (sfid-20071006_130401_442456_C1BC87FD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't check if the radio is enabled in rt2x00lib_toggle_rx,
this is required since the link tuner should be disabled
when shutting down the device. The remaining calls inside the
rt2x00lib_toggle_rx handler should deliver no problems when
called while the radio is done.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0216096..b6a5c34 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -164,9 +164,6 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
 {
 	enum dev_state state = enable ? STATE_RADIO_RX_ON : STATE_RADIO_RX_OFF;
 
-	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
-		return;
-
 	/*
 	 * When we are disabling the RX, we should also stop the link tuner.
 	 */
-- 
1.5.3.4

