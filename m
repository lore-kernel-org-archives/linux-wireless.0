Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45448 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751025AbeEUUfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 16:35:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ebiggers3@gmail.com, Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 May 2018 23:34:57 +0300
Message-Id: <20180521203457.17242-1-luca@coelho.fi> (sfid-20180521_223511_004087_F887B9BB)
In-Reply-To: <20180519183345.GA701@sol.localdomain>
References: <20180519183345.GA701@sol.localdomain>
Subject: [PATCH] cfg80211: fix NULL pointer derference when querying regdb
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Some drivers may call this function when regdb is not initialized yet,
so we need to make sure regdb is valid before trying to access it.

Make sure regdb is initialized before trying to access it in
reg_query_regdb_wmm() and query_regdb().

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9806380ec671..91ebe2425b0d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -916,6 +916,9 @@ int reg_query_regdb_wmm(char *alpha2, int freq, u32 *dbptr,
 	const struct fwdb_header *hdr = regdb;
 	const struct fwdb_country *country;
 
+	if (!regdb)
+		return -ENODATA;
+
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
-- 
2.17.0
