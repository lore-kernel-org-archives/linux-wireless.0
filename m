Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3949 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYAWCCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 21:02:00 -0500
Date: Tue, 22 Jan 2008 20:44:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull request: wireless-2.6 'fixes' 2008-01-22
Message-ID: <20080123014439.GF3206@tuxdriver.com> (sfid-20080123_020207_258395_3071973D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here is a NULL pointer avoidance fix for iwlwifi that would be nice
to have in 2.6.24 if possible.

Thanks!

John

---

Individual patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/fixes

---

The following changes since commit 889c94a14e38e749c8060f597ee7825ea0764229:
  Johann Felix Soden (1):
        Fix file references in documentation and Kconfig

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes 

Reinette Chatre (1):
      iwlwifi: fix possible read attempt on ucode that is not available

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a6b0e0..0b3ec7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6342,6 +6342,11 @@ static int __iwl_up(struct iwl_priv *priv)
 		return 0;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl_hw_nic_init(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6cd57c2..15a45f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6698,6 +6698,11 @@ static int __iwl_up(struct iwl_priv *priv)
 		return 0;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl_hw_nic_init(priv);
-- 
John W. Linville
linville@tuxdriver.com
