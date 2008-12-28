Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:54900 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYL1SyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 13:54:18 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 056BE8BD2A
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 20:54:16 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id D47622BD42
	for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 20:54:14 +0200 (EET)
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] mac80211: add declarations for wake/stop_queue_by_reason()
To: linux-wireless@vger.kernel.org
Date: Sun, 28 Dec 2008 20:54:14 +0200
Message-ID: <20081228185414.6204.97451.stgit@tikku> (sfid-20081228_195454_993874_52CF1FA0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes sparse warnings:

net/mac80211/util.c:355:6: warning: symbol 
  'ieee80211_wake_queue_by_reason' was not declared. Should it be static?
net/mac80211/util.c:385:6: warning: symbol 
  'ieee80211_stop_queue_by_reason' was not declared. Should it be static?

Thanks to Johannes Berg for reporting this.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 net/mac80211/ieee80211_i.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 117718b..b6b40ec 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -991,6 +991,10 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
 
+void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason);
+void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+				    enum queue_stop_reason reason);
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,

