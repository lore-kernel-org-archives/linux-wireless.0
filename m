Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:56773 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1ADXst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:48:49 -0500
Subject: [RFC PATCH 07/17] zd1211rw: fix ack_pending in filter_ack causing
	tx-packet ordering problem on monitor
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:48:45 +0200
Message-ID: <20110104234845.25309.78285.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For reasons not very clear yet to me, filter_ack leaves matching tx-packet
pending with 'ack_pending'. This causes tx-packet to be passed back to upper
layer after next packet has been transfered and tx-packets might end up
coming come out of monitor interface in wrong order vs. rx.

Because of this when enable AP-mode, hostapd monitor interface would get
packets in wrong order causing problems in WPA association.

So don't use mac->ack_pending when in AP-mode.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 0ef27db..9dde27a 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -799,6 +799,13 @@ static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 
 		mac->ack_pending = 1;
 		mac->ack_signal = stats->signal;
+
+		/* Prevent pending tx-packet on AP-mode */
+		if (mac->type == NL80211_IFTYPE_AP) {
+			skb = __skb_dequeue(q);
+			zd_mac_tx_status(hw, skb, mac->ack_signal, NULL);
+			mac->ack_pending = 0;
+		}
 	}
 
 	spin_unlock_irqrestore(&q->lock, flags);

