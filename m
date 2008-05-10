Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYEJMJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:09:55 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:54 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 04/16] mac80211: Don't encrypt beacons
Date: Sat, 10 May 2008 13:40:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101340.15709.IvDoorn@gmail.com> (sfid-20080510_141013_108972_E3BC630F)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beacons shouldn't be encryped, so mac80211 should set
the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx info flags.
Otherwise the driver will cause a NULL pointer dereference
when it tries to access the info->control.hw_key which isn't
configured.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/mac80211/tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f35eaea..28d8bd5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1898,6 +1898,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
+		control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 		control->retry_limit = 1;
 		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
 	}
-- 
1.5.5.1

