Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0HRNB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 09:01:26 -0400
Subject: [PATCH v2] mac80211: fix docbook
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1282130871.3664.5.camel@jlt3.sipsolutions.net>
References: <1282130871.3664.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:01:23 +0200
Message-ID: <1282136483.13315.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix a small problem in the documentation for
ieee80211_request_smps, and a now erroneous
inclusion of enum ieee80211_key_alg, which no
longer exists after the change to ciphers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    1 -
 include/net/mac80211.h           |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-18 13:26:33.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-18 13:26:43.000000000 +0200
@@ -2546,7 +2546,7 @@ void ieee80211_chswitch_done(struct ieee
 /**
  * ieee80211_request_smps - request SM PS transition
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- * @mode: new SM PS mode
+ * @smps_mode: new SM PS mode
  *
  * This allows the driver to request an SM PS transition in managed
  * mode. This is useful when the driver has more information than
--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-08-18 14:53:44.000000000 +0200
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-08-18 14:54:25.000000000 +0200
@@ -248,7 +248,6 @@ MISSING
   <!-- intentionally multiple !F lines to get proper order -->
 !Finclude/net/mac80211.h set_key_cmd
 !Finclude/net/mac80211.h ieee80211_key_conf
-!Finclude/net/mac80211.h ieee80211_key_alg
 !Finclude/net/mac80211.h ieee80211_key_flags
       </chapter>
 


