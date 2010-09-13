Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab0IMMrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:47:00 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/14] mac80211: wait for scan work complete before restarting hw
Date: Mon, 13 Sep 2010 14:46:42 +0200
Message-Id: <1284382005-3246-12-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to avoid warning in ieee80211_restart_hw about hardware
scan in progress.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4935b84..bf0eb6a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -305,6 +305,9 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 
 	trace_api_restart_hw(local);
 
+	/* wait for scan work complete */
+	flush_workqueue(local->workqueue);
+
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 		"%s called with hardware scan in progress\n", __func__);
 
-- 
1.7.1

