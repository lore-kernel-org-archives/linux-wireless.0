Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:59805 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYL2ICw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 03:02:52 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 64D178BDBD
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 10:02:50 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 4A37F2BD4F
	for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 10:02:49 +0200 (EET)
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v2] mac80211: make wake/stop_queue_by_reason() functions static
To: linux-wireless@vger.kernel.org
Date: Mon, 29 Dec 2008 10:02:48 +0200
Message-ID: <20081229080248.29905.35613.stgit@tikku> (sfid-20081229_090256_174706_F66F5E52)
In-Reply-To: <87sko7ikls.fsf@litku.valot.fi>
References: <87sko7ikls.fsf@litku.valot.fi>
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

 net/mac80211/util.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb89e1d..5cd4303 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -352,8 +352,8 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 	}
 }
 
-void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason)
+static void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
+					   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;
@@ -382,8 +382,8 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	netif_stop_subqueue(local->mdev, queue);
 }
 
-void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
-				    enum queue_stop_reason reason)
+static void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
+					   enum queue_stop_reason reason)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	unsigned long flags;

