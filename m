Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:47481 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab2LGGtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 01:49:43 -0500
Message-ID: <50C1917E.2010407@posedge.com> (sfid-20121207_074946_466854_A5CA27BF)
Date: Fri, 07 Dec 2012 12:19:34 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix the multiple warnings for budding chipsets
 without ampdu_action defined
References: <201212070645.qB76jSjN013395@chaitanya-desktop>
In-Reply-To: <201212070645.qB76jSjN013395@chaitanya-desktop>
Content-Type: multipart/mixed;
 boundary="------------010604080503030804070006"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010604080503030804070006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



Warn once should suffice.

Eg: our driver doesn't support the ampdu_action yet, so
seeing a lot of warnings, hence the check for any
new drivers to avoid messing the kernel log.


Signed-off-by: T Krushna Chaitanya <chaitanyatk@posedge.com>
--- 
net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4152ed1..eb9df22 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
 	trace_api_start_tx_ba_session(pubsta, tid);
 
-	if (WARN_ON(!local->ops->ampdu_action))
+	if (WARN_ON_ONCE(!local->ops->ampdu_action))
 		return -EINVAL;
 
 	if ((tid >= IEEE80211_NUM_TIDS) ||





--------------010604080503030804070006
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010604080503030804070006--
