Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:55383 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1AaSsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:48:21 -0500
Subject: [PATCH 08/22] zd1211rw: fix ack_pending in filter_ack causing
	tx-packet ordering problem on monitor
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:48:16 +0200
Message-ID: <20110131184816.10044.26884.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
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
index ab0d1b9..84ac95e 100644
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

