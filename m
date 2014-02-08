Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60359 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaBHA1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 12/30] mwifiex: advertise correct beamforming information for VHT
Date: Fri, 7 Feb 2014 16:27:27 -0800
Message-ID: <1391819254-21130-2-git-send-email-bzhao@marvell.com> (sfid-20140208_012742_693876_A56F14C3)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently MU/SU beamformer and MU beamformee features are
not supported.

Hence this patch modifies VHT capability information accordingly.
Number of sounding dimensions should be zero in this case.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 6 ++++--
 drivers/net/wireless/mwifiex/fw.h     | 9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 556cb2c..7711b11 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1499,8 +1499,10 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		/* Copy 11AC cap */
 		adapter->hw_dot_11ac_dev_cap =
 					le32_to_cpu(hw_spec->dot_11ac_dev_cap);
-		adapter->usr_dot_11ac_dev_cap_bg = adapter->hw_dot_11ac_dev_cap;
-		adapter->usr_dot_11ac_dev_cap_a = adapter->hw_dot_11ac_dev_cap;
+		adapter->usr_dot_11ac_dev_cap_bg = adapter->hw_dot_11ac_dev_cap
+					& ~MWIFIEX_DEF_11AC_CAP_BF_RESET_MASK;
+		adapter->usr_dot_11ac_dev_cap_a = adapter->hw_dot_11ac_dev_cap
+					& ~MWIFIEX_DEF_11AC_CAP_BF_RESET_MASK;
 
 		/* Copy 11AC mcs */
 		adapter->hw_dot_11ac_mcs_support =
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index cad9f86..4139c6f 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -243,6 +243,15 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define GET_DEVTXMCSMAP(dev_mcs_map)      (dev_mcs_map >> 16)
 #define GET_DEVRXMCSMAP(dev_mcs_map)      (dev_mcs_map & 0xFFFF)
 
+/* Clear SU Beanformer, MU beanformer, MU beanformee and
+ * sounding dimensions bits
+ */
+#define MWIFIEX_DEF_11AC_CAP_BF_RESET_MASK \
+			(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE | \
+			 IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE | \
+			 IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE | \
+			 IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK)
+
 #define MOD_CLASS_HR_DSSS       0x03
 #define MOD_CLASS_OFDM          0x07
 #define MOD_CLASS_HT            0x08
-- 
1.8.2.3

