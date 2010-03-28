Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59450 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0C1LzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 07:55:12 -0400
Date: Sun, 28 Mar 2010 14:55:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: range checking issue
Message-ID: <20100328115500.GX5069@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IWL_RATE_COUNT is 13 and IWL_RATE_COUNT_LEGACY is 12.

IWL_RATE_COUNT_LEGACY is the right one here because iwl3945_rates
doesn't support 60M and also that's how "rates" is defined in
iwlcore_init_geos() from drivers/net/wireless/iwlwifi/iwl-core.c.

        rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
                        GFP_KERNEL);

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 54daa38..7d3806a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1955,7 +1955,7 @@ static void iwl3945_init_hw_rates(struct iwl_priv *priv,
 {
 	int i;
 
-	for (i = 0; i < IWL_RATE_COUNT; i++) {
+	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = iwl3945_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
