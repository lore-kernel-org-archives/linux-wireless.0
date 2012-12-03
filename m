Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2LCL4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 06:56:47 -0500
Date: Mon, 3 Dec 2012 12:56:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] mac80211: introduce
 IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Message-ID: <20121203115632.GA2490@redhat.com> (sfid-20121203_125651_063309_2F056771)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
failed BAR frames later instead of tearing down aggr" caused regression
on rt2x00 hardware (connection hangs). This regression was fixed by
commit be03d4a45c09ee5100d3aaaedd087f19bc20d01 "rt2x00: Don't let
mac80211 send a BAR when an AMPDU subframe fails". But the letter
commit, caused yet another problem reported in
https://bugzilla.kernel.org/show_bug.cgi?id=42828#c22

After long discussion in this thread:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-October/005349.html
and testing various alternative solutions, which failed on one or other
setup, we have no other good fix for the issues like just revert both
mentioned earlier commits.

To do not affect other hardware which benefit from commit
f0425beda4d404a6e751439b562100b902ba9c98, instead of reverting it,
introduce flag that when used will restore mac80211 behaviour before
the commit.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
It's fine to queue this to 3.8 and this will get 3.7 and older
releases through -stable.

 include/net/mac80211.h |    5 +++++
 net/mac80211/status.c  |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82558c8..d481cc6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1253,6 +1253,10 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
  *	P2P Interface. This will be honoured even if more than one interface
  *	is supported.
+ *
+ * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
+ *	should be tear down once BAR frame will not be acked.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1281,6 +1285,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
+	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
 };
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 101eb88..c511e9c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -432,7 +432,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
 
-				ieee80211_set_bar_pending(sta, tid, ssn);
+				if (local->hw.flags &
+				    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL)
+					ieee80211_stop_tx_ba_session(&sta->sta, tid);
+				else
+					ieee80211_set_bar_pending(sta, tid, ssn);
 			}
 		}
 
-- 
1.7.4.4

