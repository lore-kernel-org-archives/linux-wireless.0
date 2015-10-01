Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45112 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbbJAKvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 06:51:17 -0400
Subject: [PATCH 5/6] ath10k: fix whitespace usage
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2015 13:51:14 +0300
Message-ID: <20151001105114.8770.28029.stgit@potku.adurom.net> (sfid-20151001_125120_334106_4A869EC1)
In-Reply-To: <20151001105001.8770.96252.stgit@potku.adurom.net>
References: <20151001105001.8770.96252.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

checkpatch found:

drivers/net/wireless/ath/ath10k/core.c:574: Blank lines aren't necessary before a close brace '}'
drivers/net/wireless/ath/ath10k/mac.c:4067: Missing a blank line after declarations
drivers/net/wireless/ath/ath10k/mac.c:4083: Missing a blank line after declarations
drivers/net/wireless/ath/ath10k/mac.c:4084: spaces required around that '>>=' (ctx:WxV)
drivers/net/wireless/ath/ath10k/pci.c:1507: Missing a blank line after declarations

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    1 -
 drivers/net/wireless/ath/ath10k/mac.c  |    4 +++-
 drivers/net/wireless/ath/ath10k/pci.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 12fef599debe..c295c919568b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -570,7 +570,6 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	ar->firmware_len = 0;
 
 	ar->cal_file = NULL;
-
 }
 
 static int ath10k_fetch_cal_file(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3316aec16043..ab0864feb514 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4064,6 +4064,7 @@ static u32 get_nss_from_chainmask(u16 chain_mask)
 static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
 {
 	int nsts = ar->vht_cap_info;
+
 	nsts &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
 
@@ -4080,8 +4081,9 @@ static int ath10k_mac_get_vht_cap_bf_sts(struct ath10k *ar)
 static int ath10k_mac_get_vht_cap_bf_sound_dim(struct ath10k *ar)
 {
 	int sound_dim = ar->vht_cap_info;
+
 	sound_dim &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
-	sound_dim >>=IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
+	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 
 	/* If the sounding dimension is not advertised by the firmware,
 	 * let's use a default value of 1
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 08cc4304001e..61df93e2e1c9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1504,6 +1504,7 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_irq_enable(ar);

