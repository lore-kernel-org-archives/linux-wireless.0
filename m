Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1C2N2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 09:28:15 -0400
Subject: [PATCH v2] iwlegacy: fix bugs in change_interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1301405175.3834.15.camel@jlt3.sipsolutions.net>
References: <1301400359.3834.12.camel@jlt3.sipsolutions.net>
	 <20110329132231.GA6919@redhat.com>
	 <1301405175.3834.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 15:28:11 +0200
Message-ID: <1301405291.3834.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If change_interface gets invoked during a firmware
restart, it may crash; prevent that from happening
by checking if ctx->vif is assigned.

Additionally, in my initial commit I forgot to set
the vif->p2p variable correctly, so fix that too.

Cc: stable@kernel.org [2.6.38+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/iwlegacy/iwl-core.c	2011-03-29 14:04:06.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c	2011-03-29 15:27:21.000000000 +0200
@@ -1805,6 +1805,15 @@ iwl_legacy_mac_change_interface(struct i
 
 	mutex_lock(&priv->mutex);
 
+	if (!ctx->vif || !iwl_legacy_is_ready_rf(priv)) {
+		/*
+		 * Huh? But wait ... this can maybe happen when
+		 * we're in the middle of a firmware restart!
+		 */
+		err = -EBUSY;
+		goto out;
+	}
+
 	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
 
 	if (!(interface_modes & BIT(newtype))) {
@@ -1832,6 +1841,7 @@ iwl_legacy_mac_change_interface(struct i
 	/* success */
 	iwl_legacy_teardown_interface(priv, vif, true);
 	vif->type = newtype;
+	vif->p2p = newp2p;
 	err = iwl_legacy_setup_interface(priv, ctx);
 	WARN_ON(err);
 	/*


