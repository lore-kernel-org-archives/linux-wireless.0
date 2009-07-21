Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZGUQ3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 12:29:08 -0400
Subject: Re: [PATCH 2.6.31] iwlagn: fix minimum number of queues setting
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20090721154417.GB2721@tuxdriver.com>
References: <1247848476-24185-1-git-send-email-reinette.chatre@intel.com>
	 <20090721154417.GB2721@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 09:29:07 -0700
Message-Id: <1248193747.17896.2636.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2009-07-21 at 08:44 -0700, John W. Linville wrote:
> When built against 2.6.31, I get this:
> 
>   CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
> In file included from drivers/net/wireless/iwlwifi/iwl3945-base.c:55:
> drivers/net/wireless/iwlwifi/iwl-3945.h:115:1: warning: "IWL_MIN_NUM_QUEUES" redefined
> In file included from drivers/net/wireless/iwlwifi/iwl-3945.h:48,
>                  from drivers/net/wireless/iwlwifi/iwl3945-base.c:55:

I am very sorry. This patch will fix this.

From: Reinette Chatre <reinette.chatre@intel.com>

We need to provide a reasonable minimum that will result in a
working setup if used. Set minimum to be 10 to provide for
4 standard TX queues + 1 command queue + 2 (unused) HCCA queues +
4 HT queues (one per AC).

We allow the user to change the number of queues used via a module
parameter and use this minimum value to check if it is valid. Without
this patch a user can select a value for the number of queues that
will result in a failing setup.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
This patch has already been submitted for wireless-testing, but we would
like to include this fix into 2.6.31 also if possible.

This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2011

 drivers/net/wireless/iwlwifi/iwl-dev.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1a2fe37..b989d5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -258,8 +258,10 @@ struct iwl_channel_info {
 #define IWL_TX_FIFO_HCCA_2	6
 #define IWL_TX_FIFO_NONE	7
 
-/* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
+/* Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate the 4 standard TX queues, 1 command
+ * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
+#define IWL_MIN_NUM_QUEUES	10
 
 /* Power management (not Tx power) structures */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fbb3a57..2de6471 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -112,7 +112,7 @@ enum iwl3945_antenna {
 #define IWL_TX_FIFO_NONE	7
 
 /* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
+#define IWL39_MIN_NUM_QUEUES	4
 
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cb9bd4c..b01fba3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4020,10 +4020,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	if ((iwl3945_mod_params.num_of_queues > IWL39_MAX_NUM_QUEUES) ||
-	     (iwl3945_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
+	     (iwl3945_mod_params.num_of_queues < IWL39_MIN_NUM_QUEUES)) {
 		IWL_ERR(priv,
 			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
+			IWL39_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
 		err = -EINVAL;
 		goto out_ieee80211_free_hw;
 	}


