Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:38342 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab0BPTmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 14:42:50 -0500
Received: by fxm7 with SMTP id 7so7633828fxm.28
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 11:42:48 -0800 (PST)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 16 Feb 2010 14:42:28 -0500
Message-ID: <cb0375e11002161142o48fc45c0r32dfd7538bae28f5@mail.gmail.com>
Subject: "Monitor and recover the aggregation TX flow failure" goes a little
	bit nuts
To: trieux.t.nguyen@intel.com, ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running the changeset "iwlwifi: Monitor and recover the
aggregation TX flow failure" on something resembling 2.6.33-rc7, and
I'm getting lots of lag on my connections and stuff like this in
dmesg:

[128694.380917] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:21:d8:49:d6:f2 tid = 0
[128695.217054] call iwl_force_reset(IWL_RF_RESET)
[128697.515296] call iwl_force_reset(IWL_RF_RESET)
[128698.034922] call iwl_force_reset(IWL_RF_RESET)
[128699.602022] call iwl_force_reset(IWL_FW_RESET)
[128699.710573] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[128699.710586] iwlagn 0000:03:00.0: queue number out of range: 0,
must be 10 to 19
[128701.623101] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra =
00:21:d8:49:d6:f2 tid = 0
[128702.526568] call iwl_force_reset(IWL_RF_RESET)
[128703.570138] call iwl_force_reset(IWL_RF_RESET)
[128707.437103] call iwl_force_reset(IWL_RF_RESET)
[128707.649877] call iwl_force_reset(IWL_RF_RESET)
[128707.959510] call iwl_force_reset(IWL_RF_RESET)
[128709.734898] call iwl_force_reset(IWL_RF_RESET)
[128710.778607] call iwl_force_reset(IWL_RF_RESET)
[128712.554917] call iwl_force_reset(IWL_RF_RESET)
[128712.868074] call iwl_force_reset(IWL_FW_RESET)
[128715.166000] call iwl_force_reset(IWL_RF_RESET)
[128717.569235] call iwl_force_reset(IWL_RF_RESET)
[128791.830914] call iwl_force_reset(IWL_RF_RESET)
[128794.441324] call iwl_force_reset(IWL_RF_RESET)
[128795.903410] call iwl_force_reset(IWL_RF_RESET)
[128797.366627] call iwl_force_reset(IWL_RF_RESET)
[128799.245967] call iwl_force_reset(IWL_RF_RESET)
[128804.260292] call iwl_force_reset(IWL_RF_RESET)
[128806.245023] call iwl_force_reset(IWL_RF_RESET)
[128807.709088] call iwl_force_reset(IWL_RF_RESET)
[128810.735958] call iwl_force_reset(IWL_RF_RESET)
[128823.061684] call iwl_force_reset(IWL_RF_RESET)


This is with the following extra patch:

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0d09f57..f39f693 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -678,10 +678,12 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 				BA_TIMEOUT_MAX)) {
 			IWL_DEBUG_RADIO(priv,
 				"call iwl_force_reset(IWL_FW_RESET)\n");
+			printk(KERN_ERR "call iwl_force_reset(IWL_FW_RESET)\n");
 			iwl_force_reset(priv, IWL_FW_RESET);
 		} else {
 			IWL_DEBUG_RADIO(priv,
 				"call iwl_force_reset(IWL_RF_RESET)\n");
+			printk(KERN_ERR "call iwl_force_reset(IWL_RF_RESET)\n");
 			iwl_force_reset(priv, IWL_RF_RESET);
 		}
 	}


Something's wrong here, I think.  This is probably related to bug
#2120 (http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2120).

--Andy
