Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:19887 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab3AXVBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:01:35 -0500
Date: Thu, 24 Jan 2013 22:01:55 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 4/4] rt2x00: print queue parameters at debug level
Message-ID: <20130124210155.GC22800@localhost.localdomain> (sfid-20130124_220138_516763_794ABECA)
References: <20130124205931.GB16252@localhost.localdomain>
 <20130124210028.GA22800@localhost.localdomain>
 <20130124210110.GB22800@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124210110.GB22800@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those messages do not provide interesting information for average user,
print them at debug level.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ed7a1bb..20c6ecc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -731,9 +731,9 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
 	queue->aifs = params->aifs;
 	queue->txop = params->txop;
 
-	INFO(rt2x00dev,
-	     "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
-	     queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
+	DEBUG(rt2x00dev,
+	      "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
+	      queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
 
 	return 0;
 }
-- 
1.7.4.4

