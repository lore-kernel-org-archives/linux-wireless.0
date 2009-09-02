Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61670 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZIBOxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 10:53:08 -0400
Received: by fxm17 with SMTP id 17so832646fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 07:53:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 10:53:08 -0400
Message-ID: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
Subject: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Andrew Lutomirski <luto@mit.edu>
To: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now, enabling power saving on iwlwifi is impossible, because
mac80211 won't tell iwlwifi that power saving is on (since
IEEE80211_HW_SUPPORTS_PS is not set) and iwlwifi will ignore the
user's power_level setting until mac80211 asks for power saving.
Setting this flag allows the user to manually enable power saving if
desired.

Signed-off-by: Andy Lutomirski <luto@mit.edu>

---

This fixes what looks to me like a regression: power_level used to
work but now fails silently.  In 2.6.32 I think this code is going
away, but this patch seems like a safe stopgap measure.

iwlwifi mostly ignores mac80211's power settings, but I think
advertising IEEE80211_HW_SUPPORTS_PS should be safe, even this late in
the 2.6.31 cycle because:

1. This patch won't have any effect until the user requests power
saving through wext or nl80211.
2. Even if that happens, the user still has to set power_level in
sysfs for anything to change.
3. As far as I can tell, power_level in sysfs wasn't any safer in
2.6.29 or 2.6.30 than it will be with this patch.
4. This fixes a regression.

The power_level sysfs entry is still rather odd in that setting and
getting don't behave in quite the way that the user would expect
(there should probably be power_level_requested and actual_power_level
as separate entries), but power_level looks like it's going away soon,
so this isn't worth fixing now.

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c
b/drivers/net/wireless/iwlwifi/iwl-core.c
index 18b135f..be6f1e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1325,7 +1325,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_SUPPORTS_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
