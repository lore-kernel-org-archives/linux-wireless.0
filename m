Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYEJMKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:37 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:37 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/5] mac80211: Initialize sta pointer
Date: Sat, 10 May 2008 13:50:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com>
In-Reply-To: <200805101349.19481.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101350.43435.IvDoorn@gmail.com> (sfid-20080510_141046_554298_178ECB59)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch: mac80211: rewrite fragmentation code
introduced the following compile warning:

net/mac80211/tx.c: In function 'ieee80211_master_start_xmit':
net/mac80211/tx.c:1244: warning: 'sta' may be used uninitialized in this function

sta is allowed to be NULL throughout the rest of the function,
so we best initialize it to NULL.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ac891f..2aaf866 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1241,7 +1241,7 @@ static bool validate_control(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key *key;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	struct sta_info *sta;
+	struct sta_info *sta = NULL;
 	u8 *da;
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
1.5.5.1

