Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61129 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2CNH44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 03:56:56 -0400
Received: by wibhj6 with SMTP id hj6so6694447wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2012 00:56:55 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, IvDoorn@gmail.com, gwingerde@gmail.com,
	sgruszka@redhat.com, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Set IEEE80211_HW_REPORTS_TX_ACK_STATUS in rt2800
Date: Wed, 14 Mar 2012 08:56:47 +0100
Message-Id: <1331711807-32680-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20120314_085701_129884_58408164)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800 already reports the tx ack status of each frame back to mac80211.
Advertise this by setting IEEE80211_HW_REPORTS_TX_ACK_STATUS for rt2800.
This allows some mac80211 features like frame loss notifications to work
with rt2800.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

I don't see a problem with enabling this for rt2800pci.
Ivo, Gertjan, Stanislaw, any objection against enabling for rt2800usb?

Thanks,
Helmut

 drivers/net/wireless/rt2x00/rt2800lib.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 79a9eeb..4d7dc7b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4504,7 +4504,9 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
-	    IEEE80211_HW_AMPDU_AGGREGATION;
+	    IEEE80211_HW_AMPDU_AGGREGATION |
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
 	 * unless we are capable of sending the buffered frames out after the
-- 
1.7.7

