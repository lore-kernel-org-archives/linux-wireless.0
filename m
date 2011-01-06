Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1AFViH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:38:07 -0500
Message-Id: <20110106213715.504494360@sipsolutions.net>
Date: Thu, 06 Jan 2011 22:36:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: add doc short section on LED triggers
References: <20110106213643.454994320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just create a section to collect the LED trigger
functions and add a very short description as to
what drivers should do.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2011-01-06 22:30:55.000000000 +0100
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2011-01-06 22:33:25.000000000 +0100
@@ -285,10 +285,6 @@ MISSING
 !Finclude/net/mac80211.h ieee80211_ops
 !Finclude/net/mac80211.h ieee80211_alloc_hw
 !Finclude/net/mac80211.h ieee80211_register_hw
-!Finclude/net/mac80211.h ieee80211_get_tx_led_name
-!Finclude/net/mac80211.h ieee80211_get_rx_led_name
-!Finclude/net/mac80211.h ieee80211_get_assoc_led_name
-!Finclude/net/mac80211.h ieee80211_get_radio_led_name
 !Finclude/net/mac80211.h ieee80211_unregister_hw
 !Finclude/net/mac80211.h ieee80211_free_hw
       </chapter>
@@ -399,6 +395,23 @@ MISSING
         </para>
       </partintro>
 
+      <chapter id="led-support">
+        <title>LED support</title>
+        <para>
+         Mac80211 supports various ways of blinking LEDs. Wherever possible,
+         device LEDs should be exposed as LED class devices and hooked up to
+         the appropriate trigger, which will then be triggered appropriately
+         by mac80211.
+        </para>
+!Finclude/net/mac80211.h ieee80211_get_tx_led_name
+!Finclude/net/mac80211.h ieee80211_get_rx_led_name
+!Finclude/net/mac80211.h ieee80211_get_assoc_led_name
+!Finclude/net/mac80211.h ieee80211_get_radio_led_name
+!Finclude/net/mac80211.h ieee80211_tpt_blink
+!Finclude/net/mac80211.h ieee80211_tpt_led_trigger_flags
+!Finclude/net/mac80211.h ieee80211_create_tpt_led_trigger
+      </chapter>
+
       <chapter id="hardware-crypto-offload">
         <title>Hardware crypto acceleration</title>
 !Pinclude/net/mac80211.h Hardware crypto acceleration


