Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50931 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934604Ab1IOTr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:47:27 -0400
Subject: [PATCH] iwlagn: Convert kzalloc to kcalloc
From: Joe Perches <joe@perches.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Thu, 15 Sep 2011 12:47:26 -0700
In-Reply-To: <1316112830.19293.4.camel@wwguy-huron>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com>
	 <1316115470.11236.1.camel@Joe-Laptop>
	 <1316112830.19293.4.camel@wwguy-huron>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316116047.11236.8.camel@Joe-Laptop> (sfid-20110915_214730_545412_CE19ECD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert kzalloc to kcalloc, coalesce multiple lines too.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2011-09-15 at 11:53 -0700, Guy, Wey-Yi wrote:
> On Thu, 2011-09-15 at 12:37 -0700, Joe Perches wrote:
> > kcalloc would be even prettier...
> agree, would you mind submit a patch to changes it

Just converted your original patch inline.

 drivers/net/wireless/iwlwifi/iwl-trans.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index d4f6281..498e006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -308,10 +308,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	txq->q.n_window = slots_num;
 
-	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
-			    GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
-			   GFP_KERNEL);
+	txq->meta = kcalloc(slots_num, sizeof(txq->meta[0]), GFP_KERNEL);
+	txq->cmd = kcalloc(slots_num, sizeof(txq->cmd[0]), GFP_KERNEL);
 
 	if (!txq->meta || !txq->cmd)
 		goto error;


