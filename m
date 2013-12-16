Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53832 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3LPWBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:14 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so5524537obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:13 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 8/8] b43: Set B43_MACCTL_HWPS when PM should be set
Date: Mon, 16 Dec 2013 16:01:00 -0600
Message-Id: <1387231260-2849-9-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230131_996397_3F2744A6)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even though powersave is not supported the HWPS bit still needs
to be set in order to transmit nullfunc frames with PM set. Add
support for the change_ps callback to set this bit whenever the
powersave mode requires PM to be set.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/b43/main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index bc6ba1c..d883160 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4030,6 +4030,21 @@ out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 }
 
+static void b43_op_change_ps(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	unsigned int ps_flags;
+
+	if (vif->ps_mode == IEEE80211_VIF_PS_DOZE ||
+	    vif->ps_mode == IEEE80211_VIF_PS_AWAKE_PM)
+		ps_flags = B43_PS_ENABLED;
+	else
+		ps_flags = B43_PS_DISABLED;
+
+	b43_power_saving_ctl_bits(wl->current_dev, ps_flags);
+}
+
 static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			  struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key)
@@ -5031,6 +5046,7 @@ static const struct ieee80211_ops b43_hw_ops = {
 	.remove_interface	= b43_op_remove_interface,
 	.config			= b43_op_config,
 	.bss_info_changed	= b43_op_bss_info_changed,
+	.change_ps		= b43_op_change_ps,
 	.configure_filter	= b43_op_configure_filter,
 	.set_key		= b43_op_set_key,
 	.update_tkip_key	= b43_op_update_tkip_key,
-- 
1.8.3.2

