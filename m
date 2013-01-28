Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3A1JiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 20/37] iwlwifi: add the MVM driver (Makefile)
Date: Mon, 28 Jan 2013 10:37:27 +0100
Message-Id: <1359365864-4259-21-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103826_963816_A00C7836)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/Makefile

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
new file mode 100644
index 0000000..807b250
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -0,0 +1,10 @@
+obj-$(CONFIG_IWLMVM)   += iwlmvm.o
+iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
+iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o
+iwlmvm-y += scan.o time-event.o rs.o
+iwlmvm-y += power.o
+iwlmvm-y += led.o
+iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
+iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
+
+ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/../
-- 
1.8.0

