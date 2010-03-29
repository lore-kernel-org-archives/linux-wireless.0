Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab0C2LU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 07:20:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	<wey-yi.w.guy@intel.com>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 3/3] mac80211: enable QoS explicitly in AP mode
Date: Mon, 29 Mar 2010 12:18:36 +0200
Message-Id: <1269857916-4440-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1269857916-4440-2-git-send-email-sgruszka@redhat.com>
References: <1269857916-4440-1-git-send-email-sgruszka@redhat.com>
 <1269857916-4440-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable QoS explicitly, when user space AP program will setup a QoS
queues. Currently this is not needed as iwlwifi not work in AP mode
and no other driver implement enable/disable QoS.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
 - add this patch  

 net/mac80211/cfg.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b7116ef..b88c7e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1136,6 +1136,10 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
+	/* enable WMM or activate new settings */
+	local->hw.conf.flags |= IEEE80211_CONF_QOS;
+	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
+
 	return 0;
 }
 
-- 
1.6.2.5

