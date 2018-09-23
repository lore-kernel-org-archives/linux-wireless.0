Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbeIXA5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Sep 2018 20:57:48 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] cfg80211: fix reg_query_regdb_wmm kernel-doc
Message-ID: <cfbd4e00-0abc-f265-9e38-ce6655f09b83@infradead.org> (sfid-20180923_210000_145110_56694441)
Date: Sun, 23 Sep 2018 11:59:13 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Drop @ptr from kernel-doc for function reg_query_regdb_wmm().
This function parameter was recently removed so update the
kernel-doc to match that and remove the kernel-doc warnings.

Removes 109 occurrences of this warning message:
../include/net/cfg80211.h:4869: warning: Excess function parameter 'ptr' description in 'reg_query_regdb_wmm'

Fixes: 38cb87ee47fb ("cfg80211: make wmm_rule part of the reg_rule structure")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 include/net/cfg80211.h |    2 --
 1 file changed, 2 deletions(-)

--- lnx-419-rc5.orig/include/net/cfg80211.h
+++ lnx-419-rc5/include/net/cfg80211.h
@@ -4852,8 +4852,6 @@ const char *reg_initiator_name(enum nl80
  *
  * @alpha2: the ISO/IEC 3166 alpha2 wmm rule to be queried.
  * @freq: the freqency(in MHz) to be queried.
- * @ptr: pointer where the regdb wmm data is to be stored (or %NULL if
- *	irrelevant). This can be used later for deduplication.
  * @rule: pointer to store the wmm rule from the regulatory db.
  *
  * Self-managed wireless drivers can use this function to  query
