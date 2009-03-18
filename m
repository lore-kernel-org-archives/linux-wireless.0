Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbZCREq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlagn: allow power level setting all the times
Date: Tue, 17 Mar 2009 21:51:44 -0700
Message-Id: <1237351913-19202-5-git-send-email-reinette.chatre@intel.com> (sfid-20090318_060339_257110_6C9561C3)
In-Reply-To: <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

allow user to set power level at all times

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 -----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 -----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c148285..663dc83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3093,11 +3093,6 @@ static ssize_t store_power_level(struct device *d,
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv)) {
-		ret = -EAGAIN;
-		goto out;
-	}
-
 	ret = strict_strtoul(buf, 10, &mode);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 215d3f6..33bdd86 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4550,11 +4550,6 @@ static ssize_t store_power_level(struct device *d,
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready(priv)) {
-		ret = -EAGAIN;
-		goto out;
-	}
-
 	ret = strict_strtoul(buf, 10, &mode);
 	if (ret)
 		goto out;
-- 
1.5.6.3

