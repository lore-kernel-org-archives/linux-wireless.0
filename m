Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYDDOaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:30:11 -0400
Subject: [PATCH] iwlwifi: honour regulatory restrictions in scan code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:41:56 +0200
Message-Id: <1207298516.19189.16.camel@johannes.berg> (sfid-20080404_153021_591180_7D07AB0B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When doing firmware-assisted scanning, iwlwifi drivers do not
honour the regulatory control code that might disable channels
that are enabled in the EEPROM, for example when the user is
visiting another country and adjusted the regulatory domain
accordingly. This patch fixes that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +++
 2 files changed, 6 insertions(+)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-03 18:52:45.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-03 18:53:07.000000000 +0200
@@ -4965,6 +4965,9 @@ static int iwl3945_get_channels_for_scan
 	passive_dwell = iwl3945_get_passive_dwell_time(priv, band);
 
 	for (i = 0, added = 0; i < sband->n_channels; i++) {
+		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
 		if (channels[i].hw_value ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
 			if (iwl3945_is_associated(priv)) {
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-03 18:52:10.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-03 18:52:41.000000000 +0200
@@ -4828,6 +4828,9 @@ static int iwl4965_get_channels_for_scan
 	passive_dwell = iwl4965_get_passive_dwell_time(priv, band);
 
 	for (i = 0, added = 0; i < sband->n_channels; i++) {
+		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
 		if (ieee80211_frequency_to_channel(channels[i].center_freq) ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
 			if (iwl4965_is_associated(priv)) {


