Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:48985 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaAWTHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 14:07:44 -0500
Received: by mail-we0-f175.google.com with SMTP id p61so1689520wes.34
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 11:07:43 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] mac80211: send {ADD,DEL}BA on AC_VO like other mgmt frames, as per spec
Date: Thu, 23 Jan 2014 20:06:34 +0100
Message-Id: <1390503994-13496-1-git-send-email-karl.beldan@gmail.com> (sfid-20140123_200748_820570_2CD395DE)
In-Reply-To: <1390486106.4142.15.camel@jlt4.sipsolutions.net>
References: <1390486106.4142.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

ATM, {ADD,DEL}BA and BAR frames are sent on the AC matching the TID of
the BA parameters. Johannes recalled [1] that it fixed some races with
the DELBA and indeed this behavior was introduced in [2].
While [2] is right for the BARs, the part queueing the {ADD,DEL}BAs on
their BA params TID AC violates the spec and is more a workaround for
some drivers. Helmut expressed [2] some concerns wrt such drivers, in
particular DELBAs in rt2x00.
ATM, DELBAs are sent after a driver has called (hence "purposely")
ieee80211_start_tx_ba_cb_irqsafe and Johannes and Emmanuel gave [2] some
details wrt intentions behind the split of the IEEE80211_AMPDU_TX_STOP_*
given to the drv ampdu_action supposed to call this function, which
could prove handy to people trying to do the right thing in faulty
drivers (if their fw/hw don't get in their way).

[1] Message-Id: http://mid.gmane.org/1390391564-18481-1-git-send-email-karl.beldan@gmail.com
[2] Commit: cf6bb79ad8287cd9fe87 ("mac80211: Use appropriate TID for sending BAR, ADDBA and DELBA frames")

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/agg-tx.c | 2 +-
 net/mac80211/ht.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 13b7683..ce9633a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -107,7 +107,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index fab7b91..dc3c280 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -375,7 +375,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid);
+	ieee80211_tx_skb(sdata, skb);
 }
 
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.1.19.gdaad3aa

