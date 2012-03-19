Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:3600 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2CSNhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:37:23 -0400
Message-ID: <4F673690.40302@raritan.com> (sfid-20120319_143729_946181_49D4C2C2)
Date: Mon, 19 Mar 2012 14:37:20 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org,
	RT2x00 Users <users@rt2x00.serialmonkey.com>
Subject: [PATCH] mac80211: when receiving DTIM disable power-save mode only
 if it was enabled
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving DTIM we currently disable power save mode in the
hardware unconditionally, i.e. also when the hardware was not sleeping.
This causes trouble with at least one wireless chipset (Ralink RT3572).
When the hardware is not sleeping and we send a wakeup command (e.g.
this happens after a scan) then a significant decrease of the link
quality or a disconnect may occur.
Disabling power save mode only when it was enabled prevents this issue.

Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
---
Index: linux/net/mac80211/mlme.c
===================================================================
--- linux/net/mac80211/mlme.c	(revision 213137)
+++ linux/net/mac80211/mlme.c	(working copy)
@@ -1922,9 +1922,11 @@
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
-				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-				ieee80211_hw_config(local,
-						    IEEE80211_CONF_CHANGE_PS);
+				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+					local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+					ieee80211_hw_config(local,
+							    IEEE80211_CONF_CHANGE_PS);
+				}
 				ieee80211_send_nullfunc(local, sdata, 0);
 			} else {
 				local->pspolling = true;
