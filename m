Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:54335 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaAQIcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:21 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so1596723eaj.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:20 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 5/5] cfg80211: parse STRICT-BW flag for insternal regdb option
Date: Fri, 17 Jan 2014 09:32:04 +0100
Message-Id: <1389947524-6102-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093225_922968_BBCAC33C)
In-Reply-To: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for parsing STRICT-BW flag when internal
regulatory database is used.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/genregdb.awk |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
index 9a8217d..f7aeca9 100644
--- a/net/wireless/genregdb.awk
+++ b/net/wireless/genregdb.awk
@@ -105,6 +105,8 @@ function parse_reg_rule()
 			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
 		} else if (flagarray[arg] == "NO-IR") {
 			flags = flags "\n\t\t\tNL80211_RRF_NO_IR | "
+		} else if (flagarray[arg] == "STRICT-BW") {
+			flags = flags "\n\t\t\tNL80211_RRF_STRICT_BW | "
 		}
 
 	}
-- 
1.7.9.5

