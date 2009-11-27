Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61721 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZK0OID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 09:08:03 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE85nJ025516
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 08:08:08 -0600
Received: from [127.0.1.1] (essapo-nirac2521.europe.nokia.com [10.162.252.1])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE7xJJ004528
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 16:08:03 +0200
Subject: [RFC PATCH v1 1/4] cfg80211: add U-APSD support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 16:07:56 +0200
Message-ID: <20091127140756.2847.34880.stgit@tikku>
In-Reply-To: <20091127140700.2847.42426.stgit@tikku>
References: <20091127140700.2847.42426.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Experimental patch to add U-APSD support to cfg80211, most probably I'll
drop this because I don't see any use for this. If we want to control
U-APSD through cfg80211, this needs to be discussed more.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    1 +
 net/wireless/nl80211.c  |    3 +++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index da8ea2e..7bb020b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1284,6 +1284,7 @@ enum nl80211_meshconf_params {
  * @NL80211_TXQ_ATTR_CWMAX: Maximum contention window [a value of the form
  *	2^n-1 in the range 1..32767]
  * @NL80211_TXQ_ATTR_AIFS: Arbitration interframe space [0..255]
+ * @NL80211_TXQ_ATTR_UAPSD: U-APSD enabled [0..1]
  * @__NL80211_TXQ_ATTR_AFTER_LAST: Internal
  * @NL80211_TXQ_ATTR_MAX: Maximum TXQ attribute number
  */
@@ -1294,6 +1295,7 @@ enum nl80211_txq_attr {
 	NL80211_TXQ_ATTR_CWMIN,
 	NL80211_TXQ_ATTR_CWMAX,
 	NL80211_TXQ_ATTR_AIFS,
+	NL80211_TXQ_ATTR_UAPSD,
 
 	/* keep last */
 	__NL80211_TXQ_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0884b9a..7be82d7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -556,6 +556,7 @@ struct ieee80211_txq_params {
 	u16 cwmin;
 	u16 cwmax;
 	u8 aifs;
+	bool uapsd;
 };
 
 /* from net/wireless.h */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a602843..54c9941 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -670,6 +670,9 @@ static int parse_txq_params(struct nlattr *tb[],
 	txq_params->cwmax = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMAX]);
 	txq_params->aifs = nla_get_u8(tb[NL80211_TXQ_ATTR_AIFS]);
 
+	if (tb[NL80211_TXQ_ATTR_UAPSD])
+		txq_params->uapsd = nla_get_u8(tb[NL80211_TXQ_ATTR_UAPSD]);
+
 	return 0;
 }
 

