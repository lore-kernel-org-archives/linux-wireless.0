Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1KRIWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:14 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MERf022728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 38/77] iwlegacy: add accidentally removed comments
Date: Fri, 18 Nov 2011 09:22:00 +0100
Message-Id: <1321604559-10707-38-git-send-email-sgruszka@redhat.com> (sfid-20111118_092229_876963_5E74AA59)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d817d8d..a8a6461 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1411,6 +1411,33 @@ void il4965_reply_stats(struct il_priv *il,
 	il4965_rx_stats(il, rxb);
 }
 
+
+/*
+ * mac80211 queues, ACs, hardware queues, FIFOs.
+ *
+ * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
+ *
+ * Mac80211 uses the following numbers, which we get as from it
+ * by way of skb_get_queue_mapping(skb):
+ *
+ *     VO      0
+ *     VI      1
+ *     BE      2
+ *     BK      3
+ *
+ *
+ * Regular (not A-MPDU) frames are put into hardware queues corresponding
+ * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
+ * own queue per aggregation session (RA/TID combination), such queues are
+ * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
+ * order to map frames to the right queue, we also need an AC->hw queue
+ * mapping. This is implemented here.
+ *
+ * Due to the way hw queues are set up (by the hw specific modules like
+ * iwl-4965.c), the AC->hw queue mapping is the identity
+ * mapping.
+ */
+
 static const u8 tid_to_ac[] = {
 	IEEE80211_AC_BE,
 	IEEE80211_AC_BK,
-- 
1.7.1

