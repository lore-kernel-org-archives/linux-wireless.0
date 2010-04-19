Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64790 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0DSRqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:46:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: pass HT changes to driver when off channel
Date: Mon, 19 Apr 2010 10:46:31 -0700
Message-Id: <1271699191-28925-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Since "mac80211: make off-channel work generic" drivers have not been
notified of configuration changes after association or authentication. This
caused more dependence on current state to ensure driver will be notified
when configuration changes occur. One such problem arises if off-channel is
in progress when HT information changes. Since HT is only enabled on the
"oper_channel" the driver will never be notified of this change. Usually
the driver is notified soon after of a BSS information change
(BSS_CHANGED_HT) ... but since the driver did not get a notification that
this is a HT channel the new BSS information does not make sense.

Fix this by also changing the off-channel information when HT is enabled
and thus cause driver to be notified correctly.

This fixes a problem in 4965 when associated with 5GHz 40MHz channel.
Without this patch the system can associate but is unable to transfer any
data, not even ping.

See http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2158

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 35d8502..3133681 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -175,6 +175,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
 		     channel_type != local->hw.conf.channel_type;
 
+	if (local->tmp_channel)
+		local->tmp_channel_type = channel_type;
 	local->oper_channel_type = channel_type;
 
 	if (ht_changed) {
-- 
1.6.3.3

