Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47247 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab0IRJ5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 05:57:07 -0400
Received: by bwz11 with SMTP id 11so3374663bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 02:57:05 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] compat-wireless: Select minstrel_ht as default rc algo
Date: Sat, 18 Sep 2010 11:56:06 +0200
Message-Id: <1284803766-27710-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless-testing is using minstrel_ht already as default rc algorithm.
Do the same im compat-wireless. Setting CONFIG_MAC80211_RC_DEFAULT
manually is needed in compat-wireless since it doesn't have the Kconfig
magic to automagically select minstrel_ht if it is compiled in.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 config.mk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index b61c318..a021172 100644
--- a/config.mk
+++ b/config.mk
@@ -124,12 +124,12 @@ CONFIG_MAC80211=m
 # CONFIG_MAC80211_DRIVER_API_TRACER=y
 
 # choose between pid and minstrel as default rate control algorithm
-CONFIG_MAC80211_RC_DEFAULT=minstrel
+CONFIG_MAC80211_RC_DEFAULT=minstrel_ht
 CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
 # CONFIG_MAC80211_RC_DEFAULT_PID=y
 # This is the one used by our compat-wireless net/mac80211/rate.c
 # in case you have and old kernel which is overriding this to pid.
-CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel
+CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
 CONFIG_MAC80211_RC_PID=y
 CONFIG_MAC80211_RC_MINSTREL=y
 CONFIG_MAC80211_RC_MINSTREL_HT=y
-- 
1.7.1

