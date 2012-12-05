Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40919 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:13:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so7732788ieb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 01:13:29 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 5 Dec 2012 14:43:09 +0530
Message-ID: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com> (sfid-20121205_101334_375340_F38F6023)
Subject: [PATCH] mac80211: fixing the warning storm for budding chipsets
 without ampdu_action defined
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Warn once should suffice.

Eg: our driver doesn't support the ampdu_action yet, so
seeing a lot of warnings, hence the check for any
new drivers to avoid messing the kernel log.

Signed-off-by: Chaitanya T K<chaitanya.mgit@gmail.com>
---
 net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4152ed1..eb9df22 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct
ieee80211_sta *pubsta, u16 tid,

        trace_api_start_tx_ba_session(pubsta, tid);

-       if (WARN_ON(!local->ops->ampdu_action))
+       if (WARN_ON_ONCE(!local->ops->ampdu_action))
                return -EINVAL;

        if ((tid >= IEEE80211_NUM_TIDS) ||
