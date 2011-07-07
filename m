Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20827 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1GGSDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 14:03:49 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] mac80211: Restart STA timers only on associated state
Date: Thu, 7 Jul 2011 23:33:39 +0530
Message-ID: <1310061819-7260-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110707_200352_667581_D4F0D1CE)
In-Reply-To: <1310061819-7260-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310061819-7260-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A panic was observed when the device is failed to resume properly,
and there are no running interfaces. ieee80211_reconfig tries
to restart STA timers on unassociated state.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 182cda6..b6d9bd5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2215,6 +2215,9 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (!ifmgd->associated)
+		return;
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
-- 
1.7.6

