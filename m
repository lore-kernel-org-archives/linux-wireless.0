Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0IQVXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: do not perferm force reset while doing scan
Date: Fri, 17 Sep 2010 14:24:17 -0700
Message-Id: <1284758657-25267-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When uCode error condition detected, driver try to perform either
rf reset or firmware reload in order bring device back to
working condition.

If rf reset is required and scan is in process, there is no need
to issue rf reset since scan already reset the rf.

If firmware reload is required and scan is in process, skip the
reload request. There is a possibility firmware reload during
scan cause problem.

[  485.804046] WARNING: at net/mac80211/main.c:310 ieee80211_restart_hw+0x28/0x62()
[  485.804049] Hardware name: Latitude E6400
[  485.804052] ieee80211_restart_hw called with hardware scan in progress
[  485.804054] Modules linked in: iwlagn iwlcore bnep sco rfcomm l2cap crc16 bluetooth [last unloaded: iwlcore]
[  485.804069] Pid: 812, comm: kworker/u:3 Tainted: G        W   2.6.36-rc3-wl+ #74
[  485.804072] Call Trace:
[  485.804079]  [<c103019a>] warn_slowpath_common+0x60/0x75
[  485.804084]  [<c1030213>] warn_slowpath_fmt+0x26/0x2a
[  485.804089]  [<c145da67>] ieee80211_restart_hw+0x28/0x62
[  485.804102]  [<f8b35dc6>] iwl_bg_restart+0x113/0x150 [iwlagn]
[  485.804108]  [<c10415d5>] process_one_work+0x181/0x25c
[  485.804119]  [<f8b35cb3>] ? iwl_bg_restart+0x0/0x150 [iwlagn]
[  485.804124]  [<c104190a>] worker_thread+0xf9/0x1f2
[  485.804128]  [<c1041811>] ? worker_thread+0x0/0x1f2
[  485.804133]  [<c10451b0>] kthread+0x64/0x69
[  485.804137]  [<c104514c>] ? kthread+0x0/0x69
[  485.804141]  [<c1002df6>] kernel_thread_helper+0x6/0x10
[  485.804145] ---[ end trace 3d4ebdc02d524bbb ]---
[  485.804153] Pid: 812, comm: kworker/u:3 Tainted: G        W   2.6.36-rc3-wl+ #74
[  485.804156] Call Trace:
[  485.804161]  [<c145da9b>] ? ieee80211_restart_hw+0x5c/0x62
[  485.804172]  [<f8b35dcb>] iwl_bg_restart+0x118/0x150 [iwlagn]
[  485.804177]  [<c10415d5>] process_one_work+0x181/0x25c
[  485.804188]  [<f8b35cb3>] ? iwl_bg_restart+0x0/0x150 [iwlagn]
[  485.804192]  [<c104190a>] worker_thread+0xf9/0x1f2
[  485.804197]  [<c1041811>] ? worker_thread+0x0/0x1f2
[  485.804201]  [<c10451b0>] kthread+0x64/0x69
[  485.804205]  [<c104514c>] ? kthread+0x0/0x69
[  485.804209]  [<c1002df6>] kernel_thread_helper+0x6/0x10

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 07dbc27..e23c406 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2613,6 +2613,11 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EINVAL;
 
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "scan in progress.\n");
+		return -EINVAL;
+	}
+
 	if (mode >= IWL_MAX_FORCE_RESET) {
 		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
 		return -EINVAL;
-- 
1.7.0.4

