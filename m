Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYDUQ77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 12:59:59 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 09:59:55 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 1/9] rt2x00: Support hardware RTS and CTS-to-self frames
Date: Mon, 21 Apr 2008 18:59:48 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200804211859.48443.IvDoorn@gmail.com> (sfid-20080421_190101_803194_88032DA9)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver has set the set_rts_threshold() callback function
to mac80211 it is capable of generating RTS and CTS-to-self frames
inside the hardware and rt2x00lib doesn't have to create them
in software.
Only rt2800pci and rt2800usb support this feature.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c206b50..e46d406 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -118,11 +118,16 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * create and queue that frame first. But make sure we have
 	 * at least enough entries available to send this CTS/RTS
 	 * frame as well as the data frame.
+	 * Note that when the driver has set the set_rts_threshold()
+	 * callback function it doesn't need software generation of
+	 * neither RTS or CTS-to-self frames and handles everything
+	 * inside the hardware.
 	 */
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
 	    (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
-			       IEEE80211_TXCTL_USE_CTS_PROTECT))) {
+			       IEEE80211_TXCTL_USE_CTS_PROTECT)) &&
+	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
 			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 			return NETDEV_TX_BUSY;
-- 
1.5.4.5

