Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33616 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbbFCGgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:36:22 -0400
Received: by wiwd19 with SMTP id d19so41139527wiw.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 23:36:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: release channel on auth failure
Date: Wed,  3 Jun 2015 08:36:13 +0200
Message-Id: <1433313373-28216-1-git-send-email-michal.kazior@tieto.com> (sfid-20150603_083625_481268_2D1E444E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a few rare cases when upon
authentication failure channel wasn't released.
This could cause stale pointers to remain in
chanctx assigned_vifs after interface removal and
trigger general protection fault later.

This could be triggered, e.g. on ath10k with the
following steps:

 1. start an AP
 2. create 2 extra vifs on ath10k host
 3. connect vif1 to the AP
 4. connect vif2 to the AP
    (auth fails because ath10k firmware isn't able
     to maintain 2 peers with colliding AP mac
     addresses across vifs and consequently
     refuses sta_info_insert() in
     ieee80211_prep_connection())
 5. remove the 2 extra vifs
 6. goto step 2; at step 3 kernel was crashing:

 general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
 Modules linked in: ath10k_pci ath10k_core ath
 ...
 Call Trace:
  [<ffffffff81a2dabb>] ieee80211_check_combinations+0x22b/0x290
  [<ffffffff819fb825>] ? ieee80211_check_concurrent_iface+0x125/0x220
  [<ffffffff8180f664>] ? netpoll_poll_disable+0x84/0x100
  [<ffffffff819fb833>] ieee80211_check_concurrent_iface+0x133/0x220
  [<ffffffff81a0029e>] ieee80211_open+0x3e/0x80
  [<ffffffff817f2d26>] __dev_open+0xb6/0x130
  [<ffffffff817f3051>] __dev_change_flags+0xa1/0x170
 ...
 RIP  [<ffffffff81a23140>] ieee80211_chanctx_radar_detect+0xa0/0x170

 (gdb) l * ieee80211_chanctx_radar_detect+0xa0
 0xffffffff81a23140 is in ieee80211_chanctx_radar_detect (/devel/src/linux/net/mac80211/util.c:3182).
 3177             */
 3178            WARN_ON(ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER &&
 3179                    !list_empty(&ctx->assigned_vifs));
 3180
 3181            list_for_each_entry(sdata, &ctx->assigned_vifs, assigned_chanctx_list)
 3182                    if (sdata->radar_required)
 3183                            radar_detect |= BIT(sdata->vif.bss_conf.chandef.width);
 3184
 3185            return radar_detect;

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 387fe70ab126..e7ef6f15b687 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4589,6 +4589,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	eth_zero_addr(ifmgd->bssid);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->mtx);
  err_free:
 	kfree(auth_data);
 	return err;
-- 
2.1.4

