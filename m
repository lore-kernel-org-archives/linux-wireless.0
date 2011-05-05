Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab1EEXst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 19:48:49 -0400
Date: Thu, 05 May 2011 18:48:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix build error when CONFIG_PM is not defined
Message-ID: <4dc3375f.3VdEfQKL1lidemOn%Larry.Finger@lwfinger.net> (sfid-20110506_014853_920653_A302E59A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 is built without CONFIG_PM being defined, the following errors
are output:

net/mac80211/main.c: In function ‘ieee80211_register_hw’:
net/mac80211/main.c:700: error: ‘const struct ieee80211_ops’ has no member named ‘suspend’
net/mac80211/main.c:700: error: ‘const struct ieee80211_ops’ has no member named ‘resume’
make[2]: *** [net/mac80211/main.o] Error 1
make[1]: *** [net/mac80211] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [net] Error 2

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c
+++ wireless-testing/net/mac80211/main.c
@@ -696,8 +696,11 @@ int ieee80211_register_hw(struct ieee802
 		WLAN_CIPHER_SUITE_AES_CMAC
 	};
 
-	if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns) &&
-	    (!local->ops->suspend || !local->ops->resume))
+	if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns)
+#ifdef CONFIG_PM
+	    && (!local->ops->suspend || !local->ops->resume)
+#endif
+	    )
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
