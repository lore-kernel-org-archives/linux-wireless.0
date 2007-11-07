Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58660 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754151AbXKGP3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 10:29:18 -0500
Message-ID: <4731D9CC.3090809@lwfinger.net> (sfid-20071107_152923_022717_8246941C)
Date: Wed, 07 Nov 2007 09:29:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Regression in latest wireless-2.6: commit 43c8321e breaks rate control
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 43c8321e breaks rate control, and my b43 device, on wireless-2.6/everything. The hack below
fixes it:

Index: wireless-2.6/net/mac80211/Kconfig
===================================================================
--- wireless-2.6.orig/net/mac80211/Kconfig
+++ wireless-2.6/net/mac80211/Kconfig
@@ -16,7 +16,7 @@ config MAC80211
 config MAC80211_RCSIMPLE
        bool "'simple' rate control algorithm"
        default y
-       depends on MAC80211 && EMBEDDED
+       depends on MAC80211
        help
          This option allows you to turn off the 'simple' rate
          control algorithm in mac80211. If you do turn it off,

On my system, the symbol EMBEDDED is not defined, thus rcsimple, the only rate-control mechanism I
need to use, is not built.

Larry
