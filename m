Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0CRObh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 10:31:37 -0400
Date: Thu, 18 Mar 2010 15:29:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>, Adel Gadllah <adel.gadllah@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2.6.32] iwlwifi: fix nfreed--
Message-ID: <20100318142933.GB4063@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com> <1268758859.2446.595.camel@rchatre-DESK> <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During backporting of a120e912eb51e347f36c71b60a1d13af74d30e83
("iwlwifi: sanity check before counting number of tfds can be free")
we forget one hunk, what make lot of messages "free more than
tfds_in_queue" show up in dmesg.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index f449f06..cf5ac00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1096,7 +1096,6 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-		nfreed++;
 	}
 	return nfreed;
 }
-- 
1.6.2.5

