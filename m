Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41187 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1CYDqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 23:46:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove helper functions for displaying 11n capabilities
Date: Thu, 24 Mar 2011 20:49:38 -0700
Message-Id: <1301024979-28987-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

'iw list' is sufficient to retrieve the information which
was displayed by these functions.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c    |   96 ---------------------------------
 drivers/net/wireless/mwifiex/11n.h    |    2 -
 drivers/net/wireless/mwifiex/cmdevt.c |    2 -
 drivers/net/wireless/mwifiex/fw.h     |   16 ------
 4 files changed, 0 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 0e04a21..7b7b86d 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -140,102 +140,6 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 }
 
 /*
- * Shows HT capability information fields.
- *
- * The following HT capability information fields are supported.
- *      - Maximum AMSDU length (3839 bytes or 7935 bytes)
- *      - Beam forming support
- *      - Greenfield preamble support
- *      - AMPDU support
- *      - MIMO Power Save support
- *      - Rx STBC support
- *      - Tx STBC support
- *      - Short GI for 20 MHz support
- *      - Short GI for 40 MHz support
- *      - LDPC coded packets receive support
- *      - Number of delayed BA streams
- *      - Number of immediate BA streams
- *      - 10 MHz channel width support
- *      - 20 MHz channel width support
- *      - 40 MHz channel width support
- *      - Presence of Tx antenna A/B/C/D
- *      - Presence of Rx antenna A/B/C/D
- */
-void
-mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
-{
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Max MSDU len = %s octets\n",
-	       (ISSUPP_MAXAMSDU(cap) ? "7935" : "3839"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Beam forming %s\n",
-	       (ISSUPP_BEAMFORMING(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Greenfield preamble %s\n",
-	       (ISSUPP_GREENFIELD(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: AMPDU %s\n",
-	       (ISSUPP_AMPDU(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MIMO Power Save %s\n",
-	       (ISSUPP_MIMOPS(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Rx STBC %s\n",
-	       (ISSUPP_RXSTBC(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Tx STBC %s\n",
-	       (ISSUPP_TXSTBC(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 40 Mhz %s\n",
-	       (ISSUPP_SHORTGI40(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 20 Mhz %s\n",
-	       (ISSUPP_SHORTGI20(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: LDPC coded packet receive %s\n",
-	       (ISSUPP_RXLDPC(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev,
-		"info: GET_HW_SPEC: Number of Delayed Block Ack streams = %d\n",
-	       GET_DELAYEDBACK(cap));
-	dev_dbg(adapter->dev,
-		"info: GET_HW_SPEC: Number of Immediate Block Ack streams = %d\n",
-	       GET_IMMEDIATEBACK(cap));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 40 Mhz channel width %s\n",
-	       (ISSUPP_CHANWIDTH40(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 20 Mhz channel width %s\n",
-	       (ISSUPP_CHANWIDTH20(cap) ? "supported" : "not supported"));
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 10 Mhz channel width %s\n",
-	       (ISSUPP_CHANWIDTH10(cap) ? "supported" : "not supported"));
-
-	if (ISSUPP_RXANTENNAA(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea A\n");
-
-	if (ISSUPP_RXANTENNAB(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea B\n");
-
-	if (ISSUPP_RXANTENNAC(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea C\n");
-
-	if (ISSUPP_RXANTENNAD(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea D\n");
-
-	if (ISSUPP_TXANTENNAA(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea A\n");
-
-	if (ISSUPP_TXANTENNAB(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea B\n");
-
-	if (ISSUPP_TXANTENNAC(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea C\n");
-
-	if (ISSUPP_TXANTENNAD(cap))
-		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea D\n");
-
-	return;
-}
-
-/*
- * Shows HT MCS support field.
- */
-void
-mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
-{
-	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MCSs for %dx%d MIMO\n",
-	       GET_RXMCSSUPP(support), GET_TXMCSSUPP(support));
-	return;
-}
-
-/*
  * This function returns the pointer to an entry in BA Stream
  * table which matches the requested BA status.
  */
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 769a27f..71a853e 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -24,8 +24,6 @@
 #include "11n_rxreorder.h"
 #include "wmm.h"
 
-void mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap);
-void mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support);
 int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 			  struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 3a8fe1e..24a3b6b 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1452,8 +1452,6 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		DEFAULT_11N_CAP_MASK;
 	adapter->hw_dev_mcs_support = hw_spec->dev_mcs_support;
 	adapter->usr_dev_mcs_support = adapter->hw_dev_mcs_support;
-	mwifiex_show_dot_11n_dev_cap(adapter, adapter->hw_dot_11n_dev_cap);
-	mwifiex_show_dev_mcs_support(adapter, adapter->hw_dev_mcs_support);
 
 	if (adapter->if_ops.update_mp_end_port)
 		adapter->if_ops.update_mp_end_port(adapter,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index e5dae45..d1a5a10 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -196,30 +196,14 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define DEFAULT_11N_CAP_MASK	(HWSPEC_SHORTGI20_SUPP | HWSPEC_RXSTBC_SUPP)
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
-#define ISSUPP_MAXAMSDU(Dot11nDevCap) (Dot11nDevCap & BIT(31))
-#define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
-#define ISSUPP_AMPDU(Dot11nDevCap) (Dot11nDevCap & BIT(28))
-#define ISSUPP_MIMOPS(Dot11nDevCap) (Dot11nDevCap & BIT(27))
 #define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
 #define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
 #define ISSUPP_SHORTGI40(Dot11nDevCap) (Dot11nDevCap & BIT(24))
 #define ISSUPP_SHORTGI20(Dot11nDevCap) (Dot11nDevCap & BIT(23))
-#define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
 #define GET_DELAYEDBACK(Dot11nDevCap) (((Dot11nDevCap >> 20) & 0x03))
-#define GET_IMMEDIATEBACK(Dot11nDevCap) (((Dot11nDevCap >> 18) & 0x03))
 #define ISSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap & BIT(17))
-#define ISSUPP_CHANWIDTH20(Dot11nDevCap) (Dot11nDevCap & BIT(16))
-#define ISSUPP_CHANWIDTH10(Dot11nDevCap) (Dot11nDevCap & BIT(15))
 #define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
-#define ISSUPP_RXANTENNAD(Dot11nDevCap) (Dot11nDevCap & BIT(7))
-#define ISSUPP_RXANTENNAC(Dot11nDevCap) (Dot11nDevCap & BIT(6))
-#define ISSUPP_RXANTENNAB(Dot11nDevCap) (Dot11nDevCap & BIT(5))
-#define ISSUPP_RXANTENNAA(Dot11nDevCap) (Dot11nDevCap & BIT(4))
-#define ISSUPP_TXANTENNAD(Dot11nDevCap) (Dot11nDevCap & BIT(3))
-#define ISSUPP_TXANTENNAC(Dot11nDevCap) (Dot11nDevCap & BIT(2))
-#define ISSUPP_TXANTENNAB(Dot11nDevCap) (Dot11nDevCap & BIT(1))
-#define ISSUPP_TXANTENNAA(Dot11nDevCap) (Dot11nDevCap & BIT(0))
 #define SETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap |= BIT(17))
 #define RESETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap &= ~BIT(17))
 #define GET_TXMCSSUPP(DevMCSSupported) (DevMCSSupported >> 4)
-- 
1.7.0.2

