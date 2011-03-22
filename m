Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43578 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1CVA5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 20:57:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3] wireless: mwifiex: initial commit for Marvell mwifiex driver
Date: Mon, 21 Mar 2011 18:00:50 -0700
Message-Id: <1300755650-21740-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver adds WiFi support for Marvell 802.11n based chipsets
with SDIO interface. Currently only SD8787 is supported. More
chipsets will be supported later.

drivers/net/wireless/mwifiex/

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Ramesh Radhakrishnan <rramesh@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
v3: added set_default_key() implementation and removed most of the
    debugfs APIs as per comments from Johannes Berg; fixed ad-hoc issues
v2: incorporated patches by John Linville; comments from Johannes Berg
    and Joe Perches; coding style fixes, etc.

 drivers/net/wireless/Kconfig                 |    1 +
 drivers/net/wireless/Makefile                |    2 +
 drivers/net/wireless/mwifiex/11n.c           |  922 ++++++++
 drivers/net/wireless/mwifiex/11n.h           |  178 ++
 drivers/net/wireless/mwifiex/11n_aggr.c      |  423 ++++
 drivers/net/wireless/mwifiex/11n_aggr.h      |   32 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  637 ++++++
 drivers/net/wireless/mwifiex/11n_rxreorder.h |   67 +
 drivers/net/wireless/mwifiex/Kconfig         |   21 +
 drivers/net/wireless/mwifiex/Makefile        |   41 +
 drivers/net/wireless/mwifiex/README          |  204 ++
 drivers/net/wireless/mwifiex/cfg80211.c      | 1517 +++++++++++++
 drivers/net/wireless/mwifiex/cfg80211.h      |   31 +
 drivers/net/wireless/mwifiex/cfp.c           |  368 +++
 drivers/net/wireless/mwifiex/cmdevt.c        | 1463 ++++++++++++
 drivers/net/wireless/mwifiex/debugfs.c       |  773 +++++++
 drivers/net/wireless/mwifiex/decl.h          |  177 ++
 drivers/net/wireless/mwifiex/fw.h            | 1376 ++++++++++++
 drivers/net/wireless/mwifiex/init.c          |  665 ++++++
 drivers/net/wireless/mwifiex/ioctl.h         |  433 ++++
 drivers/net/wireless/mwifiex/join.c          | 1464 ++++++++++++
 drivers/net/wireless/mwifiex/main.c          | 1102 +++++++++
 drivers/net/wireless/mwifiex/main.h          | 1081 +++++++++
 drivers/net/wireless/mwifiex/scan.c          | 3098 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sdio.c          | 1770 +++++++++++++++
 drivers/net/wireless/mwifiex/sdio.h          |  305 +++
 drivers/net/wireless/mwifiex/sta_cmd.c       | 1226 ++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  986 ++++++++
 drivers/net/wireless/mwifiex/sta_event.c     |  405 ++++
 drivers/net/wireless/mwifiex/sta_ioctl.c     | 2478 ++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_rx.c        |  182 ++
 drivers/net/wireless/mwifiex/sta_tx.c        |  202 ++
 drivers/net/wireless/mwifiex/txrx.c          |  202 ++
 drivers/net/wireless/mwifiex/util.c          |  252 +++
 drivers/net/wireless/mwifiex/util.h          |   32 +
 drivers/net/wireless/mwifiex/wmm.c           | 1237 ++++++++++
 drivers/net/wireless/mwifiex/wmm.h           |  112 +
 37 files changed, 25465 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/11n.c
 create mode 100644 drivers/net/wireless/mwifiex/11n.h
 create mode 100644 drivers/net/wireless/mwifiex/11n_aggr.c
 create mode 100644 drivers/net/wireless/mwifiex/11n_aggr.h
 create mode 100644 drivers/net/wireless/mwifiex/11n_rxreorder.c
 create mode 100644 drivers/net/wireless/mwifiex/11n_rxreorder.h
 create mode 100644 drivers/net/wireless/mwifiex/Kconfig
 create mode 100644 drivers/net/wireless/mwifiex/Makefile
 create mode 100644 drivers/net/wireless/mwifiex/README
 create mode 100644 drivers/net/wireless/mwifiex/cfg80211.c
 create mode 100644 drivers/net/wireless/mwifiex/cfg80211.h
 create mode 100644 drivers/net/wireless/mwifiex/cfp.c
 create mode 100644 drivers/net/wireless/mwifiex/cmdevt.c
 create mode 100644 drivers/net/wireless/mwifiex/debugfs.c
 create mode 100644 drivers/net/wireless/mwifiex/decl.h
 create mode 100644 drivers/net/wireless/mwifiex/fw.h
 create mode 100644 drivers/net/wireless/mwifiex/init.c
 create mode 100644 drivers/net/wireless/mwifiex/ioctl.h
 create mode 100644 drivers/net/wireless/mwifiex/join.c
 create mode 100644 drivers/net/wireless/mwifiex/main.c
 create mode 100644 drivers/net/wireless/mwifiex/main.h
 create mode 100644 drivers/net/wireless/mwifiex/scan.c
 create mode 100644 drivers/net/wireless/mwifiex/sdio.c
 create mode 100644 drivers/net/wireless/mwifiex/sdio.h
 create mode 100644 drivers/net/wireless/mwifiex/sta_cmd.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_cmdresp.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_event.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_ioctl.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_rx.c
 create mode 100644 drivers/net/wireless/mwifiex/sta_tx.c
 create mode 100644 drivers/net/wireless/mwifiex/txrx.c
 create mode 100644 drivers/net/wireless/mwifiex/util.c
 create mode 100644 drivers/net/wireless/mwifiex/util.h
 create mode 100644 drivers/net/wireless/mwifiex/wmm.c
 create mode 100644 drivers/net/wireless/mwifiex/wmm.h

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 7aeb113..f354bd4 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -284,5 +284,6 @@ source "drivers/net/wireless/rtlwifi/Kconfig"
 source "drivers/net/wireless/wl1251/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
+source "drivers/net/wireless/mwifiex/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index ddd3fb6..7bba6a8 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -56,3 +56,5 @@ obj-$(CONFIG_WL12XX)	+= wl12xx/
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
 
 obj-$(CONFIG_IWM)	+= iwmc3200wifi/
+
+obj-$(CONFIG_MWIFIEX)	+= mwifiex/
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
new file mode 100644
index 0000000..0e04a21
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -0,0 +1,922 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * Fills HT capability information field, AMPDU Parameters field, HT extended
+ * capability field, and supported MCS set fields.
+ *
+ * Only the following HT capability information fields are used, all other
+ * fields are always turned off.
+ *
+ *  Bit 1 : Supported channel width (0: 20MHz, 1: Both 20 and 40 MHz)
+ *  Bit 4 : Greenfield support (0: Not supported, 1: Supported)
+ *  Bit 5 : Short GI for 20 MHz support (0: Not supported, 1: Supported)
+ *  Bit 6 : Short GI for 40 MHz support (0: Not supported, 1: Supported)
+ *  Bit 7 : Tx STBC (0: Not supported, 1: Supported)
+ *  Bit 8-9 : Rx STBC (0: Not supported, X: Support for up to X spatial streams)
+ *  Bit 10 : Delayed BA support (0: Not supported, 1: Supported)
+ *  Bit 11 : Maximum AMSDU length (0: 3839 octets, 1: 7935 octets)
+ *  Bit 14 : 40-Mhz intolerant support (0: Not supported, 1: Supported)
+ *
+ *  In addition, the following AMPDU Parameters are set -
+ *      - Maximum AMPDU length exponent (set to 3)
+ *      - Minimum AMPDU start spacing (set to 0 - No restrictions)
+ *
+ *  MCS is set for 1x1, with MSC32 for infra mode or ad-hoc mode with 40 MHz
+ *  support.
+ *
+ *  RD responder bit to set to clear in the extended capability header.
+ */
+void
+mwifiex_fill_cap_info(struct mwifiex_private *priv,
+		      struct mwifiex_ie_types_htcap *ht_cap)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *mcs;
+	int rx_mcs_supp;
+	uint16_t ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
+	uint16_t ht_ext_cap = le16_to_cpu(ht_cap->ht_cap.extended_ht_cap_info);
+
+	if (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
+	    ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap))
+		SETHT_SUPPCHANWIDTH(ht_cap_info);
+	else
+		RESETHT_SUPPCHANWIDTH(ht_cap_info);
+
+	if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap) &&
+	    ISSUPP_GREENFIELD(adapter->usr_dot_11n_dev_cap))
+		SETHT_GREENFIELD(ht_cap_info);
+	else
+		RESETHT_GREENFIELD(ht_cap_info);
+
+	if (ISSUPP_SHORTGI20(adapter->hw_dot_11n_dev_cap) &&
+	    ISSUPP_SHORTGI20(adapter->usr_dot_11n_dev_cap))
+		SETHT_SHORTGI20(ht_cap_info);
+	else
+		RESETHT_SHORTGI20(ht_cap_info);
+
+	if (ISSUPP_SHORTGI40(adapter->hw_dot_11n_dev_cap) &&
+	    ISSUPP_SHORTGI40(adapter->usr_dot_11n_dev_cap))
+		SETHT_SHORTGI40(ht_cap_info);
+	else
+		RESETHT_SHORTGI40(ht_cap_info);
+
+	/* No user config for RX STBC yet */
+	if (ISSUPP_RXSTBC(adapter->hw_dot_11n_dev_cap)
+	    && ISSUPP_RXSTBC(adapter->usr_dot_11n_dev_cap))
+		SETHT_RXSTBC(ht_cap_info, 1);
+	else
+		RESETHT_RXSTBC(ht_cap_info);
+
+	/* No user config for TX STBC yet */
+	if (ISSUPP_TXSTBC(adapter->hw_dot_11n_dev_cap))
+		SETHT_TXSTBC(ht_cap_info);
+	else
+		RESETHT_TXSTBC(ht_cap_info);
+
+	/* No user config for Delayed BACK yet */
+	if (GET_DELAYEDBACK(adapter->hw_dot_11n_dev_cap))
+		SETHT_DELAYEDBACK(ht_cap_info);
+	else
+		RESETHT_DELAYEDBACK(ht_cap_info);
+
+	if (ISENABLED_40MHZ_INTOLARENT(adapter->usr_dot_11n_dev_cap))
+		SETHT_40MHZ_INTOLARANT(ht_cap_info);
+	else
+		RESETHT_40MHZ_INTOLARANT(ht_cap_info);
+
+	SETAMPDU_SIZE(ht_cap->ht_cap.ampdu_params_info, AMPDU_FACTOR_64K);
+	SETAMPDU_SPACING(ht_cap->ht_cap.ampdu_params_info, 0);
+
+	/* Need change to support 8k AMSDU receive */
+	RESETHT_MAXAMSDU(ht_cap_info);
+
+	rx_mcs_supp = GET_RXMCSSUPP(adapter->hw_dev_mcs_support);
+
+	mcs = (u8 *)&ht_cap->ht_cap.mcs;
+
+	/* Set MCS for 1x1 */
+	memset(mcs, 0xff, rx_mcs_supp);
+
+	/* Clear all the other values */
+	memset(&mcs[rx_mcs_supp], 0,
+			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
+
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
+	    (ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
+	     ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
+		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
+		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
+
+	/* Clear RD responder bit */
+	RESETHT_EXTCAP_RDG(ht_ext_cap);
+
+	ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
+	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
+}
+
+/*
+ * Shows HT capability information fields.
+ *
+ * The following HT capability information fields are supported.
+ *      - Maximum AMSDU length (3839 bytes or 7935 bytes)
+ *      - Beam forming support
+ *      - Greenfield preamble support
+ *      - AMPDU support
+ *      - MIMO Power Save support
+ *      - Rx STBC support
+ *      - Tx STBC support
+ *      - Short GI for 20 MHz support
+ *      - Short GI for 40 MHz support
+ *      - LDPC coded packets receive support
+ *      - Number of delayed BA streams
+ *      - Number of immediate BA streams
+ *      - 10 MHz channel width support
+ *      - 20 MHz channel width support
+ *      - 40 MHz channel width support
+ *      - Presence of Tx antenna A/B/C/D
+ *      - Presence of Rx antenna A/B/C/D
+ */
+void
+mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap)
+{
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Max MSDU len = %s octets\n",
+	       (ISSUPP_MAXAMSDU(cap) ? "7935" : "3839"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Beam forming %s\n",
+	       (ISSUPP_BEAMFORMING(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Greenfield preamble %s\n",
+	       (ISSUPP_GREENFIELD(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: AMPDU %s\n",
+	       (ISSUPP_AMPDU(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MIMO Power Save %s\n",
+	       (ISSUPP_MIMOPS(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Rx STBC %s\n",
+	       (ISSUPP_RXSTBC(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Tx STBC %s\n",
+	       (ISSUPP_TXSTBC(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 40 Mhz %s\n",
+	       (ISSUPP_SHORTGI40(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: Short GI for 20 Mhz %s\n",
+	       (ISSUPP_SHORTGI20(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: LDPC coded packet receive %s\n",
+	       (ISSUPP_RXLDPC(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev,
+		"info: GET_HW_SPEC: Number of Delayed Block Ack streams = %d\n",
+	       GET_DELAYEDBACK(cap));
+	dev_dbg(adapter->dev,
+		"info: GET_HW_SPEC: Number of Immediate Block Ack streams = %d\n",
+	       GET_IMMEDIATEBACK(cap));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 40 Mhz channel width %s\n",
+	       (ISSUPP_CHANWIDTH40(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 20 Mhz channel width %s\n",
+	       (ISSUPP_CHANWIDTH20(cap) ? "supported" : "not supported"));
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: 10 Mhz channel width %s\n",
+	       (ISSUPP_CHANWIDTH10(cap) ? "supported" : "not supported"));
+
+	if (ISSUPP_RXANTENNAA(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea A\n");
+
+	if (ISSUPP_RXANTENNAB(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea B\n");
+
+	if (ISSUPP_RXANTENNAC(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea C\n");
+
+	if (ISSUPP_RXANTENNAD(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Rx antennea D\n");
+
+	if (ISSUPP_TXANTENNAA(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea A\n");
+
+	if (ISSUPP_TXANTENNAB(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea B\n");
+
+	if (ISSUPP_TXANTENNAC(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea C\n");
+
+	if (ISSUPP_TXANTENNAD(cap))
+		dev_dbg(adapter->dev, "info: GET_HW_SPEC: Prescence of Tx antennea D\n");
+
+	return;
+}
+
+/*
+ * Shows HT MCS support field.
+ */
+void
+mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
+{
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: MCSs for %dx%d MIMO\n",
+	       GET_RXMCSSUPP(support), GET_TXMCSSUPP(support));
+	return;
+}
+
+/*
+ * This function returns the pointer to an entry in BA Stream
+ * table which matches the requested BA status.
+ */
+static struct mwifiex_tx_ba_stream_tbl *
+mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
+				  enum mwifiex_ba_status ba_status)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		if (tx_ba_tsr_tbl->ba_status == ba_status) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
+			return tx_ba_tsr_tbl;
+		}
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+	return NULL;
+}
+
+/*
+ * This function handles the command response of delete a block
+ * ack request.
+ *
+ * The function checks the response success status and takes action
+ * accordingly (send an add BA request in case of success, or recreate
+ * the deleted stream in case of failure, if the add BA was also
+ * initiated by us).
+ */
+int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *resp)
+{
+	int tid;
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
+	struct host_cmd_ds_11n_delba *del_ba =
+		(struct host_cmd_ds_11n_delba *) &resp->params.del_ba;
+	uint16_t del_ba_param_set = le16_to_cpu(del_ba->del_ba_param_set);
+
+	tid = del_ba_param_set >> DELBA_TID_POS;
+	if (del_ba->del_result == BA_RESULT_SUCCESS) {
+		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
+				del_ba->peer_mac_addr, TYPE_DELBA_SENT,
+				INITIATOR_BIT(del_ba_param_set));
+
+		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
+						BA_STREAM_SETUP_INPROGRESS);
+		if (tx_ba_tbl)
+			mwifiex_send_addba(priv, tx_ba_tbl->tid,
+					   tx_ba_tbl->ra);
+	} else { /*
+		  * In case of failure, recreate the deleted stream in case
+		  * we initiated the ADDBA
+		  */
+		if (INITIATOR_BIT(del_ba_param_set)) {
+			mwifiex_11n_create_tx_ba_stream_tbl(priv,
+					del_ba->peer_mac_addr, tid,
+					BA_STREAM_SETUP_INPROGRESS);
+
+			tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
+					BA_STREAM_SETUP_INPROGRESS);
+			if (tx_ba_tbl)
+				mwifiex_11n_delete_ba_stream_tbl(priv,
+						tx_ba_tbl->tid, tx_ba_tbl->ra,
+						TYPE_DELBA_SENT, true);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of add a block
+ * ack request.
+ *
+ * Handling includes changing the header fields to CPU formats, checking
+ * the response success status and taking actions accordingly (delete the
+ * BA stream table in case of failure).
+ */
+int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp)
+{
+	int tid;
+	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
+		(struct host_cmd_ds_11n_addba_rsp *) &resp->params.add_ba_rsp;
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
+
+	add_ba_rsp->ssn = cpu_to_le16((le16_to_cpu(add_ba_rsp->ssn))
+			& SSN_MASK);
+
+	tid = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
+		& IEEE80211_ADDBA_PARAM_TID_MASK)
+		>> BLOCKACKPARAM_TID_POS;
+	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
+		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid,
+						add_ba_rsp->peer_mac_addr);
+		if (tx_ba_tbl) {
+			dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
+			tx_ba_tbl->ba_status = BA_STREAM_SETUP_COMPLETE;
+		} else {
+			dev_err(priv->adapter->dev, "BA stream not created\n");
+		}
+	} else {
+		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
+						add_ba_rsp->peer_mac_addr,
+						TYPE_DELBA_SENT, true);
+		if (add_ba_rsp->add_rsp_result != BA_RESULT_TIMEOUT)
+			priv->aggr_prio_tbl[tid].ampdu_ap =
+				BA_STREAM_NOT_ALLOWED;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of 11n configuration request.
+ *
+ * Handling includes changing the header fields into CPU format.
+ */
+int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *resp,
+			void *data_buf)
+{
+	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
+	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
+
+	if (data_buf) {
+		tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
+		tx_cfg->tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
+		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
+	}
+	return 0;
+}
+
+/*
+ * This function prepares command of reconfigure Tx buffer.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting Tx buffer size (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd, int cmd_action,
+			     void *data_buf)
+{
+	struct host_cmd_ds_txbuf_cfg *tx_buf = &cmd->params.tx_buf;
+	u16 action = (u16) cmd_action;
+	u16 buf_size = *((u16 *) data_buf);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_RECONFIGURE_TX_BUFF);
+	cmd->size =
+		cpu_to_le16(sizeof(struct host_cmd_ds_txbuf_cfg) + S_DS_GEN);
+	tx_buf->action = cpu_to_le16(action);
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:
+		dev_dbg(priv->adapter->dev, "cmd: set tx_buf=%d\n", buf_size);
+		tx_buf->buff_size = cpu_to_le16(buf_size);
+		break;
+	case HostCmd_ACT_GEN_GET:
+	default:
+		tx_buf->buff_size = 0;
+		break;
+	}
+	return 0;
+}
+
+/*
+ * This function prepares command of AMSDU aggregation control.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting AMSDU control parameters (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				int cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
+		&cmd->params.amsdu_aggr_ctrl;
+	u16 action = (u16) cmd_action;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl =
+		(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_AMSDU_AGGR_CTRL);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_amsdu_aggr_ctrl)
+				+ S_DS_GEN);
+	amsdu_ctrl->action = cpu_to_le16(action);
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:
+		amsdu_ctrl->enable = cpu_to_le16(aa_ctrl->enable);
+		amsdu_ctrl->curr_buf_size = 0;
+		break;
+	case HostCmd_ACT_GEN_GET:
+	default:
+		amsdu_ctrl->curr_buf_size = 0;
+		break;
+	}
+	return 0;
+}
+
+/*
+ * This function handles the command response of AMSDU aggregation
+ * control request.
+ *
+ * Handling includes changing the header fields into CPU format.
+ */
+int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *resp,
+				void *data_buf)
+{
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl = NULL;
+	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
+		&resp->params.amsdu_aggr_ctrl;
+
+	if (data_buf) {
+		amsdu_aggr_ctrl =
+			(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
+		amsdu_aggr_ctrl->enable = le16_to_cpu(amsdu_ctrl->enable);
+		amsdu_aggr_ctrl->curr_buf_size =
+			le16_to_cpu(amsdu_ctrl->curr_buf_size);
+	}
+	return 0;
+}
+
+/*
+ * This function prepares 11n configuration command.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting HT Tx capability and HT Tx information fields
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_11n_cfg *htcfg = &cmd->params.htcfg;
+	struct mwifiex_ds_11n_tx_cfg *txcfg =
+		(struct mwifiex_ds_11n_tx_cfg *) data_buf;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_11N_CFG);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_cfg) + S_DS_GEN);
+	htcfg->action = cpu_to_le16(cmd_action);
+	htcfg->ht_tx_cap = cpu_to_le16(txcfg->tx_htcap);
+	htcfg->ht_tx_info = cpu_to_le16(txcfg->tx_htinfo);
+	return 0;
+}
+
+/*
+ * This function appends an 11n TLV to a buffer.
+ *
+ * Buffer allocation is responsibility of the calling
+ * function. No size validation is made here.
+ *
+ * The function fills up the following sections, if applicable -
+ *      - HT capability IE
+ *      - HT information IE (with channel list)
+ *      - 20/40 BSS Coexistence IE
+ *      - HT Extended Capabilities IE
+ */
+int
+mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
+			   struct mwifiex_bssdescriptor *bss_desc,
+			   u8 **buffer)
+{
+	struct mwifiex_ie_types_htcap *ht_cap;
+	struct mwifiex_ie_types_htinfo *ht_info;
+	struct mwifiex_ie_types_chan_list_param_set *chan_list;
+	struct mwifiex_ie_types_2040bssco *bss_co_2040;
+	struct mwifiex_ie_types_extcap *ext_cap;
+	int ret_len = 0;
+
+	if (!buffer || !*buffer)
+		return ret_len;
+
+	if (bss_desc->bcn_ht_cap) {
+		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
+		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
+		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+		ht_cap->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
+		       (u8 *) bss_desc->bcn_ht_cap +
+		       sizeof(struct ieee_types_header),
+		       le16_to_cpu(ht_cap->header.len));
+
+		mwifiex_fill_cap_info(priv, ht_cap);
+
+		*buffer += sizeof(struct mwifiex_ie_types_htcap);
+		ret_len += sizeof(struct mwifiex_ie_types_htcap);
+	}
+
+	if (bss_desc->bcn_ht_info) {
+		if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+			ht_info = (struct mwifiex_ie_types_htinfo *) *buffer;
+			memset(ht_info, 0,
+			       sizeof(struct mwifiex_ie_types_htinfo));
+			ht_info->header.type =
+					cpu_to_le16(WLAN_EID_HT_INFORMATION);
+			ht_info->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_info));
+
+			memcpy((u8 *) ht_info +
+			       sizeof(struct mwifiex_ie_types_header),
+			       (u8 *) bss_desc->bcn_ht_info +
+			       sizeof(struct ieee_types_header),
+			       le16_to_cpu(ht_info->header.len));
+
+			if (!ISSUPP_CHANWIDTH40
+			    (priv->adapter->hw_dot_11n_dev_cap)
+			    || !ISSUPP_CHANWIDTH40(priv->adapter->
+						   usr_dot_11n_dev_cap))
+				RESET_CHANWIDTH40(ht_info->ht_info.ht_param);
+
+			*buffer += sizeof(struct mwifiex_ie_types_htinfo);
+			ret_len += sizeof(struct mwifiex_ie_types_htinfo);
+		}
+
+		chan_list =
+			(struct mwifiex_ie_types_chan_list_param_set *) *buffer;
+		memset(chan_list, 0,
+		       sizeof(struct mwifiex_ie_types_chan_list_param_set));
+		chan_list->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
+		chan_list->header.len = cpu_to_le16(
+			sizeof(struct mwifiex_ie_types_chan_list_param_set) -
+			sizeof(struct mwifiex_ie_types_header));
+		chan_list->chan_scan_param[0].chan_number =
+			bss_desc->bcn_ht_info->control_chan;
+		chan_list->chan_scan_param[0].radio_type =
+			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
+
+		if ((ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
+		     ISSUPP_CHANWIDTH40(priv->adapter->usr_dot_11n_dev_cap))
+		    && ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_info->ht_param))
+			SET_SECONDARYCHAN(chan_list->chan_scan_param[0].
+					  radio_type,
+					  GET_SECONDARYCHAN(bss_desc->
+					  bcn_ht_info->ht_param));
+
+		*buffer += sizeof(struct mwifiex_ie_types_chan_list_param_set);
+		ret_len += sizeof(struct mwifiex_ie_types_chan_list_param_set);
+	}
+
+	if (bss_desc->bcn_bss_co_2040) {
+		bss_co_2040 = (struct mwifiex_ie_types_2040bssco *) *buffer;
+		memset(bss_co_2040, 0,
+		       sizeof(struct mwifiex_ie_types_2040bssco));
+		bss_co_2040->header.type = cpu_to_le16(WLAN_EID_BSS_COEX_2040);
+		bss_co_2040->header.len =
+		       cpu_to_le16(sizeof(bss_co_2040->bss_co_2040));
+
+		memcpy((u8 *) bss_co_2040 +
+		       sizeof(struct mwifiex_ie_types_header),
+		       (u8 *) bss_desc->bcn_bss_co_2040 +
+		       sizeof(struct ieee_types_header),
+		       le16_to_cpu(bss_co_2040->header.len));
+
+		*buffer += sizeof(struct mwifiex_ie_types_2040bssco);
+		ret_len += sizeof(struct mwifiex_ie_types_2040bssco);
+	}
+
+	if (bss_desc->bcn_ext_cap) {
+		ext_cap = (struct mwifiex_ie_types_extcap *) *buffer;
+		memset(ext_cap, 0, sizeof(struct mwifiex_ie_types_extcap));
+		ext_cap->header.type = cpu_to_le16(WLAN_EID_EXT_CAPABILITY);
+		ext_cap->header.len = cpu_to_le16(sizeof(ext_cap->ext_cap));
+
+		memcpy((u8 *) ext_cap +
+		       sizeof(struct mwifiex_ie_types_header),
+		       (u8 *) bss_desc->bcn_ext_cap +
+		       sizeof(struct ieee_types_header),
+		       le16_to_cpu(ext_cap->header.len));
+
+		*buffer += sizeof(struct mwifiex_ie_types_extcap);
+		ret_len += sizeof(struct mwifiex_ie_types_extcap);
+	}
+
+	return ret_len;
+}
+
+/*
+ * This function reconfigures the Tx buffer size in firmware.
+ *
+ * This function prepares a firmware command and issues it, if
+ * the current Tx buffer size is different from the one requested.
+ * Maximum configurable Tx buffer size is limited by the HT capability
+ * field value.
+ */
+void
+mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
+		   struct mwifiex_bssdescriptor *bss_desc)
+{
+	u16 max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+	u16 tx_buf = 0;
+	u16 curr_tx_buf_size = 0;
+
+	if (bss_desc->bcn_ht_cap) {
+		if (GETHT_MAXAMSDU(le16_to_cpu(bss_desc->bcn_ht_cap->cap_info)))
+			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
+		else
+			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_4K;
+	}
+
+	tx_buf = min(priv->adapter->max_tx_buf_size, max_amsdu);
+
+	dev_dbg(priv->adapter->dev, "info: max_amsdu=%d, max_tx_buf=%d\n",
+			max_amsdu, priv->adapter->max_tx_buf_size);
+
+	if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_2K)
+		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+	else if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_4K)
+		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
+	else if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_8K)
+		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_8K;
+	if (curr_tx_buf_size != tx_buf)
+		mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
+			HostCmd_ACT_GEN_SET, 0,
+			NULL, &tx_buf);
+
+	return;
+}
+
+/*
+ * This function checks if the given pointer is valid entry of
+ * Tx BA Stream table.
+ */
+static int mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
+				struct mwifiex_tx_ba_stream_tbl *tx_tbl_ptr)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		if (tx_ba_tsr_tbl == tx_tbl_ptr)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * This function deletes the given entry in Tx BA Stream table.
+ *
+ * The function also performs a validity check on the supplied
+ * pointer before trying to delete.
+ */
+void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
+				struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
+{
+	if (!tx_ba_tsr_tbl &&
+			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
+		return;
+
+	dev_dbg(priv->adapter->dev, "info: tx_ba_tsr_tbl %p\n", tx_ba_tsr_tbl);
+
+	list_del(&tx_ba_tsr_tbl->list);
+
+	kfree(tx_ba_tsr_tbl);
+
+	return;
+}
+
+/*
+ * This function deletes all the entries in Tx BA Stream table.
+ */
+void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
+{
+	int i;
+	struct mwifiex_tx_ba_stream_tbl *del_tbl_ptr, *tmp_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
+				 &priv->tx_ba_stream_tbl_ptr, list)
+		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, del_tbl_ptr);
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
+	INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
+
+	for (i = 0; i < MAX_NUM_TID; ++i)
+		priv->aggr_prio_tbl[i].ampdu_ap =
+			priv->aggr_prio_tbl[i].ampdu_user;
+}
+
+/*
+ * This function returns the pointer to an entry in BA Stream
+ * table which matches the given RA/TID pair.
+ */
+struct mwifiex_tx_ba_stream_tbl *
+mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
+				 int tid, u8 *ra)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, ETH_ALEN))
+		    && (tx_ba_tsr_tbl->tid == tid)) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
+			return tx_ba_tsr_tbl;
+		}
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+	return NULL;
+}
+
+/*
+ * This function creates an entry in Tx BA stream table for the
+ * given RA/TID pair.
+ */
+void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
+					 u8 *ra, int tid,
+					 enum mwifiex_ba_status ba_status)
+{
+	struct mwifiex_tx_ba_stream_tbl *new_node;
+	unsigned long flags;
+
+	if (!mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ra)) {
+		new_node = kzalloc(sizeof(struct mwifiex_tx_ba_stream_tbl),
+				   GFP_ATOMIC);
+		if (!new_node) {
+			dev_err(priv->adapter->dev,
+				"%s: failed to alloc new_node\n", __func__);
+			return;
+		}
+
+		INIT_LIST_HEAD(&new_node->list);
+
+		new_node->tid = tid;
+		new_node->ba_status = ba_status;
+		memcpy(new_node->ra, ra, ETH_ALEN);
+
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+		list_add_tail(&new_node->list, &priv->tx_ba_stream_tbl_ptr);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+	}
+
+	return;
+}
+
+/*
+ * This function sends an add BA request to the given TID/RA pair.
+ */
+int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
+{
+	struct host_cmd_ds_11n_addba_req add_ba_req;
+	static u8 dialog_tok;
+	int ret;
+
+	dev_dbg(priv->adapter->dev, "cmd: %s: tid %d\n", __func__, tid);
+
+	add_ba_req.block_ack_param_set = cpu_to_le16(
+		(u16) ((tid << BLOCKACKPARAM_TID_POS) |
+			 (priv->add_ba_param.
+			  tx_win_size << BLOCKACKPARAM_WINSIZE_POS) |
+			 IMMEDIATE_BLOCK_ACK));
+	add_ba_req.block_ack_tmo = cpu_to_le16((u16)priv->add_ba_param.timeout);
+
+	++dialog_tok;
+
+	if (dialog_tok == 0)
+		dialog_tok = 1;
+
+	add_ba_req.dialog_token = dialog_tok;
+	memcpy(&add_ba_req.peer_mac_addr, peer_mac, ETH_ALEN);
+
+	/* We don't wait for the response of this command */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_REQ,
+				  0, 0, NULL, &add_ba_req);
+
+	return ret;
+}
+
+/*
+ * This function sends a delete BA request to the given TID/RA pair.
+ */
+int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
+		       int initiator)
+{
+	struct host_cmd_ds_11n_delba delba;
+	int ret;
+	uint16_t del_ba_param_set;
+
+	memset(&delba, 0, sizeof(delba));
+	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
+
+	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
+	if (initiator)
+		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
+	else
+		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
+
+	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
+
+	/* We don't wait for the response of this command */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA,
+				  HostCmd_ACT_GEN_SET, 0, NULL, &delba);
+
+	return ret;
+}
+
+/*
+ * This function handles the command response of a delete BA request.
+ */
+void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
+{
+	struct host_cmd_ds_11n_delba *cmd_del_ba =
+		(struct host_cmd_ds_11n_delba *) del_ba;
+	uint16_t del_ba_param_set = le16_to_cpu(cmd_del_ba->del_ba_param_set);
+	int tid;
+
+	tid = del_ba_param_set >> DELBA_TID_POS;
+
+	mwifiex_11n_delete_ba_stream_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
+					 TYPE_DELBA_RECEIVE,
+					 INITIATOR_BIT(del_ba_param_set));
+}
+
+/*
+ * This function retrieves the Rx reordering table.
+ */
+int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
+			       struct mwifiex_ds_rx_reorder_tbl *buf)
+{
+	int i;
+	struct mwifiex_ds_rx_reorder_tbl *rx_reo_tbl = buf;
+	struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr;
+	int count = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry(rx_reorder_tbl_ptr, &priv->rx_reorder_tbl_ptr,
+			    list) {
+		rx_reo_tbl->tid = (u16) rx_reorder_tbl_ptr->tid;
+		memcpy(rx_reo_tbl->ta, rx_reorder_tbl_ptr->ta, ETH_ALEN);
+		rx_reo_tbl->start_win = rx_reorder_tbl_ptr->start_win;
+		rx_reo_tbl->win_size = rx_reorder_tbl_ptr->win_size;
+		for (i = 0; i < rx_reorder_tbl_ptr->win_size; ++i) {
+			if (rx_reorder_tbl_ptr->rx_reorder_ptr[i])
+				rx_reo_tbl->buffer[i] = true;
+			else
+				rx_reo_tbl->buffer[i] = false;
+		}
+		rx_reo_tbl++;
+		count++;
+
+		if (count >= MWIFIEX_MAX_RX_BASTREAM_SUPPORTED)
+			break;
+	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	return count;
+}
+
+/*
+ * This function retrieves the Tx BA stream table.
+ */
+int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
+				 struct mwifiex_ds_tx_ba_stream_tbl *buf)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	struct mwifiex_ds_tx_ba_stream_tbl *rx_reo_tbl = buf;
+	int count = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
+		dev_dbg(priv->adapter->dev, "data: %s tid=%d\n",
+						__func__, rx_reo_tbl->tid);
+		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra, ETH_ALEN);
+		rx_reo_tbl++;
+		count++;
+		if (count >= MWIFIEX_MAX_TX_BASTREAM_SUPPORTED)
+			break;
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
+	return count;
+}
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
new file mode 100644
index 0000000..769a27f
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -0,0 +1,178 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_11N_H_
+#define _MWIFIEX_11N_H_
+
+#include "11n_aggr.h"
+#include "11n_rxreorder.h"
+#include "wmm.h"
+
+void mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap);
+void mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support);
+int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *resp);
+int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp);
+int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *resp,
+			void *data_buf);
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf);
+
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf);
+
+int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
+			       struct mwifiex_bssdescriptor *bss_desc,
+			       u8 **buffer);
+void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
+			struct mwifiex_bssdescriptor *bss_desc);
+void mwifiex_fill_cap_info(struct mwifiex_private *,
+			   struct mwifiex_ie_types_htcap *);
+int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
+				  u16 action, int *htcap_cfg);
+void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
+					     struct mwifiex_tx_ba_stream_tbl
+					     *tx_tbl);
+void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv);
+struct mwifiex_tx_ba_stream_tbl *mwifiex_11n_get_tx_ba_stream_tbl(struct
+							     mwifiex_private
+							     *priv, int tid,
+							     u8 *ra);
+void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv, u8 *ra,
+				       int tid,
+				       enum mwifiex_ba_status ba_status);
+int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac);
+int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
+		       int initiator);
+void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba);
+int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
+			      struct mwifiex_ds_rx_reorder_tbl *buf);
+int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
+			       struct mwifiex_ds_tx_ba_stream_tbl *buf);
+int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command
+				*resp,
+				void *data_buf);
+int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd,
+			     int cmd_action, void *data_buf);
+int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				int cmd_action,
+				void *data_buf);
+
+/*
+ * This function checks whether AMPDU is allowed or not for a particular TID.
+ */
+static inline u8
+mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
+			 struct mwifiex_ra_list_tbl *ptr, int tid)
+{
+	return ((priv->aggr_prio_tbl[tid].ampdu_ap != BA_STREAM_NOT_ALLOWED)
+		? true : false);
+}
+
+/*
+ * This function checks whether AMSDU is allowed or not for a particular TID.
+ */
+static inline u8
+mwifiex_is_amsdu_allowed(struct mwifiex_private *priv,
+			 struct mwifiex_ra_list_tbl *ptr, int tid)
+{
+	return (((priv->aggr_prio_tbl[tid].amsdu != BA_STREAM_NOT_ALLOWED)
+			&& ((priv->is_data_rate_auto)
+			|| !((priv->bitmap_rates[2]) & 0x03)))
+		? true : false);
+}
+
+/*
+ * This function checks whether a BA stream is available or not.
+ */
+static inline u8
+mwifiex_is_ba_stream_avail(struct mwifiex_private *priv)
+{
+	struct mwifiex_private *pmpriv = NULL;
+	u8 i = 0;
+	u32 ba_stream_num = 0;
+
+	for (i = 0; i < priv->adapter->priv_num; i++) {
+		pmpriv = priv->adapter->priv[i];
+		if (pmpriv)
+			ba_stream_num +=
+				mwifiex_wmm_list_len(priv->adapter,
+						     (struct list_head
+						      *) &pmpriv->
+						     tx_ba_stream_tbl_ptr);
+	}
+
+	return ((ba_stream_num <
+		 MWIFIEX_MAX_TX_BASTREAM_SUPPORTED) ? true : false);
+}
+
+/*
+ * This function finds the correct Tx BA stream to delete.
+ *
+ * Upon successfully locating, both the TID and the RA are returned.
+ */
+static inline u8
+mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
+			      struct mwifiex_ra_list_tbl *ptr, int ptr_tid,
+			      int *ptid, u8 *ra)
+{
+	int tid;
+	u8 ret = false;
+	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
+	unsigned long flags;
+
+	tid = priv->aggr_prio_tbl[ptr_tid].ampdu_user;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
+		if (tid > priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user) {
+			tid = priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user;
+			*ptid = tx_tbl->tid;
+			memcpy(ra, tx_tbl->ra, ETH_ALEN);
+			ret = true;
+		}
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
+	return ret;
+}
+
+/*
+ * This function checks whether BA stream is set up or not.
+ */
+static inline int
+mwifiex_is_ba_stream_setup(struct mwifiex_private *priv,
+			  struct mwifiex_ra_list_tbl *ptr, int tid)
+{
+	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
+
+	tx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ptr->ra);
+	if (tx_tbl && IS_BASTREAM_SETUP(tx_tbl))
+		return true;
+
+	return false;
+}
+#endif /* !_MWIFIEX_11N_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
new file mode 100644
index 0000000..c2abced
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -0,0 +1,423 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n Aggregation
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+#include "11n_aggr.h"
+
+/*
+ * Creates an AMSDU subframe for aggregation into one AMSDU packet.
+ *
+ * The resultant AMSDU subframe format is -
+ *
+ * +---- ~ -----+---- ~ ------+---- ~ -----+----- ~ -----+---- ~ -----+
+ * |     DA     |     SA      |   Length   | SNAP header |   MSDU     |
+ * | data[0..5] | data[6..11] |            |             | data[14..] |
+ * +---- ~ -----+---- ~ ------+---- ~ -----+----- ~ -----+---- ~ -----+
+ * <--6-bytes--> <--6-bytes--> <--2-bytes--><--8-bytes--> <--n-bytes-->
+ *
+ * This function also computes the amount of padding required to make the
+ * buffer length multiple of 4 bytes.
+ *
+ * Data => |DA|SA|SNAP-TYPE|........    .|
+ * MSDU => |DA|SA|Length|SNAP|......   ..|
+ */
+static int
+mwifiex_11n_form_amsdu_pkt(struct mwifiex_adapter *adapter,
+			   struct sk_buff *skb_aggr,
+			   struct sk_buff *skb_src, int *pad)
+
+{
+	int dt_offset;
+	struct rfc_1042_hdr snap = {
+		0xaa,		/* LLC DSAP */
+		0xaa,		/* LLC SSAP */
+		0x03,		/* LLC CTRL */
+		{0x00, 0x00, 0x00},	/* SNAP OUI */
+		0x0000		/* SNAP type */
+			/*
+			 * This field will be overwritten
+			 * later with ethertype
+			 */
+	};
+	struct tx_packet_hdr *tx_header = NULL;
+
+	skb_put(skb_aggr, sizeof(*tx_header));
+
+	tx_header = (struct tx_packet_hdr *) skb_aggr->data;
+
+	/* Copy DA and SA */
+	dt_offset = 2 * ETH_ALEN;
+	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
+
+	/* Copy SNAP header */
+	snap.snap_type = *(u16 *) ((u8 *)skb_src->data + dt_offset);
+	dt_offset += sizeof(u16);
+
+	memcpy(&tx_header->rfc1042_hdr, &snap, sizeof(struct rfc_1042_hdr));
+
+	skb_pull(skb_src, dt_offset);
+
+	/* Update Length field */
+	tx_header->eth803_hdr.h_proto = htons(skb_src->len + LLC_SNAP_LEN);
+
+	/* Add payload */
+	skb_put(skb_aggr, skb_src->len);
+	memcpy(skb_aggr->data + sizeof(*tx_header), skb_src->data,
+							skb_src->len);
+	*pad = (((skb_src->len + LLC_SNAP_LEN) & 3)) ? (4 - (((skb_src->len +
+						      LLC_SNAP_LEN)) & 3)) : 0;
+	skb_put(skb_aggr, *pad);
+
+	return skb_aggr->len + *pad;
+}
+
+/*
+ * Adds TxPD to AMSDU header.
+ *
+ * Each AMSDU packet will contain one TxPD at the beginning,
+ * followed by multiple AMSDU subframes.
+ */
+static void
+mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
+			    struct sk_buff *skb)
+{
+	struct txpd *local_tx_pd;
+
+	skb_push(skb, sizeof(*local_tx_pd));
+
+	local_tx_pd = (struct txpd *) skb->data;
+	memset(local_tx_pd, 0, sizeof(struct txpd));
+
+	/* Original priority has been overwritten */
+	local_tx_pd->priority = (u8) skb->priority;
+	local_tx_pd->pkt_delay_2ms =
+		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
+	local_tx_pd->bss_num = priv->bss_num;
+	local_tx_pd->bss_type = priv->bss_type;
+	/* Always zero as the data is followed by struct txpd */
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+	local_tx_pd->tx_pkt_type = cpu_to_le16(PKT_TYPE_AMSDU);
+	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
+			sizeof(*local_tx_pd));
+
+	if (local_tx_pd->tx_control == 0)
+		/* TxCtrl set by user or default */
+		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
+
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+		(priv->adapter->pps_uapsd_mode)) {
+		if (true == mwifiex_check_last_packet_indication(priv)) {
+			priv->adapter->tx_lock_flag = true;
+			local_tx_pd->flags =
+				MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET;
+		}
+	}
+}
+
+/*
+ * Counts the number of subframes in an aggregate packet.
+ *
+ * This function parses an aggregate packet buffer, looking for
+ * subframes and counting the number of such subframe found. The
+ * function automatically skips the DA/SA fields at the beginning
+ * of each subframe and padding at the end.
+ */
+static int
+mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
+{
+	int pkt_count = 0, pkt_len, pad;
+
+	while (total_pkt_len > 0) {
+		/* Length will be in network format, change it to host */
+		pkt_len = ntohs((*(__be16 *)(data + 2 * ETH_ALEN)));
+		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
+			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
+		data += pkt_len + pad + sizeof(struct ethhdr);
+		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
+		++pkt_count;
+	}
+
+	return pkt_count;
+}
+
+/*
+ * De-aggregate received packets.
+ *
+ * This function parses the received aggregate buffer, extracts each subframe,
+ * strips off the SNAP header from them and sends the data portion for further
+ * processing.
+ *
+ * Each subframe body is copied onto a separate buffer, which are freed by
+ * upper layer after processing. The function also performs sanity tests on
+ * the received buffer.
+ */
+int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
+				struct sk_buff *skb)
+{
+	u16 pkt_len;
+	int total_pkt_len;
+	u8 *data;
+	int pad;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct rxpd *local_rx_pd = (struct rxpd *) skb->data;
+	struct sk_buff *skb_daggr;
+	struct mwifiex_rxinfo *rx_info_daggr = NULL;
+	int ret = -1;
+	struct rx_packet_hdr *rx_pkt_hdr;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
+
+	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
+	total_pkt_len = local_rx_pd->rx_pkt_length;
+
+	/* Sanity test */
+	if (total_pkt_len > MWIFIEX_RX_DATA_BUF_SIZE) {
+		dev_err(adapter->dev, "total pkt len greater than buffer"
+		       " size %d\n", total_pkt_len);
+		return -1;
+	}
+
+	rx_info->use_count = mwifiex_11n_get_num_aggr_pkts(data, total_pkt_len);
+
+	while (total_pkt_len > 0) {
+		rx_pkt_hdr = (struct rx_packet_hdr *) data;
+		/* Length will be in network format, change it to host */
+		pkt_len = ntohs((*(__be16 *) (data + 2 * ETH_ALEN)));
+		if (pkt_len > total_pkt_len) {
+			dev_err(adapter->dev, "pkt_len %d > total_pkt_len %d\n",
+			       total_pkt_len, pkt_len);
+			break;
+		}
+
+		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
+			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
+
+		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
+
+		if (memcmp(&rx_pkt_hdr->rfc1042_hdr,
+			   rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)) == 0) {
+			memmove(data + LLC_SNAP_LEN, data, 2 * ETH_ALEN);
+			data += LLC_SNAP_LEN;
+			pkt_len += sizeof(struct ethhdr) - LLC_SNAP_LEN;
+		} else {
+			*(u16 *) (data + 2 * ETH_ALEN) = (u16) 0;
+			pkt_len += sizeof(struct ethhdr);
+		}
+
+		skb_daggr = dev_alloc_skb(pkt_len);
+		if (!skb_daggr) {
+			dev_err(adapter->dev, "%s: failed to alloc skb_daggr\n",
+			       __func__);
+			return -1;
+		}
+		rx_info_daggr = MWIFIEX_SKB_RXCB(skb_daggr);
+
+		rx_info_daggr->bss_index = rx_info->bss_index;
+		skb_daggr->tstamp = skb->tstamp;
+		rx_info_daggr->parent = skb;
+		skb_daggr->priority = skb->priority;
+		skb_put(skb_daggr, pkt_len);
+		memcpy(skb_daggr->data, data, pkt_len);
+
+		ret = mwifiex_recv_packet(adapter, skb_daggr);
+
+		switch (ret) {
+		case -EINPROGRESS:
+			break;
+		case -1:
+			dev_err(adapter->dev, "deaggr: host_to_card failed\n");
+		case 0:
+			mwifiex_recv_packet_complete(adapter, skb_daggr, ret);
+			break;
+		default:
+			break;
+		}
+
+		data += pkt_len + pad;
+	}
+
+	return ret;
+}
+
+/*
+ * Create aggregated packet.
+ *
+ * This function creates an aggregated MSDU packet, by combining buffers
+ * from the RA list. Each individual buffer is encapsulated as an AMSDU
+ * subframe and all such subframes are concatenated together to form the
+ * AMSDU packet.
+ *
+ * A TxPD is also added to the front of the resultant AMSDU packets for
+ * transmission. The resultant packets format is -
+ *
+ * +---- ~ ----+------ ~ ------+------ ~ ------+-..-+------ ~ ------+
+ * |    TxPD   |AMSDU sub-frame|AMSDU sub-frame| .. |AMSDU sub-frame|
+ * |           |       1       |       2       | .. |       n       |
+ * +---- ~ ----+------ ~ ------+------ ~ ------+ .. +------ ~ ------+
+ */
+int
+mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
+			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
+			  int ptrindex, unsigned long ra_list_flags)
+			  __releases(&priv->wmm.ra_list_spinlock)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct sk_buff *skb_aggr, *skb_src;
+	struct mwifiex_txinfo *tx_info_aggr, *tx_info_src;
+	int pad = 0;
+	int ret = 0;
+	struct mwifiex_tx_param tx_param;
+	struct txpd *ptx_pd = NULL;
+
+	if (skb_queue_empty(&pra_list->skb_head)) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		return 0;
+	}
+	skb_src = skb_peek(&pra_list->skb_head);
+	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
+	skb_aggr = dev_alloc_skb(adapter->tx_buf_size);
+	if (!skb_aggr) {
+		dev_err(adapter->dev, "%s: alloc skb_aggr\n", __func__);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		return -1;
+	}
+	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
+	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
+
+	tx_info_aggr->bss_index = tx_info_src->bss_index;
+	skb_aggr->priority = skb_src->priority;
+
+	while (skb_src && ((skb_headroom(skb_aggr) + skb_src->len
+					+ LLC_SNAP_LEN)
+				<= adapter->tx_buf_size)) {
+
+		if (!skb_queue_empty(&pra_list->skb_head))
+			skb_src = skb_dequeue(&pra_list->skb_head);
+		else
+			skb_src = NULL;
+
+		pra_list->total_pkts_size -= skb_src->len;
+
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		mwifiex_11n_form_amsdu_pkt(adapter, skb_aggr, skb_src, &pad);
+
+		mwifiex_write_data_complete(adapter, skb_src, 0);
+
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
+			return -1;
+		}
+
+		if (!skb_queue_empty(&pra_list->skb_head))
+			skb_src = skb_peek(&pra_list->skb_head);
+		else
+			skb_src = NULL;
+	}
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+	/* Last AMSDU packet does not need padding */
+	skb_trim(skb_aggr, skb_aggr->len - pad);
+
+	/* Form AMSDU */
+	mwifiex_11n_form_amsdu_txpd(priv, skb_aggr);
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+		ptx_pd = (struct txpd *)skb_aggr->data;
+
+	skb_push(skb_aggr, headroom);
+
+	tx_param.next_pkt_len = ((pra_list->total_pkts_size) ?
+				 (((pra_list->total_pkts_size) >
+				   adapter->tx_buf_size) ? adapter->
+				  tx_buf_size : pra_list->total_pkts_size +
+				  LLC_SNAP_LEN + sizeof(struct txpd)) : 0);
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					     skb_aggr->data,
+					     skb_aggr->len, &tx_param);
+	switch (ret) {
+	case -EBUSY:
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
+			mwifiex_write_data_complete(adapter, skb_aggr, -1);
+			return -1;
+		}
+		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+			(adapter->pps_uapsd_mode) &&
+			(adapter->tx_lock_flag)) {
+				priv->adapter->tx_lock_flag = false;
+				ptx_pd->flags = 0;
+		}
+
+		skb_queue_tail(&pra_list->skb_head, skb_aggr);
+
+		pra_list->total_pkts_size += skb_aggr->len;
+
+		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		break;
+	case -1:
+		adapter->data_sent = false;
+		dev_err(adapter->dev, "%s: host_to_card failed: %#x\n",
+						__func__, ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, skb_aggr, ret);
+		return 0;
+	case -EINPROGRESS:
+		adapter->data_sent = false;
+		break;
+	case 0:
+		mwifiex_write_data_complete(adapter, skb_aggr, ret);
+		break;
+	default:
+		break;
+	}
+	if (ret != -EBUSY) {
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
+			priv->wmm.packets_out[ptrindex]++;
+			priv->wmm.tid_tbl_ptr[ptrindex].ra_list_curr = pra_list;
+		}
+		/* Now bss_prio_cur pointer points to next node */
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node, list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
new file mode 100644
index 0000000..9c6dca7
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -0,0 +1,32 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n Aggregation
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_11N_AGGR_H_
+#define _MWIFIEX_11N_AGGR_H_
+
+#define PKT_TYPE_AMSDU	0xE6
+
+int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
+				struct sk_buff *skb);
+int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
+			      struct mwifiex_ra_list_tbl *ptr, int headroom,
+			      int ptr_index, unsigned long flags)
+			      __releases(&priv->wmm.ra_list_spinlock);
+
+#endif /* !_MWIFIEX_11N_AGGR_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
new file mode 100644
index 0000000..8e94e62
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -0,0 +1,637 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+#include "11n_rxreorder.h"
+
+/*
+ * This function processes a received packet and forwards
+ * it to the kernel/upper layer.
+ */
+static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	ret = mwifiex_process_rx_packet(adapter, (struct sk_buff *) payload);
+	return ret;
+}
+
+/*
+ * This function dispatches all packets in the Rx reorder table.
+ *
+ * There could be holes in the buffer, which are skipped by the function.
+ * Since the buffer is linear, the function uses rotation to simulate
+ * circular buffer.
+ */
+static int
+mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
+					 struct mwifiex_rx_reorder_tbl
+					 *rx_reor_tbl_ptr, int start_win)
+{
+	int no_pkt_to_send, i, xchg;
+	void *rx_tmp_ptr = NULL;
+	unsigned long flags;
+
+	no_pkt_to_send = (start_win > rx_reor_tbl_ptr->start_win) ?
+		min((start_win - rx_reor_tbl_ptr->start_win),
+		    rx_reor_tbl_ptr->win_size) : rx_reor_tbl_ptr->win_size;
+
+	for (i = 0; i < no_pkt_to_send; ++i) {
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+		rx_tmp_ptr = NULL;
+		if (rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
+			rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
+			rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
+		}
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+		if (rx_tmp_ptr)
+			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+	}
+
+	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+	/*
+	 * We don't have a circular buffer, hence use rotation to simulate
+	 * circular buffer
+	 */
+	xchg = rx_reor_tbl_ptr->win_size - no_pkt_to_send;
+	for (i = 0; i < xchg; ++i) {
+		rx_reor_tbl_ptr->rx_reorder_ptr[i] =
+			rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i];
+		rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i] = NULL;
+	}
+
+	rx_reor_tbl_ptr->start_win = start_win;
+	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+
+	return 0;
+}
+
+/*
+ * This function dispatches all packets in the Rx reorder table until
+ * a hole is found.
+ *
+ * The start window is adjusted automatically when a hole is located.
+ * Since the buffer is linear, the function uses rotation to simulate
+ * circular buffer.
+ */
+static int
+mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
+			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
+{
+	int i, j, xchg;
+	void *rx_tmp_ptr = NULL;
+	unsigned long flags;
+
+	for (i = 0; i < rx_reor_tbl_ptr->win_size; ++i) {
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+		if (!rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+			break;
+		}
+		rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
+		rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+	}
+
+	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+	/*
+	 * We don't have a circular buffer, hence use rotation to simulate
+	 * circular buffer
+	 */
+	if (i > 0) {
+		xchg = rx_reor_tbl_ptr->win_size - i;
+		for (j = 0; j < xchg; ++j) {
+			rx_reor_tbl_ptr->rx_reorder_ptr[j] =
+				rx_reor_tbl_ptr->rx_reorder_ptr[i + j];
+			rx_reor_tbl_ptr->rx_reorder_ptr[i + j] = NULL;
+		}
+	}
+	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
+		&(MAX_TID_VALUE - 1);
+	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+	return 0;
+}
+
+/*
+ * This function deletes the Rx reorder table and frees the memory.
+ *
+ * The function stops the associated timer and dispatches all the
+ * pending packets in the Rx reorder table before deletion.
+ */
+static void
+mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
+				       struct mwifiex_rx_reorder_tbl
+				       *rx_reor_tbl_ptr)
+{
+	unsigned long flags;
+
+	if (!rx_reor_tbl_ptr)
+		return;
+
+	mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
+						 (rx_reor_tbl_ptr->start_win +
+						  rx_reor_tbl_ptr->win_size)
+						 &(MAX_TID_VALUE - 1));
+
+	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_del(&rx_reor_tbl_ptr->list);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	kfree(rx_reor_tbl_ptr->rx_reorder_ptr);
+	kfree(rx_reor_tbl_ptr);
+}
+
+/*
+ * This function returns the pointer to an entry in Rx reordering
+ * table which matches the given TA/TID pair.
+ */
+static struct mwifiex_rx_reorder_tbl *
+mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
+{
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
+		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, ETH_ALEN))
+		    && (rx_reor_tbl_ptr->tid == tid)) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
+			return rx_reor_tbl_ptr;
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	return NULL;
+}
+
+/*
+ * This function finds the last sequence number used in the packets
+ * buffered in Rx reordering table.
+ */
+static int
+mwifiex_11n_find_last_seq_num(struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr)
+{
+	int i;
+
+	for (i = (rx_reorder_tbl_ptr->win_size - 1); i >= 0; --i)
+		if (rx_reorder_tbl_ptr->rx_reorder_ptr[i])
+			return i;
+
+	return -1;
+}
+
+/*
+ * This function flushes all the packets in Rx reordering table.
+ *
+ * The function checks if any packets are currently buffered in the
+ * table or not. In case there are packets available, it dispatches
+ * them and then dumps the Rx reordering table.
+ */
+static void
+mwifiex_flush_data(unsigned long context)
+{
+	struct reorder_tmr_cnxt *reorder_cnxt =
+		(struct reorder_tmr_cnxt *) context;
+	int start_win;
+
+	start_win = mwifiex_11n_find_last_seq_num(reorder_cnxt->ptr);
+	if (start_win >= 0) {
+		dev_dbg(reorder_cnxt->priv->adapter->dev,
+				"info: flush data %d\n", start_win);
+		mwifiex_11n_dispatch_pkt_until_start_win(reorder_cnxt->priv,
+				reorder_cnxt->ptr,
+				((reorder_cnxt->ptr->start_win +
+				  start_win + 1) & (MAX_TID_VALUE - 1)));
+	}
+}
+
+/*
+ * This function creates an entry in Rx reordering table for the
+ * given TA/TID.
+ *
+ * The function also initializes the entry with sequence number, window
+ * size as well as initializes the timer.
+ *
+ * If the received TA/TID pair is already present, all the packets are
+ * dispatched and the window size is moved until the SSN.
+ */
+static void
+mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
+				 int tid, int win_size, int seq_num)
+{
+	int i;
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr, *new_node;
+	u16 last_seq = 0;
+	unsigned long flags;
+
+	/*
+	 * If we get a TID, ta pair which is already present dispatch all the
+	 * the packets and move the window size until the ssn
+	 */
+	rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
+	if (rx_reor_tbl_ptr) {
+		mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
+							 seq_num);
+		return;
+	}
+	/* if !rx_reor_tbl_ptr then create one */
+	new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl), GFP_KERNEL);
+	if (!new_node) {
+		dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
+		       __func__);
+		return;
+	}
+
+	INIT_LIST_HEAD(&new_node->list);
+	new_node->tid = tid;
+	memcpy(new_node->ta, ta, ETH_ALEN);
+	new_node->start_win = seq_num;
+	if (mwifiex_queuing_ra_based(priv))
+		/* TODO for adhoc */
+		dev_dbg(priv->adapter->dev,
+			"info: ADHOC:last_seq=%d start_win=%d\n",
+			last_seq, new_node->start_win);
+	else
+		last_seq = priv->rx_seq[tid];
+
+	if (last_seq >= new_node->start_win)
+		new_node->start_win = last_seq + 1;
+
+	new_node->win_size = win_size;
+
+	new_node->rx_reorder_ptr = kzalloc(sizeof(void *) * win_size,
+					GFP_KERNEL);
+	if (!new_node->rx_reorder_ptr) {
+		kfree((u8 *) new_node);
+		dev_err(priv->adapter->dev,
+			"%s: failed to alloc reorder_ptr\n", __func__);
+		return;
+	}
+
+	new_node->timer_context.ptr = new_node;
+	new_node->timer_context.priv = priv;
+
+	init_timer(&new_node->timer_context.timer);
+	new_node->timer_context.timer.function = mwifiex_flush_data;
+	new_node->timer_context.timer.data =
+			(unsigned long) &new_node->timer_context;
+
+	for (i = 0; i < win_size; ++i)
+		new_node->rx_reorder_ptr[i] = NULL;
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	return;
+}
+
+/*
+ * This function prepares command for adding a BA request.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting add BA request buffer
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	struct host_cmd_ds_11n_addba_req *add_ba_req =
+		(struct host_cmd_ds_11n_addba_req *)
+		&cmd->params.add_ba_req;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_REQ);
+	cmd->size = cpu_to_le16(sizeof(*add_ba_req) + S_DS_GEN);
+	memcpy(add_ba_req, data_buf, sizeof(*add_ba_req));
+
+	return 0;
+}
+
+/*
+ * This function prepares command for adding a BA response.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting add BA response buffer
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command *cmd,
+				  void *data_buf)
+{
+	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
+		(struct host_cmd_ds_11n_addba_rsp *)
+		&cmd->params.add_ba_rsp;
+	struct host_cmd_ds_11n_addba_req *cmd_addba_req =
+		(struct host_cmd_ds_11n_addba_req *) data_buf;
+	u8 tid = 0;
+	int win_size = 0;
+	uint16_t block_ack_param_set;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
+	cmd->size = cpu_to_le16(sizeof(*add_ba_rsp) + S_DS_GEN);
+
+	memcpy(add_ba_rsp->peer_mac_addr, cmd_addba_req->peer_mac_addr,
+	       ETH_ALEN);
+	add_ba_rsp->dialog_token = cmd_addba_req->dialog_token;
+	add_ba_rsp->block_ack_tmo = cmd_addba_req->block_ack_tmo;
+	add_ba_rsp->ssn = cmd_addba_req->ssn;
+
+	block_ack_param_set = le16_to_cpu(cmd_addba_req->block_ack_param_set);
+	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
+		>> BLOCKACKPARAM_TID_POS;
+	add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
+	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
+	/* We donot support AMSDU inside AMPDU, hence reset the bit */
+	block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
+	block_ack_param_set |= (priv->add_ba_param.rx_win_size <<
+					     BLOCKACKPARAM_WINSIZE_POS);
+	add_ba_rsp->block_ack_param_set = cpu_to_le16(block_ack_param_set);
+	win_size = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
+					& IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
+					>> BLOCKACKPARAM_WINSIZE_POS;
+	cmd_addba_req->block_ack_param_set = cpu_to_le16(block_ack_param_set);
+
+	mwifiex_11n_create_rx_reorder_tbl(priv, cmd_addba_req->peer_mac_addr,
+			    tid, win_size, le16_to_cpu(cmd_addba_req->ssn));
+	return 0;
+}
+
+/*
+ * This function prepares command for deleting a BA request.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting del BA request buffer
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	struct host_cmd_ds_11n_delba *del_ba = (struct host_cmd_ds_11n_delba *)
+		&cmd->params.del_ba;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_11N_DELBA);
+	cmd->size = cpu_to_le16(sizeof(*del_ba) + S_DS_GEN);
+	memcpy(del_ba, data_buf, sizeof(*del_ba));
+
+	return 0;
+}
+
+/*
+ * This function identifies if Rx reordering is needed for a received packet.
+ *
+ * In case reordering is required, the function will do the reordering
+ * before sending it to kernel.
+ *
+ * The Rx reorder table is checked first with the received TID/TA pair. If
+ * not found, the received packet is dispatched immediately. But if found,
+ * the packet is reordered and all the packets in the updated Rx reordering
+ * table is dispatched until a hole is found.
+ *
+ * For sequence number less than the starting window, the packet is dropped.
+ */
+int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
+				u16 seq_num, u16 tid,
+				u8 *ta, u8 pkt_type, void *payload)
+{
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	int start_win, end_win, win_size;
+	int ret = 0;
+	u16 pkt_index = 0;
+
+	rx_reor_tbl_ptr =
+		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
+						tid, ta);
+	if (!rx_reor_tbl_ptr) {
+		if (pkt_type != PKT_TYPE_BAR)
+			mwifiex_11n_dispatch_pkt(priv, payload);
+		return 0;
+	}
+	start_win = rx_reor_tbl_ptr->start_win;
+	win_size = rx_reor_tbl_ptr->win_size;
+	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
+	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
+	mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
+			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
+
+	/*
+	 * If seq_num is less then starting win then ignore and drop the
+	 * packet
+	 */
+	if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
+		if (seq_num >= ((start_win + (TWOPOW11)) & (MAX_TID_VALUE - 1))
+				&& (seq_num < start_win))
+			return -1;
+	} else if ((seq_num < start_win)
+			|| (seq_num > (start_win + (TWOPOW11)))) {
+		return -1;
+	}
+
+	/*
+	 * If this packet is a BAR we adjust seq_num as
+	 * WinStart = seq_num
+	 */
+	if (pkt_type == PKT_TYPE_BAR)
+		seq_num = ((seq_num + win_size) - 1) & (MAX_TID_VALUE - 1);
+
+	if (((end_win < start_win)
+	     && (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win)))
+	     && (seq_num > end_win)) || ((end_win > start_win)
+	     && ((seq_num > end_win) || (seq_num < start_win)))) {
+		end_win = seq_num;
+		if (((seq_num - win_size) + 1) >= 0)
+			start_win = (end_win - win_size) + 1;
+		else
+			start_win = (MAX_TID_VALUE - (win_size - seq_num)) + 1;
+		ret = mwifiex_11n_dispatch_pkt_until_start_win(priv,
+						rx_reor_tbl_ptr, start_win);
+
+		if (ret)
+			return ret;
+	}
+
+	if (pkt_type != PKT_TYPE_BAR) {
+		if (seq_num >= start_win)
+			pkt_index = seq_num - start_win;
+		else
+			pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
+
+		if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index])
+			return -1;
+
+		rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
+	}
+
+	/*
+	 * Dispatch all packets sequentially from start_win until a
+	 * hole is found and adjust the start_win appropriately
+	 */
+	ret = mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
+
+	return ret;
+}
+
+/*
+ * This function deletes an entry for a given TID/TA pair.
+ *
+ * The TID/TA are taken from del BA event body.
+ */
+void
+mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
+				u8 *peer_mac, u8 type, int initiator)
+{
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
+	u8 cleanup_rx_reorder_tbl;
+	unsigned long flags;
+
+	if (type == TYPE_DELBA_RECEIVE)
+		cleanup_rx_reorder_tbl = (initiator) ? true : false;
+	else
+		cleanup_rx_reorder_tbl = (initiator) ? false : true;
+
+	dev_dbg(priv->adapter->dev, "event: DELBA: %pM tid=%d, "
+	       "initiator=%d\n", peer_mac, tid, initiator);
+
+	if (cleanup_rx_reorder_tbl) {
+		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
+								 peer_mac);
+		if (!rx_reor_tbl_ptr) {
+			dev_dbg(priv->adapter->dev,
+					"event: TID, TA not found in table\n");
+			return;
+		}
+		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, rx_reor_tbl_ptr);
+	} else {
+		ptx_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, peer_mac);
+		if (!ptx_tbl) {
+			dev_dbg(priv->adapter->dev,
+					"event: TID, RA not found in table\n");
+			return;
+		}
+
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, ptx_tbl);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+	}
+}
+
+/*
+ * This function handles the command response of an add BA response.
+ *
+ * Handling includes changing the header fields into CPU format and
+ * creating the stream, provided the add BA is accepted.
+ */
+int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
+		(struct host_cmd_ds_11n_addba_rsp *)
+		&resp->params.add_ba_rsp;
+	int tid, win_size;
+	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr = NULL;
+	uint16_t block_ack_param_set;
+
+	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
+
+	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
+		>> BLOCKACKPARAM_TID_POS;
+	/*
+	 * Check if we had rejected the ADDBA, if yes then do not create
+	 * the stream
+	 */
+	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
+		win_size = (block_ack_param_set &
+			IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
+			>> BLOCKACKPARAM_WINSIZE_POS;
+
+		dev_dbg(priv->adapter->dev, "cmd: ADDBA RSP: %pM"
+		       " tid=%d ssn=%d win_size=%d\n",
+		       add_ba_rsp->peer_mac_addr,
+		       tid, add_ba_rsp->ssn, win_size);
+	} else {
+		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
+					add_ba_rsp->peer_mac_addr, tid);
+
+		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv,
+					tid, add_ba_rsp->peer_mac_addr);
+		if (rx_reor_tbl_ptr)
+			mwifiex_11n_delete_rx_reorder_tbl_entry(priv,
+				rx_reor_tbl_ptr);
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles BA stream timeout event by preparing and sending
+ * a command to the firmware.
+ */
+void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
+				   struct host_cmd_ds_11n_batimeout *event)
+{
+	struct host_cmd_ds_11n_delba delba;
+
+	memset(&delba, 0, sizeof(struct host_cmd_ds_11n_delba));
+	memcpy(delba.peer_mac_addr, event->peer_mac_addr, ETH_ALEN);
+
+	delba.del_ba_param_set |=
+		cpu_to_le16((u16) event->tid << DELBA_TID_POS);
+	delba.del_ba_param_set |= cpu_to_le16(
+		(u16) event->origninator << DELBA_INITIATOR_POS);
+	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
+	mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA, 0, 0, NULL, &delba);
+
+	return;
+}
+
+/*
+ * This function cleans up the Rx reorder table by deleting all the entries
+ * and re-initializing.
+ */
+void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
+{
+	struct mwifiex_rx_reorder_tbl *del_tbl_ptr, *tmp_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
+				 &priv->rx_reorder_tbl_ptr, list) {
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, del_tbl_ptr);
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
+	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
+}
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
new file mode 100644
index 0000000..42f5690
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -0,0 +1,67 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11n RX Re-ordering
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_11N_RXREORDER_H_
+#define _MWIFIEX_11N_RXREORDER_H_
+
+#define MIN_FLUSH_TIMER_MS		50
+
+#define PKT_TYPE_BAR 0xE7
+#define MAX_TID_VALUE			(2 << 11)
+#define TWOPOW11			(2 << 10)
+
+#define BLOCKACKPARAM_TID_POS		2
+#define BLOCKACKPARAM_AMSDU_SUPP_MASK	0x1
+#define BLOCKACKPARAM_WINSIZE_POS	6
+#define DELBA_TID_POS			12
+#define DELBA_INITIATOR_POS		11
+#define TYPE_DELBA_SENT			1
+#define TYPE_DELBA_RECEIVE		2
+#define IMMEDIATE_BLOCK_ACK		0x2
+
+#define ADDBA_RSP_STATUS_ACCEPT 0
+
+int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
+			       u16 seqNum,
+			       u16 tid, u8 *ta,
+			       u8 pkttype, void *payload);
+void mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int Tid,
+				     u8 *PeerMACAddr, u8 type,
+				     int initiator);
+void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
+				   struct host_cmd_ds_11n_batimeout *event);
+int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command
+			       *resp);
+int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd,
+			  void *data_buf);
+int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command
+				  *cmd, void *data_buf);
+int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *cmd,
+			      void *data_buf);
+void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv);
+struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
+							   mwifiex_private
+							   *priv, int tid,
+							   u8 *ta);
+
+#endif /* _MWIFIEX_11N_RXREORDER_H_ */
diff --git a/drivers/net/wireless/mwifiex/Kconfig b/drivers/net/wireless/mwifiex/Kconfig
new file mode 100644
index 0000000..8696292
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -0,0 +1,21 @@
+config MWIFIEX
+	tristate "Marvell WiFi-Ex Driver"
+	depends on CFG80211
+	select LIB80211
+	---help---
+	  This adds support for wireless adapters based on Marvell
+	  802.11n chipsets.
+
+	  If you choose to build it as a module, it will be called
+	  mwifiex.
+
+config MWIFIEX_SDIO
+	tristate "Marvell WiFi-Ex Driver for SD8787"
+	depends on MWIFIEX && MMC
+	select FW_LOADER
+	---help---
+	  This adds support for wireless adapters based on Marvell
+	  8787 chipset with SDIO interface.
+
+	  If you choose to build it as a module, it will be called
+	  mwifiex_sdio.
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
new file mode 100644
index 0000000..42cb733
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -0,0 +1,41 @@
+#
+# Copyright (C) 2011, Marvell International Ltd.
+#
+# This software file (the "File") is distributed by Marvell International
+# Ltd. under the terms of the GNU General Public License Version 2, June 1991
+# (the "License").  You may use, redistribute and/or modify this File in
+# accordance with the terms and conditions of the License, a copy of which
+# is available by writing to the Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+# worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+#
+# THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+# IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+# ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+# this warranty disclaimer.
+
+
+mwifiex-y += main.o
+mwifiex-y += init.o
+mwifiex-y += cfp.o
+mwifiex-y += cmdevt.o
+mwifiex-y += util.o
+mwifiex-y += txrx.o
+mwifiex-y += wmm.o
+mwifiex-y += 11n.o
+mwifiex-y += 11n_aggr.o
+mwifiex-y += 11n_rxreorder.o
+mwifiex-y += scan.o
+mwifiex-y += join.o
+mwifiex-y += sta_ioctl.o
+mwifiex-y += sta_cmd.o
+mwifiex-y += sta_cmdresp.o
+mwifiex-y += sta_event.o
+mwifiex-y += sta_tx.o
+mwifiex-y += sta_rx.o
+mwifiex-y += cfg80211.o
+mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
+obj-$(CONFIG_MWIFIEX) += mwifiex.o
+
+mwifiex_sdio-y += sdio.o
+obj-$(CONFIG_MWIFIEX_SDIO) += mwifiex_sdio.o
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
new file mode 100644
index 0000000..338377f
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/README
@@ -0,0 +1,204 @@
+# Copyright (C) 2011, Marvell International Ltd.
+#
+# This software file (the "File") is distributed by Marvell International
+# Ltd. under the terms of the GNU General Public License Version 2, June 1991
+# (the "License").  You may use, redistribute and/or modify this File in
+# accordance with the terms and conditions of the License, a copy of which
+# is available by writing to the Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+# worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+#
+# THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+# IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+# ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+# this warranty disclaimer.
+
+
+===============================================================================
+			U S E R  M A N U A L
+
+1) FOR DRIVER INSTALL
+
+	a) Copy sd8787.bin to /lib/firmware/mrvl/ directory,
+	   create the directory if it doesn't exist.
+	b) Install WLAN driver,
+		insmod mwifiex.ko
+	c) Uninstall WLAN driver,
+		ifconfig mlanX down
+		rmmod mwifiex
+
+
+2) FOR DRIVER CONFIGURATION AND INFO
+	The configurations can be done either using the 'iw' user space
+	utility or debugfs.
+
+	a) 'iw' utility commands
+
+	Following are some useful iw commands:-
+
+iw dev mlan0 scan
+
+	This command will trigger a scan.
+	The command will then display the scan table entries
+
+iw dev mlan0 connect -w <SSID> [<freq in MHz>] [<bssid>] [key 0:abcde d:1123456789a]
+	The above command can be used to connect to an AP with a particular SSID.
+	Ap's operating frequency can be specified or even the bssid. If the AP is using
+	WEP encryption, wep keys can be specified in the command.
+	Note: Every time before connecting to an AP scan command (iw dev mlan0 scan) should be used by user.
+
+iw dev mlan0 disconnect
+	This command will be used to disconnect from an AP.
+
+
+iw dev mlan0 ibss join <SSID> <freq in MHz> [fixed-freq] [fixed-bssid] [key 0:abcde]
+	The command will be used to join or create an ibss. Optionally, operating frequency,
+	bssid and the security related parameters can be specified while joining/creating
+	and ibss.
+
+iw dev mlan0 ibss leave
+	The command will be used to leave an ibss network.
+
+iw dev mlan0 link
+	The command will be used to get the connection status. The command will return parameters
+	such as SSID, operating frequency, rx/tx packets, signal strength, tx bitrate.
+
+	Apart from the iw utility all standard configurations using the 'iwconfig' utility are also supported.
+
+	b) Debugfs interface
+
+	The debugfs interface can be used for configurations and for getting
+	some useful information from the driver.
+	The section below explains the configurations that can be
+	done.
+
+	Mount debugfs to /debugfs mount point:
+
+		mkdir /debugfs
+		mount -t debugfs debugfs /debugfs
+
+	The information is provided in /debugfs/mwifiex/mlanX/:
+
+iw reg set <country code>
+	The command will be used to change the regulatory domain.
+
+iw reg get
+	The command will be used to get current regulatory domain.
+
+info
+	This command is used to get driver info.
+
+	Usage:
+		cat info
+
+	driver_name = "mwifiex"
+	driver_version = <driver_name, driver_version, (firmware_version)>
+	interface_name = "mlanX"
+	bss_mode = "Ad-hoc" | "Managed" | "Auto" | "Unknown"
+	media_state = "Disconnected" | "Connected"
+	mac_address = <6-byte adapter MAC address>
+	multicase_count = <multicast address count>
+	essid = <current SSID>
+	bssid = <current BSSID>
+	channel = <current channel>
+	region_code = <current region code>
+	multicasr_address[n] = <multicast address>
+	num_tx_bytes = <number of bytes sent to device>
+	num_rx_bytes = <number of bytes received from device and sent to kernel>
+	num_tx_pkts = <number of packets sent to device>
+	num_rx_pkts = <number of packets received from device and sent to kernel>
+	num_tx_pkts_dropped = <number of Tx packets dropped by driver>
+	num_rx_pkts_dropped = <number of Rx packets dropped by driver>
+	num_tx_pkts_err = <number of Tx packets failed to send to device>
+	num_rx_pkts_err = <number of Rx packets failed to receive from device>
+	carrier "on" | "off"
+	tx queue "stopped" | "started"
+
+	The following debug info are provided in /debugfs/mwifiex/mlanX/debug:
+
+	int_counter = <interrupt count, cleared when interrupt handled>
+	wmm_ac_vo = <number of packets sent to device from WMM AcVo queue>
+	wmm_ac_vi = <number of packets sent to device from WMM AcVi queue>
+	wmm_ac_be = <number of packets sent to device from WMM AcBE queue>
+	wmm_ac_bk = <number of packets sent to device from WMM AcBK queue>
+	max_tx_buf_size = <maximum Tx buffer size>
+	tx_buf_size = <current Tx buffer size>
+	curr_tx_buf_size = <current Tx buffer size>
+	ps_mode = <0/1, CAM mode/PS mode>
+	ps_state = <0/1/2/3, full power state/awake state/pre-sleep state/sleep state>
+	is_deep_sleep = <0/1, not deep sleep state/deep sleep state>
+	wakeup_dev_req = <0/1, wakeup device not required/required>
+	wakeup_tries = <wakeup device count, cleared when device awake>
+	hs_configured = <0/1, host sleep not configured/configured>
+	hs_activated = <0/1, extended host sleep not activated/activated>
+	num_tx_timeout = <number of Tx timeout>
+	num_cmd_timeout = <number of timeout commands>
+	timeout_cmd_id = <command id of the last timeout command>
+	timeout_cmd_act = <command action of the last timeout command>
+	last_cmd_id = <command id of the last several commands sent to device>
+	last_cmd_act = <command action of the last several commands sent to device>
+	last_cmd_index = <0 based last command index>
+	last_cmd_resp_id = <command id of the last several command responses received from device>
+	last_cmd_resp_index = <0 based last command response index>
+	last_event = <event id of the last several events received from device>
+	last_event_index = <0 based last event index>
+	num_cmd_h2c_fail = <number of commands failed to send to device>
+	num_cmd_sleep_cfm_fail = <number of sleep confirm failed to send to device>
+	num_tx_h2c_fail = <number of data packets failed to send to device>
+	num_evt_deauth = <number of deauthenticated events received from device>
+	num_evt_disassoc = <number of disassociated events received from device>
+	num_evt_link_lost = <number of link lost events received from device>
+	num_cmd_deauth = <number of deauthenticate commands sent to device>
+	num_cmd_assoc_ok = <number of associate commands with success return>
+	num_cmd_assoc_fail = <number of associate commands with failure return>
+	cmd_sent = <0/1, send command resources available/sending command to device>
+	data_sent = <0/1, send data resources available/sending data to device>
+	mp_rd_bitmap = <SDIO multi-port read bitmap>
+	mp_wr_bitmap = <SDIO multi-port write bitmap>
+	cmd_resp_received = <0/1, no cmd response to process/response received and yet to process>
+	event_received = <0/1, no event to process/event received and yet to process>
+	ioctl_pending = <number of ioctl pending>
+	tx_pending = <number of Tx packet pending>
+	rx_pending = <number of Rx packet pending>
+
+
+3) FOR DRIVER CONFIGURATION
+
+regrdwr
+	This command is used to read/write the adapter register.
+
+	Usage:
+		echo " <type> <offset> [value]" > regrdwr
+		cat regrdwr
+
+	where the parameters are,
+		<type>:     1:MAC/SOC, 2:BBP, 3:RF, 4:PMIC, 5:CAU
+		<offset>:   offset of register
+		[value]:    value to be written
+
+	Examples:
+		echo "1 0xa060" > regrdwr           : Read the MAC register
+		echo "1 0xa060 0x12" > regrdwr      : Write the MAC register
+		echo "1 0xa794 0x80000000" > regrdwr
+		                                    : Write 0x80000000 to MAC register
+rdeeprom
+	This command is used to read the EEPROM contents of the card.
+
+	Usage:
+		echo "<offset> <length>" > rdeeprom
+		cat rdeeprom
+
+	where the parameters are,
+		<offset>:   multiples of 4
+		<length>:   4-20, multiples of 4
+
+	Example:
+		echo "0 20" > rdeeprom      : Read 20 bytes of EEPROM data from offset 0
+
+getlog
+        This command is used to get the statistics available in the station.
+	Usage:
+
+	cat getlog
+
+===============================================================================
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
new file mode 100644
index 0000000..80f367f
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -0,0 +1,1517 @@
+/*
+ * Marvell Wireless LAN device driver: CFG80211
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "cfg80211.h"
+#include "main.h"
+
+/*
+ * This function maps the nl802.11 channel type into driver channel type.
+ *
+ * The mapping is as follows -
+ *      NL80211_CHAN_NO_HT     -> NO_SEC_CHANNEL
+ *      NL80211_CHAN_HT20      -> NO_SEC_CHANNEL
+ *      NL80211_CHAN_HT40PLUS  -> SEC_CHANNEL_ABOVE
+ *      NL80211_CHAN_HT40MINUS -> SEC_CHANNEL_BELOW
+ *      Others                 -> NO_SEC_CHANNEL
+ */
+static int
+mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
+						  channel_type)
+{
+	int channel;
+	switch (channel_type) {
+	case NL80211_CHAN_NO_HT:
+	case NL80211_CHAN_HT20:
+		channel = NO_SEC_CHANNEL;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+		channel = SEC_CHANNEL_ABOVE;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		channel = SEC_CHANNEL_BELOW;
+		break;
+	default:
+		channel = NO_SEC_CHANNEL;
+	}
+	return channel;
+}
+
+/*
+ * This function maps the driver channel type into nl802.11 channel type.
+ *
+ * The mapping is as follows -
+ *      NO_SEC_CHANNEL      -> NL80211_CHAN_HT20
+ *      SEC_CHANNEL_ABOVE   -> NL80211_CHAN_HT40PLUS
+ *      SEC_CHANNEL_BELOW   -> NL80211_CHAN_HT40MINUS
+ *      Others              -> NL80211_CHAN_HT20
+ */
+static enum nl80211_channel_type
+mwifiex_channels_to_cfg80211_channel_type(int channel_type)
+{
+	int channel;
+	switch (channel_type) {
+	case NO_SEC_CHANNEL:
+		channel = NL80211_CHAN_HT20;
+		break;
+	case SEC_CHANNEL_ABOVE:
+		channel = NL80211_CHAN_HT40PLUS;
+		break;
+	case SEC_CHANNEL_BELOW:
+		channel = NL80211_CHAN_HT40MINUS;
+		break;
+	default:
+		channel = NL80211_CHAN_HT20;
+	}
+	return channel;
+}
+
+/*
+ * This function checks whether WEP is set.
+ */
+static int
+mwifiex_is_alg_wep(u32 cipher)
+{
+	int alg = 0;
+
+	switch (cipher) {
+	case MWIFIEX_ENCRYPTION_MODE_WEP40:
+	case MWIFIEX_ENCRYPTION_MODE_WEP104:
+		alg = 1;
+		break;
+	default:
+		alg = 0;
+		break;
+	}
+	return alg;
+}
+
+/*
+ * This function maps the given cipher type into driver specific type.
+ *
+ * It also sets a flag to indicate whether WPA is enabled or not.
+ *
+ * The mapping table is -
+ *      Input cipher                Driver cipher type              WPA enabled?
+ *      ------------                ------------------              ------------
+ *      IW_AUTH_CIPHER_NONE         MWIFIEX_ENCRYPTION_MODE_NONE    No
+ *      WLAN_CIPHER_SUITE_WEP40     MWIFIEX_ENCRYPTION_MODE_WEP40   No
+ *      WLAN_CIPHER_SUITE_WEP104    MWIFIEX_ENCRYPTION_MODE_WEP104  No
+ *      WLAN_CIPHER_SUITE_TKIP      MWIFIEX_ENCRYPTION_MODE_TKIP    Yes
+ *      WLAN_CIPHER_SUITE_CCMP      MWIFIEX_ENCRYPTION_MODE_CCMP    Yes
+ *      Others                      -1                              No
+ */
+static int
+mwifiex_get_mwifiex_cipher(u32 cipher, int *wpa_enabled)
+{
+	int encrypt_mode;
+
+	if (wpa_enabled)
+		*wpa_enabled = 0;
+	switch (cipher) {
+	case IW_AUTH_CIPHER_NONE:
+		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
+		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_WEP40;
+		break;
+	case WLAN_CIPHER_SUITE_WEP104:
+		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_WEP104;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_TKIP;
+		if (wpa_enabled)
+			*wpa_enabled = 1;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		encrypt_mode = MWIFIEX_ENCRYPTION_MODE_CCMP;
+		if (wpa_enabled)
+			*wpa_enabled = 1;
+		break;
+	default:
+		encrypt_mode = -1;
+	}
+
+	return encrypt_mode;
+}
+
+/*
+ * This function retrieves the private structure from kernel wiphy structure.
+ */
+static void *mwifiex_cfg80211_get_priv(struct wiphy *wiphy)
+{
+	return (void *) (*(unsigned long *) wiphy_priv(wiphy));
+}
+
+/*
+ * CFG802.11 operation handler to delete a network key.
+ */
+static int
+mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
+			 u8 key_index, bool pairwise, const u8 *mac_addr)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	int ret = 0;
+
+	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 1);
+	if (ret) {
+		wiphy_err(wiphy, "deleting the crypto keys\n");
+		return -EFAULT;
+	}
+
+	wiphy_dbg(wiphy, "info: crypto keys deleted\n");
+	return 0;
+}
+
+/*
+ * CFG802.11 operation handler to set Tx power.
+ */
+static int
+mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
+			      enum nl80211_tx_power_setting type,
+			      int dbm)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	ret = mwifiex_set_tx_power(priv, type, dbm);
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to set Power Save option.
+ *
+ * The timeout value, if provided, is currently ignored.
+ */
+static int
+mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
+				struct net_device *dev,
+				bool enabled, int timeout)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	if (timeout)
+		wiphy_dbg(wiphy,
+			"info: ignoring the timeout value"
+			" for IEEE power save\n");
+
+	ret = mwifiex_drv_set_power(priv, enabled);
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to set the default network key.
+ */
+static int
+mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
+				 u8 key_index, bool unicast,
+				 bool multicast)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	int ret;
+
+	ret = mwifiex_set_encode(priv, NULL, 0, key_index, 0);
+
+	wiphy_dbg(wiphy, "info: set default Tx key index\n");
+
+	if (ret)
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * CFG802.11 operation handler to add a network key.
+ */
+static int
+mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct net_device *netdev,
+			 u8 key_index, bool pairwise, const u8 *mac_addr,
+			 struct key_params *params)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	int ret = 0;
+	int encrypt_mode;
+
+	encrypt_mode = mwifiex_get_mwifiex_cipher(params->cipher, NULL);
+
+	if (encrypt_mode != -1)
+		ret = mwifiex_set_encode(priv, params->key, params->key_len,
+						key_index, 0);
+
+	wiphy_dbg(wiphy, "info: crypto keys added\n");
+
+	if (ret)
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * This function sends domain information to the firmware.
+ *
+ * The following information are passed to the firmware -
+ *      - Country codes
+ *      - Sub bands (first channel, number of channels, maximum Tx power)
+ */
+static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
+{
+	u8 no_of_triplet = 0;
+	struct ieee80211_country_ie_triplet *t;
+	u8 no_of_parsed_chan = 0;
+	u8 first_chan = 0, next_chan = 0, max_pwr = 0;
+	u8 i, flag = 0;
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
+	int ret = 0;
+
+	/* Set country code */
+	domain_info->country_code[0] = priv->country_code[0];
+	domain_info->country_code[1] = priv->country_code[1];
+	domain_info->country_code[2] = ' ';
+
+	band = mwifiex_band_to_radio_type(adapter->config_bands);
+	if (!wiphy->bands[band]) {
+		wiphy_err(wiphy, "11D: setting domain info in FW\n");
+		return -1;
+	}
+
+	sband = wiphy->bands[band];
+
+	for (i = 0; i < sband->n_channels ; i++) {
+		ch = &sband->channels[i];
+		if (ch->flags & IEEE80211_CHAN_DISABLED)
+			continue;
+
+		if (!flag) {
+			flag = 1;
+			first_chan = (u32) ch->hw_value;
+			next_chan = first_chan;
+			max_pwr = ch->max_power;
+			no_of_parsed_chan = 1;
+			continue;
+		}
+
+		if (ch->hw_value == next_chan + 1 &&
+				ch->max_power == max_pwr) {
+			next_chan++;
+			no_of_parsed_chan++;
+		} else {
+			t = &domain_info->triplet[no_of_triplet];
+			t->chans.first_channel = first_chan;
+			t->chans.num_channels = no_of_parsed_chan;
+			t->chans.max_power = max_pwr;
+			no_of_triplet++;
+			first_chan = (u32) ch->hw_value;
+			next_chan = first_chan;
+			max_pwr = ch->max_power;
+			no_of_parsed_chan = 1;
+		}
+	}
+
+	if (flag) {
+		t = &domain_info->triplet[no_of_triplet];
+		t->chans.first_channel = first_chan;
+		t->chans.num_channels = no_of_parsed_chan;
+		t->chans.max_power = max_pwr;
+		no_of_triplet++;
+	}
+
+	domain_info->no_of_triplet = no_of_triplet;
+	/* Send cmd to FW to set domain info */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+				  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+	if (ret)
+		wiphy_err(wiphy, "11D: setting domain info in FW\n");
+
+	return ret;
+}
+
+/*
+ * CFG802.11 regulatory domain callback function.
+ *
+ * This function is called when the regulatory domain is changed due to the
+ * following reasons -
+ *      - Set by driver
+ *      - Set by system core
+ *      - Set by user
+ *      - Set bt Country IE
+ */
+static int mwifiex_reg_notifier(struct wiphy *wiphy,
+		struct regulatory_request *request)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	wiphy_dbg(wiphy, "info: cfg80211 regulatory domain callback for domain"
+			" %c%c\n", request->alpha2[0], request->alpha2[1]);
+
+	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
+
+	switch (request->initiator) {
+	case NL80211_REGDOM_SET_BY_DRIVER:
+	case NL80211_REGDOM_SET_BY_CORE:
+	case NL80211_REGDOM_SET_BY_USER:
+		break;
+		/* Todo: apply driver specific changes in channel flags based
+		   on the request initiator if necessary. */
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		break;
+	}
+	mwifiex_send_domain_info_cmd_fw(wiphy);
+
+	return 0;
+}
+
+/*
+ * This function sets the RF channel.
+ *
+ * This function creates multiple IOCTL requests, populates them accordingly
+ * and issues them to set the band/channel and frequency.
+ */
+static int
+mwifiex_set_rf_channel(struct mwifiex_private *priv,
+		       struct ieee80211_channel *chan,
+		       enum nl80211_channel_type channel_type)
+{
+	struct mwifiex_chan_freq_power cfp;
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_ds_band_cfg band_cfg;
+	int mode;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+	u32 config_bands = 0;
+	struct wiphy *wiphy = priv->wdev->wiphy;
+
+	mode = mwifiex_drv_get_mode(priv, wait_option);
+
+	if (chan) {
+		memset(&band_cfg, 0, sizeof(band_cfg));
+		/* Set appropriate bands */
+		if (chan->band == IEEE80211_BAND_2GHZ)
+			config_bands = BAND_B | BAND_G | BAND_GN;
+		else
+			config_bands = BAND_AN | BAND_A;
+		if (mode == MWIFIEX_BSS_MODE_INFRA
+		    || mode == MWIFIEX_BSS_MODE_AUTO) {
+			band_cfg.config_bands = config_bands;
+		} else if (mode == MWIFIEX_BSS_MODE_IBSS) {
+			band_cfg.config_bands = config_bands;
+			band_cfg.adhoc_start_band = config_bands;
+		}
+		/* Set channel offset */
+		band_cfg.sec_chan_offset =
+			mwifiex_cfg80211_channel_type_to_mwifiex_channels
+			(channel_type);
+		status = mwifiex_radio_ioctl_band_cfg(priv, HostCmd_ACT_GEN_SET,
+						      &band_cfg);
+
+		if (status)
+			return -EFAULT;
+		mwifiex_send_domain_info_cmd_fw(wiphy);
+	}
+
+	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
+		"mode %d\n", config_bands, band_cfg.sec_chan_offset, mode);
+	if (!chan)
+		return ret;
+
+	memset(&cfp, 0, sizeof(cfp));
+	cfp.freq = chan->center_freq;
+	/* Convert frequency to channel */
+	cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
+
+	status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET, &cfp);
+	if (status)
+		return -EFAULT;
+
+	ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to set channel.
+ *
+ * This function can only be used when station is not connected.
+ */
+static int
+mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type channel_type)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	if (priv->media_connected) {
+		wiphy_err(wiphy, "This setting is valid only when station "
+				"is not connected\n");
+		return -EINVAL;
+	}
+
+	return mwifiex_set_rf_channel(priv, chan, channel_type);
+}
+
+/*
+ * This function sets the fragmentation threshold.
+ *
+ * This function creates an IOCTL request, populates it accordingly
+ * and issues an IOCTL.
+ *
+ * The fragmentation threshold value must lies between MWIFIEX_FRAG_MIN_VALUE
+ * and MWIFIEX_FRAG_MAX_VALUE.
+ */
+static int
+mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
+	    || frag_thr > MWIFIEX_FRAG_MAX_VALUE)
+		return -EINVAL;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
+					HostCmd_ACT_GEN_SET, &frag_thr);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
+		ret = -EFAULT;
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * This function sets the RTS threshold.
+ *
+ * This function creates an IOCTL request, populates it accordingly
+ * and issues an IOCTL.
+ */
+static int
+mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
+		rts_thr = MWIFIEX_RTS_MAX_VALUE;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_snmp_mib_ioctl(priv, wait, RTS_THRESH_I,
+					HostCmd_ACT_GEN_SET, &rts_thr);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
+		ret = -EFAULT;
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to set wiphy parameters.
+ *
+ * This function can be used to set the RTS threshold and the
+ * Fragmentation threshold of the driver.
+ */
+static int
+mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	int ret = 0;
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+		ret = mwifiex_set_rts(priv, wiphy->rts_threshold);
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
+		ret = mwifiex_set_frag(priv, wiphy->frag_threshold);
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to change interface type.
+ *
+ * This function creates an IOCTL request, populates it accordingly
+ * and issues an IOCTL.
+ *
+ * The function also maps the CFG802.11 mode type into driver mode type.
+ *      NL80211_IFTYPE_ADHOC        -> MWIFIEX_BSS_MODE_IBSS
+ *      NL80211_IFTYPE_STATION      -> MWIFIEX_BSS_MODE_INFRA
+ *      NL80211_IFTYPE_UNSPECIFIED  -> MWIFIEX_BSS_MODE_AUTO
+ */
+static int
+mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     enum nl80211_iftype type, u32 *flags,
+				     struct vif_params *params)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int mode = -1;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	switch (type) {
+	case NL80211_IFTYPE_ADHOC:
+		mode = MWIFIEX_BSS_MODE_IBSS;
+		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_ADHOC;
+		wiphy_dbg(wiphy, "info: setting interface type to adhoc\n");
+		break;
+	case NL80211_IFTYPE_STATION:
+		mode = MWIFIEX_BSS_MODE_INFRA;
+		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
+		wiphy_dbg(wiphy, "info: Setting interface type to managed\n");
+		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
+		mode = MWIFIEX_BSS_MODE_AUTO;
+		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
+		wiphy_dbg(wiphy, "info: setting interface type to auto\n");
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (ret)
+		goto done;
+	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_SET, &mode);
+
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
+		ret = -EFAULT;
+
+done:
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * This function dumps the station information on a buffer.
+ *
+ * The following information are shown -
+ *      - Total bytes transmitted
+ *      - Total bytes received
+ *      - Total packets transmitted
+ *      - Total packets received
+ *      - Signal quality level
+ *      - Transmission rate
+ */
+static int
+mwifiex_dump_station_info(struct mwifiex_private *priv,
+			  struct station_info *sinfo)
+{
+	struct mwifiex_ds_get_signal signal;
+	struct mwifiex_rate_cfg rate;
+	int ret = 0;
+
+	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
+		STATION_INFO_RX_PACKETS |
+		STATION_INFO_TX_PACKETS
+		| STATION_INFO_SIGNAL | STATION_INFO_TX_BITRATE;
+
+	/* Get signal information from the firmware */
+	memset(&signal, 0, sizeof(struct mwifiex_ds_get_signal));
+	if (mwifiex_get_signal_info(priv, MWIFIEX_IOCTL_WAIT, &signal)) {
+		dev_err(priv->adapter->dev, "getting signal information\n");
+		ret = -EFAULT;
+	}
+
+	if (mwifiex_drv_get_data_rate(priv, &rate)) {
+		dev_err(priv->adapter->dev, "getting data rate\n");
+		ret = -EFAULT;
+	}
+
+	sinfo->rx_bytes = priv->stats.rx_bytes;
+	sinfo->tx_bytes = priv->stats.tx_bytes;
+	sinfo->rx_packets = priv->stats.rx_packets;
+	sinfo->tx_packets = priv->stats.tx_packets;
+	sinfo->signal = priv->w_stats.qual.level;
+	sinfo->txrate.legacy = rate.rate;
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to get station information.
+ *
+ * This function only works in connected mode, and dumps the
+ * requested station information, if available.
+ */
+static int
+mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
+			     u8 *mac, struct station_info *sinfo)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int ret = 0;
+
+	mwifiex_dump_station_info(priv, sinfo);
+
+	if (!priv->media_connected)
+		return -ENOENT;
+	if (memcmp(mac, priv->cfg_bssid, ETH_ALEN))
+		return -ENOENT;
+
+
+	ret = mwifiex_dump_station_info(priv, sinfo);
+
+	return ret;
+}
+
+/* Supported rates to be advertised to the cfg80211 */
+
+static struct ieee80211_rate mwifiex_rates[] = {
+	{.bitrate = 10, .hw_value = 2, },
+	{.bitrate = 20, .hw_value = 4, },
+	{.bitrate = 55, .hw_value = 11, },
+	{.bitrate = 110, .hw_value = 22, },
+	{.bitrate = 220, .hw_value = 44, },
+	{.bitrate = 60, .hw_value = 12, },
+	{.bitrate = 90, .hw_value = 18, },
+	{.bitrate = 120, .hw_value = 24, },
+	{.bitrate = 180, .hw_value = 36, },
+	{.bitrate = 240, .hw_value = 48, },
+	{.bitrate = 360, .hw_value = 72, },
+	{.bitrate = 480, .hw_value = 96, },
+	{.bitrate = 540, .hw_value = 108, },
+	{.bitrate = 720, .hw_value = 144, },
+};
+
+/* Channel definitions to be advertised to cfg80211 */
+
+static struct ieee80211_channel mwifiex_channels_2ghz[] = {
+	{.center_freq = 2412, .hw_value = 1, },
+	{.center_freq = 2417, .hw_value = 2, },
+	{.center_freq = 2422, .hw_value = 3, },
+	{.center_freq = 2427, .hw_value = 4, },
+	{.center_freq = 2432, .hw_value = 5, },
+	{.center_freq = 2437, .hw_value = 6, },
+	{.center_freq = 2442, .hw_value = 7, },
+	{.center_freq = 2447, .hw_value = 8, },
+	{.center_freq = 2452, .hw_value = 9, },
+	{.center_freq = 2457, .hw_value = 10, },
+	{.center_freq = 2462, .hw_value = 11, },
+	{.center_freq = 2467, .hw_value = 12, },
+	{.center_freq = 2472, .hw_value = 13, },
+	{.center_freq = 2484, .hw_value = 14, },
+};
+
+static struct ieee80211_supported_band mwifiex_band_2ghz = {
+	.channels = mwifiex_channels_2ghz,
+	.n_channels = ARRAY_SIZE(mwifiex_channels_2ghz),
+	.bitrates = mwifiex_rates,
+	.n_bitrates = 14,
+};
+
+static struct ieee80211_channel mwifiex_channels_5ghz[] = {
+	{.center_freq = 5040, .hw_value = 8, },
+	{.center_freq = 5060, .hw_value = 12, },
+	{.center_freq = 5080, .hw_value = 16, },
+	{.center_freq = 5170, .hw_value = 34, },
+	{.center_freq = 5190, .hw_value = 38, },
+	{.center_freq = 5210, .hw_value = 42, },
+	{.center_freq = 5230, .hw_value = 46, },
+	{.center_freq = 5180, .hw_value = 36, },
+	{.center_freq = 5200, .hw_value = 40, },
+	{.center_freq = 5220, .hw_value = 44, },
+	{.center_freq = 5240, .hw_value = 48, },
+	{.center_freq = 5260, .hw_value = 52, },
+	{.center_freq = 5280, .hw_value = 56, },
+	{.center_freq = 5300, .hw_value = 60, },
+	{.center_freq = 5320, .hw_value = 64, },
+	{.center_freq = 5500, .hw_value = 100, },
+	{.center_freq = 5520, .hw_value = 104, },
+	{.center_freq = 5540, .hw_value = 108, },
+	{.center_freq = 5560, .hw_value = 112, },
+	{.center_freq = 5580, .hw_value = 116, },
+	{.center_freq = 5600, .hw_value = 120, },
+	{.center_freq = 5620, .hw_value = 124, },
+	{.center_freq = 5640, .hw_value = 128, },
+	{.center_freq = 5660, .hw_value = 132, },
+	{.center_freq = 5680, .hw_value = 136, },
+	{.center_freq = 5700, .hw_value = 140, },
+	{.center_freq = 5745, .hw_value = 149, },
+	{.center_freq = 5765, .hw_value = 153, },
+	{.center_freq = 5785, .hw_value = 157, },
+	{.center_freq = 5805, .hw_value = 161, },
+	{.center_freq = 5825, .hw_value = 165, },
+};
+
+static struct ieee80211_supported_band mwifiex_band_5ghz = {
+	.channels = mwifiex_channels_5ghz,
+	.n_channels = ARRAY_SIZE(mwifiex_channels_5ghz),
+	.bitrates = mwifiex_rates - 4,
+	.n_bitrates = ARRAY_SIZE(mwifiex_rates) + 4,
+};
+
+
+/* Supported crypto cipher suits to be advertised to cfg80211 */
+
+static const u32 mwifiex_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+};
+
+/*
+ * CFG802.11 operation handler for disconnection request.
+ *
+ * This function does not work when there is already a disconnection
+ * procedure going on.
+ */
+static int
+mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
+			    u16 reason_code)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (priv->disconnect)
+		return -EBUSY;
+
+	priv->disconnect = 1;
+	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
+		return -EFAULT;
+
+	wiphy_dbg(wiphy, "info: successfully disconnected from %pM:"
+		" reason code %d\n", priv->cfg_bssid, reason_code);
+
+	queue_work(priv->workqueue, &priv->cfg_workqueue);
+
+	return 0;
+}
+
+/*
+ * This function informs the CFG802.11 subsystem of a new IBSS.
+ *
+ * The following information are sent to the CFG802.11 subsystem
+ * to register the new IBSS. If we do not register the new IBSS,
+ * a kernel panic will result.
+ *      - SSID
+ *      - SSID length
+ *      - BSSID
+ *      - Channel
+ */
+static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
+{
+	int ret = 0;
+	struct ieee80211_channel *chan;
+	struct mwifiex_bss_info bss_info;
+	int ie_len = 0;
+	u8 ie_buf[IEEE80211_MAX_SSID_LEN + sizeof(struct ieee_types_header)];
+
+	ret = mwifiex_get_bss_info(priv, &bss_info);
+	if (ret)
+		return ret;
+
+	ie_buf[0] = WLAN_EID_SSID;
+	ie_buf[1] = bss_info.ssid.ssid_len;
+
+	memcpy(&ie_buf[sizeof(struct ieee_types_header)],
+			&bss_info.ssid.ssid,
+			bss_info.ssid.ssid_len);
+	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
+
+	chan = __ieee80211_get_channel(priv->wdev->wiphy,
+			ieee80211_channel_to_frequency(bss_info.bss_chan,
+						priv->curr_bss_params.band));
+
+	cfg80211_inform_bss(priv->wdev->wiphy, chan,
+		bss_info.bssid, 0, WLAN_CAPABILITY_IBSS,
+		0, ie_buf, ie_len, 0, GFP_KERNEL);
+	memcpy(priv->cfg_bssid, bss_info.bssid, ETH_ALEN);
+
+	return ret;
+}
+
+/*
+ * This function informs the CFG802.11 subsystem of a new BSS connection.
+ *
+ * The following information are sent to the CFG802.11 subsystem
+ * to register the new BSS connection. If we do not register the new BSS,
+ * a kernel panic will result.
+ *      - MAC address
+ *      - Capabilities
+ *      - Beacon period
+ *      - RSSI value
+ *      - Channel
+ *      - Supported rates IE
+ *      - Extended capabilities IE
+ *      - DS parameter set IE
+ *      - HT Capability IE
+ *      - Vendor Specific IE (221)
+ *      - WPA IE
+ *      - RSN IE
+ */
+static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
+					       struct mwifiex_802_11_ssid *ssid)
+{
+	struct mwifiex_scan_resp scan_resp;
+	struct mwifiex_bssdescriptor *scan_table;
+	int i, j;
+	struct ieee80211_channel *chan;
+	u8 *ie, *tmp, *ie_buf;
+	u32 ie_len;
+	u64 ts = 0;
+	u8 *beacon;
+	int beacon_size;
+	u8 element_id, element_len;
+
+	memset(&scan_resp, 0, sizeof(scan_resp));
+	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp))
+		return -EFAULT;
+
+#define MAX_IE_BUF	2048
+	ie_buf = kzalloc(MAX_IE_BUF, GFP_KERNEL);
+	if (!ie_buf) {
+		dev_err(priv->adapter->dev, "%s: failed to alloc ie_buf\n",
+						__func__);
+		return -ENOMEM;
+	}
+
+	scan_table = (struct mwifiex_bssdescriptor *) scan_resp.scan_table;
+	for (i = 0; i < scan_resp.num_in_scan_table; i++) {
+		if (ssid) {
+			/* Inform specific BSS only */
+			if (memcmp(ssid->ssid, scan_table[i].ssid.ssid,
+					   ssid->ssid_len))
+				continue;
+		}
+		memset(ie_buf, 0, MAX_IE_BUF);
+		ie_buf[0] = WLAN_EID_SSID;
+		ie_buf[1] = scan_table[i].ssid.ssid_len;
+		memcpy(&ie_buf[sizeof(struct ieee_types_header)],
+		       scan_table[i].ssid.ssid, ie_buf[1]);
+
+		ie = ie_buf + ie_buf[1] + sizeof(struct ieee_types_header);
+		ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
+
+		ie[0] = WLAN_EID_SUPP_RATES;
+
+		for (j = 0; j < sizeof(scan_table[i].supported_rates); j++) {
+			if (!scan_table[i].supported_rates[j])
+				break;
+			else
+				ie[j + sizeof(struct ieee_types_header)] =
+					scan_table[i].supported_rates[j];
+		}
+
+		ie[1] = j;
+		ie_len += ie[1] + sizeof(struct ieee_types_header);
+
+		beacon = scan_table[i].beacon_buf;
+		beacon_size = scan_table[i].beacon_buf_size;
+
+		/* Skip time stamp, beacon interval and capability */
+
+		if (beacon) {
+			beacon += sizeof(scan_table[i].beacon_period)
+				+ sizeof(scan_table[i].time_stamp) +
+				+sizeof(scan_table[i].cap_info_bitmap);
+
+			beacon_size -= sizeof(scan_table[i].beacon_period)
+				+ sizeof(scan_table[i].time_stamp)
+				+ sizeof(scan_table[i].cap_info_bitmap);
+		}
+
+		while (beacon_size >= sizeof(struct ieee_types_header)) {
+			ie = ie_buf + ie_len;
+			element_id = *beacon;
+			element_len = *(beacon + 1);
+			if (beacon_size < (int) element_len +
+			    sizeof(struct ieee_types_header)) {
+				dev_err(priv->adapter->dev, "%s: in processing"
+					" IE, bytes left < IE length\n",
+					__func__);
+				break;
+			}
+			switch (element_id) {
+			case WLAN_EID_EXT_CAPABILITY:
+			case WLAN_EID_DS_PARAMS:
+			case WLAN_EID_HT_CAPABILITY:
+			case WLAN_EID_VENDOR_SPECIFIC:
+			case WLAN_EID_RSN:
+			case WLAN_EID_BSS_AC_ACCESS_DELAY:
+				ie[0] = element_id;
+				ie[1] = element_len;
+				tmp = (u8 *) beacon;
+				memcpy(&ie[sizeof(struct ieee_types_header)],
+				       tmp + sizeof(struct ieee_types_header),
+				       element_len);
+				ie_len += ie[1] +
+					sizeof(struct ieee_types_header);
+				break;
+			default:
+				break;
+			}
+			beacon += element_len +
+					sizeof(struct ieee_types_header);
+			beacon_size -= element_len +
+					sizeof(struct ieee_types_header);
+		}
+		chan = ieee80211_get_channel(priv->wdev->wiphy,
+						scan_table[i].freq);
+		cfg80211_inform_bss(priv->wdev->wiphy, chan,
+					scan_table[i].mac_address,
+					ts, scan_table[i].cap_info_bitmap,
+					scan_table[i].beacon_period,
+					ie_buf, ie_len,
+					scan_table[i].rssi, GFP_KERNEL);
+	}
+
+	kfree(ie_buf);
+	return 0;
+}
+
+/*
+ * This function connects with a BSS.
+ *
+ * This function handles both Infra and Ad-Hoc modes. It also performs
+ * validity checking on the provided parameters, disconnects from the
+ * current BSS (if any), sets up the association/scan parameters,
+ * including security settings, and performs specific SSID scan before
+ * trying to connect.
+ *
+ * For Infra mode, the function returns failure if the specified SSID
+ * is not found in scan table. However, for Ad-Hoc mode, it can create
+ * the IBSS if it does not exist. On successful completion in either case,
+ * the function notifies the CFG802.11 subsystem of the new BSS connection,
+ * otherwise the kernel will panic.
+ */
+static int
+mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
+		       u8 *bssid, int mode, struct ieee80211_channel *channel,
+		       struct cfg80211_connect_params *sme, bool privacy)
+{
+	struct mwifiex_802_11_ssid req_ssid;
+	struct mwifiex_ssid_bssid ssid_bssid;
+	int ret = 0;
+	int auth_type = 0, pairwise_encrypt_mode = 0, wpa_enabled = 0;
+	int group_encrypt_mode = 0;
+	int alg_is_wep = 0;
+
+	memset(&req_ssid, 0, sizeof(struct mwifiex_802_11_ssid));
+	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
+
+	req_ssid.ssid_len = ssid_len;
+	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
+		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
+		return -EINVAL;
+	}
+
+	memcpy(req_ssid.ssid, ssid, ssid_len);
+	if (!req_ssid.ssid_len || req_ssid.ssid[0] < 0x20) {
+		dev_err(priv->adapter->dev, "invalid SSID - aborting\n");
+		return -EINVAL;
+	}
+
+	/* disconnect before try to associate */
+	mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL);
+
+	if (channel)
+		ret = mwifiex_set_rf_channel(priv, channel,
+				mwifiex_channels_to_cfg80211_channel_type
+				(priv->adapter->chan_offset));
+
+	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
+
+	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+		/* "privacy" is set only for ad-hoc mode */
+		if (privacy) {
+			/*
+			 * Keep MWIFIEX_ENCRYPTION_MODE_WEP104 for now so that
+			 * the firmware can find a matching network from the
+			 * scan. The cfg80211 does not give us the encryption
+			 * mode at this stage so just setting it to WEP here.
+			 */
+			wpa_enabled = 0;
+			auth_type = MWIFIEX_AUTH_MODE_OPEN;
+			ret = mwifiex_set_auth(priv,
+						MWIFIEX_ENCRYPTION_MODE_WEP104,
+						auth_type, wpa_enabled);
+		}
+
+		goto done;
+	}
+
+	/* Now handle infra mode. "sme" is valid for infra mode only */
+	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC
+			|| sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
+		auth_type = MWIFIEX_AUTH_MODE_OPEN;
+	else if (sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY)
+		auth_type = MWIFIEX_AUTH_MODE_SHARED;
+
+	if (sme->crypto.n_ciphers_pairwise) {
+		pairwise_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
+					ciphers_pairwise[0], &wpa_enabled);
+		ret = mwifiex_set_auth(priv, pairwise_encrypt_mode, auth_type,
+								wpa_enabled);
+	}
+
+	if (sme->crypto.cipher_group) {
+		group_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
+						   cipher_group, &wpa_enabled);
+		ret = mwifiex_set_auth(priv, group_encrypt_mode, auth_type,
+								wpa_enabled);
+	}
+	if (sme->ie)
+		ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
+
+	if (sme->key) {
+		alg_is_wep = mwifiex_is_alg_wep(pairwise_encrypt_mode)
+			| mwifiex_is_alg_wep(group_encrypt_mode);
+		if (alg_is_wep) {
+			dev_dbg(priv->adapter->dev,
+				"info: setting wep encryption"
+				" with key len %d\n", sme->key_len);
+			ret = mwifiex_set_encode(priv, sme->key, sme->key_len,
+							sme->key_idx, 0);
+		}
+	}
+done:
+	/* Do specific SSID scanning */
+	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
+		dev_err(priv->adapter->dev, "scan error\n");
+		return -EFAULT;
+	}
+
+
+	memcpy(&ssid_bssid.ssid, &req_ssid, sizeof(struct mwifiex_802_11_ssid));
+
+	if (mode != MWIFIEX_BSS_MODE_IBSS) {
+		if (mwifiex_find_best_bss(priv, MWIFIEX_IOCTL_WAIT,
+					  &ssid_bssid))
+			return -EFAULT;
+		/* Inform the BSS information to kernel, otherwise
+		 * kernel will give a panic after successful assoc */
+		if (mwifiex_inform_bss_from_scan_result(priv, &req_ssid))
+			return -EFAULT;
+	}
+
+	dev_dbg(priv->adapter->dev, "info: trying to associate to %s and bssid %pM\n",
+	       (char *) req_ssid.ssid, ssid_bssid.bssid);
+
+	memcpy(&priv->cfg_bssid, ssid_bssid.bssid, 6);
+
+	/* Connect to BSS by ESSID */
+	memset(&ssid_bssid.bssid, 0, ETH_ALEN);
+
+	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid))
+		return -EFAULT;
+
+	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+		/* Inform the BSS information to kernel, otherwise
+		 * kernel will give a panic after successful assoc */
+		if (mwifiex_cfg80211_inform_ibss_bss(priv))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler for association request.
+ *
+ * This function does not work when the current mode is set to Ad-Hoc, or
+ * when there is already an association procedure going on. The given BSS
+ * information is used to associate.
+ */
+static int
+mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
+			 struct cfg80211_connect_params *sme)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int ret = 0;
+	int mode = 0;
+
+	if (priv->assoc_request)
+		return -EBUSY;
+
+	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
+
+	if (mode == MWIFIEX_BSS_MODE_IBSS) {
+		wiphy_err(wiphy, "received infra assoc request "
+				"when station is in ibss mode\n");
+		goto done;
+	}
+
+	priv->assoc_request = 1;
+
+	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
+	       (char *) sme->ssid, sme->bssid);
+
+	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
+				     mode, sme->channel, sme, 0);
+
+done:
+	priv->assoc_result = ret;
+	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to join an IBSS.
+ *
+ * This function does not work in any mode other than Ad-Hoc, or if
+ * a join operation is already in progress.
+ */
+static int
+mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_ibss_params *params)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+	int ret = 0;
+	int mode = 0;
+
+	if (priv->ibss_join_request)
+		return -EBUSY;
+
+	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
+	if (mode != MWIFIEX_BSS_MODE_IBSS) {
+		wiphy_err(wiphy, "request to join ibss received "
+				"when station is not in ibss mode\n");
+		goto done;
+	}
+
+	priv->ibss_join_request = 1;
+
+	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
+	       (char *) params->ssid, params->bssid);
+
+	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
+				     params->bssid, mode, params->channel, NULL,
+				     params->privacy);
+done:
+	priv->ibss_join_result = ret;
+	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	return ret;
+}
+
+/*
+ * CFG802.11 operation handler to leave an IBSS.
+ *
+ * This function does not work if a leave operation is
+ * already in progress.
+ */
+static int
+mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
+
+	if (priv->disconnect)
+		return -EBUSY;
+
+	priv->disconnect = 1;
+
+	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
+			priv->cfg_bssid);
+	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
+		return -EFAULT;
+
+	queue_work(priv->workqueue, &priv->cfg_workqueue);
+
+	return 0;
+}
+
+/*
+ * CFG802.11 operation handler for scan request.
+ *
+ * This function issues a scan request to the firmware based upon
+ * the user specified scan configuration. On successfull completion,
+ * it also informs the results.
+ */
+static int
+mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
+		      struct cfg80211_scan_request *request)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
+
+	if (priv->scan_request && priv->scan_request != request)
+		return -EBUSY;
+
+	priv->scan_request = request;
+
+	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	return 0;
+}
+
+/*
+ * This function sets up the CFG802.11 specific HT capability fields
+ * with default values.
+ *
+ * The following default values are set -
+ *      - HT Supported = True
+ *      - Maximum AMPDU length factor = 0x3
+ *      - Minimum AMPDU spacing = 0x6
+ *      - HT Capabilities map = IEEE80211_HT_CAP_SUP_WIDTH_20_40 (0x0002)
+ *      - MCS information, Rx mask = 0xff
+ *      - MCD information, Tx parameters = IEEE80211_HT_MCS_TX_DEFINED (0x01)
+ */
+static void
+mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
+		      struct mwifiex_private *priv)
+{
+	int rx_mcs_supp;
+	struct ieee80211_mcs_info mcs_set;
+	u8 *mcs = (u8 *)&mcs_set;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	ht_info->ht_supported = true;
+	ht_info->ampdu_factor = 0x3;
+	ht_info->ampdu_density = 0x6;
+
+	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
+	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+	rx_mcs_supp = GET_RXMCSSUPP(priv->adapter->hw_dev_mcs_support);
+	/* Set MCS for 1x1 */
+	memset(mcs, 0xff, rx_mcs_supp);
+	/* Clear all the other values */
+	memset(&mcs[rx_mcs_supp], 0,
+			sizeof(struct ieee80211_mcs_info) - rx_mcs_supp);
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA ||
+			(ISSUPP_CHANWIDTH40(adapter->hw_dot_11n_dev_cap) &&
+			 ISSUPP_CHANWIDTH40(adapter->usr_dot_11n_dev_cap)))
+		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
+		SETHT_MCS32(mcs_set.rx_mask);
+
+	memcpy((u8 *) &ht_info->mcs, mcs, sizeof(struct ieee80211_mcs_info));
+
+	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+}
+
+/* station cfg80211 operations */
+static struct cfg80211_ops mwifiex_cfg80211_ops = {
+	.change_virtual_intf = mwifiex_cfg80211_change_virtual_intf,
+	.scan = mwifiex_cfg80211_scan,
+	.connect = mwifiex_cfg80211_connect,
+	.disconnect = mwifiex_cfg80211_disconnect,
+	.get_station = mwifiex_cfg80211_get_station,
+	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
+	.set_channel = mwifiex_cfg80211_set_channel,
+	.join_ibss = mwifiex_cfg80211_join_ibss,
+	.leave_ibss = mwifiex_cfg80211_leave_ibss,
+	.add_key = mwifiex_cfg80211_add_key,
+	.del_key = mwifiex_cfg80211_del_key,
+	.set_default_key = mwifiex_cfg80211_set_default_key,
+	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
+	.set_tx_power = mwifiex_cfg80211_set_tx_power,
+};
+
+/*
+ * This function registers the device with CFG802.11 subsystem.
+ *
+ * The function creates the wireless device/wiphy, populates it with
+ * default parameters and handler function pointers, and finally
+ * registers the device.
+ */
+int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
+			      struct mwifiex_private *priv)
+{
+	int ret = 0;
+	void *wdev_priv = NULL;
+	struct wireless_dev *wdev;
+
+	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	if (!wdev) {
+		dev_err(priv->adapter->dev, "%s: allocating wireless device\n",
+						__func__);
+		return -ENOMEM;
+	}
+	wdev->wiphy =
+		wiphy_new(&mwifiex_cfg80211_ops,
+			  sizeof(struct mwifiex_private *));
+	if (!wdev->wiphy)
+		return -ENOMEM;
+	wdev->iftype = NL80211_IFTYPE_STATION;
+	wdev->wiphy->max_scan_ssids = 10;
+	wdev->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
+	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
+	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
+
+	/* Initialize cipher suits */
+	wdev->wiphy->cipher_suites = mwifiex_cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
+
+	/* Initialize parameters for 2GHz band */
+
+	mwifiex_setup_ht_caps(&wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap,
+									priv);
+	mwifiex_setup_ht_caps(&wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap,
+									priv);
+
+	memcpy(wdev->wiphy->perm_addr, mac, 6);
+	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+
+	/* We are using custom domains */
+	wdev->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+
+	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
+
+	/* Set struct mwifiex_private pointer in wiphy_priv */
+	wdev_priv = wiphy_priv(wdev->wiphy);
+
+	*(unsigned long *) wdev_priv = (unsigned long) priv;
+
+	ret = wiphy_register(wdev->wiphy);
+	if (ret < 0) {
+		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
+						__func__);
+		wiphy_free(wdev->wiphy);
+		return ret;
+	} else {
+		dev_dbg(priv->adapter->dev,
+				"info: successfully registered wiphy device\n");
+	}
+
+	dev_net_set(dev, wiphy_net(wdev->wiphy));
+	dev->ieee80211_ptr = wdev;
+	memcpy(dev->dev_addr, wdev->wiphy->perm_addr, 6);
+	memcpy(dev->perm_addr, wdev->wiphy->perm_addr, 6);
+	SET_NETDEV_DEV(dev, wiphy_dev(wdev->wiphy));
+	priv->wdev = wdev;
+
+	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
+	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
+
+	return ret;
+}
+
+/*
+ * This function handles the result of different pending network operations.
+ *
+ * The following operations are handled and CFG802.11 subsystem is
+ * notified accordingly -
+ *      - Scan request completion
+ *      - Association request completion
+ *      - IBSS join request completion
+ *      - Disconnect request completion
+ */
+void
+mwifiex_cfg80211_results(struct work_struct *work)
+{
+	struct mwifiex_private *priv =
+		container_of(work, struct mwifiex_private, cfg_workqueue);
+	struct mwifiex_user_scan_cfg *scan_req;
+	int ret = 0, i;
+	struct ieee80211_channel *chan;
+
+	if (priv->scan_request) {
+		scan_req = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
+				   GFP_KERNEL);
+		if (!scan_req) {
+			dev_err(priv->adapter->dev, "failed to alloc "
+						    "scan_req\n");
+			return;
+		}
+		for (i = 0; i < priv->scan_request->n_ssids; i++) {
+			memcpy(scan_req->ssid_list[i].ssid,
+					priv->scan_request->ssids[i].ssid,
+					priv->scan_request->ssids[i].ssid_len);
+			scan_req->ssid_list[i].max_len =
+					priv->scan_request->ssids[i].ssid_len;
+		}
+		for (i = 0; i < priv->scan_request->n_channels; i++) {
+			chan = priv->scan_request->channels[i];
+			scan_req->chan_list[i].chan_number = chan->hw_value;
+			scan_req->chan_list[i].radio_type = chan->band;
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				scan_req->chan_list[i].scan_type =
+					MWIFIEX_SCAN_TYPE_PASSIVE;
+			else
+				scan_req->chan_list[i].scan_type =
+					MWIFIEX_SCAN_TYPE_ACTIVE;
+			scan_req->chan_list[i].scan_time = 0;
+		}
+		if (mwifiex_set_user_scan_ioctl(priv, scan_req)) {
+			ret = -EFAULT;
+			goto done;
+		}
+		if (mwifiex_inform_bss_from_scan_result(priv, NULL))
+			ret = -EFAULT;
+done:
+		priv->scan_result_status = ret;
+		dev_dbg(priv->adapter->dev, "info: %s: sending scan results\n",
+							__func__);
+		cfg80211_scan_done(priv->scan_request,
+				(priv->scan_result_status < 0));
+		priv->scan_request = NULL;
+		kfree(scan_req);
+	}
+
+	if (priv->assoc_request) {
+		if (!priv->assoc_result) {
+			cfg80211_connect_result(priv->netdev, priv->cfg_bssid,
+						NULL, 0, NULL, 0,
+						WLAN_STATUS_SUCCESS,
+						GFP_KERNEL);
+			dev_dbg(priv->adapter->dev,
+				"info: associated to bssid %pM successfully\n",
+			       priv->cfg_bssid);
+		} else {
+			dev_dbg(priv->adapter->dev,
+				"info: association to bssid %pM failed\n",
+			       priv->cfg_bssid);
+			memset(priv->cfg_bssid, 0, ETH_ALEN);
+		}
+		priv->assoc_request = 0;
+		priv->assoc_result = 0;
+	}
+
+	if (priv->ibss_join_request) {
+		if (!priv->ibss_join_result) {
+			cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
+					     GFP_KERNEL);
+			dev_dbg(priv->adapter->dev,
+				"info: joined/created adhoc network with bssid"
+					" %pM successfully\n", priv->cfg_bssid);
+		} else {
+			dev_dbg(priv->adapter->dev,
+				"info: failed creating/joining adhoc network\n");
+		}
+		priv->ibss_join_request = 0;
+		priv->ibss_join_result = 0;
+	}
+
+	if (priv->disconnect) {
+		memset(priv->cfg_bssid, 0, ETH_ALEN);
+		priv->disconnect = 0;
+	}
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
new file mode 100644
index 0000000..c4db8f3
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -0,0 +1,31 @@
+/*
+ * Marvell Wireless LAN device driver: CFG80211
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef __MWIFIEX_CFG80211__
+#define __MWIFIEX_CFG80211__
+
+#include <net/cfg80211.h>
+
+#include "main.h"
+
+int mwifiex_register_cfg80211(struct net_device *, u8 *,
+				struct mwifiex_private *);
+
+void mwifiex_cfg80211_results(struct work_struct *work);
+#endif
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
new file mode 100644
index 0000000..999ed81
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -0,0 +1,368 @@
+/*
+ * Marvell Wireless LAN device driver: Channel, Frequence and Power
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "cfg80211.h"
+
+/* 100mW */
+#define MWIFIEX_TX_PWR_DEFAULT     20
+/* 100mW */
+#define MWIFIEX_TX_PWR_US_DEFAULT      20
+/* 50mW */
+#define MWIFIEX_TX_PWR_JP_DEFAULT      16
+/* 100mW */
+#define MWIFIEX_TX_PWR_FR_100MW        20
+/* 10mW */
+#define MWIFIEX_TX_PWR_FR_10MW         10
+/* 100mW */
+#define MWIFIEX_TX_PWR_EMEA_DEFAULT    20
+
+static u8 adhoc_rates_b[B_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96, 0 };
+
+static u8 adhoc_rates_g[G_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
+					       0xb0, 0x48, 0x60, 0x6c, 0 };
+
+static u8 adhoc_rates_bg[BG_SUPPORTED_RATES] = { 0x82, 0x84, 0x8b, 0x96,
+						 0x0c, 0x12, 0x18, 0x24,
+						 0x30, 0x48, 0x60, 0x6c, 0 };
+
+static u8 adhoc_rates_a[A_SUPPORTED_RATES] = { 0x8c, 0x12, 0x98, 0x24,
+					       0xb0, 0x48, 0x60, 0x6c, 0 };
+u8 supported_rates_a[A_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
+					0xb0, 0x48, 0x60, 0x6c, 0 };
+static u16 mwifiex_data_rates[MWIFIEX_SUPPORTED_RATES_EXT] = { 0x02, 0x04,
+					0x0B, 0x16, 0x00, 0x0C, 0x12, 0x18,
+					0x24, 0x30, 0x48, 0x60, 0x6C, 0x90,
+					0x0D, 0x1A, 0x27, 0x34, 0x4E, 0x68,
+					0x75, 0x82, 0x0C, 0x1B, 0x36, 0x51,
+					0x6C, 0xA2, 0xD8, 0xF3, 0x10E, 0x00 };
+
+u8 supported_rates_b[B_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x16, 0 };
+
+u8 supported_rates_g[G_SUPPORTED_RATES] = { 0x0c, 0x12, 0x18, 0x24,
+					0x30, 0x48, 0x60, 0x6c, 0 };
+
+u8 supported_rates_bg[BG_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x0c,
+					0x12, 0x16, 0x18, 0x24, 0x30, 0x48,
+					0x60, 0x6c, 0 };
+
+u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x10, 0x20, 0x30,
+						0x32, 0x40, 0x41, 0xff };
+
+u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
+
+/*
+ * This function maps an index in supported rates table into
+ * the corresponding data rate.
+ */
+u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
+			       u8 ht_info)
+{
+	u16 mcs_rate[4][8] = {
+		{0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e}
+	,			/* LG 40M */
+	{0x1e, 0x3c, 0x5a, 0x78, 0xb4, 0xf0, 0x10e, 0x12c}
+	,			/* SG 40M */
+	{0x0d, 0x1a, 0x27, 0x34, 0x4e, 0x68, 0x75, 0x82}
+	,			/* LG 20M */
+	{0x0e, 0x1c, 0x2b, 0x39, 0x56, 0x73, 0x82, 0x90}
+	};			/* SG 20M */
+
+	u32 rate;
+
+	if (ht_info & BIT(0)) {
+		if (index == MWIFIEX_RATE_BITMAP_MCS0) {
+			if (ht_info & BIT(2))
+				rate = 0x0D;	/* MCS 32 SGI rate */
+			else
+				rate = 0x0C;	/* MCS 32 LGI rate */
+		} else if (index < 8) {
+			if (ht_info & BIT(1)) {
+				if (ht_info & BIT(2))
+					/* SGI, 40M */
+					rate = mcs_rate[1][index];
+				else
+					/* LGI, 40M */
+					rate = mcs_rate[0][index];
+			} else {
+				if (ht_info & BIT(2))
+					/* SGI, 20M */
+					rate = mcs_rate[3][index];
+				else
+					/* LGI, 20M */
+					rate = mcs_rate[2][index];
+			}
+		} else
+			rate = mwifiex_data_rates[0];
+	} else {
+		if (index >= MWIFIEX_SUPPORTED_RATES_EXT)
+			index = 0;
+		rate = mwifiex_data_rates[index];
+	}
+	return rate;
+}
+
+/*
+ * This function maps a data rate value into corresponding index in supported
+ * rates table.
+ */
+u8 mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
+{
+	u16 *ptr;
+
+	if (rate) {
+		ptr = memchr(mwifiex_data_rates, rate,
+				sizeof(mwifiex_data_rates));
+		if (ptr)
+			return (u8) (ptr - mwifiex_data_rates);
+	}
+	return 0;
+}
+
+/*
+ * This function returns the current active data rates.
+ *
+ * The result may vary depending upon connection status.
+ */
+u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
+{
+	u32 k;
+
+	if (!priv->media_connected)
+		k = mwifiex_get_supported_rates(priv, rates);
+	else
+		k = mwifiex_copy_rates(rates, 0,
+				       priv->curr_bss_params.data_rates,
+				       priv->curr_bss_params.num_of_rates);
+
+	return k;
+}
+
+/*
+ * This function locates the Channel-Frequency-Power triplet based upon
+ * band and channel parameters.
+ */
+struct mwifiex_chan_freq_power *
+mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
+						  *priv, u8 band, u16 channel)
+{
+	struct mwifiex_chan_freq_power *cfp = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	int i;
+
+	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
+		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	if (!sband) {
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & channel %d\n", __func__, band, channel);
+		return cfp;
+	}
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		if (((ch->hw_value == channel) ||
+			(channel == FIRST_VALID_CHANNEL))
+			&& !(ch->flags & IEEE80211_CHAN_DISABLED)) {
+			priv->cfp.channel = channel;
+			priv->cfp.freq = ch->center_freq;
+			priv->cfp.max_tx_power = ch->max_power;
+			cfp = &priv->cfp;
+			break;
+		}
+	}
+	if (i == sband->n_channels)
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & channel %d\n", __func__, band, channel);
+
+	return cfp;
+}
+
+/*
+ * This function locates the Channel-Frequency-Power triplet based upon
+ * band and frequency parameters.
+ */
+struct mwifiex_chan_freq_power *
+mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
+					       u8 band, u32 freq)
+{
+	struct mwifiex_chan_freq_power *cfp = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	int i;
+
+	if (mwifiex_band_to_radio_type(band) == HostCmd_SCAN_RADIO_TYPE_BG)
+		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
+	else
+		sband = priv->wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	if (!sband) {
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & freq %d\n", __func__, band, freq);
+		return cfp;
+	}
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+		if ((ch->center_freq == freq) &&
+			!(ch->flags & IEEE80211_CHAN_DISABLED)) {
+			priv->cfp.channel = ch->hw_value;
+			priv->cfp.freq = freq;
+			priv->cfp.max_tx_power = ch->max_power;
+			cfp = &priv->cfp;
+			break;
+		}
+	}
+	if (i == sband->n_channels)
+		dev_err(priv->adapter->dev, "%s: cannot find cfp by band %d"
+				" & freq %d\n", __func__, band, freq);
+
+	return cfp;
+}
+
+/*
+ * This function checks if the data rate is set to auto.
+ */
+u8
+mwifiex_is_rate_auto(struct mwifiex_private *priv)
+{
+	u32 i;
+	int rate_num = 0;
+
+	for (i = 0; i < ARRAY_SIZE(priv->bitmap_rates); i++)
+		if (priv->bitmap_rates[i])
+			rate_num++;
+
+	if (rate_num > 1)
+		return true;
+	else
+		return false;
+}
+
+/*
+ * This function converts rate bitmap into rate index.
+ */
+int
+mwifiex_get_rate_index(struct mwifiex_adapter *adapter, u16 *rate_bitmap,
+		       int size)
+{
+	int i;
+
+	for (i = 0; i < size * 8; i++)
+		if (rate_bitmap[i / 16] & (1 << (i % 16)))
+			return i;
+
+	return 0;
+}
+
+/*
+ * This function gets the supported data rates.
+ *
+ * The function works in both Ad-Hoc and infra mode by printing the
+ * band and returning the data rates.
+ */
+u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
+{
+	u32 k = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+		/* Infra. mode */
+		switch (adapter->config_bands) {
+		case BAND_B:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_b\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_b,
+					       sizeof(supported_rates_b));
+			break;
+		case BAND_G:
+		case BAND_G | BAND_GN:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_g\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_g,
+					       sizeof(supported_rates_g));
+			break;
+		case BAND_B | BAND_G:
+		case BAND_A | BAND_B | BAND_G:
+		case BAND_A | BAND_B:
+		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN:
+		case BAND_B | BAND_G | BAND_GN:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_bg\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_bg,
+					       sizeof(supported_rates_bg));
+			break;
+		case BAND_A:
+		case BAND_A | BAND_G:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_a\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_a,
+					       sizeof(supported_rates_a));
+			break;
+		case BAND_A | BAND_AN:
+		case BAND_A | BAND_G | BAND_AN | BAND_GN:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_a\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_a,
+					       sizeof(supported_rates_a));
+			break;
+		case BAND_GN:
+			dev_dbg(adapter->dev, "info: infra band=%d "
+				"supported_rates_n\n", adapter->config_bands);
+			k = mwifiex_copy_rates(rates, k, supported_rates_n,
+					       sizeof(supported_rates_n));
+			break;
+		}
+	} else {
+		/* Ad-hoc mode */
+		switch (adapter->adhoc_start_band) {
+		case BAND_B:
+			dev_dbg(adapter->dev, "info: adhoc B\n");
+			k = mwifiex_copy_rates(rates, k, adhoc_rates_b,
+					       sizeof(adhoc_rates_b));
+			break;
+		case BAND_G:
+		case BAND_G | BAND_GN:
+			dev_dbg(adapter->dev, "info: adhoc G only\n");
+			k = mwifiex_copy_rates(rates, k, adhoc_rates_g,
+					       sizeof(adhoc_rates_g));
+			break;
+		case BAND_B | BAND_G:
+		case BAND_B | BAND_G | BAND_GN:
+			dev_dbg(adapter->dev, "info: adhoc BG\n");
+			k = mwifiex_copy_rates(rates, k, adhoc_rates_bg,
+					       sizeof(adhoc_rates_bg));
+			break;
+		case BAND_A:
+		case BAND_A | BAND_AN:
+			dev_dbg(adapter->dev, "info: adhoc A\n");
+			k = mwifiex_copy_rates(rates, k, adhoc_rates_a,
+					       sizeof(adhoc_rates_a));
+			break;
+		}
+	}
+
+	return k;
+}
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
new file mode 100644
index 0000000..3a8fe1e
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -0,0 +1,1463 @@
+/*
+ * Marvell Wireless LAN device driver: commands and events
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * This function initializes a command node.
+ *
+ * The actual allocation of the node is not done by this function. It only
+ * initiates a node by filling it with default parameters. Similarly,
+ * allocation of the different buffers used (IOCTL buffer, data buffer) are
+ * not done by this function either.
+ */
+static void
+mwifiex_init_cmd_node(struct mwifiex_private *priv,
+		      struct cmd_ctrl_node *cmd_node,
+		      u32 cmd_oid, void *wait_queue, void *data_buf)
+{
+	cmd_node->priv = priv;
+	cmd_node->cmd_oid = cmd_oid;
+	cmd_node->wq_buf = wait_queue;
+	cmd_node->data_buf = data_buf;
+	cmd_node->cmd_skb = cmd_node->skb;
+}
+
+/*
+ * This function returns a command node from the free queue depending upon
+ * availability.
+ */
+static struct cmd_ctrl_node *
+mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
+{
+	struct cmd_ctrl_node *cmd_node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
+	if (list_empty(&adapter->cmd_free_q)) {
+		dev_err(adapter->dev, "GET_CMD_NODE: cmd node not available\n");
+		spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+		return NULL;
+	}
+	cmd_node = list_first_entry(&adapter->cmd_free_q,
+			struct cmd_ctrl_node, list);
+	list_del(&cmd_node->list);
+	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+
+	return cmd_node;
+}
+
+/*
+ * This function cleans up a command node.
+ *
+ * The function resets the fields including the buffer pointers.
+ * This function does not try to free the buffers. They must be
+ * freed before calling this function.
+ *
+ * This function will however call the receive completion callback
+ * in case a response buffer is still available before resetting
+ * the pointer.
+ */
+static void
+mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
+		       struct cmd_ctrl_node *cmd_node)
+{
+	cmd_node->cmd_oid = 0;
+	cmd_node->cmd_flag = 0;
+	cmd_node->wq_buf = NULL;
+	cmd_node->data_buf = NULL;
+
+	if (cmd_node->resp_skb) {
+		mwifiex_recv_complete(adapter, cmd_node->resp_skb, 0);
+		cmd_node->resp_skb = NULL;
+	}
+
+	return;
+}
+
+/*
+ * This function returns a command node from the pending queue which
+ * matches the given IOCTL request.
+ */
+static struct cmd_ctrl_node *
+mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
+			      struct mwifiex_wait_queue *wait_queue)
+{
+	unsigned long flags;
+	struct cmd_ctrl_node *cmd_node;
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
+		if (cmd_node->wq_buf == wait_queue) {
+			spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+					       flags);
+			return cmd_node;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+	return NULL;
+}
+
+/*
+ * This function sends a host command to the firmware.
+ *
+ * The function copies the host command into the driver command
+ * buffer, which will be transferred to the firmware later by the
+ * main thread.
+ */
+static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	struct mwifiex_ds_misc_cmd *pcmd_ptr =
+		(struct mwifiex_ds_misc_cmd *) data_buf;
+
+	/* Copy the HOST command to command buffer */
+	memcpy((void *) cmd, pcmd_ptr->cmd, pcmd_ptr->len);
+	dev_dbg(priv->adapter->dev, "cmd: host cmd size = %d\n", pcmd_ptr->len);
+	return 0;
+}
+
+/*
+ * This function downloads a command to the firmware.
+ *
+ * The function performs sanity tests, sets the command sequence
+ * number and size, converts the header fields to CPU format before
+ * sending. Afterwards, it logs the command ID and action for debugging
+ * and sets up the command timeout timer.
+ */
+static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
+				  struct cmd_ctrl_node *cmd_node)
+{
+
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = 0;
+	struct host_cmd_ds_command *host_cmd;
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	uint16_t cmd_code;
+	uint16_t cmd_size;
+	struct timeval tstamp;
+	unsigned long flags;
+
+	if (!adapter || !cmd_node)
+		return -1;
+
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
+	if (cmd_node->wq_buf)
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
+
+	/* Sanity test */
+	if (host_cmd == NULL || host_cmd->size == 0) {
+		dev_err(adapter->dev, "DNLD_CMD: host_cmd is null"
+			" or cmd size is 0, not sending\n");
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		return -1;
+	}
+
+	/* Set command sequence number */
+	adapter->seq_num++;
+	host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
+			    (adapter->seq_num, cmd_node->priv->bss_num,
+			     cmd_node->priv->bss_type));
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->curr_cmd = cmd_node;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+	cmd_code = le16_to_cpu(host_cmd->command);
+	cmd_size = le16_to_cpu(host_cmd->size);
+
+	skb_trim(cmd_node->cmd_skb, cmd_size);
+
+	do_gettimeofday(&tstamp);
+	dev_dbg(adapter->dev, "cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d,"
+		" seqno %#x\n",
+		tstamp.tv_sec, tstamp.tv_usec, cmd_code,
+	       le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
+	       le16_to_cpu(host_cmd->seq_num));
+
+	skb_push(cmd_node->cmd_skb, INTF_HEADER_LEN);
+
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
+					     cmd_node->cmd_skb->data,
+					     cmd_node->cmd_skb->len, NULL);
+
+	if (ret == -1) {
+		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->curr_cmd = NULL;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+		adapter->dbg.num_cmd_host_to_card_failure++;
+		return -1;
+	}
+
+	/* Save the last command id and action to debug log */
+	adapter->dbg.last_cmd_index =
+		(adapter->dbg.last_cmd_index + 1) % DBG_CMD_NUM;
+	adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index] = cmd_code;
+	adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index] =
+		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN));
+
+	/* Clear BSS_NO_BITS from HostCmd */
+	cmd_code &= HostCmd_CMD_ID_MASK;
+
+	/* Setup the timer after transmit command */
+	mod_timer(&adapter->cmd_timer,
+		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
+
+	return 0;
+}
+
+/*
+ * This function downloads a sleep confirm command to the firmware.
+ *
+ * The function performs sanity tests, sets the command sequence
+ * number and size, converts the header fields to CPU format before
+ * sending.
+ *
+ * No responses are needed for sleep confirm command.
+ */
+static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	u16 cmd_len = 0;
+	struct mwifiex_private *priv;
+	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf =
+				(struct mwifiex_opt_sleep_confirm_buffer *)
+				adapter->sleep_cfm->data;
+	cmd_len = sizeof(struct mwifiex_opt_sleep_confirm);
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
+	sleep_cfm_buf->ps_cfm_sleep.seq_num =
+		cpu_to_le16((HostCmd_SET_SEQ_NO_BSS_INFO
+					(adapter->seq_num, priv->bss_num,
+					 priv->bss_type)));
+	adapter->seq_num++;
+
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_CMD,
+					     adapter->sleep_cfm->data,
+					     adapter->sleep_cfm->len +
+					     INTF_HEADER_LEN, NULL);
+
+	if (ret == -1) {
+		dev_err(adapter->dev, "SLEEP_CFM: failed\n");
+		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
+		return -1;
+	}
+	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
+			== MWIFIEX_BSS_ROLE_STA) {
+		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl)
+			/* Response is not needed for sleep
+			   confirm command */
+			adapter->ps_state = PS_STATE_SLEEP;
+		else
+			adapter->ps_state = PS_STATE_SLEEP_CFM;
+
+		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl
+				&& (adapter->is_hs_configured
+					&& !adapter->sleep_period.period)) {
+			adapter->pm_wakeup_card_req = true;
+			mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+						MWIFIEX_BSS_ROLE_STA), true);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function allocates the command buffers and links them to
+ * the command free queue.
+ *
+ * The driver uses a pre allocated number of command buffers, which
+ * are created at driver initializations and freed at driver cleanup.
+ * Every command needs to obtain a command buffer from this pool before
+ * it can be issued. The command free queue lists the command buffers
+ * currently free to use, while the command pending queue lists the
+ * command buffers already in use and awaiting handling. Command buffers
+ * are returned to the free queue after use.
+ */
+int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
+{
+	struct cmd_ctrl_node *cmd_array;
+	u32 buf_size;
+	u32 i;
+
+	/* Allocate and initialize struct cmd_ctrl_node */
+	buf_size = sizeof(struct cmd_ctrl_node) * MWIFIEX_NUM_OF_CMD_BUFFER;
+	cmd_array = kzalloc(buf_size, GFP_KERNEL);
+	if (!cmd_array) {
+		dev_err(adapter->dev, "%s: failed to alloc cmd_array\n",
+				__func__);
+		return -1;
+	}
+
+	adapter->cmd_pool = cmd_array;
+	memset(adapter->cmd_pool, 0, buf_size);
+
+	/* Allocate and initialize command buffers */
+	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
+		cmd_array[i].skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
+		if (!cmd_array[i].skb) {
+			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
+			return -1;
+		}
+	}
+
+	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++)
+		mwifiex_insert_cmd_to_free_q(adapter, &cmd_array[i]);
+
+	return 0;
+}
+
+/*
+ * This function frees the command buffers.
+ *
+ * The function calls the completion callback for all the command
+ * buffers that still have response buffers associated with them.
+ */
+int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
+{
+	struct cmd_ctrl_node *cmd_array;
+	u32 i;
+
+	/* Need to check if cmd pool is allocated or not */
+	if (!adapter->cmd_pool) {
+		dev_dbg(adapter->dev, "info: FREE_CMD_BUF: cmd_pool is null\n");
+		return 0;
+	}
+
+	cmd_array = adapter->cmd_pool;
+
+	/* Release shared memory buffers */
+	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
+		if (cmd_array[i].skb) {
+			dev_dbg(adapter->dev, "cmd: free cmd buffer %d\n", i);
+			dev_kfree_skb_any(cmd_array[i].skb);
+		}
+		if (!cmd_array[i].resp_skb)
+			continue;
+		mwifiex_recv_complete(adapter, cmd_array[i].resp_skb, 0);
+	}
+	/* Release struct cmd_ctrl_node */
+	if (adapter->cmd_pool) {
+		dev_dbg(adapter->dev, "cmd: free cmd pool\n");
+		kfree(adapter->cmd_pool);
+		adapter->cmd_pool = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles events generated by firmware.
+ *
+ * Event body of events received from firmware are not used (though they are
+ * saved), only the event ID is used. Some events are re-invoked by
+ * the driver, with a new event body.
+ *
+ * After processing, the function calls the completion callback
+ * for cleanup.
+ */
+int mwifiex_process_event(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	struct mwifiex_private *priv =
+		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	struct sk_buff *skb = adapter->event_skb;
+	u32 eventcause = adapter->event_cause;
+	struct timeval tstamp;
+	struct mwifiex_rxinfo *rx_info = NULL;
+
+	/* Save the last event to debug log */
+	adapter->dbg.last_event_index =
+		(adapter->dbg.last_event_index + 1) % DBG_CMD_NUM;
+	adapter->dbg.last_event[adapter->dbg.last_event_index] =
+		(u16) eventcause;
+
+	/* Get BSS number and corresponding priv */
+	priv = mwifiex_get_priv_by_id(adapter, EVENT_GET_BSS_NUM(eventcause),
+				      EVENT_GET_BSS_TYPE(eventcause));
+	if (!priv)
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	/* Clear BSS_NO_BITS from event */
+	eventcause &= EVENT_ID_MASK;
+	adapter->event_cause = eventcause;
+
+	if (skb) {
+		rx_info = MWIFIEX_SKB_RXCB(skb);
+		rx_info->bss_index = priv->bss_index;
+	}
+
+	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
+		do_gettimeofday(&tstamp);
+		dev_dbg(adapter->dev, "event: %lu.%lu: cause: %#x\n",
+		       tstamp.tv_sec, tstamp.tv_usec, eventcause);
+	}
+
+	ret = mwifiex_process_sta_event(priv);
+
+	adapter->event_cause = 0;
+	adapter->event_skb = NULL;
+
+	mwifiex_recv_complete(adapter, skb, 0);
+
+	return ret;
+}
+
+/*
+ * This function prepares a command before sending it to the firmware.
+ *
+ * Preparation includes -
+ *      - Sanity tests to make sure the card is still present or the FW
+ *        is not reset
+ *      - Getting a new command node from the command free queue
+ *      - Initializing the command node for default parameters
+ *      - Fill up the non-default parameters and buffer pointers
+ *      - Add the command to pending queue
+ */
+int mwifiex_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			u16 cmd_action, u32 cmd_oid,
+			void *wait_queue, void *data_buf)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmd_node = NULL;
+	struct host_cmd_ds_command *cmd_ptr = NULL;
+
+	if (!adapter) {
+		pr_err("PREP_CMD: adapter is NULL\n");
+		return -1;
+	}
+
+	if (adapter->is_suspended) {
+		dev_err(adapter->dev, "PREP_CMD: device in suspended state\n");
+		return -1;
+	}
+
+	if (adapter->surprise_removed) {
+		dev_err(adapter->dev, "PREP_CMD: card is removed\n");
+		return -1;
+	}
+
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
+		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
+			dev_err(adapter->dev, "PREP_CMD: FW in reset state\n");
+			return -1;
+		}
+	}
+
+	/* Get a new command node */
+	cmd_node = mwifiex_get_cmd_node(adapter);
+
+	if (!cmd_node) {
+		dev_err(adapter->dev, "PREP_CMD: no free cmd node\n");
+		return -1;
+	}
+
+	/* Initialize the command node */
+	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, wait_queue, data_buf);
+
+	if (!cmd_node->cmd_skb) {
+		dev_err(adapter->dev, "PREP_CMD: no free cmd buf\n");
+		return -1;
+	}
+
+	memset(skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command)),
+	       0, sizeof(struct host_cmd_ds_command));
+
+	cmd_ptr = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
+	cmd_ptr->command = cpu_to_le16(cmd_no);
+	cmd_ptr->result = 0;
+
+	/* Prepare command */
+	if (cmd_no) {
+		ret = mwifiex_sta_prepare_cmd(priv, cmd_no, cmd_action,
+					      cmd_oid, data_buf, cmd_ptr);
+	} else {
+		ret = mwifiex_cmd_host_cmd(priv, cmd_ptr, data_buf);
+		cmd_node->cmd_flag |= CMD_F_HOSTCMD;
+	}
+
+	/* Return error, since the command preparation failed */
+	if (ret) {
+		dev_err(adapter->dev, "PREP_CMD: cmd %#x preparation failed\n",
+							cmd_no);
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		return -1;
+	}
+
+	/* Send command */
+	if (cmd_no == HostCmd_CMD_802_11_SCAN)
+		mwifiex_queue_scan_cmd(priv, cmd_node);
+	else
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+
+	return ret;
+}
+
+/*
+ * This function returns a command to the command free queue.
+ *
+ * The function also calls the completion callback if required, before
+ * cleaning the command node and re-inserting it into the free queue.
+ */
+void
+mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
+			     struct cmd_ctrl_node *cmd_node)
+{
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	unsigned long flags;
+
+	if (cmd_node == NULL)
+		return;
+	if (cmd_node->wq_buf) {
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
+		if (wait_queue->status != MWIFIEX_ERROR_NO_ERROR)
+			mwifiex_ioctl_complete(adapter, wait_queue, -1);
+		else
+			mwifiex_ioctl_complete(adapter, wait_queue, 0);
+	}
+	/* Clean the node */
+	mwifiex_clean_cmd_node(adapter, cmd_node);
+
+	/* Insert node into cmd_free_q */
+	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
+	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
+	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+
+	return;
+}
+
+/*
+ * This function queues a command to the command pending queue.
+ *
+ * This in effect adds the command to the command list to be executed.
+ * Exit PS command is handled specially, by placing it always to the
+ * front of the command queue.
+ */
+void
+mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
+				struct cmd_ctrl_node *cmd_node, u32 add_tail)
+{
+	struct host_cmd_ds_command *host_cmd = NULL;
+	u16 command;
+	unsigned long flags;
+
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
+	if (!host_cmd) {
+		dev_err(adapter->dev, "QUEUE_CMD: host_cmd is NULL\n");
+		return;
+	}
+
+	command = le16_to_cpu(host_cmd->command);
+
+	/* Exit_PS command needs to be queued in the header always. */
+	if (command == HostCmd_CMD_802_11_PS_MODE_ENH) {
+		struct host_cmd_ds_802_11_ps_mode_enh *pm =
+			&host_cmd->params.psmode_enh;
+		if ((le16_to_cpu(pm->action) == DIS_PS)
+		    || (le16_to_cpu(pm->action) == DIS_AUTO_PS)) {
+			if (adapter->ps_state != PS_STATE_AWAKE)
+				add_tail = false;
+		}
+	}
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	if (add_tail)
+		list_add_tail(&cmd_node->list, &adapter->cmd_pending_q);
+	else
+		list_add(&cmd_node->list, &adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x is queued\n", command);
+
+	return;
+}
+
+/*
+ * This function executes the next command in command pending queue.
+ *
+ * This function will fail if a command is already in processing stage,
+ * otherwise it will dequeue the first command from the command pending
+ * queue and send to the firmware.
+ *
+ * If the device is currently in host sleep mode, any commands, except the
+ * host sleep configuration command will de-activate the host sleep. For PS
+ * mode, the function will put the firmware back to sleep if applicable.
+ */
+int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL;
+	int ret = 0;
+	struct host_cmd_ds_command *host_cmd;
+	unsigned long cmd_flags;
+	unsigned long cmd_pending_q_flags;
+
+	/* Check if already in processing */
+	if (adapter->curr_cmd) {
+		dev_err(adapter->dev, "EXEC_NEXT_CMD: cmd in processing\n");
+		return -1;
+	}
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+	/* Check if any command is pending */
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
+	if (list_empty(&adapter->cmd_pending_q)) {
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+				       cmd_pending_q_flags);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		return 0;
+	}
+	cmd_node = list_first_entry(&adapter->cmd_pending_q,
+				    struct cmd_ctrl_node, list);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+			       cmd_pending_q_flags);
+
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
+	priv = cmd_node->priv;
+
+	if (adapter->ps_state != PS_STATE_AWAKE) {
+		dev_err(adapter->dev, "%s: cannot send cmd in sleep state,"
+				" this should not happen\n", __func__);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		return ret;
+	}
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
+	list_del(&cmd_node->list);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+			       cmd_pending_q_flags);
+
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+	ret = mwifiex_dnld_cmd_to_fw(priv, cmd_node);
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	/* Any command sent to the firmware when host is in sleep
+	 * mode should de-configure host sleep. We should skip the
+	 * host sleep configuration command itself though
+	 */
+	if (priv && (host_cmd->command !=
+	     cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH))) {
+		if (adapter->hs_activated) {
+			adapter->is_hs_configured = false;
+			mwifiex_hs_activated_event(priv, false);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function handles the command response.
+ *
+ * After processing, the function cleans the command node and puts
+ * it back to the command free queue.
+ */
+int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
+{
+	struct host_cmd_ds_command *resp = NULL;
+	struct mwifiex_private *priv =
+		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	int ret = 0;
+	uint16_t orig_cmdresp_no;
+	uint16_t cmdresp_no;
+	uint16_t cmdresp_result;
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	struct timeval tstamp;
+	unsigned long flags;
+
+	/* Now we got response from FW, cancel the command timer */
+	del_timer(&adapter->cmd_timer);
+
+	if (!adapter->curr_cmd || !adapter->curr_cmd->resp_skb) {
+		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
+		dev_err(adapter->dev, "CMD_RESP: NULL curr_cmd, %#x\n",
+		       le16_to_cpu(resp->command));
+		return -1;
+	}
+
+	if (adapter->curr_cmd->wq_buf)
+		wait_queue = (struct mwifiex_wait_queue *)
+				adapter->curr_cmd->wq_buf;
+
+	adapter->num_cmd_timeout = 0;
+
+	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
+	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
+		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
+				le16_to_cpu(resp->command));
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->curr_cmd = NULL;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		return -1;
+	}
+
+	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
+		/* Copy original response back to response buffer */
+		struct mwifiex_ds_misc_cmd *hostcmd = NULL;
+		uint16_t size = le16_to_cpu(resp->size);
+		dev_dbg(adapter->dev, "info: host cmd resp size = %d\n", size);
+		size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
+		if (adapter->curr_cmd->data_buf) {
+			hostcmd = (struct mwifiex_ds_misc_cmd *)
+						adapter->curr_cmd->data_buf;
+			hostcmd->len = size;
+			memcpy(hostcmd->cmd, (void *) resp, size);
+		}
+	}
+	orig_cmdresp_no = le16_to_cpu(resp->command);
+
+	/* Get BSS number and corresponding priv */
+	priv = mwifiex_get_priv_by_id(adapter,
+			HostCmd_GET_BSS_NO(le16_to_cpu(resp->seq_num)),
+			HostCmd_GET_BSS_TYPE(le16_to_cpu(resp->seq_num)));
+	if (!priv)
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	/* Clear RET_BIT from HostCmd */
+	resp->command = cpu_to_le16(orig_cmdresp_no & HostCmd_CMD_ID_MASK);
+
+	cmdresp_no = le16_to_cpu(resp->command);
+	cmdresp_result = le16_to_cpu(resp->result);
+
+	/* Save the last command response to debug log */
+	adapter->dbg.last_cmd_resp_index =
+		(adapter->dbg.last_cmd_resp_index + 1) % DBG_CMD_NUM;
+	adapter->dbg.last_cmd_resp_id[adapter->dbg.last_cmd_resp_index] =
+		orig_cmdresp_no;
+
+	do_gettimeofday(&tstamp);
+	dev_dbg(adapter->dev, "cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d,"
+		" len %d, seqno 0x%x\n",
+	       tstamp.tv_sec, tstamp.tv_usec, orig_cmdresp_no, cmdresp_result,
+	       le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
+
+	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
+		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_FW_CMDRESP;
+
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->curr_cmd = NULL;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		return -1;
+	}
+
+	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
+		adapter->curr_cmd->cmd_flag &= ~CMD_F_HOSTCMD;
+		if ((cmdresp_result == HostCmd_RESULT_OK)
+		    && (cmdresp_no == HostCmd_CMD_802_11_HS_CFG_ENH))
+			ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
+	} else {
+		/* handle response */
+		ret = mwifiex_process_sta_cmdresp(priv, cmdresp_no, resp,
+						  wait_queue);
+	}
+
+	/* Check init command response */
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
+		if (ret == -1) {
+			dev_err(adapter->dev, "%s: cmd %#x failed during "
+				"initialization\n", __func__, cmdresp_no);
+			mwifiex_init_fw_complete(adapter);
+			return -1;
+		} else if (adapter->last_init_cmd == cmdresp_no)
+			adapter->hw_status = MWIFIEX_HW_STATUS_INIT_DONE;
+	}
+
+	if (adapter->curr_cmd) {
+		if (wait_queue && (!ret))
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+		else if (wait_queue && (ret == -1))
+			wait_queue->status = MWIFIEX_ERROR_CMD_RESP_FAIL;
+
+		/* Clean up and put current command back to cmd_free_q */
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->curr_cmd = NULL;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+	}
+
+	return ret;
+}
+
+/*
+ * This function handles the timeout of command sending.
+ *
+ * It will re-send the same command again.
+ */
+void
+mwifiex_cmd_timeout_func(unsigned long function_context)
+{
+	struct mwifiex_adapter *adapter =
+		(struct mwifiex_adapter *) function_context;
+	struct cmd_ctrl_node *cmd_node = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	struct timeval tstamp;
+
+	adapter->num_cmd_timeout++;
+	adapter->dbg.num_cmd_timeout++;
+	if (!adapter->curr_cmd) {
+		dev_dbg(adapter->dev, "cmd: empty curr_cmd\n");
+		return;
+	}
+	cmd_node = adapter->curr_cmd;
+	if (cmd_node->wq_buf) {
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
+		wait_queue->status = MWIFIEX_ERROR_CMD_TIMEOUT;
+	}
+
+	if (cmd_node) {
+		adapter->dbg.timeout_cmd_id =
+			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
+		adapter->dbg.timeout_cmd_act =
+			adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index];
+		do_gettimeofday(&tstamp);
+		dev_err(adapter->dev, "%s: Timeout cmd id (%lu.%lu) = %#x,"
+			" act = %#x\n", __func__,
+		       tstamp.tv_sec, tstamp.tv_usec,
+		       adapter->dbg.timeout_cmd_id,
+		       adapter->dbg.timeout_cmd_act);
+
+		dev_err(adapter->dev, "num_data_h2c_failure = %d\n",
+		       adapter->dbg.num_tx_host_to_card_failure);
+		dev_err(adapter->dev, "num_cmd_h2c_failure = %d\n",
+		       adapter->dbg.num_cmd_host_to_card_failure);
+
+		dev_err(adapter->dev, "num_cmd_timeout = %d\n",
+		       adapter->dbg.num_cmd_timeout);
+		dev_err(adapter->dev, "num_tx_timeout = %d\n",
+		       adapter->dbg.num_tx_timeout);
+
+		dev_err(adapter->dev, "last_cmd_index = %d\n",
+		       adapter->dbg.last_cmd_index);
+		print_hex_dump_bytes("last_cmd_id: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_id, DBG_CMD_NUM);
+		print_hex_dump_bytes("last_cmd_act: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_act, DBG_CMD_NUM);
+
+		dev_err(adapter->dev, "last_cmd_resp_index = %d\n",
+		       adapter->dbg.last_cmd_resp_index);
+		print_hex_dump_bytes("last_cmd_resp_id: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_cmd_resp_id, DBG_CMD_NUM);
+
+		dev_err(adapter->dev, "last_event_index = %d\n",
+		       adapter->dbg.last_event_index);
+		print_hex_dump_bytes("last_event: ", DUMP_PREFIX_OFFSET,
+				adapter->dbg.last_event, DBG_CMD_NUM);
+
+		dev_err(adapter->dev, "data_sent=%d cmd_sent=%d\n",
+		       adapter->data_sent, adapter->cmd_sent);
+
+		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
+				adapter->ps_mode, adapter->ps_state);
+	}
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
+		mwifiex_init_fw_complete(adapter);
+
+	return;
+}
+
+/*
+ * This function cancels all the pending commands.
+ *
+ * The current command, all commands in command pending queue and all scan
+ * commands in scan pending queue are cancelled. All the completion callbacks
+ * are called with failure status to ensure cleanup.
+ */
+void
+mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
+{
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	unsigned long flags;
+
+	/* Cancel current cmd */
+	if ((adapter->curr_cmd) && (adapter->curr_cmd->wq_buf)) {
+		wait_queue =
+			(struct mwifiex_wait_queue *) adapter->curr_cmd->wq_buf;
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->curr_cmd->wq_buf = NULL;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+		mwifiex_ioctl_complete(adapter, wait_queue, -1);
+	}
+	/* Cancel all pending command */
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->cmd_pending_q, list) {
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+		if (cmd_node->wq_buf) {
+			wait_queue =
+				(struct mwifiex_wait_queue *) cmd_node->wq_buf;
+			wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+			mwifiex_ioctl_complete(adapter, wait_queue, -1);
+			cmd_node->wq_buf = NULL;
+		}
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	}
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+	/* Cancel all pending scan command */
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->scan_pending_q, list) {
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		cmd_node->wq_buf = NULL;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->scan_processing = false;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+}
+
+/*
+ * This function cancels all pending commands that matches with
+ * the given IOCTL request.
+ *
+ * Both the current command buffer and the pending command queue are
+ * searched for matching IOCTL request. The completion callback of
+ * the matched command is called with failure status to ensure cleanup.
+ * In case of scan commands, all pending commands in scan pending queue
+ * are cancelled.
+ */
+void
+mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
+			     struct mwifiex_wait_queue *wait_queue)
+{
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	unsigned long cmd_flags;
+	unsigned long cmd_pending_q_flags;
+	unsigned long scan_pending_q_flags;
+	uint16_t cancel_scan_cmd = false;
+
+	if ((adapter->curr_cmd) &&
+	    (adapter->curr_cmd->wq_buf == wait_queue)) {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+		cmd_node = adapter->curr_cmd;
+		cmd_node->wq_buf = NULL;
+		cmd_node->cmd_flag |= CMD_F_CANCELED;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+	}
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+	while (1) {
+		cmd_node = mwifiex_get_pending_ioctl_cmd(adapter, wait_queue);
+		if (!cmd_node)
+			break;
+
+		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
+				  cmd_pending_q_flags);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+				       cmd_pending_q_flags);
+
+		cmd_node->wq_buf = NULL;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+	}
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+	/* Cancel all pending scan command */
+	spin_lock_irqsave(&adapter->scan_pending_q_lock,
+			  scan_pending_q_flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->scan_pending_q, list) {
+		if (cmd_node->wq_buf == wait_queue) {
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       scan_pending_q_flags);
+			cmd_node->wq_buf = NULL;
+			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+			spin_lock_irqsave(&adapter->scan_pending_q_lock,
+					  scan_pending_q_flags);
+			cancel_scan_cmd = true;
+		}
+	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+			       scan_pending_q_flags);
+
+	if (cancel_scan_cmd) {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+	}
+	wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+	mwifiex_ioctl_complete(adapter, wait_queue, -1);
+
+	return;
+}
+
+/*
+ * This function sends the sleep confirm command to firmware, if
+ * possible.
+ *
+ * The sleep confirm command cannot be issued if command response,
+ * data response or event response is awaiting handling, or if we
+ * are in the middle of sending a command, or expecting a command
+ * response.
+ */
+void
+mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
+{
+	if (!adapter->cmd_sent &&
+	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
+		mwifiex_dnld_sleep_confirm_cmd(adapter);
+	else
+		dev_dbg(adapter->dev,
+			"cmd: Delay Sleep Confirm (%s%s%s)\n",
+		       (adapter->cmd_sent) ? "D" : "",
+		       (adapter->curr_cmd) ? "C" : "",
+		       (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
+}
+
+/*
+ * This function sends a Host Sleep activated event to applications.
+ *
+ * This event is generated by the driver, with a blank event body.
+ */
+void
+mwifiex_hs_activated_event(struct mwifiex_private *priv, u8 activated)
+{
+	if (activated) {
+		if (priv->adapter->is_hs_configured) {
+			priv->adapter->hs_activated = true;
+			dev_dbg(priv->adapter->dev, "event: hs_activated\n");
+			priv->adapter->hs_activate_wait_q_woken = true;
+			wake_up_interruptible(
+				&priv->adapter->hs_activate_wait_q);
+		} else {
+			dev_dbg(priv->adapter->dev, "event: HS not configured\n");
+		}
+	} else {
+		dev_dbg(priv->adapter->dev, "event: hs_deactivated\n");
+		priv->adapter->hs_activated = false;
+	}
+}
+
+/*
+ * This function handles the command response of a Host Sleep configuration
+ * command.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and setting the current host sleep activation status in driver.
+ *
+ * In case host sleep status change, the function generates an event to
+ * notify the applications.
+ */
+int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_hs_cfg_enh *phs_cfg =
+		&resp->params.opt_hs_cfg;
+	uint32_t conditions = le32_to_cpu(phs_cfg->params.hs_config.conditions);
+
+	if (phs_cfg->action == cpu_to_le16(HS_ACTIVATE)) {
+		mwifiex_hs_activated_event(priv, true);
+		return 0;
+	} else {
+		dev_dbg(adapter->dev, "cmd: CMD_RESP: HS_CFG cmd reply"
+			" result=%#x, conditions=0x%x gpio=0x%x gap=0x%x\n",
+			resp->result, conditions,
+		       phs_cfg->params.hs_config.gpio,
+		       phs_cfg->params.hs_config.gap);
+	}
+	if (conditions != HOST_SLEEP_CFG_CANCEL) {
+		adapter->is_hs_configured = true;
+	} else {
+		adapter->is_hs_configured = false;
+		if (adapter->hs_activated)
+			mwifiex_hs_activated_event(priv, false);
+	}
+
+	return 0;
+}
+
+/*
+ * This function wakes up the adapter and generates a Host Sleep
+ * cancel event on receiving the power up interrupt.
+ */
+void
+mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
+{
+	dev_dbg(adapter->dev, "info: %s: auto cancelling host sleep"
+		" since there is interrupt from the firmware\n", __func__);
+
+	adapter->if_ops.wakeup(adapter);
+	adapter->hs_activated = false;
+	adapter->is_hs_configured = false;
+	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+				   MWIFIEX_BSS_ROLE_ANY), false);
+	return;
+}
+
+/*
+ * This function handles the command response of a sleep confirm command.
+ *
+ * The function sets the card state to SLEEP if the response indicates success.
+ */
+void
+mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
+				   u8 *pbuf, u32 upld_len)
+{
+	struct host_cmd_ds_command *cmd = (struct host_cmd_ds_command *) pbuf;
+	struct mwifiex_private *priv =
+		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	uint16_t result = le16_to_cpu(cmd->result);
+	uint16_t command = le16_to_cpu(cmd->command);
+	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
+
+	if (!upld_len) {
+		dev_err(adapter->dev, "%s: cmd size is 0\n", __func__);
+		return;
+	}
+
+	/* Get BSS number and corresponding priv */
+	priv = mwifiex_get_priv_by_id(adapter, HostCmd_GET_BSS_NO(seq_num),
+				      HostCmd_GET_BSS_TYPE(seq_num));
+	if (!priv)
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
+	/* Update sequence number */
+	seq_num = HostCmd_GET_SEQ_NO(seq_num);
+	/* Clear RET_BIT from HostCmd */
+	command &= HostCmd_CMD_ID_MASK;
+
+	if (command != HostCmd_CMD_802_11_PS_MODE_ENH) {
+		dev_err(adapter->dev, "%s: received unexpected response for"
+			" cmd %x, result = %x\n", __func__, command, result);
+		return;
+	}
+
+	if (result) {
+		dev_err(adapter->dev, "%s: sleep confirm cmd failed\n",
+						__func__);
+		adapter->pm_wakeup_card_req = false;
+		adapter->ps_state = PS_STATE_AWAKE;
+		return;
+	}
+	adapter->pm_wakeup_card_req = true;
+	if (adapter->is_hs_configured)
+		mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+					   MWIFIEX_BSS_ROLE_ANY), true);
+	adapter->ps_state = PS_STATE_SLEEP;
+	cmd->command = cpu_to_le16(command);
+	cmd->seq_num = cpu_to_le16(seq_num);
+}
+EXPORT_SYMBOL_GPL(mwifiex_process_sleep_confirm_resp);
+
+/*
+ * This function prepares an enhanced power mode command.
+ *
+ * This function can be used to disable power save or to configure
+ * power save with auto PS or STA PS or auto deep sleep.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting Power Save bitmap, PS parameters TLV, PS mode TLV,
+ *        auto deep sleep TLV (as required)
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *cmd,
+			       u16 cmd_action, uint16_t ps_bitmap,
+			       void *data_buf)
+{
+	struct host_cmd_ds_802_11_ps_mode_enh *psmode_enh =
+		&cmd->params.psmode_enh;
+	u8 *tlv = NULL;
+	u16 cmd_size = 0;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
+	if (cmd_action == DIS_AUTO_PS) {
+		psmode_enh->action = cpu_to_le16(DIS_AUTO_PS);
+		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
+		cmd->size = cpu_to_le16(S_DS_GEN + AUTO_PS_FIX_SIZE);
+	} else if (cmd_action == GET_PS) {
+		psmode_enh->action = cpu_to_le16(GET_PS);
+		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
+		cmd->size = cpu_to_le16(S_DS_GEN + AUTO_PS_FIX_SIZE);
+	} else if (cmd_action == EN_AUTO_PS) {
+		psmode_enh->action = cpu_to_le16(EN_AUTO_PS);
+		psmode_enh->params.auto_ps.ps_bitmap = cpu_to_le16(ps_bitmap);
+		cmd_size = S_DS_GEN + AUTO_PS_FIX_SIZE;
+		tlv = (u8 *) cmd + cmd_size;
+		if (ps_bitmap & BITMAP_STA_PS) {
+			struct mwifiex_adapter *adapter = priv->adapter;
+			struct mwifiex_ie_types_ps_param *ps_tlv =
+				(struct mwifiex_ie_types_ps_param *) tlv;
+			struct mwifiex_ps_param *ps_mode = &ps_tlv->param;
+			ps_tlv->header.type = cpu_to_le16(TLV_TYPE_PS_PARAM);
+			ps_tlv->header.len = cpu_to_le16(sizeof(*ps_tlv) -
+					sizeof(struct mwifiex_ie_types_header));
+			cmd_size += sizeof(*ps_tlv);
+			tlv += sizeof(*ps_tlv);
+			dev_dbg(adapter->dev, "cmd: PS Command: Enter PS\n");
+			ps_mode->null_pkt_interval =
+				cpu_to_le16(adapter->null_pkt_interval);
+			ps_mode->multiple_dtims =
+				cpu_to_le16(adapter->multiple_dtim);
+			ps_mode->bcn_miss_timeout =
+				cpu_to_le16(adapter->bcn_miss_time_out);
+			ps_mode->local_listen_interval =
+				cpu_to_le16(adapter->local_listen_interval);
+			ps_mode->adhoc_wake_period =
+				cpu_to_le16(adapter->adhoc_awake_period);
+			ps_mode->delay_to_ps =
+				cpu_to_le16(adapter->delay_to_ps);
+			ps_mode->mode =
+				cpu_to_le16(adapter->enhanced_ps_mode);
+
+		}
+		if (ps_bitmap & BITMAP_AUTO_DS) {
+			struct mwifiex_ie_types_auto_ds_param *auto_ps_tlv =
+				(struct mwifiex_ie_types_auto_ds_param *) tlv;
+			struct mwifiex_auto_ds_param *auto_ds =
+				&auto_ps_tlv->param;
+			u16 idletime = 0;
+			auto_ps_tlv->header.type =
+				cpu_to_le16(TLV_TYPE_AUTO_DS_PARAM);
+			auto_ps_tlv->header.len =
+				cpu_to_le16(sizeof(*auto_ps_tlv) -
+					sizeof(struct mwifiex_ie_types_header));
+			cmd_size += sizeof(*auto_ps_tlv);
+			tlv += sizeof(*auto_ps_tlv);
+			if (data_buf)
+				idletime = ((struct mwifiex_ds_auto_ds *)
+					     data_buf)->idle_time;
+			dev_dbg(priv->adapter->dev,
+					"cmd: PS Command: Enter Auto Deep Sleep\n");
+			auto_ds->deep_sleep_timeout = cpu_to_le16(idletime);
+		}
+		cmd->size = cpu_to_le16(cmd_size);
+	}
+	return 0;
+}
+
+/*
+ * This function handles the command response of an enhanced power mode
+ * command.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and setting the current enhanced power mode in driver.
+ */
+int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_ps_mode_enh *ps_mode =
+		&resp->params.psmode_enh;
+	uint16_t action = le16_to_cpu(ps_mode->action);
+	uint16_t ps_bitmap = le16_to_cpu(ps_mode->params.ps_bitmap);
+	uint16_t auto_ps_bitmap =
+		le16_to_cpu(ps_mode->params.auto_ps.ps_bitmap);
+
+	dev_dbg(adapter->dev, "info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
+					__func__, resp->result, action);
+	if (action == EN_AUTO_PS) {
+		if (auto_ps_bitmap & BITMAP_AUTO_DS) {
+			dev_dbg(adapter->dev, "cmd: Enabled auto deep sleep\n");
+			priv->adapter->is_deep_sleep = true;
+		}
+		if (auto_ps_bitmap & BITMAP_STA_PS) {
+			dev_dbg(adapter->dev, "cmd: Enabled STA power save\n");
+			if (adapter->sleep_period.period)
+				dev_dbg(adapter->dev, "cmd: set to uapsd/pps mode\n");
+		}
+	} else if (action == DIS_AUTO_PS) {
+		if (ps_bitmap & BITMAP_AUTO_DS) {
+			priv->adapter->is_deep_sleep = false;
+			dev_dbg(adapter->dev, "cmd: Disabled auto deep sleep\n");
+		}
+		if (ps_bitmap & BITMAP_STA_PS) {
+			dev_dbg(adapter->dev, "cmd: Disabled STA power save\n");
+			if (adapter->sleep_period.period) {
+				adapter->delay_null_pkt = false;
+				adapter->tx_lock_flag = false;
+				adapter->pps_uapsd_mode = false;
+			}
+		}
+	} else if (action == GET_PS) {
+		if (ps_bitmap & (BITMAP_STA_PS | BITMAP_UAP_INACT_PS
+							| BITMAP_UAP_DTIM_PS))
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+		else
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+
+		dev_dbg(adapter->dev, "cmd: ps_bitmap=%#x\n", ps_bitmap);
+
+		if (data_buf) {
+			/* This section is for get power save mode */
+			struct mwifiex_ds_pm_cfg *pm_cfg =
+					(struct mwifiex_ds_pm_cfg *)data_buf;
+			if (ps_bitmap & BITMAP_STA_PS)
+				pm_cfg->param.ps_mode = 1;
+			else
+				pm_cfg->param.ps_mode = 0;
+		}
+	}
+	return 0;
+}
+
+/*
+ * This function prepares command to get hardware specifications.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting permanent address parameter
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd)
+{
+	struct host_cmd_ds_get_hw_spec *hw_spec = &cmd->params.hw_spec;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_GET_HW_SPEC);
+	cmd->size =
+		cpu_to_le16(sizeof(struct host_cmd_ds_get_hw_spec) + S_DS_GEN);
+	memcpy(hw_spec->permanent_addr, priv->curr_addr, ETH_ALEN);
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of get hardware
+ * specifications.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving/updating the following parameters in driver -
+ *      - Firmware capability information
+ *      - Firmware band settings
+ *      - Ad-hoc start band and channel
+ *      - Ad-hoc 11n activation status
+ *      - Firmware release number
+ *      - Number of antennas
+ *      - Hardware address
+ *      - Hardware interface version
+ *      - Firmware version
+ *      - Region code
+ *      - 11n capabilities
+ *      - MCS support fields
+ *      - MP end port
+ */
+int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int i;
+
+	adapter->fw_cap_info = le32_to_cpu(hw_spec->fw_cap_info);
+
+	if (IS_SUPPORT_MULTI_BANDS(adapter))
+		adapter->fw_bands = (u8) GET_FW_DEFAULT_BANDS(adapter);
+	else
+		adapter->fw_bands = BAND_B;
+
+	adapter->config_bands = adapter->fw_bands;
+
+	if (adapter->fw_bands & BAND_A) {
+		if (adapter->fw_bands & BAND_GN) {
+			adapter->config_bands |= BAND_AN;
+			adapter->fw_bands |= BAND_AN;
+		}
+		if (adapter->fw_bands & BAND_AN) {
+			adapter->adhoc_start_band = BAND_A | BAND_AN;
+			adapter->adhoc_11n_enabled = true;
+		} else {
+			adapter->adhoc_start_band = BAND_A;
+		}
+		priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL_A;
+	} else if (adapter->fw_bands & BAND_GN) {
+		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
+		priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+		adapter->adhoc_11n_enabled = true;
+	} else if (adapter->fw_bands & BAND_G) {
+		adapter->adhoc_start_band = BAND_G | BAND_B;
+		priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+	} else if (adapter->fw_bands & BAND_B) {
+		adapter->adhoc_start_band = BAND_B;
+		priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+	}
+
+	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
+	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
+
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
+	       adapter->fw_release_number);
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
+					hw_spec->permanent_addr);
+	dev_dbg(adapter->dev, "info: GET_HW_SPEC: hw_if_version=%#x  version=%#x\n",
+		le16_to_cpu(hw_spec->hw_if_version),
+	       le16_to_cpu(hw_spec->version));
+
+	if (priv->curr_addr[0] == 0xff)
+		memmove(priv->curr_addr, hw_spec->permanent_addr, ETH_ALEN);
+
+	adapter->region_code = le16_to_cpu(hw_spec->region_code);
+
+	for (i = 0; i < MWIFIEX_MAX_REGION_CODE; i++)
+		/* Use the region code to search for the index */
+		if (adapter->region_code == region_code_index[i])
+			break;
+
+	/* If it's unidentified region code, use the default (USA) */
+	if (i >= MWIFIEX_MAX_REGION_CODE) {
+		adapter->region_code = 0x10;
+		dev_dbg(adapter->dev, "cmd: unknown region code, use default (USA)\n");
+	}
+
+	adapter->hw_dot_11n_dev_cap = le32_to_cpu(hw_spec->dot_11n_dev_cap);
+	adapter->usr_dot_11n_dev_cap = adapter->hw_dot_11n_dev_cap &
+		DEFAULT_11N_CAP_MASK;
+	adapter->hw_dev_mcs_support = hw_spec->dev_mcs_support;
+	adapter->usr_dev_mcs_support = adapter->hw_dev_mcs_support;
+	mwifiex_show_dot_11n_dev_cap(adapter, adapter->hw_dot_11n_dev_cap);
+	mwifiex_show_dev_mcs_support(adapter, adapter->hw_dev_mcs_support);
+
+	if (adapter->if_ops.update_mp_end_port)
+		adapter->if_ops.update_mp_end_port(adapter,
+					le16_to_cpu(hw_spec->mp_end_port));
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
new file mode 100644
index 0000000..63b0969
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -0,0 +1,773 @@
+/*
+ * Marvell Wireless LAN device driver: debugfs
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include <linux/debugfs.h>
+
+#include "main.h"
+#include "11n.h"
+
+
+static struct dentry *mwifiex_dfs_dir;
+
+static char *bss_modes[] = {
+	"Unknown",
+	"Managed",
+	"Ad-hoc",
+	"Auto"
+};
+
+/* size/addr for mwifiex_debug_info */
+#define item_size(n)		(FIELD_SIZEOF(struct mwifiex_debug_info, n))
+#define item_addr(n)		(offsetof(struct mwifiex_debug_info, n))
+
+/* size/addr for struct mwifiex_adapter */
+#define adapter_item_size(n)	(FIELD_SIZEOF(struct mwifiex_adapter, n))
+#define adapter_item_addr(n)	(offsetof(struct mwifiex_adapter, n))
+
+struct mwifiex_debug_data {
+	char name[32];		/* variable/array name */
+	u32 size;		/* size of the variable/array */
+	size_t addr;		/* address of the variable/array */
+	int num;		/* number of variables in an array */
+};
+
+static struct mwifiex_debug_data items[] = {
+	{"int_counter", item_size(int_counter),
+	 item_addr(int_counter), 1},
+	{"wmm_ac_vo", item_size(packets_out[WMM_AC_VO]),
+	 item_addr(packets_out[WMM_AC_VO]), 1},
+	{"wmm_ac_vi", item_size(packets_out[WMM_AC_VI]),
+	 item_addr(packets_out[WMM_AC_VI]), 1},
+	{"wmm_ac_be", item_size(packets_out[WMM_AC_BE]),
+	 item_addr(packets_out[WMM_AC_BE]), 1},
+	{"wmm_ac_bk", item_size(packets_out[WMM_AC_BK]),
+	 item_addr(packets_out[WMM_AC_BK]), 1},
+	{"max_tx_buf_size", item_size(max_tx_buf_size),
+	 item_addr(max_tx_buf_size), 1},
+	{"tx_buf_size", item_size(tx_buf_size),
+	 item_addr(tx_buf_size), 1},
+	{"curr_tx_buf_size", item_size(curr_tx_buf_size),
+	 item_addr(curr_tx_buf_size), 1},
+	{"ps_mode", item_size(ps_mode),
+	 item_addr(ps_mode), 1},
+	{"ps_state", item_size(ps_state),
+	 item_addr(ps_state), 1},
+	{"is_deep_sleep", item_size(is_deep_sleep),
+	 item_addr(is_deep_sleep), 1},
+	{"wakeup_dev_req", item_size(pm_wakeup_card_req),
+	 item_addr(pm_wakeup_card_req), 1},
+	{"wakeup_tries", item_size(pm_wakeup_fw_try),
+	 item_addr(pm_wakeup_fw_try), 1},
+	{"hs_configured", item_size(is_hs_configured),
+	 item_addr(is_hs_configured), 1},
+	{"hs_activated", item_size(hs_activated),
+	 item_addr(hs_activated), 1},
+	{"num_tx_timeout", item_size(num_tx_timeout),
+	 item_addr(num_tx_timeout), 1},
+	{"num_cmd_timeout", item_size(num_cmd_timeout),
+	 item_addr(num_cmd_timeout), 1},
+	{"timeout_cmd_id", item_size(timeout_cmd_id),
+	 item_addr(timeout_cmd_id), 1},
+	{"timeout_cmd_act", item_size(timeout_cmd_act),
+	 item_addr(timeout_cmd_act), 1},
+	{"last_cmd_id", item_size(last_cmd_id),
+	 item_addr(last_cmd_id), DBG_CMD_NUM},
+	{"last_cmd_act", item_size(last_cmd_act),
+	 item_addr(last_cmd_act), DBG_CMD_NUM},
+	{"last_cmd_index", item_size(last_cmd_index),
+	 item_addr(last_cmd_index), 1},
+	{"last_cmd_resp_id", item_size(last_cmd_resp_id),
+	 item_addr(last_cmd_resp_id), DBG_CMD_NUM},
+	{"last_cmd_resp_index", item_size(last_cmd_resp_index),
+	 item_addr(last_cmd_resp_index), 1},
+	{"last_event", item_size(last_event),
+	 item_addr(last_event), DBG_CMD_NUM},
+	{"last_event_index", item_size(last_event_index),
+	 item_addr(last_event_index), 1},
+	{"num_cmd_h2c_fail", item_size(num_cmd_host_to_card_failure),
+	 item_addr(num_cmd_host_to_card_failure), 1},
+	{"num_cmd_sleep_cfm_fail",
+	 item_size(num_cmd_sleep_cfm_host_to_card_failure),
+	 item_addr(num_cmd_sleep_cfm_host_to_card_failure), 1},
+	{"num_tx_h2c_fail", item_size(num_tx_host_to_card_failure),
+	 item_addr(num_tx_host_to_card_failure), 1},
+	{"num_evt_deauth", item_size(num_event_deauth),
+	 item_addr(num_event_deauth), 1},
+	{"num_evt_disassoc", item_size(num_event_disassoc),
+	 item_addr(num_event_disassoc), 1},
+	{"num_evt_link_lost", item_size(num_event_link_lost),
+	 item_addr(num_event_link_lost), 1},
+	{"num_cmd_deauth", item_size(num_cmd_deauth),
+	 item_addr(num_cmd_deauth), 1},
+	{"num_cmd_assoc_ok", item_size(num_cmd_assoc_success),
+	 item_addr(num_cmd_assoc_success), 1},
+	{"num_cmd_assoc_fail", item_size(num_cmd_assoc_failure),
+	 item_addr(num_cmd_assoc_failure), 1},
+	{"cmd_sent", item_size(cmd_sent),
+	 item_addr(cmd_sent), 1},
+	{"data_sent", item_size(data_sent),
+	 item_addr(data_sent), 1},
+	{"cmd_resp_received", item_size(cmd_resp_received),
+	 item_addr(cmd_resp_received), 1},
+	{"event_received", item_size(event_received),
+	 item_addr(event_received), 1},
+
+	/* variables defined in struct mwifiex_adapter */
+	{"ioctl_pending", adapter_item_size(ioctl_pending),
+	 adapter_item_addr(ioctl_pending), 1},
+	{"tx_pending", adapter_item_size(tx_pending),
+	 adapter_item_addr(tx_pending), 1},
+	{"rx_pending", adapter_item_size(rx_pending),
+	 adapter_item_addr(rx_pending), 1},
+};
+
+static int num_of_items = ARRAY_SIZE(items);
+
+/*
+ * Generic proc file open handler.
+ *
+ * This function is called every time a file is accessed for read or write.
+ */
+static int
+mwifiex_open_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+/*
+ * Proc info file read handler.
+ *
+ * This function is called when the 'info' file is opened for reading.
+ * It prints the following driver related information -
+ *      - Driver name
+ *      - Driver version
+ *      - Driver extended version
+ *      - Interface name
+ *      - BSS mode
+ *      - Media state (connected or disconnected)
+ *      - MAC address
+ *      - Total number of Tx bytes
+ *      - Total number of Rx bytes
+ *      - Total number of Tx packets
+ *      - Total number of Rx packets
+ *      - Total number of dropped Tx packets
+ *      - Total number of dropped Rx packets
+ *      - Total number of corrupted Tx packets
+ *      - Total number of corrupted Rx packets
+ *      - Carrier status (on or off)
+ *      - Tx queue status (started or stopped)
+ *
+ * For STA mode drivers, it also prints the following extra -
+ *      - ESSID
+ *      - BSSID
+ *      - Channel
+ *      - Region code
+ *      - Multicast count
+ *      - Multicast addresses
+ */
+static ssize_t
+mwifiex_info_read(struct file *file, char __user *ubuf,
+		  size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *) file->private_data;
+	struct net_device *netdev = priv->netdev;
+	struct netdev_hw_addr *ha;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *p = (char *) page, fmt[64];
+	struct mwifiex_bss_info info;
+	ssize_t ret = 0;
+	int i = 0;
+
+	if (!p)
+		return -ENOMEM;
+
+	memset(&info, 0, sizeof(info));
+	ret = mwifiex_get_bss_info(priv, &info);
+	if (ret)
+		goto free_and_exit;
+
+	mwifiex_drv_get_driver_version(priv->adapter, fmt, sizeof(fmt) - 1);
+
+	if (!priv->version_str[0])
+		mwifiex_get_ver_ext(priv);
+
+	p += sprintf(p, "driver_name = " "\"mwifiex\"\n");
+	p += sprintf(p, "driver_version = %s", fmt);
+	p += sprintf(p, "\nverext = %s", priv->version_str);
+	p += sprintf(p, "\ninterface_name=\"%s\"\n", netdev->name);
+	p += sprintf(p, "bss_mode=\"%s\"\n", bss_modes[info.bss_mode]);
+	p += sprintf(p, "media_state=\"%s\"\n",
+		     (!priv->media_connected ? "Disconnected" : "Connected"));
+	p += sprintf(p, "mac_address=\"%02x:%02x:%02x:%02x:%02x:%02x\"\n",
+		     netdev->dev_addr[0], netdev->dev_addr[1],
+		     netdev->dev_addr[2], netdev->dev_addr[3],
+		     netdev->dev_addr[4], netdev->dev_addr[5]);
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
+		p += sprintf(p, "multicast_count=\"%d\"\n",
+			     netdev_mc_count(netdev));
+		p += sprintf(p, "essid=\"%s\"\n", info.ssid.ssid);
+		p += sprintf(p, "bssid=\"%02x:%02x:%02x:%02x:%02x:%02x\"\n",
+			     info.bssid[0], info.bssid[1],
+			     info.bssid[2], info.bssid[3],
+			     info.bssid[4], info.bssid[5]);
+		p += sprintf(p, "channel=\"%d\"\n", (int) info.bss_chan);
+		p += sprintf(p, "region_code = \"%02x\"\n", info.region_code);
+
+		netdev_for_each_mc_addr(ha, netdev)
+			p += sprintf(p, "multicast_address[%d]="
+				     "\"%02x:%02x:%02x:%02x:%02x:%02x\"\n", i++,
+				     ha->addr[0], ha->addr[1],
+				     ha->addr[2], ha->addr[3],
+				     ha->addr[4], ha->addr[5]);
+	}
+
+	p += sprintf(p, "num_tx_bytes = %lu\n", priv->stats.tx_bytes);
+	p += sprintf(p, "num_rx_bytes = %lu\n", priv->stats.rx_bytes);
+	p += sprintf(p, "num_tx_pkts = %lu\n", priv->stats.tx_packets);
+	p += sprintf(p, "num_rx_pkts = %lu\n", priv->stats.rx_packets);
+	p += sprintf(p, "num_tx_pkts_dropped = %lu\n", priv->stats.tx_dropped);
+	p += sprintf(p, "num_rx_pkts_dropped = %lu\n", priv->stats.rx_dropped);
+	p += sprintf(p, "num_tx_pkts_err = %lu\n", priv->stats.tx_errors);
+	p += sprintf(p, "num_rx_pkts_err = %lu\n", priv->stats.rx_errors);
+	p += sprintf(p, "carrier %s\n", ((netif_carrier_ok(priv->netdev))
+					 ? "on" : "off"));
+	p += sprintf(p, "tx queue %s\n", ((netif_queue_stopped(priv->netdev))
+					  ? "stopped" : "started"));
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
+				      (unsigned long) p - page);
+
+free_and_exit:
+	free_page(page);
+	return ret;
+}
+
+/*
+ * Proc getlog file read handler.
+ *
+ * This function is called when the 'getlog' file is opened for reading
+ * It prints the following log information -
+ *      - Number of multicast Tx frames
+ *      - Number of failed packets
+ *      - Number of Tx retries
+ *      - Number of multicast Tx retries
+ *      - Number of duplicate frames
+ *      - Number of RTS successes
+ *      - Number of RTS failures
+ *      - Number of ACK failures
+ *      - Number of fragmented Rx frames
+ *      - Number of multicast Rx frames
+ *      - Number of FCS errors
+ *      - Number of Tx frames
+ *      - WEP ICV error counts
+ */
+static ssize_t
+mwifiex_getlog_read(struct file *file, char __user *ubuf,
+		    size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *) file->private_data;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *p = (char *) page;
+	ssize_t ret = 0;
+	struct mwifiex_ds_get_stats stats;
+
+	if (!p)
+		return -ENOMEM;
+
+	memset(&stats, 0, sizeof(stats));
+	ret = mwifiex_get_stats_info(priv, &stats);
+	if (ret)
+		goto free_and_exit;
+
+	p += sprintf(p, "\n"
+		     "mcasttxframe     %u\n"
+		     "failed           %u\n"
+		     "retry            %u\n"
+		     "multiretry       %u\n"
+		     "framedup         %u\n"
+		     "rtssuccess       %u\n"
+		     "rtsfailure       %u\n"
+		     "ackfailure       %u\n"
+		     "rxfrag           %u\n"
+		     "mcastrxframe     %u\n"
+		     "fcserror         %u\n"
+		     "txframe          %u\n"
+		     "wepicverrcnt-1   %u\n"
+		     "wepicverrcnt-2   %u\n"
+		     "wepicverrcnt-3   %u\n"
+		     "wepicverrcnt-4   %u\n",
+		     stats.mcast_tx_frame,
+		     stats.failed,
+		     stats.retry,
+		     stats.multi_retry,
+		     stats.frame_dup,
+		     stats.rts_success,
+		     stats.rts_failure,
+		     stats.ack_failure,
+		     stats.rx_frag,
+		     stats.mcast_rx_frame,
+		     stats.fcs_error,
+		     stats.tx_frame,
+		     stats.wep_icv_error[0],
+		     stats.wep_icv_error[1],
+		     stats.wep_icv_error[2],
+		     stats.wep_icv_error[3]);
+
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
+				      (unsigned long) p - page);
+
+free_and_exit:
+	free_page(page);
+	return ret;
+}
+
+static struct mwifiex_debug_info info;
+
+/*
+ * Proc debug file read handler.
+ *
+ * This function is called when the 'debug' file is opened for reading
+ * It prints the following log information -
+ *      - Interrupt count
+ *      - WMM AC VO packets count
+ *      - WMM AC VI packets count
+ *      - WMM AC BE packets count
+ *      - WMM AC BK packets count
+ *      - Maximum Tx buffer size
+ *      - Tx buffer size
+ *      - Current Tx buffer size
+ *      - Power Save mode
+ *      - Power Save state
+ *      - Deep Sleep status
+ *      - Device wakeup required status
+ *      - Number of wakeup tries
+ *      - Host Sleep configured status
+ *      - Host Sleep activated status
+ *      - Number of Tx timeouts
+ *      - Number of command timeouts
+ *      - Last timed out command ID
+ *      - Last timed out command action
+ *      - Last command ID
+ *      - Last command action
+ *      - Last command index
+ *      - Last command response ID
+ *      - Last command response index
+ *      - Last event
+ *      - Last event index
+ *      - Number of host to card command failures
+ *      - Number of sleep confirm command failures
+ *      - Number of host to card data failure
+ *      - Number of deauthentication events
+ *      - Number of disassociation events
+ *      - Number of link lost events
+ *      - Number of deauthentication commands
+ *      - Number of association success commands
+ *      - Number of association failure commands
+ *      - Number of commands sent
+ *      - Number of data packets sent
+ *      - Number of command responses received
+ *      - Number of events received
+ *      - Tx BA stream table (TID, RA)
+ *      - Rx reorder table (TID, TA, Start window, Window size, Buffer)
+ */
+static ssize_t
+mwifiex_debug_read(struct file *file, char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *) file->private_data;
+	struct mwifiex_debug_data *d = &items[0];
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *p = (char *) page;
+	ssize_t ret = 0;
+	size_t size, addr;
+	long val;
+	int i, j;
+
+	if (!p)
+		return -ENOMEM;
+
+	ret = mwifiex_get_debug_info(priv, &info);
+	if (ret)
+		goto free_and_exit;
+
+	for (i = 0; i < num_of_items; i++) {
+		p += sprintf(p, "%s=", d[i].name);
+
+		size = d[i].size / d[i].num;
+
+		if (i < (num_of_items - 3))
+			addr = d[i].addr + (size_t) &info;
+		else /* The last 3 items are struct mwifiex_adapter variables */
+			addr = d[i].addr + (size_t) priv->adapter;
+
+		for (j = 0; j < d[i].num; j++) {
+			switch (size) {
+			case 1:
+				val = *((u8 *) addr);
+				break;
+			case 2:
+				val = *((u16 *) addr);
+				break;
+			case 4:
+				val = *((u32 *) addr);
+				break;
+			case 8:
+				val = *((long long *) addr);
+				break;
+			default:
+				val = -1;
+				break;
+			}
+
+			p += sprintf(p, "%#lx ", val);
+			addr += size;
+		}
+
+		p += sprintf(p, "\n");
+	}
+
+	if (info.tx_tbl_num) {
+		p += sprintf(p, "Tx BA stream table:\n");
+		for (i = 0; i < info.tx_tbl_num; i++)
+			p += sprintf(p, "tid = %d, "
+				     "ra = %02x:%02x:%02x:%02x:%02x:%02x\n",
+				     info.tx_tbl[i].tid, info.tx_tbl[i].ra[0],
+				     info.tx_tbl[i].ra[1], info.tx_tbl[i].ra[2],
+				     info.tx_tbl[i].ra[3], info.tx_tbl[i].ra[4],
+				     info.tx_tbl[i].ra[5]);
+	}
+
+	if (info.rx_tbl_num) {
+		p += sprintf(p, "Rx reorder table:\n");
+		for (i = 0; i < info.rx_tbl_num; i++) {
+
+			p += sprintf(p, "tid = %d, "
+				     "ta = %02x:%02x:%02x:%02x:%02x:%02x, "
+				     "start_win = %d, "
+				     "win_size = %d, buffer: ",
+				     info.rx_tbl[i].tid,
+				     info.rx_tbl[i].ta[0], info.rx_tbl[i].ta[1],
+				     info.rx_tbl[i].ta[2], info.rx_tbl[i].ta[3],
+				     info.rx_tbl[i].ta[4], info.rx_tbl[i].ta[5],
+				     info.rx_tbl[i].start_win,
+				     info.rx_tbl[i].win_size);
+
+			for (j = 0; j < info.rx_tbl[i].win_size; j++)
+				p += sprintf(p, "%c ",
+					     info.rx_tbl[i].buffer[j] ?
+					     '1' : '0');
+
+			p += sprintf(p, "\n");
+		}
+	}
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
+				      (unsigned long) p - page);
+
+free_and_exit:
+	free_page(page);
+	return ret;
+}
+
+static u32 saved_reg_type, saved_reg_offset, saved_reg_value;
+
+/*
+ * Proc regrdwr file write handler.
+ *
+ * This function is called when the 'regrdwr' file is opened for writing
+ *
+ * This function can be used to write to a register.
+ */
+static ssize_t
+mwifiex_regrdwr_write(struct file *file,
+		      const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *) addr;
+	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
+	int ret = 0;
+	u32 reg_type = 0, reg_offset = 0, reg_value = UINT_MAX;
+
+	if (!buf)
+		return -ENOMEM;
+
+
+	if (copy_from_user(buf, ubuf, buf_size)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	sscanf(buf, "%u %x %x", &reg_type, &reg_offset, &reg_value);
+
+	if (reg_type == 0 || reg_offset == 0) {
+		ret = -EINVAL;
+		goto done;
+	} else {
+		saved_reg_type = reg_type;
+		saved_reg_offset = reg_offset;
+		saved_reg_value = reg_value;
+		ret = count;
+	}
+done:
+	free_page(addr);
+	return ret;
+}
+
+/*
+ * Proc regrdwr file read handler.
+ *
+ * This function is called when the 'regrdwr' file is opened for reading
+ *
+ * This function can be used to read from a register.
+ */
+static ssize_t
+mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
+		     size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *) file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *) addr;
+	int pos = 0, ret = 0;
+	u32 reg_value;
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (!saved_reg_type) {
+		/* No command has been given */
+		pos += snprintf(buf, PAGE_SIZE, "0");
+		goto done;
+	}
+	/* Set command has been given */
+	if (saved_reg_value != UINT_MAX) {
+		ret = mwifiex_reg_write(priv, saved_reg_type, saved_reg_offset,
+					saved_reg_value);
+
+		pos += snprintf(buf, PAGE_SIZE, "%u 0x%x 0x%x\n",
+				saved_reg_type, saved_reg_offset,
+				saved_reg_value);
+
+		ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+		goto done;
+	}
+	/* Get command has been given */
+	ret = mwifiex_reg_read(priv, saved_reg_type,
+			       saved_reg_offset, &reg_value);
+	if (ret) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	pos += snprintf(buf, PAGE_SIZE, "%u 0x%x 0x%x\n", saved_reg_type,
+			saved_reg_offset, reg_value);
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+done:
+	free_page(addr);
+	return ret;
+}
+
+static u32 saved_offset = -1, saved_bytes = -1;
+
+/*
+ * Proc rdeeprom file write handler.
+ *
+ * This function is called when the 'rdeeprom' file is opened for writing
+ *
+ * This function can be used to write to a RDEEPROM location.
+ */
+static ssize_t
+mwifiex_rdeeprom_write(struct file *file,
+		       const char __user *ubuf, size_t count, loff_t *ppos)
+{
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *) addr;
+	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
+	int ret = 0;
+	int offset = -1, bytes = -1;
+
+	if (!buf)
+		return -ENOMEM;
+
+
+	if (copy_from_user(buf, ubuf, buf_size)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	sscanf(buf, "%d %d", &offset, &bytes);
+
+	if (offset == -1 || bytes == -1) {
+		ret = -EINVAL;
+		goto done;
+	} else {
+		saved_offset = offset;
+		saved_bytes = bytes;
+		ret = count;
+	}
+done:
+	free_page(addr);
+	return ret;
+}
+
+/*
+ * Proc rdeeprom read write handler.
+ *
+ * This function is called when the 'rdeeprom' file is opened for reading
+ *
+ * This function can be used to read from a RDEEPROM location.
+ */
+static ssize_t
+mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
+		      size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *) file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *) addr;
+	int pos = 0, ret = 0, i = 0;
+	u8 value[MAX_EEPROM_DATA];
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (saved_offset == -1) {
+		/* No command has been given */
+		pos += snprintf(buf, PAGE_SIZE, "0");
+		goto done;
+	}
+
+	/* Get command has been given */
+	ret = mwifiex_eeprom_read(priv, (u16) saved_offset,
+				  (u16) saved_bytes, value);
+	if (ret) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	pos += snprintf(buf, PAGE_SIZE, "%d %d ", saved_offset, saved_bytes);
+
+	for (i = 0; i < saved_bytes; i++)
+		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", value[i]);
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+done:
+	free_page(addr);
+	return ret;
+}
+
+
+#define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
+	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
+			priv, &mwifiex_dfs_##name##_fops))              \
+		return;                                                 \
+} while (0);
+
+#define MWIFIEX_DFS_FILE_OPS(name)                                      \
+static const struct file_operations mwifiex_dfs_##name##_fops = {       \
+	.read = mwifiex_##name##_read,                                  \
+	.write = mwifiex_##name##_write,                                \
+	.open = mwifiex_open_generic,                                   \
+};
+
+#define MWIFIEX_DFS_FILE_READ_OPS(name)                                 \
+static const struct file_operations mwifiex_dfs_##name##_fops = {       \
+	.read = mwifiex_##name##_read,                                  \
+	.open = mwifiex_open_generic,                                   \
+};
+
+#define MWIFIEX_DFS_FILE_WRITE_OPS(name)                                \
+static const struct file_operations mwifiex_dfs_##name##_fops = {       \
+	.write = mwifiex_##name##_write,                                \
+	.open = mwifiex_open_generic,                                   \
+};
+
+
+MWIFIEX_DFS_FILE_READ_OPS(info);
+MWIFIEX_DFS_FILE_READ_OPS(debug);
+MWIFIEX_DFS_FILE_READ_OPS(getlog);
+MWIFIEX_DFS_FILE_OPS(regrdwr);
+MWIFIEX_DFS_FILE_OPS(rdeeprom);
+
+/*
+ * This function creates the debug FS directory structure and the files.
+ */
+void
+mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
+{
+	if (!mwifiex_dfs_dir || !priv)
+		return;
+
+	priv->dfs_dev_dir = debugfs_create_dir(priv->netdev->name,
+					       mwifiex_dfs_dir);
+
+	if (!priv->dfs_dev_dir)
+		return;
+
+	MWIFIEX_DFS_ADD_FILE(info);
+	MWIFIEX_DFS_ADD_FILE(debug);
+	MWIFIEX_DFS_ADD_FILE(getlog);
+	MWIFIEX_DFS_ADD_FILE(regrdwr);
+	MWIFIEX_DFS_ADD_FILE(rdeeprom);
+
+	return;
+}
+
+/*
+ * This function removes the debug FS directory structure and the files.
+ */
+void
+mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
+{
+	if (!priv)
+		return;
+
+	debugfs_remove_recursive(priv->dfs_dev_dir);
+	return;
+}
+
+/*
+ * This function creates the top level proc directory.
+ */
+void
+mwifiex_debugfs_init(void)
+{
+	if (!mwifiex_dfs_dir)
+		mwifiex_dfs_dir = debugfs_create_dir("mwifiex", NULL);
+}
+
+/*
+ * This function removes the top level proc directory.
+ */
+void
+mwifiex_debugfs_remove(void)
+{
+	if (mwifiex_dfs_dir)
+		debugfs_remove(mwifiex_dfs_dir);
+}
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
new file mode 100644
index 0000000..4e1f115
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -0,0 +1,177 @@
+/*
+ * Marvell Wireless LAN device driver: generic data structures and APIs
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_DECL_H_
+#define _MWIFIEX_DECL_H_
+
+#undef pr_fmt
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/wait.h>
+#include <linux/timer.h>
+#include <linux/ieee80211.h>
+
+
+#define MWIFIEX_MAX_BSS_NUM         (1)
+
+#define MWIFIEX_MIN_DATA_HEADER_LEN 32	/* (sizeof(mwifiex_txpd)) */
+
+#define MWIFIEX_MAX_TX_BASTREAM_SUPPORTED	2
+#define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED	16
+
+#define MWIFIEX_AMPDU_DEF_TXWINSIZE        32
+#define MWIFIEX_AMPDU_DEF_RXWINSIZE        16
+#define MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT  0xffff
+
+#define MWIFIEX_RATE_INDEX_HRDSSS0 0
+#define MWIFIEX_RATE_INDEX_HRDSSS3 3
+#define MWIFIEX_RATE_INDEX_OFDM0   4
+#define MWIFIEX_RATE_INDEX_OFDM7   11
+#define MWIFIEX_RATE_INDEX_MCS0    12
+
+#define MWIFIEX_RATE_BITMAP_OFDM0  16
+#define MWIFIEX_RATE_BITMAP_OFDM7  23
+#define MWIFIEX_RATE_BITMAP_MCS0   32
+#define MWIFIEX_RATE_BITMAP_MCS127 159
+
+#define MWIFIEX_RX_DATA_BUF_SIZE     (4 * 1024)
+#define MWIFIEX_RX_CMD_BUF_SIZE      (2 * 1024)
+
+#define MWIFIEX_RTS_MIN_VALUE              (0)
+#define MWIFIEX_RTS_MAX_VALUE              (2347)
+#define MWIFIEX_FRAG_MIN_VALUE             (256)
+#define MWIFIEX_FRAG_MAX_VALUE             (2346)
+
+#define MWIFIEX_SDIO_BLOCK_SIZE            256
+
+#define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
+
+enum mwifiex_error_code {
+	MWIFIEX_ERROR_NO_ERROR = 0,
+	MWIFIEX_ERROR_FW_NOT_READY = 0x00000001,
+	MWIFIEX_ERROR_FW_BUSY,
+	MWIFIEX_ERROR_FW_CMDRESP,
+	MWIFIEX_ERROR_PKT_SIZE_INVALID = 0x80000001,
+	MWIFIEX_ERROR_PKT_TIMEOUT,
+	MWIFIEX_ERROR_CMD_INVALID,
+	MWIFIEX_ERROR_CMD_TIMEOUT,
+	MWIFIEX_ERROR_CMD_DNLD_FAIL,
+	MWIFIEX_ERROR_CMD_CANCEL,
+	MWIFIEX_ERROR_CMD_RESP_FAIL,
+	MWIFIEX_ERROR_ASSOC_FAIL,
+	MWIFIEX_ERROR_EVENT_UNKNOWN,
+	MWIFIEX_ERROR_INVALID_PARAMETER,
+};
+
+enum mwifiex_bss_type {
+	MWIFIEX_BSS_TYPE_STA = 0,
+	MWIFIEX_BSS_TYPE_UAP = 1,
+	MWIFIEX_BSS_TYPE_ANY = 0xff,
+};
+
+enum mwifiex_bss_role {
+	MWIFIEX_BSS_ROLE_STA = 0,
+	MWIFIEX_BSS_ROLE_UAP = 1,
+	MWIFIEX_BSS_ROLE_ANY = 0xff,
+};
+
+#define BSS_ROLE_BIT_MASK    BIT(0)
+
+#define GET_BSS_ROLE(priv)   ((priv)->bss_role & BSS_ROLE_BIT_MASK)
+
+enum mwifiex_data_frame_type {
+	MWIFIEX_DATA_FRAME_TYPE_ETH_II = 0,
+	MWIFIEX_DATA_FRAME_TYPE_802_11,
+};
+
+struct mwifiex_fw_image {
+	u8 *helper_buf;
+	u32 helper_len;
+	u8 *fw_buf;
+	u32 fw_len;
+};
+
+struct mwifiex_802_11_ssid {
+	u32 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+};
+
+struct mwifiex_wait_queue {
+	u32 bss_index;
+	wait_queue_head_t *wait;
+	u16 *condition;
+	u32 start_time;
+	int status;
+	u32 enabled;
+};
+
+struct mwifiex_rxinfo {
+	u8 bss_index;
+	struct sk_buff *parent;
+	u8 use_count;
+};
+
+struct mwifiex_txinfo {
+	u32 status_code;
+	u8 flags;
+	u8 bss_index;
+};
+
+struct mwifiex_bss_attr {
+	u32 bss_type;
+	u32 frame_type;
+	u32 active;
+	u32 bss_priority;
+	u32 bss_num;
+};
+
+enum mwifiex_cmd_result_e {
+	MWIFIEX_CMD_RESULT_SUCCESS = 0,
+	MWIFIEX_CMD_RESULT_FAILURE = 1,
+	MWIFIEX_CMD_RESULT_TIMEOUT = 2,
+	MWIFIEX_CMD_RESULT_INVALID_DATA = 3
+} __packed;
+
+enum mwifiex_wmm_ac_e {
+	WMM_AC_BK,
+	WMM_AC_BE,
+	WMM_AC_VI,
+	WMM_AC_VO
+} __packed;
+
+enum mwifiex_wmm_queue_config_action_e {
+	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_GET = 0,
+	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_SET = 1,
+	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_DEFAULT = 2,
+	MWIFIEX_WMM_QUEUE_CONFIG_ACTION_MAX
+} __packed;
+
+enum mwifiex_wmm_queue_stats_action_e {
+	MWIFIEX_WMM_STATS_ACTION_START = 0,
+	MWIFIEX_WMM_STATS_ACTION_STOP = 1,
+	MWIFIEX_WMM_STATS_ACTION_GET_CLR = 2,
+	MWIFIEX_WMM_STATS_ACTION_SET_CFG = 3,	/* Not currently used */
+	MWIFIEX_WMM_STATS_ACTION_GET_CFG = 4,	/* Not currently used */
+	MWIFIEX_WMM_STATS_ACTION_MAX
+} __packed;
+
+struct mwifiex_device {
+	struct mwifiex_bss_attr bss_attr[MWIFIEX_MAX_BSS_NUM];
+};
+#endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
new file mode 100644
index 0000000..e5dae45
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -0,0 +1,1376 @@
+/*
+ * Marvell Wireless LAN device driver: Firmware specific macros & structures
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_FW_H_
+#define _MWIFIEX_FW_H_
+
+#include <linux/if_ether.h>
+
+
+#define INTF_HEADER_LEN     4
+
+struct rfc_1042_hdr {
+	u8 llc_dsap;
+	u8 llc_ssap;
+	u8 llc_ctrl;
+	u8 snap_oui[3];
+	u16 snap_type;
+};
+
+struct rx_packet_hdr {
+	struct ethhdr eth803_hdr;
+	struct rfc_1042_hdr rfc1042_hdr;
+};
+
+struct tx_packet_hdr {
+	struct ethhdr eth803_hdr;
+	struct rfc_1042_hdr rfc1042_hdr;
+};
+
+#define B_SUPPORTED_RATES               5
+#define G_SUPPORTED_RATES               9
+#define BG_SUPPORTED_RATES              13
+#define A_SUPPORTED_RATES               9
+#define HOSTCMD_SUPPORTED_RATES         14
+#define N_SUPPORTED_RATES               3
+#define ALL_802_11_BANDS           (BAND_A | BAND_B | BAND_G | BAND_GN)
+
+#define FW_MULTI_BANDS_SUPPORT  (BIT(8) | BIT(9) | BIT(10) | BIT(11))
+#define IS_SUPPORT_MULTI_BANDS(adapter)        \
+	(adapter->fw_cap_info & FW_MULTI_BANDS_SUPPORT)
+#define GET_FW_DEFAULT_BANDS(adapter)  \
+	((adapter->fw_cap_info >> 8) & ALL_802_11_BANDS)
+
+#define SHORT_SLOT_TIME_DISABLED(CapInfo) (CapInfo &= ~BIT(10))
+#define SHORT_SLOT_TIME_ENABLED(CapInfo)  (CapInfo |= BIT(10))
+
+extern u8 supported_rates_b[B_SUPPORTED_RATES];
+extern u8 supported_rates_g[G_SUPPORTED_RATES];
+extern u8 supported_rates_bg[BG_SUPPORTED_RATES];
+extern u8 supported_rates_a[A_SUPPORTED_RATES];
+extern u8 supported_rates_n[N_SUPPORTED_RATES];
+
+#define HostCmd_WEP_KEY_INDEX_MASK              0x3fff
+
+#define KEY_INFO_ENABLED        0x01
+enum KEY_TYPE_ID {
+	KEY_TYPE_ID_WEP = 0,
+	KEY_TYPE_ID_TKIP,
+	KEY_TYPE_ID_AES,
+	KEY_TYPE_ID_WAPI,
+};
+
+enum KEY_INFO_WEP {
+	KEY_INFO_WEP_MCAST = 0x01,
+	KEY_INFO_WEP_UNICAST = 0x02,
+	KEY_INFO_WEP_ENABLED = 0x04
+};
+
+enum KEY_INFO_TKIP {
+	KEY_INFO_TKIP_MCAST = 0x01,
+	KEY_INFO_TKIP_UNICAST = 0x02,
+	KEY_INFO_TKIP_ENABLED = 0x04
+};
+
+enum KEY_INFO_AES {
+	KEY_INFO_AES_MCAST = 0x01,
+	KEY_INFO_AES_UNICAST = 0x02,
+	KEY_INFO_AES_ENABLED = 0x04
+};
+
+#define WAPI_KEY_LEN			50
+
+enum KEY_INFO_WAPI {
+	KEY_INFO_WAPI_MCAST = 0x01,
+	KEY_INFO_WAPI_UNICAST = 0x02,
+	KEY_INFO_WAPI_ENABLED = 0x04
+};
+
+#define MAX_POLL_TRIES			100
+
+#define MAX_MULTI_INTERFACE_POLL_TRIES  1000
+
+#define MAX_FIRMWARE_POLL_TRIES			100
+
+#define FIRMWARE_READY				0xfedc
+
+#define FIRMWARE_TRANSFER_NBLOCK		2
+
+enum MWIFIEX_802_11_PRIVACY_FILTER {
+	MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL,
+	MWIFIEX_802_11_PRIV_FILTER_8021X_WEP
+};
+
+enum MWIFIEX_802_11_WEP_STATUS {
+	MWIFIEX_802_11_WEP_ENABLED,
+	MWIFIEX_802_11_WEP_DISABLED,
+};
+
+#define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
+
+#define PROPRIETARY_TLV_BASE_ID                 0x0100
+#define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
+#define TLV_TYPE_CHANLIST           (PROPRIETARY_TLV_BASE_ID + 1)
+#define TLV_TYPE_NUMPROBES          (PROPRIETARY_TLV_BASE_ID + 2)
+#define TLV_TYPE_RSSI_LOW           (PROPRIETARY_TLV_BASE_ID + 4)
+#define TLV_TYPE_SNR_LOW            (PROPRIETARY_TLV_BASE_ID + 5)
+#define TLV_TYPE_FAILCOUNT          (PROPRIETARY_TLV_BASE_ID + 6)
+#define TLV_TYPE_BCNMISS            (PROPRIETARY_TLV_BASE_ID + 7)
+#define TLV_TYPE_LEDBEHAVIOR        (PROPRIETARY_TLV_BASE_ID + 9)
+#define TLV_TYPE_PASSTHROUGH        (PROPRIETARY_TLV_BASE_ID + 10)
+#define TLV_TYPE_POWER_TBL_2_4GHZ   (PROPRIETARY_TLV_BASE_ID + 12)
+#define TLV_TYPE_POWER_TBL_5GHZ     (PROPRIETARY_TLV_BASE_ID + 13)
+#define TLV_TYPE_WMMQSTATUS         (PROPRIETARY_TLV_BASE_ID + 16)
+#define TLV_TYPE_WILDCARDSSID       (PROPRIETARY_TLV_BASE_ID + 18)
+#define TLV_TYPE_TSFTIMESTAMP       (PROPRIETARY_TLV_BASE_ID + 19)
+#define TLV_TYPE_RSSI_HIGH          (PROPRIETARY_TLV_BASE_ID + 22)
+#define TLV_TYPE_SNR_HIGH           (PROPRIETARY_TLV_BASE_ID + 23)
+
+#define TLV_TYPE_STARTBGSCANLATER   (PROPRIETARY_TLV_BASE_ID + 30)
+#define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
+#define TLV_TYPE_LINK_QUALITY       (PROPRIETARY_TLV_BASE_ID + 36)
+#define TLV_TYPE_RSSI_LOW_DATA      (PROPRIETARY_TLV_BASE_ID + 38)
+#define TLV_TYPE_SNR_LOW_DATA       (PROPRIETARY_TLV_BASE_ID + 39)
+#define TLV_TYPE_RSSI_HIGH_DATA     (PROPRIETARY_TLV_BASE_ID + 40)
+#define TLV_TYPE_SNR_HIGH_DATA      (PROPRIETARY_TLV_BASE_ID + 41)
+
+#define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
+#define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
+
+#define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
+
+#define TLV_TYPE_HT_CAP                  (PROPRIETARY_TLV_BASE_ID + 74)
+#define TLV_TYPE_HT_INFO                 (PROPRIETARY_TLV_BASE_ID + 75)
+#define TLV_SECONDARY_CHANNEL_OFFSET     (PROPRIETARY_TLV_BASE_ID + 76)
+#define TLV_TYPE_2040BSS_COEXISTENCE     (PROPRIETARY_TLV_BASE_ID + 77)
+#define TLV_TYPE_OVERLAP_BSS_SCAN_PARAM  (PROPRIETARY_TLV_BASE_ID + 78)
+#define TLV_TYPE_EXTCAP                  (PROPRIETARY_TLV_BASE_ID + 79)
+#define TLV_TYPE_HT_OPERATIONAL_MCS_SET  (PROPRIETARY_TLV_BASE_ID + 80)
+
+#define ADDBA_TID_MASK   (BIT(2) | BIT(3) | BIT(4) | BIT(5))
+#define DELBA_TID_MASK   (BIT(12) | BIT(13) | BIT(14) | BIT(15))
+#define SSN_MASK         0xfff0
+
+#define BA_RESULT_SUCCESS        0x0
+#define BA_RESULT_FAILURE        0x1
+#define BA_RESULT_TIMEOUT        0x2
+#define BA_RESULT_DATA_INVALID   0x3
+
+#define IS_BASTREAM_SETUP(ptr)  (ptr->ba_status)
+
+#define BA_STREAM_NOT_ALLOWED   0xff
+
+#define IS_11N_ENABLED(priv) ((priv->adapter->config_bands & BAND_GN || \
+			priv->adapter->config_bands & BAND_AN) \
+			&& priv->curr_bss_params.bss_descriptor.bcn_ht_cap)
+#define INITIATOR_BIT(DelBAParamSet) (((DelBAParamSet) &\
+			BIT(DELBA_INITIATOR_POS)) >> DELBA_INITIATOR_POS)
+
+#define MWIFIEX_TX_DATA_BUF_SIZE_4K        4096
+#define MWIFIEX_TX_DATA_BUF_SIZE_8K        8192
+#define MAX_RX_AMPDU_SIZE_64K   0x03
+#define NON_GREENFIELD_STAS     0x04
+
+#define HWSPEC_GREENFIELD_SUPP	 BIT(29)
+#define HWSPEC_RXSTBC_SUPP	 BIT(26)
+#define HWSPEC_SHORTGI40_SUPP	 BIT(24)
+#define HWSPEC_SHORTGI20_SUPP	 BIT(23)
+#define HWSPEC_CHANBW40_SUPP	 BIT(17)
+
+#define DEFAULT_11N_CAP_MASK	(HWSPEC_SHORTGI20_SUPP | HWSPEC_RXSTBC_SUPP)
+#define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
+#define ISSUPP_MAXAMSDU(Dot11nDevCap) (Dot11nDevCap & BIT(31))
+#define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
+#define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
+#define ISSUPP_AMPDU(Dot11nDevCap) (Dot11nDevCap & BIT(28))
+#define ISSUPP_MIMOPS(Dot11nDevCap) (Dot11nDevCap & BIT(27))
+#define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
+#define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
+#define ISSUPP_SHORTGI40(Dot11nDevCap) (Dot11nDevCap & BIT(24))
+#define ISSUPP_SHORTGI20(Dot11nDevCap) (Dot11nDevCap & BIT(23))
+#define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
+#define GET_DELAYEDBACK(Dot11nDevCap) (((Dot11nDevCap >> 20) & 0x03))
+#define GET_IMMEDIATEBACK(Dot11nDevCap) (((Dot11nDevCap >> 18) & 0x03))
+#define ISSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap & BIT(17))
+#define ISSUPP_CHANWIDTH20(Dot11nDevCap) (Dot11nDevCap & BIT(16))
+#define ISSUPP_CHANWIDTH10(Dot11nDevCap) (Dot11nDevCap & BIT(15))
+#define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
+#define ISSUPP_RXANTENNAD(Dot11nDevCap) (Dot11nDevCap & BIT(7))
+#define ISSUPP_RXANTENNAC(Dot11nDevCap) (Dot11nDevCap & BIT(6))
+#define ISSUPP_RXANTENNAB(Dot11nDevCap) (Dot11nDevCap & BIT(5))
+#define ISSUPP_RXANTENNAA(Dot11nDevCap) (Dot11nDevCap & BIT(4))
+#define ISSUPP_TXANTENNAD(Dot11nDevCap) (Dot11nDevCap & BIT(3))
+#define ISSUPP_TXANTENNAC(Dot11nDevCap) (Dot11nDevCap & BIT(2))
+#define ISSUPP_TXANTENNAB(Dot11nDevCap) (Dot11nDevCap & BIT(1))
+#define ISSUPP_TXANTENNAA(Dot11nDevCap) (Dot11nDevCap & BIT(0))
+#define SETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap |= BIT(17))
+#define RESETSUPP_CHANWIDTH40(Dot11nDevCap) (Dot11nDevCap &= ~BIT(17))
+#define GET_TXMCSSUPP(DevMCSSupported) (DevMCSSupported >> 4)
+#define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
+#define GETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo & BIT(1))
+#define GETHT_GREENFIELD(HTCapInfo) (HTCapInfo & BIT(4))
+#define GETHT_SHORTGI20(HTCapInfo) (HTCapInfo & BIT(5))
+#define GETHT_SHORTGI40(HTCapInfo) (HTCapInfo & BIT(6))
+#define GETHT_TXSTBC(HTCapInfo) (HTCapInfo & BIT(7))
+#define GETHT_RXSTBC(HTCapInfo) ((HTCapInfo >> 8) & 0x03)
+#define GETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo & BIT(10))
+#define GETHT_MAXAMSDU(HTCapInfo) (HTCapInfo & BIT(11))
+#define SETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo |= BIT(1))
+#define SETHT_GREENFIELD(HTCapInfo) (HTCapInfo |= BIT(4))
+#define SETHT_SHORTGI20(HTCapInfo) (HTCapInfo |= BIT(5))
+#define SETHT_SHORTGI40(HTCapInfo) (HTCapInfo |= BIT(6))
+#define SETHT_TXSTBC(HTCapInfo) (HTCapInfo |= BIT(7))
+#define SETHT_RXSTBC(HTCapInfo, value) (HTCapInfo |= (value << 8))
+#define SETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo |= BIT(10))
+#define SETHT_MAXAMSDU(HTCapInfo) (HTCapInfo |= BIT(11))
+#define SETHT_DSSSCCK40(HTCapInfo) (HTCapInfo |= BIT(12))
+#define SETHT_40MHZ_INTOLARANT(HTCapInfo) (HTCapInfo |= BIT(14))
+#define RESETHT_SUPPCHANWIDTH(HTCapInfo) (HTCapInfo &= ~BIT(1))
+#define RESETHT_GREENFIELD(HTCapInfo) (HTCapInfo &= ~BIT(4))
+#define RESETHT_SHORTGI20(HTCapInfo) (HTCapInfo &= ~BIT(5))
+#define RESETHT_SHORTGI40(HTCapInfo) (HTCapInfo &= ~BIT(6))
+#define RESETHT_TXSTBC(HTCapInfo) (HTCapInfo &= ~BIT(7))
+#define RESETHT_RXSTBC(HTCapInfo) (HTCapInfo &= ~(0x03 << 8))
+#define RESETHT_DELAYEDBACK(HTCapInfo) (HTCapInfo &= ~BIT(10))
+#define RESETHT_MAXAMSDU(HTCapInfo) (HTCapInfo &= ~BIT(11))
+#define RESETHT_40MHZ_INTOLARANT(HTCapInfo) (HTCapInfo &= ~BIT(14))
+#define RESETHT_EXTCAP_RDG(HTExtCap) (HTExtCap &= ~BIT(11))
+#define SETHT_MCS32(x) (x[4] |= 1)
+#define SETHT_MCS_SET_DEFINED(x) (x[12] |= 1)
+#define SETHT_RX_HIGHEST_DT_SUPP(x, y) ((*(u16 *) (x + 10)) = y)
+#define AMPDU_FACTOR_64K	0x03
+#define SETAMPDU_SIZE(x, y) do { \
+	x = x & ~0x03; \
+	x |= y & 0x03; \
+} while (0) \
+
+#define SETAMPDU_SPACING(x, y) do { \
+	x = x & ~0x1c; \
+	x |= (y & 0x07) << 2; \
+} while (0) \
+
+#define ISSUPP_BANDA(FwCapInfo) (FwCapInfo & BIT(10))
+#define ISALLOWED_CHANWIDTH40(Field2) (Field2 & BIT(2))
+#define SET_CHANWIDTH40(Field2) (Field2 |= BIT(2))
+#define RESET_CHANWIDTH40(Field2) (Field2 &= ~(BIT(0) | BIT(1) | BIT(2)))
+#define GET_SECONDARYCHAN(Field2) (Field2 & (BIT(0) | BIT(1)))
+#define SET_SECONDARYCHAN(RadioType, SECCHAN) (RadioType |= (SECCHAN << 4))
+
+#define LLC_SNAP_LEN    8
+
+#define TLV_TYPE_RATE_DROP_PATTERN  (PROPRIETARY_TLV_BASE_ID + 81)
+#define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
+#define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
+
+#define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
+
+#define MOD_CLASS_HR_DSSS       0x03
+#define MOD_CLASS_OFDM          0x07
+#define MOD_CLASS_HT            0x08
+#define HT_BW_20    0
+#define HT_BW_40    1
+
+#define HostCmd_CMD_GET_HW_SPEC                       0x0003
+#define HostCmd_CMD_802_11_SCAN                       0x0006
+#define HostCmd_CMD_802_11_GET_LOG                    0x000b
+#define HostCmd_CMD_MAC_MULTICAST_ADR                 0x0010
+#define HostCmd_CMD_802_11_EEPROM_ACCESS              0x0059
+#define HostCmd_CMD_802_11_ASSOCIATE                  0x0012
+#define HostCmd_CMD_802_11_SNMP_MIB                   0x0016
+#define HostCmd_CMD_MAC_REG_ACCESS                    0x0019
+#define HostCmd_CMD_BBP_REG_ACCESS                    0x001a
+#define HostCmd_CMD_RF_REG_ACCESS                     0x001b
+#define HostCmd_CMD_PMIC_REG_ACCESS                   0x00ad
+#define HostCmd_CMD_802_11_RF_CHANNEL                 0x001d
+#define HostCmd_CMD_802_11_DEAUTHENTICATE             0x0024
+#define HostCmd_CMD_MAC_CONTROL                       0x0028
+#define HostCmd_CMD_802_11_AD_HOC_START               0x002b
+#define HostCmd_CMD_802_11_AD_HOC_JOIN                0x002c
+#define HostCmd_CMD_802_11_AD_HOC_STOP                0x0040
+#define HostCmd_CMD_802_11_MAC_ADDRESS                0x004D
+#define HostCmd_CMD_802_11D_DOMAIN_INFO               0x005b
+#define HostCmd_CMD_802_11_KEY_MATERIAL               0x005e
+#define HostCmd_CMD_802_11_BG_SCAN_QUERY              0x006c
+#define HostCmd_CMD_WMM_GET_STATUS                    0x0071
+#define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
+#define HostCmd_CMD_802_11_IBSS_COALESCING_STATUS     0x0083
+#define HostCmd_CMD_VERSION_EXT                       0x0097
+#define HostCmd_CMD_RSSI_INFO                         0x00a4
+#define HostCmd_CMD_FUNC_INIT                         0x00a9
+#define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
+#define HostCmd_CMD_11N_CFG                           0x00cd
+#define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
+#define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
+#define HostCmd_CMD_11N_DELBA                         0x00d0
+#define HostCmd_CMD_RECONFIGURE_TX_BUFF               0x00d9
+#define HostCmd_CMD_AMSDU_AGGR_CTRL                   0x00df
+#define HostCmd_CMD_TXPWR_CFG                         0x00d1
+#define HostCmd_CMD_TX_RATE_CFG                       0x00d6
+#define HostCmd_CMD_802_11_PS_MODE_ENH                0x00e4
+#define HostCmd_CMD_802_11_HS_CFG_ENH                 0x00e5
+#define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
+#define HostCmd_CMD_SET_BSS_MODE                      0x00f7
+
+
+enum ENH_PS_MODES {
+	EN_PS = 1,
+	DIS_PS = 2,
+	EN_AUTO_DS = 3,
+	DIS_AUTO_DS = 4,
+	SLEEP_CONFIRM = 5,
+	GET_PS = 0,
+	EN_AUTO_PS = 0xff,
+	DIS_AUTO_PS = 0xfe,
+};
+
+#define HostCmd_RET_BIT                       0x8000
+#define HostCmd_ACT_GEN_GET                   0x0000
+#define HostCmd_ACT_GEN_SET                   0x0001
+#define HostCmd_ACT_GEN_REMOVE                0x0004
+#define HostCmd_ACT_SET_BOTH                  0x0003
+#define HostCmd_ACT_GET_BOTH                  0x000c
+#define HostCmd_RESULT_OK                     0x0000
+#define HostCmd_RESULT_ERROR                  0x0001
+#define HostCmd_RESULT_NOT_SUPPORT            0x0002
+#define HostCmd_RESULT_PENDING                0x0003
+#define HostCmd_RESULT_BUSY                   0x0004
+#define HostCmd_RESULT_PARTIAL_DATA           0x0005
+
+#define HostCmd_ACT_MAC_RX_ON                 0x0001
+#define HostCmd_ACT_MAC_TX_ON                 0x0002
+#define HostCmd_ACT_MAC_WEP_ENABLE            0x0008
+#define HostCmd_ACT_MAC_ETHERNETII_ENABLE     0x0010
+#define HostCmd_ACT_MAC_PROMISCUOUS_ENABLE    0x0080
+#define HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE  0x0100
+#define HostCmd_ACT_MAC_RTS_CTS_ENABLE        0x0200
+#define HostCmd_ACT_MAC_STRICT_PROTECTION_ENABLE  0x0400
+#define HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON     0x2000
+
+#define HostCmd_BSS_MODE_BSS                0x0001
+#define HostCmd_BSS_MODE_IBSS               0x0002
+#define HostCmd_BSS_MODE_ANY                0x0003
+
+#define HostCmd_SCAN_RADIO_TYPE_BG          0
+#define HostCmd_SCAN_RADIO_TYPE_A           1
+
+#define HOST_SLEEP_CFG_CANCEL		0xffffffff
+#define HOST_SLEEP_CFG_COND_DEF		0x0000000f
+#define HOST_SLEEP_CFG_GPIO_DEF		0xff
+#define HOST_SLEEP_CFG_GAP_DEF		0
+
+#define CMD_F_HOSTCMD           (1 << 0)
+#define CMD_F_CANCELED          (1 << 1)
+
+#define HostCmd_CMD_ID_MASK             0x0fff
+
+#define HostCmd_SEQ_NUM_MASK            0x00ff
+
+#define HostCmd_BSS_NUM_MASK            0x0f00
+
+#define HostCmd_BSS_TYPE_MASK           0xf000
+
+#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
+	(((seq) & 0x00ff) |                             \
+	 (((num) & 0x000f) << 8)) |                     \
+	(((type) & 0x000f) << 12);                  }
+
+#define HostCmd_GET_SEQ_NO(seq)       \
+	((seq) & HostCmd_SEQ_NUM_MASK)
+
+#define HostCmd_GET_BSS_NO(seq)         \
+	(((seq) & HostCmd_BSS_NUM_MASK) >> 8)
+
+#define HostCmd_GET_BSS_TYPE(seq)       \
+	(((seq) & HostCmd_BSS_TYPE_MASK) >> 12)
+
+#define EVENT_DUMMY_HOST_WAKEUP_SIGNAL  0x00000001
+#define EVENT_LINK_LOST                 0x00000003
+#define EVENT_LINK_SENSED               0x00000004
+#define EVENT_MIB_CHANGED               0x00000006
+#define EVENT_INIT_DONE                 0x00000007
+#define EVENT_DEAUTHENTICATED           0x00000008
+#define EVENT_DISASSOCIATED             0x00000009
+#define EVENT_PS_AWAKE                  0x0000000a
+#define EVENT_PS_SLEEP                  0x0000000b
+#define EVENT_MIC_ERR_MULTICAST         0x0000000d
+#define EVENT_MIC_ERR_UNICAST           0x0000000e
+#define EVENT_DEEP_SLEEP_AWAKE          0x00000010
+#define EVENT_ADHOC_BCN_LOST            0x00000011
+
+#define EVENT_WMM_STATUS_CHANGE         0x00000017
+#define EVENT_BG_SCAN_REPORT            0x00000018
+#define EVENT_RSSI_LOW                  0x00000019
+#define EVENT_SNR_LOW                   0x0000001a
+#define EVENT_MAX_FAIL                  0x0000001b
+#define EVENT_RSSI_HIGH                 0x0000001c
+#define EVENT_SNR_HIGH                  0x0000001d
+#define EVENT_IBSS_COALESCED            0x0000001e
+#define EVENT_DATA_RSSI_LOW             0x00000024
+#define EVENT_DATA_SNR_LOW              0x00000025
+#define EVENT_DATA_RSSI_HIGH            0x00000026
+#define EVENT_DATA_SNR_HIGH             0x00000027
+#define EVENT_LINK_QUALITY              0x00000028
+#define EVENT_PORT_RELEASE              0x0000002b
+#define EVENT_PRE_BEACON_LOST           0x00000031
+#define EVENT_ADDBA                     0x00000033
+#define EVENT_DELBA                     0x00000034
+#define EVENT_BA_STREAM_TIEMOUT         0x00000037
+#define EVENT_AMSDU_AGGR_CTRL           0x00000042
+#define EVENT_WEP_ICV_ERR               0x00000046
+#define EVENT_HS_ACT_REQ                0x00000047
+#define EVENT_BW_CHANGE                 0x00000048
+
+#define EVENT_HOSTWAKE_STAIE		0x0000004d
+
+#define EVENT_ID_MASK                   0xffff
+#define BSS_NUM_MASK                    0xf
+
+#define EVENT_GET_BSS_NUM(event_cause)          \
+	(((event_cause) >> 16) & BSS_NUM_MASK)
+
+#define EVENT_GET_BSS_TYPE(event_cause)         \
+	(((event_cause) >> 24) & 0x00ff)
+
+struct mwifiex_event_wep_icv_err {
+	u16 reason_code;
+	u8 src_mac_addr[ETH_ALEN];
+	u8 wep_key_index;
+	u8 wep_key_length;
+	u8 key[WLAN_KEY_LEN_WEP104];
+};
+
+struct mwifiex_802_11_fixed_ies {
+	u8 time_stamp[8];
+	__le16 beacon_interval;
+	__le16 capabilities;
+};
+
+struct mwifiex_ie_types_header {
+	__le16 type;
+	__le16 len;
+} __packed;
+
+struct mwifiex_ie_types_data {
+	struct mwifiex_ie_types_header header;
+	u8 data[1];
+} __packed;
+
+#define MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET 0x01
+#define MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET 0x08
+
+struct txpd {
+	u8 bss_type;
+	u8 bss_num;
+	__le16 tx_pkt_length;
+	__le16 tx_pkt_offset;
+	__le16 tx_pkt_type;
+	__le32 tx_control;
+	u8 priority;
+	u8 flags;
+	u8 pkt_delay_2ms;
+	u8 reserved1;
+} __packed;
+
+struct rxpd {
+	u8 bss_type;
+	u8 bss_num;
+	u16 rx_pkt_length;
+	u16 rx_pkt_offset;
+	u16 rx_pkt_type;
+	u16 seq_num;
+	u8 priority;
+	u8 rx_rate;
+	s8 snr;
+	s8 nf;
+	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
+	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
+	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
+	u8 ht_info;
+	u8 reserved;
+} __packed;
+
+enum mwifiex_chan_scan_mode_bitmasks {
+	MWIFIEX_PASSIVE_SCAN = BIT(0),
+	MWIFIEX_DISABLE_CHAN_FILT = BIT(1),
+};
+
+#define SECOND_CHANNEL_BELOW    0x30
+#define SECOND_CHANNEL_ABOVE    0x10
+struct mwifiex_chan_scan_param_set {
+	u8 radio_type;
+	u8 chan_number;
+	u8 chan_scan_mode_bitmap;
+	__le16 min_scan_time;
+	__le16 max_scan_time;
+} __packed;
+
+struct mwifiex_ie_types_chan_list_param_set {
+	struct mwifiex_ie_types_header header;
+	struct mwifiex_chan_scan_param_set chan_scan_param[1];
+} __packed;
+
+struct chan_band_param_set {
+	u8 radio_type;
+	u8 chan_number;
+};
+
+struct mwifiex_ie_types_chan_band_list_param_set {
+	struct mwifiex_ie_types_header header;
+	struct chan_band_param_set chan_band_param[1];
+} __packed;
+
+struct mwifiex_ie_types_rates_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 rates[1];
+} __packed;
+
+struct mwifiex_ie_types_ssid_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 ssid[1];
+} __packed;
+
+struct mwifiex_ie_types_num_probes {
+	struct mwifiex_ie_types_header header;
+	__le16 num_probes;
+} __packed;
+
+struct mwifiex_ie_types_wildcard_ssid_params {
+	struct mwifiex_ie_types_header header;
+	u8 max_ssid_length;
+	u8 ssid[1];
+} __packed;
+
+#define TSF_DATA_SIZE            8
+struct mwifiex_ie_types_tsf_timestamp {
+	struct mwifiex_ie_types_header header;
+	u8 tsf_data[1];
+} __packed;
+
+struct mwifiex_cf_param_set {
+	u8 cfp_cnt;
+	u8 cfp_period;
+	u16 cfp_max_duration;
+	u16 cfp_duration_remaining;
+} __packed;
+
+struct mwifiex_ibss_param_set {
+	u16 atim_window;
+} __packed;
+
+struct mwifiex_ie_types_ss_param_set {
+	struct mwifiex_ie_types_header header;
+	union {
+		struct mwifiex_cf_param_set cf_param_set[1];
+		struct mwifiex_ibss_param_set ibss_param_set[1];
+	} cf_ibss;
+} __packed;
+
+struct mwifiex_fh_param_set {
+	u16 dwell_time;
+	u8 hop_set;
+	u8 hop_pattern;
+	u8 hop_index;
+} __packed;
+
+struct mwifiex_ds_param_set {
+	u8 current_chan;
+} __packed;
+
+struct mwifiex_ie_types_phy_param_set {
+	struct mwifiex_ie_types_header header;
+	union {
+		struct mwifiex_fh_param_set fh_param_set[1];
+		struct mwifiex_ds_param_set ds_param_set[1];
+	} fh_ds;
+} __packed;
+
+struct mwifiex_ie_types_auth_type {
+	struct mwifiex_ie_types_header header;
+	__le16 auth_type;
+} __packed;
+
+struct mwifiex_ie_types_vendor_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 ie[MWIFIEX_MAX_VSIE_LEN];
+};
+
+struct mwifiex_ie_types_rsn_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 rsn_ie[1];
+} __packed;
+
+#define KEYPARAMSET_FIXED_LEN 6
+
+struct mwifiex_ie_type_key_param_set {
+	__le16 type;
+	__le16 length;
+	__le16 key_type_id;
+	__le16 key_info;
+	__le16 key_len;
+	u8 key[50];
+} __packed;
+
+struct host_cmd_ds_802_11_key_material {
+	__le16 action;
+	struct mwifiex_ie_type_key_param_set key_param_set;
+} __packed;
+
+struct host_cmd_ds_gen {
+	u16 command;
+	u16 size;
+	u16 seq_num;
+	u16 result;
+};
+
+#define S_DS_GEN        sizeof(struct host_cmd_ds_gen)
+
+enum sleep_resp_ctrl {
+	RESP_NOT_NEEDED = 0,
+	RESP_NEEDED,
+};
+
+struct mwifiex_ps_param {
+	__le16 null_pkt_interval;
+	__le16 multiple_dtims;
+	__le16 bcn_miss_timeout;
+	__le16 local_listen_interval;
+	__le16 adhoc_wake_period;
+	__le16 mode;
+	__le16 delay_to_ps;
+};
+
+struct mwifiex_auto_ds_param {
+	__le16 deep_sleep_timeout;
+};
+
+struct sleep_confirm_param {
+	__le16 resp_ctrl;
+};
+
+#define BITMAP_AUTO_DS         0x01
+#define BITMAP_STA_PS          0x10
+#define BITMAP_UAP_INACT_PS    0x100
+#define BITMAP_UAP_DTIM_PS     0x200
+struct auto_ps_param {
+	__le16 ps_bitmap;
+	/* auto deep sleep parameter,
+	 * sta power save parameter
+	 * uap inactivity parameter
+	 * uap DTIM parameter */
+};
+
+#define AUTO_PS_FIX_SIZE    4
+
+#define TLV_TYPE_AUTO_DS_PARAM        (PROPRIETARY_TLV_BASE_ID + 113)
+#define TLV_TYPE_PS_PARAM             (PROPRIETARY_TLV_BASE_ID + 114)
+
+struct mwifiex_ie_types_auto_ds_param {
+	struct mwifiex_ie_types_header header;
+	struct mwifiex_auto_ds_param param;
+} __packed;
+
+struct mwifiex_ie_types_ps_param {
+	struct mwifiex_ie_types_header header;
+	struct mwifiex_ps_param param;
+} __packed;
+
+struct host_cmd_ds_802_11_ps_mode_enh {
+	__le16 action;
+
+	union {
+		struct mwifiex_ps_param opt_ps;
+		struct mwifiex_auto_ds_param auto_ds;
+		struct sleep_confirm_param sleep_cfm;
+		__le16 ps_bitmap;
+		struct auto_ps_param auto_ps;
+	} params;
+} __packed;
+
+struct host_cmd_ds_get_hw_spec {
+	__le16 hw_if_version;
+	__le16 version;
+	__le16 reserved;
+	__le16 num_of_mcast_adr;
+	u8 permanent_addr[ETH_ALEN];
+	__le16 region_code;
+	__le16 number_of_antenna;
+	__le32 fw_release_number;
+	__le32 reserved_1;
+	__le32 reserved_2;
+	__le32 reserved_3;
+	__le32 fw_cap_info;
+	__le32 dot_11n_dev_cap;
+	u8 dev_mcs_support;
+	__le16 mp_end_port;	/* SDIO only, reserved for other interfacces */
+	__le16 reserved_4;
+} __packed;
+
+struct host_cmd_ds_802_11_rssi_info {
+	__le16 action;
+	__le16 ndata;
+	__le16 nbcn;
+	__le16 reserved[9];
+	long long reserved_1;
+};
+
+struct host_cmd_ds_802_11_rssi_info_rsp {
+	__le16 action;
+	__le16 ndata;
+	__le16 nbcn;
+	__le16 data_rssi_last;
+	__le16 data_nf_last;
+	__le16 data_rssi_avg;
+	__le16 data_nf_avg;
+	__le16 bcn_rssi_last;
+	__le16 bcn_nf_last;
+	__le16 bcn_rssi_avg;
+	__le16 bcn_nf_avg;
+	long long tsf_bcn;
+};
+
+struct host_cmd_ds_802_11_mac_address {
+	__le16 action;
+	u8 mac_addr[ETH_ALEN];
+};
+
+struct host_cmd_ds_mac_control {
+	__le16 action;
+	__le16 reserved;
+};
+
+struct host_cmd_ds_mac_multicast_adr {
+	__le16 action;
+	__le16 num_of_adrs;
+	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
+} __packed;
+
+struct host_cmd_ds_802_11_deauthenticate {
+	u8 mac_addr[ETH_ALEN];
+	__le16 reason_code;
+} __packed;
+
+struct host_cmd_ds_802_11_associate {
+	u8 peer_sta_addr[ETH_ALEN];
+	__le16 cap_info_bitmap;
+	__le16 listen_interval;
+	__le16 beacon_period;
+	u8 dtim_period;
+} __packed;
+
+struct ieee_types_assoc_rsp {
+	__le16 cap_info_bitmap;
+	__le16 status_code;
+	__le16 a_id;
+	u8 ie_buffer[1];
+} __packed;
+
+struct host_cmd_ds_802_11_associate_rsp {
+	struct ieee_types_assoc_rsp assoc_rsp;
+} __packed;
+
+struct ieee_types_cf_param_set {
+	u8 element_id;
+	u8 len;
+	u8 cfp_cnt;
+	u8 cfp_period;
+	u16 cfp_max_duration;
+	u16 cfp_duration_remaining;
+} __packed;
+
+struct ieee_types_ibss_param_set {
+	u8 element_id;
+	u8 len;
+	__le16 atim_window;
+} __packed;
+
+union ieee_types_ss_param_set {
+	struct ieee_types_cf_param_set cf_param_set;
+	struct ieee_types_ibss_param_set ibss_param_set;
+} __packed;
+
+struct ieee_types_fh_param_set {
+	u8 element_id;
+	u8 len;
+	__le16 dwell_time;
+	u8 hop_set;
+	u8 hop_pattern;
+	u8 hop_index;
+} __packed;
+
+struct ieee_types_ds_param_set {
+	u8 element_id;
+	u8 len;
+	u8 current_chan;
+} __packed;
+
+union ieee_types_phy_param_set {
+	struct ieee_types_fh_param_set fh_param_set;
+	struct ieee_types_ds_param_set ds_param_set;
+} __packed;
+
+struct host_cmd_ds_802_11_ad_hoc_start {
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 bss_mode;
+	__le16 beacon_period;
+	u8 dtim_period;
+	union ieee_types_ss_param_set ss_param_set;
+	union ieee_types_phy_param_set phy_param_set;
+	u16 reserved1;
+	__le16 cap_info_bitmap;
+	u8 DataRate[HOSTCMD_SUPPORTED_RATES];
+} __packed;
+
+struct host_cmd_ds_802_11_ad_hoc_result {
+	u8 pad[3];
+	u8 bssid[ETH_ALEN];
+} __packed;
+
+struct adhoc_bss_desc {
+	u8 bssid[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 bss_mode;
+	__le16 beacon_period;
+	u8 dtim_period;
+	u8 time_stamp[8];
+	u8 local_time[8];
+	union ieee_types_phy_param_set phy_param_set;
+	union ieee_types_ss_param_set ss_param_set;
+	__le16 cap_info_bitmap;
+	u8 data_rates[HOSTCMD_SUPPORTED_RATES];
+
+	/*
+	 *  DO NOT ADD ANY FIELDS TO THIS STRUCTURE.
+	 *  It is used in the Adhoc join command and will cause a
+	 *  binary layout mismatch with the firmware
+	 */
+} __packed;
+
+struct host_cmd_ds_802_11_ad_hoc_join {
+	struct adhoc_bss_desc bss_descriptor;
+	u16 reserved1;
+	u16 reserved2;
+} __packed;
+
+struct host_cmd_ds_802_11_get_log {
+	__le32 mcast_tx_frame;
+	__le32 failed;
+	__le32 retry;
+	__le32 multi_retry;
+	__le32 frame_dup;
+	__le32 rts_success;
+	__le32 rts_failure;
+	__le32 ack_failure;
+	__le32 rx_frag;
+	__le32 mcast_rx_frame;
+	__le32 fcs_error;
+	__le32 tx_frame;
+	__le32 reserved;
+	__le32 wep_icv_err_cnt[4];
+};
+
+struct host_cmd_ds_tx_rate_query {
+	u8 tx_rate;
+	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
+	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
+	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
+	u8 ht_info;
+} __packed;
+
+enum Host_Sleep_Action {
+	HS_CONFIGURE = 0x0001,
+	HS_ACTIVATE  = 0x0002,
+};
+
+struct mwifiex_hs_config_param {
+	__le32 conditions;
+	u8 gpio;
+	u8 gap;
+} __packed;
+
+struct hs_activate_param {
+	u16 resp_ctrl;
+} __packed;
+
+struct host_cmd_ds_802_11_hs_cfg_enh {
+	__le16 action;
+
+	union {
+		struct mwifiex_hs_config_param hs_config;
+		struct hs_activate_param hs_activate;
+	} params;
+} __packed;
+
+enum SNMP_MIB_INDEX {
+	OP_RATE_SET_I = 1,
+	DTIM_PERIOD_I = 3,
+	RTS_THRESH_I = 5,
+	SHORT_RETRY_LIM_I = 6,
+	LONG_RETRY_LIM_I = 7,
+	FRAG_THRESH_I = 8,
+	DOT11D_I = 9,
+};
+
+#define MAX_SNMP_BUF_SIZE   128
+
+struct host_cmd_ds_802_11_snmp_mib {
+	__le16 query_type;
+	__le16 oid;
+	__le16 buf_size;
+	u8 value[1];
+} __packed;
+
+#define RADIO_ON                                0x01
+#define RADIO_OFF                               0x00
+
+struct mwifiex_rate_scope {
+	__le16 type;
+	__le16 length;
+	__le16 hr_dsss_rate_bitmap;
+	__le16 ofdm_rate_bitmap;
+	__le16 ht_mcs_rate_bitmap[8];
+} __packed;
+
+struct mwifiex_rate_drop_pattern {
+	__le16 type;
+	__le16 length;
+	__le32 rate_drop_mode;
+} __packed;
+
+struct host_cmd_ds_tx_rate_cfg {
+	__le16 action;
+	__le16 cfg_index;
+} __packed;
+
+struct mwifiex_power_group {
+	u8 modulation_class;
+	u8 first_rate_code;
+	u8 last_rate_code;
+	s8 power_step;
+	s8 power_min;
+	s8 power_max;
+	u8 ht_bandwidth;
+	u8 reserved;
+} __packed;
+
+struct mwifiex_types_power_group {
+	u16 type;
+	u16 length;
+} __packed;
+
+struct host_cmd_ds_txpwr_cfg {
+	__le16 action;
+	__le16 cfg_index;
+	__le32 mode;
+} __packed;
+
+#define MWIFIEX_USER_SCAN_CHAN_MAX             50
+
+#define MWIFIEX_MAX_SSID_LIST_LENGTH         10
+
+struct mwifiex_scan_cmd_config {
+	/*
+	 *  BSS Type to be sent in the firmware command
+	 *
+	 *  Field can be used to restrict the types of networks returned in the
+	 *    scan.  Valid settings are:
+	 *
+	 *   - MWIFIEX_SCAN_MODE_BSS  (infrastructure)
+	 *   - MWIFIEX_SCAN_MODE_IBSS (adhoc)
+	 *   - MWIFIEX_SCAN_MODE_ANY  (unrestricted, adhoc and infrastructure)
+	 */
+	u8 bss_mode;
+
+	/* Specific BSSID used to filter scan results in the firmware */
+	u8 specific_bssid[ETH_ALEN];
+
+	/* Length of TLVs sent in command starting at tlvBuffer */
+	u32 tlv_buf_len;
+
+	/*
+	 *  SSID TLV(s) and ChanList TLVs to be sent in the firmware command
+	 *
+	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
+	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
+	 */
+	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
+				   here */
+} __packed;
+
+struct mwifiex_user_scan_chan {
+	u8 chan_number;
+	u8 radio_type;
+	u8 scan_type;
+	u8 reserved;
+	u32 scan_time;
+} __packed;
+
+struct mwifiex_user_scan_ssid {
+	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
+	u8 max_len;
+} __packed;
+
+struct mwifiex_user_scan_cfg {
+	/*
+	 *  Flag set to keep the previous scan table intact
+	 *
+	 *  If set, the scan results will accumulate, replacing any previous
+	 *   matched entries for a BSS with the new scan data
+	 */
+	u8 keep_previous_scan;
+	/*
+	 *  BSS mode to be sent in the firmware command
+	 *
+	 *  Field can be used to restrict the types of networks returned in the
+	 *    scan.  Valid settings are:
+	 *
+	 *   - MWIFIEX_SCAN_MODE_BSS  (infrastructure)
+	 *   - MWIFIEX_SCAN_MODE_IBSS (adhoc)
+	 *   - MWIFIEX_SCAN_MODE_ANY  (unrestricted, adhoc and infrastructure)
+	 */
+	u8 bss_mode;
+	/* Configure the number of probe requests for active chan scans */
+	u8 num_probes;
+	u8 reserved;
+	/* BSSID filter sent in the firmware command to limit the results */
+	u8 specific_bssid[ETH_ALEN];
+	/* SSID filter list used in the to limit the scan results */
+	struct mwifiex_user_scan_ssid ssid_list[MWIFIEX_MAX_SSID_LIST_LENGTH];
+	/* Variable number (fixed maximum) of channels to scan up */
+	struct mwifiex_user_scan_chan chan_list[MWIFIEX_USER_SCAN_CHAN_MAX];
+} __packed;
+
+struct ie_body {
+	u8 grp_key_oui[4];
+	u8 ptk_cnt[2];
+	u8 ptk_body[4];
+} __packed;
+
+struct host_cmd_ds_802_11_scan {
+	u8 bss_mode;
+	u8 bssid[ETH_ALEN];
+	u8 tlv_buffer[1];
+} __packed;
+
+struct host_cmd_ds_802_11_scan_rsp {
+	__le16 bss_descript_size;
+	u8 number_of_sets;
+	u8 bss_desc_and_tlv_buffer[1];
+} __packed;
+
+struct host_cmd_ds_802_11_bg_scan_query {
+	u8 flush;
+} __packed;
+
+struct host_cmd_ds_802_11_bg_scan_query_rsp {
+	u32 report_condition;
+	struct host_cmd_ds_802_11_scan_rsp scan_resp;
+} __packed;
+
+struct mwifiex_ietypes_domain_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
+	struct ieee80211_country_ie_triplet triplet[1];
+} __packed;
+
+struct host_cmd_ds_802_11d_domain_info {
+	__le16 action;
+	struct mwifiex_ietypes_domain_param_set domain;
+} __packed;
+
+struct host_cmd_ds_802_11d_domain_info_rsp {
+	__le16 action;
+	struct mwifiex_ietypes_domain_param_set domain;
+} __packed;
+
+struct host_cmd_ds_11n_addba_req {
+	u8 add_req_result;
+	u8 peer_mac_addr[ETH_ALEN];
+	u8 dialog_token;
+	__le16 block_ack_param_set;
+	__le16 block_ack_tmo;
+	__le16 ssn;
+} __packed;
+
+struct host_cmd_ds_11n_addba_rsp {
+	u8 add_rsp_result;
+	u8 peer_mac_addr[ETH_ALEN];
+	u8 dialog_token;
+	__le16 status_code;
+	__le16 block_ack_param_set;
+	__le16 block_ack_tmo;
+	__le16 ssn;
+} __packed;
+
+struct host_cmd_ds_11n_delba {
+	u8 del_result;
+	u8 peer_mac_addr[ETH_ALEN];
+	__le16 del_ba_param_set;
+	__le16 reason_code;
+	u8 reserved;
+} __packed;
+
+struct host_cmd_ds_11n_batimeout {
+	u8 tid;
+	u8 peer_mac_addr[ETH_ALEN];
+	u8 origninator;
+} __packed;
+
+struct host_cmd_ds_11n_cfg {
+	__le16 action;
+	__le16 ht_tx_cap;
+	__le16 ht_tx_info;
+} __packed;
+
+struct host_cmd_ds_txbuf_cfg {
+	__le16 action;
+	__le16 buff_size;
+	__le16 mp_end_port;	/* SDIO only, reserved for other interfacces */
+	__le16 reserved3;
+} __packed;
+
+struct host_cmd_ds_amsdu_aggr_ctrl {
+	__le16 action;
+	__le16 enable;
+	__le16 curr_buf_size;
+} __packed;
+
+struct mwifiex_ie_types_wmm_param_set {
+	struct mwifiex_ie_types_header header;
+	u8 wmm_ie[1];
+};
+
+struct mwifiex_ie_types_wmm_queue_status {
+	struct mwifiex_ie_types_header header;
+	u8 queue_index;
+	u8 disabled;
+	u16 medium_time;
+	u8 flow_required;
+	u8 flow_created;
+	u32 reserved;
+};
+
+struct ieee_types_vendor_header {
+	u8 element_id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+	u8 oui_subtype;
+	u8 version;
+} __packed;
+
+struct ieee_types_wmm_ac_parameters {
+	u8 aci_aifsn_bitmap;
+	u8 ecw_bitmap;
+	__le16 tx_op_limit;
+} __packed;
+
+struct ieee_types_wmm_parameter {
+	/*
+	 * WMM Parameter IE - Vendor Specific Header:
+	 *   element_id  [221/0xdd]
+	 *   Len         [24]
+	 *   Oui         [00:50:f2]
+	 *   OuiType     [2]
+	 *   OuiSubType  [1]
+	 *   Version     [1]
+	 */
+	struct ieee_types_vendor_header vend_hdr;
+	u8 qos_info_bitmap;
+	u8 reserved;
+	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
+} __packed;
+
+struct ieee_types_wmm_info {
+
+	/*
+	 * WMM Info IE - Vendor Specific Header:
+	 *   element_id  [221/0xdd]
+	 *   Len         [7]
+	 *   Oui         [00:50:f2]
+	 *   OuiType     [2]
+	 *   OuiSubType  [0]
+	 *   Version     [1]
+	 */
+	struct ieee_types_vendor_header vend_hdr;
+
+	u8 qos_info_bitmap;
+} __packed;
+
+struct host_cmd_ds_wmm_get_status {
+	u8 queue_status_tlv[sizeof(struct mwifiex_ie_types_wmm_queue_status) *
+			      IEEE80211_MAX_QUEUES];
+	u8 wmm_param_tlv[sizeof(struct ieee_types_wmm_parameter) + 2];
+} __packed;
+
+struct mwifiex_wmm_ac_status {
+	u8 disabled;
+	u8 flow_required;
+	u8 flow_created;
+};
+
+struct mwifiex_ie_types_htcap {
+	struct mwifiex_ie_types_header header;
+	struct ieee80211_ht_cap ht_cap;
+} __packed;
+
+struct mwifiex_ie_types_htinfo {
+	struct mwifiex_ie_types_header header;
+	struct ieee80211_ht_info ht_info;
+} __packed;
+
+struct mwifiex_ie_types_2040bssco {
+	struct mwifiex_ie_types_header header;
+	u8 bss_co_2040;
+} __packed;
+
+struct mwifiex_ie_types_extcap {
+	struct mwifiex_ie_types_header header;
+	u8 ext_cap;
+} __packed;
+
+struct host_cmd_ds_mac_reg_access {
+	__le16 action;
+	__le16 offset;
+	__le32 value;
+} __packed;
+
+struct host_cmd_ds_bbp_reg_access {
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 reserved[3];
+} __packed;
+
+struct host_cmd_ds_rf_reg_access {
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 reserved[3];
+} __packed;
+
+struct host_cmd_ds_pmic_reg_access {
+	__le16 action;
+	__le16 offset;
+	u8 value;
+	u8 reserved[3];
+} __packed;
+
+struct host_cmd_ds_802_11_eeprom_access {
+	__le16 action;
+
+	__le16 offset;
+	__le16 byte_count;
+	u8 value;
+} __packed;
+
+struct host_cmd_ds_802_11_rf_channel {
+	__le16 action;
+	__le16 current_channel;
+	__le16 rf_type;
+	__le16 reserved;
+	u8 reserved_1[32];
+} __packed;
+
+struct host_cmd_ds_version_ext {
+	u8 version_str_sel;
+	char version_str[128];
+} __packed;
+
+struct host_cmd_ds_802_11_ibss_status {
+	__le16 action;
+	__le16 enable;
+	u8 bssid[ETH_ALEN];
+	__le16 beacon_interval;
+	__le16 atim_window;
+	__le16 use_g_rate_protect;
+} __packed;
+
+#define CONNECTION_TYPE_INFRA   0
+#define CONNECTION_TYPE_ADHOC   1
+
+struct host_cmd_ds_set_bss_mode {
+	u8 con_type;
+} __packed;
+
+struct host_cmd_ds_command {
+	__le16 command;
+	__le16 size;
+	__le16 seq_num;
+	__le16 result;
+	union {
+		struct host_cmd_ds_get_hw_spec hw_spec;
+		struct host_cmd_ds_mac_control mac_ctrl;
+		struct host_cmd_ds_802_11_mac_address mac_addr;
+		struct host_cmd_ds_mac_multicast_adr mc_addr;
+		struct host_cmd_ds_802_11_get_log get_log;
+		struct host_cmd_ds_802_11_rssi_info rssi_info;
+		struct host_cmd_ds_802_11_rssi_info_rsp rssi_info_rsp;
+		struct host_cmd_ds_802_11_snmp_mib smib;
+		struct host_cmd_ds_802_11_rf_channel rf_channel;
+		struct host_cmd_ds_tx_rate_query tx_rate;
+		struct host_cmd_ds_tx_rate_cfg tx_rate_cfg;
+		struct host_cmd_ds_txpwr_cfg txp_cfg;
+		struct host_cmd_ds_802_11_ps_mode_enh psmode_enh;
+		struct host_cmd_ds_802_11_hs_cfg_enh opt_hs_cfg;
+		struct host_cmd_ds_802_11_scan scan;
+		struct host_cmd_ds_802_11_scan_rsp scan_resp;
+		struct host_cmd_ds_802_11_bg_scan_query bg_scan_query;
+		struct host_cmd_ds_802_11_bg_scan_query_rsp bg_scan_query_resp;
+		struct host_cmd_ds_802_11_associate associate;
+		struct host_cmd_ds_802_11_associate_rsp associate_rsp;
+		struct host_cmd_ds_802_11_deauthenticate deauth;
+		struct host_cmd_ds_802_11_ad_hoc_start adhoc_start;
+		struct host_cmd_ds_802_11_ad_hoc_result adhoc_result;
+		struct host_cmd_ds_802_11_ad_hoc_join adhoc_join;
+		struct host_cmd_ds_802_11d_domain_info domain_info;
+		struct host_cmd_ds_802_11d_domain_info_rsp domain_info_resp;
+		struct host_cmd_ds_11n_addba_req add_ba_req;
+		struct host_cmd_ds_11n_addba_rsp add_ba_rsp;
+		struct host_cmd_ds_11n_delba del_ba;
+		struct host_cmd_ds_txbuf_cfg tx_buf;
+		struct host_cmd_ds_amsdu_aggr_ctrl amsdu_aggr_ctrl;
+		struct host_cmd_ds_11n_cfg htcfg;
+		struct host_cmd_ds_wmm_get_status get_wmm_status;
+		struct host_cmd_ds_802_11_key_material key_material;
+		struct host_cmd_ds_version_ext verext;
+		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
+		struct host_cmd_ds_mac_reg_access mac_reg;
+		struct host_cmd_ds_bbp_reg_access bbp_reg;
+		struct host_cmd_ds_rf_reg_access rf_reg;
+		struct host_cmd_ds_pmic_reg_access pmic_reg;
+		struct host_cmd_ds_set_bss_mode bss_mode;
+		struct host_cmd_ds_802_11_eeprom_access eeprom;
+	} params;
+} __packed;
+
+struct mwifiex_opt_sleep_confirm {
+	__le16 command;
+	__le16 size;
+	__le16 seq_num;
+	__le16 result;
+	__le16 action;
+	struct sleep_confirm_param sleep_cfm;
+} __packed;
+
+struct mwifiex_opt_sleep_confirm_buffer {
+	u8 hdr[4];
+	struct mwifiex_opt_sleep_confirm ps_cfm_sleep;
+} __packed;
+#endif /* !_MWIFIEX_FW_H_ */
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
new file mode 100644
index 0000000..07ebc97
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -0,0 +1,665 @@
+/*
+ * Marvell Wireless LAN device driver: HW/FW Initialization
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * This function adds a BSS priority table to the table list.
+ *
+ * The function allocates a new BSS priority table node and adds it to
+ * the end of BSS priority table list, kept in driver memory.
+ */
+static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bss_prio_node *bss_prio;
+	int status = 0;
+	unsigned long flags;
+
+	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
+	if (!bss_prio) {
+		dev_err(adapter->dev, "%s: failed to alloc bss_prio\n",
+						__func__);
+		return -1;
+	}
+
+	bss_prio->priv = priv;
+	INIT_LIST_HEAD(&bss_prio->list);
+	if (!adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur)
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			bss_prio;
+
+	spin_lock_irqsave(&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_lock, flags);
+	list_add_tail(&bss_prio->list,
+			&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_head);
+	spin_unlock_irqrestore(&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_lock, flags);
+
+	return status;
+}
+
+/*
+ * This function initializes the private structure and sets default
+ * values to the members.
+ *
+ * Additionally, it also initializes all the locks and sets up all the
+ * lists.
+ */
+static int mwifiex_init_priv(struct mwifiex_private *priv)
+{
+	u32 i;
+	int ret = 0;
+
+	priv->media_connected = false;
+	memset(priv->curr_addr, 0xff, ETH_ALEN);
+
+	priv->pkt_tx_ctrl = 0;
+	priv->bss_mode = MWIFIEX_BSS_MODE_INFRA;
+	priv->data_rate = 0;	/* Initially indicate the rate as auto */
+	priv->is_data_rate_auto = true;
+	priv->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
+	priv->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
+
+	priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
+	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
+	priv->sec_info.encryption_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
+	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
+		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
+	priv->wep_key_curr_index = 0;
+	priv->curr_pkt_filter = HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
+				HostCmd_ACT_MAC_ETHERNETII_ENABLE;
+
+	priv->beacon_period = 100; /* beacon interval */ ;
+	priv->attempted_bss_desc = NULL;
+	memset(&priv->curr_bss_params, 0, sizeof(priv->curr_bss_params));
+	priv->listen_interval = MWIFIEX_DEFAULT_LISTEN_INTERVAL;
+
+	memset(&priv->prev_ssid, 0, sizeof(priv->prev_ssid));
+	memset(&priv->prev_bssid, 0, sizeof(priv->prev_bssid));
+	memset(&priv->assoc_rsp_buf, 0, sizeof(priv->assoc_rsp_buf));
+	priv->assoc_rsp_size = 0;
+	priv->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+	priv->atim_window = 0;
+	priv->adhoc_state = ADHOC_IDLE;
+	priv->tx_power_level = 0;
+	priv->max_tx_power_level = 0;
+	priv->min_tx_power_level = 0;
+	priv->tx_rate = 0;
+	priv->rxpd_htinfo = 0;
+	priv->rxpd_rate = 0;
+	priv->rate_bitmap = 0;
+	priv->data_rssi_last = 0;
+	priv->data_rssi_avg = 0;
+	priv->data_nf_avg = 0;
+	priv->data_nf_last = 0;
+	priv->bcn_rssi_last = 0;
+	priv->bcn_rssi_avg = 0;
+	priv->bcn_nf_avg = 0;
+	priv->bcn_nf_last = 0;
+	memset(&priv->wpa_ie, 0, sizeof(priv->wpa_ie));
+	memset(&priv->aes_key, 0, sizeof(priv->aes_key));
+	priv->wpa_ie_len = 0;
+	priv->wpa_is_gtk_set = false;
+
+	memset(&priv->assoc_tlv_buf, 0, sizeof(priv->assoc_tlv_buf));
+	priv->assoc_tlv_buf_len = 0;
+	memset(&priv->wps, 0, sizeof(priv->wps));
+	memset(&priv->gen_ie_buf, 0, sizeof(priv->gen_ie_buf));
+	priv->gen_ie_buf_len = 0;
+	memset(priv->vs_ie, 0, sizeof(priv->vs_ie));
+
+	priv->wmm_required = true;
+	priv->wmm_enabled = false;
+	priv->wmm_qosinfo = 0;
+	priv->curr_bcn_buf = NULL;
+	priv->curr_bcn_size = 0;
+
+	priv->scan_block = false;
+
+	ret = mwifiex_add_bss_prio_tbl(priv);
+
+	return ret;
+}
+
+/*
+ * This function allocates buffers for members of the adapter
+ * structure.
+ *
+ * The memory allocated includes scan table, command buffers, and
+ * sleep confirm command buffer. In addition, the queues are
+ * also initialized.
+ */
+static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	u32 buf_size;
+	struct mwifiex_bssdescriptor *temp_scan_table;
+
+	/* Allocate buffer to store the BSSID list */
+	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
+	temp_scan_table = kzalloc(buf_size, GFP_KERNEL);
+	if (!temp_scan_table) {
+		dev_err(adapter->dev, "%s: failed to alloc temp_scan_table\n",
+		       __func__);
+		return -1;
+	}
+
+	adapter->scan_table = temp_scan_table;
+
+	/* Allocate command buffer */
+	ret = mwifiex_alloc_cmd_buffer(adapter);
+	if (ret) {
+		dev_err(adapter->dev, "%s: failed to alloc cmd buffer\n",
+		       __func__);
+		return -1;
+	}
+
+	adapter->sleep_cfm =
+		dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm_buffer)
+				+ INTF_HEADER_LEN);
+
+	if (!adapter->sleep_cfm) {
+		dev_err(adapter->dev, "%s: failed to alloc sleep cfm"
+			" cmd buffer\n", __func__);
+		return -1;
+	}
+	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
+
+	return 0;
+}
+
+/*
+ * This function initializes the adapter structure and sets default
+ * values to the members of adapter.
+ *
+ * This also initializes the WMM related parameters in the driver private
+ * structures.
+ */
+static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf = NULL;
+
+	skb_put(adapter->sleep_cfm, sizeof(sleep_cfm_buf->ps_cfm_sleep));
+	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm_buffer *)
+						(adapter->sleep_cfm->data);
+
+	adapter->cmd_sent = false;
+	adapter->data_sent = true;
+	adapter->cmd_resp_received = false;
+	adapter->event_received = false;
+	adapter->data_received = false;
+
+	adapter->surprise_removed = false;
+
+	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
+
+	adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+	adapter->ps_state = PS_STATE_AWAKE;
+	adapter->need_to_wakeup = false;
+
+	adapter->scan_mode = HostCmd_BSS_MODE_ANY;
+	adapter->specific_scan_time = MWIFIEX_SPECIFIC_SCAN_CHAN_TIME;
+	adapter->active_scan_time = MWIFIEX_ACTIVE_SCAN_CHAN_TIME;
+	adapter->passive_scan_time = MWIFIEX_PASSIVE_SCAN_CHAN_TIME;
+
+	adapter->num_in_scan_table = 0;
+	memset(adapter->scan_table, 0,
+	       (sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP));
+	adapter->scan_probes = 1;
+
+	memset(adapter->bcn_buf, 0, sizeof(adapter->bcn_buf));
+	adapter->bcn_buf_end = adapter->bcn_buf;
+
+	adapter->radio_on = RADIO_ON;
+	adapter->multiple_dtim = 1;
+
+	adapter->local_listen_interval = 0;	/* default value in firmware
+						   will be used */
+
+	adapter->is_deep_sleep = false;
+
+	adapter->delay_null_pkt = false;
+	adapter->delay_to_ps = 1000;
+	adapter->enhanced_ps_mode = PS_MODE_AUTO;
+
+	adapter->gen_null_pkt = false;	/* Disable NULL Pkg generation by
+					   default */
+	adapter->pps_uapsd_mode = false; /* Disable pps/uapsd mode by
+					   default */
+	adapter->pm_wakeup_card_req = false;
+
+	adapter->pm_wakeup_fw_try = false;
+
+	adapter->max_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+	adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+	adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
+
+	adapter->is_hs_configured = false;
+	adapter->hs_cfg.conditions = cpu_to_le32(HOST_SLEEP_CFG_COND_DEF);
+	adapter->hs_cfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
+	adapter->hs_cfg.gap = HOST_SLEEP_CFG_GAP_DEF;
+	adapter->hs_activated = false;
+
+	memset(adapter->event_body, 0, sizeof(adapter->event_body));
+	adapter->hw_dot_11n_dev_cap = 0;
+	adapter->hw_dev_mcs_support = 0;
+	adapter->usr_dot_11n_dev_cap = 0;
+	adapter->usr_dev_mcs_support = 0;
+	adapter->chan_offset = 0;
+	adapter->adhoc_11n_enabled = false;
+
+	mwifiex_wmm_init(adapter);
+
+	if (adapter->sleep_cfm) {
+		memset(&sleep_cfm_buf->ps_cfm_sleep, 0,
+			adapter->sleep_cfm->len);
+		sleep_cfm_buf->ps_cfm_sleep.command =
+			cpu_to_le16(HostCmd_CMD_802_11_PS_MODE_ENH);
+		sleep_cfm_buf->ps_cfm_sleep.size =
+			cpu_to_le16(adapter->sleep_cfm->len);
+		sleep_cfm_buf->ps_cfm_sleep.result = 0;
+		sleep_cfm_buf->ps_cfm_sleep.action = cpu_to_le16(SLEEP_CONFIRM);
+		sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl =
+			cpu_to_le16(RESP_NEEDED);
+	}
+	memset(&adapter->sleep_params, 0, sizeof(adapter->sleep_params));
+	memset(&adapter->sleep_period, 0, sizeof(adapter->sleep_period));
+	adapter->tx_lock_flag = false;
+	adapter->null_pkt_interval = 0;
+	adapter->fw_bands = 0;
+	adapter->config_bands = 0;
+	adapter->adhoc_start_band = 0;
+	adapter->scan_channels = NULL;
+	adapter->fw_release_number = 0;
+	adapter->fw_cap_info = 0;
+	memset(&adapter->upld_buf, 0, sizeof(adapter->upld_buf));
+	adapter->event_cause = 0;
+	adapter->region_code = 0;
+	adapter->bcn_miss_time_out = DEFAULT_BCN_MISS_TIMEOUT;
+	adapter->adhoc_awake_period = 0;
+	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
+	adapter->arp_filter_size = 0;
+
+	return;
+}
+
+/*
+ * This function frees the adapter structure.
+ *
+ * The freeing operation is done recursively, by canceling all
+ * pending commands, freeing the member buffers previously
+ * allocated (command buffers, scan table buffer, sleep confirm
+ * command buffer), stopping the timers and calling the cleanup
+ * routines for every interface, before the actual adapter
+ * structure is freed.
+ */
+static void
+mwifiex_free_adapter(struct mwifiex_adapter *adapter)
+{
+	if (!adapter) {
+		pr_err("%s: adapter is NULL\n", __func__);
+		return;
+	}
+
+	mwifiex_cancel_all_pending_cmd(adapter);
+
+	/* Free lock variables */
+	mwifiex_free_lock_list(adapter);
+
+	/* Free command buffer */
+	dev_dbg(adapter->dev, "info: free cmd buffer\n");
+	mwifiex_free_cmd_buffer(adapter);
+
+	del_timer(&adapter->cmd_timer);
+
+	dev_dbg(adapter->dev, "info: free scan table\n");
+	kfree(adapter->scan_table);
+	adapter->scan_table = NULL;
+
+	adapter->if_ops.cleanup_if(adapter);
+
+	dev_kfree_skb_any(adapter->sleep_cfm);
+
+	return;
+}
+
+/*
+ *  This function intializes the lock variables and
+ *  the list heads.
+ */
+int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private   *priv = NULL;
+	s32           i = 0;
+	u32           j = 0;
+
+	spin_lock_init(&adapter->mwifiex_lock);
+	spin_lock_init(&adapter->int_lock);
+	spin_lock_init(&adapter->main_proc_lock);
+	spin_lock_init(&adapter->mwifiex_cmd_lock);
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+			spin_lock_init(&priv->rx_pkt_lock);
+			spin_lock_init(&priv->wmm.ra_list_spinlock);
+			spin_lock_init(&priv->curr_bcn_buf_lock);
+		}
+	}
+
+	/* Initialize cmd_free_q */
+	INIT_LIST_HEAD(&adapter->cmd_free_q);
+	/* Initialize cmd_pending_q */
+	INIT_LIST_HEAD(&adapter->cmd_pending_q);
+	/* Initialize scan_pending_q */
+	INIT_LIST_HEAD(&adapter->scan_pending_q);
+
+	spin_lock_init(&adapter->cmd_free_q_lock);
+	spin_lock_init(&adapter->cmd_pending_q_lock);
+	spin_lock_init(&adapter->scan_pending_q_lock);
+
+	for (i = 0; i < adapter->priv_num; ++i) {
+		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
+		adapter->bss_prio_tbl[i].bss_prio_cur = NULL;
+		spin_lock_init(&adapter->bss_prio_tbl[i].bss_prio_lock);
+	}
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (!adapter->priv[i])
+			continue;
+		priv = adapter->priv[i];
+		for (j = 0; j < MAX_NUM_TID; ++j) {
+			INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j].ra_list);
+			spin_lock_init(&priv->wmm.tid_tbl_ptr[j].tid_tbl_lock);
+		}
+		INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
+		INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
+
+		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
+		spin_lock_init(&priv->rx_reorder_tbl_lock);
+	}
+
+	return 0;
+}
+
+/*
+ *  This function releases the lock variables and frees the locks and
+ *  associated locks.
+ */
+void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv = NULL;
+	s32           i = 0;
+	s32           j = 0;
+
+	/* Free lists */
+	list_del(&adapter->cmd_free_q);
+	list_del(&adapter->cmd_pending_q);
+	list_del(&adapter->scan_pending_q);
+
+	for (i = 0; i < adapter->priv_num; i++)
+		list_del(&adapter->bss_prio_tbl[i].bss_prio_head);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+			for (j = 0; j < MAX_NUM_TID; ++j)
+				list_del(&priv->wmm.tid_tbl_ptr[j].ra_list);
+			list_del(&priv->tx_ba_stream_tbl_ptr);
+			list_del(&priv->rx_reorder_tbl_ptr);
+		}
+	}
+
+	return;
+}
+
+/*
+ * This function initializes the firmware.
+ *
+ * The following operations are performed sequentially -
+ *      - Allocate adapter structure
+ *      - Initialize the adapter structure
+ *      - Initialize the private structure
+ *      - Add BSS priority tables to the adapter structure
+ *      - For each interface, send the init commands to firmware
+ *      - Send the first command in command pending queue, if available
+ */
+int mwifiex_init_fw(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = NULL;
+	u8 i = 0;
+	u8 first_sta = true;
+	int is_cmd_pend_q_empty;
+	unsigned long flags;
+
+	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
+
+	/* Allocate memory for member of adapter structure */
+	ret = mwifiex_allocate_adapter(adapter);
+	if (ret)
+		return -1;
+
+	/* Initialize adapter structure */
+	mwifiex_init_adapter(adapter);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+
+			/* Initialize private structure */
+			ret = mwifiex_init_priv(priv);
+			if (ret)
+				return -1;
+		}
+	}
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta);
+			if (ret == -1)
+				return -1;
+
+			first_sta = false;
+		}
+	}
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	is_cmd_pend_q_empty = list_empty(&adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+	if (!is_cmd_pend_q_empty) {
+		/* Send the first command in queue and return */
+		if (mwifiex_main_process(adapter) != -1)
+			ret = -EINPROGRESS;
+	} else {
+		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
+	}
+
+	return ret;
+}
+
+/*
+ * This function deletes the BSS priority tables.
+ *
+ * The function traverses through all the allocated BSS priority nodes
+ * in every BSS priority table and frees them.
+ */
+static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
+{
+	int i;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bss_prio_node *bssprio_node = NULL, *tmp_node = NULL,
+								**cur = NULL;
+	struct list_head *head;
+	spinlock_t *lock;
+	unsigned long flags;
+
+	for (i = 0; i < adapter->priv_num; ++i) {
+		head = &adapter->bss_prio_tbl[i].bss_prio_head;
+		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
+		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
+		dev_dbg(adapter->dev, "info: delete BSS priority table,"
+				" index = %d, i = %d, head = %p, cur = %p\n",
+			      priv->bss_index, i, head, *cur);
+		if (*cur) {
+			spin_lock_irqsave(lock, flags);
+			if (list_empty(head)) {
+				spin_unlock_irqrestore(lock, flags);
+				continue;
+			}
+			bssprio_node = list_first_entry(head,
+					struct mwifiex_bss_prio_node, list);
+			spin_unlock_irqrestore(lock, flags);
+
+			list_for_each_entry_safe(bssprio_node, tmp_node, head,
+						 list) {
+				if (bssprio_node->priv == priv) {
+					dev_dbg(adapter->dev, "info: Delete "
+						"node %p, next = %p\n",
+						bssprio_node, tmp_node);
+					spin_lock_irqsave(lock, flags);
+					list_del(&bssprio_node->list);
+					spin_unlock_irqrestore(lock, flags);
+					kfree(bssprio_node);
+				}
+			}
+			*cur = (struct mwifiex_bss_prio_node *)head;
+		}
+	}
+}
+
+/*
+ * This function is used to shutdown the driver.
+ *
+ * The following operations are performed sequentially -
+ *      - Check if already shut down
+ *      - Make sure the main process has stopped
+ *      - Clean up the Tx and Rx queues
+ *      - Delete BSS priority tables
+ *      - Free the adapter
+ *      - Notify completion
+ */
+int
+mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
+{
+	int ret = -EINPROGRESS;
+	struct mwifiex_private *priv = NULL;
+	s32 i = 0;
+	unsigned long flags;
+
+	/* mwifiex already shutdown */
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
+		return 0;
+
+	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
+	/* wait for mwifiex_process to complete */
+	if (adapter->mwifiex_processing) {
+		dev_warn(adapter->dev, "main process is still running\n");
+		return ret;
+	}
+
+	/* shut down mwifiex */
+	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
+
+	/* Clean up Tx/Rx queues and delete BSS priority table */
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			priv = adapter->priv[i];
+
+			mwifiex_clean_txrx(priv);
+			mwifiex_delete_bss_prio_tbl(priv);
+		}
+	}
+
+	spin_lock_irqsave(&adapter->mwifiex_lock, flags);
+
+	/* Free adapter structure */
+	mwifiex_free_adapter(adapter);
+
+	spin_unlock_irqrestore(&adapter->mwifiex_lock, flags);
+
+	/* Notify completion */
+	ret = mwifiex_shutdown_fw_complete(adapter);
+
+	return ret;
+}
+
+/*
+ * This function downloads the firmware to the card.
+ *
+ * The actual download is preceded by two sanity checks -
+ *      - Check if firmware is already running
+ *      - Check if the interface is the winner to download the firmware
+ *
+ * ...and followed by another -
+ *      - Check if the firmware is downloaded successfully
+ *
+ * After download is successfully completed, the host interrupts are enabled.
+ */
+int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
+		    struct mwifiex_fw_image *pmfw)
+{
+	int ret = 0;
+	u32 poll_num = 1;
+	int winner;
+
+	/* Check if firmware is already running */
+	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
+	if (!ret) {
+		dev_notice(adapter->dev,
+				"WLAN FW already running! Skip FW download\n");
+		goto done;
+	}
+	poll_num = MAX_FIRMWARE_POLL_TRIES;
+
+	/* Check if we are the winner for downloading FW */
+	if (!winner) {
+		dev_notice(adapter->dev,
+				"Other interface already running!"
+				" Skip FW download\n");
+		poll_num = MAX_MULTI_INTERFACE_POLL_TRIES;
+		goto poll_fw;
+	}
+	if (pmfw) {
+		/* Download firmware with helper */
+		ret = adapter->if_ops.prog_fw(adapter, pmfw);
+		if (ret) {
+			dev_err(adapter->dev, "prog_fw failed ret=%#x\n", ret);
+			return ret;
+		}
+	}
+
+poll_fw:
+	/* Check if the firmware is downloaded successfully or not */
+	ret = adapter->if_ops.check_fw_status(adapter, poll_num, NULL);
+	if (ret) {
+		dev_err(adapter->dev, "FW failed to be active in time\n");
+		return -1;
+	}
+done:
+	/* re-enable host interrupt for mwifiex after fw dnld is successful */
+	adapter->if_ops.enable_int(adapter);
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
new file mode 100644
index 0000000..d6babfb
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -0,0 +1,433 @@
+/*
+ * Marvell Wireless LAN device driver: ioctl data structures & APIs
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_IOCTL_H_
+#define _MWIFIEX_IOCTL_H_
+
+#include <net/mac80211.h>
+
+enum {
+	MWIFIEX_SCAN_MODE_UNCHANGED = 0,
+	MWIFIEX_SCAN_MODE_BSS,
+	MWIFIEX_SCAN_MODE_IBSS,
+	MWIFIEX_SCAN_MODE_ANY
+};
+
+enum {
+	MWIFIEX_SCAN_TYPE_UNCHANGED = 0,
+	MWIFIEX_SCAN_TYPE_ACTIVE,
+	MWIFIEX_SCAN_TYPE_PASSIVE
+};
+
+struct mwifiex_get_scan_table_fixed {
+	u8 bssid[ETH_ALEN];
+	u8 channel;
+	u8 rssi;
+	long long network_tsf;
+};
+
+struct mwifiex_scan_time_params {
+	u32 specific_scan_time;
+	u32 active_scan_time;
+	u32 passive_scan_time;
+};
+
+struct mwifiex_user_scan {
+	u32 scan_cfg_len;
+	u8 scan_cfg_buf[1];
+};
+
+struct mwifiex_scan_req {
+	u32 scan_mode;
+	u32 scan_type;
+	struct mwifiex_802_11_ssid scan_ssid;
+	struct mwifiex_scan_time_params scan_time;
+	struct mwifiex_user_scan user_scan;
+};
+
+struct mwifiex_scan_resp {
+	u32 num_in_scan_table;
+	u8 *scan_table;
+};
+
+enum {
+	MWIFIEX_BSS_MODE_INFRA = 1,
+	MWIFIEX_BSS_MODE_IBSS,
+	MWIFIEX_BSS_MODE_AUTO
+};
+
+#define MWIFIEX_PROMISC_MODE            1
+#define MWIFIEX_MULTICAST_MODE		2
+#define	MWIFIEX_ALL_MULTI_MODE		4
+#define MWIFIEX_MAX_MULTICAST_LIST_SIZE	32
+
+struct mwifiex_multicast_list {
+	u32 mode;
+	u32 num_multicast_addr;
+	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE][ETH_ALEN];
+};
+
+#define MWIFIEX_MAX_CHANNEL_NUM		128
+
+struct mwifiex_chan_freq {
+	u32 channel;
+	u32 freq;
+};
+
+struct mwifiex_chan_list {
+	u32 num_of_chan;
+	struct mwifiex_chan_freq cf[MWIFIEX_MAX_CHANNEL_NUM];
+};
+
+struct mwifiex_ssid_bssid {
+	struct mwifiex_802_11_ssid ssid;
+	u8 bssid[ETH_ALEN];
+};
+
+enum {
+	BAND_B = 1,
+	BAND_G = 2,
+	BAND_A = 4,
+	BAND_GN = 8,
+	BAND_AN = 16,
+};
+
+#define NO_SEC_CHANNEL               0
+#define SEC_CHANNEL_ABOVE            1
+#define SEC_CHANNEL_BELOW            3
+
+struct mwifiex_ds_band_cfg {
+	u32 config_bands;
+	u32 adhoc_start_band;
+	u32 adhoc_channel;
+	u32 sec_chan_offset;
+};
+
+enum {
+	ADHOC_IDLE,
+	ADHOC_STARTED,
+	ADHOC_JOINED,
+	ADHOC_COALESCED
+};
+
+struct mwifiex_ds_get_stats {
+	u32 mcast_tx_frame;
+	u32 failed;
+	u32 retry;
+	u32 multi_retry;
+	u32 frame_dup;
+	u32 rts_success;
+	u32 rts_failure;
+	u32 ack_failure;
+	u32 rx_frag;
+	u32 mcast_rx_frame;
+	u32 fcs_error;
+	u32 tx_frame;
+	u32 wep_icv_error[4];
+};
+
+#define BCN_RSSI_LAST_MASK              0x00000001
+#define BCN_RSSI_AVG_MASK               0x00000002
+#define DATA_RSSI_LAST_MASK             0x00000004
+#define DATA_RSSI_AVG_MASK              0x00000008
+#define BCN_SNR_LAST_MASK               0x00000010
+#define BCN_SNR_AVG_MASK                0x00000020
+#define DATA_SNR_LAST_MASK              0x00000040
+#define DATA_SNR_AVG_MASK               0x00000080
+#define BCN_NF_LAST_MASK                0x00000100
+#define BCN_NF_AVG_MASK                 0x00000200
+#define DATA_NF_LAST_MASK               0x00000400
+#define DATA_NF_AVG_MASK                0x00000800
+#define ALL_RSSI_INFO_MASK              0x00000fff
+
+struct mwifiex_ds_get_signal {
+	/*
+	 * Bit0:  Last Beacon RSSI,  Bit1:  Average Beacon RSSI,
+	 * Bit2:  Last Data RSSI,    Bit3:  Average Data RSSI,
+	 * Bit4:  Last Beacon SNR,   Bit5:  Average Beacon SNR,
+	 * Bit6:  Last Data SNR,     Bit7:  Average Data SNR,
+	 * Bit8:  Last Beacon NF,    Bit9:  Average Beacon NF,
+	 * Bit10: Last Data NF,      Bit11: Average Data NF
+	 */
+	u16 selector;
+	s16 bcn_rssi_last;
+	s16 bcn_rssi_avg;
+	s16 data_rssi_last;
+	s16 data_rssi_avg;
+	s16 bcn_snr_last;
+	s16 bcn_snr_avg;
+	s16 data_snr_last;
+	s16 data_snr_avg;
+	s16 bcn_nf_last;
+	s16 bcn_nf_avg;
+	s16 data_nf_last;
+	s16 data_nf_avg;
+};
+
+struct mwifiex_fw_info {
+	u32 fw_ver;
+	u8 mac_addr[ETH_ALEN];
+};
+
+#define MWIFIEX_MAX_VER_STR_LEN    128
+
+struct mwifiex_ver_ext {
+	u32 version_str_sel;
+	char version_str[MWIFIEX_MAX_VER_STR_LEN];
+};
+
+struct mwifiex_bss_info {
+	u32 bss_mode;
+	struct mwifiex_802_11_ssid ssid;
+	u32 scan_table_idx;
+	u32 bss_chan;
+	u32 region_code;
+	u32 media_connected;
+	u32 radio_on;
+	u32 max_power_level;
+	u32 min_power_level;
+	u32 adhoc_state;
+	signed int bcn_nf_last;
+	u32 wep_status;
+	u32 is_hs_configured;
+	u32 is_deep_sleep;
+	u8 bssid[ETH_ALEN];
+};
+
+#define MAX_NUM_TID     8
+
+#define MAX_RX_WINSIZE  64
+
+struct mwifiex_ds_rx_reorder_tbl {
+	u16 tid;
+	u8 ta[ETH_ALEN];
+	u32 start_win;
+	u32 win_size;
+	u32 buffer[MAX_RX_WINSIZE];
+};
+
+struct mwifiex_ds_tx_ba_stream_tbl {
+	u16 tid;
+	u8 ra[ETH_ALEN];
+};
+
+#define DBG_CMD_NUM	5
+
+struct mwifiex_debug_info {
+	u32 int_counter;
+	u32 packets_out[MAX_NUM_TID];
+	u32 max_tx_buf_size;
+	u32 tx_buf_size;
+	u32 curr_tx_buf_size;
+	u32 tx_tbl_num;
+	struct mwifiex_ds_tx_ba_stream_tbl
+		tx_tbl[MWIFIEX_MAX_TX_BASTREAM_SUPPORTED];
+	u32 rx_tbl_num;
+	struct mwifiex_ds_rx_reorder_tbl rx_tbl
+		[MWIFIEX_MAX_RX_BASTREAM_SUPPORTED];
+	u16 ps_mode;
+	u32 ps_state;
+	u8 is_deep_sleep;
+	u8 pm_wakeup_card_req;
+	u32 pm_wakeup_fw_try;
+	u8 is_hs_configured;
+	u8 hs_activated;
+	u32 num_cmd_host_to_card_failure;
+	u32 num_cmd_sleep_cfm_host_to_card_failure;
+	u32 num_tx_host_to_card_failure;
+	u32 num_event_deauth;
+	u32 num_event_disassoc;
+	u32 num_event_link_lost;
+	u32 num_cmd_deauth;
+	u32 num_cmd_assoc_success;
+	u32 num_cmd_assoc_failure;
+	u32 num_tx_timeout;
+	u32 num_cmd_timeout;
+	u16 timeout_cmd_id;
+	u16 timeout_cmd_act;
+	u16 last_cmd_id[DBG_CMD_NUM];
+	u16 last_cmd_act[DBG_CMD_NUM];
+	u16 last_cmd_index;
+	u16 last_cmd_resp_id[DBG_CMD_NUM];
+	u16 last_cmd_resp_index;
+	u16 last_event[DBG_CMD_NUM];
+	u16 last_event_index;
+	u8 data_sent;
+	u8 cmd_sent;
+	u8 cmd_resp_received;
+	u8 event_received;
+};
+
+enum {
+	MWIFIEX_AUTH_MODE_OPEN = 0x00,
+	MWIFIEX_AUTH_MODE_SHARED = 0x01,
+	MWIFIEX_AUTH_MODE_NETWORKEAP = 0x80,
+	MWIFIEX_AUTH_MODE_AUTO = 0xFF,
+};
+
+enum {
+	MWIFIEX_ENCRYPTION_MODE_NONE = 0,
+	MWIFIEX_ENCRYPTION_MODE_WEP40 = 1,
+	MWIFIEX_ENCRYPTION_MODE_TKIP = 2,
+	MWIFIEX_ENCRYPTION_MODE_CCMP = 3,
+	MWIFIEX_ENCRYPTION_MODE_WEP104 = 4,
+};
+
+#define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
+#define MWIFIEX_MAX_KEY_LENGTH		32
+#define WAPI_RXPN_LEN			16
+
+struct mwifiex_ds_encrypt_key {
+	u32 key_disable;
+	u32 key_index;
+	u32 key_len;
+	u8 key_material[MWIFIEX_MAX_KEY_LENGTH];
+	u8 mac_addr[ETH_ALEN];
+	u32 is_wapi_key;
+	u8 wapi_rxpn[WAPI_RXPN_LEN];
+};
+
+struct mwifiex_rate_cfg {
+	u32 action;
+	u32 is_rate_auto;
+	u32 rate;
+};
+
+struct mwifiex_data_rate {
+	u32 tx_data_rate;
+	u32 rx_data_rate;
+};
+
+struct mwifiex_power_cfg {
+	u32 is_power_auto;
+	u32 power_level;
+};
+
+struct mwifiex_ds_hs_cfg {
+	u32 is_invoke_hostcmd;
+	/*  Bit0: non-unicast data
+	 *  Bit1: unicast data
+	 *  Bit2: mac events
+	 *  Bit3: magic packet
+	 */
+	u32 conditions;
+	u32 gpio;
+	u32 gap;
+};
+
+#define DEEP_SLEEP_ON  1
+#define DEEP_SLEEP_OFF 0
+
+#define DEEP_SLEEP_IDLE_TIME	100
+
+struct mwifiex_ds_auto_ds {
+	u16 auto_ds;
+	u16 idle_time;
+};
+
+#define PS_MODE_UNCHANGED			0
+#define PS_MODE_AUTO				1
+#define PS_MODE_POLL				2
+#define PS_MODE_NULL				3
+
+
+struct mwifiex_ds_pm_cfg {
+	union {
+		u32 ps_mode;
+		struct mwifiex_ds_hs_cfg hs_cfg;
+		struct mwifiex_ds_auto_ds auto_deep_sleep;
+		u32 sleep_period;
+	} param;
+};
+
+struct mwifiex_ioctl_wmm_queue_status_ac {
+	u8 wmm_acm;
+	u8 flow_required;
+	u8 flow_created;
+	u8 disabled;
+};
+
+struct mwifiex_ds_wmm_queue_status {
+	struct mwifiex_ioctl_wmm_queue_status_ac
+		ac_status[IEEE80211_MAX_QUEUES];
+};
+
+struct mwifiex_ds_11n_tx_cfg {
+	u16 tx_htcap;
+	u16 tx_htinfo;
+};
+
+struct mwifiex_ds_11n_amsdu_aggr_ctrl {
+	u16 enable;
+	u16 curr_buf_size;
+};
+
+#define MWIFIEX_NUM_OF_CMD_BUFFER	20
+#define MWIFIEX_SIZE_OF_CMD_BUFFER	2048
+
+enum {
+	MWIFIEX_IE_TYPE_GEN_IE = 0,
+	MWIFIEX_IE_TYPE_ARP_FILTER,
+};
+
+enum {
+	MWIFIEX_REG_MAC = 1,
+	MWIFIEX_REG_BBP,
+	MWIFIEX_REG_RF,
+	MWIFIEX_REG_PMIC,
+	MWIFIEX_REG_CAU,
+};
+
+struct mwifiex_ds_reg_rw {
+	__le32 type;
+	__le32 offset;
+	__le32 value;
+};
+
+#define MAX_EEPROM_DATA 256
+
+struct mwifiex_ds_read_eeprom {
+	__le16 offset;
+	__le16 byte_count;
+	u8 value[MAX_EEPROM_DATA];
+};
+
+struct mwifiex_ds_misc_gen_ie {
+	u32 type;
+	u32 len;
+	u8 ie_data[IW_CUSTOM_MAX];
+};
+
+struct mwifiex_ds_misc_cmd {
+	u32 len;
+	u8 cmd[MWIFIEX_SIZE_OF_CMD_BUFFER];
+};
+
+#define MWIFIEX_MAX_VSIE_LEN       (256)
+#define MWIFIEX_MAX_VSIE_NUM       (8)
+#define MWIFIEX_VSIE_MASK_SCAN     0x01
+#define MWIFIEX_VSIE_MASK_ASSOC    0x02
+#define MWIFIEX_VSIE_MASK_ADHOC    0x04
+
+enum {
+	MWIFIEX_FUNC_INIT = 1,
+	MWIFIEX_FUNC_SHUTDOWN,
+};
+
+#endif /* !_MWIFIEX_IOCTL_H_ */
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
new file mode 100644
index 0000000..d06f4c2
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -0,0 +1,1464 @@
+/*
+ * Marvell Wireless LAN device driver: association and ad-hoc start/join
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+#define CAPINFO_MASK    (~(BIT(15) | BIT(14) | BIT(12) | BIT(11) | BIT(9)))
+
+/*
+ * Append a generic IE as a pass through TLV to a TLV buffer.
+ *
+ * This function is called from the network join command preparation routine.
+ *
+ * If the IE buffer has been setup by the application, this routine appends
+ * the buffer as a pass through TLV type to the request.
+ */
+static int
+mwifiex_cmd_append_generic_ie(struct mwifiex_private *priv, u8 **buffer)
+{
+	int ret_len = 0;
+	struct mwifiex_ie_types_header ie_header;
+
+	/* Null Checks */
+	if (!buffer)
+		return 0;
+	if (!(*buffer))
+		return 0;
+
+	/*
+	 * If there is a generic ie buffer setup, append it to the return
+	 *   parameter buffer pointer.
+	 */
+	if (priv->gen_ie_buf_len) {
+		dev_dbg(priv->adapter->dev, "info: %s: append generic %d to %p\n",
+				__func__, priv->gen_ie_buf_len, *buffer);
+
+		/* Wrap the generic IE buffer with a pass through TLV type */
+		ie_header.type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
+		ie_header.len = cpu_to_le16(priv->gen_ie_buf_len);
+		memcpy(*buffer, &ie_header, sizeof(ie_header));
+
+		/* Increment the return size and the return buffer pointer
+		   param */
+		*buffer += sizeof(ie_header);
+		ret_len += sizeof(ie_header);
+
+		/* Copy the generic IE buffer to the output buffer, advance
+		   pointer */
+		memcpy(*buffer, priv->gen_ie_buf, priv->gen_ie_buf_len);
+
+		/* Increment the return size and the return buffer pointer
+		   param */
+		*buffer += priv->gen_ie_buf_len;
+		ret_len += priv->gen_ie_buf_len;
+
+		/* Reset the generic IE buffer */
+		priv->gen_ie_buf_len = 0;
+	}
+
+	/* return the length appended to the buffer */
+	return ret_len;
+}
+
+/*
+ * Append TSF tracking info from the scan table for the target AP.
+ *
+ * This function is called from the network join command preparation routine.
+ *
+ * The TSF table TSF sent to the firmware contains two TSF values:
+ *      - The TSF of the target AP from its previous beacon/probe response
+ *      - The TSF timestamp of our local MAC at the time we observed the
+ *        beacon/probe response.
+ *
+ * The firmware uses the timestamp values to set an initial TSF value
+ * in the MAC for the new association after a reassociation attempt.
+ */
+static int
+mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
+			   struct mwifiex_bssdescriptor *bss_desc)
+{
+	struct mwifiex_ie_types_tsf_timestamp tsf_tlv;
+	long long tsf_val;
+
+	/* Null Checks */
+	if (buffer == NULL)
+		return 0;
+	if (*buffer == NULL)
+		return 0;
+
+	memset(&tsf_tlv, 0x00, sizeof(struct mwifiex_ie_types_tsf_timestamp));
+
+	tsf_tlv.header.type = cpu_to_le16(TLV_TYPE_TSFTIMESTAMP);
+	tsf_tlv.header.len = cpu_to_le16(2 * sizeof(tsf_val));
+
+	memcpy(*buffer, &tsf_tlv, sizeof(tsf_tlv.header));
+	*buffer += sizeof(tsf_tlv.header);
+
+	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
+	*buffer += sizeof(tsf_val);
+
+	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
+
+	dev_dbg(priv->adapter->dev, "info: %s: TSF offset calc: %016llx - "
+			"%016llx\n", __func__, tsf_val, bss_desc->network_tsf);
+
+	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
+	*buffer += sizeof(tsf_val);
+
+	return sizeof(tsf_tlv.header) + (2 * sizeof(tsf_val));
+}
+
+/*
+ * This function finds out the common rates between rate1 and rate2.
+ *
+ * It will fill common rates in rate1 as output if found.
+ *
+ * NOTE: Setting the MSB of the basic rates needs to be taken
+ * care of, either before or after calling this function.
+ */
+static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
+				    u32 rate1_size, u8 *rate2, u32 rate2_size)
+{
+	int ret = 0;
+	u8 *ptr = rate1;
+	u8 *tmp = NULL;
+	u32 i, j;
+
+	tmp = kmalloc(rate1_size, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(priv->adapter->dev, "failed to alloc tmp buf\n");
+		return -ENOMEM;
+	}
+
+	memcpy(tmp, rate1, rate1_size);
+	memset(rate1, 0, rate1_size);
+
+	for (i = 0; rate2[i] && i < rate2_size; i++) {
+		for (j = 0; tmp[j] && j < rate1_size; j++) {
+			/* Check common rate, excluding the bit for
+			   basic rate */
+			if ((rate2[i] & 0x7F) == (tmp[j] & 0x7F)) {
+				*rate1++ = tmp[j];
+				break;
+			}
+		}
+	}
+
+	dev_dbg(priv->adapter->dev, "info: Tx data rate set to %#x\n",
+						priv->data_rate);
+
+	if (!priv->is_data_rate_auto) {
+		while (*ptr) {
+			if ((*ptr & 0x7f) == priv->data_rate) {
+				ret = 0;
+				goto done;
+			}
+			ptr++;
+		}
+		dev_err(priv->adapter->dev, "previously set fixed data rate %#x"
+			" is not compatible with the network\n",
+			priv->data_rate);
+
+		ret = -1;
+		goto done;
+	}
+
+	ret = 0;
+done:
+	kfree(tmp);
+	return ret;
+}
+
+/*
+ * This function creates the intersection of the rates supported by a
+ * target BSS and our adapter settings for use in an assoc/join command.
+ */
+static int
+mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
+				 struct mwifiex_bssdescriptor *bss_desc,
+				 u8 *out_rates, u32 *out_rates_size)
+{
+	u8 card_rates[MWIFIEX_SUPPORTED_RATES];
+	u32 card_rates_size = 0;
+
+	/* Copy AP supported rates */
+	memcpy(out_rates, bss_desc->supported_rates, MWIFIEX_SUPPORTED_RATES);
+	/* Get the STA supported rates */
+	card_rates_size = mwifiex_get_active_data_rates(priv, card_rates);
+	/* Get the common rates between AP and STA supported rates */
+	if (mwifiex_get_common_rates(priv, out_rates, MWIFIEX_SUPPORTED_RATES,
+				     card_rates, card_rates_size)) {
+		*out_rates_size = 0;
+		dev_err(priv->adapter->dev, "%s: cannot get common rates\n",
+						__func__);
+		return -1;
+	}
+
+	*out_rates_size =
+		min_t(size_t, strlen(out_rates), MWIFIEX_SUPPORTED_RATES);
+
+	return 0;
+}
+
+/*
+ * This function updates the scan entry TSF timestamps to reflect
+ * a new association.
+ */
+static void
+mwifiex_update_tsf_timestamps(struct mwifiex_private *priv,
+			      struct mwifiex_bssdescriptor *new_bss_desc)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 table_idx;
+	long long new_tsf_base;
+	signed long long tsf_delta;
+
+	memcpy(&new_tsf_base, new_bss_desc->time_stamp, sizeof(new_tsf_base));
+
+	tsf_delta = new_tsf_base - new_bss_desc->network_tsf;
+
+	dev_dbg(adapter->dev, "info: TSF: update TSF timestamps, "
+		"0x%016llx -> 0x%016llx\n",
+	       new_bss_desc->network_tsf, new_tsf_base);
+
+	for (table_idx = 0; table_idx < adapter->num_in_scan_table;
+	     table_idx++)
+		adapter->scan_table[table_idx].network_tsf += tsf_delta;
+}
+
+/*
+ * This function appends a WAPI IE.
+ *
+ * This function is called from the network join command preparation routine.
+ *
+ * If the IE buffer has been setup by the application, this routine appends
+ * the buffer as a WAPI TLV type to the request.
+ */
+static int
+mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
+{
+	int retLen = 0;
+	struct mwifiex_ie_types_header ie_header;
+
+	/* Null Checks */
+	if (buffer == NULL)
+		return 0;
+	if (*buffer == NULL)
+		return 0;
+
+	/*
+	 * If there is a wapi ie buffer setup, append it to the return
+	 *   parameter buffer pointer.
+	 */
+	if (priv->wapi_ie_len) {
+		dev_dbg(priv->adapter->dev, "cmd: append wapi ie %d to %p\n",
+				priv->wapi_ie_len, *buffer);
+
+		/* Wrap the generic IE buffer with a pass through TLV type */
+		ie_header.type = cpu_to_le16(TLV_TYPE_WAPI_IE);
+		ie_header.len = cpu_to_le16(priv->wapi_ie_len);
+		memcpy(*buffer, &ie_header, sizeof(ie_header));
+
+		/* Increment the return size and the return buffer pointer
+		   param */
+		*buffer += sizeof(ie_header);
+		retLen += sizeof(ie_header);
+
+		/* Copy the wapi IE buffer to the output buffer, advance
+		   pointer */
+		memcpy(*buffer, priv->wapi_ie, priv->wapi_ie_len);
+
+		/* Increment the return size and the return buffer pointer
+		   param */
+		*buffer += priv->wapi_ie_len;
+		retLen += priv->wapi_ie_len;
+
+	}
+	/* return the length appended to the buffer */
+	return retLen;
+}
+
+/*
+ * This function appends rsn ie tlv for wpa/wpa2 security modes.
+ * It is called from the network join command preparation routine.
+ */
+static int mwifiex_append_rsn_ie_wpa_wpa2(struct mwifiex_private *priv,
+					  u8 **buffer)
+{
+	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
+	int rsn_ie_len;
+
+	if (!buffer || !(*buffer))
+		return 0;
+
+	rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) (*buffer);
+	rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
+	rsn_ie_tlv->header.type = cpu_to_le16(
+				 le16_to_cpu(rsn_ie_tlv->header.type) & 0x00FF);
+	rsn_ie_tlv->header.len = cpu_to_le16((u16) priv->wpa_ie[1]);
+	rsn_ie_tlv->header.len = cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
+							& 0x00FF);
+	if (le16_to_cpu(rsn_ie_tlv->header.len) <= (sizeof(priv->wpa_ie) - 2))
+		memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
+					le16_to_cpu(rsn_ie_tlv->header.len));
+	else
+		return -1;
+
+	rsn_ie_len = sizeof(rsn_ie_tlv->header) +
+					le16_to_cpu(rsn_ie_tlv->header.len);
+	*buffer += rsn_ie_len;
+
+	return rsn_ie_len;
+}
+
+/*
+ * This function prepares command for association.
+ *
+ * This sets the following parameters -
+ *      - Peer MAC address
+ *      - Listen interval
+ *      - Beacon interval
+ *      - Capability information
+ *
+ * ...and the following TLVs, as required -
+ *      - SSID TLV
+ *      - PHY TLV
+ *      - SS TLV
+ *      - Rates TLV
+ *      - Authentication TLV
+ *      - Channel TLV
+ *      - WPA/WPA2 IE
+ *      - 11n TLV
+ *      - Vendor specific TLV
+ *      - WMM TLV
+ *      - WAPI IE
+ *      - Generic IE
+ *      - TSF TLV
+ *
+ * Preparation also includes -
+ *      - Setting command ID and proper size
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *cmd,
+				 void *data_buf)
+{
+	struct host_cmd_ds_802_11_associate *assoc = &cmd->params.associate;
+	struct mwifiex_bssdescriptor *bss_desc;
+	struct mwifiex_ie_types_ssid_param_set *ssid_tlv;
+	struct mwifiex_ie_types_phy_param_set *phy_tlv;
+	struct mwifiex_ie_types_ss_param_set *ss_tlv;
+	struct mwifiex_ie_types_rates_param_set *rates_tlv;
+	struct mwifiex_ie_types_auth_type *auth_tlv;
+	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
+	u8 rates[MWIFIEX_SUPPORTED_RATES];
+	u32 rates_size;
+	u16 tmp_cap;
+	u8 *pos;
+	int rsn_ie_len = 0;
+
+	bss_desc = (struct mwifiex_bssdescriptor *) data_buf;
+	pos = (u8 *) assoc;
+
+	mwifiex_cfg_tx_buf(priv, bss_desc);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_ASSOCIATE);
+
+	/* Save so we know which BSS Desc to use in the response handler */
+	priv->attempted_bss_desc = bss_desc;
+
+	memcpy(assoc->peer_sta_addr,
+	       bss_desc->mac_address, sizeof(assoc->peer_sta_addr));
+	pos += sizeof(assoc->peer_sta_addr);
+
+	/* Set the listen interval */
+	assoc->listen_interval = cpu_to_le16(priv->listen_interval);
+	/* Set the beacon period */
+	assoc->beacon_period = cpu_to_le16(bss_desc->beacon_period);
+
+	pos += sizeof(assoc->cap_info_bitmap);
+	pos += sizeof(assoc->listen_interval);
+	pos += sizeof(assoc->beacon_period);
+	pos += sizeof(assoc->dtim_period);
+
+	ssid_tlv = (struct mwifiex_ie_types_ssid_param_set *) pos;
+	ssid_tlv->header.type = cpu_to_le16(WLAN_EID_SSID);
+	ssid_tlv->header.len = cpu_to_le16((u16) bss_desc->ssid.ssid_len);
+	memcpy(ssid_tlv->ssid, bss_desc->ssid.ssid,
+		le16_to_cpu(ssid_tlv->header.len));
+	pos += sizeof(ssid_tlv->header) + le16_to_cpu(ssid_tlv->header.len);
+
+	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
+	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
+	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
+	memcpy(&phy_tlv->fh_ds.ds_param_set,
+	       &bss_desc->phy_param_set.ds_param_set.current_chan,
+	       sizeof(phy_tlv->fh_ds.ds_param_set));
+	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
+
+	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
+	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
+	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
+	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
+
+	/* Get the common rates supported between the driver and the BSS Desc */
+	if (mwifiex_setup_rates_from_bssdesc
+	    (priv, bss_desc, rates, &rates_size))
+		return -1;
+
+	/* Save the data rates into Current BSS state structure */
+	priv->curr_bss_params.num_of_rates = rates_size;
+	memcpy(&priv->curr_bss_params.data_rates, rates, rates_size);
+
+	/* Setup the Rates TLV in the association command */
+	rates_tlv = (struct mwifiex_ie_types_rates_param_set *) pos;
+	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
+	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
+	memcpy(rates_tlv->rates, rates, rates_size);
+	pos += sizeof(rates_tlv->header) + rates_size;
+	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: rates size = %d\n",
+					rates_size);
+
+	/* Add the Authentication type to be used for Auth frames if needed */
+	if (priv->sec_info.authentication_mode != MWIFIEX_AUTH_MODE_AUTO) {
+		auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
+		auth_tlv->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+		auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
+		if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+			auth_tlv->auth_type = cpu_to_le16((u16) priv->sec_info.
+							  authentication_mode);
+		else
+			auth_tlv->auth_type =
+				cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
+		pos += sizeof(auth_tlv->header) +
+			le16_to_cpu(auth_tlv->header.len);
+	}
+
+	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)
+	    && !(ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
+		&& (!bss_desc->disable_11n)
+		 && (priv->adapter->config_bands & BAND_GN
+		     || priv->adapter->config_bands & BAND_AN)
+		 && (bss_desc->bcn_ht_cap)
+	    )
+		) {
+		/* Append a channel TLV for the channel the attempted AP was
+		   found on */
+		chan_tlv = (struct mwifiex_ie_types_chan_list_param_set *) pos;
+		chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
+		chan_tlv->header.len =
+			cpu_to_le16(sizeof(struct mwifiex_chan_scan_param_set));
+
+		memset(chan_tlv->chan_scan_param, 0x00,
+		       sizeof(struct mwifiex_chan_scan_param_set));
+		chan_tlv->chan_scan_param[0].chan_number =
+			(bss_desc->phy_param_set.ds_param_set.current_chan);
+		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Chan = %d\n",
+		       chan_tlv->chan_scan_param[0].chan_number);
+
+		chan_tlv->chan_scan_param[0].radio_type =
+			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
+
+		dev_dbg(priv->adapter->dev, "info: Assoc: TLV Band = %d\n",
+		       chan_tlv->chan_scan_param[0].radio_type);
+		pos += sizeof(chan_tlv->header) +
+			sizeof(struct mwifiex_chan_scan_param_set);
+	}
+
+	if (!priv->wps.session_enable) {
+		if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
+			rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+
+		if (rsn_ie_len == -1)
+			return -1;
+	}
+
+	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
+		&& (!bss_desc->disable_11n)
+	    && (priv->adapter->config_bands & BAND_GN
+		|| priv->adapter->config_bands & BAND_AN))
+		mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
+
+	/* Append vendor specific IE TLV */
+	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ASSOC, &pos);
+
+	mwifiex_wmm_process_association_req(priv, &pos, &bss_desc->wmm_ie,
+					    bss_desc->bcn_ht_cap);
+	if (priv->sec_info.wapi_enabled && priv->wapi_ie_len)
+		mwifiex_cmd_append_wapi_ie(priv, &pos);
+
+
+	mwifiex_cmd_append_generic_ie(priv, &pos);
+
+	mwifiex_cmd_append_tsf_tlv(priv, &pos, bss_desc);
+
+	cmd->size = cpu_to_le16((u16) (pos - (u8 *) assoc) + S_DS_GEN);
+
+	/* Set the Capability info at last */
+	tmp_cap = bss_desc->cap_info_bitmap;
+
+	if (priv->adapter->config_bands == BAND_B)
+		SHORT_SLOT_TIME_DISABLED(tmp_cap);
+
+	tmp_cap &= CAPINFO_MASK;
+	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
+	       tmp_cap, CAPINFO_MASK);
+	assoc->cap_info_bitmap = cpu_to_le16(tmp_cap);
+
+	return 0;
+}
+
+/*
+ * Association firmware command response handler
+ *
+ * The response buffer for the association command has the following
+ * memory layout.
+ *
+ * For cases where an association response was not received (indicated
+ * by the CapInfo and AId field):
+ *
+ *     .------------------------------------------------------------.
+ *     |  Header(4 * sizeof(t_u16)):  Standard command response hdr |
+ *     .------------------------------------------------------------.
+ *     |  cap_info/Error Return(t_u16):                             |
+ *     |           0xFFFF(-1): Internal error                       |
+ *     |           0xFFFE(-2): Authentication unhandled message     |
+ *     |           0xFFFD(-3): Authentication refused               |
+ *     |           0xFFFC(-4): Timeout waiting for AP response      |
+ *     .------------------------------------------------------------.
+ *     |  status_code(t_u16):                                       |
+ *     |        If cap_info is -1:                                  |
+ *     |           An internal firmware failure prevented the       |
+ *     |           command from being processed.  The status_code   |
+ *     |           will be set to 1.                                |
+ *     |                                                            |
+ *     |        If cap_info is -2:                                  |
+ *     |           An authentication frame was received but was     |
+ *     |           not handled by the firmware.  IEEE Status        |
+ *     |           code for the failure is returned.                |
+ *     |                                                            |
+ *     |        If cap_info is -3:                                  |
+ *     |           An authentication frame was received and the     |
+ *     |           status_code is the IEEE Status reported in the   |
+ *     |           response.                                        |
+ *     |                                                            |
+ *     |        If cap_info is -4:                                  |
+ *     |           (1) Association response timeout                 |
+ *     |           (2) Authentication response timeout              |
+ *     .------------------------------------------------------------.
+ *     |  a_id(t_u16): 0xFFFF                                       |
+ *     .------------------------------------------------------------.
+ *
+ *
+ * For cases where an association response was received, the IEEE
+ * standard association response frame is returned:
+ *
+ *     .------------------------------------------------------------.
+ *     |  Header(4 * sizeof(t_u16)):  Standard command response hdr |
+ *     .------------------------------------------------------------.
+ *     |  cap_info(t_u16): IEEE Capability                          |
+ *     .------------------------------------------------------------.
+ *     |  status_code(t_u16): IEEE Status Code                      |
+ *     .------------------------------------------------------------.
+ *     |  a_id(t_u16): IEEE Association ID                          |
+ *     .------------------------------------------------------------.
+ *     |  IEEE IEs(variable): Any received IEs comprising the       |
+ *     |                      remaining portion of a received       |
+ *     |                      association response frame.           |
+ *     .------------------------------------------------------------.
+ *
+ * For simplistic handling, the status_code field can be used to determine
+ * an association success (0) or failure (non-zero).
+ */
+int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *resp, void *wq_buf)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
+	struct ieee_types_assoc_rsp *assoc_rsp;
+	struct mwifiex_bssdescriptor *bss_desc;
+	u8 enable_data = true;
+
+	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
+
+	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
+				     sizeof(priv->assoc_rsp_buf));
+
+	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
+
+	if (le16_to_cpu(assoc_rsp->status_code)) {
+		priv->adapter->dbg.num_cmd_assoc_failure++;
+		dev_err(priv->adapter->dev, "ASSOC_RESP: association failed, "
+		       "status code = %d, error = 0x%x, a_id = 0x%x\n",
+		       le16_to_cpu(assoc_rsp->status_code),
+		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
+		       le16_to_cpu(assoc_rsp->a_id));
+
+		ret = -1;
+		goto done;
+	}
+
+	/* Send a Media Connected event, according to the Spec */
+	priv->media_connected = true;
+
+	priv->adapter->ps_state = PS_STATE_AWAKE;
+	priv->adapter->pps_uapsd_mode = false;
+	priv->adapter->tx_lock_flag = false;
+
+	/* Set the attempted BSSID Index to current */
+	bss_desc = priv->attempted_bss_desc;
+
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: %s\n",
+						bss_desc->ssid.ssid);
+
+	/* Make a copy of current BSSID descriptor */
+	memcpy(&priv->curr_bss_params.bss_descriptor,
+	       bss_desc, sizeof(struct mwifiex_bssdescriptor));
+
+	/* Update curr_bss_params */
+	priv->curr_bss_params.bss_descriptor.channel
+		= bss_desc->phy_param_set.ds_param_set.current_chan;
+
+	priv->curr_bss_params.band = (u8) bss_desc->bss_band;
+
+	/*
+	 * Adjust the timestamps in the scan table to be relative to the newly
+	 * associated AP's TSF
+	 */
+	mwifiex_update_tsf_timestamps(priv, bss_desc);
+
+	if (bss_desc->wmm_ie.vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC)
+		priv->curr_bss_params.wmm_enabled = true;
+	else
+		priv->curr_bss_params.wmm_enabled = false;
+
+	if ((priv->wmm_required || bss_desc->bcn_ht_cap)
+			&& priv->curr_bss_params.wmm_enabled)
+		priv->wmm_enabled = true;
+	else
+		priv->wmm_enabled = false;
+
+	priv->curr_bss_params.wmm_uapsd_enabled = false;
+
+	if (priv->wmm_enabled)
+		priv->curr_bss_params.wmm_uapsd_enabled
+			= ((bss_desc->wmm_ie.qos_info_bitmap &
+				IEEE80211_WMM_IE_AP_QOSINFO_UAPSD) ? 1 : 0);
+
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: curr_pkt_filter is %#x\n",
+	       priv->curr_pkt_filter);
+	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
+		priv->wpa_is_gtk_set = false;
+
+	if (priv->wmm_enabled) {
+		/* Don't re-enable carrier until we get the WMM_GET_STATUS
+		   event */
+		enable_data = false;
+	} else {
+		/* Since WMM is not enabled, setup the queues with the
+		   defaults */
+		mwifiex_wmm_setup_queue_priorities(priv, NULL);
+		mwifiex_wmm_setup_ac_downgrade(priv);
+	}
+
+	if (enable_data)
+		dev_dbg(priv->adapter->dev,
+			"info: post association, re-enabling data flow\n");
+
+	/* Reset SNR/NF/RSSI values */
+	priv->data_rssi_last = 0;
+	priv->data_nf_last = 0;
+	priv->data_rssi_avg = 0;
+	priv->data_nf_avg = 0;
+	priv->bcn_rssi_last = 0;
+	priv->bcn_nf_last = 0;
+	priv->bcn_rssi_avg = 0;
+	priv->bcn_nf_avg = 0;
+	priv->rxpd_rate = 0;
+	priv->rxpd_htinfo = 0;
+
+	mwifiex_save_curr_bcn(priv);
+
+	priv->adapter->dbg.num_cmd_assoc_success++;
+
+	dev_dbg(priv->adapter->dev, "info: ASSOC_RESP: associated\n");
+
+	/* Add the ra_list here for infra mode as there will be only 1 ra
+	   always */
+	mwifiex_ralist_add(priv,
+			   priv->curr_bss_params.bss_descriptor.mac_address);
+
+	if (!netif_carrier_ok(priv->netdev))
+		netif_carrier_on(priv->netdev);
+	if (netif_queue_stopped(priv->netdev))
+		netif_wake_queue(priv->netdev);
+
+	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
+		priv->scan_block = true;
+
+done:
+	/* Need to indicate IOCTL complete */
+	if (wait_queue) {
+		if (ret) {
+			if (assoc_rsp->status_code)
+				wait_queue->status =
+					le16_to_cpu(assoc_rsp->status_code);
+			else
+				wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
+		} else {
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function prepares command for ad-hoc start.
+ *
+ * Driver will fill up SSID, BSS mode, IBSS parameters, physical
+ * parameters, probe delay, and capability information. Firmware
+ * will fill up beacon period, basic rates and operational rates.
+ *
+ * In addition, the following TLVs are added -
+ *      - Channel TLV
+ *      - Vendor specific IE
+ *      - WPA/WPA2 IE
+ *      - HT Capabilities IE
+ *      - HT Information IE
+ *
+ * Preparation also includes -
+ *      - Setting command ID and proper size
+ *      - Ensuring correct endian-ness
+ */
+int
+mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	int ret = 0, rsn_ie_len = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_ad_hoc_start *adhoc_start =
+		&cmd->params.adhoc_start;
+	struct mwifiex_bssdescriptor *bss_desc;
+	u32 cmd_append_size = 0;
+	u32 i;
+	u16 tmp_cap;
+	uint16_t ht_cap_info;
+	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
+
+	struct mwifiex_ie_types_htcap *ht_cap;
+	struct mwifiex_ie_types_htinfo *ht_info;
+	u8 *pos = (u8 *) adhoc_start +
+			sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
+
+	if (!adapter)
+		return -1;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_START);
+
+	bss_desc = &priv->curr_bss_params.bss_descriptor;
+	priv->attempted_bss_desc = bss_desc;
+
+	/*
+	 * Fill in the parameters for 2 data structures:
+	 *   1. struct host_cmd_ds_802_11_ad_hoc_start command
+	 *   2. bss_desc
+	 * Driver will fill up SSID, bss_mode,IBSS param, Physical Param,
+	 * probe delay, and Cap info.
+	 * Firmware will fill up beacon period, Basic rates
+	 * and operational rates.
+	 */
+
+	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
+
+	memcpy(adhoc_start->ssid,
+	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
+	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
+
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: SSID = %s\n",
+				adhoc_start->ssid);
+
+	memset(bss_desc->ssid.ssid, 0, IEEE80211_MAX_SSID_LEN);
+	memcpy(bss_desc->ssid.ssid,
+	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid,
+	       ((struct mwifiex_802_11_ssid *) data_buf)->ssid_len);
+
+	bss_desc->ssid.ssid_len =
+		((struct mwifiex_802_11_ssid *) data_buf)->ssid_len;
+
+	/* Set the BSS mode */
+	adhoc_start->bss_mode = HostCmd_BSS_MODE_IBSS;
+	bss_desc->bss_mode = MWIFIEX_BSS_MODE_IBSS;
+	adhoc_start->beacon_period = cpu_to_le16(priv->beacon_period);
+	bss_desc->beacon_period = priv->beacon_period;
+
+	/* Set Physical param set */
+/* Parameter IE Id */
+#define DS_PARA_IE_ID   3
+/* Parameter IE length */
+#define DS_PARA_IE_LEN  1
+
+	adhoc_start->phy_param_set.ds_param_set.element_id = DS_PARA_IE_ID;
+	adhoc_start->phy_param_set.ds_param_set.len = DS_PARA_IE_LEN;
+
+	if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+			(priv, adapter->adhoc_start_band, (u16)
+				priv->adhoc_channel)) {
+		struct mwifiex_chan_freq_power *cfp;
+		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+				adapter->adhoc_start_band, FIRST_VALID_CHANNEL);
+		if (cfp)
+			priv->adhoc_channel = (u8) cfp->channel;
+	}
+
+	if (!priv->adhoc_channel) {
+		dev_err(adapter->dev, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: creating ADHOC on channel %d\n",
+				priv->adhoc_channel);
+
+	priv->curr_bss_params.bss_descriptor.channel = priv->adhoc_channel;
+	priv->curr_bss_params.band = adapter->adhoc_start_band;
+
+	bss_desc->channel = priv->adhoc_channel;
+	adhoc_start->phy_param_set.ds_param_set.current_chan =
+		priv->adhoc_channel;
+
+	memcpy(&bss_desc->phy_param_set, &adhoc_start->phy_param_set,
+	       sizeof(union ieee_types_phy_param_set));
+
+	/* Set IBSS param set */
+/* IBSS parameter IE Id */
+#define IBSS_PARA_IE_ID   6
+/* IBSS parameter IE length */
+#define IBSS_PARA_IE_LEN  2
+
+	adhoc_start->ss_param_set.ibss_param_set.element_id = IBSS_PARA_IE_ID;
+	adhoc_start->ss_param_set.ibss_param_set.len = IBSS_PARA_IE_LEN;
+	adhoc_start->ss_param_set.ibss_param_set.atim_window
+		= cpu_to_le16(priv->atim_window);
+	memcpy(&bss_desc->ss_param_set, &adhoc_start->ss_param_set,
+	       sizeof(union ieee_types_ss_param_set));
+
+	/* Set Capability info */
+	bss_desc->cap_info_bitmap |= WLAN_CAPABILITY_IBSS;
+	tmp_cap = le16_to_cpu(adhoc_start->cap_info_bitmap);
+	tmp_cap &= ~WLAN_CAPABILITY_ESS;
+	tmp_cap |= WLAN_CAPABILITY_IBSS;
+
+	/* Set up privacy in bss_desc */
+	if (priv->sec_info.encryption_mode != MWIFIEX_ENCRYPTION_MODE_NONE) {
+		/* Ad-Hoc capability privacy on */
+		dev_dbg(adapter->dev,
+			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
+		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
+		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
+	} else {
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: wep_status NOT set,"
+				" setting privacy to ACCEPT ALL\n");
+		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
+	}
+
+	memset(adhoc_start->DataRate, 0, sizeof(adhoc_start->DataRate));
+	mwifiex_get_active_data_rates(priv, adhoc_start->DataRate);
+	if ((adapter->adhoc_start_band & BAND_G) &&
+	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+					  HostCmd_ACT_GEN_SET,
+					  0, NULL, &priv->curr_pkt_filter);
+
+		if (ret) {
+			dev_err(adapter->dev,
+			       "ADHOC_S_CMD: G Protection config failed\n");
+			return -1;
+		}
+	}
+	/* Find the last non zero */
+	for (i = 0; i < sizeof(adhoc_start->DataRate) &&
+			adhoc_start->DataRate[i];
+			i++)
+			;
+
+	priv->curr_bss_params.num_of_rates = i;
+
+	/* Copy the ad-hoc creating rates into Current BSS rate structure */
+	memcpy(&priv->curr_bss_params.data_rates,
+	       &adhoc_start->DataRate, priv->curr_bss_params.num_of_rates);
+
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
+	       adhoc_start->DataRate[0], adhoc_start->DataRate[1],
+	       adhoc_start->DataRate[2], adhoc_start->DataRate[3]);
+
+	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
+
+	if (IS_SUPPORT_MULTI_BANDS(adapter)) {
+		/* Append a channel TLV */
+		chan_tlv = (struct mwifiex_ie_types_chan_list_param_set *) pos;
+		chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
+		chan_tlv->header.len =
+			cpu_to_le16(sizeof(struct mwifiex_chan_scan_param_set));
+
+		memset(chan_tlv->chan_scan_param, 0x00,
+		       sizeof(struct mwifiex_chan_scan_param_set));
+		chan_tlv->chan_scan_param[0].chan_number =
+			(u8) priv->curr_bss_params.bss_descriptor.channel;
+
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Chan = %d\n",
+		       chan_tlv->chan_scan_param[0].chan_number);
+
+		chan_tlv->chan_scan_param[0].radio_type
+		       = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
+		if (adapter->adhoc_start_band & BAND_GN
+		    || adapter->adhoc_start_band & BAND_AN) {
+			if (adapter->chan_offset == SEC_CHANNEL_ABOVE)
+				chan_tlv->chan_scan_param[0].radio_type |=
+					SECOND_CHANNEL_ABOVE;
+			else if (adapter->chan_offset == SEC_CHANNEL_BELOW)
+				chan_tlv->chan_scan_param[0].radio_type |=
+					SECOND_CHANNEL_BELOW;
+		}
+		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Band = %d\n",
+		       chan_tlv->chan_scan_param[0].radio_type);
+		pos += sizeof(chan_tlv->header) +
+			sizeof(struct mwifiex_chan_scan_param_set);
+		cmd_append_size +=
+			sizeof(chan_tlv->header) +
+			sizeof(struct mwifiex_chan_scan_param_set);
+	}
+
+	/* Append vendor specific IE TLV */
+	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
+				MWIFIEX_VSIE_MASK_ADHOC, &pos);
+
+	if (priv->sec_info.wpa_enabled) {
+		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+		if (rsn_ie_len == -1)
+			return -1;
+		cmd_append_size += rsn_ie_len;
+	}
+
+	if (adapter->adhoc_11n_enabled) {
+		{
+			ht_cap = (struct mwifiex_ie_types_htcap *) pos;
+			memset(ht_cap, 0,
+			       sizeof(struct mwifiex_ie_types_htcap));
+			ht_cap->header.type =
+				cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+			ht_cap->header.len =
+			       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
+
+			SETHT_SHORTGI20(ht_cap_info);
+			if (adapter->chan_offset) {
+				SETHT_SHORTGI40(ht_cap_info);
+				SETHT_DSSSCCK40(ht_cap_info);
+				SETHT_SUPPCHANWIDTH(ht_cap_info);
+				SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
+			}
+
+			ht_cap->ht_cap.ampdu_params_info
+					= MAX_RX_AMPDU_SIZE_64K;
+			ht_cap->ht_cap.mcs.rx_mask[0] = 0xff;
+			pos += sizeof(struct mwifiex_ie_types_htcap);
+			cmd_append_size +=
+				sizeof(struct mwifiex_ie_types_htcap);
+		}
+		{
+			ht_info = (struct mwifiex_ie_types_htinfo *) pos;
+			memset(ht_info, 0,
+			       sizeof(struct mwifiex_ie_types_htinfo));
+			ht_info->header.type =
+				cpu_to_le16(WLAN_EID_HT_INFORMATION);
+			ht_info->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_info));
+			ht_info->ht_info.control_chan =
+				(u8) priv->curr_bss_params.bss_descriptor.
+				channel;
+			if (adapter->chan_offset) {
+				ht_info->ht_info.ht_param =
+					adapter->chan_offset;
+				SET_CHANWIDTH40(ht_info->ht_info.ht_param);
+			}
+			ht_info->ht_info.operation_mode =
+				cpu_to_le16(NON_GREENFIELD_STAS);
+			ht_info->ht_info.basic_set[0] = 0xff;
+			pos += sizeof(struct mwifiex_ie_types_htinfo);
+			cmd_append_size +=
+				sizeof(struct mwifiex_ie_types_htinfo);
+		}
+	}
+
+	cmd->size = cpu_to_le16((u16)
+			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_start)
+			     + S_DS_GEN + cmd_append_size));
+
+	if (adapter->adhoc_start_band == BAND_B)
+		SHORT_SLOT_TIME_DISABLED(tmp_cap);
+	else
+		SHORT_SLOT_TIME_ENABLED(tmp_cap);
+
+	adhoc_start->cap_info_bitmap = cpu_to_le16(tmp_cap);
+
+	return 0;
+}
+
+/*
+ * This function prepares command for ad-hoc join.
+ *
+ * Most of the parameters are set up by copying from the target BSS descriptor
+ * from the scan response.
+ *
+ * In addition, the following TLVs are added -
+ *      - Channel TLV
+ *      - Vendor specific IE
+ *      - WPA/WPA2 IE
+ *      - 11n IE
+ *
+ * Preparation also includes -
+ *      - Setting command ID and proper size
+ *      - Ensuring correct endian-ness
+ */
+int
+mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	int ret = 0, rsn_ie_len = 0;
+	struct host_cmd_ds_802_11_ad_hoc_join *adhoc_join =
+		&cmd->params.adhoc_join;
+	struct mwifiex_bssdescriptor *bss_desc =
+		(struct mwifiex_bssdescriptor *) data_buf;
+	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
+	u32 cmd_append_size = 0;
+	u16 tmp_cap;
+	u32 i, rates_size = 0;
+	u16 curr_pkt_filter;
+	u8 *pos =
+		(u8 *) adhoc_join +
+		sizeof(struct host_cmd_ds_802_11_ad_hoc_join);
+
+/* Use G protection */
+#define USE_G_PROTECTION        0x02
+	if (bss_desc->erp_flags & USE_G_PROTECTION) {
+		curr_pkt_filter =
+			priv->
+			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
+
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+					  HostCmd_ACT_GEN_SET, 0, NULL,
+					  &curr_pkt_filter);
+		if (ret) {
+			dev_err(priv->adapter->dev,
+			       "ADHOC_J_CMD: G Protection config failed\n");
+			return -1;
+		}
+	}
+
+	priv->attempted_bss_desc = bss_desc;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_JOIN);
+
+	adhoc_join->bss_descriptor.bss_mode = HostCmd_BSS_MODE_IBSS;
+
+	adhoc_join->bss_descriptor.beacon_period
+		= cpu_to_le16(bss_desc->beacon_period);
+
+	memcpy(&adhoc_join->bss_descriptor.bssid,
+	       &bss_desc->mac_address, ETH_ALEN);
+
+	memcpy(&adhoc_join->bss_descriptor.ssid,
+	       &bss_desc->ssid.ssid, bss_desc->ssid.ssid_len);
+
+	memcpy(&adhoc_join->bss_descriptor.phy_param_set,
+	       &bss_desc->phy_param_set,
+	       sizeof(union ieee_types_phy_param_set));
+
+	memcpy(&adhoc_join->bss_descriptor.ss_param_set,
+	       &bss_desc->ss_param_set, sizeof(union ieee_types_ss_param_set));
+
+	tmp_cap = bss_desc->cap_info_bitmap;
+
+	tmp_cap &= CAPINFO_MASK;
+
+	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: tmp_cap=%4X"
+			" CAPINFO_MASK=%4lX\n", tmp_cap, CAPINFO_MASK);
+
+	/* Information on BSSID descriptor passed to FW */
+	dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: BSSID = %pM, SSID = %s\n",
+				adhoc_join->bss_descriptor.bssid,
+				adhoc_join->bss_descriptor.ssid);
+
+	for (i = 0; bss_desc->supported_rates[i] &&
+			i < MWIFIEX_SUPPORTED_RATES;
+			i++)
+			;
+	rates_size = i;
+
+	/* Copy Data Rates from the Rates recorded in scan response */
+	memset(adhoc_join->bss_descriptor.data_rates, 0,
+	       sizeof(adhoc_join->bss_descriptor.data_rates));
+	memcpy(adhoc_join->bss_descriptor.data_rates,
+	       bss_desc->supported_rates, rates_size);
+
+	/* Copy the adhoc join rates into Current BSS state structure */
+	priv->curr_bss_params.num_of_rates = rates_size;
+	memcpy(&priv->curr_bss_params.data_rates, bss_desc->supported_rates,
+	       rates_size);
+
+	/* Copy the channel information */
+	priv->curr_bss_params.bss_descriptor.channel = bss_desc->channel;
+	priv->curr_bss_params.band = (u8) bss_desc->bss_band;
+
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
+	    || priv->sec_info.wpa_enabled)
+		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
+
+	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)) {
+		/* Append a channel TLV */
+		chan_tlv = (struct mwifiex_ie_types_chan_list_param_set *) pos;
+		chan_tlv->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
+		chan_tlv->header.len =
+			cpu_to_le16(sizeof(struct mwifiex_chan_scan_param_set));
+
+		memset(chan_tlv->chan_scan_param, 0x00,
+		       sizeof(struct mwifiex_chan_scan_param_set));
+		chan_tlv->chan_scan_param[0].chan_number =
+			(bss_desc->phy_param_set.ds_param_set.current_chan);
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Chan = %d\n",
+		       chan_tlv->chan_scan_param[0].chan_number);
+
+		chan_tlv->chan_scan_param[0].radio_type =
+			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
+
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Band = %d\n",
+		       chan_tlv->chan_scan_param[0].radio_type);
+		pos += sizeof(chan_tlv->header) +
+			sizeof(struct mwifiex_chan_scan_param_set);
+		cmd_append_size += sizeof(chan_tlv->header) +
+			sizeof(struct mwifiex_chan_scan_param_set);
+	}
+
+	if (priv->sec_info.wpa_enabled)
+		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+	if (rsn_ie_len == -1)
+		return -1;
+	cmd_append_size += rsn_ie_len;
+
+	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
+		cmd_append_size += mwifiex_cmd_append_11n_tlv(priv,
+			bss_desc, &pos);
+
+	/* Append vendor specific IE TLV */
+	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
+			MWIFIEX_VSIE_MASK_ADHOC, &pos);
+
+	cmd->size = cpu_to_le16((u16)
+			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_join)
+			     + S_DS_GEN + cmd_append_size));
+
+	adhoc_join->bss_descriptor.cap_info_bitmap = cpu_to_le16(tmp_cap);
+
+	return ret;
+}
+
+/*
+ * This function handles the command response of ad-hoc start and
+ * ad-hoc join.
+ *
+ * The function generates a device-connected event to notify
+ * the applications, in case of successful ad-hoc start/join, and
+ * saves the beacon buffer.
+ */
+int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp, void *wq_buf)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
+	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
+	struct mwifiex_bssdescriptor *bss_desc;
+	u16 command = le16_to_cpu(resp->command);
+	u16 result = le16_to_cpu(resp->result);
+
+	adhoc_result = &resp->params.adhoc_result;
+
+	bss_desc = priv->attempted_bss_desc;
+
+	/* Join result code 0 --> SUCCESS */
+	if (result) {
+		dev_err(priv->adapter->dev, "ADHOC_RESP: failed\n");
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
+
+		memset(&priv->curr_bss_params.bss_descriptor,
+		       0x00, sizeof(struct mwifiex_bssdescriptor));
+
+		ret = -1;
+		goto done;
+	}
+
+	/* Send a Media Connected event, according to the Spec */
+	priv->media_connected = true;
+
+	if (command == HostCmd_CMD_802_11_AD_HOC_START) {
+		dev_dbg(priv->adapter->dev, "info: ADHOC_S_RESP %s\n",
+				bss_desc->ssid.ssid);
+
+		/* Update the created network descriptor with the new BSSID */
+		memcpy(bss_desc->mac_address,
+		       adhoc_result->bssid, ETH_ALEN);
+
+		priv->adhoc_state = ADHOC_STARTED;
+	} else {
+		/*
+		 * Now the join cmd should be successful.
+		 * If BSSID has changed use SSID to compare instead of BSSID
+		 */
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_RESP %s\n",
+				bss_desc->ssid.ssid);
+
+		/*
+		 * Make a copy of current BSSID descriptor, only needed for
+		 * join since the current descriptor is already being used
+		 * for adhoc start
+		 */
+		memcpy(&priv->curr_bss_params.bss_descriptor,
+		       bss_desc, sizeof(struct mwifiex_bssdescriptor));
+
+		priv->adhoc_state = ADHOC_JOINED;
+	}
+
+	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: channel = %d\n",
+				priv->adhoc_channel);
+	dev_dbg(priv->adapter->dev, "info: ADHOC_RESP: BSSID = %pM\n",
+	       priv->curr_bss_params.bss_descriptor.mac_address);
+
+	if (!netif_carrier_ok(priv->netdev))
+		netif_carrier_on(priv->netdev);
+	if (netif_queue_stopped(priv->netdev))
+		netif_wake_queue(priv->netdev);
+
+	mwifiex_save_curr_bcn(priv);
+
+done:
+	/* Need to indicate IOCTL complete */
+	if (wait_queue) {
+		if (ret)
+			wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
+		else
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+
+	}
+
+	return ret;
+}
+
+/*
+ * This function associates to a specific BSS discovered in a scan.
+ *
+ * It clears any past association response stored for application
+ * retrieval and calls the command preparation routine to send the
+ * command to firmware.
+ */
+int mwifiex_associate(struct mwifiex_private *priv,
+		      void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+{
+	int ret = 0;
+	u8 current_bssid[ETH_ALEN];
+
+	/* Return error if the adapter or table entry is not marked as infra */
+	if ((priv->bss_mode != MWIFIEX_BSS_MODE_INFRA) ||
+	    (bss_desc->bss_mode != MWIFIEX_BSS_MODE_INFRA))
+		return -1;
+
+	memcpy(&current_bssid,
+	       &priv->curr_bss_params.bss_descriptor.mac_address,
+	       sizeof(current_bssid));
+
+	/* Clear any past association response stored for application
+	   retrieval */
+	priv->assoc_rsp_size = 0;
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_ASSOCIATE,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
+				  bss_desc);
+
+	return ret;
+}
+
+/*
+ * This function starts an ad-hoc network.
+ *
+ * It calls the command preparation routine to send the command to firmware.
+ */
+int
+mwifiex_adhoc_start(struct mwifiex_private *priv,
+		    void *wait_queue, struct mwifiex_802_11_ssid *adhoc_ssid)
+{
+	int ret = 0;
+
+	dev_dbg(priv->adapter->dev, "info: Adhoc Channel = %d\n",
+		priv->adhoc_channel);
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
+	       priv->curr_bss_params.bss_descriptor.channel);
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
+	       priv->curr_bss_params.band);
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_START,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
+				  adhoc_ssid);
+
+	return ret;
+}
+
+/*
+ * This function joins an ad-hoc network found in a previous scan.
+ *
+ * It calls the command preparation routine to send the command to firmware,
+ * if already not connected to the requested SSID.
+ */
+int mwifiex_adhoc_join(struct mwifiex_private *priv,
+		       void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+{
+	int ret = 0;
+
+	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid =%s\n",
+	       priv->curr_bss_params.bss_descriptor.ssid.ssid);
+	dev_dbg(priv->adapter->dev, "info: adhoc join: curr_bss ssid_len =%u\n",
+	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid =%s\n",
+		bss_desc->ssid.ssid);
+	dev_dbg(priv->adapter->dev, "info: adhoc join: ssid_len =%u\n",
+	       bss_desc->ssid.ssid_len);
+
+	/* Check if the requested SSID is already joined */
+	if (priv->curr_bss_params.bss_descriptor.ssid.ssid_len &&
+	    !mwifiex_ssid_cmp(&bss_desc->ssid,
+			      &priv->curr_bss_params.bss_descriptor.ssid) &&
+	    (priv->curr_bss_params.bss_descriptor.bss_mode ==
+	     MWIFIEX_BSS_MODE_IBSS)) {
+		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: new ad-hoc SSID"
+			" is the same as current; not attempting to re-join\n");
+		return -1;
+	}
+
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.channel = %d\n",
+	       priv->curr_bss_params.bss_descriptor.channel);
+	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
+	       priv->curr_bss_params.band);
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
+				  bss_desc);
+
+	return ret;
+}
+
+/*
+ * This function deauthenticates/disconnects from infra network by sending
+ * deauthentication request.
+ */
+static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
+					struct mwifiex_wait_queue *wait,
+					u8 *mac)
+{
+	u8 mac_address[ETH_ALEN];
+	int ret = 0;
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+
+	if (mac) {
+		if (!memcmp(mac, zero_mac, sizeof(zero_mac)))
+			memcpy((u8 *) &mac_address,
+			       (u8 *) &priv->curr_bss_params.bss_descriptor.
+			       mac_address, ETH_ALEN);
+		else
+			memcpy((u8 *) &mac_address, (u8 *) mac, ETH_ALEN);
+	} else {
+		memcpy((u8 *) &mac_address, (u8 *) &priv->curr_bss_params.
+		       bss_descriptor.mac_address, ETH_ALEN);
+	}
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
+				  HostCmd_ACT_GEN_SET, 0, wait, &mac_address);
+
+	if (!ret && wait)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * This function deauthenticates/disconnects from a BSS.
+ *
+ * In case of infra made, it sends deauthentication request, and
+ * in case of ad-hoc mode, a stop network request is sent to the firmware.
+ */
+int mwifiex_deauthenticate(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait, u8 *mac)
+{
+	int ret = 0;
+
+	if (priv->media_connected) {
+		if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+			ret = mwifiex_deauthenticate_infra(priv, wait, mac);
+		} else if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+			ret = mwifiex_prepare_cmd(priv,
+					HostCmd_CMD_802_11_AD_HOC_STOP,
+					HostCmd_ACT_GEN_SET, 0, wait, NULL);
+
+			if (!ret && wait)
+				ret = -EINPROGRESS;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function converts band to radio type used in channel TLV.
+ */
+u8
+mwifiex_band_to_radio_type(u8 band)
+{
+	u8 ret_radio_type;
+
+	switch (band) {
+	case BAND_A:
+	case BAND_AN:
+	case BAND_A | BAND_AN:
+		ret_radio_type = HostCmd_SCAN_RADIO_TYPE_A;
+		break;
+	case BAND_B:
+	case BAND_G:
+	case BAND_B | BAND_G:
+	default:
+		ret_radio_type = HostCmd_SCAN_RADIO_TYPE_BG;
+		break;
+	}
+
+	return ret_radio_type;
+}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
new file mode 100644
index 0000000..ed89ca4
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -0,0 +1,1102 @@
+/*
+ * Marvell Wireless LAN device driver: major functions
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+#include "wmm.h"
+#include "cfg80211.h"
+#include "11n.h"
+
+#define VERSION	"1.0"
+
+const char driver_version[] = "mwifiex " VERSION " (%s) ";
+
+struct mwifiex_adapter *g_adapter;
+EXPORT_SYMBOL_GPL(g_adapter);
+
+static struct mwifiex_bss_attr mwifiex_bss_sta[] = {
+	{MWIFIEX_BSS_TYPE_STA, MWIFIEX_DATA_FRAME_TYPE_ETH_II, true, 0, 0},
+};
+
+static int drv_mode = DRV_MODE_STA;
+
+static char fw_name[32] = DEFAULT_FW_NAME;
+
+/* Supported drv_mode table */
+static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
+	{
+	 /* drv_mode */
+	 .drv_mode = DRV_MODE_STA,
+	 /* intf number */
+	 .intf_num = ARRAY_SIZE(mwifiex_bss_sta),
+	 /* bss_attr */
+	 .bss_attr = mwifiex_bss_sta,
+	 }
+	,
+};
+
+/*
+ * This function registers the device and performs all the necessary
+ * initializations.
+ *
+ * The following initialization operations are performed -
+ *      - Allocate adapter structure
+ *      - Save interface specific operations table in adapter
+ *      - Call interface specific initialization routine
+ *      - Allocate private structures
+ *      - Set default adapter structure parameters
+ *      - Initialize locks
+ *
+ * In case of any errors during inittialization, this function also ensures
+ * proper cleanup before exiting.
+ */
+static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
+			    struct mwifiex_device *mdevice, void **padapter)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = NULL;
+	u8 i = 0;
+
+	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
+	/* Allocate memory for adapter structure */
+	if (!adapter)
+		return -1;
+
+	g_adapter = adapter;
+	adapter->card = card;
+
+	/* Save interface specific operations in adapter */
+	memmove(&adapter->if_ops, if_ops, sizeof(struct mwifiex_if_ops));
+
+	/* card specific initialization has been deferred until now .. */
+	ret = adapter->if_ops.init_if(adapter);
+	if (ret)
+		goto error;
+
+	adapter->priv_num = 0;
+	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
+		adapter->priv[i] = NULL;
+
+		if (!mdevice->bss_attr[i].active)
+			continue;
+
+		/* For valid bss_attr,
+		   allocate memory for private structure */
+		adapter->priv[i] = kzalloc(sizeof(struct mwifiex_private),
+				GFP_KERNEL);
+		if (!adapter->priv[i]) {
+			dev_err(adapter->dev, "%s: failed to alloc priv[%d]\n",
+			       __func__, i);
+			goto error;
+		}
+
+		adapter->priv_num++;
+		memset(adapter->priv[i], 0,
+		       sizeof(struct mwifiex_private));
+		adapter->priv[i]->adapter = adapter;
+		/* Save bss_type, frame_type & bss_priority */
+		adapter->priv[i]->bss_type = (u8) mdevice->bss_attr[i].bss_type;
+		adapter->priv[i]->frame_type =
+			(u8) mdevice->bss_attr[i].frame_type;
+		adapter->priv[i]->bss_priority =
+			(u8) mdevice->bss_attr[i].bss_priority;
+		if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_STA)
+			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_STA;
+		else if (mdevice->bss_attr[i].bss_type == MWIFIEX_BSS_TYPE_UAP)
+			adapter->priv[i]->bss_role = MWIFIEX_BSS_ROLE_UAP;
+
+		/* Save bss_index & bss_num */
+		adapter->priv[i]->bss_index = i;
+		adapter->priv[i]->bss_num = mdevice->bss_attr[i].bss_num;
+	}
+
+	/* Initialize lock variables */
+	if (mwifiex_init_lock_list(adapter))
+		goto error;
+
+	init_timer(&adapter->cmd_timer);
+	adapter->cmd_timer.function = mwifiex_cmd_timeout_func;
+	adapter->cmd_timer.data = (unsigned long) adapter;
+
+	/* Return pointer of struct mwifiex_adapter */
+	*padapter = adapter;
+	return 0;
+
+error:
+	dev_dbg(adapter->dev, "info: leave mwifiex_register with error\n");
+
+	/* Free lock variables */
+	mwifiex_free_lock_list(adapter);
+	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++)
+		kfree(adapter->priv[i]);
+	kfree(adapter);
+
+	return -1;
+}
+
+/*
+ * This function unregisters the device and performs all the necessary
+ * cleanups.
+ *
+ * The following cleanup operations are performed -
+ *      - Free the timers
+ *      - Free beacon buffers
+ *      - Free private structures
+ *      - Free adapter structure
+ */
+static int mwifiex_unregister(struct mwifiex_adapter *adapter)
+{
+	s32 i = 0;
+
+	del_timer(&adapter->cmd_timer);
+
+	/* Free private structures */
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			mwifiex_free_curr_bcn(adapter->priv[i]);
+			kfree(adapter->priv[i]);
+		}
+	}
+
+	kfree(adapter);
+	return 0;
+}
+
+/*
+ * The main process.
+ *
+ * This function is the main procedure of the driver and handles various driver
+ * operations. It runs in a loop and provides the core functionalities.
+ *
+ * The main responsibilities of this function are -
+ *      - Ensure concurrency control
+ *      - Handle pending interrupts and call interrupt handlers
+ *      - Wake up the card if required
+ *      - Handle command responses and call response handlers
+ *      - Handle events and call event handlers
+ *      - Execute pending commands
+ *      - Transmit pending data packets
+ */
+int mwifiex_main_process(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+
+	/* Check if already processing */
+	if (adapter->mwifiex_processing) {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+		goto exit_main_proc;
+	} else {
+		adapter->mwifiex_processing = true;
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+	}
+process_start:
+	do {
+		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
+		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
+			break;
+
+		/* Handle pending interrupt if any */
+		if (adapter->int_status) {
+			if (adapter->hs_activated)
+				mwifiex_process_hs_config(adapter);
+			adapter->if_ops.process_int_status(adapter);
+		}
+
+		/* Need to wake up the card ? */
+		if ((adapter->ps_state == PS_STATE_SLEEP) &&
+		    (adapter->pm_wakeup_card_req &&
+		     !adapter->pm_wakeup_fw_try) &&
+		    (is_command_pending(adapter)
+		     || !mwifiex_wmm_lists_empty(adapter))) {
+			adapter->pm_wakeup_fw_try = true;
+			adapter->if_ops.wakeup(adapter);
+			continue;
+		}
+		if (IS_CARD_RX_RCVD(adapter)) {
+			adapter->pm_wakeup_fw_try = false;
+			if (adapter->ps_state == PS_STATE_SLEEP)
+				adapter->ps_state = PS_STATE_AWAKE;
+		} else {
+			/* We have tried to wakeup the card already */
+			if (adapter->pm_wakeup_fw_try)
+				break;
+			if (adapter->ps_state != PS_STATE_AWAKE ||
+			    adapter->tx_lock_flag)
+				break;
+
+			if (adapter->scan_processing || adapter->data_sent
+			    || mwifiex_wmm_lists_empty(adapter)) {
+				if (adapter->cmd_sent || adapter->curr_cmd
+				    || (!is_command_pending(adapter)))
+					break;
+			}
+		}
+
+		/* Check for Cmd Resp */
+		if (adapter->cmd_resp_received) {
+			adapter->cmd_resp_received = false;
+			mwifiex_process_cmdresp(adapter);
+
+			/* call mwifiex back when init_fw is done */
+			if (adapter->hw_status == MWIFIEX_HW_STATUS_INIT_DONE) {
+				adapter->hw_status = MWIFIEX_HW_STATUS_READY;
+				mwifiex_init_fw_complete(adapter);
+			}
+		}
+
+		/* Check for event */
+		if (adapter->event_received) {
+			adapter->event_received = false;
+			mwifiex_process_event(adapter);
+		}
+
+		/* Check if we need to confirm Sleep Request
+		   received previously */
+		if (adapter->ps_state == PS_STATE_PRE_SLEEP) {
+			if (!adapter->cmd_sent && !adapter->curr_cmd)
+				mwifiex_check_ps_cond(adapter);
+		}
+
+		/* * The ps_state may have been changed during processing of
+		 * Sleep Request event.
+		 */
+		if ((adapter->ps_state == PS_STATE_SLEEP)
+		    || (adapter->ps_state == PS_STATE_PRE_SLEEP)
+		    || (adapter->ps_state == PS_STATE_SLEEP_CFM)
+		    || adapter->tx_lock_flag)
+			continue;
+
+		if (!adapter->cmd_sent && !adapter->curr_cmd) {
+			if (mwifiex_exec_next_cmd(adapter) == -1) {
+				ret = -1;
+				break;
+			}
+		}
+
+		if (!adapter->scan_processing && !adapter->data_sent &&
+		    !mwifiex_wmm_lists_empty(adapter)) {
+			mwifiex_wmm_process_tx(adapter);
+			if (adapter->hs_activated) {
+				adapter->is_hs_configured = false;
+				mwifiex_hs_activated_event
+					(mwifiex_get_priv
+					 (adapter, MWIFIEX_BSS_ROLE_ANY),
+					 false);
+			}
+		}
+
+		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
+		    !adapter->curr_cmd && !is_command_pending(adapter)
+		    && mwifiex_wmm_lists_empty(adapter)) {
+			if (!mwifiex_send_null_packet
+			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
+			     MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
+			     MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET)) {
+				adapter->delay_null_pkt = false;
+				adapter->ps_state = PS_STATE_SLEEP;
+			}
+			break;
+		}
+	} while (true);
+
+	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
+		goto process_start;
+
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	adapter->mwifiex_processing = false;
+	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+
+exit_main_proc:
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
+		mwifiex_shutdown_drv(adapter);
+	return ret;
+}
+
+/*
+ * This function initializes the software.
+ *
+ * The main work includes allocating and initializing the adapter structure
+ * and initializing the private structures.
+ */
+static int
+mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
+{
+	int i;
+	struct mwifiex_device device;
+	struct mwifiex_drv_mode *drv_mode_ptr;
+
+	/* find mwifiex_drv_mode entry from mwifiex_drv_mode_tbl */
+	drv_mode_ptr = NULL;
+	for (i = 0; i < ARRAY_SIZE(mwifiex_drv_mode_tbl); i++) {
+		if (mwifiex_drv_mode_tbl[i].drv_mode == drv_mode) {
+			drv_mode_ptr = &mwifiex_drv_mode_tbl[i];
+			break;
+		}
+	}
+
+	if (!drv_mode_ptr) {
+		pr_err("invalid drv_mode=%d\n", drv_mode);
+		return -1;
+	}
+
+	memset(&device, 0, sizeof(struct mwifiex_device));
+
+	for (i = 0; i < drv_mode_ptr->intf_num; i++) {
+		device.bss_attr[i].bss_type =
+			drv_mode_ptr->bss_attr[i].bss_type;
+		device.bss_attr[i].frame_type =
+			drv_mode_ptr->bss_attr[i].frame_type;
+		device.bss_attr[i].active = drv_mode_ptr->bss_attr[i].active;
+		device.bss_attr[i].bss_priority =
+			drv_mode_ptr->bss_attr[i].bss_priority;
+		device.bss_attr[i].bss_num = drv_mode_ptr->bss_attr[i].bss_num;
+	}
+
+	if (mwifiex_register(card, if_ops, &device, pmwifiex))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This function frees the adapter structure.
+ *
+ * Additionally, this closes the netlink socket, frees the timers
+ * and private structures.
+ */
+static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
+{
+	if (!adapter) {
+		pr_err("%s: adapter is NULL\n", __func__);
+		return;
+	}
+
+	mwifiex_unregister(adapter);
+	pr_debug("info: %s: free adapter\n", __func__);
+}
+
+/*
+ * This function initializes the hardware and firmware.
+ *
+ * The main initialization steps followed are -
+ *      - Download the correct firmware to card
+ *      - Allocate and initialize the adapter structure
+ *      - Initialize the private structures
+ *      - Issue the init commands to firmware
+ */
+static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	int err;
+	struct mwifiex_fw_image fw;
+
+	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
+
+	switch (adapter->revision_id) {
+	case SD8787_W0:
+	case SD8787_W1:
+		strcpy(fw_name, SD8787_W1_FW_NAME);
+		break;
+	case SD8787_A0:
+	case SD8787_A1:
+		strcpy(fw_name, SD8787_AX_FW_NAME);
+		break;
+	default:
+		break;
+	}
+
+	err = request_firmware(&adapter->firmware, fw_name, adapter->dev);
+	if (err < 0) {
+		dev_err(adapter->dev, "request_firmware() returned"
+				" error code %#x\n", err);
+		ret = -1;
+		goto done;
+	}
+	fw.fw_buf = (u8 *) adapter->firmware->data;
+	fw.fw_len = adapter->firmware->size;
+
+	ret = mwifiex_dnld_fw(adapter, &fw);
+	if (ret == -1)
+		goto done;
+
+	dev_notice(adapter->dev, "WLAN FW is active\n");
+
+	adapter->init_wait_q_woken = false;
+	ret = mwifiex_init_fw(adapter);
+	if (ret == -1) {
+		goto done;
+	} else if (!ret) {
+		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
+		goto done;
+	}
+	/* Wait for mwifiex_init to complete */
+	wait_event_interruptible(adapter->init_wait_q,
+				 adapter->init_wait_q_woken);
+	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
+		ret = -1;
+		goto done;
+	}
+	ret = 0;
+
+done:
+	if (adapter->firmware)
+		release_firmware(adapter->firmware);
+	if (ret)
+		ret = -1;
+	return ret;
+}
+
+/*
+ * This function fills a driver buffer.
+ *
+ * The function associates a given SKB with the provided driver buffer
+ * and also updates some of the SKB parameters, including IP header,
+ * priority and timestamp.
+ */
+static void
+mwifiex_fill_buffer(struct sk_buff *skb)
+{
+	struct ethhdr *eth = NULL;
+	struct iphdr *iph;
+	struct timeval tv;
+	u8 tid = 0;
+
+	eth = (struct ethhdr *) skb->data;
+	switch (eth->h_proto) {
+	case __constant_htons(ETH_P_IP):
+		iph = ip_hdr(skb);
+		tid = IPTOS_PREC(iph->tos);
+		pr_debug("data: packet type ETH_P_IP: %04x, tid=%#x prio=%#x\n",
+		       eth->h_proto, tid, skb->priority);
+		break;
+	case __constant_htons(ETH_P_ARP):
+		pr_debug("data: ARP packet: %04x\n", eth->h_proto);
+	default:
+		break;
+	}
+/* Offset for TOS field in the IP header */
+#define IPTOS_OFFSET 5
+	tid = (tid >> IPTOS_OFFSET);
+	skb->priority = tid;
+	/* Record the current time the packet was queued; used to
+	   determine the amount of time the packet was queued in
+	   the driver before it was sent to the firmware.
+	   The delay is then sent along with the packet to the
+	   firmware for aggregate delay calculation for stats and
+	   MSDU lifetime expiry.
+	 */
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
+	return;
+}
+
+/*
+ * CFG802.11 network device handler for open.
+ *
+ * Starts the data queue.
+ */
+static int
+mwifiex_open(struct net_device *dev)
+{
+	netif_start_queue(dev);
+	return 0;
+}
+
+/*
+ * CFG802.11 network device handler for close.
+ */
+static int
+mwifiex_close(struct net_device *dev)
+{
+	return 0;
+}
+
+/*
+ * CFG802.11 network device handler for data transmission.
+ */
+static int
+mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct sk_buff *new_skb = NULL;
+	struct mwifiex_txinfo *tx_info;
+
+	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d): Data <= kernel\n",
+				jiffies, priv->bss_index);
+
+	if (priv->adapter->surprise_removed) {
+		kfree(skb);
+		priv->stats.tx_dropped++;
+		return 0;
+	}
+	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
+		dev_err(priv->adapter->dev, "Tx: bad skb len %d\n", skb->len);
+		kfree(skb);
+		priv->stats.tx_dropped++;
+		return 0;
+	}
+	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
+		dev_dbg(priv->adapter->dev,
+			"data: Tx: insufficient skb headroom %d\n",
+		       skb_headroom(skb));
+		/* Insufficient skb headroom - allocate a new skb */
+		new_skb =
+			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
+		if (unlikely(!new_skb)) {
+			dev_err(priv->adapter->dev, "Tx: cannot alloca new_skb\n");
+			kfree(skb);
+			priv->stats.tx_dropped++;
+			return 0;
+		}
+		kfree_skb(skb);
+		skb = new_skb;
+		dev_dbg(priv->adapter->dev, "info: new skb headroomd %d\n",
+				skb_headroom(skb));
+	}
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_index = priv->bss_index;
+	mwifiex_fill_buffer(skb);
+
+	mwifiex_wmm_add_buf_txqueue(priv->adapter, skb);
+	atomic_inc(&priv->adapter->tx_pending);
+
+	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
+		netif_stop_queue(priv->netdev);
+		dev->trans_start = jiffies;
+	}
+
+	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
+
+	return 0;
+}
+
+/*
+ * CFG802.11 network device handler for setting MAC address.
+ */
+static int
+mwifiex_set_mac_address(struct net_device *dev, void *addr)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct sockaddr *hw_addr = (struct sockaddr *) addr;
+
+	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
+
+	if (mwifiex_request_set_mac_address(priv)) {
+		dev_err(priv->adapter->dev, "set MAC address failed\n");
+		return -EFAULT;
+	}
+	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
+
+	return 0;
+}
+
+/*
+ * CFG802.11 network device handler for setting multicast list.
+ */
+static void mwifiex_set_multicast_list(struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	mwifiex_request_set_multicast_list(priv, dev);
+}
+
+/*
+ * CFG802.11 network device handler for transmission timeout.
+ */
+static void
+mwifiex_tx_timeout(struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_index=%d\n",
+				jiffies, priv->bss_index);
+	dev->trans_start = jiffies;
+	priv->num_tx_timeout++;
+}
+
+/*
+ * CFG802.11 network device handler for statistics retrieval.
+ */
+static struct net_device_stats *mwifiex_get_stats(struct net_device *dev)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	return &priv->stats;
+}
+
+/* Network device handlers */
+static const struct net_device_ops mwifiex_netdev_ops = {
+	.ndo_open = mwifiex_open,
+	.ndo_stop = mwifiex_close,
+	.ndo_start_xmit = mwifiex_hard_start_xmit,
+	.ndo_set_mac_address = mwifiex_set_mac_address,
+	.ndo_tx_timeout = mwifiex_tx_timeout,
+	.ndo_get_stats = mwifiex_get_stats,
+	.ndo_set_multicast_list = mwifiex_set_multicast_list,
+};
+
+/*
+ * This function initializes the private structure parameters.
+ *
+ * The following wait queues are initialized -
+ *      - IOCTL wait queue
+ *      - Command wait queue
+ *      - Statistics wait queue
+ *
+ * ...and the following default parameters are set -
+ *      - Current key index     : Set to 0
+ *      - Rate index            : Set to auto
+ *      - Media connected       : Set to disconnected
+ *      - Adhoc link sensed     : Set to false
+ *      - Nick name             : Set to null
+ *      - Number of Tx timeout  : Set to 0
+ *      - Device address        : Set to current address
+ *
+ * In addition, the CFG80211 work queue is also created.
+ */
+static void
+mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
+{
+	dev->netdev_ops = &mwifiex_netdev_ops;
+	/* Initialize private structure */
+	init_waitqueue_head(&priv->ioctl_wait_q);
+	init_waitqueue_head(&priv->cmd_wait_q);
+	init_waitqueue_head(&priv->w_stats_wait_q);
+	priv->current_key_index = 0;
+	priv->media_connected = false;
+	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
+	priv->num_tx_timeout = 0;
+	priv->workqueue = create_singlethread_workqueue("cfg80211_wq");
+	INIT_WORK(&priv->cfg_workqueue, mwifiex_cfg80211_results);
+	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
+}
+
+/*
+ * This function adds a new logical interface.
+ *
+ * It allocates, initializes and registers the interface by performing
+ * the following opearations -
+ *      - Allocate a new net device structure
+ *      - Assign device name
+ *      - Register the new device with CFG80211 subsystem
+ *      - Initialize semaphore and private structure
+ *      - Register the new device with kernel
+ *      - Create the complete debug FS structure if configured
+ */
+static struct mwifiex_private *mwifiex_add_interface(
+			struct mwifiex_adapter *adapter,
+			u8 bss_index, u8 bss_type)
+{
+	struct net_device *dev = NULL;
+	struct mwifiex_private *priv = NULL;
+	void *mdev_priv = NULL;
+
+	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
+			      ether_setup, 1);
+	if (!dev) {
+		dev_err(adapter->dev, "no memory available for netdevice\n");
+		goto error;
+	}
+	if (dev_alloc_name(dev, dev->name)) {
+		dev_err(adapter->dev, "unable to alloc name for netdevice\n");
+		goto error;
+	}
+
+	if (mwifiex_register_cfg80211(dev, adapter->priv[bss_index]->curr_addr,
+				      adapter->priv[bss_index]) != 0) {
+		dev_err(adapter->dev, "cannot register netdevice with cfg80211\n");
+		goto error;
+	}
+	/* Save the priv pointer in netdev */
+	priv = adapter->priv[bss_index];
+	mdev_priv = netdev_priv(dev);
+	*((unsigned long *) mdev_priv) = (unsigned long) priv;
+
+	priv->netdev = dev;
+
+	sema_init(&priv->async_sem, 1);
+	priv->scan_pending_on_block = false;
+
+	mwifiex_init_priv_params(priv, dev);
+
+	SET_NETDEV_DEV(dev, adapter->dev);
+
+	/* Register network device */
+	if (register_netdev(dev)) {
+		dev_err(adapter->dev, "cannot register virtual network device\n");
+		goto error;
+	}
+
+	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_dev_debugfs_init(priv);
+#endif
+	return priv;
+error:
+	if (dev)
+		free_netdev(dev);
+	return NULL;
+}
+
+/*
+ * This function removes a logical interface.
+ *
+ * It deregisters, resets and frees the interface by performing
+ * the following operations -
+ *      - Disconnect the device if connected, send wireless event to
+ *        notify applications.
+ *      - Remove the debug FS structure if configured
+ *      - Unregister the device from kernel
+ *      - Free the net device structure
+ *      - Cancel all works and destroy work queue
+ *      - Unregister and free the wireless device from CFG80211 subsystem
+ */
+static void
+mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
+{
+	struct net_device *dev = NULL;
+	struct mwifiex_private *priv = adapter->priv[bss_index];
+
+	if (!priv)
+		return;
+	dev = priv->netdev;
+
+	if (priv->media_connected)
+		priv->media_connected = false;
+
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_dev_debugfs_remove(priv);
+#endif
+	/* Last reference is our one */
+	dev_dbg(adapter->dev, "info: %s: refcnt = %d\n",
+				dev->name, netdev_refcnt_read(dev));
+
+	if (dev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(dev);
+
+	/* Clear the priv in adapter */
+	priv->netdev = NULL;
+	if (dev)
+		free_netdev(dev);
+
+	cancel_work_sync(&priv->cfg_workqueue);
+	flush_workqueue(priv->workqueue);
+	destroy_workqueue(priv->workqueue);
+	wiphy_unregister(priv->wdev->wiphy);
+	wiphy_free(priv->wdev->wiphy);
+	kfree(priv->wdev);
+
+	return;
+}
+
+/*
+ * Sends IOCTL request to shutdown firmware.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	/* Allocate an IOCTL request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_misc_ioctl_init_shutdown(priv->adapter, wait,
+						  MWIFIEX_FUNC_SHUTDOWN);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	kfree(wait);
+	return status;
+}
+EXPORT_SYMBOL_GPL(mwifiex_shutdown_fw);
+
+/*
+ * This function check if command is pending.
+ */
+int is_command_pending(struct mwifiex_adapter *adapter)
+{
+	unsigned long flags;
+	int is_cmd_pend_q_empty;
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	is_cmd_pend_q_empty = list_empty(&adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+	return !is_cmd_pend_q_empty;
+}
+
+/*
+ * This function returns the correct private structure pointer based
+ * upon the BSS number.
+ */
+struct mwifiex_private *
+mwifiex_bss_index_to_priv(struct mwifiex_adapter *adapter, u8 bss_index)
+{
+	if (!adapter || (bss_index >= adapter->priv_num))
+		return NULL;
+	return adapter->priv[bss_index];
+}
+
+/*
+ * This is the main work queue function.
+ *
+ * It handles the main process, which in turn handles the complete
+ * driver operations.
+ */
+static void mwifiex_main_work_queue(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+		container_of(work, struct mwifiex_adapter, main_work);
+
+	if (adapter->surprise_removed)
+		return;
+	mwifiex_main_process(adapter);
+}
+
+/*
+ * This function cancels all works in the queue and destroys
+ * the main workqueue.
+ */
+static void
+mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
+{
+	flush_workqueue(adapter->workqueue);
+	destroy_workqueue(adapter->workqueue);
+	adapter->workqueue = NULL;
+}
+
+/*
+ * This function adds the card.
+ *
+ * This function follows the following major steps to set up the device -
+ *      - Initialize software. This includes probing the card, registering
+ *        the interface operations table, and allocating/initializing the
+ *        adapter structure
+ *      - Set up the netlink socket
+ *      - Create and start the main work queue
+ *      - Register the device
+ *      - Initialize firmware and hardware
+ *      - Add logical interfaces
+ */
+int
+mwifiex_add_card(void *card, struct semaphore *sem,
+		 struct mwifiex_if_ops *if_ops)
+{
+	int status = 0;
+	int i;
+	struct mwifiex_adapter *adapter = NULL;
+	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
+
+	if (down_interruptible(sem))
+		goto exit_sem_err;
+
+	if (mwifiex_init_sw(card, if_ops, (void **) &adapter)) {
+		pr_err("%s: software init failed\n", __func__);
+		goto err_init_sw;
+	}
+
+	adapter->drv_mode = drv_mode_info;
+
+	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
+	/* PnP and power profile */
+	adapter->surprise_removed = false;
+	init_waitqueue_head(&adapter->init_wait_q);
+	adapter->is_suspended = false;
+	adapter->hs_activated = false;
+	init_waitqueue_head(&adapter->hs_activate_wait_q);
+
+	/* Create workqueue */
+	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
+	if (!adapter->workqueue)
+		goto err_kmalloc;
+
+	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
+
+	/* Register the device. Fill up the private data structure with relevant
+	   information from the card and request for the required IRQ. */
+	if (adapter->if_ops.register_dev(adapter)) {
+		pr_err("%s: failed to register mwifiex device\n", __func__);
+		goto err_registerdev;
+	}
+
+	/* Init FW and HW */
+	if (mwifiex_init_hw_fw(adapter)) {
+		pr_err("%s: firmware init failed\n", __func__);
+		goto err_init_fw;
+	}
+	/* Add interfaces */
+	for (i = 0; i < drv_mode_info->intf_num; i++) {
+		if (!mwifiex_add_interface(adapter, i,
+				adapter->drv_mode->bss_attr[i].bss_type)) {
+			status = -1;
+			break;
+		}
+	}
+	if (status)
+		goto err_add_intf;
+
+	up(sem);
+
+	return 0;
+
+err_add_intf:
+	for (i = 0; i < adapter->priv_num; i++)
+		mwifiex_remove_interface(adapter, i);
+err_init_fw:
+	/* Unregister device */
+	pr_debug("info: %s: unregister device\n", __func__);
+	adapter->if_ops.unregister_dev(adapter);
+err_registerdev:
+	adapter->surprise_removed = true;
+	mwifiex_terminate_workqueue(adapter);
+err_kmalloc:
+	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
+	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
+		pr_debug("info: %s: shutdown mwifiex\n", __func__);
+		adapter->init_wait_q_woken = false;
+		status = mwifiex_shutdown_drv(adapter);
+		if (status == -EINPROGRESS)
+			wait_event_interruptible(adapter->init_wait_q,
+						 adapter->init_wait_q_woken);
+	}
+
+	mwifiex_free_adapter(adapter);
+
+err_init_sw:
+	up(sem);
+
+exit_sem_err:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(mwifiex_add_card);
+
+/*
+ * This function removes the card.
+ *
+ * This function follows the following major steps to remove the device -
+ *      - Stop data traffic
+ *      - Shutdown firmware
+ *      - Remove the logical interfaces
+ *      - Terminate the work queue
+ *      - Unregister the device
+ *      - Free the adapter structure
+ */
+int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
+{
+	struct mwifiex_private *priv = NULL;
+	int status;
+	int i;
+
+	if (down_interruptible(sem))
+		goto exit_sem_err;
+
+	if (!adapter)
+		goto exit_remove;
+
+	adapter->surprise_removed = true;
+
+	/* Stop data */
+	for (i = 0; i < adapter->priv_num; i++) {
+		priv = adapter->priv[i];
+		if (priv) {
+			if (!netif_queue_stopped(priv->netdev))
+				netif_stop_queue(priv->netdev);
+			if (netif_carrier_ok(priv->netdev))
+				netif_carrier_off(priv->netdev);
+		}
+	}
+
+	dev_dbg(adapter->dev, "cmd: calling mwifiex_shutdown_drv...\n");
+	adapter->init_wait_q_woken = false;
+	status = mwifiex_shutdown_drv(adapter);
+	if (status == -EINPROGRESS)
+		wait_event_interruptible(adapter->init_wait_q,
+					 adapter->init_wait_q_woken);
+	dev_dbg(adapter->dev, "cmd: mwifiex_shutdown_drv done\n");
+	if (atomic_read(&adapter->rx_pending) ||
+	    atomic_read(&adapter->tx_pending) ||
+	    atomic_read(&adapter->ioctl_pending)) {
+		dev_err(adapter->dev, "rx_pending=%d, tx_pending=%d, "
+		       "ioctl_pending=%d\n",
+		       atomic_read(&adapter->rx_pending),
+		       atomic_read(&adapter->tx_pending),
+		       atomic_read(&adapter->ioctl_pending));
+	}
+
+	/* Remove interface */
+	for (i = 0; i < adapter->priv_num; i++)
+		mwifiex_remove_interface(adapter, i);
+
+	mwifiex_terminate_workqueue(adapter);
+
+	/* Unregister device */
+	dev_dbg(adapter->dev, "info: unregister device\n");
+	adapter->if_ops.unregister_dev(adapter);
+	/* Free adapter structure */
+	dev_dbg(adapter->dev, "info: free adapter\n");
+	mwifiex_free_adapter(adapter);
+
+exit_remove:
+	up(sem);
+exit_sem_err:
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mwifiex_remove_card);
+
+/*
+ * This function initializes the module.
+ *
+ * The debug FS is also initialized if configured.
+ */
+static int
+mwifiex_init_module(void)
+{
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_debugfs_init();
+#endif
+	return 0;
+}
+
+/*
+ * This function cleans up the module.
+ *
+ * The debug FS is removed if available.
+ */
+static void
+mwifiex_cleanup_module(void)
+{
+#ifdef CONFIG_DEBUG_FS
+	mwifiex_debugfs_remove();
+#endif
+}
+
+module_init(mwifiex_init_module);
+module_exit(mwifiex_cleanup_module);
+
+MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_DESCRIPTION("Marvell WiFi-Ex Driver version " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
new file mode 100644
index 0000000..2b0ad8e
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -0,0 +1,1081 @@
+/*
+ * Marvell Wireless LAN device driver: major data structures and prototypes
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_MAIN_H_
+#define _MWIFIEX_MAIN_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <net/sock.h>
+#include <net/lib80211.h>
+#include <linux/firmware.h>
+#include <linux/ctype.h>
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+
+extern const char driver_version[];
+extern struct mwifiex_adapter *g_adapter;
+
+enum {
+	MWIFIEX_NO_WAIT,
+	MWIFIEX_IOCTL_WAIT,
+	MWIFIEX_CMD_WAIT,
+	MWIFIEX_PROC_WAIT,
+	MWIFIEX_WSTATS_WAIT
+};
+
+#define DRV_MODE_STA       0x1
+#define DRV_MODE_UAP       0x2
+#define DRV_MODE_UAP_STA   0x3
+
+#define SD8787_W0   0x30
+#define SD8787_W1   0x31
+#define SD8787_A0   0x40
+#define SD8787_A1   0x41
+
+#define DEFAULT_FW_NAME "mrvl/sd8787_uapsta.bin"
+#define SD8787_W1_FW_NAME "mrvl/sd8787_uapsta_w1.bin"
+#define SD8787_AX_FW_NAME "mrvl/sd8787_uapsta.bin"
+
+struct mwifiex_drv_mode {
+	u16 drv_mode;
+	u16 intf_num;
+	struct mwifiex_bss_attr *bss_attr;
+};
+
+
+#define MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT	(5 * HZ)
+
+#define MWIFIEX_TIMER_10S			10000
+#define MWIFIEX_TIMER_1S			1000
+
+#define NL_MAX_PAYLOAD      1024
+#define NL_MULTICAST_GROUP  1
+
+#define MAX_TX_PENDING      60
+
+#define HEADER_ALIGNMENT                8
+
+#define MWIFIEX_UPLD_SIZE               (2312)
+
+#define MAX_EVENT_SIZE                  1024
+
+#define ARP_FILTER_MAX_BUF_SIZE         68
+
+#define MWIFIEX_KEY_BUFFER_SIZE			16
+#define MWIFIEX_DEFAULT_LISTEN_INTERVAL 10
+#define MWIFIEX_MAX_REGION_CODE         7
+
+#define DEFAULT_BCN_AVG_FACTOR          8
+#define DEFAULT_DATA_AVG_FACTOR         8
+
+#define FIRST_VALID_CHANNEL				0xff
+#define DEFAULT_AD_HOC_CHANNEL			6
+#define DEFAULT_AD_HOC_CHANNEL_A		36
+
+#define DEFAULT_BCN_MISS_TIMEOUT		5
+
+#define MAX_SCAN_BEACON_BUFFER			8000
+
+#define SCAN_BEACON_ENTRY_PAD			6
+
+#define MWIFIEX_PASSIVE_SCAN_CHAN_TIME	200
+#define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	200
+#define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	110
+
+#define SCAN_RSSI(RSSI)					(0x100 - ((u8)(RSSI)))
+
+#define MWIFIEX_MAX_TOTAL_SCAN_TIME	(MWIFIEX_TIMER_10S - MWIFIEX_TIMER_1S)
+
+#define RSN_GTK_OUI_OFFSET				2
+
+#define MWIFIEX_OUI_NOT_PRESENT			0
+#define MWIFIEX_OUI_PRESENT				1
+
+#define IS_CARD_RX_RCVD(adapter) (adapter->cmd_resp_received || \
+					adapter->event_received || \
+					adapter->data_received)
+
+#define MWIFIEX_TYPE_CMD				1
+#define MWIFIEX_TYPE_DATA				0
+#define MWIFIEX_TYPE_EVENT				3
+
+#define DBG_CMD_NUM						5
+
+#define MAX_BITMAP_RATES_SIZE			10
+
+#define MAX_CHANNEL_BAND_BG     14
+
+#define MAX_FREQUENCY_BAND_BG   2484
+
+struct mwifiex_dbg {
+	u32 num_cmd_host_to_card_failure;
+	u32 num_cmd_sleep_cfm_host_to_card_failure;
+	u32 num_tx_host_to_card_failure;
+	u32 num_event_deauth;
+	u32 num_event_disassoc;
+	u32 num_event_link_lost;
+	u32 num_cmd_deauth;
+	u32 num_cmd_assoc_success;
+	u32 num_cmd_assoc_failure;
+	u32 num_tx_timeout;
+	u32 num_cmd_timeout;
+	u16 timeout_cmd_id;
+	u16 timeout_cmd_act;
+	u16 last_cmd_id[DBG_CMD_NUM];
+	u16 last_cmd_act[DBG_CMD_NUM];
+	u16 last_cmd_index;
+	u16 last_cmd_resp_id[DBG_CMD_NUM];
+	u16 last_cmd_resp_index;
+	u16 last_event[DBG_CMD_NUM];
+	u16 last_event_index;
+};
+
+enum MWIFIEX_HARDWARE_STATUS {
+	MWIFIEX_HW_STATUS_READY,
+	MWIFIEX_HW_STATUS_INITIALIZING,
+	MWIFIEX_HW_STATUS_FW_READY,
+	MWIFIEX_HW_STATUS_INIT_DONE,
+	MWIFIEX_HW_STATUS_RESET,
+	MWIFIEX_HW_STATUS_CLOSING,
+	MWIFIEX_HW_STATUS_NOT_READY
+};
+
+enum MWIFIEX_802_11_POWER_MODE {
+	MWIFIEX_802_11_POWER_MODE_CAM,
+	MWIFIEX_802_11_POWER_MODE_PSP
+};
+
+struct mwifiex_tx_param {
+	u32 next_pkt_len;
+};
+
+enum MWIFIEX_PS_STATE {
+	PS_STATE_AWAKE,
+	PS_STATE_PRE_SLEEP,
+	PS_STATE_SLEEP_CFM,
+	PS_STATE_SLEEP
+};
+
+struct mwifiex_add_ba_param {
+	u32 tx_win_size;
+	u32 rx_win_size;
+	u32 timeout;
+};
+
+struct mwifiex_tx_aggr {
+	u8 ampdu_user;
+	u8 ampdu_ap;
+	u8 amsdu;
+};
+
+struct mwifiex_ra_list_tbl {
+	struct list_head list;
+	struct sk_buff_head skb_head;
+	u8 ra[ETH_ALEN];
+	u32 total_pkts_size;
+	u32 is_11n_enabled;
+};
+
+struct mwifiex_tid_tbl {
+	struct list_head ra_list;
+	/* spin lock for tid table */
+	spinlock_t tid_tbl_lock;
+	struct mwifiex_ra_list_tbl *ra_list_curr;
+};
+
+#define WMM_HIGHEST_PRIORITY		7
+#define HIGH_PRIO_TID				7
+#define LOW_PRIO_TID				0
+
+struct mwifiex_wmm_desc {
+	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
+	u32 packets_out[MAX_NUM_TID];
+	/* spin lock to protect ra_list */
+	spinlock_t ra_list_spinlock;
+	struct mwifiex_wmm_ac_status ac_status[IEEE80211_MAX_QUEUES];
+	enum mwifiex_wmm_ac_e ac_down_graded_vals[IEEE80211_MAX_QUEUES];
+	u32 drv_pkt_delay_max;
+	u8 queue_priority[IEEE80211_MAX_QUEUES];
+	u32 user_pri_pkt_tx_ctrl[WMM_HIGHEST_PRIORITY + 1];	/* UP: 0 to 7 */
+
+};
+
+struct mwifiex_802_11_security {
+	u8 wpa_enabled;
+	u8 wpa2_enabled;
+	u8 wapi_enabled;
+	u8 wapi_key_on;
+	enum MWIFIEX_802_11_WEP_STATUS wep_status;
+	u32 authentication_mode;
+	u32 encryption_mode;
+};
+
+struct ieee_types_header {
+	u8 element_id;
+	u8 len;
+} __packed;
+
+struct ieee_obss_scan_param {
+	u16 obss_scan_passive_dwell;
+	u16 obss_scan_active_dwell;
+	u16 bss_chan_width_trigger_scan_int;
+	u16 obss_scan_passive_total;
+	u16 obss_scan_active_total;
+	u16 bss_width_chan_trans_delay;
+	u16 obss_scan_active_threshold;
+} __packed;
+
+struct ieee_types_obss_scan_param {
+	struct ieee_types_header ieee_hdr;
+	struct ieee_obss_scan_param obss_scan;
+} __packed;
+
+#define MWIFIEX_SUPPORTED_RATES                 14
+
+#define MWIFIEX_SUPPORTED_RATES_EXT             32
+
+#define IEEE_MAX_IE_SIZE			256
+
+struct ieee_types_vendor_specific {
+	struct ieee_types_vendor_header vend_hdr;
+	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_vendor_header)];
+} __packed;
+
+struct ieee_types_generic {
+	struct ieee_types_header ieee_hdr;
+	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
+} __packed;
+
+struct mwifiex_bssdescriptor {
+	u8 mac_address[ETH_ALEN];
+	struct mwifiex_802_11_ssid ssid;
+	u32 privacy;
+	s32 rssi;
+	u32 channel;
+	u32 freq;
+	u16 beacon_period;
+	u8 erp_flags;
+	u32 bss_mode;
+	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
+	u8 data_rates[MWIFIEX_SUPPORTED_RATES];
+	/* Network band.
+	 * BAND_B(0x01): 'b' band
+	 * BAND_G(0x02): 'g' band
+	 * BAND_A(0X04): 'a' band
+	 */
+	u16 bss_band;
+	long long network_tsf;
+	u8 time_stamp[8];
+	union ieee_types_phy_param_set phy_param_set;
+	union ieee_types_ss_param_set ss_param_set;
+	u16 cap_info_bitmap;
+	struct ieee_types_wmm_parameter wmm_ie;
+	u8  disable_11n;
+	struct ieee80211_ht_cap *bcn_ht_cap;
+	u16 ht_cap_offset;
+	struct ieee80211_ht_info *bcn_ht_info;
+	u16 ht_info_offset;
+	u8 *bcn_bss_co_2040;
+	u16 bss_co_2040_offset;
+	u8 *bcn_ext_cap;
+	u16 ext_cap_offset;
+	struct ieee_types_obss_scan_param *bcn_obss_scan;
+	u16 overlap_bss_offset;
+	struct ieee_types_vendor_specific *bcn_wpa_ie;
+	u16 wpa_offset;
+	struct ieee_types_generic *bcn_rsn_ie;
+	u16 rsn_offset;
+	struct ieee_types_generic *bcn_wapi_ie;
+	u16 wapi_offset;
+	u8 *beacon_buf;
+	u32 beacon_buf_size;
+	u32 beacon_buf_size_max;
+
+};
+
+struct mwifiex_current_bss_params {
+	struct mwifiex_bssdescriptor bss_descriptor;
+	u8 wmm_enabled;
+	u8 wmm_uapsd_enabled;
+	u8 band;
+	u32 num_of_rates;
+	u8 data_rates[MWIFIEX_SUPPORTED_RATES];
+};
+
+struct mwifiex_sleep_params {
+	u16 sp_error;
+	u16 sp_offset;
+	u16 sp_stable_time;
+	u8 sp_cal_control;
+	u8 sp_ext_sleep_clk;
+	u16 sp_reserved;
+};
+
+struct mwifiex_sleep_period {
+	u16 period;
+	u16 reserved;
+};
+
+struct mwifiex_wep_key {
+	u32 length;
+	u32 key_index;
+	u32 key_length;
+	u8 key_material[MWIFIEX_KEY_BUFFER_SIZE];
+};
+
+#define MAX_REGION_CHANNEL_NUM  2
+
+struct mwifiex_chan_freq_power {
+	u16 channel;
+	u32 freq;
+	u16 max_tx_power;
+	u8 unsupported;
+};
+
+enum state_11d_t {
+	DISABLE_11D = 0,
+	ENABLE_11D = 1,
+};
+
+#define MWIFIEX_MAX_TRIPLET_802_11D		83
+
+struct mwifiex_802_11d_domain_reg {
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
+	u8 no_of_triplet;
+	struct ieee80211_country_ie_triplet
+		triplet[MWIFIEX_MAX_TRIPLET_802_11D];
+};
+
+struct mwifiex_vendor_spec_cfg_ie {
+	u16 mask;
+	u16 flag;
+	u8 ie[MWIFIEX_MAX_VSIE_LEN];
+};
+
+struct wps {
+	u8 session_enable;
+};
+
+struct mwifiex_adapter;
+struct mwifiex_private;
+
+struct mwifiex_private {
+	struct mwifiex_adapter *adapter;
+	u8 bss_index;
+	u8 bss_type;
+	u8 bss_role;
+	u8 bss_priority;
+	u8 bss_num;
+	u8 frame_type;
+	u8 curr_addr[ETH_ALEN];
+	u8 media_connected;
+	u32 num_tx_timeout;
+	struct net_device *netdev;
+	struct net_device_stats stats;
+	u16 curr_pkt_filter;
+	u32 bss_mode;
+	u32 pkt_tx_ctrl;
+	u16 tx_power_level;
+	u8 max_tx_power_level;
+	u8 min_tx_power_level;
+	u8 tx_rate;
+	u8 tx_htinfo;
+	u8 rxpd_htinfo;
+	u8 rxpd_rate;
+	u16 rate_bitmap;
+	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
+	u32 data_rate;
+	u8 is_data_rate_auto;
+	u16 bcn_avg_factor;
+	u16 data_avg_factor;
+	s16 data_rssi_last;
+	s16 data_nf_last;
+	s16 data_rssi_avg;
+	s16 data_nf_avg;
+	s16 bcn_rssi_last;
+	s16 bcn_nf_last;
+	s16 bcn_rssi_avg;
+	s16 bcn_nf_avg;
+	struct mwifiex_bssdescriptor *attempted_bss_desc;
+	struct mwifiex_802_11_ssid prev_ssid;
+	u8 prev_bssid[ETH_ALEN];
+	struct mwifiex_current_bss_params curr_bss_params;
+	u16 beacon_period;
+	u16 listen_interval;
+	u16 atim_window;
+	u8 adhoc_channel;
+	u8 adhoc_is_link_sensed;
+	u8 adhoc_state;
+	struct mwifiex_802_11_security sec_info;
+	struct mwifiex_wep_key wep_key[NUM_WEP_KEYS];
+	u16 wep_key_curr_index;
+	u8 wpa_ie[256];
+	u8 wpa_ie_len;
+	u8 wpa_is_gtk_set;
+	struct host_cmd_ds_802_11_key_material aes_key;
+	u8 wapi_ie[256];
+	u8 wapi_ie_len;
+	u8 wmm_required;
+	u8 wmm_enabled;
+	u8 wmm_qosinfo;
+	struct mwifiex_wmm_desc wmm;
+	struct list_head tx_ba_stream_tbl_ptr;
+	/* spin lock for tx_ba_stream_tbl_ptr queue */
+	spinlock_t tx_ba_stream_tbl_lock;
+	struct mwifiex_tx_aggr aggr_prio_tbl[MAX_NUM_TID];
+	struct mwifiex_add_ba_param add_ba_param;
+	u16 rx_seq[MAX_NUM_TID];
+	struct list_head rx_reorder_tbl_ptr;
+	/* spin lock for rx_reorder_tbl_ptr queue */
+	spinlock_t rx_reorder_tbl_lock;
+	/* spin lock for Rx packets */
+	spinlock_t rx_pkt_lock;
+
+#define MWIFIEX_ASSOC_RSP_BUF_SIZE  500
+	u8 assoc_rsp_buf[MWIFIEX_ASSOC_RSP_BUF_SIZE];
+	u32 assoc_rsp_size;
+
+#define MWIFIEX_GENIE_BUF_SIZE      256
+	u8 gen_ie_buf[MWIFIEX_GENIE_BUF_SIZE];
+	u8 gen_ie_buf_len;
+
+	struct mwifiex_vendor_spec_cfg_ie vs_ie[MWIFIEX_MAX_VSIE_NUM];
+
+#define MWIFIEX_ASSOC_TLV_BUF_SIZE  256
+	u8 assoc_tlv_buf[MWIFIEX_ASSOC_TLV_BUF_SIZE];
+	u8 assoc_tlv_buf_len;
+
+	u8 *curr_bcn_buf;
+	u32 curr_bcn_size;
+	/* spin lock for beacon buffer */
+	spinlock_t curr_bcn_buf_lock;
+	u16 ioctl_wait_q_woken;
+	wait_queue_head_t ioctl_wait_q;
+	u16 cmd_wait_q_woken;
+	wait_queue_head_t cmd_wait_q;
+	struct wireless_dev *wdev;
+	struct mwifiex_chan_freq_power cfp;
+	char version_str[128];
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dfs_dev_dir;
+#endif
+	u8 nick_name[16];
+	struct iw_statistics w_stats;
+	u16 w_stats_wait_q_woken;
+	wait_queue_head_t w_stats_wait_q;
+	u16 current_key_index;
+	struct semaphore async_sem;
+	u8 scan_pending_on_block;
+	u8 report_scan_result;
+	struct cfg80211_scan_request *scan_request;
+	int scan_result_status;
+	bool assoc_request;
+	u16 assoc_result;
+	bool ibss_join_request;
+	u16 ibss_join_result;
+	bool disconnect;
+	u8 cfg_bssid[6];
+	struct workqueue_struct *workqueue;
+	struct work_struct cfg_workqueue;
+	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
+	struct wps wps;
+	u8 scan_block;
+};
+
+enum mwifiex_ba_status {
+	BA_STREAM_NOT_SETUP = 0,
+	BA_STREAM_SETUP_INPROGRESS,
+	BA_STREAM_SETUP_COMPLETE
+};
+
+struct mwifiex_tx_ba_stream_tbl {
+	struct list_head list;
+	int tid;
+	u8 ra[ETH_ALEN];
+	enum mwifiex_ba_status ba_status;
+};
+
+struct mwifiex_rx_reorder_tbl;
+
+struct reorder_tmr_cnxt {
+	struct timer_list timer;
+	struct mwifiex_rx_reorder_tbl *ptr;
+	struct mwifiex_private *priv;
+};
+
+struct mwifiex_rx_reorder_tbl {
+	struct list_head list;
+	int tid;
+	u8 ta[ETH_ALEN];
+	int start_win;
+	int win_size;
+	void **rx_reorder_ptr;
+	struct reorder_tmr_cnxt timer_context;
+};
+
+struct mwifiex_bss_prio_node {
+	struct list_head list;
+	struct mwifiex_private *priv;
+};
+
+struct mwifiex_bss_prio_tbl {
+	struct list_head bss_prio_head;
+	/* spin lock for bss priority  */
+	spinlock_t bss_prio_lock;
+	struct mwifiex_bss_prio_node *bss_prio_cur;
+};
+
+struct cmd_ctrl_node {
+	struct list_head list;
+	struct mwifiex_private *priv;
+	u32 cmd_oid;
+	u32 cmd_flag;
+	struct sk_buff *cmd_skb;
+	struct sk_buff *resp_skb;
+	void *data_buf;
+	void *wq_buf;
+	struct sk_buff *skb;
+};
+
+struct mwifiex_if_ops {
+	int (*init_if) (struct mwifiex_adapter *);
+	void (*cleanup_if) (struct mwifiex_adapter *);
+	int (*check_fw_status) (struct mwifiex_adapter *, u32, int *);
+	int (*prog_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
+	int (*register_dev) (struct mwifiex_adapter *);
+	void (*unregister_dev) (struct mwifiex_adapter *);
+	int (*enable_int) (struct mwifiex_adapter *);
+	int (*process_int_status) (struct mwifiex_adapter *);
+	int (*host_to_card) (struct mwifiex_adapter *, u8,
+			     u8 *payload, u32 pkt_len,
+			     struct mwifiex_tx_param *);
+	int (*wakeup) (struct mwifiex_adapter *);
+	int (*wakeup_complete) (struct mwifiex_adapter *);
+
+	void (*update_mp_end_port) (struct mwifiex_adapter *, u16);
+	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
+};
+
+struct mwifiex_adapter {
+	struct mwifiex_private *priv[MWIFIEX_MAX_BSS_NUM];
+	u8 priv_num;
+	struct mwifiex_drv_mode *drv_mode;
+	const struct firmware *firmware;
+	struct device *dev;
+	bool surprise_removed;
+	u32 fw_release_number;
+	u32 revision_id;
+	u16 init_wait_q_woken;
+	wait_queue_head_t init_wait_q;
+	void *card;
+	struct mwifiex_if_ops if_ops;
+	atomic_t rx_pending;
+	atomic_t tx_pending;
+	atomic_t ioctl_pending;
+	struct workqueue_struct *workqueue;
+	struct work_struct main_work;
+	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
+	/* spin lock for init/shutdown */
+	spinlock_t mwifiex_lock;
+	/* spin lock for main process */
+	spinlock_t main_proc_lock;
+	u32 mwifiex_processing;
+	u16 max_tx_buf_size;
+	u16 tx_buf_size;
+	u16 curr_tx_buf_size;
+	u32 ioport;
+	enum MWIFIEX_HARDWARE_STATUS hw_status;
+	u16 radio_on;
+	u16 number_of_antenna;
+	u32 fw_cap_info;
+	/* spin lock for interrupt handling */
+	spinlock_t int_lock;
+	u8 int_status;
+	u32 event_cause;
+	struct sk_buff *event_skb;
+	u8 upld_buf[MWIFIEX_UPLD_SIZE];
+	u8 data_sent;
+	u8 cmd_sent;
+	u8 cmd_resp_received;
+	u8 event_received;
+	u8 data_received;
+	u16 seq_num;
+	struct cmd_ctrl_node *cmd_pool;
+	struct cmd_ctrl_node *curr_cmd;
+	/* spin lock for command */
+	spinlock_t mwifiex_cmd_lock;
+	u32 num_cmd_timeout;
+	u16 last_init_cmd;
+	struct timer_list cmd_timer;
+	struct list_head cmd_free_q;
+	/* spin lock for cmd_free_q */
+	spinlock_t cmd_free_q_lock;
+	struct list_head cmd_pending_q;
+	/* spin lock for cmd_pending_q */
+	spinlock_t cmd_pending_q_lock;
+	struct list_head scan_pending_q;
+	/* spin lock for scan_pending_q */
+	spinlock_t scan_pending_q_lock;
+	u32 scan_processing;
+	u16 region_code;
+	struct mwifiex_802_11d_domain_reg domain_reg;
+	struct mwifiex_bssdescriptor *scan_table;
+	u32 num_in_scan_table;
+	u16 scan_probes;
+	u32 scan_mode;
+	u16 specific_scan_time;
+	u16 active_scan_time;
+	u16 passive_scan_time;
+	u8 bcn_buf[MAX_SCAN_BEACON_BUFFER];
+	u8 *bcn_buf_end;
+	u8 fw_bands;
+	u8 adhoc_start_band;
+	u8 config_bands;
+	struct mwifiex_chan_scan_param_set *scan_channels;
+	u8 tx_lock_flag;
+	struct mwifiex_sleep_params sleep_params;
+	struct mwifiex_sleep_period sleep_period;
+	u16 ps_mode;
+	u32 ps_state;
+	u8 need_to_wakeup;
+	u16 multiple_dtim;
+	u16 local_listen_interval;
+	u16 null_pkt_interval;
+	struct sk_buff *sleep_cfm;
+	u16 bcn_miss_time_out;
+	u16 adhoc_awake_period;
+	u8 is_deep_sleep;
+	u8 delay_null_pkt;
+	u16 delay_to_ps;
+	u16 enhanced_ps_mode;
+	u8 pm_wakeup_card_req;
+	u16 gen_null_pkt;
+	u16 pps_uapsd_mode;
+	u32 pm_wakeup_fw_try;
+	u8 is_hs_configured;
+	struct mwifiex_hs_config_param hs_cfg;
+	u8 hs_activated;
+	u16 hs_activate_wait_q_woken;
+	wait_queue_head_t hs_activate_wait_q;
+	bool is_suspended;
+	u8 event_body[MAX_EVENT_SIZE];
+	u32 hw_dot_11n_dev_cap;
+	u8 hw_dev_mcs_support;
+	u32 usr_dot_11n_dev_cap;
+	u8 usr_dev_mcs_support;
+	u8 adhoc_11n_enabled;
+	u8 chan_offset;
+	struct mwifiex_dbg dbg;
+	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
+	u32 arp_filter_size;
+};
+
+int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
+void mwifiex_free_lock_list(struct mwifiex_adapter *adapter);
+
+int mwifiex_init_fw(struct mwifiex_adapter *adapter);
+
+int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
+
+int mwifiex_shutdown_drv(struct mwifiex_adapter *adapter);
+
+int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter);
+
+int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
+
+int mwifiex_recv_complete(struct mwifiex_adapter *,
+			  struct sk_buff *skb,
+			  int status);
+
+int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
+
+int mwifiex_process_event(struct mwifiex_adapter *adapter);
+
+int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
+			   struct mwifiex_wait_queue *ioctl_wq,
+			   int status);
+
+int mwifiex_prepare_cmd(struct mwifiex_private *priv,
+			uint16_t cmd_no,
+			u16 cmd_action,
+			u32 cmd_oid,
+			void *wait_queue, void *data_buf);
+
+void mwifiex_cmd_timeout_func(unsigned long function_context);
+
+int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
+				     struct mwifiex_wait_queue *wait_queue,
+				     u32 func_init_shutdown);
+int mwifiex_get_debug_info(struct mwifiex_private *,
+			   struct mwifiex_debug_info *);
+
+int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
+int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
+void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
+void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
+				  struct mwifiex_wait_queue *ioctl_wq);
+
+void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
+				  struct cmd_ctrl_node *cmd_node);
+
+void mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
+				     struct cmd_ctrl_node *cmd_node,
+				     u32 addtail);
+
+int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter);
+int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter);
+int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
+			     struct sk_buff *skb);
+int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
+		       struct mwifiex_tx_param *tx_param);
+int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags);
+int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
+				struct sk_buff *skb, int status);
+int mwifiex_recv_packet_complete(struct mwifiex_adapter *,
+				 struct sk_buff *skb, int status);
+void mwifiex_clean_txrx(struct mwifiex_private *priv);
+u8 mwifiex_check_last_packet_indication(struct mwifiex_private *priv);
+void mwifiex_check_ps_cond(struct mwifiex_adapter *adapter);
+void mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *, u8 *,
+					u32);
+int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *cmd,
+			       u16 cmd_action, uint16_t ps_bitmap,
+			       void *data_buf);
+int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf);
+void mwifiex_process_hs_config(struct mwifiex_adapter *adapter);
+void mwifiex_hs_activated_event(struct mwifiex_private *priv,
+					u8 activated);
+int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp);
+int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+			      struct sk_buff *skb);
+int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf);
+int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
+				void *cmd_buf, void *ioctl);
+int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
+				  struct sk_buff *skb);
+int mwifiex_process_sta_event(struct mwifiex_private *);
+void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
+int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
+int mwifiex_scan_networks(struct mwifiex_private *priv, void *wait_queue,
+			  u16 action,
+			  const struct mwifiex_user_scan_cfg
+			  *user_scan_in, struct mwifiex_scan_resp *);
+int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd,
+			    void *data_buf);
+void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
+			    struct cmd_ctrl_node *cmd_node);
+int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp,
+			    void *wait_queue);
+s32 mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
+				struct mwifiex_802_11_ssid *ssid, u8 *bssid,
+				u32 mode);
+s32 mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
+				 u32 mode);
+int mwifiex_find_best_network(struct mwifiex_private *priv,
+			      struct mwifiex_ssid_bssid *req_ssid_bssid);
+s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
+		       struct mwifiex_802_11_ssid *ssid2);
+int mwifiex_associate(struct mwifiex_private *priv, void *wait_queue,
+		      struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command
+				 *cmd, void *data_buf);
+int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *resp,
+				 void *wait_queue);
+void mwifiex_reset_connect_state(struct mwifiex_private *priv);
+void mwifiex_2040_coex_event(struct mwifiex_private *priv);
+u8 mwifiex_band_to_radio_type(u8 band);
+int mwifiex_deauthenticate(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait_queue,
+			   u8 *mac);
+int mwifiex_adhoc_start(struct mwifiex_private *priv, void *wait_queue,
+			struct mwifiex_802_11_ssid *adhoc_ssid);
+int mwifiex_adhoc_join(struct mwifiex_private *priv, void *wait_queue,
+		       struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    void *data_buf);
+int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   void *data_buf);
+int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp,
+			      void *wait_queue);
+int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     void *data_buf);
+struct mwifiex_chan_freq_power *
+			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
+						struct mwifiex_private *priv,
+						u8 band, u16 channel);
+struct mwifiex_chan_freq_power *mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
+						struct mwifiex_private *priv,
+						u8 band, u32 freq);
+u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
+				 u8 ht_info);
+u32 mwifiex_find_freq_from_band_chan(u8, u8);
+int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
+				u8 **buffer);
+u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
+				 u8 ht_info);
+u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv,
+				    u8 *rates);
+u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates);
+u8 mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate);
+u8 mwifiex_is_rate_auto(struct mwifiex_private *priv);
+int mwifiex_get_rate_index(struct mwifiex_adapter *adapter,
+			   u16 *rateBitmap, int size);
+extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
+void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
+void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
+int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd);
+int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp);
+int is_command_pending(struct mwifiex_adapter *adapter);
+
+/*
+ * This function checks if the queuing is RA based or not.
+ */
+static inline u8
+mwifiex_queuing_ra_based(struct mwifiex_private *priv)
+{
+	/*
+	 * Currently we assume if we are in Infra, then DA=RA. This might not be
+	 * true in the future
+	 */
+	if ((priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) &&
+	    (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA))
+		return false;
+
+	return true;
+}
+
+/*
+ * This function copies rates.
+ */
+static inline u32
+mwifiex_copy_rates(u8 *dest, u32 pos, u8 *src, int len)
+{
+	int i;
+
+	for (i = 0; i < len && src[i]; i++, pos++) {
+		if (pos >= MWIFIEX_SUPPORTED_RATES)
+			break;
+		dest[pos] = src[i];
+	}
+
+	return pos;
+}
+
+/*
+ * This function returns the correct private structure pointer based
+ * upon the BSS type and BSS number.
+ */
+static inline struct mwifiex_private *
+mwifiex_get_priv_by_id(struct mwifiex_adapter *adapter,
+		       u32 bss_num, u32 bss_type)
+{
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			if ((adapter->priv[i]->bss_num == bss_num)
+			    && (adapter->priv[i]->bss_type == bss_type))
+				break;
+		}
+	}
+	return ((i < adapter->priv_num) ? adapter->priv[i] : NULL);
+}
+
+/*
+ * This function returns the first available private structure pointer
+ * based upon the BSS role.
+ */
+static inline struct mwifiex_private *
+mwifiex_get_priv(struct mwifiex_adapter *adapter,
+		 enum mwifiex_bss_role bss_role)
+{
+	int i;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i]) {
+			if (bss_role == MWIFIEX_BSS_ROLE_ANY ||
+			    GET_BSS_ROLE(adapter->priv[i]) == bss_role)
+				break;
+		}
+	}
+
+	return ((i < adapter->priv_num) ? adapter->priv[i] : NULL);
+}
+
+/*
+ * This function returns the driver private structure of a network device.
+ */
+static inline struct mwifiex_private *
+mwifiex_netdev_get_priv(struct net_device *dev)
+{
+	return (struct mwifiex_private *) (*(unsigned long *) netdev_priv(dev));
+}
+
+struct mwifiex_wait_queue *mwifiex_alloc_fill_wait_queue(
+				struct mwifiex_private *,
+				u8 wait_option);
+struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
+						*adapter, u8 bss_index);
+int mwifiex_shutdown_fw(struct mwifiex_private *, u8);
+
+int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *);
+int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
+
+void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
+			 int maxlen);
+int mwifiex_request_set_mac_address(struct mwifiex_private *priv);
+void mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
+					struct net_device *dev);
+int mwifiex_request_ioctl(struct mwifiex_private *priv,
+			  struct mwifiex_wait_queue *req,
+			  int, u8 wait_option);
+int mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
+int mwifiex_bss_start(struct mwifiex_private *priv,
+		      u8 wait_option,
+		      struct mwifiex_ssid_bssid *ssid_bssid);
+int mwifiex_set_hs_params(struct mwifiex_private *priv,
+			      u16 action, u8 wait_option,
+			      struct mwifiex_ds_hs_cfg *hscfg);
+int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option);
+int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
+void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
+				struct mwifiex_wait_queue *req);
+u32 mwifiex_get_mode(struct mwifiex_private *priv, u8 wait_option);
+int mwifiex_get_signal_info(struct mwifiex_private *priv,
+			    u8 wait_option,
+			    struct mwifiex_ds_get_signal *signal);
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
+			      struct mwifiex_rate_cfg *rate);
+int mwifiex_get_channel_list(struct mwifiex_private *priv,
+			     u8 wait_option,
+			     struct mwifiex_chan_list *chanlist);
+int mwifiex_get_scan_table(struct mwifiex_private *priv,
+			   u8 wait_option,
+			   struct mwifiex_scan_resp *scanresp);
+int mwifiex_get_auth_mode(struct mwifiex_private *priv,
+			  u8 wait_option, u32 *auth_mode);
+int mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
+			     u8 wait_option,
+			     u32 *encrypt_mode);
+int mwifiex_enable_wep_key(struct mwifiex_private *priv, u8 wait_option);
+int mwifiex_find_best_bss(struct mwifiex_private *priv, u8 wait_option,
+			  struct mwifiex_ssid_bssid *ssid_bssid);
+int mwifiex_request_scan(struct mwifiex_private *priv,
+			 u8 wait_option,
+			 struct mwifiex_802_11_ssid *req_ssid);
+int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
+				struct mwifiex_user_scan_cfg *scan_req);
+int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
+int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
+
+int mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option);
+
+int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
+
+int mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
+		     int auth_mode, int wpa_enabled);
+
+int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
+		       int key_len, u8 key_index, int disable);
+
+int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
+
+int mwifiex_get_ver_ext(struct mwifiex_private *priv);
+
+int mwifiex_get_stats_info(struct mwifiex_private *priv,
+			   struct mwifiex_ds_get_stats *log);
+
+int mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
+		      u32 reg_offset, u32 reg_value);
+
+int mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
+		     u32 reg_offset, u32 *value);
+
+int mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
+			u8 *value);
+
+int mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data);
+
+int mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data);
+
+int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
+
+int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
+
+int mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on);
+
+int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
+				   char *version, int max_len);
+
+int mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm);
+
+int mwifiex_main_process(struct mwifiex_adapter *);
+
+int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   u16 action, int *mode);
+int mwifiex_bss_ioctl_channel(struct mwifiex_private *,
+			      u16 action,
+			      struct mwifiex_chan_freq_power *cfp);
+int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
+			       struct mwifiex_wait_queue *,
+			       struct mwifiex_ssid_bssid *);
+int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
+				 u16 action,
+				 struct mwifiex_ds_band_cfg *);
+int mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   u32 cmd_oid, u16 action, u32 *value);
+int mwifiex_get_bss_info(struct mwifiex_private *,
+			 struct mwifiex_bss_info *);
+
+#ifdef CONFIG_DEBUG_FS
+void mwifiex_debugfs_init(void);
+void mwifiex_debugfs_remove(void);
+
+void mwifiex_dev_debugfs_init(struct mwifiex_private *priv);
+void mwifiex_dev_debugfs_remove(struct mwifiex_private *priv);
+#endif
+#endif /* !_MWIFIEX_MAIN_H_ */
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
new file mode 100644
index 0000000..1152beb
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -0,0 +1,3098 @@
+/*
+ * Marvell Wireless LAN device driver: scan ioctl and command handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "11n.h"
+#include "cfg80211.h"
+
+/* The maximum number of channels the firmware can scan per command */
+#define MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN   14
+
+#define MWIFIEX_CHANNELS_PER_SCAN_CMD            4
+
+/* Memory needed to store a max sized Channel List TLV for a firmware scan */
+#define CHAN_TLV_MAX_SIZE  (sizeof(struct mwifiex_ie_types_header)         \
+				+ (MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN     \
+				*sizeof(struct mwifiex_chan_scan_param_set)))
+
+/* Memory needed to store supported rate */
+#define RATE_TLV_MAX_SIZE   (sizeof(struct mwifiex_ie_types_rates_param_set) \
+				+ HOSTCMD_SUPPORTED_RATES)
+
+/* Memory needed to store a max number/size WildCard SSID TLV for a firmware
+	scan */
+#define WILDCARD_SSID_TLV_MAX_SIZE  \
+	(MWIFIEX_MAX_SSID_LIST_LENGTH *					\
+		(sizeof(struct mwifiex_ie_types_wildcard_ssid_params)	\
+			+ IEEE80211_MAX_SSID_LEN))
+
+/* Maximum memory needed for a mwifiex_scan_cmd_config with all TLVs at max */
+#define MAX_SCAN_CFG_ALLOC (sizeof(struct mwifiex_scan_cmd_config)        \
+				+ sizeof(struct mwifiex_ie_types_num_probes)   \
+				+ sizeof(struct mwifiex_ie_types_htcap)       \
+				+ CHAN_TLV_MAX_SIZE                 \
+				+ RATE_TLV_MAX_SIZE                 \
+				+ WILDCARD_SSID_TLV_MAX_SIZE)
+
+
+union mwifiex_scan_cmd_config_tlv {
+	/* Scan configuration (variable length) */
+	struct mwifiex_scan_cmd_config config;
+	/* Max allocated block */
+	u8 config_alloc_buf[MAX_SCAN_CFG_ALLOC];
+};
+
+enum cipher_suite {
+	CIPHER_SUITE_TKIP,
+	CIPHER_SUITE_CCMP,
+	CIPHER_SUITE_MAX
+};
+static u8 mwifiex_wpa_oui[CIPHER_SUITE_MAX][4] = {
+	{ 0x00, 0x50, 0xf2, 0x02 },	/* TKIP */
+	{ 0x00, 0x50, 0xf2, 0x04 },	/* AES  */
+};
+static u8 mwifiex_rsn_oui[CIPHER_SUITE_MAX][4] = {
+	{ 0x00, 0x0f, 0xac, 0x02 },	/* TKIP */
+	{ 0x00, 0x0f, 0xac, 0x04 },	/* AES  */
+};
+
+/*
+ * This function parses a given IE for a given OUI.
+ *
+ * This is used to parse a WPA/RSN IE to find if it has
+ * a given oui in PTK.
+ */
+static u8
+mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
+{
+	u8 count;
+
+	count = iebody->ptk_cnt[0];
+
+	/* There could be multiple OUIs for PTK hence
+	   1) Take the length.
+	   2) Check all the OUIs for AES.
+	   3) If one of them is AES then pass success. */
+	while (count) {
+		if (!memcmp(iebody->ptk_body, oui, sizeof(iebody->ptk_body)))
+			return MWIFIEX_OUI_PRESENT;
+
+		--count;
+		if (count)
+			iebody = (struct ie_body *) ((u8 *) iebody +
+						sizeof(iebody->ptk_body));
+	}
+
+	pr_debug("info: %s: OUI is not found in PTK\n", __func__);
+	return MWIFIEX_OUI_NOT_PRESENT;
+}
+
+/*
+ * This function checks if a given OUI is present in a RSN IE.
+ *
+ * The function first checks if a RSN IE is present or not in the
+ * BSS descriptor. It tries to locate the OUI only if such an IE is
+ * present.
+ */
+static u8
+mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
+{
+	u8 *oui = NULL;
+	struct ie_body *iebody = NULL;
+	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
+
+	if (((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).
+					ieee_hdr.element_id == WLAN_EID_RSN))) {
+		iebody = (struct ie_body *)
+			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
+			 RSN_GTK_OUI_OFFSET);
+		oui = &mwifiex_rsn_oui[cipher][0];
+		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+/*
+ * This function checks if a given OUI is present in a WPA IE.
+ *
+ * The function first checks if a WPA IE is present or not in the
+ * BSS descriptor. It tries to locate the OUI only if such an IE is
+ * present.
+ */
+static u8
+mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
+{
+	u8 *oui = NULL;
+	struct ie_body *iebody = NULL;
+	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
+
+	if (((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).
+				      vend_hdr.element_id == WLAN_EID_WPA))) {
+		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
+		oui = &mwifiex_wpa_oui[cipher][0];
+		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+/*
+ * This function compares two SSIDs and checks if they match.
+ */
+s32
+mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
+		 struct mwifiex_802_11_ssid *ssid2)
+{
+	if (!ssid1 || !ssid2 || (ssid1->ssid_len != ssid2->ssid_len))
+		return -1;
+	return memcmp(ssid1->ssid, ssid2->ssid, ssid1->ssid_len);
+}
+
+/*
+ * Sends IOCTL request to get the best BSS.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_find_best_bss(struct mwifiex_private *priv,
+			  u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ssid_bssid tmp_ssid_bssid;
+	int ret = 0;
+	u8 *mac = NULL;
+
+	if (!ssid_bssid)
+		return -1;
+
+	/* Allocate wait request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	memcpy(&tmp_ssid_bssid, ssid_bssid,
+	       sizeof(struct mwifiex_ssid_bssid));
+	ret = mwifiex_bss_ioctl_find_bss(priv, wait, &tmp_ssid_bssid);
+
+	if (!ret) {
+		memcpy(ssid_bssid, &tmp_ssid_bssid,
+		       sizeof(struct mwifiex_ssid_bssid));
+		mac = (u8 *) &ssid_bssid->bssid;
+		dev_dbg(priv->adapter->dev, "cmd: found network: ssid=%s,"
+				" %pM\n", ssid_bssid->ssid.ssid, mac);
+	}
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to start a scan with user configurations.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ *
+ * Upon completion, it also generates a wireless event to notify
+ * applications.
+ */
+int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
+				struct mwifiex_user_scan_cfg *scan_req)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	/* Allocate an IOCTL request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
+				       scan_req, NULL);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	if (wait && (status != -EINPROGRESS))
+		kfree(wait);
+	return status;
+}
+
+/*
+ * This function checks if wapi is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wapi(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wapi_enabled &&
+	    (bss_desc->bcn_wapi_ie &&
+	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
+			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if driver is configured with no security mode and
+ * scanned network is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) ||
+		((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
+	    WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) ||
+		((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
+	    WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode ==
+	    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if static WEP is enabled in driver and scanned network
+ * is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if wpa is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
+				      struct mwifiex_bssdescriptor *bss_desc,
+				      int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+						element_id == WLAN_EID_WPA))
+	   /*
+	    * Privacy bit may NOT be set in some APs like
+	    * LinkSys WRT54G && bss_desc->privacy
+	    */
+	 ) {
+		dev_dbg(priv->adapter->dev, "info: %s: WPA: index=%d"
+			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
+			"EncMode=%#x privacy=%#x\n", __func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			(priv->sec_info.wep_status ==
+			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wpa_enabled) ? "e" : "d",
+			(priv->sec_info.wpa2_enabled) ? "e" : "d",
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if wpa2 is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc,
+				       int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	   && !priv->sec_info.wpa_enabled && priv->sec_info.wpa2_enabled
+	   && ((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+						element_id == WLAN_EID_RSN))
+	   /*
+	    * Privacy bit may NOT be set in some APs like
+	    * LinkSys WRT54G && bss_desc->privacy
+	    */
+	 ) {
+		dev_dbg(priv->adapter->dev, "info: %s: WPA2: index=%d"
+			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
+			"EncMode=%#x privacy=%#x\n", __func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			(priv->sec_info.wep_status ==
+			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wpa_enabled) ? "e" : "d",
+			(priv->sec_info.wpa2_enabled) ? "e" : "d",
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if adhoc AES is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+		   element_id != WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+		   element_id != WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode ==
+	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if dynamic WEP is enabled in driver and scanned network
+ * is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc,
+				       int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+		   element_id != WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+		   element_id != WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode !=
+	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
+			"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
+			"EncMode=%#x privacy=%#x\n",
+			__func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if a scanned network is compatible with the driver
+ * settings.
+ *
+ *   WEP     WPA    WPA2   ad-hoc encrypt                  Network
+ * enabled enabled enabled  AES    mode   Privacy WPA WPA2 Compatible
+ *    0       0       0      0     NONE      0     0   0   yes No security
+ *    0       1       0      0      x        1x    1   x   yes WPA (disable
+ *                                                         HT if no AES)
+ *    0       0       1      0      x        1x    x   1   yes WPA2 (disable
+ *                                                         HT if no AES)
+ *    0       0       0      1     NONE      1     0   0   yes Ad-hoc AES
+ *    1       0       0      0     NONE      1     0   0   yes Static WEP
+ *                                                         (disable HT)
+ *    0       0       0      0    !=NONE     1     0   0   yes Dynamic WEP
+ *
+ * Compatibility is not matched while roaming, except for mode.
+ */
+static s32
+mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bssdescriptor *bss_desc;
+
+	bss_desc = &adapter->scan_table[index];
+	bss_desc->disable_11n = false;
+
+	/* Don't check for compatibility if roaming */
+	if (priv->media_connected && (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
+	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA))
+		return index;
+
+	if (priv->wps.session_enable) {
+		dev_dbg(adapter->dev,
+			"info: return success directly in WPS period\n");
+		return index;
+	}
+
+	if (mwifiex_is_network_compatible_for_wapi(priv, bss_desc)) {
+		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
+		return index;
+	}
+
+	if (bss_desc->bss_mode == mode) {
+		if (mwifiex_is_network_compatible_for_no_sec(priv, bss_desc)) {
+			/* No security */
+			return index;
+		} else if (mwifiex_is_network_compatible_for_static_wep(priv,
+								bss_desc)) {
+			/* Static WEP enabled */
+			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
+			bss_desc->disable_11n = true;
+			return index;
+		} else if (mwifiex_is_network_compatible_for_wpa(priv, bss_desc,
+								 index)) {
+			/* WPA enabled */
+			if (((priv->adapter->config_bands & BAND_GN
+			      || priv->adapter->config_bands & BAND_AN)
+			      && bss_desc->bcn_ht_cap)
+			      && !mwifiex_is_wpa_oui_present(bss_desc,
+					CIPHER_SUITE_CCMP)) {
+
+				if (mwifiex_is_wpa_oui_present(bss_desc,
+					    CIPHER_SUITE_TKIP)) {
+					dev_dbg(adapter->dev,
+						"info: Disable 11n if AES "
+						"is not supported by AP\n");
+					bss_desc->disable_11n = true;
+				} else {
+					return -1;
+				}
+			}
+			return index;
+		} else if (mwifiex_is_network_compatible_for_wpa2(priv,
+							bss_desc, index)) {
+			/* WPA2 enabled */
+			if (((priv->adapter->config_bands & BAND_GN
+			      || priv->adapter->config_bands & BAND_AN)
+			      && bss_desc->bcn_ht_cap)
+			      && !mwifiex_is_rsn_oui_present(bss_desc,
+					CIPHER_SUITE_CCMP)) {
+
+				if (mwifiex_is_rsn_oui_present(bss_desc,
+					    CIPHER_SUITE_TKIP)) {
+					dev_dbg(adapter->dev,
+						"info: Disable 11n if AES "
+						"is not supported by AP\n");
+					bss_desc->disable_11n = true;
+				} else {
+					return -1;
+				}
+			}
+			return index;
+		} else if (mwifiex_is_network_compatible_for_adhoc_aes(priv,
+								bss_desc)) {
+			/* Ad-hoc AES enabled */
+			return index;
+		} else if (mwifiex_is_network_compatible_for_dynamic_wep(priv,
+							bss_desc, index)) {
+			/* Dynamic WEP enabled */
+			return index;
+		}
+
+		/* Security doesn't match */
+		dev_dbg(adapter->dev, "info: %s: failed: index=%d "
+		       "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s EncMode"
+		       "=%#x privacy=%#x\n",
+		       __func__, index,
+		       (bss_desc->bcn_wpa_ie) ?
+		       (*(bss_desc->bcn_wpa_ie)).vend_hdr.
+		       element_id : 0,
+		       (bss_desc->bcn_rsn_ie) ?
+		       (*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+		       element_id : 0,
+		       (priv->sec_info.wep_status ==
+				MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+		       (priv->sec_info.wpa_enabled) ? "e" : "d",
+		       (priv->sec_info.wpa2_enabled) ? "e" : "d",
+		       priv->sec_info.encryption_mode, bss_desc->privacy);
+		return -1;
+	}
+
+	/* Mode doesn't match */
+	return -1;
+}
+
+/*
+ * This function finds the best SSID in the scan list.
+ *
+ * It searches the scan table for the best SSID that also matches the current
+ * adapter network preference (mode, security etc.).
+ */
+static s32
+mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 mode = priv->bss_mode;
+	s32 best_net = -1;
+	s32 best_rssi = 0;
+	u32 i;
+
+	dev_dbg(adapter->dev, "info: num of BSSIDs = %d\n",
+				adapter->num_in_scan_table);
+
+	for (i = 0; i < adapter->num_in_scan_table; i++) {
+		switch (mode) {
+		case MWIFIEX_BSS_MODE_INFRA:
+		case MWIFIEX_BSS_MODE_IBSS:
+			if (mwifiex_is_network_compatible(priv, i, mode) >= 0) {
+				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
+				    best_rssi) {
+					best_rssi = SCAN_RSSI(adapter->
+							  scan_table[i].rssi);
+					best_net = i;
+				}
+			}
+			break;
+		case MWIFIEX_BSS_MODE_AUTO:
+		default:
+			if (SCAN_RSSI(adapter->scan_table[i].rssi) >
+			    best_rssi) {
+				best_rssi = SCAN_RSSI(adapter->scan_table[i].
+						      rssi);
+				best_net = i;
+			}
+			break;
+		}
+	}
+
+	return best_net;
+}
+
+/*
+ * This function creates a channel list for the driver to scan, based
+ * on region/band information.
+ *
+ * This routine is used for any scan that is not provided with a
+ * specific channel list to scan.
+ */
+static void
+mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
+				const struct mwifiex_user_scan_cfg
+				*user_scan_in,
+				struct mwifiex_chan_scan_param_set
+				*scan_chan_list,
+				u8 filtered_scan)
+{
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int chan_idx = 0, i;
+	u8 scan_type;
+
+	for (band = 0; (band < IEEE80211_NUM_BANDS) ; band++) {
+
+		if (!priv->wdev->wiphy->bands[band])
+			continue;
+
+		sband = priv->wdev->wiphy->bands[band];
+
+		for (i = 0; (i < sband->n_channels) ; i++, chan_idx++) {
+			ch = &sband->channels[i];
+			if (ch->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+			scan_chan_list[chan_idx].radio_type = band;
+			scan_type = ch->flags & IEEE80211_CHAN_PASSIVE_SCAN;
+			if (user_scan_in &&
+				user_scan_in->chan_list[0].scan_time)
+				scan_chan_list[chan_idx].max_scan_time =
+					cpu_to_le16((u16) user_scan_in->
+					chan_list[0].scan_time);
+			else if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+				scan_chan_list[chan_idx].max_scan_time =
+					cpu_to_le16(adapter->passive_scan_time);
+			else
+				scan_chan_list[chan_idx].max_scan_time =
+					cpu_to_le16(adapter->active_scan_time);
+			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					|= MWIFIEX_PASSIVE_SCAN;
+			else
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					&= ~MWIFIEX_PASSIVE_SCAN;
+			scan_chan_list[chan_idx].chan_number =
+							(u32) ch->hw_value;
+			if (filtered_scan) {
+				scan_chan_list[chan_idx].max_scan_time =
+				cpu_to_le16(adapter->specific_scan_time);
+				scan_chan_list[chan_idx].chan_scan_mode_bitmap
+					|= MWIFIEX_DISABLE_CHAN_FILT;
+			}
+		}
+
+	}
+}
+
+/*
+ * This function constructs and sends multiple scan config commands to
+ * the firmware.
+ *
+ * Previous routines in the code flow have created a scan command configuration
+ * with any requested TLVs.  This function splits the channel TLV into maximum
+ * channels supported per scan lists and sends the portion of the channel TLV,
+ * along with the other TLVs, to the firmware.
+ */
+static int
+mwifiex_scan_channel_list(struct mwifiex_private *priv, void *wait_buf,
+			  u32 max_chan_per_scan, u8 filtered_scan,
+			  struct mwifiex_scan_cmd_config *scan_cfg_out,
+			  struct mwifiex_ie_types_chan_list_param_set
+			  *chan_tlv_out,
+			  struct mwifiex_chan_scan_param_set *scan_chan_list)
+{
+	int ret = 0;
+	struct mwifiex_chan_scan_param_set *tmp_chan_list;
+	struct mwifiex_chan_scan_param_set *start_chan;
+
+	u32 tlv_idx;
+	u32 total_scan_time;
+	u32 done_early;
+
+	if (!scan_cfg_out || !chan_tlv_out || !scan_chan_list) {
+		dev_dbg(priv->adapter->dev,
+			"info: Scan: Null detect: %p, %p, %p\n",
+		       scan_cfg_out, chan_tlv_out, scan_chan_list);
+		return -1;
+	}
+
+	chan_tlv_out->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
+
+	/* Set the temp channel struct pointer to the start of the desired
+	   list */
+	tmp_chan_list = scan_chan_list;
+
+	/* Loop through the desired channel list, sending a new firmware scan
+	   commands for each max_chan_per_scan channels (or for 1,6,11
+	   individually if configured accordingly) */
+	while (tmp_chan_list->chan_number) {
+
+		tlv_idx = 0;
+		total_scan_time = 0;
+		chan_tlv_out->header.len = 0;
+		start_chan = tmp_chan_list;
+		done_early = false;
+
+		/*
+		 * Construct the Channel TLV for the scan command.  Continue to
+		 * insert channel TLVs until:
+		 *   - the tlv_idx hits the maximum configured per scan command
+		 *   - the next channel to insert is 0 (end of desired channel
+		 *     list)
+		 *   - done_early is set (controlling individual scanning of
+		 *     1,6,11)
+		 */
+		while (tlv_idx < max_chan_per_scan
+		       && tmp_chan_list->chan_number && !done_early) {
+
+			dev_dbg(priv->adapter->dev,
+				"info: Scan: Chan(%3d), Radio(%d),"
+				" Mode(%d, %d), Dur(%d)\n",
+			       tmp_chan_list->chan_number,
+			       tmp_chan_list->radio_type,
+			       tmp_chan_list->chan_scan_mode_bitmap
+			       & MWIFIEX_PASSIVE_SCAN,
+			       (tmp_chan_list->chan_scan_mode_bitmap
+			       & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
+			       le16_to_cpu(tmp_chan_list->max_scan_time));
+
+			/* Copy the current channel TLV to the command being
+			   prepared */
+			memcpy(chan_tlv_out->chan_scan_param + tlv_idx,
+			       tmp_chan_list,
+			       sizeof(chan_tlv_out->chan_scan_param));
+
+			/* Increment the TLV header length by the size
+			   appended */
+			chan_tlv_out->header.len =
+			cpu_to_le16(le16_to_cpu(chan_tlv_out->header.len) +
+			(sizeof(chan_tlv_out->chan_scan_param)));
+
+			/*
+			 * The tlv buffer length is set to the number of bytes
+			 * of the between the channel tlv pointer and the start
+			 * of the tlv buffer.  This compensates for any TLVs
+			 * that were appended before the channel list.
+			 */
+			scan_cfg_out->tlv_buf_len = (u32) ((u8 *) chan_tlv_out -
+							scan_cfg_out->tlv_buf);
+
+			/* Add the size of the channel tlv header and the data
+			   length */
+			scan_cfg_out->tlv_buf_len +=
+				(sizeof(chan_tlv_out->header)
+				 + le16_to_cpu(chan_tlv_out->header.len));
+
+			/* Increment the index to the channel tlv we are
+			   constructing */
+			tlv_idx++;
+
+			/* Count the total scan time per command */
+			total_scan_time +=
+				le16_to_cpu(tmp_chan_list->max_scan_time);
+
+			done_early = false;
+
+			/* Stop the loop if the *current* channel is in the
+			   1,6,11 set and we are not filtering on a BSSID
+			   or SSID. */
+			if (!filtered_scan && (tmp_chan_list->chan_number == 1
+				|| tmp_chan_list->chan_number == 6
+				|| tmp_chan_list->chan_number == 11))
+				done_early = true;
+
+			/* Increment the tmp pointer to the next channel to
+			   be scanned */
+			tmp_chan_list++;
+
+			/* Stop the loop if the *next* channel is in the 1,6,11
+			   set.  This will cause it to be the only channel
+			   scanned on the next interation */
+			if (!filtered_scan && (tmp_chan_list->chan_number == 1
+				|| tmp_chan_list->chan_number == 6
+				|| tmp_chan_list->chan_number == 11))
+				done_early = true;
+		}
+
+		/* The total scan time should be less than scan command timeout
+		   value */
+		if (total_scan_time > MWIFIEX_MAX_TOTAL_SCAN_TIME) {
+			dev_err(priv->adapter->dev, "total scan time %dms"
+				" is over limit (%dms), scan skipped\n",
+				total_scan_time, MWIFIEX_MAX_TOTAL_SCAN_TIME);
+			ret = -1;
+			break;
+		}
+
+		priv->adapter->scan_channels = start_chan;
+
+		/* Send the scan command to the firmware with the specified
+		   cfg */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SCAN,
+					  HostCmd_ACT_GEN_SET,
+					  0, wait_buf, scan_cfg_out);
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This function constructs a scan command configuration structure to use
+ * in scan commands.
+ *
+ * Application layer or other functions can invoke network scanning
+ * with a scan configuration supplied in a user scan configuration structure.
+ * This structure is used as the basis of one or many scan command configuration
+ * commands that are sent to the command processing module and eventually to the
+ * firmware.
+ *
+ * This function creates a scan command configuration structure  based on the
+ * following user supplied parameters (if present):
+ *      - SSID filter
+ *      - BSSID filter
+ *      - Number of Probes to be sent
+ *      - Channel list
+ *
+ * If the SSID or BSSID filter is not present, the filter is disabled/cleared.
+ * If the number of probes is not set, adapter default setting is used.
+ */
+static void
+mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
+			       const struct mwifiex_user_scan_cfg *user_scan_in,
+			       struct mwifiex_scan_cmd_config *scan_cfg_out,
+			       struct mwifiex_ie_types_chan_list_param_set
+			       **chan_list_out,
+			       struct mwifiex_chan_scan_param_set
+			       *scan_chan_list,
+			       u8 *max_chan_per_scan, u8 *filtered_scan,
+			       u8 *scan_current_only)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_ie_types_num_probes *num_probes_tlv;
+	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
+	struct mwifiex_ie_types_rates_param_set *rates_tlv;
+	const u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+	u8 *tlv_pos;
+	u32 num_probes;
+	u32 ssid_len;
+	u32 chan_idx;
+	u32 scan_type;
+	u16 scan_dur;
+	u8 channel;
+	u8 radio_type;
+	u32 ssid_idx;
+	u8 ssid_filter;
+	u8 rates[MWIFIEX_SUPPORTED_RATES];
+	u32 rates_size;
+	struct mwifiex_ie_types_htcap *ht_cap;
+
+	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
+	   in this routine will be preserved since the routine that sends the
+	   command will append channelTLVs at *chan_list_out.  The difference
+	   between the *chan_list_out and the tlv_buf start will be used to
+	   calculate the size of anything we add in this routine. */
+	scan_cfg_out->tlv_buf_len = 0;
+
+	/* Running tlv pointer.  Assigned to chan_list_out at end of function
+	   so later routines know where channels can be added to the command
+	   buf */
+	tlv_pos = scan_cfg_out->tlv_buf;
+
+	/* Initialize the scan as un-filtered; the flag is later set to TRUE
+	   below if a SSID or BSSID filter is sent in the command */
+	*filtered_scan = false;
+
+	/* Initialize the scan as not being only on the current channel.  If
+	   the channel list is customized, only contains one channel, and is
+	   the active channel, this is set true and data flow is not halted. */
+	*scan_current_only = false;
+
+	if (user_scan_in) {
+
+		/* Default the ssid_filter flag to TRUE, set false under
+		   certain wildcard conditions and qualified by the existence
+		   of an SSID list before marking the scan as filtered */
+		ssid_filter = true;
+
+		/* Set the BSS type scan filter, use Adapter setting if
+		   unset */
+		scan_cfg_out->bss_mode =
+			(user_scan_in->bss_mode ? (u8) user_scan_in->
+			 bss_mode : (u8) adapter->scan_mode);
+
+		/* Set the number of probes to send, use Adapter setting
+		   if unset */
+		num_probes =
+			(user_scan_in->num_probes ? user_scan_in->
+			 num_probes : adapter->scan_probes);
+
+		/*
+		 * Set the BSSID filter to the incoming configuration,
+		 * if non-zero.  If not set, it will remain disabled
+		 * (all zeros).
+		 */
+		memcpy(scan_cfg_out->specific_bssid,
+		       user_scan_in->specific_bssid,
+		       sizeof(scan_cfg_out->specific_bssid));
+
+		for (ssid_idx = 0;
+		     ((ssid_idx < ARRAY_SIZE(user_scan_in->ssid_list))
+		      && (*user_scan_in->ssid_list[ssid_idx].ssid
+			  || user_scan_in->ssid_list[ssid_idx].max_len));
+		     ssid_idx++) {
+
+			ssid_len = strlen(user_scan_in->ssid_list[ssid_idx].
+					  ssid) + 1;
+
+			wildcard_ssid_tlv =
+				(struct mwifiex_ie_types_wildcard_ssid_params *)
+				tlv_pos;
+			wildcard_ssid_tlv->header.type =
+				cpu_to_le16(TLV_TYPE_WILDCARDSSID);
+			wildcard_ssid_tlv->header.len = cpu_to_le16(
+				(u16) (ssid_len + sizeof(wildcard_ssid_tlv->
+							 max_ssid_length)));
+			wildcard_ssid_tlv->max_ssid_length =
+				user_scan_in->ssid_list[ssid_idx].max_len;
+
+			memcpy(wildcard_ssid_tlv->ssid,
+			       user_scan_in->ssid_list[ssid_idx].ssid,
+			       ssid_len);
+
+			tlv_pos += (sizeof(wildcard_ssid_tlv->header)
+				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
+
+			dev_dbg(adapter->dev, "info: scan: ssid_list[%d]: %s, %d\n",
+				ssid_idx, wildcard_ssid_tlv->ssid,
+				wildcard_ssid_tlv->max_ssid_length);
+
+			/* Empty wildcard ssid with a maxlen will match many or
+			   potentially all SSIDs (maxlen == 32), therefore do
+			   not treat the scan as
+			   filtered. */
+			if (!ssid_len && wildcard_ssid_tlv->max_ssid_length)
+				ssid_filter = false;
+
+		}
+
+		/*
+		 *  The default number of channels sent in the command is low to
+		 *  ensure the response buffer from the firmware does not
+		 *  truncate scan results.  That is not an issue with an SSID
+		 *  or BSSID filter applied to the scan results in the firmware.
+		 */
+		if ((ssid_idx && ssid_filter)
+		    || memcmp(scan_cfg_out->specific_bssid, &zero_mac,
+			      sizeof(zero_mac)))
+			*filtered_scan = true;
+	} else {
+		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
+		num_probes = adapter->scan_probes;
+	}
+
+	/*
+	 *  If a specific BSSID or SSID is used, the number of channels in the
+	 *  scan command will be increased to the absolute maximum.
+	 */
+	if (*filtered_scan)
+		*max_chan_per_scan = MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
+	else
+		*max_chan_per_scan = MWIFIEX_CHANNELS_PER_SCAN_CMD;
+
+	/* If the input config or adapter has the number of Probes set,
+	   add tlv */
+	if (num_probes) {
+
+		dev_dbg(adapter->dev, "info: scan: num_probes = %d\n",
+						num_probes);
+
+		num_probes_tlv = (struct mwifiex_ie_types_num_probes *) tlv_pos;
+		num_probes_tlv->header.type = cpu_to_le16(TLV_TYPE_NUMPROBES);
+		num_probes_tlv->header.len =
+			cpu_to_le16(sizeof(num_probes_tlv->num_probes));
+		num_probes_tlv->num_probes = cpu_to_le16((u16) num_probes);
+
+		tlv_pos += sizeof(num_probes_tlv->header) +
+			le16_to_cpu(num_probes_tlv->header.len);
+
+	}
+
+	/* Append rates tlv */
+	memset(rates, 0, sizeof(rates));
+
+	rates_size = mwifiex_get_supported_rates(priv, rates);
+
+	rates_tlv = (struct mwifiex_ie_types_rates_param_set *) tlv_pos;
+	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
+	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
+	memcpy(rates_tlv->rates, rates, rates_size);
+	tlv_pos += sizeof(rates_tlv->header) + rates_size;
+
+	dev_dbg(adapter->dev, "info: SCAN_CMD: Rates size = %d\n", rates_size);
+
+	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
+	    && (priv->adapter->config_bands & BAND_GN
+		|| priv->adapter->config_bands & BAND_AN)) {
+		ht_cap = (struct mwifiex_ie_types_htcap *) tlv_pos;
+		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
+		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+		ht_cap->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+		mwifiex_fill_cap_info(priv, ht_cap);
+		tlv_pos += sizeof(struct mwifiex_ie_types_htcap);
+	}
+
+	/* Append vendor specific IE TLV */
+	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_SCAN, &tlv_pos);
+
+	/*
+	 * Set the output for the channel TLV to the address in the tlv buffer
+	 *   past any TLVs that were added in this function (SSID, num_probes).
+	 *   Channel TLVs will be added past this for each scan command,
+	 *   preserving the TLVs that were previously added.
+	 */
+	*chan_list_out =
+		(struct mwifiex_ie_types_chan_list_param_set *) tlv_pos;
+
+	if (user_scan_in && user_scan_in->chan_list[0].chan_number) {
+
+		dev_dbg(adapter->dev, "info: Scan: Using supplied channel list\n");
+
+		for (chan_idx = 0;
+		     chan_idx < MWIFIEX_USER_SCAN_CHAN_MAX
+		     && user_scan_in->chan_list[chan_idx].chan_number;
+		     chan_idx++) {
+
+			channel = user_scan_in->chan_list[chan_idx].chan_number;
+			(scan_chan_list + chan_idx)->chan_number = channel;
+
+			radio_type =
+				user_scan_in->chan_list[chan_idx].radio_type;
+			(scan_chan_list + chan_idx)->radio_type = radio_type;
+
+			scan_type = user_scan_in->chan_list[chan_idx].scan_type;
+
+			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+				(scan_chan_list +
+				 chan_idx)->chan_scan_mode_bitmap
+					|= MWIFIEX_PASSIVE_SCAN;
+			else
+				(scan_chan_list +
+				 chan_idx)->chan_scan_mode_bitmap
+					&= ~MWIFIEX_PASSIVE_SCAN;
+
+			if (user_scan_in->chan_list[chan_idx].scan_time) {
+				scan_dur = (u16) user_scan_in->
+					chan_list[chan_idx].scan_time;
+			} else {
+				if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
+					scan_dur = adapter->passive_scan_time;
+				else if (*filtered_scan)
+					scan_dur = adapter->specific_scan_time;
+				else
+					scan_dur = adapter->active_scan_time;
+			}
+
+			(scan_chan_list + chan_idx)->min_scan_time =
+				cpu_to_le16(scan_dur);
+			(scan_chan_list + chan_idx)->max_scan_time =
+				cpu_to_le16(scan_dur);
+		}
+
+		/* Check if we are only scanning the current channel */
+		if ((chan_idx == 1)
+		    && (user_scan_in->chan_list[0].chan_number
+			== priv->curr_bss_params.bss_descriptor.channel)) {
+			*scan_current_only = true;
+			dev_dbg(adapter->dev,
+				"info: Scan: Scanning current channel only\n");
+		}
+
+	} else {
+		dev_dbg(adapter->dev,
+				"info: Scan: Creating full region channel list\n");
+		mwifiex_scan_create_channel_list(priv, user_scan_in,
+						 scan_chan_list,
+						 *filtered_scan);
+	}
+}
+
+/*
+ * This function inspects the scan response buffer for pointers to
+ * expected TLVs.
+ *
+ * TLVs can be included at the end of the scan response BSS information.
+ *
+ * Data in the buffer is parsed pointers to TLVs that can potentially
+ * be passed back in the response.
+ */
+static void
+mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
+				     struct mwifiex_ie_types_data *tlv,
+				     u32 tlv_buf_size, u32 req_tlv_type,
+				     struct mwifiex_ie_types_data **tlv_data)
+{
+	struct mwifiex_ie_types_data *current_tlv;
+	u32 tlv_buf_left;
+	u32 tlv_type;
+	u32 tlv_len;
+
+	current_tlv = tlv;
+	tlv_buf_left = tlv_buf_size;
+	*tlv_data = NULL;
+
+	dev_dbg(adapter->dev, "info: SCAN_RESP: tlv_buf_size = %d\n",
+						tlv_buf_size);
+
+	while (tlv_buf_left >= sizeof(struct mwifiex_ie_types_header)) {
+
+		tlv_type = le16_to_cpu(current_tlv->header.type);
+		tlv_len = le16_to_cpu(current_tlv->header.len);
+
+		if (sizeof(tlv->header) + tlv_len > tlv_buf_left) {
+			dev_err(adapter->dev, "SCAN_RESP: TLV buffer corrupt\n");
+			break;
+		}
+
+		if (req_tlv_type == tlv_type) {
+			switch (tlv_type) {
+			case TLV_TYPE_TSFTIMESTAMP:
+				dev_dbg(adapter->dev, "info: SCAN_RESP: TSF "
+					"timestamp TLV, len = %d\n", tlv_len);
+				*tlv_data = (struct mwifiex_ie_types_data *)
+					current_tlv;
+				break;
+			case TLV_TYPE_CHANNELBANDLIST:
+				dev_dbg(adapter->dev, "info: SCAN_RESP: channel"
+					" band list TLV, len = %d\n", tlv_len);
+				*tlv_data = (struct mwifiex_ie_types_data *)
+					current_tlv;
+				break;
+			default:
+				dev_err(adapter->dev,
+					"SCAN_RESP: unhandled TLV = %d\n",
+				       tlv_type);
+				/* Give up, this seems corrupted */
+				return;
+			}
+		}
+
+		if (*tlv_data)
+			break;
+
+
+		tlv_buf_left -= (sizeof(tlv->header) + tlv_len);
+		current_tlv =
+			(struct mwifiex_ie_types_data *) (current_tlv->data +
+							  tlv_len);
+
+	}			/* while */
+}
+
+/*
+ * This function interprets a BSS scan response returned from the firmware.
+ *
+ * The various fixed fields and IEs are parsed and passed back for a BSS
+ * probe response or beacon from scan command. Information is recorded as
+ * needed in the scan table for that entry.
+ *
+ * The following IE types are recognized and parsed -
+ *      - SSID
+ *      - Supported rates
+ *      - FH parameters set
+ *      - DS parameters set
+ *      - CF parameters set
+ *      - IBSS parameters set
+ *      - ERP information
+ *      - Extended supported rates
+ *      - Vendor specific (221)
+ *      - RSN IE
+ *      - WAPI IE
+ *      - HT capability
+ *      - HT operation
+ *      - BSS Coexistence 20/40
+ *      - Extended capability
+ *      - Overlapping BSS scan parameters
+ */
+static int
+mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
+				   struct mwifiex_bssdescriptor *bss_entry,
+				   u8 **beacon_info, u32 *bytes_left)
+{
+	int ret = 0;
+	u8 element_id;
+	struct ieee_types_fh_param_set *fh_param_set;
+	struct ieee_types_ds_param_set *ds_param_set;
+	struct ieee_types_cf_param_set *cf_param_set;
+	struct ieee_types_ibss_param_set *ibss_param_set;
+	struct mwifiex_802_11_fixed_ies fixed_ie;
+	u8 *current_ptr;
+	u8 *rate;
+	u8 element_len;
+	u16 total_ie_len;
+	u8 bytes_to_copy;
+	u8 rate_size;
+	u16 beacon_size;
+	u8 found_data_rate_ie;
+	u32 bytes_left_for_current_beacon;
+	struct ieee_types_vendor_specific *vendor_ie;
+	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
+	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
+
+	found_data_rate_ie = false;
+	rate_size = 0;
+	beacon_size = 0;
+
+	if (*bytes_left >= sizeof(beacon_size)) {
+		/* Extract & convert beacon size from the command buffer */
+		memcpy(&beacon_size, *beacon_info, sizeof(beacon_size));
+		*bytes_left -= sizeof(beacon_size);
+		*beacon_info += sizeof(beacon_size);
+	}
+
+	if (!beacon_size || beacon_size > *bytes_left) {
+		*beacon_info += *bytes_left;
+		*bytes_left = 0;
+		return -1;
+	}
+
+	/* Initialize the current working beacon pointer for this BSS
+	   iteration */
+	current_ptr = *beacon_info;
+
+	/* Advance the return beacon pointer past the current beacon */
+	*beacon_info += beacon_size;
+	*bytes_left -= beacon_size;
+
+	bytes_left_for_current_beacon = beacon_size;
+
+	memcpy(bss_entry->mac_address, current_ptr, ETH_ALEN);
+	dev_dbg(adapter->dev, "info: InterpretIE: AP MAC Addr: %pM\n",
+						bss_entry->mac_address);
+
+	current_ptr += ETH_ALEN;
+	bytes_left_for_current_beacon -= ETH_ALEN;
+
+	if (bytes_left_for_current_beacon < 12) {
+		dev_err(adapter->dev, "InterpretIE: not enough bytes left\n");
+		return -1;
+	}
+
+	/*
+	 * Next 4 fields are RSSI, time stamp, beacon interval,
+	 *   and capability information
+	 */
+
+	/* RSSI is 1 byte long */
+	bss_entry->rssi = (s32) (*current_ptr);
+	dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n", *current_ptr);
+	current_ptr += 1;
+	bytes_left_for_current_beacon -= 1;
+
+	/*
+	 *  The RSSI is not part of the beacon/probe response.  After we have
+	 *    advanced current_ptr past the RSSI field, save the remaining
+	 *    data for use at the application layer
+	 */
+	bss_entry->beacon_buf = current_ptr;
+	bss_entry->beacon_buf_size = bytes_left_for_current_beacon;
+
+	/* Time stamp is 8 bytes long */
+	memcpy(fixed_ie.time_stamp, current_ptr, 8);
+	memcpy(bss_entry->time_stamp, current_ptr, 8);
+	current_ptr += 8;
+	bytes_left_for_current_beacon -= 8;
+
+	/* Beacon interval is 2 bytes long */
+	memcpy(&fixed_ie.beacon_interval, current_ptr, 2);
+	bss_entry->beacon_period = le16_to_cpu(fixed_ie.beacon_interval);
+	current_ptr += 2;
+	bytes_left_for_current_beacon -= 2;
+
+	/* Capability information is 2 bytes long */
+	memcpy(&fixed_ie.capabilities, current_ptr, 2);
+	dev_dbg(adapter->dev, "info: InterpretIE: fixed_ie.capabilities=0x%X\n",
+	       fixed_ie.capabilities);
+	bss_entry->cap_info_bitmap = le16_to_cpu(fixed_ie.capabilities);
+	current_ptr += 2;
+	bytes_left_for_current_beacon -= 2;
+
+	/* Rest of the current buffer are IE's */
+	dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP = %d\n",
+	       bytes_left_for_current_beacon);
+
+	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_PRIVACY) {
+		dev_dbg(adapter->dev, "info: InterpretIE: AP WEP enabled\n");
+		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_8021X_WEP;
+	} else {
+		bss_entry->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
+	}
+
+	if (bss_entry->cap_info_bitmap & WLAN_CAPABILITY_IBSS)
+		bss_entry->bss_mode = MWIFIEX_BSS_MODE_IBSS;
+	else
+		bss_entry->bss_mode = MWIFIEX_BSS_MODE_INFRA;
+
+
+	/* Process variable IE */
+	while (bytes_left_for_current_beacon >= 2) {
+		element_id = *current_ptr;
+		element_len = *(current_ptr + 1);
+		total_ie_len = element_len + sizeof(struct ieee_types_header);
+
+		if (bytes_left_for_current_beacon < total_ie_len) {
+			dev_err(adapter->dev, "err: InterpretIE: in processing"
+				" IE, bytes left < IE length\n");
+			bytes_left_for_current_beacon = 0;
+			ret = -1;
+			continue;
+		}
+		switch (element_id) {
+		case WLAN_EID_SSID:
+			bss_entry->ssid.ssid_len = element_len;
+			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
+			       element_len);
+			dev_dbg(adapter->dev, "info: InterpretIE: ssid: %-32s\n",
+			       bss_entry->ssid.ssid);
+			break;
+
+		case WLAN_EID_SUPP_RATES:
+			memcpy(bss_entry->data_rates, current_ptr + 2,
+			       element_len);
+			memcpy(bss_entry->supported_rates, current_ptr + 2,
+			       element_len);
+			rate_size = element_len;
+			found_data_rate_ie = true;
+			break;
+
+		case WLAN_EID_FH_PARAMS:
+			fh_param_set =
+				(struct ieee_types_fh_param_set *) current_ptr;
+			memcpy(&bss_entry->phy_param_set.fh_param_set,
+			       fh_param_set,
+			       sizeof(struct ieee_types_fh_param_set));
+			break;
+
+		case WLAN_EID_DS_PARAMS:
+			ds_param_set =
+				(struct ieee_types_ds_param_set *) current_ptr;
+
+			bss_entry->channel = ds_param_set->current_chan;
+
+			memcpy(&bss_entry->phy_param_set.ds_param_set,
+			       ds_param_set,
+			       sizeof(struct ieee_types_ds_param_set));
+			break;
+
+		case WLAN_EID_CF_PARAMS:
+			cf_param_set =
+				(struct ieee_types_cf_param_set *) current_ptr;
+			memcpy(&bss_entry->ss_param_set.cf_param_set,
+			       cf_param_set,
+			       sizeof(struct ieee_types_cf_param_set));
+			break;
+
+		case WLAN_EID_IBSS_PARAMS:
+			ibss_param_set =
+				(struct ieee_types_ibss_param_set *)
+				current_ptr;
+			memcpy(&bss_entry->ss_param_set.ibss_param_set,
+			       ibss_param_set,
+			       sizeof(struct ieee_types_ibss_param_set));
+			break;
+
+		case WLAN_EID_ERP_INFO:
+			bss_entry->erp_flags = *(current_ptr + 2);
+			break;
+
+		case WLAN_EID_EXT_SUPP_RATES:
+			/*
+			 * Only process extended supported rate
+			 * if data rate is already found.
+			 * Data rate IE should come before
+			 * extended supported rate IE
+			 */
+			if (found_data_rate_ie) {
+				if ((element_len + rate_size) >
+				    MWIFIEX_SUPPORTED_RATES)
+					bytes_to_copy =
+						(MWIFIEX_SUPPORTED_RATES -
+						 rate_size);
+				else
+					bytes_to_copy = element_len;
+
+				rate = (u8 *) bss_entry->data_rates;
+				rate += rate_size;
+				memcpy(rate, current_ptr + 2, bytes_to_copy);
+
+				rate = (u8 *) bss_entry->supported_rates;
+				rate += rate_size;
+				memcpy(rate, current_ptr + 2, bytes_to_copy);
+			}
+			break;
+
+		case WLAN_EID_VENDOR_SPECIFIC:
+			vendor_ie = (struct ieee_types_vendor_specific *)
+					current_ptr;
+
+			if (!memcmp
+			    (vendor_ie->vend_hdr.oui, wpa_oui,
+			     sizeof(wpa_oui))) {
+				bss_entry->bcn_wpa_ie =
+					(struct ieee_types_vendor_specific *)
+					current_ptr;
+				bss_entry->wpa_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
+			} else if (!memcmp(vendor_ie->vend_hdr.oui, wmm_oui,
+				    sizeof(wmm_oui))) {
+				if (total_ie_len ==
+				    sizeof(struct ieee_types_wmm_parameter)
+				    || total_ie_len ==
+				    sizeof(struct ieee_types_wmm_info))
+					/*
+					 * Only accept and copy the WMM IE if
+					 * it matches the size expected for the
+					 * WMM Info IE or the WMM Parameter IE.
+					 */
+					memcpy((u8 *) &bss_entry->wmm_ie,
+					       current_ptr, total_ie_len);
+			}
+			break;
+		case WLAN_EID_RSN:
+			bss_entry->bcn_rsn_ie =
+				(struct ieee_types_generic *) current_ptr;
+			bss_entry->rsn_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_BSS_AC_ACCESS_DELAY:
+			bss_entry->bcn_wapi_ie =
+				(struct ieee_types_generic *) current_ptr;
+			bss_entry->wapi_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_HT_CAPABILITY:
+			bss_entry->bcn_ht_cap = (struct ieee80211_ht_cap *)
+					(current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ht_cap_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_HT_INFORMATION:
+			bss_entry->bcn_ht_info = (struct ieee80211_ht_info *)
+					(current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ht_info_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_BSS_COEX_2040:
+			bss_entry->bcn_bss_co_2040 = (u8 *) (current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->bss_co_2040_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+						bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_EXT_CAPABILITY:
+			bss_entry->bcn_ext_cap = (u8 *) (current_ptr +
+					sizeof(struct ieee_types_header));
+			bss_entry->ext_cap_offset = (u16) (current_ptr +
+					sizeof(struct ieee_types_header) -
+					bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
+			bss_entry->bcn_obss_scan =
+				(struct ieee_types_obss_scan_param *)
+				current_ptr;
+			bss_entry->overlap_bss_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
+			break;
+		default:
+			break;
+		}
+
+		current_ptr += element_len + 2;
+
+		/* Need to account for IE ID and IE Len */
+		bytes_left_for_current_beacon -= (element_len + 2);
+
+	}	/* while (bytes_left_for_current_beacon > 2) */
+	return ret;
+}
+
+/*
+ * This function adjusts the pointers used in beacon buffers to reflect
+ * shifts.
+ *
+ * The memory allocated for beacon buffers is of fixed sizes where all the
+ * saved beacons must be stored. New beacons are added in the free portion
+ * of this memory, space permitting; while duplicate beacon buffers are
+ * placed at the same start location. However, since duplicate beacon
+ * buffers may not match the size of the old one, all the following buffers
+ * in the memory must be shifted to either make space, or to fill up freed
+ * up space.
+ *
+ * This function is used to update the beacon buffer pointers that are past
+ * an existing beacon buffer that is updated with a new one of different
+ * size. The pointers are shifted by a fixed amount, either forward or
+ * backward.
+ *
+ * the following pointers in every affected beacon buffers are changed, if
+ * present -
+ *      - WPA IE pointer
+ *      - RSN IE pointer
+ *      - WAPI IE pointer
+ *      - HT capability IE pointer
+ *      - HT information IE pointer
+ *      - BSS coexistence 20/40 IE pointer
+ *      - Extended capability IE pointer
+ *      - Overlapping BSS scan parameter IE pointer
+ */
+static void
+mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv, u8 advance,
+				  u8 *bcn_store, u32 rem_bcn_size,
+				  u32 num_of_ent)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 adj_idx;
+	for (adj_idx = 0; adj_idx < num_of_ent; adj_idx++) {
+		if (adapter->scan_table[adj_idx].beacon_buf > bcn_store) {
+
+			if (advance)
+				adapter->scan_table[adj_idx].beacon_buf +=
+					rem_bcn_size;
+			else
+				adapter->scan_table[adj_idx].beacon_buf -=
+					rem_bcn_size;
+
+			if (adapter->scan_table[adj_idx].bcn_wpa_ie)
+				adapter->scan_table[adj_idx].bcn_wpa_ie =
+				(struct ieee_types_vendor_specific *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].wpa_offset);
+			if (adapter->scan_table[adj_idx].bcn_rsn_ie)
+				adapter->scan_table[adj_idx].bcn_rsn_ie =
+				(struct ieee_types_generic *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].rsn_offset);
+			if (adapter->scan_table[adj_idx].bcn_wapi_ie)
+				adapter->scan_table[adj_idx].bcn_wapi_ie =
+				(struct ieee_types_generic *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].wapi_offset);
+			if (adapter->scan_table[adj_idx].bcn_ht_cap)
+				adapter->scan_table[adj_idx].bcn_ht_cap =
+				(struct ieee80211_ht_cap *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].ht_cap_offset);
+
+			if (adapter->scan_table[adj_idx].bcn_ht_info)
+				adapter->scan_table[adj_idx].bcn_ht_info =
+				(struct ieee80211_ht_info *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].ht_info_offset);
+			if (adapter->scan_table[adj_idx].bcn_bss_co_2040)
+				adapter->scan_table[adj_idx].bcn_bss_co_2040 =
+				(u8 *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+			       adapter->scan_table[adj_idx].bss_co_2040_offset);
+			if (adapter->scan_table[adj_idx].bcn_ext_cap)
+				adapter->scan_table[adj_idx].bcn_ext_cap =
+				(u8 *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+				 adapter->scan_table[adj_idx].ext_cap_offset);
+			if (adapter->scan_table[adj_idx].bcn_obss_scan)
+				adapter->scan_table[adj_idx].bcn_obss_scan =
+				(struct ieee_types_obss_scan_param *)
+				(adapter->scan_table[adj_idx].beacon_buf +
+			       adapter->scan_table[adj_idx].overlap_bss_offset);
+		}
+	}
+}
+
+/*
+ * This function updates the pointers used in beacon buffer for given bss
+ * descriptor to reflect shifts
+ *
+ * Following pointers are updated
+ *      - WPA IE pointer
+ *      - RSN IE pointer
+ *      - WAPI IE pointer
+ *      - HT capability IE pointer
+ *      - HT information IE pointer
+ *      - BSS coexistence 20/40 IE pointer
+ *      - Extended capability IE pointer
+ *      - Overlapping BSS scan parameter IE pointer
+ */
+static void
+mwifiex_update_beacon_buffer_ptrs(struct mwifiex_bssdescriptor *beacon)
+{
+	if (beacon->bcn_wpa_ie)
+		beacon->bcn_wpa_ie = (struct ieee_types_vendor_specific *)
+			(beacon->beacon_buf + beacon->wpa_offset);
+	if (beacon->bcn_rsn_ie)
+		beacon->bcn_rsn_ie = (struct ieee_types_generic *)
+			(beacon->beacon_buf + beacon->rsn_offset);
+	if (beacon->bcn_wapi_ie)
+		beacon->bcn_wapi_ie = (struct ieee_types_generic *)
+			(beacon->beacon_buf + beacon->wapi_offset);
+	if (beacon->bcn_ht_cap)
+		beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
+			(beacon->beacon_buf + beacon->ht_cap_offset);
+	if (beacon->bcn_ht_info)
+		beacon->bcn_ht_info = (struct ieee80211_ht_info *)
+			(beacon->beacon_buf + beacon->ht_info_offset);
+	if (beacon->bcn_bss_co_2040)
+		beacon->bcn_bss_co_2040 = (u8 *) (beacon->beacon_buf +
+			beacon->bss_co_2040_offset);
+	if (beacon->bcn_ext_cap)
+		beacon->bcn_ext_cap = (u8 *) (beacon->beacon_buf +
+			beacon->ext_cap_offset);
+	if (beacon->bcn_obss_scan)
+		beacon->bcn_obss_scan = (struct ieee_types_obss_scan_param *)
+			(beacon->beacon_buf + beacon->overlap_bss_offset);
+}
+
+/*
+ * This function stores a beacon or probe response for a BSS returned
+ * in the scan.
+ *
+ * This stores a new scan response or an update for a previous scan response.
+ * New entries need to verify that they do not exceed the total amount of
+ * memory allocated for the table.
+ *
+ * Replacement entries need to take into consideration the amount of space
+ * currently allocated for the beacon/probe response and adjust the entry
+ * as needed.
+ *
+ * A small amount of extra pad (SCAN_BEACON_ENTRY_PAD) is generally reserved
+ * for an entry in case it is a beacon since a probe response for the
+ * network will by larger per the standard.  This helps to reduce the
+ * amount of memory copying to fit a new probe response into an entry
+ * already occupied by a network's previously stored beacon.
+ */
+static void
+mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
+				     u32 beacon_idx, u32 num_of_ent,
+				     struct mwifiex_bssdescriptor *new_beacon)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *bcn_store;
+	u32 new_bcn_size;
+	u32 old_bcn_size;
+	u32 bcn_space;
+
+	if (adapter->scan_table[beacon_idx].beacon_buf) {
+
+		new_bcn_size = new_beacon->beacon_buf_size;
+		old_bcn_size = adapter->scan_table[beacon_idx].beacon_buf_size;
+		bcn_space = adapter->scan_table[beacon_idx].beacon_buf_size_max;
+		bcn_store = adapter->scan_table[beacon_idx].beacon_buf;
+
+		/* Set the max to be the same as current entry unless changed
+		   below */
+		new_beacon->beacon_buf_size_max = bcn_space;
+		if (new_bcn_size == old_bcn_size) {
+			/*
+			 * Beacon is the same size as the previous entry.
+			 *   Replace the previous contents with the scan result
+			 */
+			memcpy(bcn_store, new_beacon->beacon_buf,
+			       new_beacon->beacon_buf_size);
+
+		} else if (new_bcn_size <= bcn_space) {
+			/*
+			 * New beacon size will fit in the amount of space
+			 *   we have previously allocated for it
+			 */
+
+			/* Copy the new beacon buffer entry over the old one */
+			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
+
+			/*
+			 *  If the old beacon size was less than the maximum
+			 *  we had alloted for the entry, and the new entry
+			 *  is even smaller, reset the max size to the old
+			 *  beacon entry and compress the storage space
+			 *  (leaving a new pad space of (old_bcn_size -
+			 *  new_bcn_size).
+			 */
+			if (old_bcn_size < bcn_space
+			    && new_bcn_size <= old_bcn_size) {
+				/*
+				 * Old Beacon size is smaller than the alloted
+				 * storage size. Shrink the alloted storage
+				 * space.
+				 */
+				dev_dbg(adapter->dev, "info: AppControl:"
+					" smaller duplicate beacon "
+				       "(%d), old = %d, new = %d, space = %d,"
+				       "left = %d\n",
+				       beacon_idx, old_bcn_size, new_bcn_size,
+				       bcn_space,
+				       (int)(sizeof(adapter->bcn_buf) -
+					(adapter->bcn_buf_end -
+					 adapter->bcn_buf)));
+
+				/*
+				 *  memmove (since the memory overlaps) the
+				 *  data after the beacon we just stored to the
+				 *  end of the current beacon.  This cleans up
+				 *  any unused space the old larger beacon was
+				 *  using in the buffer
+				 */
+				memmove(bcn_store + old_bcn_size,
+					bcn_store + bcn_space,
+					adapter->bcn_buf_end - (bcn_store +
+								   bcn_space));
+
+				/*
+				 * Decrement the end pointer by the difference
+				 * between the old larger size and the new
+				 * smaller size since we are using less space
+				 * due to the new beacon being smaller
+				 */
+				adapter->bcn_buf_end -=
+					(bcn_space - old_bcn_size);
+
+				/* Set the maximum storage size to the old
+				   beacon size */
+				new_beacon->beacon_buf_size_max = old_bcn_size;
+
+				/* Adjust beacon buffer pointers that are past
+				   the current */
+				mwifiex_adjust_beacon_buffer_ptrs(priv, 0,
+					bcn_store, (bcn_space - old_bcn_size),
+					num_of_ent);
+			}
+		} else if (adapter->bcn_buf_end + (new_bcn_size - bcn_space)
+			   < (adapter->bcn_buf + sizeof(adapter->bcn_buf))) {
+			/*
+			 * Beacon is larger than space previously allocated
+			 * (bcn_space) and there is enough space left in the
+			 * beaconBuffer to store the additional data
+			 */
+			dev_dbg(adapter->dev, "info: AppControl:"
+				" larger duplicate beacon (%d), "
+			       "old = %d, new = %d, space = %d, left = %d\n",
+			       beacon_idx, old_bcn_size, new_bcn_size,
+			       bcn_space,
+			       (int)(sizeof(adapter->bcn_buf) -
+				(adapter->bcn_buf_end -
+				 adapter->bcn_buf)));
+
+			/*
+			 * memmove (since the memory overlaps) the data
+			 *  after the beacon we just stored to the end of
+			 *  the current beacon.  This moves the data for
+			 *  the beacons after this further in memory to
+			 *  make space for the new larger beacon we are
+			 *  about to copy in.
+			 */
+			memmove(bcn_store + new_bcn_size,
+				bcn_store + bcn_space,
+				adapter->bcn_buf_end - (bcn_store + bcn_space));
+
+			/* Copy the new beacon buffer entry over the old one */
+			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
+
+			/* Move the beacon end pointer by the amount of new
+			   beacon data we are adding */
+			adapter->bcn_buf_end += (new_bcn_size - bcn_space);
+
+			/*
+			 * This entry is bigger than the alloted max space
+			 *  previously reserved.  Increase the max space to
+			 *  be equal to the new beacon size
+			 */
+			new_beacon->beacon_buf_size_max = new_bcn_size;
+
+			/* Adjust beacon buffer pointers that are past the
+			   current */
+			mwifiex_adjust_beacon_buffer_ptrs(priv, 1, bcn_store,
+						(new_bcn_size - bcn_space),
+						num_of_ent);
+		} else {
+			/*
+			 * Beacon is larger than the previously allocated space,
+			 * but there is not enough free space to store the
+			 * additional data.
+			 */
+			dev_err(adapter->dev, "AppControl: larger duplicate "
+				" beacon (%d), old = %d new = %d, space = %d,"
+				" left = %d\n", beacon_idx, old_bcn_size,
+				new_bcn_size, bcn_space,
+				(int)(sizeof(adapter->bcn_buf) -
+				(adapter->bcn_buf_end - adapter->bcn_buf)));
+
+			/* Storage failure, keep old beacon intact */
+			new_beacon->beacon_buf_size = old_bcn_size;
+			if (new_beacon->bcn_wpa_ie)
+				new_beacon->wpa_offset =
+					adapter->scan_table[beacon_idx].
+					wpa_offset;
+			if (new_beacon->bcn_rsn_ie)
+				new_beacon->rsn_offset =
+					adapter->scan_table[beacon_idx].
+					rsn_offset;
+			if (new_beacon->bcn_wapi_ie)
+				new_beacon->wapi_offset =
+					adapter->scan_table[beacon_idx].
+					wapi_offset;
+			if (new_beacon->bcn_ht_cap)
+				new_beacon->ht_cap_offset =
+					adapter->scan_table[beacon_idx].
+					ht_cap_offset;
+			if (new_beacon->bcn_ht_info)
+				new_beacon->ht_info_offset =
+					adapter->scan_table[beacon_idx].
+					ht_info_offset;
+			if (new_beacon->bcn_bss_co_2040)
+				new_beacon->bss_co_2040_offset =
+					adapter->scan_table[beacon_idx].
+					bss_co_2040_offset;
+			if (new_beacon->bcn_ext_cap)
+				new_beacon->ext_cap_offset =
+					adapter->scan_table[beacon_idx].
+					ext_cap_offset;
+			if (new_beacon->bcn_obss_scan)
+				new_beacon->overlap_bss_offset =
+					adapter->scan_table[beacon_idx].
+					overlap_bss_offset;
+		}
+		/* Point the new entry to its permanent storage space */
+		new_beacon->beacon_buf = bcn_store;
+		mwifiex_update_beacon_buffer_ptrs(new_beacon);
+	} else {
+		/*
+		 * No existing beacon data exists for this entry, check to see
+		 *   if we can fit it in the remaining space
+		 */
+		if (adapter->bcn_buf_end + new_beacon->beacon_buf_size +
+		    SCAN_BEACON_ENTRY_PAD < (adapter->bcn_buf +
+					     sizeof(adapter->bcn_buf))) {
+
+			/*
+			 * Copy the beacon buffer data from the local entry to
+			 * the adapter dev struct buffer space used to store
+			 * the raw beacon data for each entry in the scan table
+			 */
+			memcpy(adapter->bcn_buf_end, new_beacon->beacon_buf,
+			       new_beacon->beacon_buf_size);
+
+			/* Update the beacon ptr to point to the table save
+			   area */
+			new_beacon->beacon_buf = adapter->bcn_buf_end;
+			new_beacon->beacon_buf_size_max =
+				(new_beacon->beacon_buf_size +
+				 SCAN_BEACON_ENTRY_PAD);
+
+			mwifiex_update_beacon_buffer_ptrs(new_beacon);
+
+			/* Increment the end pointer by the size reserved */
+			adapter->bcn_buf_end += new_beacon->beacon_buf_size_max;
+
+			dev_dbg(adapter->dev, "info: AppControl: beacon[%02d]"
+				" sz=%03d, used = %04d, left = %04d\n",
+			       beacon_idx,
+			       new_beacon->beacon_buf_size,
+			       (int)(adapter->bcn_buf_end - adapter->bcn_buf),
+			       (int)(sizeof(adapter->bcn_buf) -
+				(adapter->bcn_buf_end -
+				 adapter->bcn_buf)));
+		} else {
+			/* No space for new beacon */
+			dev_dbg(adapter->dev, "info: AppControl: no space for"
+				" beacon (%d): %pM sz=%03d, left=%03d\n",
+			       beacon_idx, new_beacon->mac_address,
+			       new_beacon->beacon_buf_size,
+			       (int)(sizeof(adapter->bcn_buf) -
+				(adapter->bcn_buf_end -
+				 adapter->bcn_buf)));
+
+			/* Storage failure; clear storage records for this
+			   bcn */
+			new_beacon->beacon_buf = NULL;
+			new_beacon->beacon_buf_size = 0;
+			new_beacon->beacon_buf_size_max = 0;
+			new_beacon->bcn_wpa_ie = NULL;
+			new_beacon->wpa_offset = 0;
+			new_beacon->bcn_rsn_ie = NULL;
+			new_beacon->rsn_offset = 0;
+			new_beacon->bcn_wapi_ie = NULL;
+			new_beacon->wapi_offset = 0;
+			new_beacon->bcn_ht_cap = NULL;
+			new_beacon->ht_cap_offset = 0;
+			new_beacon->bcn_ht_info = NULL;
+			new_beacon->ht_info_offset = 0;
+			new_beacon->bcn_bss_co_2040 = NULL;
+			new_beacon->bss_co_2040_offset = 0;
+			new_beacon->bcn_ext_cap = NULL;
+			new_beacon->ext_cap_offset = 0;
+			new_beacon->bcn_obss_scan = NULL;
+			new_beacon->overlap_bss_offset = 0;
+		}
+	}
+}
+
+/*
+ * This function restores a beacon buffer of the current BSS descriptor.
+ */
+static void mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bssdescriptor *curr_bss =
+		&priv->curr_bss_params.bss_descriptor;
+	unsigned long flags;
+
+	if (priv->curr_bcn_buf &&
+	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
+	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
+		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
+
+		/* restore the current beacon buffer */
+		memcpy(adapter->bcn_buf_end, priv->curr_bcn_buf,
+		       priv->curr_bcn_size);
+		curr_bss->beacon_buf = adapter->bcn_buf_end;
+		curr_bss->beacon_buf_size = priv->curr_bcn_size;
+		adapter->bcn_buf_end += priv->curr_bcn_size;
+
+		/* adjust the pointers in the current BSS descriptor */
+		if (curr_bss->bcn_wpa_ie)
+			curr_bss->bcn_wpa_ie =
+				(struct ieee_types_vendor_specific *)
+				(curr_bss->beacon_buf +
+				 curr_bss->wpa_offset);
+
+		if (curr_bss->bcn_rsn_ie)
+			curr_bss->bcn_rsn_ie = (struct ieee_types_generic *)
+				(curr_bss->beacon_buf +
+				 curr_bss->rsn_offset);
+
+		if (curr_bss->bcn_ht_cap)
+			curr_bss->bcn_ht_cap = (struct ieee80211_ht_cap *)
+				(curr_bss->beacon_buf +
+				 curr_bss->ht_cap_offset);
+
+		if (curr_bss->bcn_ht_info)
+			curr_bss->bcn_ht_info = (struct ieee80211_ht_info *)
+				(curr_bss->beacon_buf +
+				 curr_bss->ht_info_offset);
+
+		if (curr_bss->bcn_bss_co_2040)
+			curr_bss->bcn_bss_co_2040 =
+				(u8 *) (curr_bss->beacon_buf +
+				 curr_bss->bss_co_2040_offset);
+
+		if (curr_bss->bcn_ext_cap)
+			curr_bss->bcn_ext_cap = (u8 *) (curr_bss->beacon_buf +
+				 curr_bss->ext_cap_offset);
+
+		if (curr_bss->bcn_obss_scan)
+			curr_bss->bcn_obss_scan =
+				(struct ieee_types_obss_scan_param *)
+				(curr_bss->beacon_buf +
+				 curr_bss->overlap_bss_offset);
+
+		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
+
+		dev_dbg(adapter->dev, "info: current beacon restored %d\n",
+		       priv->curr_bcn_size);
+	} else {
+		dev_warn(adapter->dev,
+			"curr_bcn_buf not saved or bcn_buf has no space\n");
+	}
+}
+
+/*
+ * This function post processes the scan table after a new scan command has
+ * completed.
+ *
+ * It inspects each entry of the scan table and tries to find an entry that
+ * matches with our current associated/joined network from the scan. If
+ * one is found, the stored copy of the BSS descriptor of our current network
+ * is updated.
+ *
+ * It also debug dumps the current scan table contents after processing is over.
+ */
+static void
+mwifiex_process_scan_results(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	s32 j;
+	u32 i;
+	unsigned long flags;
+
+	if (priv->media_connected) {
+
+		j = mwifiex_find_ssid_in_list(priv, &priv->curr_bss_params.
+					      bss_descriptor.ssid,
+					      priv->curr_bss_params.
+					      bss_descriptor.mac_address,
+					      priv->bss_mode);
+
+		if (j >= 0) {
+			spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
+			priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
+			priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
+			priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
+			priv->curr_bss_params.bss_descriptor.rsn_offset = 0;
+			priv->curr_bss_params.bss_descriptor.bcn_wapi_ie = NULL;
+			priv->curr_bss_params.bss_descriptor.wapi_offset = 0;
+			priv->curr_bss_params.bss_descriptor.bcn_ht_cap = NULL;
+			priv->curr_bss_params.bss_descriptor.ht_cap_offset =
+				0;
+			priv->curr_bss_params.bss_descriptor.bcn_ht_info = NULL;
+			priv->curr_bss_params.bss_descriptor.ht_info_offset =
+				0;
+			priv->curr_bss_params.bss_descriptor.bcn_bss_co_2040 =
+				NULL;
+			priv->curr_bss_params.bss_descriptor.
+				bss_co_2040_offset = 0;
+			priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
+			priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
+			priv->curr_bss_params.bss_descriptor.
+				bcn_obss_scan = NULL;
+			priv->curr_bss_params.bss_descriptor.
+				overlap_bss_offset = 0;
+			priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
+			priv->curr_bss_params.bss_descriptor.beacon_buf_size =
+				0;
+			priv->curr_bss_params.bss_descriptor.
+				beacon_buf_size_max = 0;
+
+			dev_dbg(adapter->dev, "info: Found current ssid/bssid"
+				" in list @ index #%d\n", j);
+			/* Make a copy of current BSSID descriptor */
+			memcpy(&priv->curr_bss_params.bss_descriptor,
+			       &adapter->scan_table[j],
+			       sizeof(priv->curr_bss_params.bss_descriptor));
+
+			mwifiex_save_curr_bcn(priv);
+			spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
+
+		} else {
+			mwifiex_restore_curr_bcn(priv);
+		}
+	}
+
+	for (i = 0; i < adapter->num_in_scan_table; i++)
+		dev_dbg(adapter->dev, "info: scan:(%02d) %pM "
+		       "RSSI[%03d], SSID[%s]\n",
+		       i, adapter->scan_table[i].mac_address,
+		       (s32) adapter->scan_table[i].rssi,
+		       adapter->scan_table[i].ssid.ssid);
+}
+
+/*
+ * This function converts radio type scan parameter to a band configuration
+ * to be used in join command.
+ */
+static u8
+mwifiex_radio_type_to_band(u8 radio_type)
+{
+	u8 ret_band;
+
+	switch (radio_type) {
+	case HostCmd_SCAN_RADIO_TYPE_A:
+		ret_band = BAND_A;
+		break;
+	case HostCmd_SCAN_RADIO_TYPE_BG:
+	default:
+		ret_band = BAND_G;
+		break;
+	}
+
+	return ret_band;
+}
+
+/*
+ * This function deletes a specific indexed entry from the scan table.
+ *
+ * This also compacts the remaining entries and adjusts any buffering
+ * of beacon/probe response data if needed.
+ */
+static void
+mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 del_idx;
+	u32 beacon_buf_adj;
+	u8 *beacon_buf;
+
+	/*
+	 * Shift the saved beacon buffer data for the scan table back over the
+	 *   entry being removed.  Update the end of buffer pointer.  Save the
+	 *   deleted buffer allocation size for pointer adjustments for entries
+	 *   compacted after the deleted index.
+	 */
+	beacon_buf_adj = adapter->scan_table[table_idx].beacon_buf_size_max;
+
+	dev_dbg(adapter->dev, "info: Scan: Delete Entry %d, beacon buffer "
+		"removal = %d bytes\n", table_idx, beacon_buf_adj);
+
+	/* Check if the table entry had storage allocated for its beacon */
+	if (beacon_buf_adj) {
+		beacon_buf = adapter->scan_table[table_idx].beacon_buf;
+
+		/*
+		 * Remove the entry's buffer space, decrement the table end
+		 * pointer by the amount we are removing
+		 */
+		adapter->bcn_buf_end -= beacon_buf_adj;
+
+		dev_dbg(adapter->dev, "info: scan: delete entry %d,"
+			" compact data: %p <- %p (sz = %d)\n",
+		       table_idx, beacon_buf,
+		       beacon_buf + beacon_buf_adj,
+		       (int)(adapter->bcn_buf_end - beacon_buf));
+
+		/*
+		 * Compact data storage.  Copy all data after the deleted
+		 * entry's end address (beacon_buf + beacon_buf_adj) back
+		 * to the original start address (beacon_buf).
+		 *
+		 * Scan table entries affected by the move will have their
+		 * entry pointer adjusted below.
+		 *
+		 * Use memmove since the dest/src memory regions overlap.
+		 */
+		memmove(beacon_buf, beacon_buf + beacon_buf_adj,
+			adapter->bcn_buf_end - beacon_buf);
+	}
+
+	dev_dbg(adapter->dev,
+		"info: Scan: Delete Entry %d, num_in_scan_table = %d\n",
+	       table_idx, adapter->num_in_scan_table);
+
+	/* Shift all of the entries after the table_idx back by one, compacting
+	   the table and removing the requested entry */
+	for (del_idx = table_idx; (del_idx + 1) < adapter->num_in_scan_table;
+	     del_idx++) {
+		/* Copy the next entry over this one */
+		memcpy(adapter->scan_table + del_idx,
+		       adapter->scan_table + del_idx + 1,
+		       sizeof(struct mwifiex_bssdescriptor));
+
+		/*
+		 * Adjust this entry's pointer to its beacon buffer based on
+		 * the removed/compacted entry from the deleted index.  Don't
+		 * decrement if the buffer pointer is NULL (no data stored for
+		 * this entry).
+		 */
+		if (adapter->scan_table[del_idx].beacon_buf) {
+			adapter->scan_table[del_idx].beacon_buf -=
+				beacon_buf_adj;
+			if (adapter->scan_table[del_idx].bcn_wpa_ie)
+				adapter->scan_table[del_idx].bcn_wpa_ie =
+					(struct ieee_types_vendor_specific *)
+					(adapter->scan_table[del_idx].
+					 beacon_buf +
+					 adapter->scan_table[del_idx].
+					 wpa_offset);
+			if (adapter->scan_table[del_idx].bcn_rsn_ie)
+				adapter->scan_table[del_idx].bcn_rsn_ie =
+					(struct ieee_types_generic *)
+					(adapter->scan_table[del_idx].
+					 beacon_buf +
+					 adapter->scan_table[del_idx].
+					 rsn_offset);
+			if (adapter->scan_table[del_idx].bcn_wapi_ie)
+				adapter->scan_table[del_idx].bcn_wapi_ie =
+					(struct ieee_types_generic *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					 wapi_offset);
+			if (adapter->scan_table[del_idx].bcn_ht_cap)
+				adapter->scan_table[del_idx].bcn_ht_cap =
+					(struct ieee80211_ht_cap *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					  ht_cap_offset);
+
+			if (adapter->scan_table[del_idx].bcn_ht_info)
+				adapter->scan_table[del_idx].bcn_ht_info =
+					(struct ieee80211_ht_info *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					  ht_info_offset);
+			if (adapter->scan_table[del_idx].bcn_bss_co_2040)
+				adapter->scan_table[del_idx].bcn_bss_co_2040 =
+					(u8 *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					   bss_co_2040_offset);
+			if (adapter->scan_table[del_idx].bcn_ext_cap)
+				adapter->scan_table[del_idx].bcn_ext_cap =
+					(u8 *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					     ext_cap_offset);
+			if (adapter->scan_table[del_idx].bcn_obss_scan)
+				adapter->scan_table[del_idx].
+					bcn_obss_scan =
+					(struct ieee_types_obss_scan_param *)
+					(adapter->scan_table[del_idx].beacon_buf
+					 + adapter->scan_table[del_idx].
+					     overlap_bss_offset);
+		}
+	}
+
+	/* The last entry is invalid now that it has been deleted or moved
+	   back */
+	memset(adapter->scan_table + adapter->num_in_scan_table - 1,
+	       0x00, sizeof(struct mwifiex_bssdescriptor));
+
+	adapter->num_in_scan_table--;
+}
+
+/*
+ * This function deletes all occurrences of a given SSID from the scan table.
+ *
+ * This iterates through the scan table and deletes all entries that match
+ * the given SSID. It also compacts the remaining scan table entries.
+ */
+static int
+mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
+				     struct mwifiex_802_11_ssid *del_ssid)
+{
+	int ret = -1;
+	s32 table_idx;
+
+	dev_dbg(priv->adapter->dev, "info: scan: delete ssid entry: %-32s\n",
+			del_ssid->ssid);
+
+	/* If the requested SSID is found in the table, delete it.  Then keep
+	   searching the table for multiple entires for the SSID until no
+	   more are found */
+	while ((table_idx = mwifiex_find_ssid_in_list(priv, del_ssid, NULL,
+						      MWIFIEX_BSS_MODE_AUTO)) >=
+	       0) {
+		dev_dbg(priv->adapter->dev,
+			"info: Scan: Delete SSID Entry: Found Idx = %d\n",
+		       table_idx);
+		ret = 0;
+		mwifiex_scan_delete_table_entry(priv, table_idx);
+	}
+
+	return ret;
+}
+
+/*
+ * This is an internal function used to start a scan based on an input
+ * configuration.
+ *
+ * This uses the input user scan configuration information when provided in
+ * order to send the appropriate scan commands to firmware to populate or
+ * update the internal driver scan table.
+ */
+int mwifiex_scan_networks(struct mwifiex_private *priv,
+			  void *wait_buf, u16 action,
+			  const struct mwifiex_user_scan_cfg *user_scan_in,
+			  struct mwifiex_scan_resp *scan_resp)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cmd_ctrl_node *cmd_node = NULL;
+	union mwifiex_scan_cmd_config_tlv *scan_cfg_out = NULL;
+	struct mwifiex_ie_types_chan_list_param_set *chan_list_out;
+	u32 buf_size;
+	struct mwifiex_chan_scan_param_set *scan_chan_list;
+	u8 keep_previous_scan;
+	u8 filtered_scan;
+	u8 scan_current_chan_only;
+	u8 max_chan_per_scan;
+	unsigned long flags;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (scan_resp) {
+			scan_resp->scan_table = (u8 *) adapter->scan_table;
+			scan_resp->num_in_scan_table =
+				adapter->num_in_scan_table;
+		} else {
+			ret = -1;
+		}
+		return ret;
+	}
+
+	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
+		return ret;
+	}
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->scan_processing = true;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+		dev_dbg(adapter->dev,
+			"cmd: Scan is blocked during association...\n");
+		return ret;
+	}
+
+	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
+					GFP_KERNEL);
+	if (!scan_cfg_out) {
+		dev_err(adapter->dev, "failed to alloc scan_cfg_out\n");
+		return -1;
+	}
+
+	buf_size = sizeof(struct mwifiex_chan_scan_param_set) *
+			MWIFIEX_USER_SCAN_CHAN_MAX;
+	scan_chan_list = kzalloc(buf_size, GFP_KERNEL);
+	if (!scan_chan_list) {
+		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
+		kfree(scan_cfg_out);
+		return -1;
+	}
+
+	keep_previous_scan = false;
+
+	mwifiex_scan_setup_scan_config(priv, user_scan_in,
+				       &scan_cfg_out->config, &chan_list_out,
+				       scan_chan_list, &max_chan_per_scan,
+				       &filtered_scan, &scan_current_chan_only);
+
+	if (user_scan_in)
+		keep_previous_scan = user_scan_in->keep_previous_scan;
+
+
+	if (!keep_previous_scan) {
+		memset(adapter->scan_table, 0x00,
+		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
+		adapter->num_in_scan_table = 0;
+		adapter->bcn_buf_end = adapter->bcn_buf;
+	}
+
+	ret = mwifiex_scan_channel_list(priv, wait_buf, max_chan_per_scan,
+					filtered_scan, &scan_cfg_out->config,
+					chan_list_out, scan_chan_list);
+
+	/* Get scan command from scan_pending_q and put to cmd_pending_q */
+	if (!ret) {
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		if (!list_empty(&adapter->scan_pending_q)) {
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+									flags);
+			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
+							true);
+		} else {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+		}
+		ret = -EINPROGRESS;
+	} else {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = true;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+	}
+
+	kfree(scan_cfg_out);
+	kfree(scan_chan_list);
+	return ret;
+}
+
+/*
+ * This function prepares a scan command to be sent to the firmware.
+ *
+ * This uses the scan command configuration sent to the command processing
+ * module in command preparation stage to configure a scan command structure
+ * to send to firmware.
+ *
+ * The fixed fields specifying the BSS type and BSSID filters as well as a
+ * variable number/length of TLVs are sent in the command to firmware.
+ *
+ * Preparation also includes -
+ *      - Setting command ID, and proper size
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd, void *data_buf)
+{
+	struct host_cmd_ds_802_11_scan *scan_cmd = &cmd->params.scan;
+	struct mwifiex_scan_cmd_config *scan_cfg;
+
+	scan_cfg = (struct mwifiex_scan_cmd_config *) data_buf;
+
+	/* Set fixed field variables in scan command */
+	scan_cmd->bss_mode = scan_cfg->bss_mode;
+	memcpy(scan_cmd->bssid, scan_cfg->specific_bssid,
+	       sizeof(scan_cmd->bssid));
+	memcpy(scan_cmd->tlv_buffer, scan_cfg->tlv_buf, scan_cfg->tlv_buf_len);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SCAN);
+
+	/* Size is equal to the sizeof(fixed portions) + the TLV len + header */
+	cmd->size = cpu_to_le16((u16) (sizeof(scan_cmd->bss_mode)
+					  + sizeof(scan_cmd->bssid)
+					  + scan_cfg->tlv_buf_len + S_DS_GEN));
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of scan.
+ *
+ * The response buffer for the scan command has the following
+ * memory layout:
+ *
+ *      .-------------------------------------------------------------.
+ *      |  Header (4 * sizeof(t_u16)):  Standard command response hdr |
+ *      .-------------------------------------------------------------.
+ *      |  BufSize (t_u16) : sizeof the BSS Description data          |
+ *      .-------------------------------------------------------------.
+ *      |  NumOfSet (t_u8) : Number of BSS Descs returned             |
+ *      .-------------------------------------------------------------.
+ *      |  BSSDescription data (variable, size given in BufSize)      |
+ *      .-------------------------------------------------------------.
+ *      |  TLV data (variable, size calculated using Header->Size,    |
+ *      |            BufSize and sizeof the fixed fields above)       |
+ *      .-------------------------------------------------------------.
+ */
+int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp, void *wq_buf)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_wait_queue *wait_queue = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL;
+	struct host_cmd_ds_802_11_scan_rsp *scan_rsp = NULL;
+	struct mwifiex_bssdescriptor *bss_new_entry = NULL;
+	struct mwifiex_ie_types_data *tlv_data;
+	struct mwifiex_ie_types_tsf_timestamp *tsf_tlv;
+	u8 *bss_info;
+	u32 scan_resp_size;
+	u32 bytes_left;
+	u32 num_in_table;
+	u32 bss_idx;
+	u32 idx;
+	u32 tlv_buf_size;
+	long long tsf_val;
+	struct mwifiex_chan_freq_power *cfp;
+	struct mwifiex_ie_types_chan_band_list_param_set *chan_band_tlv;
+	struct chan_band_param_set *chan_band;
+	u8 band;
+	u8 is_bgscan_resp;
+	unsigned long flags;
+
+	is_bgscan_resp = (le16_to_cpu(resp->command)
+		== HostCmd_CMD_802_11_BG_SCAN_QUERY);
+	if (is_bgscan_resp)
+		scan_rsp = &resp->params.bg_scan_query_resp.scan_resp;
+	else
+		scan_rsp = &resp->params.scan_resp;
+
+
+	if (scan_rsp->number_of_sets > IW_MAX_AP) {
+		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
+		       scan_rsp->number_of_sets);
+		ret = -1;
+		goto done;
+	}
+
+	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
+	dev_dbg(adapter->dev, "info: SCAN_RESP: bss_descript_size %d\n",
+						bytes_left);
+
+	scan_resp_size = le16_to_cpu(resp->size);
+
+	dev_dbg(adapter->dev,
+		"info: SCAN_RESP: returned %d APs before parsing\n",
+	       scan_rsp->number_of_sets);
+
+	num_in_table = adapter->num_in_scan_table;
+	bss_info = scan_rsp->bss_desc_and_tlv_buffer;
+
+	/*
+	 * The size of the TLV buffer is equal to the entire command response
+	 *   size (scan_resp_size) minus the fixed fields (sizeof()'s), the
+	 *   BSS Descriptions (bss_descript_size as bytesLef) and the command
+	 *   response header (S_DS_GEN)
+	 */
+	tlv_buf_size = scan_resp_size - (bytes_left
+					 + sizeof(scan_rsp->bss_descript_size)
+					 + sizeof(scan_rsp->number_of_sets)
+					 + S_DS_GEN);
+
+	tlv_data = (struct mwifiex_ie_types_data *) (scan_rsp->
+						 bss_desc_and_tlv_buffer +
+						 bytes_left);
+
+	/* Search the TLV buffer space in the scan response for any valid
+	   TLVs */
+	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter, tlv_data, tlv_buf_size,
+					     TLV_TYPE_TSFTIMESTAMP,
+					     (struct mwifiex_ie_types_data **)
+					     &tsf_tlv);
+
+	/* Search the TLV buffer space in the scan response for any valid
+	   TLVs */
+	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter, tlv_data, tlv_buf_size,
+					     TLV_TYPE_CHANNELBANDLIST,
+					     (struct mwifiex_ie_types_data **)
+					     &chan_band_tlv);
+
+	/*
+	 *  Process each scan response returned (scan_rsp->number_of_sets).
+	 *  Save the information in the bss_new_entry and then insert into the
+	 *  driver scan table either as an update to an existing entry
+	 *  or as an addition at the end of the table
+	 */
+	bss_new_entry = kzalloc(sizeof(struct mwifiex_bssdescriptor),
+				GFP_KERNEL);
+	if (!bss_new_entry) {
+		dev_err(adapter->dev, " failed to alloc bss_new_entry\n");
+		return -1;
+	}
+
+	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
+		/* Zero out the bss_new_entry we are about to store info in */
+		memset(bss_new_entry, 0x00,
+		       sizeof(struct mwifiex_bssdescriptor));
+
+		if (mwifiex_interpret_bss_desc_with_ie(adapter, bss_new_entry,
+							&bss_info,
+							&bytes_left)) {
+			/* Error parsing/interpreting scan response, skipped */
+			dev_err(adapter->dev, "SCAN_RESP: "
+			       "mwifiex_interpret_bss_desc_with_ie "
+			       "returned ERROR\n");
+			continue;
+		}
+
+		/* Process the data fields and IEs returned for this BSS */
+		dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
+		       bss_new_entry->mac_address);
+
+		/* Search the scan table for the same bssid */
+		for (bss_idx = 0; bss_idx < num_in_table; bss_idx++) {
+			if (memcmp(bss_new_entry->mac_address,
+				adapter->scan_table[bss_idx].mac_address,
+				sizeof(bss_new_entry->mac_address))) {
+				continue;
+			}
+			/*
+			 * If the SSID matches as well, it is a
+			 * duplicate of this entry.  Keep the bss_idx
+			 * set to this entry so we replace the old
+			 * contents in the table
+			 */
+			if ((bss_new_entry->ssid.ssid_len
+				== adapter->scan_table[bss_idx]. ssid.ssid_len)
+					&& (!memcmp(bss_new_entry->ssid.ssid,
+					adapter->scan_table[bss_idx].ssid.ssid,
+					bss_new_entry->ssid.ssid_len))) {
+				dev_dbg(adapter->dev, "info: SCAN_RESP:"
+					" duplicate of index: %d\n", bss_idx);
+				break;
+			}
+		}
+		/*
+		 * If the bss_idx is equal to the number of entries in
+		 * the table, the new entry was not a duplicate; append
+		 * it to the scan table
+		 */
+		if (bss_idx == num_in_table) {
+			/* Range check the bss_idx, keep it limited to
+			   the last entry */
+			if (bss_idx == IW_MAX_AP)
+				bss_idx--;
+			else
+				num_in_table++;
+		}
+
+		/*
+		 * Save the beacon/probe response returned for later application
+		 * retrieval.  Duplicate beacon/probe responses are updated if
+		 * possible
+		 */
+		mwifiex_ret_802_11_scan_store_beacon(priv, bss_idx,
+						num_in_table, bss_new_entry);
+		/*
+		 * If the TSF TLV was appended to the scan results, save this
+		 * entry's TSF value in the networkTSF field.The networkTSF is
+		 * the firmware's TSF value at the time the beacon or probe
+		 * response was received.
+		 */
+		if (tsf_tlv) {
+			memcpy(&tsf_val, &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE]
+					, sizeof(tsf_val));
+			memcpy(&bss_new_entry->network_tsf, &tsf_val,
+					sizeof(bss_new_entry->network_tsf));
+		}
+		band = BAND_G;
+		if (chan_band_tlv) {
+			chan_band = &chan_band_tlv->chan_band_param[idx];
+			band = mwifiex_radio_type_to_band(chan_band->radio_type
+					& (BIT(0) | BIT(1)));
+		}
+
+		/* Save the band designation for this entry for use in join */
+		bss_new_entry->bss_band = band;
+		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+					(u8) bss_new_entry->bss_band,
+					(u16)bss_new_entry->channel);
+
+		if (cfp)
+			bss_new_entry->freq = cfp->freq;
+		else
+			bss_new_entry->freq = 0;
+
+		/* Copy the locally created bss_new_entry to the scan table */
+		memcpy(&adapter->scan_table[bss_idx], bss_new_entry,
+		       sizeof(adapter->scan_table[bss_idx]));
+
+	}
+
+	dev_dbg(adapter->dev,
+		"info: SCAN_RESP: Scanned %2d APs, %d valid, %d total\n",
+	       scan_rsp->number_of_sets,
+	       num_in_table - adapter->num_in_scan_table, num_in_table);
+
+	/* Update the total number of BSSIDs in the scan table */
+	adapter->num_in_scan_table = num_in_table;
+
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	if (list_empty(&adapter->scan_pending_q)) {
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		/*
+		 * Process the resulting scan table:
+		 *   - Remove any bad ssids
+		 *   - Update our current BSS information from scan data
+		 */
+		mwifiex_process_scan_results(priv);
+
+		/* Need to indicate IOCTL complete */
+		wait_queue = (struct mwifiex_wait_queue *) wq_buf;
+		if (wait_queue) {
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+
+			/* Indicate ioctl complete */
+			mwifiex_ioctl_complete(adapter,
+			       (struct mwifiex_wait_queue *) wait_queue, 0);
+		}
+		if (priv->report_scan_result)
+			priv->report_scan_result = false;
+		if (priv->scan_pending_on_block) {
+			priv->scan_pending_on_block = false;
+			up(&priv->async_sem);
+		}
+
+	} else {
+		/* Get scan command from scan_pending_q and put to
+		   cmd_pending_q */
+		cmd_node = list_first_entry(&adapter->scan_pending_q,
+					    struct cmd_ctrl_node, list);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+	}
+
+done:
+	kfree((u8 *) bss_new_entry);
+	return ret;
+}
+
+/*
+ * This function prepares command for background scan query.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting background scan flush parameter
+ *      - Ensuring correct endian-ness
+ */
+int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     void *data_buf)
+{
+	struct host_cmd_ds_802_11_bg_scan_query *bg_query =
+		&cmd->params.bg_scan_query;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_BG_SCAN_QUERY);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_bg_scan_query)
+				+ S_DS_GEN);
+
+	bg_query->flush = 1;
+
+	return 0;
+}
+
+/*
+ * This function finds a SSID in the scan table.
+ *
+ * A BSSID may optionally be provided to qualify the SSID.
+ * For non-Auto mode, further check is made to make sure the
+ * BSS found in the scan table is compatible with the current
+ * settings of the driver.
+ */
+s32
+mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
+			  struct mwifiex_802_11_ssid *ssid, u8 *bssid,
+			  u32 mode)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	s32 net = -1, j;
+	u8 best_rssi = 0;
+	u32 i;
+
+	dev_dbg(adapter->dev, "info: num of entries in table = %d\n",
+	       adapter->num_in_scan_table);
+
+	/*
+	 * Loop through the table until the maximum is reached or until a match
+	 *   is found based on the bssid field comparison
+	 */
+	for (i = 0;
+	     i < adapter->num_in_scan_table && (!bssid || (bssid && net < 0));
+	     i++) {
+		if (!mwifiex_ssid_cmp(&adapter->scan_table[i].ssid, ssid) &&
+		    (!bssid
+		     || !memcmp(adapter->scan_table[i].mac_address, bssid,
+				ETH_ALEN))
+		    &&
+		    (mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+		     (priv, (u8) adapter->scan_table[i].bss_band,
+		      (u16) adapter->scan_table[i].channel))) {
+			switch (mode) {
+			case MWIFIEX_BSS_MODE_INFRA:
+			case MWIFIEX_BSS_MODE_IBSS:
+				j = mwifiex_is_network_compatible(priv, i,
+								  mode);
+
+				if (j >= 0) {
+					if (SCAN_RSSI
+					    (adapter->scan_table[i].rssi) >
+					    best_rssi) {
+						best_rssi = SCAN_RSSI(adapter->
+								  scan_table
+								  [i].rssi);
+						net = i;
+					}
+				} else {
+					if (net == -1)
+						net = j;
+				}
+				break;
+			case MWIFIEX_BSS_MODE_AUTO:
+			default:
+				/*
+				 * Do not check compatibility if the mode
+				 * requested is Auto/Unknown.  Allows generic
+				 * find to work without verifying against the
+				 * Adapter security settings
+				 */
+				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
+				    best_rssi) {
+					best_rssi = SCAN_RSSI(adapter->
+							  scan_table[i].rssi);
+					net = i;
+				}
+				break;
+			}
+		}
+	}
+
+	return net;
+}
+
+/*
+ * This function finds a specific compatible BSSID in the scan list.
+ *
+ * This function loops through the scan table looking for a compatible
+ * match. If a BSSID matches, but the BSS is found to be not compatible
+ * the function ignores it and continues to search through the rest of
+ * the entries in case there is an AP with multiple SSIDs assigned to
+ * the same BSSID.
+ */
+s32
+mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
+			   u32 mode)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	s32 net = -1;
+	u32 i;
+
+	if (!bssid)
+		return -1;
+
+	dev_dbg(adapter->dev, "info: FindBSSID: Num of BSSIDs = %d\n",
+	       adapter->num_in_scan_table);
+
+	/*
+	 * Look through the scan table for a compatible match. The ret return
+	 *   variable will be equal to the index in the scan table (greater
+	 *   than zero) if the network is compatible.  The loop will continue
+	 *   past a matched bssid that is not compatible in case there is an
+	 *   AP with multiple SSIDs assigned to the same BSSID
+	 */
+	for (i = 0; net < 0 && i < adapter->num_in_scan_table; i++) {
+		if (!memcmp
+		    (adapter->scan_table[i].mac_address, bssid, ETH_ALEN)
+			&& mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+								(priv,
+							    (u8) adapter->
+							    scan_table[i].
+							    bss_band,
+							    (u16) adapter->
+							    scan_table[i].
+							    channel)) {
+			switch (mode) {
+			case MWIFIEX_BSS_MODE_INFRA:
+			case MWIFIEX_BSS_MODE_IBSS:
+				net = mwifiex_is_network_compatible(priv, i,
+								    mode);
+				break;
+			default:
+				net = i;
+				break;
+			}
+		}
+	}
+
+	return net;
+}
+
+/*
+ * This function inserts scan command node to the scan pending queue.
+ */
+void
+mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
+		       struct cmd_ctrl_node *cmd_node)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+}
+
+/*
+ * This function finds an AP with specific ssid in the scan list.
+ */
+int mwifiex_find_best_network(struct mwifiex_private *priv,
+			      struct mwifiex_ssid_bssid *req_ssid_bssid)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bssdescriptor *req_bss;
+	s32 i;
+
+	memset(req_ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
+
+	i = mwifiex_find_best_network_in_list(priv);
+
+	if (i >= 0) {
+		req_bss = &adapter->scan_table[i];
+		memcpy(&req_ssid_bssid->ssid, &req_bss->ssid,
+		       sizeof(struct mwifiex_802_11_ssid));
+		memcpy((u8 *) &req_ssid_bssid->bssid,
+		       (u8 *) &req_bss->mac_address, ETH_ALEN);
+
+		/* Make sure we are in the right mode */
+		if (priv->bss_mode == MWIFIEX_BSS_MODE_AUTO)
+			priv->bss_mode = req_bss->bss_mode;
+	}
+
+	if (!req_ssid_bssid->ssid.ssid_len)
+		return -1;
+
+	dev_dbg(adapter->dev, "info: Best network found = [%s], "
+	       "[%pM]\n", req_ssid_bssid->ssid.ssid,
+	       req_ssid_bssid->bssid);
+
+	return 0;
+}
+
+/*
+ * This function sends a scan command for all available channels to the
+ * firmware, filtered on a specific SSID.
+ */
+static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
+				      void *wait_buf, u16 action,
+				      struct mwifiex_802_11_ssid *req_ssid,
+				      struct mwifiex_scan_resp *scan_resp)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = 0;
+	struct mwifiex_user_scan_cfg *scan_cfg;
+
+	if (!req_ssid)
+		return -1;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (scan_resp) {
+			scan_resp->scan_table =
+				(u8 *) &priv->curr_bss_params.bss_descriptor;
+			scan_resp->num_in_scan_table =
+				adapter->num_in_scan_table;
+		} else {
+			ret = -1;
+		}
+		return ret;
+	}
+
+	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
+		return ret;
+	}
+
+	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+		dev_dbg(adapter->dev,
+			"cmd: Scan is blocked during association...\n");
+		return ret;
+	}
+
+	mwifiex_scan_delete_ssid_table_entry(priv, req_ssid);
+
+	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
+	if (!scan_cfg) {
+		dev_err(adapter->dev, "failed to alloc scan_cfg\n");
+		return -1;
+	}
+
+	memcpy(scan_cfg->ssid_list[0].ssid, req_ssid->ssid,
+	       req_ssid->ssid_len);
+	scan_cfg->keep_previous_scan = true;
+
+	ret = mwifiex_scan_networks(priv, wait_buf, action, scan_cfg, NULL);
+
+	kfree(scan_cfg);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to start a scan.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ *
+ * Scan command can be issued for both normal scan and specific SSID
+ * scan, depending upon whether an SSID is provided or not.
+ */
+int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
+			 struct mwifiex_802_11_ssid *req_ssid)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	if (down_interruptible(&priv->async_sem)) {
+		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
+						__func__);
+		return -1;
+	}
+	priv->scan_pending_on_block = true;
+
+	/* Allocate wait request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
+		ret = -1;
+		goto done;
+	}
+
+	if (req_ssid && req_ssid->ssid_len != 0)
+		/* Specific SSID scan */
+		status = mwifiex_scan_specific_ssid(priv, wait,
+						    HostCmd_ACT_GEN_SET,
+						    req_ssid, NULL);
+	else
+		/* Normal scan */
+		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
+					       NULL, NULL);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (status == -1)
+		ret = -1;
+done:
+	if ((wait) && (status != -EINPROGRESS))
+		kfree(wait);
+	if (ret == -1) {
+		priv->scan_pending_on_block = false;
+		up(&priv->async_sem);
+	}
+	return ret;
+}
+
+/*
+ * This function appends the vendor specific IE TLV to a buffer.
+ */
+int
+mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
+			    u16 vsie_mask, u8 **buffer)
+{
+	int id, ret_len = 0;
+	struct mwifiex_ie_types_vendor_param_set *vs_param_set;
+
+	if (!buffer)
+		return 0;
+	if (!(*buffer))
+		return 0;
+
+	/*
+	 * Traverse through the saved vendor specific IE array and append
+	 * the selected(scan/assoc/adhoc) IE as TLV to the command
+	 */
+	for (id = 0; id < MWIFIEX_MAX_VSIE_NUM; id++) {
+		if (priv->vs_ie[id].mask & vsie_mask) {
+			vs_param_set =
+				(struct mwifiex_ie_types_vendor_param_set *)
+				*buffer;
+			vs_param_set->header.type =
+				cpu_to_le16(TLV_TYPE_PASSTHROUGH);
+			vs_param_set->header.len =
+				cpu_to_le16((((u16) priv->vs_ie[id].ie[1])
+				& 0x00FF) + 2);
+			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
+			       le16_to_cpu(vs_param_set->header.len));
+			*buffer += le16_to_cpu(vs_param_set->header.len) +
+				   sizeof(struct mwifiex_ie_types_header);
+			ret_len += le16_to_cpu(vs_param_set->header.len) +
+				   sizeof(struct mwifiex_ie_types_header);
+		}
+	}
+	return ret_len;
+}
+
+/*
+ * This function saves a beacon buffer of the current BSS descriptor.
+ *
+ * The current beacon buffer is saved so that it can be restored in the
+ * following cases that makes the beacon buffer not to contain the current
+ * ssid's beacon buffer.
+ *      - The current ssid was not found somehow in the last scan.
+ *      - The current ssid was the last entry of the scan table and overloaded.
+ */
+void
+mwifiex_save_curr_bcn(struct mwifiex_private *priv)
+{
+	struct mwifiex_bssdescriptor *curr_bss =
+		&priv->curr_bss_params.bss_descriptor;
+
+	/* save the beacon buffer if it is not saved or updated */
+	if ((priv->curr_bcn_buf == NULL) ||
+	    (priv->curr_bcn_size != curr_bss->beacon_buf_size) ||
+	    (memcmp(priv->curr_bcn_buf, curr_bss->beacon_buf,
+		    curr_bss->beacon_buf_size))) {
+
+		kfree(priv->curr_bcn_buf);
+		priv->curr_bcn_buf = NULL;
+
+		priv->curr_bcn_size = curr_bss->beacon_buf_size;
+		if (!priv->curr_bcn_size)
+			return;
+
+		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
+						GFP_KERNEL);
+		if (!priv->curr_bcn_buf) {
+			dev_err(priv->adapter->dev,
+					"failed to alloc curr_bcn_buf\n");
+		} else {
+			memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
+			       curr_bss->beacon_buf_size);
+			dev_dbg(priv->adapter->dev,
+				"info: current beacon saved %d\n",
+			       priv->curr_bcn_size);
+		}
+	}
+}
+
+/*
+ * This function frees the current BSS descriptor beacon buffer.
+ */
+void
+mwifiex_free_curr_bcn(struct mwifiex_private *priv)
+{
+	kfree(priv->curr_bcn_buf);
+	priv->curr_bcn_buf = NULL;
+}
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
new file mode 100644
index 0000000..f21e5cd
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -0,0 +1,1770 @@
+/*
+ * Marvell Wireless LAN device driver: SDIO specific handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include <linux/firmware.h>
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+#include "sdio.h"
+
+
+#define SDIO_VERSION	"1.0"
+
+static struct mwifiex_if_ops sdio_ops;
+
+static struct semaphore add_remove_card_sem;
+
+/*
+ * SDIO probe.
+ *
+ * This function probes an mwifiex device and registers it. It allocates
+ * the card structure, enables SDIO function number and initiates the
+ * device registration and initialization procedure by adding a logical
+ * interface.
+ */
+static int
+mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+{
+	int ret = 0;
+	struct sdio_mmc_card *card = NULL;
+
+	pr_debug("info: vendor=0x%4.04X device=0x%4.04X class=%d function=%d\n",
+	       func->vendor, func->device, func->class, func->num);
+
+	card = kzalloc(sizeof(struct sdio_mmc_card), GFP_KERNEL);
+	if (!card) {
+		pr_err("%s: failed to alloc memory\n", __func__);
+		return -ENOMEM;
+	}
+
+	card->func = func;
+
+	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
+
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	sdio_release_host(func);
+
+	if (ret) {
+		pr_err("%s: failed to enable function\n", __func__);
+		return -EIO;
+	}
+
+	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops)) {
+		pr_err("%s: add card failed\n", __func__);
+		kfree(card);
+		sdio_claim_host(func);
+		ret = sdio_disable_func(func);
+		sdio_release_host(func);
+		ret = -1;
+	}
+
+	return ret;
+}
+
+/*
+ * SDIO remove.
+ *
+ * This function removes the interface and frees up the card structure.
+ */
+static void
+mwifiex_sdio_remove(struct sdio_func *func)
+{
+	struct sdio_mmc_card *card;
+
+	pr_debug("info: SDIO func num=%d\n", func->num);
+
+	if (func) {
+		card = sdio_get_drvdata(func);
+		if (card) {
+			mwifiex_remove_card(card->adapter,
+					&add_remove_card_sem);
+			kfree(card);
+		}
+	}
+}
+
+/*
+ * SDIO suspend.
+ *
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not suspended, this function allocates and sends a host
+ * sleep activate request to the firmware and turns off the traffic.
+ */
+static int mwifiex_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct sdio_mmc_card *card;
+	struct mwifiex_adapter *adapter = NULL;
+	mmc_pm_flag_t pm_flag = 0;
+	int hs_actived = 0;
+	int i;
+	int ret = 0;
+
+	if (func) {
+		pm_flag = sdio_get_host_pm_caps(func);
+		pr_debug("cmd: %s: suspend: PM flag = 0x%x\n",
+		       sdio_func_id(func), pm_flag);
+		if (!(pm_flag & MMC_PM_KEEP_POWER)) {
+			pr_err("%s: cannot remain alive while host is"
+				" suspended\n", sdio_func_id(func));
+			return -ENOSYS;
+		}
+
+		card = sdio_get_drvdata(func);
+		if (!card || !card->adapter) {
+			pr_err("suspend: invalid card or adapter\n");
+			return 0;
+		}
+	} else {
+		pr_err("suspend: sdio_func is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	/* Enable the Host Sleep */
+	hs_actived = mwifiex_enable_hs(adapter);
+	if (hs_actived) {
+		pr_debug("cmd: suspend with MMC_PM_KEEP_POWER\n");
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	}
+
+	/* Indicate device suspended */
+	adapter->is_suspended = true;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		netif_carrier_off(adapter->priv[i]->netdev);
+
+	return ret;
+}
+
+/*
+ * SDIO resume.
+ *
+ * Kernel needs to suspend all functions separately. Therefore all
+ * registered functions must have drivers with suspend and resume
+ * methods. Failing that the kernel simply removes the whole card.
+ *
+ * If already not resumed, this function turns on the traffic and
+ * sends a host sleep cancel request to the firmware.
+ */
+static int mwifiex_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct sdio_mmc_card *card;
+	struct mwifiex_adapter *adapter = NULL;
+	mmc_pm_flag_t pm_flag = 0;
+	int i;
+
+	if (func) {
+		pm_flag = sdio_get_host_pm_caps(func);
+		card = sdio_get_drvdata(func);
+		if (!card || !card->adapter) {
+			pr_err("resume: invalid card or adapter\n");
+			return 0;
+		}
+	} else {
+		pr_err("resume: sdio_func is not specified\n");
+		return 0;
+	}
+
+	adapter = card->adapter;
+
+	if (!adapter->is_suspended) {
+		dev_warn(adapter->dev, "device already resumed\n");
+		return 0;
+	}
+
+	adapter->is_suspended = false;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i]->media_connected)
+			netif_carrier_on(adapter->priv[i]->netdev);
+
+	/* Disable Host Sleep */
+	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
+			      MWIFIEX_NO_WAIT);
+
+	return 0;
+}
+
+/* Device ID for SD8787 */
+#define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
+
+/* WLAN IDs */
+static const struct sdio_device_id mwifiex_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8787)},
+	{},
+};
+
+MODULE_DEVICE_TABLE(sdio, mwifiex_ids);
+
+static const struct dev_pm_ops mwifiex_sdio_pm_ops = {
+	.suspend = mwifiex_sdio_suspend,
+	.resume = mwifiex_sdio_resume,
+};
+
+static struct sdio_driver mwifiex_sdio = {
+	.name = "mwifiex_sdio",
+	.id_table = mwifiex_ids,
+	.probe = mwifiex_sdio_probe,
+	.remove = mwifiex_sdio_remove,
+	.drv = {
+		.owner = THIS_MODULE,
+		.pm = &mwifiex_sdio_pm_ops,
+	}
+};
+
+/*
+ * This function writes data into SDIO card register.
+ */
+static int
+mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u32 data)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = -1;
+
+	sdio_claim_host(card->func);
+	sdio_writeb(card->func, (u8) data, reg, &ret);
+	sdio_release_host(card->func);
+
+	return ret;
+}
+
+/*
+ * This function reads data from SDIO card register.
+ */
+static int
+mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = -1;
+	u8 val;
+
+	sdio_claim_host(card->func);
+	val = sdio_readb(card->func, reg, &ret);
+	sdio_release_host(card->func);
+
+	*data = val;
+
+	return ret;
+}
+
+/*
+ * This function writes multiple data into SDIO card memory.
+ *
+ * This does not work in suspended mode.
+ */
+static int
+mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
+			u8 *buffer, u32 pkt_len, u32 port, u32 timeout)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = -1;
+	u8 blk_mode =
+		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
+	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
+	u32 blk_cnt =
+		(blk_mode ==
+		 BLOCK_MODE) ? (pkt_len /
+				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
+	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
+
+	if (adapter->is_suspended) {
+		dev_err(adapter->dev,
+			"%s: not allowed while suspended\n", __func__);
+		return -1;
+	}
+
+	sdio_claim_host(card->func);
+
+	if (!sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size))
+		ret = 0;
+
+	sdio_release_host(card->func);
+
+	return ret;
+}
+
+/*
+ * This function reads multiple data from SDIO card memory.
+ */
+static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
+				  u8 *buffer, u32 len,
+		       u32 port, u32 timeout, u8 claim)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = -1;
+	u8 blk_mode =
+		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
+	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
+	u32 blk_cnt =
+		(blk_mode ==
+		 BLOCK_MODE) ? (len / MWIFIEX_SDIO_BLOCK_SIZE) : len;
+	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
+
+	if (claim)
+		sdio_claim_host(card->func);
+
+	if (!sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size))
+		ret = 0;
+
+	if (claim)
+		sdio_release_host(card->func);
+
+	return ret;
+}
+
+/*
+ * This function wakes up the card.
+ *
+ * A host power up command is written to the card configuration
+ * register to wake up the card.
+ */
+static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+{
+	int ret;
+
+	dev_dbg(adapter->dev, "event: wakeup device...\n");
+	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, HOST_POWER_UP);
+
+	return ret;
+}
+
+/*
+ * This function is called after the card has woken up.
+ *
+ * The card configuration register is reset.
+ */
+static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
+{
+	int ret;
+
+	dev_dbg(adapter->dev, "cmd: wakeup device completed\n");
+	ret = mwifiex_write_reg(adapter, CONFIGURATION_REG, 0);
+
+	return ret;
+}
+
+/*
+ * This function initializes the IO ports.
+ *
+ * The following operations are performed -
+ *      - Read the IO ports (0, 1 and 2)
+ *      - Set host interrupt Reset-To-Read to clear
+ *      - Set auto re-enable interrupt
+ */
+static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
+{
+	u32 reg;
+
+	adapter->ioport = 0;
+
+	/* Read the IO port */
+	if (!mwifiex_read_reg(adapter, IO_PORT_0_REG, &reg))
+		adapter->ioport |= (reg & 0xff);
+	else
+		return -1;
+
+	if (!mwifiex_read_reg(adapter, IO_PORT_1_REG, &reg))
+		adapter->ioport |= ((reg & 0xff) << 8);
+	else
+		return -1;
+
+	if (!mwifiex_read_reg(adapter, IO_PORT_2_REG, &reg))
+		adapter->ioport |= ((reg & 0xff) << 16);
+	else
+		return -1;
+
+	pr_debug("info: SDIO FUNC1 IO port: %#x\n", adapter->ioport);
+
+	/* Set Host interrupt reset to read to clear */
+	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg))
+		mwifiex_write_reg(adapter, HOST_INT_RSR_REG,
+				  reg | SDIO_INT_MASK);
+	else
+		return -1;
+
+	/* Dnld/Upld ready set to auto reset */
+	if (!mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg))
+		mwifiex_write_reg(adapter, CARD_MISC_CFG_REG,
+				  reg | AUTO_RE_ENABLE_INT);
+	else
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This function sends data to the card.
+ */
+static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
+				      u8 *payload, u32 pkt_len, u32 port)
+{
+	u32 i = 0;
+	int ret = 0;
+
+	do {
+		ret = mwifiex_write_data_sync(adapter, payload, pkt_len,
+								port, 0);
+		if (ret) {
+			i++;
+			dev_err(adapter->dev, "host_to_card, write iomem"
+					" (%d) failed: %d\n", i, ret);
+			if (mwifiex_write_reg(adapter,
+					CONFIGURATION_REG, 0x04))
+				dev_err(adapter->dev, "write CFG reg failed\n");
+
+			ret = -1;
+			if (i > MAX_WRITE_IOMEM_RETRY)
+				return ret;
+		}
+	} while (ret == -1);
+
+	return ret;
+}
+
+/*
+ * This function gets the read port.
+ *
+ * If control port bit is set in MP read bitmap, the control port
+ * is returned, otherwise the current read port is returned and
+ * the value is increased (provided it does not reach the maximum
+ * limit, in which case it is reset to 1)
+ */
+static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	u16 rd_bitmap = card->mp_rd_bitmap;
+
+	dev_dbg(adapter->dev, "data: mp_rd_bitmap=0x%04x\n", rd_bitmap);
+
+	if (!(rd_bitmap & (CTRL_PORT_MASK | DATA_PORT_MASK)))
+		return -1;
+
+	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
+		card->mp_rd_bitmap &= (u16) (~CTRL_PORT_MASK);
+		*port = CTRL_PORT;
+		dev_dbg(adapter->dev, "data: port=%d mp_rd_bitmap=0x%04x\n",
+		       *port, card->mp_rd_bitmap);
+	} else {
+		if (card->mp_rd_bitmap & (1 << card->curr_rd_port)) {
+			card->mp_rd_bitmap &=
+				(u16) (~(1 << card->curr_rd_port));
+			*port = card->curr_rd_port;
+
+			if (++card->curr_rd_port == MAX_PORT)
+				card->curr_rd_port = 1;
+		} else {
+			return -1;
+		}
+
+		dev_dbg(adapter->dev,
+			"data: port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
+		       *port, rd_bitmap, card->mp_rd_bitmap);
+	}
+	return 0;
+}
+
+/*
+ * This function gets the write port for data.
+ *
+ * The current write port is returned if available and the value is
+ * increased (provided it does not reach the maximum limit, in which
+ * case it is reset to 1)
+ */
+static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	u16 wr_bitmap = card->mp_wr_bitmap;
+
+	dev_dbg(adapter->dev, "data: mp_wr_bitmap=0x%04x\n", wr_bitmap);
+
+	if (!(wr_bitmap & card->mp_data_port_mask))
+		return -1;
+
+	if (card->mp_wr_bitmap & (1 << card->curr_wr_port)) {
+		card->mp_wr_bitmap &= (u16) (~(1 << card->curr_wr_port));
+		*port = card->curr_wr_port;
+		if (++card->curr_wr_port == card->mp_end_port)
+			card->curr_wr_port = 1;
+	} else {
+		adapter->data_sent = true;
+		return -EBUSY;
+	}
+
+	if (*port == CTRL_PORT) {
+		dev_err(adapter->dev, "invalid data port=%d cur port=%d"
+				" mp_wr_bitmap=0x%04x -> 0x%04x\n",
+				*port, card->curr_wr_port, wr_bitmap,
+				card->mp_wr_bitmap);
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "data: port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
+	       *port, wr_bitmap, card->mp_wr_bitmap);
+
+	return 0;
+}
+
+/*
+ * This function polls the card status.
+ */
+static int
+mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
+{
+	u32 tries;
+	u32 cs = 0;
+
+	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+		if (mwifiex_read_reg(adapter, CARD_STATUS_REG, &cs))
+			break;
+		else if ((cs & bits) == bits)
+			return 0;
+
+		udelay(10);
+	}
+
+	dev_err(adapter->dev, "poll card status failed, tries = %d\n",
+	       tries);
+	return -1;
+}
+
+/*
+ * This function reads the firmware status.
+ */
+static int
+mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
+{
+	u32 fws0 = 0, fws1 = 0;
+
+	if (mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
+		return -1;
+
+	if (mwifiex_read_reg(adapter, CARD_FW_STATUS1_REG, &fws1))
+		return -1;
+
+	*dat = (u16) ((fws1 << 8) | fws0);
+
+	return 0;
+}
+
+/*
+ * This function disables the host interrupt.
+ *
+ * The host interrupt mask is read, the disable bit is reset and
+ * written back to the card host interrupt mask register.
+ */
+static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
+{
+	u32 host_int_mask = 0;
+
+	/* Read back the host_int_mask register */
+	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask))
+		return -1;
+
+	/* Update with the mask and write back to the register */
+	host_int_mask &= ~HOST_INT_DISABLE;
+
+	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
+		dev_err(adapter->dev, "disable host interrupt failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function enables the host interrupt.
+ *
+ * The host interrupt enable mask is written to the card
+ * host interrupt mask register.
+ */
+static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
+{
+	/* Simply write the mask to the register */
+	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
+		dev_err(adapter->dev, "enable host interrupt failed\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * This function sends a data buffer to the card.
+ */
+static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
+				     u32 *type, u8 *buffer,
+				     u32 npayload, u32 ioport)
+{
+	int ret = 0;
+	u32 nb;
+
+	if (!buffer) {
+		dev_err(adapter->dev, "%s: buffer is NULL\n", __func__);
+		return -1;
+	}
+
+	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
+
+	if (ret) {
+		dev_err(adapter->dev, "%s: read iomem failed: %d\n", __func__,
+				ret);
+		return -1;
+	}
+
+	nb = le16_to_cpu(*(__le16 *) (buffer));
+	if (nb > npayload) {
+		dev_err(adapter->dev, "%s: invalid packet, nb=%d, npayload=%d\n",
+				__func__, nb, npayload);
+		return -1;
+	}
+
+	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
+
+	return ret;
+}
+
+/*
+ * This function downloads the firmware to the card.
+ *
+ * Firmware is downloaded to the card in blocks. Every block download
+ * is tested for CRC errors, and retried a number of times before
+ * returning failure.
+ */
+static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
+				    struct mwifiex_fw_image *fw)
+{
+	int ret = 0;
+	u8 *firmware = fw->fw_buf;
+	u32 firmware_len = fw->fw_len;
+	u32 offset = 0;
+	u32 base0, base1;
+	u8 *fwbuf;
+	u16 len = 0;
+	u32 txlen = 0, tx_blocks = 0, tries = 0;
+	u32 i = 0;
+
+	if (!firmware_len) {
+		dev_err(adapter->dev, "firmware image not found!"
+				" Terminating download\n");
+		return -1;
+	}
+
+	dev_dbg(adapter->dev, "info: downloading FW image (%d bytes)\n",
+			firmware_len);
+
+	/* Assume that the allocated buffer is 8-byte aligned */
+	fwbuf = kzalloc(MWIFIEX_UPLD_SIZE, GFP_KERNEL);
+	if (!fwbuf) {
+		dev_err(adapter->dev, "unable to alloc buffer for firmware."
+				" Terminating download\n");
+		return -1;
+	}
+
+	/* Perform firmware data transfer */
+	do {
+		/* The host polls for the DN_LD_CARD_RDY and CARD_IO_READY
+		   bits */
+		ret = mwifiex_sdio_poll_card_status(adapter, CARD_IO_READY |
+						    DN_LD_CARD_RDY);
+		if (ret) {
+			dev_err(adapter->dev, "FW download with helper:"
+					" poll status timeout @ %d\n", offset);
+			goto done;
+		}
+
+		/* More data? */
+		if (offset >= firmware_len)
+			break;
+
+		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_0,
+					       &base0);
+			if (ret) {
+				dev_err(adapter->dev, "dev BASE0 register read"
+					" failed: base0=0x%04X(%d). Terminating "
+				       "download\n", base0, base0);
+				goto done;
+			}
+			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_1,
+					       &base1);
+			if (ret) {
+				dev_err(adapter->dev, "dev BASE1 register read"
+					" failed: base1=0x%04X(%d). Terminating "
+				       "download\n", base1, base1);
+				goto done;
+			}
+			len = (u16) (((base1 & 0xff) << 8) | (base0 & 0xff));
+
+			if (len)
+				break;
+
+			udelay(10);
+		}
+
+		if (!len) {
+			break;
+		} else if (len > MWIFIEX_UPLD_SIZE) {
+			dev_err(adapter->dev, "FW download failed @ %d,"
+				" invalid length %d\n", offset, len);
+			ret = -1;
+			goto done;
+		}
+
+		txlen = len;
+
+		if (len & BIT(0)) {
+			i++;
+			if (i > MAX_WRITE_IOMEM_RETRY) {
+				dev_err(adapter->dev, "FW download failed @"
+					" %d, over max retry count\n", offset);
+				ret = -1;
+				goto done;
+			}
+			dev_err(adapter->dev, "CRC indicated by the helper:"
+			       " len = 0x%04X, txlen = %d\n", len, txlen);
+			len &= ~BIT(0);
+			/* Setting this to 0 to resend from same offset */
+			txlen = 0;
+		} else {
+			i = 0;
+
+			/* Set blocksize to transfer - checking for last
+			   block */
+			if (firmware_len - offset < txlen)
+				txlen = firmware_len - offset;
+
+			tx_blocks = (txlen + MWIFIEX_SDIO_BLOCK_SIZE -
+					1) / MWIFIEX_SDIO_BLOCK_SIZE;
+
+			/* Copy payload to buffer */
+			memmove(fwbuf, &firmware[offset], txlen);
+		}
+
+		ret = mwifiex_write_data_sync(adapter, fwbuf, tx_blocks *
+					      MWIFIEX_SDIO_BLOCK_SIZE,
+					      adapter->ioport, 0);
+		if (ret) {
+			dev_err(adapter->dev, "FW download, write iomem (%d)"
+					" failed @ %d\n", i, offset);
+			if (mwifiex_write_reg(adapter, CONFIGURATION_REG, 0x04))
+				dev_err(adapter->dev, "write CFG reg failed\n");
+
+			ret = -1;
+			goto done;
+		}
+
+		offset += txlen;
+	} while (true);
+
+	dev_dbg(adapter->dev, "info: FW download over, size %d bytes\n",
+						offset);
+
+	ret = 0;
+done:
+	kfree(fwbuf);
+	return ret;
+}
+
+/*
+ * This function checks the firmware status in card.
+ *
+ * The winner interface is also determined by this function.
+ */
+static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
+				   u32 poll_num, int *winner)
+{
+	int ret = 0;
+	u16 firmware_stat;
+	u32 tries;
+	u32 winner_status;
+
+	/* Wait for firmware initialization event */
+	for (tries = 0; tries < poll_num; tries++) {
+		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
+		if (ret)
+			continue;
+		if (firmware_stat == FIRMWARE_READY) {
+			ret = 0;
+			break;
+		} else {
+			mdelay(100);
+			ret = -1;
+		}
+	}
+
+	if (winner && ret) {
+		if (mwifiex_read_reg
+		    (adapter, CARD_FW_STATUS0_REG, &winner_status))
+			winner_status = 0;
+
+		if (winner_status)
+			*winner = 0;
+		else
+			*winner = 1;
+	}
+	return ret;
+}
+
+/*
+ * This function reads the interrupt status from card.
+ */
+static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	u32 sdio_ireg = 0;
+	unsigned long flags;
+
+	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
+				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
+				   0)) {
+		dev_err(adapter->dev, "read mp_regs failed\n");
+		return;
+	}
+
+	sdio_ireg = card->mp_regs[HOST_INTSTATUS_REG];
+	if (sdio_ireg) {
+		/*
+		 * DN_LD_HOST_INT_STATUS and/or UP_LD_HOST_INT_STATUS
+		 * Clear the interrupt status register
+		 */
+		dev_dbg(adapter->dev, "int: sdio_ireg = %#x\n", sdio_ireg);
+		spin_lock_irqsave(&adapter->int_lock, flags);
+		adapter->int_status |= sdio_ireg;
+		spin_unlock_irqrestore(&adapter->int_lock, flags);
+	}
+
+	return;
+}
+
+/*
+ * SDIO interrupt handler.
+ *
+ * This function reads the interrupt status from firmware and assigns
+ * the main process in workqueue which will handle the interrupt.
+ */
+static void
+mwifiex_sdio_interrupt(struct sdio_func *func)
+{
+	struct mwifiex_adapter *adapter;
+	struct sdio_mmc_card *card;
+
+	card = sdio_get_drvdata(func);
+	if (!card || !card->adapter) {
+		pr_debug("int: func=%p card=%p adapter=%p\n",
+		       func, card, card ? card->adapter : NULL);
+		return;
+	}
+	adapter = card->adapter;
+
+	if (adapter->surprise_removed)
+		return;
+
+	if (!adapter->pps_uapsd_mode && adapter->ps_state == PS_STATE_SLEEP)
+		adapter->ps_state = PS_STATE_AWAKE;
+
+	mwifiex_interrupt_status(adapter);
+	queue_work(adapter->workqueue, &adapter->main_work);
+
+	return;
+}
+
+/*
+ * This function decodes a received packet.
+ *
+ * Based on the type, the packet is treated as either a data, or
+ * a command response, or an event, and the correct handler
+ * function is invoked.
+ */
+static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
+				    struct sk_buff *skb, u32 upld_typ)
+{
+	u8 *cmd_buf;
+
+	skb_pull(skb, INTF_HEADER_LEN);
+
+	switch (upld_typ) {
+	case MWIFIEX_TYPE_DATA:
+		dev_dbg(adapter->dev, "info: --- Rx: Data packet ---\n");
+		mwifiex_handle_rx_packet(adapter, skb);
+		break;
+
+	case MWIFIEX_TYPE_CMD:
+		dev_dbg(adapter->dev, "info: --- Rx: Cmd Response ---\n");
+		/* take care of curr_cmd = NULL case */
+		if (!adapter->curr_cmd) {
+			cmd_buf = adapter->upld_buf;
+
+			if (adapter->ps_state == PS_STATE_SLEEP_CFM)
+				mwifiex_process_sleep_confirm_resp(adapter,
+							skb->data, skb->len);
+
+			memcpy(cmd_buf, skb->data, min_t(u32,
+				       MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
+
+			dev_kfree_skb_any(skb);
+		} else {
+			adapter->cmd_resp_received = true;
+			adapter->curr_cmd->resp_skb = skb;
+		}
+		break;
+
+	case MWIFIEX_TYPE_EVENT:
+		dev_dbg(adapter->dev, "info: --- Rx: Event ---\n");
+		adapter->event_cause = *(u32 *) skb->data;
+
+		skb_pull(skb, MWIFIEX_EVENT_HEADER_LEN);
+
+		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
+			memcpy(adapter->event_body, skb->data, skb->len);
+
+		/* event cause has been saved to adapter->event_cause */
+		adapter->event_received = true;
+		adapter->event_skb = skb;
+
+		break;
+
+	default:
+		dev_err(adapter->dev, "unknown upload type %#x\n", upld_typ);
+		dev_kfree_skb_any(skb);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * This function transfers received packets from card to driver, performing
+ * aggregation if required.
+ *
+ * For data received on control port, or if aggregation is disabled, the
+ * received buffers are uploaded as separate packets. However, if aggregation
+ * is enabled and required, the buffers are copied onto an aggregation buffer,
+ * provided there is space left, processed and finally uploaded.
+ */
+static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
+					     struct sk_buff *skb, u8 port)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	s32 f_do_rx_aggr = 0;
+	s32 f_do_rx_cur = 0;
+	s32 f_aggr_cur = 0;
+	struct sk_buff *skb_deaggr;
+	u32 pind = 0;
+	u32 pkt_len, pkt_type = 0;
+	u8 *curr_ptr;
+	u32 rx_len = skb->len;
+
+	if (port == CTRL_PORT) {
+		/* Read the command Resp without aggr */
+		dev_dbg(adapter->dev, "info: %s: no aggregation for cmd "
+				"response\n", __func__);
+
+		f_do_rx_cur = 1;
+		goto rx_curr_single;
+	}
+
+	if (!card->mpa_rx.enabled) {
+		dev_dbg(adapter->dev, "info: %s: rx aggregation disabled\n",
+						__func__);
+
+		f_do_rx_cur = 1;
+		goto rx_curr_single;
+	}
+
+	if (card->mp_rd_bitmap & (~((u16) CTRL_PORT_MASK))) {
+		/* Some more data RX pending */
+		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
+
+		if (MP_RX_AGGR_IN_PROGRESS(card)) {
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
+				f_aggr_cur = 1;
+			} else {
+				/* No room in Aggr buf, do rx aggr now */
+				f_do_rx_aggr = 1;
+				f_do_rx_cur = 1;
+			}
+		} else {
+			/* Rx aggr not in progress */
+			f_aggr_cur = 1;
+		}
+
+	} else {
+		/* No more data RX pending */
+		dev_dbg(adapter->dev, "info: %s: last packet\n", __func__);
+
+		if (MP_RX_AGGR_IN_PROGRESS(card)) {
+			f_do_rx_aggr = 1;
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len))
+				f_aggr_cur = 1;
+			else
+				/* No room in Aggr buf, do rx aggr now */
+				f_do_rx_cur = 1;
+		} else {
+			f_do_rx_cur = 1;
+		}
+	}
+
+	if (f_aggr_cur) {
+		dev_dbg(adapter->dev, "info: current packet aggregation\n");
+		/* Curr pkt can be aggregated */
+		MP_RX_AGGR_SETUP(card, skb, port);
+
+		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
+		    MP_RX_AGGR_PORT_LIMIT_REACHED(card)) {
+			dev_dbg(adapter->dev, "info: %s: aggregated packet "
+					"limit reached\n", __func__);
+			/* No more pkts allowed in Aggr buf, rx it */
+			f_do_rx_aggr = 1;
+		}
+	}
+
+	if (f_do_rx_aggr) {
+		/* do aggr RX now */
+		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
+		       card->mpa_rx.pkt_cnt);
+
+		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
+					   card->mpa_rx.buf_len,
+					   (adapter->ioport | 0x1000 |
+					    (card->mpa_rx.ports << 4)) +
+					   card->mpa_rx.start_port, 0, 1))
+			return -1;
+
+		curr_ptr = card->mpa_rx.buf;
+
+		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
+
+			/* get curr PKT len & type */
+			pkt_len = *(u16 *) &curr_ptr[0];
+			pkt_type = *(u16 *) &curr_ptr[2];
+
+			/* copy pkt to deaggr buf */
+			skb_deaggr = card->mpa_rx.skb_arr[pind];
+
+			if ((pkt_type == MWIFIEX_TYPE_DATA) && (pkt_len <=
+					 card->mpa_rx.len_arr[pind])) {
+
+				memcpy(skb_deaggr->data, curr_ptr, pkt_len);
+
+				skb_trim(skb_deaggr, pkt_len);
+
+				/* Process de-aggr packet */
+				mwifiex_decode_rx_packet(adapter, skb_deaggr,
+							 pkt_type);
+			} else {
+				dev_err(adapter->dev, "wrong aggr pkt:"
+					" type=%d len=%d max_len=%d\n",
+					pkt_type, pkt_len,
+					card->mpa_rx.len_arr[pind]);
+				dev_kfree_skb_any(skb_deaggr);
+			}
+			curr_ptr += card->mpa_rx.len_arr[pind];
+		}
+		MP_RX_AGGR_BUF_RESET(card);
+	}
+
+rx_curr_single:
+	if (f_do_rx_cur) {
+		dev_dbg(adapter->dev, "info: RX: port: %d, rx_len: %d\n",
+			port, rx_len);
+
+		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
+					      skb->data, skb->len,
+					      adapter->ioport + port))
+			return -1;
+
+		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
+	}
+
+	return 0;
+}
+
+/*
+ * This function checks the current interrupt status.
+ *
+ * The following interrupts are checked and handled by this function -
+ *      - Data sent
+ *      - Command sent
+ *      - Packets received
+ *
+ * Since the firmware does not generate download ready interrupt if the
+ * port updated is command port only, command sent interrupt checking
+ * should be done manually, and for every SDIO interrupt.
+ *
+ * In case of Rx packets received, the packets are uploaded from card to
+ * host and processed accordingly.
+ */
+static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+	u8 sdio_ireg;
+	struct sk_buff *skb = NULL;
+	u8 port = CTRL_PORT;
+	u32 len_reg_l, len_reg_u;
+	u32 rx_blocks;
+	u16 rx_len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->int_lock, flags);
+	sdio_ireg = adapter->int_status;
+	adapter->int_status = 0;
+	spin_unlock_irqrestore(&adapter->int_lock, flags);
+
+	if (!sdio_ireg)
+		return ret;
+
+	if (sdio_ireg & DN_LD_HOST_INT_STATUS) {
+		card->mp_wr_bitmap = ((u16) card->mp_regs[WR_BITMAP_U]) << 8;
+		card->mp_wr_bitmap |= (u16) card->mp_regs[WR_BITMAP_L];
+		dev_dbg(adapter->dev, "int: DNLD: wr_bitmap=0x%04x\n",
+				card->mp_wr_bitmap);
+		if (adapter->data_sent &&
+		    (card->mp_wr_bitmap & card->mp_data_port_mask)) {
+			dev_dbg(adapter->dev,
+				"info:  <--- Tx DONE Interrupt --->\n");
+			adapter->data_sent = false;
+		}
+	}
+
+	/* As firmware will not generate download ready interrupt if the port
+	   updated is command port only, cmd_sent should be done for any SDIO
+	   interrupt. */
+	if (adapter->cmd_sent) {
+		/* Check if firmware has attach buffer at command port and
+		   update just that in wr_bit_map. */
+		card->mp_wr_bitmap |=
+			(u16) card->mp_regs[WR_BITMAP_L] & CTRL_PORT_MASK;
+		if (card->mp_wr_bitmap & CTRL_PORT_MASK)
+			adapter->cmd_sent = false;
+	}
+
+	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
+	       adapter->cmd_sent, adapter->data_sent);
+	if (sdio_ireg & UP_LD_HOST_INT_STATUS) {
+		card->mp_rd_bitmap = ((u16) card->mp_regs[RD_BITMAP_U]) << 8;
+		card->mp_rd_bitmap |= (u16) card->mp_regs[RD_BITMAP_L];
+		dev_dbg(adapter->dev, "int: UPLD: rd_bitmap=0x%04x\n",
+				card->mp_rd_bitmap);
+
+		while (true) {
+			ret = mwifiex_get_rd_port(adapter, &port);
+			if (ret) {
+				dev_dbg(adapter->dev,
+					"info: no more rd_port available\n");
+				break;
+			}
+			len_reg_l = RD_LEN_P0_L + (port << 1);
+			len_reg_u = RD_LEN_P0_U + (port << 1);
+			rx_len = ((u16) card->mp_regs[len_reg_u]) << 8;
+			rx_len |= (u16) card->mp_regs[len_reg_l];
+			dev_dbg(adapter->dev, "info: RX: port=%d rx_len=%u\n",
+					port, rx_len);
+			rx_blocks =
+				(rx_len + MWIFIEX_SDIO_BLOCK_SIZE -
+				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
+			if (rx_len <= INTF_HEADER_LEN
+			    || (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
+			    MWIFIEX_RX_DATA_BUF_SIZE) {
+				dev_err(adapter->dev, "invalid rx_len=%d\n",
+						rx_len);
+				return -1;
+			}
+			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
+
+			skb = dev_alloc_skb(rx_len);
+
+			if (!skb) {
+				dev_err(adapter->dev, "%s: failed to alloc skb",
+								__func__);
+				return -1;
+			}
+
+			skb_put(skb, rx_len);
+
+			dev_dbg(adapter->dev, "info: rx_len = %d skb->len = %d\n",
+					rx_len, skb->len);
+
+			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
+							      port)) {
+				u32 cr = 0;
+
+				dev_err(adapter->dev, "card_to_host_mpa failed:"
+						" int status=%#x\n", sdio_ireg);
+				if (mwifiex_read_reg(adapter,
+						     CONFIGURATION_REG, &cr))
+					dev_err(adapter->dev,
+							"read CFG reg failed\n");
+
+				dev_dbg(adapter->dev,
+						"info: CFG reg val = %d\n", cr);
+				if (mwifiex_write_reg(adapter,
+						      CONFIGURATION_REG,
+						      (cr | 0x04)))
+					dev_err(adapter->dev,
+							"write CFG reg failed\n");
+
+				dev_dbg(adapter->dev, "info: write success\n");
+				if (mwifiex_read_reg(adapter,
+						     CONFIGURATION_REG, &cr))
+					dev_err(adapter->dev,
+							"read CFG reg failed\n");
+
+				dev_dbg(adapter->dev,
+						"info: CFG reg val =%x\n", cr);
+				dev_kfree_skb_any(skb);
+				return -1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function aggregates transmission buffers in driver and downloads
+ * the aggregated packet to card.
+ *
+ * The individual packets are aggregated by copying into an aggregation
+ * buffer and then downloaded to the card. Previous unsent packets in the
+ * aggregation buffer are pre-copied first before new packets are added.
+ * Aggregation is done till there is space left in the aggregation buffer,
+ * or till new packets are available.
+ *
+ * The function will only download the packet to the card when aggregation
+ * stops, otherwise it will just aggregate the packet in aggregation buffer
+ * and return.
+ */
+static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
+					u8 *payload, u32 pkt_len, u8 port,
+					u32 next_pkt_len)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+	s32 f_send_aggr_buf = 0;
+	s32 f_send_cur_buf = 0;
+	s32 f_precopy_cur_buf = 0;
+	s32 f_postcopy_cur_buf = 0;
+
+	if ((!card->mpa_tx.enabled) || (port == CTRL_PORT)) {
+		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
+						__func__);
+
+		f_send_cur_buf = 1;
+		goto tx_curr_single;
+	}
+
+	if (next_pkt_len) {
+		/* More pkt in TX queue */
+		dev_dbg(adapter->dev, "info: %s: more packets in queue.\n",
+						__func__);
+
+		if (MP_TX_AGGR_IN_PROGRESS(card)) {
+			if (!MP_TX_AGGR_PORT_LIMIT_REACHED(card) &&
+			    MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
+				f_precopy_cur_buf = 1;
+
+				if (!(card->mp_wr_bitmap &
+						(1 << card->curr_wr_port))
+						|| !MP_TX_AGGR_BUF_HAS_ROOM(
+							card, next_pkt_len))
+					f_send_aggr_buf = 1;
+			} else {
+				/* No room in Aggr buf, send it */
+				f_send_aggr_buf = 1;
+
+				if (MP_TX_AGGR_PORT_LIMIT_REACHED(card) ||
+				    !(card->mp_wr_bitmap &
+				      (1 << card->curr_wr_port)))
+					f_send_cur_buf = 1;
+				else
+					f_postcopy_cur_buf = 1;
+			}
+		} else {
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)
+			    && (card->mp_wr_bitmap & (1 << card->curr_wr_port)))
+				f_precopy_cur_buf = 1;
+			else
+				f_send_cur_buf = 1;
+		}
+	} else {
+		/* Last pkt in TX queue */
+		dev_dbg(adapter->dev, "info: %s: Last packet in Tx Queue.\n",
+						__func__);
+
+		if (MP_TX_AGGR_IN_PROGRESS(card)) {
+			/* some packs in Aggr buf already */
+			f_send_aggr_buf = 1;
+
+			if (MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len))
+				f_precopy_cur_buf = 1;
+			else
+				/* No room in Aggr buf, send it */
+				f_send_cur_buf = 1;
+		} else {
+			f_send_cur_buf = 1;
+		}
+	}
+
+	if (f_precopy_cur_buf) {
+		dev_dbg(adapter->dev, "data: %s: precopy current buffer\n",
+						__func__);
+		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
+
+		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
+		    MP_TX_AGGR_PORT_LIMIT_REACHED(card))
+			/* No more pkts allowed in Aggr buf, send it */
+			f_send_aggr_buf = 1;
+	}
+
+	if (f_send_aggr_buf) {
+		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
+				__func__,
+				card->mpa_tx.start_port, card->mpa_tx.ports);
+		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
+						 card->mpa_tx.buf_len,
+						 (adapter->ioport | 0x1000 |
+						 (card->mpa_tx.ports << 4)) +
+						  card->mpa_tx.start_port);
+
+		MP_TX_AGGR_BUF_RESET(card);
+	}
+
+tx_curr_single:
+	if (f_send_cur_buf) {
+		dev_dbg(adapter->dev, "data: %s: send current buffer %d\n",
+						__func__, port);
+		ret = mwifiex_write_data_to_card(adapter, payload, pkt_len,
+						 adapter->ioport + port);
+	}
+
+	if (f_postcopy_cur_buf) {
+		dev_dbg(adapter->dev, "data: %s: postcopy current buffer\n",
+						__func__);
+		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
+	}
+
+	return ret;
+}
+
+/*
+ * This function downloads data from driver to card.
+ *
+ * Both commands and data packets are transferred to the card by this
+ * function.
+ *
+ * This function adds the SDIO specific header to the front of the buffer
+ * before transferring. The header contains the length of the packet and
+ * the type. The firmware handles the packets based upon this set type.
+ */
+static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
+				     u8 type, u8 *payload, u32 pkt_len,
+				     struct mwifiex_tx_param *tx_param)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+	u32 buf_block_len;
+	u32 blk_size;
+	u8 port = CTRL_PORT;
+
+	/* Allocate buffer and copy payload */
+	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
+	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
+	*(u16 *) &payload[0] = (u16) pkt_len;
+	*(u16 *) &payload[2] = type;
+
+	/*
+	 * This is SDIO specific header
+	 *  u16 length,
+	 *  u16 type (MWIFIEX_TYPE_DATA = 0, MWIFIEX_TYPE_CMD = 1,
+	 *  MWIFIEX_TYPE_EVENT = 3)
+	 */
+	if (type == MWIFIEX_TYPE_DATA) {
+		ret = mwifiex_get_wr_port_data(adapter, &port);
+		if (ret) {
+			dev_err(adapter->dev, "%s: no wr_port available\n",
+						__func__);
+			return ret;
+		}
+	} else {
+		adapter->cmd_sent = true;
+		/* Type must be MWIFIEX_TYPE_CMD */
+
+		if (pkt_len <= INTF_HEADER_LEN ||
+		    pkt_len > MWIFIEX_UPLD_SIZE)
+			dev_err(adapter->dev, "%s: payload=%p, nb=%d\n",
+					__func__, payload, pkt_len);
+	}
+
+	/* Transfer data to card */
+	pkt_len = buf_block_len * blk_size;
+
+	if (tx_param)
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
+				port, tx_param->next_pkt_len);
+	else
+		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
+				port, 0);
+
+	if (ret) {
+		if (type == MWIFIEX_TYPE_CMD)
+			adapter->cmd_sent = false;
+		if (type == MWIFIEX_TYPE_DATA)
+			adapter->data_sent = false;
+	} else {
+		if (type == MWIFIEX_TYPE_DATA) {
+			if (!(card->mp_wr_bitmap & (1 << card->curr_wr_port)))
+				adapter->data_sent = true;
+			else
+				adapter->data_sent = false;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function allocates the MPA Tx and Rx buffers.
+ */
+static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
+				   u32 mpa_tx_buf_size, u32 mpa_rx_buf_size)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+
+	card->mpa_tx.buf = kzalloc(mpa_tx_buf_size, GFP_KERNEL);
+	if (!card->mpa_tx.buf) {
+		dev_err(adapter->dev, "could not alloc buffer for MP-A TX\n");
+		ret = -1;
+		goto error;
+	}
+
+	card->mpa_tx.buf_size = mpa_tx_buf_size;
+
+	card->mpa_rx.buf = kzalloc(mpa_rx_buf_size, GFP_KERNEL);
+	if (!card->mpa_rx.buf) {
+		dev_err(adapter->dev, "could not alloc buffer for MP-A RX\n");
+		ret = -1;
+		goto error;
+	}
+
+	card->mpa_rx.buf_size = mpa_rx_buf_size;
+
+error:
+	if (ret) {
+		kfree(card->mpa_tx.buf);
+		kfree(card->mpa_rx.buf);
+	}
+
+	return ret;
+}
+
+/*
+ * This function unregisters the SDIO device.
+ *
+ * The SDIO IRQ is released, the function is disabled and driver
+ * data is set to null.
+ */
+static void
+mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (adapter->card) {
+		/* Release the SDIO IRQ */
+		sdio_claim_host(card->func);
+		sdio_release_irq(card->func);
+		sdio_disable_func(card->func);
+		sdio_release_host(card->func);
+		sdio_set_drvdata(card->func, NULL);
+	}
+}
+
+/*
+ * This function registers the SDIO device.
+ *
+ * SDIO IRQ is claimed, block size is set and driver data is initialized.
+ */
+static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
+{
+	int ret = 0;
+	struct sdio_mmc_card *card = adapter->card;
+	struct sdio_func *func = card->func;
+
+	/* save adapter pointer in card */
+	card->adapter = adapter;
+
+	sdio_claim_host(func);
+
+	/* Request the SDIO IRQ */
+	ret = sdio_claim_irq(func, mwifiex_sdio_interrupt);
+	if (ret) {
+		pr_err("claim irq failed: ret=%d\n", ret);
+		goto disable_func;
+	}
+
+	/* Set block size */
+	ret = sdio_set_block_size(card->func, MWIFIEX_SDIO_BLOCK_SIZE);
+	if (ret) {
+		pr_err("cannot set SDIO block size\n");
+		ret = -1;
+		goto release_irq;
+	}
+
+	sdio_release_host(func);
+	sdio_set_drvdata(func, card);
+
+	adapter->dev = &func->dev;
+
+	return 0;
+
+release_irq:
+	sdio_release_irq(func);
+disable_func:
+	sdio_disable_func(func);
+	sdio_release_host(func);
+	adapter->card = NULL;
+
+	return -1;
+}
+
+/*
+ * This function initializes the SDIO driver.
+ *
+ * The following initializations steps are followed -
+ *      - Read the Host interrupt status register to acknowledge
+ *        the first interrupt got from bootloader
+ *      - Disable host interrupt mask register
+ *      - Get SDIO port
+ *      - Get revision ID
+ *      - Initialize SDIO variables in card
+ *      - Allocate MP registers
+ *      - Allocate MPA Tx and Rx buffers
+ */
+static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret;
+	u32 sdio_ireg = 0;
+
+	/*
+	 * Read the HOST_INT_STATUS_REG for ACK the first interrupt got
+	 * from the bootloader. If we don't do this we get a interrupt
+	 * as soon as we register the irq.
+	 */
+	mwifiex_read_reg(adapter, HOST_INTSTATUS_REG, &sdio_ireg);
+
+	/* Disable host interrupt mask register for SDIO */
+	mwifiex_sdio_disable_host_int(adapter);
+
+	/* Get SDIO ioport */
+	mwifiex_init_sdio_ioport(adapter);
+
+	/* Get revision ID */
+#define REV_ID_REG	0x5c
+	mwifiex_read_reg(adapter, REV_ID_REG, &adapter->revision_id);
+
+	/* Initialize SDIO variables in card */
+	card->mp_rd_bitmap = 0;
+	card->mp_wr_bitmap = 0;
+	card->curr_rd_port = 1;
+	card->curr_wr_port = 1;
+
+	card->mp_data_port_mask = DATA_PORT_MASK;
+
+	card->mpa_tx.buf_len = 0;
+	card->mpa_tx.pkt_cnt = 0;
+	card->mpa_tx.start_port = 0;
+
+	card->mpa_tx.enabled = 0;
+	card->mpa_tx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
+
+	card->mpa_rx.buf_len = 0;
+	card->mpa_rx.pkt_cnt = 0;
+	card->mpa_rx.start_port = 0;
+
+	card->mpa_rx.enabled = 0;
+	card->mpa_rx.pkt_aggr_limit = SDIO_MP_AGGR_DEF_PKT_LIMIT;
+
+	/* Allocate buffers for SDIO MP-A */
+	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
+	if (!card->mp_regs) {
+		dev_err(adapter->dev, "failed to alloc mp_regs\n");
+		return -1;
+	}
+
+	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
+					     SDIO_MP_TX_AGGR_DEF_BUF_SIZE,
+					     SDIO_MP_RX_AGGR_DEF_BUF_SIZE);
+	if (ret) {
+		dev_err(adapter->dev, "failed to alloc sdio mp-a buffers\n");
+		kfree(card->mp_regs);
+		return -1;
+	}
+
+	return ret;
+}
+
+/*
+ * This function resets the MPA Tx and Rx buffers.
+ */
+static void mwifiex_cleanup_mpa_buf(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+
+	MP_TX_AGGR_BUF_RESET(card);
+	MP_RX_AGGR_BUF_RESET(card);
+}
+
+/*
+ * This function cleans up the allocated card buffers.
+ *
+ * The following are freed by this function -
+ *      - MP registers
+ *      - MPA Tx buffer
+ *      - MPA Rx buffer
+ */
+static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+
+	kfree(card->mp_regs);
+	kfree(card->mpa_tx.buf);
+	kfree(card->mpa_rx.buf);
+}
+
+/*
+ * This function updates the MP end port in card.
+ */
+static void
+mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int i;
+
+	card->mp_end_port = port;
+
+	card->mp_data_port_mask = DATA_PORT_MASK;
+
+	for (i = 1; i <= MAX_PORT - card->mp_end_port; i++)
+		card->mp_data_port_mask &= ~(1 << (MAX_PORT - i));
+
+	card->curr_wr_port = 1;
+
+	dev_dbg(adapter->dev, "cmd: mp_end_port %d, data port mask 0x%x\n",
+	       port, card->mp_data_port_mask);
+}
+
+static struct mwifiex_if_ops sdio_ops = {
+	.init_if = mwifiex_init_sdio,
+	.cleanup_if = mwifiex_cleanup_sdio,
+	.check_fw_status = mwifiex_check_fw_status,
+	.prog_fw = mwifiex_prog_fw_w_helper,
+	.register_dev = mwifiex_register_dev,
+	.unregister_dev = mwifiex_unregister_dev,
+	.enable_int = mwifiex_sdio_enable_host_int,
+	.process_int_status = mwifiex_process_int_status,
+	.host_to_card = mwifiex_sdio_host_to_card,
+	.wakeup = mwifiex_pm_wakeup_card,
+	.wakeup_complete = mwifiex_pm_wakeup_card_complete,
+
+	/* SDIO specific */
+	.update_mp_end_port = mwifiex_update_mp_end_port,
+	.cleanup_mpa_buf = mwifiex_cleanup_mpa_buf,
+};
+
+/*
+ * This function initializes the SDIO driver.
+ *
+ * This initiates the semaphore and registers the device with
+ * SDIO bus.
+ */
+static int
+mwifiex_sdio_init_module(void)
+{
+	int ret;
+
+	sema_init(&add_remove_card_sem, 1);
+
+	ret = sdio_register_driver(&mwifiex_sdio);
+
+	return ret;
+}
+
+/*
+ * This function cleans up the SDIO driver.
+ *
+ * The following major steps are followed for cleanup -
+ *      - Resume the device if its suspended
+ *      - Disconnect the device if connected
+ *      - Shutdown the firmware
+ *      - Unregister the device from SDIO bus.
+ */
+static void
+mwifiex_sdio_cleanup_module(void)
+{
+	struct mwifiex_adapter *adapter = g_adapter;
+	int i;
+
+	if (down_interruptible(&add_remove_card_sem))
+		goto exit_sem_err;
+
+	if (!adapter || !adapter->priv_num)
+		goto exit;
+
+	if (adapter->is_suspended)
+		mwifiex_sdio_resume(adapter->dev);
+
+	for (i = 0; i < adapter->priv_num; i++)
+		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
+		    adapter->priv[i]->media_connected)
+			mwifiex_disconnect(adapter->priv[i], MWIFIEX_CMD_WAIT,
+					   NULL);
+
+	if (!adapter->surprise_removed)
+		mwifiex_shutdown_fw(mwifiex_get_priv
+				    (adapter, MWIFIEX_BSS_ROLE_ANY),
+				    MWIFIEX_CMD_WAIT);
+
+exit:
+	up(&add_remove_card_sem);
+
+exit_sem_err:
+	sdio_unregister_driver(&mwifiex_sdio);
+}
+
+module_init(mwifiex_sdio_init_module);
+module_exit(mwifiex_sdio_cleanup_module);
+
+MODULE_AUTHOR("Marvell International Ltd.");
+MODULE_DESCRIPTION("Marvell WiFi-Ex SDIO Driver version " SDIO_VERSION);
+MODULE_VERSION(SDIO_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE("sd8787.bin");
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
new file mode 100644
index 0000000..a0e9bc5
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -0,0 +1,305 @@
+/*
+ * Marvell Wireless LAN device driver: SDIO specific definitions
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef	_MWIFIEX_SDIO_H
+#define	_MWIFIEX_SDIO_H
+
+
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/card.h>
+
+#include "main.h"
+
+#define BLOCK_MODE	1
+#define BYTE_MODE	0
+
+#define REG_PORT			0
+#define RD_BITMAP_L			0x04
+#define RD_BITMAP_U			0x05
+#define WR_BITMAP_L			0x06
+#define WR_BITMAP_U			0x07
+#define RD_LEN_P0_L			0x08
+#define RD_LEN_P0_U			0x09
+
+#define MWIFIEX_SDIO_IO_PORT_MASK		0xfffff
+
+#define MWIFIEX_SDIO_BYTE_MODE_MASK	0x80000000
+
+#define CTRL_PORT			0
+#define CTRL_PORT_MASK			0x0001
+#define DATA_PORT_MASK			0xfffe
+
+#define MAX_MP_REGS			64
+#define MAX_PORT			16
+
+#define SDIO_MP_AGGR_DEF_PKT_LIMIT	8
+
+#define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
+
+/* Multi port RX aggregation buffer size */
+#define SDIO_MP_RX_AGGR_DEF_BUF_SIZE        (4096)	/* 4K */
+
+/* Misc. Config Register : Auto Re-enable interrupts */
+#define AUTO_RE_ENABLE_INT              BIT(4)
+
+/* Host Control Registers */
+/* Host Control Registers : I/O port 0 */
+#define IO_PORT_0_REG			0x78
+/* Host Control Registers : I/O port 1 */
+#define IO_PORT_1_REG			0x79
+/* Host Control Registers : I/O port 2 */
+#define IO_PORT_2_REG			0x7A
+
+/* Host Control Registers : Configuration */
+#define CONFIGURATION_REG		0x00
+/* Host Control Registers : Host without Command 53 finish host*/
+#define HOST_TO_CARD_EVENT       (0x1U << 3)
+/* Host Control Registers : Host without Command 53 finish host */
+#define HOST_WO_CMD53_FINISH_HOST	(0x1U << 2)
+/* Host Control Registers : Host power up */
+#define HOST_POWER_UP			(0x1U << 1)
+/* Host Control Registers : Host power down */
+#define HOST_POWER_DOWN			(0x1U << 0)
+
+/* Host Control Registers : Host interrupt mask */
+#define HOST_INT_MASK_REG		0x02
+/* Host Control Registers : Upload host interrupt mask */
+#define UP_LD_HOST_INT_MASK		(0x1U)
+/* Host Control Registers : Download host interrupt mask */
+#define DN_LD_HOST_INT_MASK		(0x2U)
+/* Enable Host interrupt mask */
+#define HOST_INT_ENABLE	(UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK)
+/* Disable Host interrupt mask */
+#define	HOST_INT_DISABLE		0xff
+
+/* Host Control Registers : Host interrupt status */
+#define HOST_INTSTATUS_REG		0x03
+/* Host Control Registers : Upload host interrupt status */
+#define UP_LD_HOST_INT_STATUS		(0x1U)
+/* Host Control Registers : Download host interrupt status */
+#define DN_LD_HOST_INT_STATUS		(0x2U)
+
+/* Host Control Registers : Host interrupt RSR */
+#define HOST_INT_RSR_REG		0x01
+/* Host Control Registers : Upload host interrupt RSR */
+#define UP_LD_HOST_INT_RSR		(0x1U)
+#define SDIO_INT_MASK			0x3F
+
+/* Host Control Registers : Host interrupt status */
+#define HOST_INT_STATUS_REG		0x28
+/* Host Control Registers : Upload CRC error */
+#define UP_LD_CRC_ERR			(0x1U << 2)
+/* Host Control Registers : Upload restart */
+#define UP_LD_RESTART                   (0x1U << 1)
+/* Host Control Registers : Download restart */
+#define DN_LD_RESTART                   (0x1U << 0)
+
+/* Card Control Registers : Card status register */
+#define CARD_STATUS_REG                 0x30
+/* Card Control Registers : Card I/O ready */
+#define CARD_IO_READY                   (0x1U << 3)
+/* Card Control Registers : CIS card ready */
+#define CIS_CARD_RDY                    (0x1U << 2)
+/* Card Control Registers : Upload card ready */
+#define UP_LD_CARD_RDY                  (0x1U << 1)
+/* Card Control Registers : Download card ready */
+#define DN_LD_CARD_RDY                  (0x1U << 0)
+
+/* Card Control Registers : Host interrupt mask register */
+#define HOST_INTERRUPT_MASK_REG         0x34
+/* Card Control Registers : Host power interrupt mask */
+#define HOST_POWER_INT_MASK             (0x1U << 3)
+/* Card Control Registers : Abort card interrupt mask */
+#define ABORT_CARD_INT_MASK             (0x1U << 2)
+/* Card Control Registers : Upload card interrupt mask */
+#define UP_LD_CARD_INT_MASK             (0x1U << 1)
+/* Card Control Registers : Download card interrupt mask */
+#define DN_LD_CARD_INT_MASK             (0x1U << 0)
+
+/* Card Control Registers : Card interrupt status register */
+#define CARD_INTERRUPT_STATUS_REG       0x38
+/* Card Control Registers : Power up interrupt */
+#define POWER_UP_INT                    (0x1U << 4)
+/* Card Control Registers : Power down interrupt */
+#define POWER_DOWN_INT                  (0x1U << 3)
+
+/* Card Control Registers : Card interrupt RSR register */
+#define CARD_INTERRUPT_RSR_REG          0x3c
+/* Card Control Registers : Power up RSR */
+#define POWER_UP_RSR                    (0x1U << 4)
+/* Card Control Registers : Power down RSR */
+#define POWER_DOWN_RSR                  (0x1U << 3)
+
+/* Card Control Registers : Miscellaneous Configuration Register */
+#define CARD_MISC_CFG_REG               0x6C
+
+/* Host F1 read base 0 */
+#define HOST_F1_RD_BASE_0		0x0040
+/* Host F1 read base 1 */
+#define HOST_F1_RD_BASE_1		0x0041
+/* Host F1 card ready */
+#define HOST_F1_CARD_RDY		0x0020
+
+/* Firmware status 0 register */
+#define CARD_FW_STATUS0_REG		0x60
+/* Firmware status 1 register */
+#define CARD_FW_STATUS1_REG		0x61
+/* Rx length register */
+#define CARD_RX_LEN_REG			0x62
+/* Rx unit register */
+#define CARD_RX_UNIT_REG		0x63
+
+/* Event header Len*/
+#define MWIFIEX_EVENT_HEADER_LEN           8
+
+/* Max retry number of CMD53 write */
+#define MAX_WRITE_IOMEM_RETRY		2
+
+/* SDIO Tx aggregation in progress ? */
+#define MP_TX_AGGR_IN_PROGRESS(a) (a->mpa_tx.pkt_cnt > 0)
+
+/* SDIO Tx aggregation buffer room for next packet ? */
+#define MP_TX_AGGR_BUF_HAS_ROOM(a, len) ((a->mpa_tx.buf_len+len)	\
+						<= a->mpa_tx.buf_size)
+
+/* Copy current packet (SDIO Tx aggregation buffer) to SDIO buffer */
+#define MP_TX_AGGR_BUF_PUT(a, payload, pkt_len, port) do {		\
+	memmove(&a->mpa_tx.buf[a->mpa_tx.buf_len],			\
+			payload, pkt_len);				\
+	a->mpa_tx.buf_len += pkt_len;					\
+	if (!a->mpa_tx.pkt_cnt)						\
+		a->mpa_tx.start_port = port;				\
+	if (a->mpa_tx.start_port <= port)				\
+		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt));		\
+	else								\
+		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt+1+(MAX_PORT -	\
+						a->mp_end_port)));	\
+	a->mpa_tx.pkt_cnt++;						\
+} while (0);
+
+/* SDIO Tx aggregation limit ? */
+#define MP_TX_AGGR_PKT_LIMIT_REACHED(a)					\
+			(a->mpa_tx.pkt_cnt == a->mpa_tx.pkt_aggr_limit)
+
+/* SDIO Tx aggregation port limit ? */
+#define MP_TX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_wr_port <		\
+			a->mpa_tx.start_port) && (((MAX_PORT -		\
+			a->mpa_tx.start_port) + a->curr_wr_port) >=	\
+				SDIO_MP_AGGR_DEF_PKT_LIMIT))
+
+/* Reset SDIO Tx aggregation buffer parameters */
+#define MP_TX_AGGR_BUF_RESET(a) do {					\
+	a->mpa_tx.pkt_cnt = 0;						\
+	a->mpa_tx.buf_len = 0;						\
+	a->mpa_tx.ports = 0;						\
+	a->mpa_tx.start_port = 0;					\
+} while (0);
+
+/* SDIO Rx aggregation limit ? */
+#define MP_RX_AGGR_PKT_LIMIT_REACHED(a)					\
+			(a->mpa_rx.pkt_cnt == a->mpa_rx.pkt_aggr_limit)
+
+/* SDIO Tx aggregation port limit ? */
+#define MP_RX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_rd_port <		\
+			a->mpa_rx.start_port) && (((MAX_PORT -		\
+			a->mpa_rx.start_port) + a->curr_rd_port) >=	\
+			SDIO_MP_AGGR_DEF_PKT_LIMIT))
+
+/* SDIO Rx aggregation in progress ? */
+#define MP_RX_AGGR_IN_PROGRESS(a) (a->mpa_rx.pkt_cnt > 0)
+
+/* SDIO Rx aggregation buffer room for next packet ? */
+#define MP_RX_AGGR_BUF_HAS_ROOM(a, rx_len)				\
+			((a->mpa_rx.buf_len+rx_len) <= a->mpa_rx.buf_size)
+
+/* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
+#define MP_RX_AGGR_SETUP(a, skb, port) do {				\
+	a->mpa_rx.buf_len += skb->len;					\
+	if (!a->mpa_rx.pkt_cnt)						\
+		a->mpa_rx.start_port = port;				\
+	if (a->mpa_rx.start_port <= port)				\
+		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt));		\
+	else								\
+		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt+1));		\
+	a->mpa_rx.skb_arr[a->mpa_rx.pkt_cnt] = skb;			\
+	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = skb->len;		\
+	a->mpa_rx.pkt_cnt++;						\
+} while (0);
+
+/* Reset SDIO Rx aggregation buffer parameters */
+#define MP_RX_AGGR_BUF_RESET(a) do {					\
+	a->mpa_rx.pkt_cnt = 0;						\
+	a->mpa_rx.buf_len = 0;						\
+	a->mpa_rx.ports = 0;						\
+	a->mpa_rx.start_port = 0;					\
+} while (0);
+
+
+/* data structure for SDIO MPA TX */
+struct mwifiex_sdio_mpa_tx {
+	/* multiport tx aggregation buffer pointer */
+	u8 *buf;
+	u32 buf_len;
+	u32 pkt_cnt;
+	u16 ports;
+	u16 start_port;
+	u8 enabled;
+	u32 buf_size;
+	u32 pkt_aggr_limit;
+};
+
+struct mwifiex_sdio_mpa_rx {
+	u8 *buf;
+	u32 buf_len;
+	u32 pkt_cnt;
+	u16 ports;
+	u16 start_port;
+
+	struct sk_buff *skb_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
+	u32 len_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
+
+	u8 enabled;
+	u32 buf_size;
+	u32 pkt_aggr_limit;
+};
+
+int mwifiex_bus_register(void);
+void mwifiex_bus_unregister(void);
+
+struct sdio_mmc_card {
+	struct sdio_func *func;
+	struct mwifiex_adapter *adapter;
+
+	u16 mp_rd_bitmap;
+	u16 mp_wr_bitmap;
+
+	u16 mp_end_port;
+	u16 mp_data_port_mask;
+
+	u8 curr_rd_port;
+	u8 curr_wr_port;
+
+	u8 *mp_regs;
+
+	struct mwifiex_sdio_mpa_tx mpa_tx;
+	struct mwifiex_sdio_mpa_rx mpa_rx;
+};
+#endif /* _MWIFIEX_SDIO_H */
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
new file mode 100644
index 0000000..795b1ea
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -0,0 +1,1226 @@
+/*
+ * Marvell Wireless LAN device driver: station command handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * This function prepares command to set/get RSSI information.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting data/beacon average factors
+ *      - Resetting SNR/NF/RSSI values in private structure
+ *      - Ensuring correct endian-ness
+ */
+static int
+mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd, u16 cmd_action)
+{
+	cmd->command = cpu_to_le16(HostCmd_CMD_RSSI_INFO);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rssi_info) +
+				S_DS_GEN);
+	cmd->params.rssi_info.action = cpu_to_le16(cmd_action);
+	cmd->params.rssi_info.ndata = cpu_to_le16(priv->data_avg_factor);
+	cmd->params.rssi_info.nbcn = cpu_to_le16(priv->bcn_avg_factor);
+
+	/* Reset SNR/NF/RSSI values in private structure */
+	priv->data_rssi_last = 0;
+	priv->data_nf_last = 0;
+	priv->data_rssi_avg = 0;
+	priv->data_nf_avg = 0;
+	priv->bcn_rssi_last = 0;
+	priv->bcn_nf_last = 0;
+	priv->bcn_rssi_avg = 0;
+	priv->bcn_nf_avg = 0;
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set MAC control.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
+	u16 action = *((u16 *) data_buf);
+
+	if (cmd_action != HostCmd_ACT_GEN_SET) {
+		dev_err(priv->adapter->dev,
+			"mac_control: only support set cmd\n");
+		return -1;
+	}
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_CONTROL);
+	cmd->size =
+		cpu_to_le16(sizeof(struct host_cmd_ds_mac_control) + S_DS_GEN);
+	mac_ctrl->action = cpu_to_le16(action);
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get SNMP MIB.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting SNMP MIB OID number and value
+ *        (as required)
+ *      - Ensuring correct endian-ness
+ *
+ * The following SNMP MIB OIDs are supported -
+ *      - FRAG_THRESH_I     : Fragmentation threshold
+ *      - RTS_THRESH_I      : RTS threshold
+ *      - SHORT_RETRY_LIM_I : Short retry limit
+ *      - DOT11D_I          : 11d support
+ */
+static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *cmd,
+				       u16 cmd_action, u32 cmd_oid,
+				       void *data_buf)
+{
+	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
+	u32 ul_temp;
+
+	dev_dbg(priv->adapter->dev, "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
+		- 1 + S_DS_GEN);
+
+	if (cmd_action == HostCmd_ACT_GEN_GET) {
+		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_GET);
+		snmp_mib->buf_size = cpu_to_le16(MAX_SNMP_BUF_SIZE);
+		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
+			+ MAX_SNMP_BUF_SIZE);
+	}
+
+	switch (cmd_oid) {
+	case FRAG_THRESH_I:
+		snmp_mib->oid = cpu_to_le16((u16) FRAG_THRESH_I);
+		if (cmd_action == HostCmd_ACT_GEN_SET) {
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
+			ul_temp = *((u32 *) data_buf);
+			*((__le16 *) (snmp_mib->value)) =
+				cpu_to_le16((u16) ul_temp);
+			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
+				+ sizeof(u16));
+		}
+		break;
+	case RTS_THRESH_I:
+		snmp_mib->oid = cpu_to_le16((u16) RTS_THRESH_I);
+		if (cmd_action == HostCmd_ACT_GEN_SET) {
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
+			ul_temp = *((u32 *) data_buf);
+			*(__le16 *) (snmp_mib->value) =
+				cpu_to_le16((u16) ul_temp);
+			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
+				+ sizeof(u16));
+		}
+		break;
+
+	case SHORT_RETRY_LIM_I:
+		snmp_mib->oid = cpu_to_le16((u16) SHORT_RETRY_LIM_I);
+		if (cmd_action == HostCmd_ACT_GEN_SET) {
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
+			ul_temp = (*(u32 *) data_buf);
+			*((__le16 *) (snmp_mib->value)) =
+				cpu_to_le16((u16) ul_temp);
+			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
+				+ sizeof(u16));
+		}
+		break;
+	case DOT11D_I:
+		snmp_mib->oid = cpu_to_le16((u16) DOT11D_I);
+		if (cmd_action == HostCmd_ACT_GEN_SET) {
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
+			ul_temp = *(u32 *) data_buf;
+			*((__le16 *) (snmp_mib->value)) =
+				cpu_to_le16((u16) ul_temp);
+			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size)
+				+ sizeof(u16));
+		}
+		break;
+	default:
+		break;
+	}
+	dev_dbg(priv->adapter->dev,
+		"cmd: SNMP_CMD: Action=0x%x, OID=0x%x, OIDSize=0x%x,"
+		" Value=0x%x\n",
+	       cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
+	       le16_to_cpu(*(__le16 *) snmp_mib->value));
+	return 0;
+}
+
+/*
+ * This function prepares command to get log.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Ensuring correct endian-ness
+ */
+static int
+mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
+			   struct host_cmd_ds_command *cmd)
+{
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_GET_LOG);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
+				S_DS_GEN);
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get Tx data rate configuration.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting configuration index, rate scope and rate drop pattern
+ *        parameters (as required)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &cmd->params.tx_rate_cfg;
+	struct mwifiex_rate_scope *rate_scope;
+	struct mwifiex_rate_drop_pattern *rate_drop;
+	u16 *pbitmap_rates = (u16 *) data_buf;
+
+	u32 i;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_TX_RATE_CFG);
+
+	rate_cfg->action = cpu_to_le16(cmd_action);
+	rate_cfg->cfg_index = 0;
+
+	rate_scope = (struct mwifiex_rate_scope *) ((u8 *) rate_cfg +
+		      sizeof(struct host_cmd_ds_tx_rate_cfg));
+	rate_scope->type = cpu_to_le16(TLV_TYPE_RATE_SCOPE);
+	rate_scope->length = cpu_to_le16(sizeof(struct mwifiex_rate_scope) -
+			sizeof(struct mwifiex_ie_types_header));
+	if (pbitmap_rates != NULL) {
+		rate_scope->hr_dsss_rate_bitmap = cpu_to_le16(pbitmap_rates[0]);
+		rate_scope->ofdm_rate_bitmap = cpu_to_le16(pbitmap_rates[1]);
+		for (i = 0;
+		     i < sizeof(rate_scope->ht_mcs_rate_bitmap) / sizeof(u16);
+		     i++)
+			rate_scope->ht_mcs_rate_bitmap[i] =
+				cpu_to_le16(pbitmap_rates[2 + i]);
+	} else {
+		rate_scope->hr_dsss_rate_bitmap =
+			cpu_to_le16(priv->bitmap_rates[0]);
+		rate_scope->ofdm_rate_bitmap =
+			cpu_to_le16(priv->bitmap_rates[1]);
+		for (i = 0;
+		     i < sizeof(rate_scope->ht_mcs_rate_bitmap) / sizeof(u16);
+		     i++)
+			rate_scope->ht_mcs_rate_bitmap[i] =
+				cpu_to_le16(priv->bitmap_rates[2 + i]);
+	}
+
+	rate_drop = (struct mwifiex_rate_drop_pattern *) ((u8 *) rate_scope +
+			sizeof(struct mwifiex_rate_scope));
+	rate_drop->type = cpu_to_le16(TLV_TYPE_RATE_DROP_CONTROL);
+	rate_drop->length = cpu_to_le16(sizeof(rate_drop->rate_drop_mode));
+	rate_drop->rate_drop_mode = 0;
+
+	cmd->size =
+		cpu_to_le16(S_DS_GEN + sizeof(struct host_cmd_ds_tx_rate_cfg) +
+			    sizeof(struct mwifiex_rate_scope) +
+			    sizeof(struct mwifiex_rate_drop_pattern));
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get Tx power configuration.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting Tx power mode, power group TLV
+ *        (as required)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    u16 cmd_action, void *data_buf)
+{
+	struct mwifiex_types_power_group *pg_tlv = NULL;
+	struct host_cmd_ds_txpwr_cfg *txp = NULL;
+	struct host_cmd_ds_txpwr_cfg *cmd_txp_cfg = &cmd->params.txp_cfg;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_TXPWR_CFG);
+	cmd->size =
+		cpu_to_le16(S_DS_GEN + sizeof(struct host_cmd_ds_txpwr_cfg));
+	switch (cmd_action) {
+	case HostCmd_ACT_GEN_SET:
+		txp = (struct host_cmd_ds_txpwr_cfg *) data_buf;
+		if (txp->mode) {
+			pg_tlv = (struct mwifiex_types_power_group
+				  *) ((unsigned long) data_buf +
+				     sizeof(struct host_cmd_ds_txpwr_cfg));
+			memmove(cmd_txp_cfg, data_buf,
+				sizeof(struct host_cmd_ds_txpwr_cfg) +
+				sizeof(struct mwifiex_types_power_group) +
+				pg_tlv->length);
+
+			pg_tlv = (struct mwifiex_types_power_group *) ((u8 *)
+				  cmd_txp_cfg +
+				  sizeof(struct host_cmd_ds_txpwr_cfg));
+			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
+				  sizeof(struct mwifiex_types_power_group) +
+				  pg_tlv->length);
+		} else {
+			memmove(cmd_txp_cfg, data_buf,
+				sizeof(struct host_cmd_ds_txpwr_cfg));
+		}
+		cmd_txp_cfg->action = cpu_to_le16(cmd_action);
+		break;
+	case HostCmd_ACT_GEN_GET:
+		cmd_txp_cfg->action = cpu_to_le16(cmd_action);
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set Host Sleep configuration.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting Host Sleep action, conditions, ARP filters
+ *        (as required)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     u16 cmd_action,
+				     struct mwifiex_hs_config_param *data_buf)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
+	u16 hs_activate = false;
+
+	if (data_buf == NULL)
+		/* New Activate command */
+		hs_activate = true;
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH);
+
+	if (!hs_activate &&
+	    (data_buf->conditions
+	    != cpu_to_le32(HOST_SLEEP_CFG_CANCEL))
+	    && ((adapter->arp_filter_size > 0)
+		&& (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
+		dev_dbg(adapter->dev,
+			"cmd: Attach %d bytes ArpFilter to HSCfg cmd\n",
+		       adapter->arp_filter_size);
+		memcpy(((u8 *) hs_cfg) +
+		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
+		       adapter->arp_filter, adapter->arp_filter_size);
+		cmd->size = cpu_to_le16(adapter->arp_filter_size +
+				    sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
+				    + S_DS_GEN);
+	} else {
+		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(struct
+					   host_cmd_ds_802_11_hs_cfg_enh));
+	}
+	if (hs_activate) {
+		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
+		hs_cfg->params.hs_activate.resp_ctrl = RESP_NEEDED;
+	} else {
+		hs_cfg->action = cpu_to_le16(HS_CONFIGURE);
+		hs_cfg->params.hs_config.conditions = data_buf->conditions;
+		hs_cfg->params.hs_config.gpio = data_buf->gpio;
+		hs_cfg->params.hs_config.gap = data_buf->gap;
+		dev_dbg(adapter->dev,
+			"cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
+		       hs_cfg->params.hs_config.conditions,
+		       hs_cfg->params.hs_config.gpio,
+		       hs_cfg->params.hs_config.gap);
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get MAC address.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting MAC address (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd,
+					  u16 cmd_action)
+{
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_MAC_ADDRESS);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_mac_address) +
+				S_DS_GEN);
+	cmd->result = 0;
+
+	cmd->params.mac_addr.action = cpu_to_le16(cmd_action);
+
+	if (cmd_action == HostCmd_ACT_GEN_SET)
+		memcpy(cmd->params.mac_addr.mac_addr, priv->curr_addr,
+		       ETH_ALEN);
+	return 0;
+}
+
+/*
+ * This function prepares command to set MAC multicast address.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting MAC multicast address
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action, void *data_buf)
+{
+	struct mwifiex_multicast_list *mcast_list =
+		(struct mwifiex_multicast_list *) data_buf;
+	struct host_cmd_ds_mac_multicast_adr *mcast_addr = &cmd->params.mc_addr;
+
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_mac_multicast_adr) +
+				S_DS_GEN);
+	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_MULTICAST_ADR);
+
+	mcast_addr->action = cpu_to_le16(cmd_action);
+	mcast_addr->num_of_adrs =
+		cpu_to_le16((u16) mcast_list->num_multicast_addr);
+	memcpy(mcast_addr->mac_list, mcast_list->mac_list,
+	       mcast_list->num_multicast_addr * ETH_ALEN);
+
+	return 0;
+}
+
+/*
+ * This function prepares command to deauthenticate.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Setting AP MAC address and reason code
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *cmd,
+					     void *data_buf)
+{
+	struct host_cmd_ds_802_11_deauthenticate *deauth = &cmd->params.deauth;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_DEAUTHENTICATE);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_deauthenticate)
+				+ S_DS_GEN);
+
+	/* Set AP MAC address */
+	memcpy(deauth->mac_addr, (u8 *) data_buf, ETH_ALEN);
+
+	dev_dbg(priv->adapter->dev, "cmd: Deauth: %pM\n", deauth->mac_addr);
+
+	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
+
+	return 0;
+}
+
+/*
+ * This function prepares command to stop Ad-Hoc network.
+ *
+ * Preparation includes -
+ *      - Setting command ID and proper size
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd)
+{
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_AD_HOC_STOP);
+	cmd->size = cpu_to_le16(S_DS_GEN);
+	return 0;
+}
+
+/*
+ * This function sets WEP key(s) to key parameter TLV(s).
+ *
+ * Multi-key parameter TLVs are supported, so we can send multiple
+ * WEP keys in a single buffer.
+ */
+static int
+mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
+			    struct mwifiex_ie_type_key_param_set *key_param_set,
+			    u16 *key_param_len)
+{
+	int cur_key_param_len = 0;
+	u8 i;
+
+	/* Multi-key_param_set TLV is supported */
+	for (i = 0; i < NUM_WEP_KEYS; i++) {
+		if ((priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP40) ||
+		    (priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP104)) {
+			key_param_set->type =
+				cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+/* Key_param_set WEP fixed length */
+#define KEYPARAMSET_WEP_FIXED_LEN 8
+			key_param_set->length = cpu_to_le16((u16)
+					(priv->wep_key[i].
+					 key_length +
+					 KEYPARAMSET_WEP_FIXED_LEN));
+			key_param_set->key_type_id =
+				cpu_to_le16(KEY_TYPE_ID_WEP);
+			key_param_set->key_info =
+				cpu_to_le16(KEY_INFO_WEP_ENABLED |
+					    KEY_INFO_WEP_UNICAST |
+					    KEY_INFO_WEP_MCAST);
+			key_param_set->key_len =
+				cpu_to_le16(priv->wep_key[i].key_length);
+			/* Set WEP key index */
+			key_param_set->key[0] = i;
+			/* Set default Tx key flag */
+			if (i ==
+			    (priv->
+			     wep_key_curr_index & HostCmd_WEP_KEY_INDEX_MASK))
+				key_param_set->key[1] = 1;
+			else
+				key_param_set->key[1] = 0;
+			memmove(&key_param_set->key[2],
+				priv->wep_key[i].key_material,
+				priv->wep_key[i].key_length);
+
+			cur_key_param_len = priv->wep_key[i].key_length +
+				KEYPARAMSET_WEP_FIXED_LEN +
+				sizeof(struct mwifiex_ie_types_header);
+			*key_param_len += (u16) cur_key_param_len;
+			key_param_set =
+				(struct mwifiex_ie_type_key_param_set *)
+						((u8 *)key_param_set +
+						cur_key_param_len);
+		} else if (!priv->wep_key[i].key_length) {
+			continue;
+		} else {
+			dev_err(priv->adapter->dev,
+				"key%d Length = %d is incorrect\n",
+			       (i + 1), priv->wep_key[i].key_length);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get/reset network key(s).
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting WEP keys, WAPI keys or WPA keys along with required
+ *        encryption (TKIP, AES) (as required)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *cmd,
+					   u16 cmd_action,
+					   u32 cmd_oid, void *data_buf)
+{
+	struct host_cmd_ds_802_11_key_material *key_material =
+		&cmd->params.key_material;
+	struct mwifiex_ds_encrypt_key *enc_key =
+		(struct mwifiex_ds_encrypt_key *) data_buf;
+	u16 key_param_len = 0;
+	int ret = 0;
+	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_KEY_MATERIAL);
+	key_material->action = cpu_to_le16(cmd_action);
+
+	if (cmd_action == HostCmd_ACT_GEN_GET) {
+		cmd->size =
+			cpu_to_le16(sizeof(key_material->action) + S_DS_GEN);
+		return ret;
+	}
+
+	if (!enc_key) {
+		memset(&key_material->key_param_set, 0,
+		       (NUM_WEP_KEYS *
+			sizeof(struct mwifiex_ie_type_key_param_set)));
+		ret = mwifiex_set_keyparamset_wep(priv,
+						  &key_material->key_param_set,
+						  &key_param_len);
+		cmd->size = cpu_to_le16(key_param_len +
+				    sizeof(key_material->action) + S_DS_GEN);
+		return ret;
+	} else
+		memset(&key_material->key_param_set, 0,
+		       sizeof(struct mwifiex_ie_type_key_param_set));
+	if (enc_key->is_wapi_key) {
+		dev_dbg(priv->adapter->dev, "info: Set WAPI Key\n");
+		key_material->key_param_set.key_type_id =
+			cpu_to_le16(KEY_TYPE_ID_WAPI);
+		if (cmd_oid == KEY_INFO_ENABLED)
+			key_material->key_param_set.key_info =
+				cpu_to_le16(KEY_INFO_WAPI_ENABLED);
+		else
+			key_material->key_param_set.key_info =
+				cpu_to_le16(!KEY_INFO_WAPI_ENABLED);
+
+		key_material->key_param_set.key[0] = enc_key->key_index;
+		if (!priv->sec_info.wapi_key_on)
+			key_material->key_param_set.key[1] = 1;
+		else
+			/* set 0 when re-key */
+			key_material->key_param_set.key[1] = 0;
+
+		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac))) {
+			/* WAPI pairwise key: unicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_WAPI_UNICAST);
+		} else {	/* WAPI group key: multicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_WAPI_MCAST);
+			priv->sec_info.wapi_key_on = true;
+		}
+
+		key_material->key_param_set.type =
+			cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+		key_material->key_param_set.key_len =
+			cpu_to_le16(WAPI_KEY_LEN);
+		memcpy(&key_material->key_param_set.key[2],
+		       enc_key->key_material, enc_key->key_len);
+		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
+		       enc_key->wapi_rxpn, WAPI_RXPN_LEN);
+		key_material->key_param_set.length =
+			cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
+
+		key_param_len = (WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN) +
+				 sizeof(struct mwifiex_ie_types_header);
+		cmd->size = cpu_to_le16(key_param_len +
+				sizeof(key_material->action) + S_DS_GEN);
+		return ret;
+	}
+	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
+		dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
+		key_material->key_param_set.key_type_id =
+			cpu_to_le16(KEY_TYPE_ID_AES);
+		if (cmd_oid == KEY_INFO_ENABLED)
+			key_material->key_param_set.key_info =
+				cpu_to_le16(KEY_INFO_AES_ENABLED);
+		else
+			key_material->key_param_set.key_info =
+				cpu_to_le16(!KEY_INFO_AES_ENABLED);
+
+		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
+				/* AES pairwise key: unicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_AES_UNICAST);
+		else		/* AES group key: multicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_AES_MCAST);
+	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
+		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
+		key_material->key_param_set.key_type_id =
+			cpu_to_le16(KEY_TYPE_ID_TKIP);
+		key_material->key_param_set.key_info =
+			cpu_to_le16(KEY_INFO_TKIP_ENABLED);
+
+		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
+				/* TKIP pairwise key: unicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_TKIP_UNICAST);
+		else		/* TKIP group key: multicast */
+			key_material->key_param_set.key_info |=
+				cpu_to_le16(KEY_INFO_TKIP_MCAST);
+	}
+
+	if (key_material->key_param_set.key_type_id) {
+		key_material->key_param_set.type =
+			cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
+		key_material->key_param_set.key_len =
+			cpu_to_le16((u16) enc_key->key_len);
+		memcpy(key_material->key_param_set.key, enc_key->key_material,
+		       enc_key->key_len);
+		key_material->key_param_set.length =
+			cpu_to_le16((u16) enc_key->key_len +
+				    KEYPARAMSET_FIXED_LEN);
+
+		key_param_len = (u16) (enc_key->key_len + KEYPARAMSET_FIXED_LEN)
+				      + sizeof(struct mwifiex_ie_types_header);
+
+		cmd->size = cpu_to_le16(key_param_len +
+				    sizeof(key_material->action) + S_DS_GEN);
+	}
+
+	return ret;
+}
+
+/*
+ * This function prepares command to set/get 11d domain information.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting domain information fields (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *cmd,
+					   u16 cmd_action)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11d_domain_info *domain_info =
+		&cmd->params.domain_info;
+	struct mwifiex_ietypes_domain_param_set *domain =
+		&domain_info->domain;
+	u8 no_of_triplet = adapter->domain_reg.no_of_triplet;
+
+	dev_dbg(adapter->dev, "info: 11D: no_of_triplet=0x%x\n", no_of_triplet);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
+	domain_info->action = cpu_to_le16(cmd_action);
+	if (cmd_action == HostCmd_ACT_GEN_GET) {
+		cmd->size = cpu_to_le16(sizeof(domain_info->action) + S_DS_GEN);
+		return 0;
+	}
+
+	/* Set domain info fields */
+	domain->header.type = cpu_to_le16(WLAN_EID_COUNTRY);
+	memcpy(domain->country_code, adapter->domain_reg.country_code,
+			sizeof(domain->country_code));
+
+	domain->header.len = cpu_to_le16((no_of_triplet *
+				sizeof(struct ieee80211_country_ie_triplet)) +
+				sizeof(domain->country_code));
+
+	if (no_of_triplet) {
+		memcpy(domain->triplet, adapter->domain_reg.triplet,
+				no_of_triplet *
+				sizeof(struct ieee80211_country_ie_triplet));
+
+		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
+				le16_to_cpu(domain->header.len) +
+				sizeof(struct mwifiex_ie_types_header)
+				+ S_DS_GEN);
+	} else {
+		cmd->size = cpu_to_le16(sizeof(domain_info->action) + S_DS_GEN);
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get RF channel.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting RF type and current RF channel (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_802_11_rf_channel *rf_chan =
+		&cmd->params.rf_channel;
+	uint16_t rf_type = le16_to_cpu(rf_chan->rf_type);
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_CHANNEL);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_channel)
+				+ S_DS_GEN);
+
+	if (cmd_action == HostCmd_ACT_GEN_SET) {
+		if ((priv->adapter->adhoc_start_band & BAND_A)
+		    || (priv->adapter->adhoc_start_band & BAND_AN))
+			rf_chan->rf_type =
+				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
+
+		rf_type = le16_to_cpu(rf_chan->rf_type);
+		SET_SECONDARYCHAN(rf_type, priv->adapter->chan_offset);
+		rf_chan->current_channel = cpu_to_le16(*((u16 *) data_buf));
+	}
+	rf_chan->action = cpu_to_le16(cmd_action);
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get IBSS coalescing status.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting status to enable or disable (for SET only)
+ *      - Ensuring correct endian-ness
+ */
+static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *cmd,
+					      u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_802_11_ibss_status *ibss_coal =
+		&(cmd->params.ibss_coalescing);
+	u16 enable = 0;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_IBSS_COALESCING_STATUS);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_ibss_status) +
+				S_DS_GEN);
+	cmd->result = 0;
+	ibss_coal->action = cpu_to_le16(cmd_action);
+
+	switch (cmd_action) {
+	case HostCmd_ACT_GEN_SET:
+		if (data_buf != NULL)
+			enable = *(u16 *) data_buf;
+		ibss_coal->enable = cpu_to_le16(enable);
+		break;
+
+		/* In other case.. Nothing to do */
+	case HostCmd_ACT_GEN_GET:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares command to set/get register value.
+ *
+ * Preparation includes -
+ *      - Setting command ID, action and proper size
+ *      - Setting register offset (for both GET and SET) and
+ *        register value (for SET only)
+ *      - Ensuring correct endian-ness
+ *
+ * The following type of registers can be accessed with this function -
+ *      - MAC register
+ *      - BBP register
+ *      - RF register
+ *      - PMIC register
+ *      - CAU register
+ *      - EEPROM
+ */
+static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
+				  u16 cmd_action, void *data_buf)
+{
+	struct mwifiex_ds_reg_rw *reg_rw;
+
+	reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
+	switch (le16_to_cpu(cmd->command)) {
+	case HostCmd_CMD_MAC_REG_ACCESS:
+	{
+		struct host_cmd_ds_mac_reg_access *mac_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*mac_reg) + S_DS_GEN);
+		mac_reg = (struct host_cmd_ds_mac_reg_access *) &cmd->
+			params.mac_reg;
+		mac_reg->action = cpu_to_le16(cmd_action);
+		mac_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		mac_reg->value = reg_rw->value;
+		break;
+	}
+	case HostCmd_CMD_BBP_REG_ACCESS:
+	{
+		struct host_cmd_ds_bbp_reg_access *bbp_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*bbp_reg) + S_DS_GEN);
+		bbp_reg = (struct host_cmd_ds_bbp_reg_access *) &cmd->
+			params.bbp_reg;
+		bbp_reg->action = cpu_to_le16(cmd_action);
+		bbp_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		bbp_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
+	case HostCmd_CMD_RF_REG_ACCESS:
+	{
+		struct host_cmd_ds_rf_reg_access *rf_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*rf_reg) + S_DS_GEN);
+		rf_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
+			params.rf_reg;
+		rf_reg->action = cpu_to_le16(cmd_action);
+		rf_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		rf_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
+	case HostCmd_CMD_PMIC_REG_ACCESS:
+	{
+		struct host_cmd_ds_pmic_reg_access *pmic_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*pmic_reg) + S_DS_GEN);
+		pmic_reg = (struct host_cmd_ds_pmic_reg_access *) &cmd->
+				params.pmic_reg;
+		pmic_reg->action = cpu_to_le16(cmd_action);
+		pmic_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		pmic_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
+	case HostCmd_CMD_CAU_REG_ACCESS:
+	{
+		struct host_cmd_ds_rf_reg_access *cau_reg;
+
+		cmd->size = cpu_to_le16(sizeof(*cau_reg) + S_DS_GEN);
+		cau_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
+				params.rf_reg;
+		cau_reg->action = cpu_to_le16(cmd_action);
+		cau_reg->offset =
+			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
+		cau_reg->value = (u8) le32_to_cpu(reg_rw->value);
+		break;
+	}
+	case HostCmd_CMD_802_11_EEPROM_ACCESS:
+	{
+		struct mwifiex_ds_read_eeprom *rd_eeprom =
+			(struct mwifiex_ds_read_eeprom *) data_buf;
+		struct host_cmd_ds_802_11_eeprom_access *cmd_eeprom =
+			(struct host_cmd_ds_802_11_eeprom_access *)
+			&cmd->params.eeprom;
+
+		cmd->size = cpu_to_le16(sizeof(*cmd_eeprom) + S_DS_GEN);
+		cmd_eeprom->action = cpu_to_le16(cmd_action);
+		cmd_eeprom->offset = rd_eeprom->offset;
+		cmd_eeprom->byte_count = rd_eeprom->byte_count;
+		cmd_eeprom->value = 0;
+		break;
+	}
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function prepares the commands before sending them to the firmware.
+ *
+ * This is a generic function which calls specific command preparation
+ * routines based upon the command number.
+ */
+int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf)
+{
+	struct host_cmd_ds_command *cmd_ptr =
+		(struct host_cmd_ds_command *) cmd_buf;
+	int ret = 0;
+
+	/* Prepare command */
+	switch (cmd_no) {
+	case HostCmd_CMD_GET_HW_SPEC:
+		ret = mwifiex_cmd_get_hw_spec(priv, cmd_ptr);
+		break;
+	case HostCmd_CMD_MAC_CONTROL:
+		ret = mwifiex_cmd_mac_control(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
+	case HostCmd_CMD_802_11_MAC_ADDRESS:
+		ret = mwifiex_cmd_802_11_mac_address(priv, cmd_ptr,
+						     cmd_action);
+		break;
+	case HostCmd_CMD_MAC_MULTICAST_ADR:
+		ret = mwifiex_cmd_mac_multicast_adr(priv, cmd_ptr, cmd_action,
+						    data_buf);
+		break;
+	case HostCmd_CMD_TX_RATE_CFG:
+		ret = mwifiex_cmd_tx_rate_cfg(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
+	case HostCmd_CMD_TXPWR_CFG:
+		ret = mwifiex_cmd_tx_power_cfg(priv, cmd_ptr, cmd_action,
+					       data_buf);
+		break;
+	case HostCmd_CMD_802_11_PS_MODE_ENH:
+		ret = mwifiex_cmd_enh_power_mode(priv, cmd_ptr, cmd_action,
+						 (uint16_t)cmd_oid, data_buf);
+		break;
+	case HostCmd_CMD_802_11_HS_CFG_ENH:
+		ret = mwifiex_cmd_802_11_hs_cfg(priv, cmd_ptr, cmd_action,
+				(struct mwifiex_hs_config_param *) data_buf);
+		break;
+	case HostCmd_CMD_802_11_SCAN:
+		ret = mwifiex_cmd_802_11_scan(priv, cmd_ptr, data_buf);
+		break;
+	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
+		ret = mwifiex_cmd_802_11_bg_scan_query(priv, cmd_ptr,
+						       data_buf);
+		break;
+	case HostCmd_CMD_802_11_ASSOCIATE:
+		ret = mwifiex_cmd_802_11_associate(priv, cmd_ptr, data_buf);
+		break;
+	case HostCmd_CMD_802_11_DEAUTHENTICATE:
+		ret = mwifiex_cmd_802_11_deauthenticate(priv, cmd_ptr,
+							data_buf);
+		break;
+	case HostCmd_CMD_802_11_AD_HOC_START:
+		ret = mwifiex_cmd_802_11_ad_hoc_start(priv, cmd_ptr,
+						      data_buf);
+		break;
+	case HostCmd_CMD_802_11_GET_LOG:
+		ret = mwifiex_cmd_802_11_get_log(priv, cmd_ptr);
+		break;
+	case HostCmd_CMD_802_11_AD_HOC_JOIN:
+		ret = mwifiex_cmd_802_11_ad_hoc_join(priv, cmd_ptr,
+						     data_buf);
+		break;
+	case HostCmd_CMD_802_11_AD_HOC_STOP:
+		ret = mwifiex_cmd_802_11_ad_hoc_stop(priv, cmd_ptr);
+		break;
+	case HostCmd_CMD_RSSI_INFO:
+		ret = mwifiex_cmd_802_11_rssi_info(priv, cmd_ptr, cmd_action);
+		break;
+	case HostCmd_CMD_802_11_SNMP_MIB:
+		ret = mwifiex_cmd_802_11_snmp_mib(priv, cmd_ptr, cmd_action,
+						  cmd_oid, data_buf);
+		break;
+	case HostCmd_CMD_802_11_TX_RATE_QUERY:
+		cmd_ptr->command =
+			cpu_to_le16(HostCmd_CMD_802_11_TX_RATE_QUERY);
+		cmd_ptr->size =
+			cpu_to_le16(sizeof(struct host_cmd_ds_tx_rate_query) +
+				    S_DS_GEN);
+		priv->tx_rate = 0;
+		ret = 0;
+		break;
+	case HostCmd_CMD_VERSION_EXT:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->params.verext.version_str_sel =
+			(u8) (*((u32 *) data_buf));
+		memcpy(&cmd_ptr->params, data_buf,
+		       sizeof(struct host_cmd_ds_version_ext));
+		cmd_ptr->size =
+			cpu_to_le16(sizeof(struct host_cmd_ds_version_ext) +
+				    S_DS_GEN);
+		ret = 0;
+		break;
+	case HostCmd_CMD_802_11_RF_CHANNEL:
+		ret = mwifiex_cmd_802_11_rf_channel(priv, cmd_ptr, cmd_action,
+						    data_buf);
+		break;
+	case HostCmd_CMD_FUNC_INIT:
+		if (priv->adapter->hw_status == MWIFIEX_HW_STATUS_RESET)
+			priv->adapter->hw_status = MWIFIEX_HW_STATUS_READY;
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
+		break;
+	case HostCmd_CMD_FUNC_SHUTDOWN:
+		priv->adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		cmd_ptr->size = cpu_to_le16(S_DS_GEN);
+		break;
+	case HostCmd_CMD_11N_ADDBA_REQ:
+		ret = mwifiex_cmd_11n_addba_req(priv, cmd_ptr, data_buf);
+		break;
+	case HostCmd_CMD_11N_DELBA:
+		ret = mwifiex_cmd_11n_delba(priv, cmd_ptr, data_buf);
+		break;
+	case HostCmd_CMD_11N_ADDBA_RSP:
+		ret = mwifiex_cmd_11n_addba_rsp_gen(priv, cmd_ptr, data_buf);
+		break;
+	case HostCmd_CMD_802_11_KEY_MATERIAL:
+		ret = mwifiex_cmd_802_11_key_material(priv, cmd_ptr,
+						cmd_action, cmd_oid,
+						data_buf);
+		break;
+	case HostCmd_CMD_802_11D_DOMAIN_INFO:
+		ret = mwifiex_cmd_802_11d_domain_info(priv, cmd_ptr,
+						cmd_action);
+		break;
+	case HostCmd_CMD_RECONFIGURE_TX_BUFF:
+		ret = mwifiex_cmd_recfg_tx_buf(priv, cmd_ptr, cmd_action,
+					       data_buf);
+		break;
+	case HostCmd_CMD_AMSDU_AGGR_CTRL:
+		ret = mwifiex_cmd_amsdu_aggr_ctrl(priv, cmd_ptr, cmd_action,
+						  data_buf);
+		break;
+	case HostCmd_CMD_11N_CFG:
+		ret = mwifiex_cmd_11n_cfg(priv, cmd_ptr, cmd_action,
+					  data_buf);
+		break;
+	case HostCmd_CMD_WMM_GET_STATUS:
+		dev_dbg(priv->adapter->dev,
+			"cmd: WMM: WMM_GET_STATUS cmd sent\n");
+		cmd_ptr->command = cpu_to_le16(HostCmd_CMD_WMM_GET_STATUS);
+		cmd_ptr->size =
+			cpu_to_le16(sizeof(struct host_cmd_ds_wmm_get_status) +
+				    S_DS_GEN);
+		ret = 0;
+		break;
+	case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
+		ret = mwifiex_cmd_ibss_coalescing_status(priv, cmd_ptr,
+							 cmd_action, data_buf);
+		break;
+	case HostCmd_CMD_MAC_REG_ACCESS:
+	case HostCmd_CMD_BBP_REG_ACCESS:
+	case HostCmd_CMD_RF_REG_ACCESS:
+	case HostCmd_CMD_PMIC_REG_ACCESS:
+	case HostCmd_CMD_CAU_REG_ACCESS:
+	case HostCmd_CMD_802_11_EEPROM_ACCESS:
+		ret = mwifiex_cmd_reg_access(cmd_ptr, cmd_action, data_buf);
+		break;
+	case HostCmd_CMD_SET_BSS_MODE:
+		cmd_ptr->command = cpu_to_le16(cmd_no);
+		if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
+			cmd_ptr->params.bss_mode.con_type =
+				CONNECTION_TYPE_ADHOC;
+		else if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
+			cmd_ptr->params.bss_mode.con_type =
+				CONNECTION_TYPE_INFRA;
+		cmd_ptr->size = cpu_to_le16(sizeof(struct
+				host_cmd_ds_set_bss_mode) + S_DS_GEN);
+		ret = 0;
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
+		ret = -1;
+		break;
+	}
+	return ret;
+}
+
+/*
+ * This function issues commands to initialize firmware.
+ *
+ * This is called after firmware download to bring the card to
+ * working state.
+ *
+ * The following commands are issued sequentially -
+ *      - Function init (for first interface only)
+ *      - Read MAC address (for first interface only)
+ *      - Reconfigure Tx buffer size (for first interface only)
+ *      - Enable auto deep sleep (for first interface only)
+ *      - Get Tx rate
+ *      - Get Tx power
+ *      - Set IBSS coalescing status
+ *      - Set AMSDU aggregation control
+ *      - Set 11d control
+ *      - Set MAC control (this must be the last command to initialize firmware)
+ */
+int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
+{
+	int ret = 0;
+	u16 enable = true;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
+	struct mwifiex_ds_auto_ds auto_ds;
+	enum state_11d_t state_11d;
+
+	if (first_sta) {
+
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
+					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+		if (ret)
+			return -1;
+		/* Read MAC address from HW */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
+					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+		if (ret)
+			return -1;
+
+		/* Reconfigure tx buf size */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
+					  HostCmd_ACT_GEN_SET, 0, NULL,
+					  &priv->adapter->tx_buf_size);
+		if (ret)
+			return -1;
+
+		/* Enable IEEE PS by default */
+		priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					  EN_AUTO_PS, BITMAP_STA_PS, NULL,
+					  NULL);
+		if (ret)
+			return -1;
+	}
+
+	/* get tx rate */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+	if (ret)
+		return -1;
+	priv->data_rate = 0;
+
+	/* get tx power */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
+				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+	if (ret)
+		return -1;
+
+	/* set ibss coalescing_status */
+	ret = mwifiex_prepare_cmd(priv,
+				  HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				  HostCmd_ACT_GEN_SET, 0, NULL, &enable);
+	if (ret)
+		return -1;
+
+	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
+	amsdu_aggr_ctrl.enable = true;
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
+				  HostCmd_ACT_GEN_SET, 0, NULL,
+				  (void *) &amsdu_aggr_ctrl);
+	if (ret)
+		return -1;
+	/* MAC Control must be the last command in init_fw */
+	/* set MAC Control */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				  HostCmd_ACT_GEN_SET, 0, NULL,
+				  &priv->curr_pkt_filter);
+	if (ret)
+		return -1;
+
+	if (first_sta) {
+		/* Enable auto deep sleep */
+		auto_ds.auto_ds = DEEP_SLEEP_ON;
+		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
+		ret = mwifiex_prepare_cmd(priv,
+				HostCmd_CMD_802_11_PS_MODE_ENH,
+				EN_AUTO_PS, BITMAP_AUTO_DS, NULL,
+				&auto_ds);
+		if (ret)
+			return -1;
+	}
+
+	/* Send cmd to FW to enable/disable 11D function */
+	state_11d = ENABLE_11D;
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				  HostCmd_ACT_GEN_SET, DOT11D_I,
+				  NULL, &state_11d);
+	if (ret)
+		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
+
+	/* set last_init_cmd */
+	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
+	ret = -EINPROGRESS;
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
new file mode 100644
index 0000000..ae960dd
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -0,0 +1,986 @@
+/*
+ * Marvell Wireless LAN device driver: station command response handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+
+/*
+ * This function handles the command response error case.
+ *
+ * For scan response error, the function cancels all the pending
+ * scan commands and generates an event to inform the applications
+ * of the scan completion.
+ *
+ * For Power Save command failure, we do not retry enter PS
+ * command in case of Ad-hoc mode.
+ *
+ * For all other response errors, the current command buffer is freed
+ * and returned to the free command queue.
+ */
+static void
+mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp,
+			      struct mwifiex_wait_queue *wq_buf)
+{
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
+
+	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
+			resp->command, resp->result);
+	if (wq_buf)
+		wq_buf->status = MWIFIEX_ERROR_FW_CMDRESP;
+
+	switch (le16_to_cpu(resp->command)) {
+	case HostCmd_CMD_802_11_PS_MODE_ENH:
+		{
+			struct host_cmd_ds_802_11_ps_mode_enh *pm =
+				&resp->params.psmode_enh;
+			dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
+				"result=0x%x action=0x%X\n",
+				resp->result, le16_to_cpu(pm->action));
+			/* We do not re-try enter-ps command in ad-hoc mode. */
+			if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
+				(le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
+				 BITMAP_STA_PS)
+				&& priv->bss_mode == MWIFIEX_BSS_MODE_IBSS)
+				adapter->ps_mode =
+					MWIFIEX_802_11_POWER_MODE_CAM;
+		}
+		break;
+	case HostCmd_CMD_802_11_SCAN:
+		/* Cancel all pending scan command */
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		}
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		if (priv->report_scan_result)
+			priv->report_scan_result = false;
+		if (priv->scan_pending_on_block) {
+			priv->scan_pending_on_block = false;
+			up(&priv->async_sem);
+		}
+		break;
+
+	case HostCmd_CMD_MAC_CONTROL:
+		break;
+
+	default:
+		break;
+	}
+	/* Handling errors here */
+	mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->curr_cmd = NULL;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+	return;
+}
+
+/*
+ * This function handles the command response of get RSSI info.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the following parameters in driver -
+ *      - Last data and beacon RSSI value
+ *      - Average data and beacon RSSI value
+ *      - Last data and beacon NF value
+ *      - Average data and beacon NF value
+ *
+ * The parameters are send to the application as well, along with
+ * calculated SNR values.
+ */
+static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
+					struct host_cmd_ds_command *resp,
+					void *data_buf)
+{
+	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
+		&resp->params.rssi_info_rsp;
+	struct mwifiex_ds_get_signal *signal = NULL;
+
+	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
+	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
+
+	priv->data_rssi_avg = le16_to_cpu(rssi_info_rsp->data_rssi_avg);
+	priv->data_nf_avg = le16_to_cpu(rssi_info_rsp->data_nf_avg);
+
+	priv->bcn_rssi_last = le16_to_cpu(rssi_info_rsp->bcn_rssi_last);
+	priv->bcn_nf_last = le16_to_cpu(rssi_info_rsp->bcn_nf_last);
+
+	priv->bcn_rssi_avg = le16_to_cpu(rssi_info_rsp->bcn_rssi_avg);
+	priv->bcn_nf_avg = le16_to_cpu(rssi_info_rsp->bcn_nf_avg);
+
+	/* Need to indicate IOCTL complete */
+	if (data_buf) {
+		signal = (struct mwifiex_ds_get_signal *) data_buf;
+		memset(signal, 0, sizeof(struct mwifiex_ds_get_signal));
+
+		signal->selector = ALL_RSSI_INFO_MASK;
+
+		/* RSSI */
+		signal->bcn_rssi_last = priv->bcn_rssi_last;
+		signal->bcn_rssi_avg = priv->bcn_rssi_avg;
+		signal->data_rssi_last = priv->data_rssi_last;
+		signal->data_rssi_avg = priv->data_rssi_avg;
+
+		/* SNR */
+		signal->bcn_snr_last =
+			CAL_SNR(priv->bcn_rssi_last, priv->bcn_nf_last);
+		signal->bcn_snr_avg =
+			CAL_SNR(priv->bcn_rssi_avg, priv->bcn_nf_avg);
+		signal->data_snr_last =
+			CAL_SNR(priv->data_rssi_last, priv->data_nf_last);
+		signal->data_snr_avg =
+			CAL_SNR(priv->data_rssi_avg, priv->data_nf_avg);
+
+		/* NF */
+		signal->bcn_nf_last = priv->bcn_nf_last;
+		signal->bcn_nf_avg = priv->bcn_nf_avg;
+		signal->data_nf_last = priv->data_nf_last;
+		signal->data_nf_avg = priv->data_nf_avg;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get SNMP
+ * MIB parameters.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the parameter in driver.
+ *
+ * The following parameters are supported -
+ *      - Fragmentation threshold
+ *      - RTS threshold
+ *      - Short retry limit
+ */
+static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *resp,
+				       void *data_buf)
+{
+	struct host_cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
+	u16 oid = le16_to_cpu(smib->oid);
+	u16 query_type = le16_to_cpu(smib->query_type);
+	u32 ul_temp;
+
+	dev_dbg(priv->adapter->dev, "info: SNMP_RESP: oid value = %#x,"
+			" query_type = %#x, buf size = %#x\n",
+			oid, query_type, le16_to_cpu(smib->buf_size));
+	if (query_type == HostCmd_ACT_GEN_GET) {
+		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
+		if (data_buf)
+			*(u32 *)data_buf = ul_temp;
+		switch (oid) {
+		case FRAG_THRESH_I:
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: FragThsd =%u\n", ul_temp);
+			break;
+		case RTS_THRESH_I:
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: RTSThsd =%u\n", ul_temp);
+			break;
+		case SHORT_RETRY_LIM_I:
+			dev_dbg(priv->adapter->dev,
+				"info: SNMP_RESP: TxRetryCount=%u\n", ul_temp);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of get log request
+ *
+ * Handling includes changing the header fields into CPU format
+ * and sending the received parameters to application.
+ */
+static int mwifiex_ret_get_log(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
+{
+	struct host_cmd_ds_802_11_get_log *get_log =
+		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
+	struct mwifiex_ds_get_stats *stats = NULL;
+
+	if (data_buf) {
+		stats = (struct mwifiex_ds_get_stats *) data_buf;
+		stats->mcast_tx_frame = le32_to_cpu(get_log->mcast_tx_frame);
+		stats->failed = le32_to_cpu(get_log->failed);
+		stats->retry = le32_to_cpu(get_log->retry);
+		stats->multi_retry = le32_to_cpu(get_log->multi_retry);
+		stats->frame_dup = le32_to_cpu(get_log->frame_dup);
+		stats->rts_success = le32_to_cpu(get_log->rts_success);
+		stats->rts_failure = le32_to_cpu(get_log->rts_failure);
+		stats->ack_failure = le32_to_cpu(get_log->ack_failure);
+		stats->rx_frag = le32_to_cpu(get_log->rx_frag);
+		stats->mcast_rx_frame = le32_to_cpu(get_log->mcast_rx_frame);
+		stats->fcs_error = le32_to_cpu(get_log->fcs_error);
+		stats->tx_frame = le32_to_cpu(get_log->tx_frame);
+		stats->wep_icv_error[0] =
+			le32_to_cpu(get_log->wep_icv_err_cnt[0]);
+		stats->wep_icv_error[1] =
+			le32_to_cpu(get_log->wep_icv_err_cnt[1]);
+		stats->wep_icv_error[2] =
+			le32_to_cpu(get_log->wep_icv_err_cnt[2]);
+		stats->wep_icv_error[3] =
+			le32_to_cpu(get_log->wep_icv_err_cnt[3]);
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get Tx rate
+ * configurations.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the following parameters in driver -
+ *      - DSSS rate bitmap
+ *      - OFDM rate bitmap
+ *      - HT MCS rate bitmaps
+ *
+ * Based on the new rate bitmaps, the function re-evaluates if
+ * auto data rate has been activated. If not, it sends another
+ * query to the firmware to get the current Tx data rate and updates
+ * the driver value.
+ */
+static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *resp,
+				   void *data_buf)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_rate_cfg *ds_rate = NULL;
+	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
+	struct mwifiex_rate_scope *rate_scope;
+	struct mwifiex_ie_types_header *head = NULL;
+	u16 tlv, tlv_buf_len;
+	u8 *tlv_buf;
+	u32 i;
+	int ret = 0;
+
+	tlv_buf = (u8 *) ((u8 *) rate_cfg) +
+			sizeof(struct host_cmd_ds_tx_rate_cfg);
+	tlv_buf_len = *(u16 *) (tlv_buf + sizeof(u16));
+
+	while (tlv_buf && tlv_buf_len > 0) {
+		tlv = (*tlv_buf);
+		tlv = tlv | (*(tlv_buf + 1) << 8);
+
+		switch (tlv) {
+		case TLV_TYPE_RATE_SCOPE:
+			rate_scope = (struct mwifiex_rate_scope *) tlv_buf;
+			priv->bitmap_rates[0] =
+				le16_to_cpu(rate_scope->hr_dsss_rate_bitmap);
+			priv->bitmap_rates[1] =
+				le16_to_cpu(rate_scope->ofdm_rate_bitmap);
+			for (i = 0;
+			     i <
+			     sizeof(rate_scope->ht_mcs_rate_bitmap) /
+			     sizeof(u16); i++)
+				priv->bitmap_rates[2 + i] =
+					le16_to_cpu(rate_scope->
+						    ht_mcs_rate_bitmap[i]);
+			break;
+			/* Add RATE_DROP tlv here */
+		}
+
+		head = (struct mwifiex_ie_types_header *) tlv_buf;
+		tlv_buf += le16_to_cpu(head->len) + sizeof(*head);
+		tlv_buf_len -= le16_to_cpu(head->len);
+	}
+
+	priv->is_data_rate_auto = mwifiex_is_rate_auto(priv);
+
+	if (priv->is_data_rate_auto)
+		priv->data_rate = 0;
+	else
+		ret = mwifiex_prepare_cmd(priv,
+					  HostCmd_CMD_802_11_TX_RATE_QUERY,
+					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+
+	if (data_buf) {
+		ds_rate = (struct mwifiex_rate_cfg *) data_buf;
+		if (le16_to_cpu(rate_cfg->action) == HostCmd_ACT_GEN_GET) {
+			if (priv->is_data_rate_auto) {
+				ds_rate->is_rate_auto = 1;
+			} else {
+				ds_rate->rate =
+					mwifiex_get_rate_index(adapter,
+							       priv->
+							       bitmap_rates,
+							       sizeof(priv->
+							       bitmap_rates));
+				if (ds_rate->rate >=
+				    MWIFIEX_RATE_BITMAP_OFDM0
+				    && ds_rate->rate <=
+				    MWIFIEX_RATE_BITMAP_OFDM7)
+					ds_rate->rate -=
+						(MWIFIEX_RATE_BITMAP_OFDM0 -
+						 MWIFIEX_RATE_INDEX_OFDM0);
+				if (ds_rate->rate >=
+				    MWIFIEX_RATE_BITMAP_MCS0
+				    && ds_rate->rate <=
+				    MWIFIEX_RATE_BITMAP_MCS127)
+					ds_rate->rate -=
+						(MWIFIEX_RATE_BITMAP_MCS0 -
+						 MWIFIEX_RATE_INDEX_MCS0);
+			}
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * This function handles the command response of get Tx power level.
+ *
+ * Handling includes saving the maximum and minimum Tx power levels
+ * in driver, as well as sending the values to user.
+ */
+static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
+{
+	int length = -1, max_power = -1, min_power = -1;
+	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
+	struct mwifiex_power_group *pg = NULL;
+
+	if (data_buf) {
+		pg_tlv_hdr =
+			(struct mwifiex_types_power_group *) ((u8 *) data_buf
+					+ sizeof(struct host_cmd_ds_txpwr_cfg));
+		pg = (struct mwifiex_power_group *) ((u8 *) pg_tlv_hdr +
+				sizeof(struct mwifiex_types_power_group));
+		length = pg_tlv_hdr->length;
+		if (length > 0) {
+			max_power = pg->power_max;
+			min_power = pg->power_min;
+			length -= sizeof(struct mwifiex_power_group);
+		}
+		while (length) {
+			pg++;
+			if (max_power < pg->power_max)
+				max_power = pg->power_max;
+
+			if (min_power > pg->power_min)
+				min_power = pg->power_min;
+
+			length -= sizeof(struct mwifiex_power_group);
+		}
+		if (pg_tlv_hdr->length > 0) {
+			priv->min_tx_power_level = (u8) min_power;
+			priv->max_tx_power_level = (u8) max_power;
+		}
+	} else {
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get Tx power
+ * configurations.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the current Tx power level in driver.
+ */
+static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *resp,
+				    void *data_buf)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_txpwr_cfg *txp_cfg = &resp->params.txp_cfg;
+	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
+	struct mwifiex_power_group *pg = NULL;
+	u16 action = le16_to_cpu(txp_cfg->action);
+
+	switch (action) {
+	case HostCmd_ACT_GEN_GET:
+		{
+			pg_tlv_hdr =
+				(struct mwifiex_types_power_group *) ((u8 *)
+						txp_cfg +
+						sizeof
+						(struct
+						 host_cmd_ds_txpwr_cfg));
+			pg = (struct mwifiex_power_group *) ((u8 *)
+						pg_tlv_hdr +
+						sizeof(struct
+						mwifiex_types_power_group));
+			if (adapter->hw_status ==
+			    MWIFIEX_HW_STATUS_INITIALIZING)
+				mwifiex_get_power_level(priv, txp_cfg);
+			priv->tx_power_level = (u16) pg->power_min;
+			break;
+		}
+	case HostCmd_ACT_GEN_SET:
+		if (le32_to_cpu(txp_cfg->mode)) {
+			pg_tlv_hdr =
+				(struct mwifiex_types_power_group *) ((u8 *)
+						txp_cfg +
+						sizeof
+						(struct
+						 host_cmd_ds_txpwr_cfg));
+			pg = (struct mwifiex_power_group *) ((u8 *) pg_tlv_hdr
+						+
+						sizeof(struct
+						mwifiex_types_power_group));
+			if (pg->power_max == pg->power_min)
+				priv->tx_power_level = (u16) pg->power_min;
+		}
+		break;
+	default:
+		dev_err(adapter->dev, "CMD_RESP: unknown cmd action %d\n",
+				action);
+		return 0;
+	}
+	dev_dbg(adapter->dev,
+		"info: Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
+	       priv->tx_power_level, priv->max_tx_power_level,
+	       priv->min_tx_power_level);
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get MAC address.
+ *
+ * Handling includes saving the MAC address in driver.
+ */
+static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
+		&resp->params.mac_addr;
+
+	memcpy(priv->curr_addr, cmd_mac_addr->mac_addr, ETH_ALEN);
+
+	dev_dbg(priv->adapter->dev,
+		"info: set mac address: %pM\n", priv->curr_addr);
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get MAC multicast
+ * address.
+ */
+static int mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *resp)
+{
+	return 0;
+}
+
+/*
+ * This function handles the command response of get Tx rate query.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the Tx rate and HT information parameters in driver.
+ *
+ * Both rate configuration and current data rate can be retrieved
+ * with this request.
+ */
+static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
+					    struct host_cmd_ds_command *resp)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	priv->tx_rate = resp->params.tx_rate.tx_rate;
+	priv->tx_htinfo = resp->params.tx_rate.ht_info;
+	if (!priv->is_data_rate_auto)
+		priv->data_rate =
+			mwifiex_index_to_data_rate(adapter, priv->tx_rate,
+						   priv->tx_htinfo);
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of a deauthenticate
+ * command.
+ *
+ * If the deauthenticated MAC matches the current BSS MAC, the connection
+ * state is reset.
+ */
+static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *resp)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	adapter->dbg.num_cmd_deauth++;
+	if (!memcmp(resp->params.deauth.mac_addr,
+		    &priv->curr_bss_params.bss_descriptor.mac_address,
+		    sizeof(resp->params.deauth.mac_addr)))
+		mwifiex_reset_connect_state(priv);
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of ad-hoc stop.
+ *
+ * The function resets the connection state in driver.
+ */
+static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *resp)
+{
+	mwifiex_reset_connect_state(priv);
+	return 0;
+}
+
+/*
+ * This function handles the command response of set/get key material.
+ *
+ * Handling includes updating the driver parameters to reflect the
+ * changes.
+ */
+static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_802_11_key_material *key =
+		&resp->params.key_material;
+
+	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
+		if ((le16_to_cpu(key->key_param_set.key_info) &
+		     KEY_INFO_TKIP_MCAST)) {
+			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
+			priv->wpa_is_gtk_set = true;
+			priv->scan_block = false;
+		}
+	}
+
+	memset(priv->aes_key.key_param_set.key, 0,
+	       sizeof(key->key_param_set.key));
+	priv->aes_key.key_param_set.key_len = key->key_param_set.key_len;
+	memcpy(priv->aes_key.key_param_set.key, key->key_param_set.key,
+	       le16_to_cpu(priv->aes_key.key_param_set.key_len));
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of get 11d domain information.
+ */
+static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_802_11d_domain_info_rsp *domain_info =
+		&resp->params.domain_info_resp;
+	struct mwifiex_ietypes_domain_param_set *domain = &domain_info->domain;
+	u16 action = le16_to_cpu(domain_info->action);
+	u8 no_of_triplet = 0;
+
+	no_of_triplet = (u8) ((le16_to_cpu(domain->header.len) -
+					IEEE80211_COUNTRY_STRING_LEN) /
+				sizeof(struct ieee80211_country_ie_triplet));
+
+	dev_dbg(priv->adapter->dev, "info: 11D Domain Info Resp:"
+			" no_of_triplet=%d\n", no_of_triplet);
+
+	if (no_of_triplet > MWIFIEX_MAX_TRIPLET_802_11D) {
+		dev_warn(priv->adapter->dev,
+			"11D: invalid number of triplets %d "
+			"returned!!\n", no_of_triplet);
+		return -1;
+	}
+
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:  /* Proc Set Action */
+		break;
+	case HostCmd_ACT_GEN_GET:
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"11D: invalid action:%d\n", domain_info->action);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of get RF channel.
+ *
+ * Handling includes changing the header fields into CPU format
+ * and saving the new channel in driver.
+ */
+static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *resp,
+					 void *data_buf)
+{
+	struct host_cmd_ds_802_11_rf_channel *rf_channel =
+		&resp->params.rf_channel;
+	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
+
+	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
+		dev_dbg(priv->adapter->dev, "cmd: Channel Switch: %d to %d\n",
+		       priv->curr_bss_params.bss_descriptor.channel,
+		       new_channel);
+		/* Update the channel again */
+		priv->curr_bss_params.bss_descriptor.channel = new_channel;
+	}
+	if (data_buf)
+		*((u16 *)data_buf) = new_channel;
+
+	return 0;
+}
+
+/*
+ * This function handles the command response of get extended version.
+ *
+ * Handling includes forming the extended version string and sending it
+ * to application.
+ */
+static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
+{
+	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
+	struct host_cmd_ds_version_ext *version_ext = NULL;
+
+	if (data_buf) {
+		version_ext = (struct host_cmd_ds_version_ext *)data_buf;
+		version_ext->version_str_sel = ver_ext->version_str_sel;
+		memcpy(version_ext->version_str, ver_ext->version_str,
+		       sizeof(char) * 128);
+		memcpy(priv->version_str, ver_ext->version_str, 128);
+	}
+	return 0;
+}
+
+/*
+ * This function handles the command response of register access.
+ *
+ * The register value and offset are returned to the user. For EEPROM
+ * access, the byte count is also returned.
+ */
+static int mwifiex_ret_reg_access(u16 type, struct host_cmd_ds_command *resp,
+				  void *data_buf)
+{
+	struct mwifiex_ds_reg_rw *reg_rw = NULL;
+	struct mwifiex_ds_read_eeprom *eeprom = NULL;
+
+	if (data_buf) {
+		reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
+		eeprom = (struct mwifiex_ds_read_eeprom *) data_buf;
+		switch (type) {
+		case HostCmd_CMD_MAC_REG_ACCESS:
+			{
+				struct host_cmd_ds_mac_reg_access *reg;
+				reg = (struct host_cmd_ds_mac_reg_access *)
+					&resp->params.mac_reg;
+				reg_rw->offset = cpu_to_le32(
+					(u32) le16_to_cpu(reg->offset));
+				reg_rw->value = reg->value;
+				break;
+			}
+		case HostCmd_CMD_BBP_REG_ACCESS:
+			{
+				struct host_cmd_ds_bbp_reg_access *reg;
+				reg = (struct host_cmd_ds_bbp_reg_access *)
+					&resp->params.bbp_reg;
+				reg_rw->offset = cpu_to_le32(
+					(u32) le16_to_cpu(reg->offset));
+				reg_rw->value = cpu_to_le32((u32) reg->value);
+				break;
+			}
+
+		case HostCmd_CMD_RF_REG_ACCESS:
+			{
+				struct host_cmd_ds_rf_reg_access *reg;
+				reg = (struct host_cmd_ds_rf_reg_access *)
+					&resp->params.rf_reg;
+				reg_rw->offset = cpu_to_le32(
+					(u32) le16_to_cpu(reg->offset));
+				reg_rw->value = cpu_to_le32((u32) reg->value);
+				break;
+			}
+		case HostCmd_CMD_PMIC_REG_ACCESS:
+			{
+				struct host_cmd_ds_pmic_reg_access *reg;
+				reg = (struct host_cmd_ds_pmic_reg_access *)
+					&resp->params.pmic_reg;
+				reg_rw->offset = cpu_to_le32(
+					(u32) le16_to_cpu(reg->offset));
+				reg_rw->value = cpu_to_le32((u32) reg->value);
+				break;
+			}
+		case HostCmd_CMD_CAU_REG_ACCESS:
+			{
+				struct host_cmd_ds_rf_reg_access *reg;
+				reg = (struct host_cmd_ds_rf_reg_access *)
+					&resp->params.rf_reg;
+				reg_rw->offset = cpu_to_le32(
+					(u32) le16_to_cpu(reg->offset));
+				reg_rw->value = cpu_to_le32((u32) reg->value);
+				break;
+			}
+		case HostCmd_CMD_802_11_EEPROM_ACCESS:
+			{
+				struct host_cmd_ds_802_11_eeprom_access
+					*cmd_eeprom =
+					(struct host_cmd_ds_802_11_eeprom_access
+					 *) &resp->params.eeprom;
+				pr_debug("info: EEPROM read len=%x\n",
+				       cmd_eeprom->byte_count);
+				if (le16_to_cpu(eeprom->byte_count) <
+						le16_to_cpu(
+						cmd_eeprom->byte_count)) {
+					eeprom->byte_count = cpu_to_le16(0);
+					pr_debug("info: EEPROM read "
+							"length is too big\n");
+					return -1;
+				}
+				eeprom->offset = cmd_eeprom->offset;
+				eeprom->byte_count = cmd_eeprom->byte_count;
+				if (le16_to_cpu(eeprom->byte_count) > 0)
+					memcpy(&eeprom->value,
+					       &cmd_eeprom->value,
+					       le16_to_cpu(eeprom->byte_count));
+
+				break;
+			}
+		default:
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * This function handles the command response of get IBSS coalescing status.
+ *
+ * If the received BSSID is different than the current one, the current BSSID,
+ * beacon interval, ATIM window and ERP information are updated, along with
+ * changing the ad-hoc state accordingly.
+ */
+static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
+		&(resp->params.ibss_coalescing);
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+
+	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET)
+		return 0;
+
+	dev_dbg(priv->adapter->dev,
+		"info: new BSSID %pM\n", ibss_coal_resp->bssid);
+
+	/* If rsp has NULL BSSID, Just return..... No Action */
+	if (!memcmp(ibss_coal_resp->bssid, zero_mac, ETH_ALEN)) {
+		dev_warn(priv->adapter->dev, "new BSSID is NULL\n");
+		return 0;
+	}
+
+	/* If BSSID is diff, modify current BSS parameters */
+	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
+		   ibss_coal_resp->bssid, ETH_ALEN)) {
+		/* BSSID */
+		memcpy(priv->curr_bss_params.bss_descriptor.mac_address,
+		       ibss_coal_resp->bssid, ETH_ALEN);
+
+		/* Beacon Interval */
+		priv->curr_bss_params.bss_descriptor.beacon_period
+			= le16_to_cpu(ibss_coal_resp->beacon_interval);
+
+		/* ERP Information */
+		priv->curr_bss_params.bss_descriptor.erp_flags =
+			(u8) le16_to_cpu(ibss_coal_resp->use_g_rate_protect);
+
+		priv->adhoc_state = ADHOC_COALESCED;
+	}
+
+	return 0;
+}
+
+/*
+ * This function handles the command responses.
+ *
+ * This is a generic function, which calls command specific
+ * response handlers based on the command ID.
+ */
+int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
+				u16 cmdresp_no, void *cmd_buf, void *wq_buf)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_command *resp =
+		(struct host_cmd_ds_command *) cmd_buf;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
+	void *data_buf = adapter->curr_cmd->data_buf;
+
+	/* If the command is not successful, cleanup and return failure */
+	if (resp->result != HostCmd_RESULT_OK) {
+		mwifiex_process_cmdresp_error(priv, resp, wait_queue);
+		return -1;
+	}
+	/* Command successful, handle response */
+	switch (cmdresp_no) {
+	case HostCmd_CMD_GET_HW_SPEC:
+		ret = mwifiex_ret_get_hw_spec(priv, resp);
+		break;
+	case HostCmd_CMD_MAC_CONTROL:
+		break;
+	case HostCmd_CMD_802_11_MAC_ADDRESS:
+		ret = mwifiex_ret_802_11_mac_address(priv, resp);
+		break;
+	case HostCmd_CMD_MAC_MULTICAST_ADR:
+		ret = mwifiex_ret_mac_multicast_adr(priv, resp);
+		break;
+	case HostCmd_CMD_TX_RATE_CFG:
+		ret = mwifiex_ret_tx_rate_cfg(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_802_11_SCAN:
+		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
+		wait_queue = NULL;
+		adapter->curr_cmd->wq_buf = NULL;
+		break;
+	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
+		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
+		dev_dbg(adapter->dev,
+			"info: CMD_RESP: BG_SCAN result is ready!\n");
+		break;
+	case HostCmd_CMD_TXPWR_CFG:
+		ret = mwifiex_ret_tx_power_cfg(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_802_11_PS_MODE_ENH:
+		ret = mwifiex_ret_enh_power_mode(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_802_11_HS_CFG_ENH:
+		ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
+		break;
+	case HostCmd_CMD_802_11_ASSOCIATE:
+		ret = mwifiex_ret_802_11_associate(priv, resp, wait_queue);
+		break;
+	case HostCmd_CMD_802_11_DEAUTHENTICATE:
+		ret = mwifiex_ret_802_11_deauthenticate(priv, resp);
+		break;
+	case HostCmd_CMD_802_11_AD_HOC_START:
+	case HostCmd_CMD_802_11_AD_HOC_JOIN:
+		ret = mwifiex_ret_802_11_ad_hoc(priv, resp, wait_queue);
+		break;
+	case HostCmd_CMD_802_11_AD_HOC_STOP:
+		ret = mwifiex_ret_802_11_ad_hoc_stop(priv, resp);
+		break;
+	case HostCmd_CMD_802_11_GET_LOG:
+		ret = mwifiex_ret_get_log(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_RSSI_INFO:
+		ret = mwifiex_ret_802_11_rssi_info(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_802_11_SNMP_MIB:
+		ret = mwifiex_ret_802_11_snmp_mib(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_802_11_TX_RATE_QUERY:
+		ret = mwifiex_ret_802_11_tx_rate_query(priv, resp);
+		break;
+	case HostCmd_CMD_802_11_RF_CHANNEL:
+		ret = mwifiex_ret_802_11_rf_channel(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_VERSION_EXT:
+		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_FUNC_INIT:
+	case HostCmd_CMD_FUNC_SHUTDOWN:
+		break;
+	case HostCmd_CMD_802_11_KEY_MATERIAL:
+		ret = mwifiex_ret_802_11_key_material(priv, resp);
+		break;
+	case HostCmd_CMD_802_11D_DOMAIN_INFO:
+		ret = mwifiex_ret_802_11d_domain_info(priv, resp);
+		break;
+	case HostCmd_CMD_11N_ADDBA_REQ:
+		ret = mwifiex_ret_11n_addba_req(priv, resp);
+		break;
+	case HostCmd_CMD_11N_DELBA:
+		ret = mwifiex_ret_11n_delba(priv, resp);
+		break;
+	case HostCmd_CMD_11N_ADDBA_RSP:
+		ret = mwifiex_ret_11n_addba_resp(priv, resp);
+		break;
+	case HostCmd_CMD_RECONFIGURE_TX_BUFF:
+		adapter->tx_buf_size = (u16) le16_to_cpu(resp->params.
+							     tx_buf.buff_size);
+		adapter->tx_buf_size = (adapter->tx_buf_size /
+						MWIFIEX_SDIO_BLOCK_SIZE) *
+						MWIFIEX_SDIO_BLOCK_SIZE;
+		adapter->curr_tx_buf_size = adapter->tx_buf_size;
+		dev_dbg(adapter->dev,
+			"cmd: max_tx_buf_size=%d, tx_buf_size=%d\n",
+		       adapter->max_tx_buf_size, adapter->tx_buf_size);
+
+		if (adapter->if_ops.update_mp_end_port)
+			adapter->if_ops.update_mp_end_port(adapter,
+					le16_to_cpu(resp->
+						params.
+						tx_buf.
+						mp_end_port));
+		break;
+	case HostCmd_CMD_AMSDU_AGGR_CTRL:
+		ret = mwifiex_ret_amsdu_aggr_ctrl(priv, resp, data_buf);
+		break;
+	case HostCmd_CMD_WMM_GET_STATUS:
+		ret = mwifiex_ret_wmm_get_status(priv, resp);
+		break;
+	case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
+		ret = mwifiex_ret_ibss_coalescing_status(priv, resp);
+		break;
+	case HostCmd_CMD_MAC_REG_ACCESS:
+	case HostCmd_CMD_BBP_REG_ACCESS:
+	case HostCmd_CMD_RF_REG_ACCESS:
+	case HostCmd_CMD_PMIC_REG_ACCESS:
+	case HostCmd_CMD_CAU_REG_ACCESS:
+	case HostCmd_CMD_802_11_EEPROM_ACCESS:
+		ret = mwifiex_ret_reg_access(cmdresp_no, resp, data_buf);
+		break;
+	case HostCmd_CMD_SET_BSS_MODE:
+		break;
+	case HostCmd_CMD_11N_CFG:
+		ret = mwifiex_ret_11n_cfg(priv, resp, data_buf);
+		break;
+	default:
+		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
+		       resp->command);
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
new file mode 100644
index 0000000..d4a5c1f
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -0,0 +1,405 @@
+/*
+ * Marvell Wireless LAN device driver: station event handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * This function resets the connection state.
+ *
+ * The function is invoked after receiving a disconnect event from firmware,
+ * and performs the following actions -
+ *      - Set media status to disconnected
+ *      - Clean up Tx and Rx packets
+ *      - Resets SNR/NF/RSSI value in driver
+ *      - Resets security configurations in driver
+ *      - Enables auto data rate
+ *      - Saves the previous SSID and BSSID so that they can
+ *        be used for re-association, if required
+ *      - Erases current SSID and BSSID information
+ *      - Sends a disconnect event to upper layers/applications.
+ */
+void
+mwifiex_reset_connect_state(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (!priv->media_connected)
+		return;
+
+	dev_dbg(adapter->dev, "info: handles disconnect event\n");
+
+	priv->media_connected = false;
+
+	priv->scan_block = false;
+
+	/* Free Tx and Rx packets, report disconnect to upper layer */
+	mwifiex_clean_txrx(priv);
+
+	/* Reset SNR/NF/RSSI values */
+	priv->data_rssi_last = 0;
+	priv->data_nf_last = 0;
+	priv->data_rssi_avg = 0;
+	priv->data_nf_avg = 0;
+	priv->bcn_rssi_last = 0;
+	priv->bcn_nf_last = 0;
+	priv->bcn_rssi_avg = 0;
+	priv->bcn_nf_avg = 0;
+	priv->rxpd_rate = 0;
+	priv->rxpd_htinfo = 0;
+	priv->sec_info.wpa_enabled = false;
+	priv->sec_info.wpa2_enabled = false;
+	priv->wpa_ie_len = 0;
+
+	priv->sec_info.wapi_enabled = false;
+	priv->wapi_ie_len = 0;
+	priv->sec_info.wapi_key_on = false;
+
+	priv->sec_info.encryption_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
+
+	/* Enable auto data rate */
+	priv->is_data_rate_auto = true;
+	priv->data_rate = 0;
+
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+		priv->adhoc_state = ADHOC_IDLE;
+		priv->adhoc_is_link_sensed = false;
+	}
+
+	/*
+	 * Memorize the previous SSID and BSSID so
+	 * it could be used for re-assoc
+	 */
+
+	dev_dbg(adapter->dev, "info: previous SSID=%s, SSID len=%u\n",
+	       priv->prev_ssid.ssid, priv->prev_ssid.ssid_len);
+
+	dev_dbg(adapter->dev, "info: current SSID=%s, SSID len=%u\n",
+	       priv->curr_bss_params.bss_descriptor.ssid.ssid,
+	       priv->curr_bss_params.bss_descriptor.ssid.ssid_len);
+
+	memcpy(&priv->prev_ssid,
+	       &priv->curr_bss_params.bss_descriptor.ssid,
+	       sizeof(struct mwifiex_802_11_ssid));
+
+	memcpy(priv->prev_bssid,
+	       priv->curr_bss_params.bss_descriptor.mac_address, ETH_ALEN);
+
+	/* Need to erase the current SSID and BSSID info */
+	memset(&priv->curr_bss_params, 0x00, sizeof(priv->curr_bss_params));
+
+	adapter->tx_lock_flag = false;
+	adapter->pps_uapsd_mode = false;
+
+	if (adapter->num_cmd_timeout && adapter->curr_cmd)
+		return;
+	priv->media_connected = false;
+	if (!priv->disconnect) {
+		priv->disconnect = 1;
+		dev_dbg(adapter->dev, "info: successfully disconnected from"
+				" %pM: reason code %d\n", priv->cfg_bssid,
+				WLAN_REASON_DEAUTH_LEAVING);
+		cfg80211_disconnected(priv->netdev,
+				WLAN_REASON_DEAUTH_LEAVING, NULL, 0,
+				GFP_KERNEL);
+		queue_work(priv->workqueue, &priv->cfg_workqueue);
+	}
+	if (!netif_queue_stopped(priv->netdev))
+		netif_stop_queue(priv->netdev);
+	if (netif_carrier_ok(priv->netdev))
+		netif_carrier_off(priv->netdev);
+	/* Reset wireless stats signal info */
+	priv->w_stats.qual.level = 0;
+	priv->w_stats.qual.noise = 0;
+}
+
+/*
+ * This function handles events generated by firmware.
+ *
+ * This is a generic function and handles all events.
+ *
+ * Event specific routines are called by this function based
+ * upon the generated event cause.
+ *
+ * For the following events, the function just forwards them to upper
+ * layers, optionally recording the change -
+ *      - EVENT_LINK_SENSED
+ *      - EVENT_MIC_ERR_UNICAST
+ *      - EVENT_MIC_ERR_MULTICAST
+ *      - EVENT_PORT_RELEASE
+ *      - EVENT_RSSI_LOW
+ *      - EVENT_SNR_LOW
+ *      - EVENT_MAX_FAIL
+ *      - EVENT_RSSI_HIGH
+ *      - EVENT_SNR_HIGH
+ *      - EVENT_DATA_RSSI_LOW
+ *      - EVENT_DATA_SNR_LOW
+ *      - EVENT_DATA_RSSI_HIGH
+ *      - EVENT_DATA_SNR_HIGH
+ *      - EVENT_LINK_QUALITY
+ *      - EVENT_PRE_BEACON_LOST
+ *      - EVENT_IBSS_COALESCED
+ *      - EVENT_WEP_ICV_ERR
+ *      - EVENT_BW_CHANGE
+ *      - EVENT_HOSTWAKE_STAIE
+  *
+ * For the following events, no action is taken -
+ *      - EVENT_MIB_CHANGED
+ *      - EVENT_INIT_DONE
+ *      - EVENT_DUMMY_HOST_WAKEUP_SIGNAL
+ *
+ * Rest of the supported events requires driver handling -
+ *      - EVENT_DEAUTHENTICATED
+ *      - EVENT_DISASSOCIATED
+ *      - EVENT_LINK_LOST
+ *      - EVENT_PS_SLEEP
+ *      - EVENT_PS_AWAKE
+ *      - EVENT_DEEP_SLEEP_AWAKE
+ *      - EVENT_HS_ACT_REQ
+ *      - EVENT_ADHOC_BCN_LOST
+ *      - EVENT_BG_SCAN_REPORT
+ *      - EVENT_WMM_STATUS_CHANGE
+ *      - EVENT_ADDBA
+ *      - EVENT_DELBA
+ *      - EVENT_BA_STREAM_TIEMOUT
+ *      - EVENT_AMSDU_AGGR_CTRL
+ */
+int mwifiex_process_sta_event(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = 0;
+	u32 eventcause = adapter->event_cause;
+
+	switch (eventcause) {
+	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
+		dev_err(adapter->dev, "invalid EVENT: DUMMY_HOST_WAKEUP_SIGNAL,"
+				" ignoring it\n");
+		break;
+	case EVENT_LINK_SENSED:
+		dev_dbg(adapter->dev, "event: LINK_SENSED\n");
+		if (!netif_carrier_ok(priv->netdev))
+			netif_carrier_on(priv->netdev);
+		if (netif_queue_stopped(priv->netdev))
+			netif_wake_queue(priv->netdev);
+		break;
+
+	case EVENT_DEAUTHENTICATED:
+		dev_dbg(adapter->dev, "event: Deauthenticated\n");
+		adapter->dbg.num_event_deauth++;
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
+		break;
+
+	case EVENT_DISASSOCIATED:
+		dev_dbg(adapter->dev, "event: Disassociated\n");
+		adapter->dbg.num_event_disassoc++;
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
+		break;
+
+	case EVENT_LINK_LOST:
+		dev_dbg(adapter->dev, "event: Link lost\n");
+		adapter->dbg.num_event_link_lost++;
+		if (priv->media_connected)
+			mwifiex_reset_connect_state(priv);
+		break;
+
+	case EVENT_PS_SLEEP:
+		dev_dbg(adapter->dev, "info: EVENT: SLEEP\n");
+
+		adapter->ps_state = PS_STATE_PRE_SLEEP;
+
+		mwifiex_check_ps_cond(adapter);
+		break;
+
+	case EVENT_PS_AWAKE:
+		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
+		if (!adapter->pps_uapsd_mode &&
+			priv->media_connected &&
+			adapter->sleep_period.period) {
+				adapter->pps_uapsd_mode = true;
+				dev_dbg(adapter->dev,
+					"event: PPS/UAPSD mode activated\n");
+		}
+		adapter->tx_lock_flag = false;
+		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
+			if (mwifiex_check_last_packet_indication(priv)) {
+				if (!adapter->data_sent) {
+					if (!mwifiex_send_null_packet(priv,
+					MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET
+					|
+					MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
+						adapter->ps_state =
+							PS_STATE_SLEEP;
+					return 0;
+				}
+			}
+		}
+		adapter->ps_state = PS_STATE_AWAKE;
+		adapter->pm_wakeup_card_req = false;
+		adapter->pm_wakeup_fw_try = false;
+
+		break;
+
+	case EVENT_DEEP_SLEEP_AWAKE:
+		adapter->if_ops.wakeup_complete(adapter);
+		dev_dbg(adapter->dev, "event: DS_AWAKE\n");
+		if (adapter->is_deep_sleep)
+			adapter->is_deep_sleep = false;
+		break;
+
+	case EVENT_HS_ACT_REQ:
+		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_HS_CFG_ENH,
+					  0, 0, NULL, NULL);
+		break;
+
+	case EVENT_MIC_ERR_UNICAST:
+		dev_dbg(adapter->dev, "event: UNICAST MIC ERROR\n");
+		break;
+
+	case EVENT_MIC_ERR_MULTICAST:
+		dev_dbg(adapter->dev, "event: MULTICAST MIC ERROR\n");
+		break;
+	case EVENT_MIB_CHANGED:
+	case EVENT_INIT_DONE:
+		break;
+
+	case EVENT_ADHOC_BCN_LOST:
+		dev_dbg(adapter->dev, "event: ADHOC_BCN_LOST\n");
+		priv->adhoc_is_link_sensed = false;
+		mwifiex_clean_txrx(priv);
+		if (!netif_queue_stopped(priv->netdev))
+			netif_stop_queue(priv->netdev);
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
+		break;
+
+	case EVENT_BG_SCAN_REPORT:
+		dev_dbg(adapter->dev, "event: BGS_REPORT\n");
+		/* Clear the previous scan result */
+		memset(adapter->scan_table, 0x00,
+		       sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP);
+		adapter->num_in_scan_table = 0;
+		adapter->bcn_buf_end = adapter->bcn_buf;
+		ret = mwifiex_prepare_cmd(priv,
+					  HostCmd_CMD_802_11_BG_SCAN_QUERY,
+					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+		break;
+
+	case EVENT_PORT_RELEASE:
+		dev_dbg(adapter->dev, "event: PORT RELEASE\n");
+		break;
+
+	case EVENT_WMM_STATUS_CHANGE:
+		dev_dbg(adapter->dev, "event: WMM status changed\n");
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
+					  0, 0, NULL, NULL);
+		break;
+
+	case EVENT_RSSI_LOW:
+		dev_dbg(adapter->dev, "event: Beacon RSSI_LOW\n");
+		break;
+	case EVENT_SNR_LOW:
+		dev_dbg(adapter->dev, "event: Beacon SNR_LOW\n");
+		break;
+	case EVENT_MAX_FAIL:
+		dev_dbg(adapter->dev, "event: MAX_FAIL\n");
+		break;
+	case EVENT_RSSI_HIGH:
+		dev_dbg(adapter->dev, "event: Beacon RSSI_HIGH\n");
+		break;
+	case EVENT_SNR_HIGH:
+		dev_dbg(adapter->dev, "event: Beacon SNR_HIGH\n");
+		break;
+	case EVENT_DATA_RSSI_LOW:
+		dev_dbg(adapter->dev, "event: Data RSSI_LOW\n");
+		break;
+	case EVENT_DATA_SNR_LOW:
+		dev_dbg(adapter->dev, "event: Data SNR_LOW\n");
+		break;
+	case EVENT_DATA_RSSI_HIGH:
+		dev_dbg(adapter->dev, "event: Data RSSI_HIGH\n");
+		break;
+	case EVENT_DATA_SNR_HIGH:
+		dev_dbg(adapter->dev, "event: Data SNR_HIGH\n");
+		break;
+	case EVENT_LINK_QUALITY:
+		dev_dbg(adapter->dev, "event: Link Quality\n");
+		break;
+	case EVENT_PRE_BEACON_LOST:
+		dev_dbg(adapter->dev, "event: Pre-Beacon Lost\n");
+		break;
+	case EVENT_IBSS_COALESCED:
+		dev_dbg(adapter->dev, "event: IBSS_COALESCED\n");
+		ret = mwifiex_prepare_cmd(priv,
+				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				HostCmd_ACT_GEN_GET, 0, NULL, NULL);
+		break;
+	case EVENT_ADDBA:
+		dev_dbg(adapter->dev, "event: ADDBA Request\n");
+		mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_ADDBA_RSP,
+				    HostCmd_ACT_GEN_SET, 0, NULL,
+				    adapter->event_body);
+		break;
+	case EVENT_DELBA:
+		dev_dbg(adapter->dev, "event: DELBA Request\n");
+		mwifiex_11n_delete_ba_stream(priv, adapter->event_body);
+		break;
+	case EVENT_BA_STREAM_TIEMOUT:
+		dev_dbg(adapter->dev, "event:  BA Stream timeout\n");
+		mwifiex_11n_ba_stream_timeout(priv,
+					      (struct host_cmd_ds_11n_batimeout
+					       *)
+					      adapter->event_body);
+		break;
+	case EVENT_AMSDU_AGGR_CTRL:
+		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
+		       *(u16 *) adapter->event_body);
+		adapter->tx_buf_size =
+			min(adapter->curr_tx_buf_size,
+			    le16_to_cpu(*(__le16 *) adapter->event_body));
+		dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
+				adapter->tx_buf_size);
+		break;
+
+	case EVENT_WEP_ICV_ERR:
+		dev_dbg(adapter->dev, "event: WEP ICV error\n");
+		break;
+
+	case EVENT_BW_CHANGE:
+		dev_dbg(adapter->dev, "event: BW Change\n");
+		break;
+
+	case EVENT_HOSTWAKE_STAIE:
+		dev_dbg(adapter->dev, "event: HOSTWAKE_STAIE %d\n", eventcause);
+		break;
+	default:
+		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
+						eventcause);
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
new file mode 100644
index 0000000..665a519
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -0,0 +1,2478 @@
+/*
+ * Marvell Wireless LAN device driver: functions for station ioctl
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+#include "cfg80211.h"
+
+/*
+ * Copies the multicast address list from device to driver.
+ *
+ * This function does not validate the destination memory for
+ * size, and the calling function must ensure enough memory is
+ * available.
+ */
+static int
+mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
+			struct net_device *dev)
+{
+	int i = 0;
+	struct netdev_hw_addr *ha;
+
+	netdev_for_each_mc_addr(ha, dev)
+		memcpy(&mlist->mac_list[i++], ha->addr, ETH_ALEN);
+
+	return i;
+}
+
+/*
+ * Allocate and fills a wait queue with proper parameters.
+ *
+ * This function needs to be called before an IOCTL request can be made.
+ * It can handle the following wait options:
+ *      MWIFIEX_NO_WAIT     - Waiting is disabled
+ *      MWIFIEX_IOCTL_WAIT  - Waiting is done on IOCTL wait queue
+ *      MWIFIEX_CMD_WAIT    - Waiting is done on command wait queue
+ *      MWIFIEX_WSTATS_WAIT - Waiting is done on stats wait queue
+ */
+struct mwifiex_wait_queue *
+mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
+			      u8 wait_option)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+
+	wait = (struct mwifiex_wait_queue *)
+		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
+	if (!wait) {
+		dev_err(priv->adapter->dev, "%s: fail to alloc buffer\n",
+						__func__);
+		return wait;
+	}
+
+	wait->bss_index = priv->bss_index;
+
+	switch (wait_option) {
+	case MWIFIEX_NO_WAIT:
+		wait->enabled = 0;
+		break;
+	case MWIFIEX_IOCTL_WAIT:
+		priv->ioctl_wait_q_woken = false;
+		wait->start_time = jiffies;
+		wait->wait = &priv->ioctl_wait_q;
+		wait->condition = &priv->ioctl_wait_q_woken;
+		wait->enabled = 1;
+		break;
+	case MWIFIEX_CMD_WAIT:
+		priv->cmd_wait_q_woken = false;
+		wait->start_time = jiffies;
+		wait->wait = &priv->cmd_wait_q;
+		wait->condition = &priv->cmd_wait_q_woken;
+		wait->enabled = 1;
+		break;
+	case MWIFIEX_WSTATS_WAIT:
+		priv->w_stats_wait_q_woken = false;
+		wait->start_time = jiffies;
+		wait->wait = &priv->w_stats_wait_q;
+		wait->condition = &priv->w_stats_wait_q_woken;
+		wait->enabled = 1;
+		break;
+	}
+
+	return wait;
+}
+
+/*
+ * Wait queue completion handler.
+ *
+ * This function waits on a particular wait queue.
+ * For NO_WAIT option, it returns immediately. It also cancels the
+ * pending IOCTL request after waking up, in case of errors.
+ */
+static void
+mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    u8 wait_option)
+{
+	bool cancel_flag = false;
+
+	switch (wait_option) {
+	case MWIFIEX_NO_WAIT:
+		break;
+	case MWIFIEX_IOCTL_WAIT:
+		wait_event_interruptible(priv->ioctl_wait_q,
+					 priv->ioctl_wait_q_woken);
+		if (!priv->ioctl_wait_q_woken)
+			cancel_flag = true;
+		break;
+	case MWIFIEX_CMD_WAIT:
+		wait_event_interruptible(priv->cmd_wait_q,
+					 priv->cmd_wait_q_woken);
+		if (!priv->cmd_wait_q_woken)
+			cancel_flag = true;
+		break;
+	case MWIFIEX_WSTATS_WAIT:
+		wait_event_interruptible(priv->w_stats_wait_q,
+					 priv->w_stats_wait_q_woken);
+		if (!priv->w_stats_wait_q_woken)
+			cancel_flag = true;
+		break;
+	}
+	if (cancel_flag) {
+		mwifiex_cancel_pending_ioctl(priv->adapter, wait);
+		dev_dbg(priv->adapter->dev, "cmd: IOCTL cancel: wait=%p, wait_option=%d\n",
+			wait, wait_option);
+	}
+
+	return;
+}
+
+/*
+ * The function waits for the request to complete and issues the
+ * completion handler, if required.
+ */
+int mwifiex_request_ioctl(struct mwifiex_private *priv,
+			  struct mwifiex_wait_queue *wait,
+			  int status, u8 wait_option)
+{
+	switch (status) {
+	case -EINPROGRESS:
+		dev_dbg(priv->adapter->dev, "cmd: IOCTL pending: wait=%p, wait_option=%d\n",
+				wait, wait_option);
+		atomic_inc(&priv->adapter->ioctl_pending);
+		/* Status pending, wake up main process */
+		queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
+
+		/* Wait for completion */
+		if (wait_option) {
+			mwifiex_wait_ioctl_complete(priv, wait, wait_option);
+			status = wait->status;
+		}
+		break;
+	case 0:
+	case -1:
+	case -EBUSY:
+	default:
+		break;
+	}
+	return status;
+}
+EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
+
+/*
+ * IOCTL request handler to set/get MAC address.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the extended version information.
+ */
+static int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
+					 struct mwifiex_wait_queue *wait,
+					 u8 action, u8 *mac)
+{
+	int ret = 0;
+
+	if ((action == HostCmd_ACT_GEN_GET) && mac) {
+		memcpy(mac, priv->curr_addr, ETH_ALEN);
+		return 0;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
+				  action, 0, wait, mac);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to set MAC address.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	u8 wait_option = MWIFIEX_CMD_WAIT;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_bss_ioctl_mac_address(priv, wait, HostCmd_ACT_GEN_SET,
+					       NULL);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (!status)
+		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
+	else
+		dev_err(priv->adapter->dev, "set mac address failed: status=%d"
+				" error_code=%#x\n", status, wait->status);
+
+	kfree(wait);
+	return status;
+}
+
+/*
+ * IOCTL request handler to set multicast list.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to set the multicast list.
+ *
+ * This function can be used to enable promiscuous mode, or enable all
+ * multicast packets, or to enable selective multicast.
+ */
+static int
+mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait,
+				 u16 action,
+				 struct mwifiex_multicast_list *mcast_list)
+{
+	int ret = 0;
+	u16 old_pkt_filter;
+
+	old_pkt_filter = priv->curr_pkt_filter;
+	if (action == HostCmd_ACT_GEN_GET)
+		return -1;
+
+	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
+		dev_dbg(priv->adapter->dev, "info: Enable Promiscuous mode\n");
+		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
+		priv->curr_pkt_filter &=
+			~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+	} else {
+		/* Multicast */
+		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
+		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+			dev_dbg(priv->adapter->dev,
+				"info: Enabling All Multicast!\n");
+			priv->curr_pkt_filter |=
+				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+		} else {
+			priv->curr_pkt_filter &=
+				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
+			if (mcast_list->num_multicast_addr) {
+				dev_dbg(priv->adapter->dev,
+					"info: Set multicast list=%d\n",
+				       mcast_list->num_multicast_addr);
+				/* Set multicast addresses to firmware */
+				if (old_pkt_filter == priv->curr_pkt_filter) {
+					/* Send request to firmware */
+					ret = mwifiex_prepare_cmd(priv,
+						HostCmd_CMD_MAC_MULTICAST_ADR,
+						action, 0, wait, mcast_list);
+					if (!ret)
+						ret = -EINPROGRESS;
+				} else {
+					/* Send request to firmware */
+					ret = mwifiex_prepare_cmd(priv,
+						HostCmd_CMD_MAC_MULTICAST_ADR,
+						action, 0, NULL,
+						mcast_list);
+				}
+			}
+		}
+	}
+	dev_dbg(priv->adapter->dev,
+		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
+	       old_pkt_filter, priv->curr_pkt_filter);
+	if (old_pkt_filter != priv->curr_pkt_filter) {
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL, action,
+					  0, wait, &priv->curr_pkt_filter);
+		if (!ret)
+			ret = -EINPROGRESS;
+	}
+
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to set multicast list.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+void
+mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
+				   struct net_device *dev)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_multicast_list mcast_list;
+	u8 wait_option = MWIFIEX_NO_WAIT;
+	int status = 0;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return;
+
+	if (dev->flags & IFF_PROMISC) {
+		mcast_list.mode = MWIFIEX_PROMISC_MODE;
+	} else if (dev->flags & IFF_ALLMULTI ||
+		   netdev_mc_count(dev) > MWIFIEX_MAX_MULTICAST_LIST_SIZE) {
+		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
+	} else {
+		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
+		if (netdev_mc_count(dev))
+			mcast_list.num_multicast_addr =
+				mwifiex_copy_mcast_addr(&mcast_list, dev);
+	}
+	status = mwifiex_bss_ioctl_multicast_list(priv, wait,
+						  HostCmd_ACT_GEN_SET,
+						  &mcast_list);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (wait && status != -EINPROGRESS)
+		kfree(wait);
+
+	return;
+}
+
+/*
+ * IOCTL request handler to disconnect from a BSS/IBSS.
+ */
+static int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait, u8 *mac)
+{
+	return mwifiex_deauthenticate(priv, wait, mac);
+}
+
+/*
+ * Sends IOCTL request to disconnect from a BSS.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_bss_ioctl_stop(priv, wait, mac);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	kfree(wait);
+	return status;
+}
+EXPORT_SYMBOL_GPL(mwifiex_disconnect);
+
+/*
+ * IOCTL request handler to join a BSS/IBSS.
+ *
+ * In Ad-Hoc mode, the IBSS is created if not found in scan list.
+ * In both Ad-Hoc and infra mode, an deauthentication is performed
+ * first.
+ */
+static int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
+				   struct mwifiex_wait_queue *wait,
+				   struct mwifiex_ssid_bssid *ssid_bssid)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	s32 i = -1;
+
+	priv->scan_block = false;
+	if (!ssid_bssid)
+		return -1;
+
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
+		/* Infra mode */
+		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		if (ret)
+			return ret;
+
+		/* Search for the requested SSID in the scan table */
+		if (ssid_bssid->ssid.ssid_len)
+			i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid,
+						NULL, MWIFIEX_BSS_MODE_INFRA);
+		else
+			i = mwifiex_find_bssid_in_list(priv,
+						(u8 *) &ssid_bssid->bssid,
+						MWIFIEX_BSS_MODE_INFRA);
+		if (i < 0)
+			return -1;
+
+		dev_dbg(adapter->dev,
+			"info: SSID found in scan list ... associating...\n");
+
+		/* Clear any past association response stored for
+		 * application retrieval */
+		priv->assoc_rsp_size = 0;
+		ret = mwifiex_associate(priv, wait, &adapter->scan_table[i]);
+		if (ret)
+			return ret;
+	} else {
+		/* Adhoc mode */
+		/* If the requested SSID matches current SSID, return */
+		if (ssid_bssid->ssid.ssid_len &&
+		    (!mwifiex_ssid_cmp
+		     (&priv->curr_bss_params.bss_descriptor.ssid,
+		      &ssid_bssid->ssid)))
+			return 0;
+
+		/* Exit Adhoc mode first */
+		dev_dbg(adapter->dev, "info: Sending Adhoc Stop\n");
+		ret = mwifiex_deauthenticate(priv, NULL, NULL);
+		if (ret)
+			return ret;
+
+		priv->adhoc_is_link_sensed = false;
+
+		/* Search for the requested network in the scan table */
+		if (ssid_bssid->ssid.ssid_len)
+			i = mwifiex_find_ssid_in_list(priv,
+						      &ssid_bssid->ssid, NULL,
+						      MWIFIEX_BSS_MODE_IBSS);
+		else
+			i = mwifiex_find_bssid_in_list(priv,
+						       (u8 *)&ssid_bssid->bssid,
+						       MWIFIEX_BSS_MODE_IBSS);
+
+		if (i >= 0) {
+			dev_dbg(adapter->dev, "info: network found in scan"
+							" list. Joining...\n");
+			ret = mwifiex_adhoc_join(priv, wait,
+						 &adapter->scan_table[i]);
+			if (ret)
+				return ret;
+		} else {	/* i >= 0 */
+			dev_dbg(adapter->dev, "info: Network not found in "
+				"the list, creating adhoc with ssid = %s\n",
+			       ssid_bssid->ssid.ssid);
+			ret = mwifiex_adhoc_start(priv, wait,
+						  &ssid_bssid->ssid);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to connect with a BSS.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
+		      struct mwifiex_ssid_bssid *ssid_bssid)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ssid_bssid tmp_ssid_bssid;
+	int status = 0;
+
+	/* Stop the O.S. TX queue if needed */
+	if (!netif_queue_stopped(priv->netdev))
+		netif_stop_queue(priv->netdev);
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	if (ssid_bssid)
+		memcpy(&tmp_ssid_bssid, ssid_bssid,
+		       sizeof(struct mwifiex_ssid_bssid));
+	status = mwifiex_bss_ioctl_start(priv, wait, &tmp_ssid_bssid);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	kfree(wait);
+	return status;
+}
+
+/*
+ * IOCTL request handler to set host sleep configuration.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+static int
+mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
+			struct mwifiex_wait_queue *wait,
+			u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int status = 0;
+	u32 prev_cond = 0;
+
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:
+		if (adapter->pps_uapsd_mode) {
+			dev_dbg(adapter->dev, "info: Host Sleep IOCTL"
+				" is blocked in UAPSD/PPS mode\n");
+			status = -1;
+			break;
+		}
+		if (hs_cfg->is_invoke_hostcmd) {
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
+				if (!adapter->is_hs_configured)
+					/* Already cancelled */
+					break;
+				/* Save previous condition */
+				prev_cond = le32_to_cpu(adapter->hs_cfg
+							.conditions);
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(hs_cfg->conditions);
+			} else if (hs_cfg->conditions) {
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(hs_cfg->conditions);
+				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
+				if (hs_cfg->gap)
+					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
+			} else if (adapter->hs_cfg.conditions ==
+						cpu_to_le32(
+						HOST_SLEEP_CFG_CANCEL)) {
+				/* Return failure if no parameters for HS
+				   enable */
+				status = -1;
+				break;
+			}
+			status = mwifiex_prepare_cmd(priv,
+					HostCmd_CMD_802_11_HS_CFG_ENH,
+					HostCmd_ACT_GEN_SET,
+					0, wait, &adapter->hs_cfg);
+			if (!status)
+				status = -EINPROGRESS;
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
+				/* Restore previous condition */
+				adapter->hs_cfg.conditions =
+						cpu_to_le32(prev_cond);
+		} else {
+			adapter->hs_cfg.conditions =
+				cpu_to_le32(hs_cfg->conditions);
+			adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
+			adapter->hs_cfg.gap = (u8)hs_cfg->gap;
+		}
+		break;
+	case HostCmd_ACT_GEN_GET:
+		hs_cfg->conditions = le32_to_cpu(adapter->hs_cfg.conditions);
+		hs_cfg->gpio = adapter->hs_cfg.gpio;
+		hs_cfg->gap = adapter->hs_cfg.gap;
+		break;
+	default:
+		status = -1;
+		break;
+	}
+
+	return status;
+}
+
+/*
+ * Sends IOCTL request to set Host Sleep parameters.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
+			      u8 wait_option,
+			      struct mwifiex_ds_hs_cfg *hscfg)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+
+	if (!hscfg)
+		return -ENOMEM;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	ret = mwifiex_pm_ioctl_hs_cfg(priv, wait, action, hscfg);
+
+	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
+
+	if (wait && (ret != -EINPROGRESS))
+		kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to cancel the existing Host Sleep configuration.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
+{
+	int ret = 0;
+	struct mwifiex_ds_hs_cfg hscfg;
+
+	/* Cancel Host Sleep */
+	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
+	hscfg.is_invoke_hostcmd = true;
+	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+					wait_option, &hscfg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mwifiex_cancel_hs);
+
+/*
+ * Sends IOCTL request to cancel the existing Host Sleep configuration.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_ds_hs_cfg hscfg;
+
+	if (adapter->hs_activated) {
+		dev_dbg(adapter->dev, "cmd: HS Already actived\n");
+		return true;
+	}
+
+	/* Enable Host Sleep */
+	adapter->hs_activate_wait_q_woken = false;
+
+	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
+	hscfg.is_invoke_hostcmd = true;
+
+	if (mwifiex_set_hs_params(mwifiex_get_priv(adapter,
+						       MWIFIEX_BSS_ROLE_STA),
+				      HostCmd_ACT_GEN_SET,
+				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
+		dev_err(adapter->dev, "IOCTL request HS enable failed\n");
+		return false;
+	}
+
+	wait_event_interruptible(adapter->hs_activate_wait_q,
+			adapter->hs_activate_wait_q_woken);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
+
+/*
+ * IOCTL request handler to get signal information.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the signal (RSSI) information.
+ *
+ * This only works in the connected mode.
+ */
+static int mwifiex_get_info_signal(struct mwifiex_private *priv,
+				   struct mwifiex_wait_queue *wait,
+				   struct mwifiex_ds_get_signal *signal)
+{
+	int ret = 0;
+
+	if (!wait) {
+		dev_err(priv->adapter->dev, "WAIT information is not present\n");
+		return -1;
+	}
+
+	/* Signal info can be obtained only if connected */
+	if (!priv->media_connected) {
+		dev_dbg(priv->adapter->dev,
+			"info: Can not get signal in disconnected state\n");
+		return -1;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RSSI_INFO,
+				  HostCmd_ACT_GEN_GET, 0, wait, signal);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to get statistics.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the statistics (RSSI) information.
+ */
+static int mwifiex_get_info_stats(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   struct mwifiex_ds_get_stats *log)
+{
+	int ret = 0;
+
+	if (!wait) {
+		dev_err(priv->adapter->dev, "MWIFIEX IOCTL information is not present\n");
+		return -1;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_GET_LOG,
+				  HostCmd_ACT_GEN_GET, 0, wait, log);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to get BSS information.
+ *
+ * This function collates the information from different driver structures
+ * to send to the user.
+ */
+int mwifiex_get_bss_info(struct mwifiex_private *priv,
+			 struct mwifiex_bss_info *info)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bssdescriptor *bss_desc;
+	s32 tbl_idx = 0;
+
+	if (!info)
+		return -1;
+
+	/* Get current BSS info */
+	bss_desc = &priv->curr_bss_params.bss_descriptor;
+
+	/* BSS mode */
+	info->bss_mode = priv->bss_mode;
+
+	/* SSID */
+	memcpy(&info->ssid, &bss_desc->ssid,
+	       sizeof(struct mwifiex_802_11_ssid));
+
+	/* BSSID */
+	memcpy(&info->bssid, &bss_desc->mac_address, ETH_ALEN);
+
+	/* Channel */
+	info->bss_chan = bss_desc->channel;
+
+	/* Region code */
+	info->region_code = adapter->region_code;
+
+	/* Scan table index if connected */
+	info->scan_table_idx = 0;
+	if (priv->media_connected) {
+		tbl_idx =
+			mwifiex_find_ssid_in_list(priv, &bss_desc->ssid,
+						  bss_desc->mac_address,
+						  priv->bss_mode);
+		if (tbl_idx >= 0)
+			info->scan_table_idx = tbl_idx;
+	}
+
+	/* Connection status */
+	info->media_connected = priv->media_connected;
+
+	/* Radio status */
+	info->radio_on = adapter->radio_on;
+
+	/* Tx power information */
+	info->max_power_level = priv->max_tx_power_level;
+	info->min_power_level = priv->min_tx_power_level;
+
+	/* AdHoc state */
+	info->adhoc_state = priv->adhoc_state;
+
+	/* Last beacon NF */
+	info->bcn_nf_last = priv->bcn_nf_last;
+
+	/* wep status */
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+		info->wep_status = true;
+	else
+		info->wep_status = false;
+
+	info->is_hs_configured = adapter->is_hs_configured;
+	info->is_deep_sleep = adapter->is_deep_sleep;
+
+	return 0;
+}
+
+/*
+ * IOCTL request handler to get extended version information.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the extended version information.
+ */
+static int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
+				    struct mwifiex_wait_queue *wait,
+				    struct mwifiex_ver_ext *ver_ext)
+{
+	int ret = 0;
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_VERSION_EXT,
+				  HostCmd_ACT_GEN_GET, 0, wait, ver_ext);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get SNMP MIB parameters.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ *
+ * Currently the following parameters are supported -
+ *      Set/get RTS Threshold
+ *      Set/get fragmentation threshold
+ *      Set/get retry count
+ */
+int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   u32 cmd_oid, u16 action, u32 *value)
+{
+	int ret = 0;
+
+	if (!value)
+		return -1;
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				  action, cmd_oid, wait, value);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get band configurations.
+ *
+ * For SET operation, it performs extra checks to make sure the Ad-Hoc
+ * band and channel are compatible. Otherwise it returns an error.
+ *
+ * For GET operation, this function retrieves the following information -
+ *      - Infra bands
+ *      - Ad-hoc band
+ *      - Ad-hoc channel
+ *      - Secondary channel offset
+ */
+int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
+				 u16 action,
+				 struct mwifiex_ds_band_cfg *radio_cfg)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 infra_band = 0;
+	u8 adhoc_band = 0;
+	u32 adhoc_channel = 0;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		/* Infra Bands */
+		radio_cfg->config_bands = adapter->config_bands;
+		/* Adhoc Band */
+		radio_cfg->adhoc_start_band = adapter->adhoc_start_band;
+		/* Adhoc channel */
+		radio_cfg->adhoc_channel = priv->adhoc_channel;
+		/* Secondary channel offset */
+		radio_cfg->sec_chan_offset = adapter->chan_offset;
+		return 0;
+	}
+
+	/* For action = SET */
+	infra_band = (u8) radio_cfg->config_bands;
+	adhoc_band = (u8) radio_cfg->adhoc_start_band;
+	adhoc_channel = radio_cfg->adhoc_channel;
+
+	/* SET Infra band */
+	if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands)
+		return -1;
+
+	adapter->config_bands = infra_band;
+
+	/* SET Ad-hoc Band */
+	if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands)
+		return -1;
+
+	if (adhoc_band)
+		adapter->adhoc_start_band = adhoc_band;
+	adapter->chan_offset = (u8) radio_cfg->sec_chan_offset;
+	/*
+	 * If no adhoc_channel is supplied verify if the existing adhoc
+	 * channel compiles with new adhoc_band
+	 */
+	if (!adhoc_channel) {
+		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+		     (priv, adapter->adhoc_start_band,
+		     priv->adhoc_channel)) {
+			/* Pass back the default channel */
+			radio_cfg->adhoc_channel = DEFAULT_AD_HOC_CHANNEL;
+			if ((adapter->adhoc_start_band & BAND_A)
+			    || (adapter->adhoc_start_band & BAND_AN))
+				radio_cfg->adhoc_channel =
+					DEFAULT_AD_HOC_CHANNEL_A;
+		}
+	} else {	/* Retrurn error if adhoc_band and
+			   adhoc_channel combination is invalid */
+		if (!mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+		    (priv, adapter->adhoc_start_band, (u16) adhoc_channel))
+			return -1;
+		priv->adhoc_channel = (u8) adhoc_channel;
+	}
+	if ((adhoc_band & BAND_GN) || (adhoc_band & BAND_AN))
+		adapter->adhoc_11n_enabled = true;
+	else
+		adapter->adhoc_11n_enabled = false;
+
+	return 0;
+}
+
+/*
+ * IOCTL request handler to set/get active channel.
+ *
+ * This function performs validity checking on channel/frequency
+ * compatibility and returns failure if not valid.
+ */
+int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
+			      struct mwifiex_chan_freq_power *chan)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_chan_freq_power *cfp = NULL;
+
+	if (!chan)
+		return -1;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+				priv->curr_bss_params.band,
+				(u16) priv->curr_bss_params.bss_descriptor.
+					channel);
+		chan->channel = cfp->channel;
+		chan->freq = cfp->freq;
+
+		return 0;
+	}
+	if (!chan->channel && !chan->freq)
+		return -1;
+	if (adapter->adhoc_start_band & BAND_AN)
+		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
+	else if (adapter->adhoc_start_band & BAND_A)
+		adapter->adhoc_start_band = BAND_G | BAND_B;
+	if (chan->channel) {
+		if (chan->channel <= MAX_CHANNEL_BAND_BG)
+			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+					(priv, 0, (u16) chan->channel);
+		if (!cfp) {
+			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
+					(priv, BAND_A, (u16) chan->channel);
+			if (cfp) {
+				if (adapter->adhoc_11n_enabled)
+					adapter->adhoc_start_band = BAND_A
+						| BAND_AN;
+				else
+					adapter->adhoc_start_band = BAND_A;
+			}
+		}
+	} else {
+		if (chan->freq <= MAX_FREQUENCY_BAND_BG)
+			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
+							priv, 0, chan->freq);
+		if (!cfp) {
+			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211
+						  (priv, BAND_A, chan->freq);
+			if (cfp) {
+				if (adapter->adhoc_11n_enabled)
+					adapter->adhoc_start_band = BAND_A
+						| BAND_AN;
+				else
+					adapter->adhoc_start_band = BAND_A;
+			}
+		}
+	}
+	if (!cfp || !cfp->channel) {
+		dev_err(adapter->dev, "invalid channel/freq\n");
+		return -1;
+	}
+	priv->adhoc_channel = (u8) cfp->channel;
+	chan->channel = cfp->channel;
+	chan->freq = cfp->freq;
+
+	return 0;
+}
+
+/*
+ * IOCTL request handler to set/get BSS mode.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to set or get the BSS mode.
+ *
+ * In case the mode is changed, a deauthentication is performed
+ * first by the function automatically.
+ */
+int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   u16 action, int *mode)
+{
+	int ret = 0;
+
+	if (!mode)
+		return -1;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		*mode = priv->bss_mode;
+		return 0;
+	}
+
+	if ((priv->bss_mode == *mode) || (*mode == MWIFIEX_BSS_MODE_AUTO)) {
+		dev_dbg(priv->adapter->dev,
+			"info: Already set to required mode! No change!\n");
+		priv->bss_mode = *mode;
+		return 0;
+	}
+
+	ret = mwifiex_deauthenticate(priv, wait, NULL);
+
+	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
+	priv->bss_mode = *mode;
+	if (priv->bss_mode != MWIFIEX_BSS_MODE_AUTO) {
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+					  HostCmd_ACT_GEN_SET, 0, wait, NULL);
+		if (!ret)
+			ret = -EINPROGRESS;
+	}
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get Ad-Hoc channel.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to set or get the ad-hoc channel.
+ */
+static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
+					  struct mwifiex_wait_queue *wait,
+					  u16 action, u16 *channel)
+{
+	int ret = 0;
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (!priv->media_connected) {
+			*channel = priv->adhoc_channel;
+			return ret;
+		}
+	} else {
+		priv->adhoc_channel = (u8) *channel;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_CHANNEL,
+				  action, 0, wait, channel);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to find a particular BSS.
+ *
+ * The BSS can be searched with either a BSSID or a SSID. If none of
+ * these are provided, just the best BSS (best RSSI) is returned.
+ */
+int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
+			       struct mwifiex_wait_queue *wait,
+			       struct mwifiex_ssid_bssid *ssid_bssid)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = 0;
+	struct mwifiex_bssdescriptor *bss_desc;
+	u8 zero_mac[ETH_ALEN] = { 0, 0, 0, 0, 0, 0 };
+	u8 mac[ETH_ALEN];
+	int i = 0;
+
+	if (memcmp(ssid_bssid->bssid, zero_mac, sizeof(zero_mac))) {
+		i = mwifiex_find_bssid_in_list(priv,
+					       (u8 *) ssid_bssid->bssid,
+					       priv->bss_mode);
+		if (i < 0) {
+			memcpy(mac, ssid_bssid->bssid, sizeof(mac));
+			dev_err(adapter->dev, "cannot find bssid %pM\n", mac);
+			return -1;
+		}
+		bss_desc = &adapter->scan_table[i];
+		memcpy(&ssid_bssid->ssid, &bss_desc->ssid,
+				sizeof(struct mwifiex_802_11_ssid));
+	} else if (ssid_bssid->ssid.ssid_len) {
+		i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid, NULL,
+					      priv->bss_mode);
+		if (i < 0) {
+			dev_err(adapter->dev, "cannot find ssid %s\n",
+					ssid_bssid->ssid.ssid);
+			return -1;
+		}
+		bss_desc = &adapter->scan_table[i];
+		memcpy(ssid_bssid->bssid, bss_desc->mac_address, ETH_ALEN);
+	} else {
+		ret = mwifiex_find_best_network(priv, ssid_bssid);
+	}
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to change Ad-Hoc channel.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ *
+ * The function follows the following steps to perform the change -
+ *      - Get current IBSS information
+ *      - Get current channel
+ *      - If no change is required, return
+ *      - If not connected, change channel and return
+ *      - If connected,
+ *          - Disconnect
+ *          - Change channel
+ *          - Perform specific SSID scan with same SSID
+ *          - Start/Join the IBSS
+ */
+int
+mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_bss_info bss_info;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+	struct mwifiex_ssid_bssid ssid_bssid;
+	u16 curr_chan = 0;
+
+	memset(&bss_info, 0, sizeof(bss_info));
+
+	/* Get BSS information */
+	if (mwifiex_get_bss_info(priv, &bss_info))
+		return -1;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	/* Get current channel */
+	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_GET,
+						&curr_chan);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
+		goto done;
+	}
+	if (curr_chan == channel) {
+		ret = 0;
+		goto done;
+	}
+	dev_dbg(priv->adapter->dev, "cmd: updating channel from %d to %d\n",
+			curr_chan, channel);
+
+	if (!bss_info.media_connected) {
+		ret = 0;
+		goto done;
+	}
+
+	/* Do disonnect */
+	memset(&ssid_bssid, 0, ETH_ALEN);
+	status = mwifiex_bss_ioctl_stop(priv, wait, ssid_bssid.bssid);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
+		goto done;
+	}
+
+	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_SET,
+						(u16 *) &channel);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
+		goto done;
+	}
+
+	/* Do specific SSID scanning */
+	if (mwifiex_request_scan(priv, wait_option, &bss_info.ssid)) {
+		ret = -1;
+		goto done;
+	}
+	/* Start/Join Adhoc network */
+	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
+	memcpy(&ssid_bssid.ssid, &bss_info.ssid,
+	       sizeof(struct mwifiex_802_11_ssid));
+
+	status = mwifiex_bss_ioctl_start(priv, wait, &ssid_bssid);
+
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
+		ret = -1;
+
+done:
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * IOCTL request handler to get current driver mode.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	int mode = -1;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -1;
+
+	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_GET, &mode);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	if (wait && (status != -EINPROGRESS))
+		kfree(wait);
+	return mode;
+}
+
+/*
+ * IOCTL request handler to get rate.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to get the current rate if it is connected,
+ * otherwise, the function returns the lowest supported rate
+ * for the band.
+ */
+static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = 0;
+
+	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
+	if (!priv->media_connected) {
+		switch (adapter->config_bands) {
+		case BAND_B:
+			/* Return the lowest supported rate for B band */
+			rate_cfg->rate = supported_rates_b[0] & 0x7f;
+			break;
+		case BAND_G:
+		case BAND_G | BAND_GN:
+			/* Return the lowest supported rate for G band */
+			rate_cfg->rate = supported_rates_g[0] & 0x7f;
+			break;
+		case BAND_B | BAND_G:
+		case BAND_A | BAND_B | BAND_G:
+		case BAND_A | BAND_B:
+		case BAND_A | BAND_B | BAND_G | BAND_AN | BAND_GN:
+		case BAND_B | BAND_G | BAND_GN:
+			/* Return the lowest supported rate for BG band */
+			rate_cfg->rate = supported_rates_bg[0] & 0x7f;
+			break;
+		case BAND_A:
+		case BAND_A | BAND_G:
+		case BAND_A | BAND_G | BAND_AN | BAND_GN:
+		case BAND_A | BAND_AN:
+			/* Return the lowest supported rate for A band */
+			rate_cfg->rate = supported_rates_a[0] & 0x7f;
+			break;
+		case BAND_GN:
+			/* Return the lowest supported rate for N band */
+			rate_cfg->rate = supported_rates_n[0] & 0x7f;
+			break;
+		default:
+			dev_warn(adapter->dev, "invalid band %#x\n",
+			       adapter->config_bands);
+			break;
+		}
+	} else {
+		/* Send request to firmware */
+		ret = mwifiex_prepare_cmd(priv,
+					  HostCmd_CMD_802_11_TX_RATE_QUERY,
+					  HostCmd_ACT_GEN_GET, 0, wait, NULL);
+		if (!ret)
+			ret = -EINPROGRESS;
+	}
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set rate.
+ *
+ * This function prepares the correct firmware command and
+ * issues it to set the current rate.
+ *
+ * The function also performs validation checking on the supplied value.
+ */
+static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
+{
+	u8 rates[MWIFIEX_SUPPORTED_RATES];
+	u8 *rate = NULL;
+	int rate_index = 0;
+	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
+	u32 i = 0;
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (rate_cfg->is_rate_auto) {
+		memset(bitmap_rates, 0, sizeof(bitmap_rates));
+		/* Support all HR/DSSS rates */
+		bitmap_rates[0] = 0x000F;
+		/* Support all OFDM rates */
+		bitmap_rates[1] = 0x00FF;
+		/* Support all HT-MCSs rate */
+		for (i = 0; i < ARRAY_SIZE(priv->bitmap_rates) - 3; i++)
+			bitmap_rates[i + 2] = 0xFFFF;
+		bitmap_rates[9] = 0x3FFF;
+	} else {
+		memset(rates, 0, sizeof(rates));
+		mwifiex_get_active_data_rates(priv, rates);
+		rate = rates;
+		for (i = 0; (rate[i] && i < MWIFIEX_SUPPORTED_RATES); i++) {
+			dev_dbg(adapter->dev, "info: rate=%#x wanted=%#x\n",
+				rate[i], rate_cfg->rate);
+			if ((rate[i] & 0x7f) == (rate_cfg->rate & 0x7f))
+				break;
+		}
+		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
+			dev_err(adapter->dev, "fixed data rate %#x is out "
+			       "of range\n", rate_cfg->rate);
+			return -1;
+		}
+		memset(bitmap_rates, 0, sizeof(bitmap_rates));
+
+		rate_index =
+			mwifiex_data_rate_to_index(adapter, rate_cfg->rate);
+
+		/* Only allow b/g rates to be set */
+		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
+		    rate_index <= MWIFIEX_RATE_INDEX_HRDSSS3) {
+			bitmap_rates[0] = 1 << rate_index;
+		} else {
+			rate_index -= 1; /* There is a 0x00 in the table */
+			if (rate_index >= MWIFIEX_RATE_INDEX_OFDM0 &&
+			    rate_index <= MWIFIEX_RATE_INDEX_OFDM7)
+				bitmap_rates[1] = 1 << (rate_index -
+						   MWIFIEX_RATE_INDEX_OFDM0);
+		}
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get rate.
+ *
+ * This function can be used to set/get either the rate value or the
+ * rate index.
+ */
+static int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
+{
+	int status = 0;
+
+	if (!rate_cfg)
+		return -1;
+
+	if (rate_cfg->action == HostCmd_ACT_GEN_GET)
+		status = mwifiex_rate_ioctl_get_rate_value(
+				priv, wait, rate_cfg);
+	else
+		status = mwifiex_rate_ioctl_set_rate_value(
+				priv, wait, rate_cfg);
+
+	return status;
+}
+
+/*
+ * Sends IOCTL request to get the data rate.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
+			      struct mwifiex_rate_cfg *rate)
+{
+	int ret = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
+	rate->action = HostCmd_ACT_GEN_GET;
+	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
+
+	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
+	if (!ret) {
+		if (rate && rate->is_rate_auto)
+			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
+					priv->tx_rate, priv->tx_htinfo);
+		else if (rate)
+			rate->rate = priv->data_rate;
+	} else {
+		ret = -1;
+	}
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set tx power configuration.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ *
+ * For non-auto power mode, all the following power groups are set -
+ *      - Modulation class HR/DSSS
+ *      - Modulation class OFDM
+ *      - Modulation class HTBW20
+ *      - Modulation class HTBW40
+ */
+static int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
+					 struct mwifiex_wait_queue *wait,
+					 struct mwifiex_power_cfg *power_cfg)
+{
+	int ret = 0;
+	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
+	struct mwifiex_types_power_group *pg_tlv = NULL;
+	struct mwifiex_power_group *pg = NULL;
+	u8 *buf = NULL;
+	u16 dbm = 0;
+
+	if (!power_cfg->is_power_auto) {
+		dbm = (u16) power_cfg->power_level;
+		if ((dbm < priv->min_tx_power_level) ||
+		    (dbm > priv->max_tx_power_level)) {
+			dev_err(priv->adapter->dev, "txpower value %d dBm"
+					" is out of range (%d dBm-%d dBm)\n",
+					dbm, priv->min_tx_power_level,
+					priv->max_tx_power_level);
+			return -1;
+		}
+	}
+	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
+	if (!buf) {
+		dev_err(priv->adapter->dev, "%s: failed to alloc cmd buffer\n",
+				__func__);
+		return -1;
+	}
+
+	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
+	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
+	if (!power_cfg->is_power_auto) {
+		txp_cfg->mode = cpu_to_le32(1);
+		pg_tlv = (struct mwifiex_types_power_group *) (buf +
+				sizeof(struct host_cmd_ds_txpwr_cfg));
+		pg_tlv->type = TLV_TYPE_POWER_GROUP;
+		pg_tlv->length = 4 * sizeof(struct mwifiex_power_group);
+		pg = (struct mwifiex_power_group *) (buf +
+				sizeof(struct host_cmd_ds_txpwr_cfg) +
+				sizeof(struct mwifiex_types_power_group));
+		/* Power group for modulation class HR/DSSS */
+		pg->first_rate_code = 0x00;
+		pg->last_rate_code = 0x03;
+		pg->modulation_class = MOD_CLASS_HR_DSSS;
+		pg->power_step = 0;
+		pg->power_min = (s8) dbm;
+		pg->power_max = (s8) dbm;
+		pg++;
+		/* Power group for modulation class OFDM */
+		pg->first_rate_code = 0x00;
+		pg->last_rate_code = 0x07;
+		pg->modulation_class = MOD_CLASS_OFDM;
+		pg->power_step = 0;
+		pg->power_min = (s8) dbm;
+		pg->power_max = (s8) dbm;
+		pg++;
+		/* Power group for modulation class HTBW20 */
+		pg->first_rate_code = 0x00;
+		pg->last_rate_code = 0x20;
+		pg->modulation_class = MOD_CLASS_HT;
+		pg->power_step = 0;
+		pg->power_min = (s8) dbm;
+		pg->power_max = (s8) dbm;
+		pg->ht_bandwidth = HT_BW_20;
+		pg++;
+		/* Power group for modulation class HTBW40 */
+		pg->first_rate_code = 0x00;
+		pg->last_rate_code = 0x20;
+		pg->modulation_class = MOD_CLASS_HT;
+		pg->power_step = 0;
+		pg->power_min = (s8) dbm;
+		pg->power_max = (s8) dbm;
+		pg->ht_bandwidth = HT_BW_40;
+	}
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
+				  HostCmd_ACT_GEN_SET, 0, wait, buf);
+	if (!ret)
+		ret = -EINPROGRESS;
+	kfree(buf);
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to get power save mode.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+static int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
+				    struct mwifiex_wait_queue *wait,
+				    u32 *ps_mode, u16 action)
+{
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u16 sub_cmd;
+
+	if (action == HostCmd_ACT_GEN_SET) {
+		if (*ps_mode)
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+		else
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+		sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					  sub_cmd, BITMAP_STA_PS, wait, NULL);
+		if ((!ret) && (sub_cmd == DIS_AUTO_PS))
+			ret = mwifiex_prepare_cmd(priv,
+					HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
+					0, NULL, NULL);
+	} else {
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					  GET_PS, 0, wait, NULL);
+	}
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/reset WPA IE.
+ *
+ * The supplied WPA IE is treated as a opaque buffer. Only the first field
+ * is checked to determine WPA version. If buffer length is zero, the existing
+ * WPA IE is reset.
+ */
+static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
+				     u8 *ie_data_ptr, u16 ie_len)
+{
+	if (ie_len) {
+		if (ie_len > sizeof(priv->wpa_ie)) {
+			dev_err(priv->adapter->dev,
+				"failed to copy WPA IE, too big\n");
+			return -1;
+		}
+		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
+		priv->wpa_ie_len = (u8) ie_len;
+		dev_dbg(priv->adapter->dev, "cmd: Set Wpa_ie_len=%d IE=%#x\n",
+				priv->wpa_ie_len, priv->wpa_ie[0]);
+
+		if (priv->wpa_ie[0] == WLAN_EID_WPA) {
+			priv->sec_info.wpa_enabled = true;
+		} else if (priv->wpa_ie[0] == WLAN_EID_RSN) {
+			priv->sec_info.wpa2_enabled = true;
+		} else {
+			priv->sec_info.wpa_enabled = false;
+			priv->sec_info.wpa2_enabled = false;
+		}
+	} else {
+		memset(priv->wpa_ie, 0, sizeof(priv->wpa_ie));
+		priv->wpa_ie_len = 0;
+		dev_dbg(priv->adapter->dev, "info: reset wpa_ie_len=%d IE=%#x\n",
+			priv->wpa_ie_len, priv->wpa_ie[0]);
+		priv->sec_info.wpa_enabled = false;
+		priv->sec_info.wpa2_enabled = false;
+	}
+
+	return 0;
+}
+
+/*
+ * IOCTL request handler to set/reset WAPI IE.
+ *
+ * The supplied WAPI IE is treated as a opaque buffer. Only the first field
+ * is checked to internally enable WAPI. If buffer length is zero, the existing
+ * WAPI IE is reset.
+ */
+static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
+			       u8 *ie_data_ptr, u16 ie_len)
+{
+	if (ie_len) {
+		if (ie_len > sizeof(priv->wapi_ie)) {
+			dev_dbg(priv->adapter->dev,
+				"info: failed to copy WAPI IE, too big\n");
+			return -1;
+		}
+		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
+		priv->wapi_ie_len = ie_len;
+		dev_dbg(priv->adapter->dev, "cmd: Set wapi_ie_len=%d IE=%#x\n",
+				priv->wapi_ie_len, priv->wapi_ie[0]);
+
+		if (priv->wapi_ie[0] == WLAN_EID_BSS_AC_ACCESS_DELAY)
+			priv->sec_info.wapi_enabled = true;
+	} else {
+		memset(priv->wapi_ie, 0, sizeof(priv->wapi_ie));
+		priv->wapi_ie_len = ie_len;
+		dev_dbg(priv->adapter->dev,
+			"info: Reset wapi_ie_len=%d IE=%#x\n",
+		       priv->wapi_ie_len, priv->wapi_ie[0]);
+		priv->sec_info.wapi_enabled = false;
+	}
+	return 0;
+}
+
+/*
+ * IOCTL request handler to set WAPI key.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
+			       struct mwifiex_wait_queue *wait,
+			       struct mwifiex_ds_encrypt_key *encrypt_key)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+				  wait, encrypt_key);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get authentication mode.
+ */
+static int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
+{
+	int ret = 0;
+
+	priv->sec_info.authentication_mode = auth_mode;
+	if (priv->sec_info.authentication_mode == MWIFIEX_AUTH_MODE_NETWORKEAP)
+		ret = mwifiex_set_wpa_ie_helper(priv, NULL, 0);
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set WEP network key.
+ *
+ * This function prepares the correct firmware command and
+ * issues it, after validation checks.
+ */
+static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
+	struct mwifiex_wep_key *wep_key = NULL;
+	int index;
+
+	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
+		priv->wep_key_curr_index = 0;
+	wep_key = &priv->wep_key[priv->wep_key_curr_index];
+	index = encrypt_key->key_index;
+	if (encrypt_key->key_disable) {
+		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
+	} else if (!encrypt_key->key_len) {
+		/* Copy the required key as the current key */
+		wep_key = &priv->wep_key[index];
+		if (!wep_key->key_length) {
+			dev_err(adapter->dev,
+				"key not set, so cannot enable it\n");
+			return -1;
+		}
+		priv->wep_key_curr_index = (u16) index;
+		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
+	} else {
+		wep_key = &priv->wep_key[index];
+		/* Cleanup */
+		memset(wep_key, 0, sizeof(struct mwifiex_wep_key));
+		/* Copy the key in the driver */
+		memcpy(wep_key->key_material,
+		       encrypt_key->key_material,
+		       encrypt_key->key_len);
+		wep_key->key_index = index;
+		wep_key->key_length = encrypt_key->key_len;
+		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
+	}
+	if (wep_key->key_length) {
+		/* Send request to firmware */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+		if (ret)
+			return ret;
+	}
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
+	else
+		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				  HostCmd_ACT_GEN_SET, 0, wait,
+				  &priv->curr_pkt_filter);
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set WPA key.
+ *
+ * This function prepares the correct firmware command and
+ * issues it, after validation checks.
+ *
+ * Current driver only supports key length of up to 32 bytes.
+ *
+ * This function can also be used to disable a currently set key.
+ */
+static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
+{
+	int ret = 0;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
+	u8 remove_key = false;
+	struct host_cmd_ds_802_11_key_material *ibss_key;
+
+	/* Current driver only supports key length of up to 32 bytes */
+	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
+		dev_err(adapter->dev, "key length too long\n");
+		return -1;
+	}
+
+	if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
+		/*
+		 * IBSS/WPA-None uses only one key (Group) for both receiving
+		 * and sending unicast and multicast packets.
+		 */
+		/* Send the key as PTK to firmware */
+		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+					  NULL, encrypt_key);
+		if (ret)
+			return ret;
+
+		ibss_key = &priv->aes_key;
+		memset(ibss_key, 0,
+		       sizeof(struct host_cmd_ds_802_11_key_material));
+		/* Copy the key in the driver */
+		memcpy(ibss_key->key_param_set.key, encrypt_key->key_material,
+		       encrypt_key->key_len);
+		memcpy(&ibss_key->key_param_set.key_len, &encrypt_key->key_len,
+		       sizeof(ibss_key->key_param_set.key_len));
+		ibss_key->key_param_set.key_type_id
+			= cpu_to_le16(KEY_TYPE_ID_TKIP);
+		ibss_key->key_param_set.key_info
+			= cpu_to_le16(KEY_INFO_TKIP_ENABLED);
+
+		/* Send the key as GTK to firmware */
+		encrypt_key->key_index = ~MWIFIEX_KEY_INDEX_UNICAST;
+	}
+
+	if (!encrypt_key->key_index)
+		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
+
+	if (remove_key)
+		/* Send request to firmware */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET,
+					  !(KEY_INFO_ENABLED),
+					  wait, encrypt_key);
+	else
+		/* Send request to firmware */
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+					  wait, encrypt_key);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get network keys.
+ *
+ * This is a generic key handling function which supports WEP, WPA
+ * and WAPI.
+ */
+static int
+mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
+{
+	int status = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (encrypt_key->is_wapi_key)
+		status = mwifiex_sec_ioctl_set_wapi_key(adapter, wait,
+							encrypt_key);
+	else if (encrypt_key->key_len > WLAN_KEY_LEN_WEP104)
+		status = mwifiex_sec_ioctl_set_wpa_key(adapter, wait,
+						       encrypt_key);
+	else
+		status = mwifiex_sec_ioctl_set_wep_key(adapter, wait,
+						       encrypt_key);
+	return status;
+}
+
+/*
+ * This function returns the driver version.
+ */
+int
+mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
+			       int max_len)
+{
+	union {
+		u32 l;
+		u8 c[4];
+	} ver;
+	char fw_ver[32];
+
+	ver.l = adapter->fw_release_number;
+	sprintf(fw_ver, "%u.%u.%u.p%u", ver.c[2], ver.c[1], ver.c[0], ver.c[3]);
+
+	snprintf(version, max_len, driver_version, fw_ver);
+
+	dev_dbg(adapter->dev, "info: MWIFIEX VERSION: %s\n", version);
+
+	return 0;
+}
+
+/*
+ * Sends IOCTL request to set Tx power. It can be set to either auto
+ * or a fixed value.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
+{
+	struct mwifiex_power_cfg power_cfg;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	int ret = 0;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	if (type == NL80211_TX_POWER_FIXED) {
+		power_cfg.is_power_auto = 0;
+		power_cfg.power_level = dbm;
+	} else {
+		power_cfg.is_power_auto = 1;
+	}
+	status = mwifiex_power_ioctl_set_power(priv, wait, &power_cfg);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to get scan table.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
+			   struct mwifiex_scan_resp *scan_resp)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_scan_resp scan;
+	int status = 0;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
+				       NULL, &scan);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (!status) {
+		if (scan_resp)
+			memcpy(scan_resp, &scan,
+			       sizeof(struct mwifiex_scan_resp));
+	}
+
+	if (wait && (status != -EINPROGRESS))
+		kfree(wait);
+	return status;
+}
+
+/*
+ * Sends IOCTL request to get signal information.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
+			    struct mwifiex_ds_get_signal *signal)
+{
+	struct mwifiex_ds_get_signal info;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	info.selector = ALL_RSSI_INFO_MASK;
+
+	status = mwifiex_get_info_signal(priv, wait, &info);
+
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (!status) {
+		if (signal)
+			memcpy(signal, &info,
+			       sizeof(struct mwifiex_ds_get_signal));
+		if (info.selector & BCN_RSSI_AVG_MASK)
+			priv->w_stats.qual.level = info.bcn_rssi_avg;
+		if (info.selector & BCN_NF_AVG_MASK)
+			priv->w_stats.qual.noise = info.bcn_nf_avg;
+	}
+
+	if (wait && (status != -EINPROGRESS))
+		kfree(wait);
+	return status;
+}
+
+/*
+ * Sends IOCTL request to set encryption mode.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+static int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
+				    u8 wait_option, u32 encrypt_mode)
+{
+	priv->sec_info.encryption_mode = encrypt_mode;
+	return 0;
+}
+
+/*
+ * This function set the authentication parameters. It sets both encryption
+ * mode and authentication mode, and also enables WPA if required.
+ */
+int
+mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
+		 int auth_mode, int wpa_enabled)
+{
+	if (mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
+		return -EFAULT;
+
+	if (mwifiex_set_auth_mode(priv, auth_mode))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Sends IOCTL request to set encoding parameters.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
+			int key_len, u8 key_index, int disable)
+{
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_encrypt_key encrypt_key;
+	int status = 0;
+	int ret = 0;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
+	encrypt_key.key_len = key_len;
+	if (!disable) {
+		encrypt_key.key_index = key_index;
+		if (key_len)
+			memcpy(encrypt_key.key_material, key, key_len);
+	} else {
+		encrypt_key.key_disable = true;
+	}
+
+	status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key);
+
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
+		ret = -EFAULT;
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to set power management parameters.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	u32 ps_mode;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	ps_mode = power_on;
+	status = mwifiex_pm_ioctl_ps_mode(priv, wait, &ps_mode,
+					  HostCmd_ACT_GEN_SET);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to get extended version.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_get_ver_ext(struct mwifiex_private *priv)
+{
+	struct mwifiex_ver_ext ver_ext;
+	struct mwifiex_wait_queue *wait = NULL;
+	int status = 0;
+	int ret = 0;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	/* get fw version */
+	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
+	status = mwifiex_get_info_ver_ext(priv, wait, &ver_ext);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
+
+	if (ret)
+		ret = -1;
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to get statistics information.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_get_stats_info(struct mwifiex_private *priv,
+		       struct mwifiex_ds_get_stats *log)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_get_stats get_log;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
+		return -ENOMEM;
+
+	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
+	status = mwifiex_get_info_stats(priv, wait, &get_log);
+
+	/* Send IOCTL request to MWIFIEX */
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (!ret) {
+		if (log)
+			memcpy(log, &get_log, sizeof(struct
+					mwifiex_ds_get_stats));
+		priv->w_stats.discard.fragment = get_log.fcs_error;
+		priv->w_stats.discard.retries = get_log.retry;
+		priv->w_stats.discard.misc = get_log.ack_failure;
+	}
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * IOCTL request handler to read/write register.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ *
+ * Access to the following registers are supported -
+ *      - MAC
+ *      - BBP
+ *      - RF
+ *      - PMIC
+ *      - CAU
+ */
+static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
+					struct mwifiex_wait_queue *wait,
+					struct mwifiex_ds_reg_rw *reg_rw,
+					u16 action)
+{
+	int ret = 0;
+	u16 cmd_no;
+
+	switch (le32_to_cpu(reg_rw->type)) {
+	case MWIFIEX_REG_MAC:
+		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_BBP:
+		cmd_no = HostCmd_CMD_BBP_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_RF:
+		cmd_no = HostCmd_CMD_RF_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_PMIC:
+		cmd_no = HostCmd_CMD_PMIC_REG_ACCESS;
+		break;
+	case MWIFIEX_REG_CAU:
+		cmd_no = HostCmd_CMD_CAU_REG_ACCESS;
+		break;
+	default:
+		return -1;
+	}
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to write to a register.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
+		  u32 reg_offset, u32 reg_value)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_reg_rw reg_rw;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	reg_rw.type = cpu_to_le32(reg_type);
+	reg_rw.offset = cpu_to_le32(reg_offset);
+	reg_rw.value = cpu_to_le32(reg_value);
+	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
+					      HostCmd_ACT_GEN_SET);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
+
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to read from a register.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
+		 u32 reg_offset, u32 *value)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_reg_rw reg_rw;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	reg_rw.type = cpu_to_le32(reg_type);
+	reg_rw.offset = cpu_to_le32(reg_offset);
+	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
+					      HostCmd_ACT_GEN_GET);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
+	if (ret)
+		goto done;
+
+	*value = le32_to_cpu(reg_rw.value);
+
+done:
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * IOCTL request handler to read EEPROM.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+static int
+mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_ds_read_eeprom *rd_eeprom)
+{
+	int ret = 0;
+
+	/* Send request to firmware */
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
+				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * Sends IOCTL request to read from EEPROM.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
+		    u8 *value)
+{
+	int ret = 0;
+	int status = 0;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_read_eeprom rd_eeprom;
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait)
+		return -ENOMEM;
+
+	rd_eeprom.offset = cpu_to_le16((u16) offset);
+	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
+	status = mwifiex_reg_mem_ioctl_read_eeprom(priv, wait, &rd_eeprom);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
+	if (ret)
+		goto done;
+
+	memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
+done:
+	kfree(wait);
+	return ret;
+}
+
+/*
+ * This function sets a generic IE. In addition to generic IE, it can
+ * also handle WPA, WPA2 and WAPI IEs.
+ */
+static int
+mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
+			  u16 ie_len)
+{
+	int ret = 0;
+	struct ieee_types_vendor_header *pvendor_ie;
+	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
+	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
+
+	/* If the passed length is zero, reset the buffer */
+	if (!ie_len) {
+		priv->gen_ie_buf_len = 0;
+		priv->wps.session_enable = false;
+
+		return 0;
+	} else if (!ie_data_ptr) {
+		return -1;
+	}
+	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
+	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
+	if (((pvendor_ie->element_id == WLAN_EID_WPA)
+	     && (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui))))
+			|| (pvendor_ie->element_id == WLAN_EID_RSN)) {
+
+		/* IE is a WPA/WPA2 IE so call set_wpa function */
+		ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr, ie_len);
+		priv->wps.session_enable = false;
+
+		return ret;
+	} else if (pvendor_ie->element_id == WLAN_EID_BSS_AC_ACCESS_DELAY) {
+		/* IE is a WAPI IE so call set_wapi function */
+		ret = mwifiex_set_wapi_ie(priv, ie_data_ptr, ie_len);
+
+		return ret;
+	}
+	/*
+	 * Verify that the passed length is not larger than the
+	 * available space remaining in the buffer
+	 */
+	if (ie_len < (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
+
+		/* Test to see if it is a WPS IE, if so, enable
+		 * wps session flag
+		 */
+		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
+		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC)
+				&& (!memcmp(pvendor_ie->oui, wps_oui,
+						sizeof(wps_oui)))) {
+			priv->wps.session_enable = true;
+			dev_dbg(priv->adapter->dev,
+				"info: WPS Session Enabled.\n");
+		}
+
+		/* Append the passed data to the end of the
+		   genIeBuffer */
+		memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len, ie_data_ptr,
+									ie_len);
+		/* Increment the stored buffer length by the
+		   size passed */
+		priv->gen_ie_buf_len += ie_len;
+	} else {
+		/* Passed data does not fit in the remaining
+		   buffer space */
+		ret = -1;
+	}
+
+	/* Return 0, or -1 for error case */
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get generic IE.
+ *
+ * In addition to various generic IEs, this function can also be
+ * used to set the ARP filter.
+ */
+static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
+				     struct mwifiex_ds_misc_gen_ie *gen_ie,
+				     u16 action)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	switch (gen_ie->type) {
+	case MWIFIEX_IE_TYPE_GEN_IE:
+		if (action == HostCmd_ACT_GEN_GET) {
+			gen_ie->len = priv->wpa_ie_len;
+			memcpy(gen_ie->ie_data, priv->wpa_ie, gen_ie->len);
+		} else {
+			mwifiex_set_gen_ie_helper(priv, gen_ie->ie_data,
+						  (u16) gen_ie->len);
+		}
+		break;
+	case MWIFIEX_IE_TYPE_ARP_FILTER:
+		memset(adapter->arp_filter, 0, sizeof(adapter->arp_filter));
+		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
+			adapter->arp_filter_size = 0;
+			dev_err(adapter->dev, "invalid ARP filter size\n");
+			return -1;
+		} else {
+			memcpy(adapter->arp_filter, gen_ie->ie_data,
+								gen_ie->len);
+			adapter->arp_filter_size = gen_ie->len;
+		}
+		break;
+	default:
+		dev_err(adapter->dev, "invalid IE type\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Sends IOCTL request to set a generic IE.
+ *
+ * This function allocates the IOCTL request buffer, fills it
+ * with requisite parameters and calls the IOCTL handler.
+ */
+int
+mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
+{
+	struct mwifiex_ds_misc_gen_ie gen_ie;
+	int status = 0;
+
+	if (ie_len > IW_CUSTOM_MAX)
+		return -EFAULT;
+
+	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
+	gen_ie.len = ie_len;
+	memcpy(gen_ie.ie_data, ie, ie_len);
+	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
+	if (status)
+		return -EFAULT;
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
new file mode 100644
index 0000000..8282679
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -0,0 +1,182 @@
+/*
+ * Marvell Wireless LAN device driver: station RX data handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "11n_aggr.h"
+#include "11n_rxreorder.h"
+
+/*
+ * This function processes the received packet and forwards it
+ * to kernel/upper layer.
+ *
+ * This function parses through the received packet and determines
+ * if it is a debug packet or normal packet.
+ *
+ * For non-debug packets, the function chops off unnecessary leading
+ * header bytes, reconstructs the packet as an ethernet frame or
+ * 802.2/llc/snap frame as required, and sends it to kernel/upper layer.
+ *
+ * The completion callback is called after processing in complete.
+ */
+int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+			      struct sk_buff *skb)
+{
+	int ret = 0;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
+	struct rx_packet_hdr *rx_pkt_hdr;
+	struct rxpd *local_rx_pd;
+	int hdr_chop;
+	struct ethhdr *eth_hdr;
+	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+
+	local_rx_pd = (struct rxpd *) (skb->data);
+
+	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
+				local_rx_pd->rx_pkt_offset);
+
+	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
+		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
+		/*
+		 *  Replace the 803 header and rfc1042 header (llc/snap) with an
+		 *    EthernetII header, keep the src/dst and snap_type
+		 *    (ethertype).
+		 *  The firmware only passes up SNAP frames converting
+		 *    all RX Data from 802.11 to 802.2/LLC/SNAP frames.
+		 *  To create the Ethernet II, just move the src, dst address
+		 *    right before the snap_type.
+		 */
+		eth_hdr = (struct ethhdr *)
+			((u8 *) &rx_pkt_hdr->eth803_hdr
+			 + sizeof(rx_pkt_hdr->eth803_hdr) +
+			 sizeof(rx_pkt_hdr->rfc1042_hdr)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_dest)
+			 - sizeof(rx_pkt_hdr->eth803_hdr.h_source)
+			 - sizeof(rx_pkt_hdr->rfc1042_hdr.snap_type));
+
+		memcpy(eth_hdr->h_source, rx_pkt_hdr->eth803_hdr.h_source,
+		       sizeof(eth_hdr->h_source));
+		memcpy(eth_hdr->h_dest, rx_pkt_hdr->eth803_hdr.h_dest,
+		       sizeof(eth_hdr->h_dest));
+
+		/* Chop off the rxpd + the excess memory from the 802.2/llc/snap
+		   header that was removed. */
+		hdr_chop = (u8 *) eth_hdr - (u8 *) local_rx_pd;
+	} else {
+		/* Chop off the rxpd */
+		hdr_chop = (u8 *) &rx_pkt_hdr->eth803_hdr -
+			(u8 *) local_rx_pd;
+	}
+
+	/* Chop off the leading header bytes so the it points to the start of
+	   either the reconstructed EthII frame or the 802.2/llc/snap frame */
+	skb_pull(skb, hdr_chop);
+
+	priv->rxpd_rate = local_rx_pd->rx_rate;
+
+	priv->rxpd_htinfo = local_rx_pd->ht_info;
+
+	ret = mwifiex_recv_packet(adapter, skb);
+	if (ret == -1)
+		dev_err(adapter->dev, "recv packet failed\n");
+
+	return ret;
+}
+
+/*
+ * This function processes the received buffer.
+ *
+ * The function looks into the RxPD and performs sanity tests on the
+ * received buffer to ensure its a valid packet, before processing it
+ * further. If the packet is determined to be aggregated, it is
+ * de-aggregated accordingly. Non-unicast packets are sent directly to
+ * the kernel/upper layers. Unicast packets are handed over to the
+ * Rx reordering routine if 11n is enabled.
+ *
+ * The completion callback is called after processing in complete.
+ */
+int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
+				  struct sk_buff *skb)
+{
+	int ret = 0;
+	struct rxpd *local_rx_pd;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct rx_packet_hdr *rx_pkt_hdr;
+	u8 ta[ETH_ALEN];
+	u16 rx_pkt_type = 0;
+	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
+
+	local_rx_pd = (struct rxpd *) (skb->data);
+	rx_pkt_type = local_rx_pd->rx_pkt_type;
+
+	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
+					local_rx_pd->rx_pkt_offset);
+
+	if ((local_rx_pd->rx_pkt_offset + local_rx_pd->rx_pkt_length) >
+	    (u16) skb->len) {
+		dev_err(adapter->dev, "wrong rx packet: len=%d,"
+			" rx_pkt_offset=%d, rx_pkt_length=%d\n", skb->len,
+		       local_rx_pd->rx_pkt_offset, local_rx_pd->rx_pkt_length);
+		priv->stats.rx_dropped++;
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+	if (local_rx_pd->rx_pkt_type == PKT_TYPE_AMSDU) {
+		mwifiex_11n_deaggregate_pkt(priv, skb);
+		return ret;
+	}
+	/*
+	 * If the packet is not an unicast packet then send the packet
+	 * directly to os. Don't pass thru rx reordering
+	 */
+	if (!IS_11N_ENABLED(priv) ||
+	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
+		mwifiex_process_rx_packet(adapter, skb);
+		return ret;
+	}
+
+	if (mwifiex_queuing_ra_based(priv)) {
+		memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
+	} else {
+		if (rx_pkt_type != PKT_TYPE_BAR)
+			priv->rx_seq[local_rx_pd->priority] =
+						local_rx_pd->seq_num;
+		memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
+		       ETH_ALEN);
+	}
+
+	/* Reorder and send to OS */
+	ret = mwifiex_11n_rx_reorder_pkt(priv, local_rx_pd->seq_num,
+					     local_rx_pd->priority, ta,
+					     (u8) local_rx_pd->rx_pkt_type,
+						(void *) skb);
+
+	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
+		if (priv && (ret == -1))
+			priv->stats.rx_dropped++;
+
+		dev_kfree_skb_any(skb);
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
new file mode 100644
index 0000000..e8db6bd
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -0,0 +1,202 @@
+/*
+ * Marvell Wireless LAN device driver: station TX data handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+
+/*
+ * This function fills the TxPD for tx packets.
+ *
+ * The Tx buffer received by this function should already have the
+ * header space allocated for TxPD.
+ *
+ * This function inserts the TxPD in between interface header and actual
+ * data and adjusts the buffer pointers accordingly.
+ *
+ * The following TxPD fields are set by this function, as required -
+ *      - BSS number
+ *      - Tx packet length and offset
+ *      - Priority
+ *      - Packet delay
+ *      - Priority specific Tx control
+ *      - Flags
+ */
+void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
+				struct sk_buff *skb)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct txpd *local_tx_pd;
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+
+	if (!skb->len) {
+		dev_err(adapter->dev, "Tx: bad packet length: %d\n",
+		       skb->len);
+		tx_info->status_code = MWIFIEX_ERROR_PKT_SIZE_INVALID;
+		return skb->data;
+	}
+
+	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN));
+	skb_push(skb, sizeof(*local_tx_pd));
+
+	local_tx_pd = (struct txpd *) skb->data;
+	memset(local_tx_pd, 0, sizeof(struct txpd));
+	local_tx_pd->bss_num = priv->bss_num;
+	local_tx_pd->bss_type = priv->bss_type;
+	local_tx_pd->tx_pkt_length = cpu_to_le16((u16) (skb->len -
+							sizeof(struct txpd)));
+
+	local_tx_pd->priority = (u8) skb->priority;
+	local_tx_pd->pkt_delay_2ms =
+		mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
+
+	if (local_tx_pd->priority <
+	    ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
+		/*
+		 * Set the priority specific tx_control field, setting of 0 will
+		 *   cause the default value to be used later in this function
+		 */
+		local_tx_pd->tx_control =
+			cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[local_tx_pd->
+							 priority]);
+
+	if (adapter->pps_uapsd_mode) {
+		if (mwifiex_check_last_packet_indication(priv)) {
+			adapter->tx_lock_flag = true;
+			local_tx_pd->flags =
+				MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET;
+		}
+	}
+
+	/* Offset of actual data */
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+
+	/* make space for INTF_HEADER_LEN */
+	skb_push(skb, INTF_HEADER_LEN);
+
+	if (!local_tx_pd->tx_control)
+		/* TxCtrl set by user or default */
+		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
+
+	return skb->data;
+}
+
+/*
+ * This function tells firmware to send a NULL data packet.
+ *
+ * The function creates a NULL data packet with TxPD and sends to the
+ * firmware for transmission, with highest priority setting.
+ */
+int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct txpd *local_tx_pd;
+/* sizeof(struct txpd) + Interface specific header */
+#define NULL_PACKET_HDR 64
+	u32 data_len = NULL_PACKET_HDR;
+	struct sk_buff *skb = NULL;
+	int ret = 0;
+	struct mwifiex_txinfo *tx_info = NULL;
+
+	if (adapter->surprise_removed)
+		return -1;
+
+	if (!priv->media_connected)
+		return -1;
+
+	if (adapter->data_sent)
+		return -1;
+
+	skb = dev_alloc_skb(data_len);
+	if (!skb)
+		return -1;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_index = priv->bss_index;
+	skb_reserve(skb, sizeof(struct txpd) + INTF_HEADER_LEN);
+	skb_push(skb, sizeof(struct txpd));
+
+	local_tx_pd = (struct txpd *) skb->data;
+	local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
+	local_tx_pd->flags = flags;
+	local_tx_pd->priority = WMM_HIGHEST_PRIORITY;
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+	local_tx_pd->bss_num = priv->bss_num;
+	local_tx_pd->bss_type = priv->bss_type;
+
+	skb_push(skb, INTF_HEADER_LEN);
+
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					     skb->data, skb->len, NULL);
+	switch (ret) {
+	case -EBUSY:
+		adapter->data_sent = true;
+		/* Fall through FAILURE handling */
+	case -1:
+		dev_kfree_skb_any(skb);
+		dev_err(adapter->dev, "%s: host_to_card failed: ret=%d\n",
+						__func__, ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		break;
+	case 0:
+		dev_kfree_skb_any(skb);
+		dev_dbg(adapter->dev, "data: %s: host_to_card succeeded\n",
+						__func__);
+		adapter->tx_lock_flag = true;
+		break;
+	case -EINPROGRESS:
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * This function checks if we need to send last packet indication.
+ */
+u8
+mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 ret = false;
+	u8 prop_ps = true;
+
+	if (!adapter->sleep_period.period)
+		return ret;
+	if (mwifiex_wmm_lists_empty(adapter)) {
+		if ((priv->curr_bss_params.wmm_uapsd_enabled &&
+		     priv->wmm_qosinfo) || prop_ps)
+			ret = true;
+	}
+
+	if (ret && !adapter->cmd_sent && !adapter->curr_cmd
+	    && !is_command_pending(adapter)) {
+		adapter->delay_null_pkt = false;
+		ret = true;
+	} else {
+		ret = false;
+		adapter->delay_null_pkt = true;
+	}
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
new file mode 100644
index 0000000..f06923c
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -0,0 +1,202 @@
+/*
+ * Marvell Wireless LAN device driver: generic TX/RX data handling
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+
+/*
+ * This function processes the received buffer.
+ *
+ * Main responsibility of this function is to parse the RxPD to
+ * identify the correct interface this packet is headed for and
+ * forwarding it to the associated handling function, where the
+ * packet will be further processed and sent to kernel/upper layer
+ * if required.
+ */
+int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
+			     struct sk_buff *skb)
+{
+	int ret = 0;
+	struct mwifiex_private *priv =
+		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	struct rxpd *local_rx_pd;
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+
+	local_rx_pd = (struct rxpd *) (skb->data);
+	/* Get the BSS number from rxpd, get corresponding priv */
+	priv = mwifiex_get_priv_by_id(adapter, local_rx_pd->bss_num &
+				      BSS_NUM_MASK, local_rx_pd->bss_type);
+	if (!priv)
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
+	rx_info->bss_index = priv->bss_index;
+	ret = mwifiex_process_sta_rx_packet(adapter, skb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
+
+/*
+ * This function sends a packet to device.
+ *
+ * It processes the packet to add the TxPD, checks condition and
+ * sends the processed packet to firmware for transmission.
+ *
+ * On successful completion, the function calls the completion callback
+ * and logs the time.
+ */
+int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
+		       struct mwifiex_tx_param *tx_param)
+{
+	int ret = -1;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 *head_ptr = NULL;
+	struct txpd *local_tx_pd = NULL;
+
+	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
+	if (head_ptr) {
+		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+			local_tx_pd =
+				(struct txpd *) (head_ptr + INTF_HEADER_LEN);
+
+		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					     skb->data, skb->len, tx_param);
+	}
+
+	switch (ret) {
+	case -EBUSY:
+		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+			(adapter->pps_uapsd_mode) &&
+			(adapter->tx_lock_flag)) {
+				priv->adapter->tx_lock_flag = false;
+				local_tx_pd->flags = 0;
+		}
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		break;
+	case -1:
+		adapter->data_sent = false;
+		dev_err(adapter->dev, "mwifiex_write_data_async failed: 0x%X\n",
+		       ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, skb, ret);
+		break;
+	case -EINPROGRESS:
+		adapter->data_sent = false;
+		break;
+	case 0:
+		mwifiex_write_data_complete(adapter, skb, ret);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Packet send completion callback handler.
+ *
+ * It either frees the buffer directly or forwards it to another
+ * completion callback which checks conditions, updates statistics,
+ * wakes up stalled traffic queue if required, and then frees the buffer.
+ */
+int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
+				struct sk_buff *skb, int status)
+{
+	struct mwifiex_private *priv = NULL, *tpriv = NULL;
+	struct mwifiex_txinfo *tx_info = NULL;
+	int i;
+
+	if (!skb)
+		return 0;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, tx_info->bss_index);
+	if (!priv)
+		goto done;
+
+	priv->netdev->trans_start = jiffies;
+	if (!status) {
+		priv->stats.tx_packets++;
+		priv->stats.tx_bytes += skb->len;
+	} else {
+		priv->stats.tx_errors++;
+	}
+	atomic_dec(&adapter->tx_pending);
+
+	for (i = 0; i < adapter->priv_num; i++) {
+
+		tpriv = adapter->priv[i];
+
+		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA)
+				&& (tpriv->media_connected)) {
+			if (netif_queue_stopped(tpriv->netdev))
+				netif_wake_queue(tpriv->netdev);
+		}
+	}
+done:
+	dev_kfree_skb_any(skb);
+
+	return 0;
+}
+
+/*
+ * Packet receive completion callback handler.
+ *
+ * This function calls another completion callback handler which
+ * updates the statistics, and optionally updates the parent buffer
+ * use count before freeing the received packet.
+ */
+int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
+				 struct sk_buff *skb, int status)
+{
+	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
+	struct mwifiex_rxinfo *rx_info_parent = NULL;
+	struct mwifiex_private *priv;
+	struct sk_buff *skb_parent = NULL;
+	unsigned long flags;
+
+	priv = adapter->priv[rx_info->bss_index];
+
+	if (priv && (status == -1))
+		priv->stats.rx_dropped++;
+
+	if (rx_info->parent) {
+		skb_parent = rx_info->parent;
+		rx_info_parent = MWIFIEX_SKB_RXCB(skb_parent);
+
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
+		--rx_info_parent->use_count;
+
+		if (!rx_info_parent->use_count) {
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+			dev_kfree_skb_any(skb_parent);
+		} else {
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
+		}
+	} else {
+		dev_kfree_skb_any(skb);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
new file mode 100644
index 0000000..205022a
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -0,0 +1,252 @@
+/*
+ * Marvell Wireless LAN device driver: utility functions
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+/*
+ * Firmware initialization complete callback handler.
+ *
+ * This function wakes up the function waiting on the init
+ * wait queue for the firmware initialization to complete.
+ */
+int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
+{
+
+	adapter->init_wait_q_woken = true;
+	wake_up_interruptible(&adapter->init_wait_q);
+	return 0;
+}
+
+/*
+ * Firmware shutdown complete callback handler.
+ *
+ * This function sets the hardware status to not ready and wakes up
+ * the function waiting on the init wait queue for the firmware
+ * shutdown to complete.
+ */
+int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
+{
+	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
+	adapter->init_wait_q_woken = true;
+	wake_up_interruptible(&adapter->init_wait_q);
+	return 0;
+}
+
+/*
+ * IOCTL request handler to send function init/shutdown command
+ * to firmware.
+ *
+ * This function prepares the correct firmware command and
+ * issues it.
+ */
+int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
+				     struct mwifiex_wait_queue *wait,
+				     u32 func_init_shutdown)
+{
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
+	int ret;
+	u16 cmd;
+
+	if (func_init_shutdown == MWIFIEX_FUNC_INIT) {
+		cmd = HostCmd_CMD_FUNC_INIT;
+	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
+		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
+	} else {
+		dev_err(adapter->dev, "unsupported parameter\n");
+		return -1;
+	}
+
+	/* Send command to firmware */
+	ret = mwifiex_prepare_cmd(priv, cmd, HostCmd_ACT_GEN_SET,
+				  0, wait, NULL);
+
+	if (!ret)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
+ * IOCTL request handler to set/get debug information.
+ *
+ * This function collates/sets the information from/to different driver
+ * structures.
+ */
+int mwifiex_get_debug_info(struct mwifiex_private *priv,
+			   struct mwifiex_debug_info *info)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (info) {
+		memcpy(info->packets_out,
+		       priv->wmm.packets_out,
+		       sizeof(priv->wmm.packets_out));
+		info->max_tx_buf_size = (u32) adapter->max_tx_buf_size;
+		info->tx_buf_size = (u32) adapter->tx_buf_size;
+		info->rx_tbl_num = mwifiex_get_rx_reorder_tbl(
+					priv, info->rx_tbl);
+		info->tx_tbl_num = mwifiex_get_tx_ba_stream_tbl(
+					priv, info->tx_tbl);
+		info->ps_mode = adapter->ps_mode;
+		info->ps_state = adapter->ps_state;
+		info->is_deep_sleep = adapter->is_deep_sleep;
+		info->pm_wakeup_card_req = adapter->pm_wakeup_card_req;
+		info->pm_wakeup_fw_try = adapter->pm_wakeup_fw_try;
+		info->is_hs_configured = adapter->is_hs_configured;
+		info->hs_activated = adapter->hs_activated;
+		info->num_cmd_host_to_card_failure
+			= adapter->dbg.num_cmd_host_to_card_failure;
+		info->num_cmd_sleep_cfm_host_to_card_failure
+			= adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure;
+		info->num_tx_host_to_card_failure
+			= adapter->dbg.num_tx_host_to_card_failure;
+		info->num_event_deauth = adapter->dbg.num_event_deauth;
+		info->num_event_disassoc = adapter->dbg.num_event_disassoc;
+		info->num_event_link_lost = adapter->dbg.num_event_link_lost;
+		info->num_cmd_deauth = adapter->dbg.num_cmd_deauth;
+		info->num_cmd_assoc_success =
+			adapter->dbg.num_cmd_assoc_success;
+		info->num_cmd_assoc_failure =
+			adapter->dbg.num_cmd_assoc_failure;
+		info->num_tx_timeout = adapter->dbg.num_tx_timeout;
+		info->num_cmd_timeout = adapter->dbg.num_cmd_timeout;
+		info->timeout_cmd_id = adapter->dbg.timeout_cmd_id;
+		info->timeout_cmd_act = adapter->dbg.timeout_cmd_act;
+		memcpy(info->last_cmd_id, adapter->dbg.last_cmd_id,
+		       sizeof(adapter->dbg.last_cmd_id));
+		memcpy(info->last_cmd_act, adapter->dbg.last_cmd_act,
+		       sizeof(adapter->dbg.last_cmd_act));
+		info->last_cmd_index = adapter->dbg.last_cmd_index;
+		memcpy(info->last_cmd_resp_id, adapter->dbg.last_cmd_resp_id,
+		       sizeof(adapter->dbg.last_cmd_resp_id));
+		info->last_cmd_resp_index = adapter->dbg.last_cmd_resp_index;
+		memcpy(info->last_event, adapter->dbg.last_event,
+		       sizeof(adapter->dbg.last_event));
+		info->last_event_index = adapter->dbg.last_event_index;
+		info->data_sent = adapter->data_sent;
+		info->cmd_sent = adapter->cmd_sent;
+		info->cmd_resp_received = adapter->cmd_resp_received;
+	}
+
+	return 0;
+}
+
+/*
+ * This function processes the received packet before sending it to the
+ * kernel.
+ *
+ * It extracts the SKB from the received buffer and sends it to kernel.
+ * In case the received buffer does not contain the data in SKB format,
+ * the function creates a blank SKB, fills it with the data from the
+ * received buffer and then sends this new SKB to the kernel.
+ */
+int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+{
+	struct mwifiex_rxinfo *rx_info = NULL;
+	struct mwifiex_private *priv = NULL;
+
+	if (!skb)
+		return -1;
+
+	rx_info = MWIFIEX_SKB_RXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
+	if (!priv)
+		return -1;
+
+	skb->dev = priv->netdev;
+	skb->protocol = eth_type_trans(skb, priv->netdev);
+	skb->ip_summed = CHECKSUM_NONE;
+	priv->stats.rx_bytes += skb->len;
+	priv->stats.rx_packets++;
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
+
+	return 0;
+}
+
+/*
+ * Receive packet completion callback handler.
+ *
+ * This function updates the statistics and frees the buffer SKB.
+ */
+int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
+			  struct sk_buff *skb, int status)
+{
+	struct mwifiex_private *priv = NULL;
+	struct mwifiex_rxinfo *rx_info = NULL;
+
+	if (!skb)
+		return 0;
+
+	rx_info = MWIFIEX_SKB_RXCB(skb);
+	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
+
+	if (priv && (status == -1))
+		priv->stats.rx_dropped++;
+
+	dev_kfree_skb_any(skb);
+
+	return 0;
+}
+
+/*
+ * IOCTL completion callback handler.
+ *
+ * This function is called when a pending IOCTL is completed.
+ *
+ * If work queue support is enabled, the function wakes up the
+ * corresponding waiting function. Otherwise, it processes the
+ * IOCTL response and frees the response buffer.
+ */
+int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
+			   struct mwifiex_wait_queue *wait_queue,
+			   int status)
+{
+	enum mwifiex_error_code status_code =
+		(enum mwifiex_error_code) wait_queue->status;
+
+	atomic_dec(&adapter->ioctl_pending);
+
+	dev_dbg(adapter->dev, "cmd: IOCTL completed: status=%d,"
+			" status_code=%#x\n", status, status_code);
+
+	if (wait_queue->enabled) {
+		*wait_queue->condition = true;
+		wait_queue->status = status;
+		if (status && (status_code == MWIFIEX_ERROR_CMD_TIMEOUT))
+			dev_err(adapter->dev, "cmd timeout\n");
+		else
+			wake_up_interruptible(wait_queue->wait);
+	} else {
+		if (status)
+			dev_err(adapter->dev, "cmd failed: status_code=%#x\n",
+			       status_code);
+		kfree(wait_queue);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
new file mode 100644
index 0000000..9506afc
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -0,0 +1,32 @@
+/*
+ * Marvell Wireless LAN device driver: utility functions
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_UTIL_H_
+#define _MWIFIEX_UTIL_H_
+
+static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
+{
+	return (struct mwifiex_rxinfo *)skb->cb;
+}
+
+static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
+{
+	return (struct mwifiex_txinfo *)skb->cb;
+}
+#endif /* !_MWIFIEX_UTIL_H_ */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
new file mode 100644
index 0000000..1cfbc6b
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -0,0 +1,1237 @@
+/*
+ * Marvell Wireless LAN device driver: WMM
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "util.h"
+#include "fw.h"
+#include "main.h"
+#include "wmm.h"
+#include "11n.h"
+
+
+/* Maximum value FW can accept for driver delay in packet transmission */
+#define DRV_PKT_DELAY_TO_FW_MAX   512
+
+
+#define WMM_QUEUED_PACKET_LOWER_LIMIT   180
+
+#define WMM_QUEUED_PACKET_UPPER_LIMIT   200
+
+/* Offset for TOS field in the IP header */
+#define IPTOS_OFFSET 5
+
+/* WMM information IE */
+static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
+	0x00, 0x50, 0xf2, 0x02,
+	0x00, 0x01, 0x00
+};
+
+static const u8 wmm_aci_to_qidx_map[] = { WMM_AC_BE,
+	WMM_AC_BK,
+	WMM_AC_VI,
+	WMM_AC_VO
+};
+
+static u8 tos_to_tid[] = {
+	/* TID DSCP_P2 DSCP_P1 DSCP_P0 WMM_AC */
+	0x01,			/* 0 1 0 AC_BK */
+	0x02,			/* 0 0 0 AC_BK */
+	0x00,			/* 0 0 1 AC_BE */
+	0x03,			/* 0 1 1 AC_BE */
+	0x04,			/* 1 0 0 AC_VI */
+	0x05,			/* 1 0 1 AC_VI */
+	0x06,			/* 1 1 0 AC_VO */
+	0x07			/* 1 1 1 AC_VO */
+};
+
+/*
+ * This table inverses the tos_to_tid operation to get a priority
+ * which is in sequential order, and can be compared.
+ * Use this to compare the priority of two different TIDs.
+ */
+static u8 tos_to_tid_inv[] = {
+	0x02,  /* from tos_to_tid[2] = 0 */
+	0x00,  /* from tos_to_tid[0] = 1 */
+	0x01,  /* from tos_to_tid[1] = 2 */
+	0x03,
+	0x04,
+	0x05,
+	0x06,
+	0x07};
+
+static u8 ac_to_tid[4][2] = { {1, 2}, {0, 3}, {4, 5}, {6, 7} };
+
+/*
+ * This function debug prints the priority parameters for a WMM AC.
+ */
+static void
+mwifiex_wmm_ac_debug_print(const struct ieee_types_wmm_ac_parameters *ac_param)
+{
+	const char *ac_str[] = { "BK", "BE", "VI", "VO" };
+
+	pr_debug("info: WMM AC_%s: ACI=%d, ACM=%d, Aifsn=%d, "
+	       "EcwMin=%d, EcwMax=%d, TxopLimit=%d\n",
+	       ac_str[wmm_aci_to_qidx_map[(ac_param->aci_aifsn_bitmap
+	       & MWIFIEX_ACI) >> 5]],
+	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACI) >> 5,
+	       (ac_param->aci_aifsn_bitmap & MWIFIEX_ACM) >> 4,
+	       ac_param->aci_aifsn_bitmap & MWIFIEX_AIFSN,
+	       ac_param->ecw_bitmap & MWIFIEX_ECW_MIN,
+	       (ac_param->ecw_bitmap & MWIFIEX_ECW_MAX) >> 4,
+	       le16_to_cpu(ac_param->tx_op_limit));
+}
+
+/*
+ * This function allocates a route address list.
+ *
+ * The function also initializes the list with the provided RA.
+ */
+static struct mwifiex_ra_list_tbl *
+mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+
+	ra_list = kzalloc(sizeof(struct mwifiex_ra_list_tbl), GFP_ATOMIC);
+
+	if (!ra_list) {
+		dev_err(adapter->dev, "%s: failed to alloc ra_list\n",
+						__func__);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ra_list->list);
+	skb_queue_head_init(&ra_list->skb_head);
+
+	memcpy(ra_list->ra, ra, ETH_ALEN);
+
+	ra_list->total_pkts_size = 0;
+
+	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
+
+	return ra_list;
+}
+
+/*
+ * This function allocates and adds a RA list for all TIDs
+ * with the given RA.
+ */
+void
+mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
+{
+	int i;
+	struct mwifiex_ra_list_tbl *ra_list;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	for (i = 0; i < MAX_NUM_TID; ++i) {
+		ra_list = mwifiex_wmm_allocate_ralist_node(adapter, ra);
+		dev_dbg(adapter->dev, "info: created ra_list %p\n", ra_list);
+
+		if (!ra_list)
+			break;
+
+		if (!mwifiex_queuing_ra_based(priv))
+			ra_list->is_11n_enabled = IS_11N_ENABLED(priv);
+		else
+			ra_list->is_11n_enabled = false;
+
+		dev_dbg(adapter->dev, "data: ralist %p: is_11n_enabled=%d\n",
+			ra_list, ra_list->is_11n_enabled);
+
+		list_add_tail(&ra_list->list,
+				&priv->wmm.tid_tbl_ptr[i].ra_list);
+
+		if (!priv->wmm.tid_tbl_ptr[i].ra_list_curr)
+			priv->wmm.tid_tbl_ptr[i].ra_list_curr = ra_list;
+	}
+}
+
+/*
+ * This function sets the WMM queue priorities to their default values.
+ */
+static void mwifiex_wmm_default_queue_priorities(struct mwifiex_private *priv)
+{
+	/* Default queue priorities: VO->VI->BE->BK */
+	priv->wmm.queue_priority[0] = WMM_AC_VO;
+	priv->wmm.queue_priority[1] = WMM_AC_VI;
+	priv->wmm.queue_priority[2] = WMM_AC_BE;
+	priv->wmm.queue_priority[3] = WMM_AC_BK;
+}
+
+/*
+ * This function map ACs to TIDs.
+ */
+static void
+mwifiex_wmm_queue_priorities_tid(struct mwifiex_private *priv,
+				 u8 queue_priority[])
+{
+	int i;
+
+	for (i = 0; i < 4; ++i) {
+		tos_to_tid[7 - (i * 2)] = ac_to_tid[queue_priority[i]][1];
+		tos_to_tid[6 - (i * 2)] = ac_to_tid[queue_priority[i]][0];
+	}
+}
+
+/*
+ * This function initializes WMM priority queues.
+ */
+void
+mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
+				   struct ieee_types_wmm_parameter *wmm_ie)
+{
+	u16 cw_min, avg_back_off, tmp[4];
+	u32 i, j, num_ac;
+	u8 ac_idx;
+
+	if (!wmm_ie || !priv->wmm_enabled) {
+		/* WMM is not enabled, just set the defaults and return */
+		mwifiex_wmm_default_queue_priorities(priv);
+		return;
+	}
+
+	dev_dbg(priv->adapter->dev, "info: WMM Parameter IE: version=%d, "
+		"qos_info Parameter Set Count=%d, Reserved=%#x\n",
+		wmm_ie->vend_hdr.version, wmm_ie->qos_info_bitmap &
+		IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK,
+		wmm_ie->reserved);
+
+	for (num_ac = 0; num_ac < ARRAY_SIZE(wmm_ie->ac_params); num_ac++) {
+		cw_min = (1 << (wmm_ie->ac_params[num_ac].ecw_bitmap &
+			MWIFIEX_ECW_MIN)) - 1;
+		avg_back_off = (cw_min >> 1) +
+			(wmm_ie->ac_params[num_ac].aci_aifsn_bitmap &
+			MWIFIEX_AIFSN);
+
+		ac_idx = wmm_aci_to_qidx_map[(wmm_ie->ac_params[num_ac].
+					     aci_aifsn_bitmap &
+					     MWIFIEX_ACI) >> 5];
+		priv->wmm.queue_priority[ac_idx] = ac_idx;
+		tmp[ac_idx] = avg_back_off;
+
+		dev_dbg(priv->adapter->dev, "info: WMM: CWmax=%d CWmin=%d Avg Back-off=%d\n",
+		       (1 << ((wmm_ie->ac_params[num_ac].ecw_bitmap &
+		       MWIFIEX_ECW_MAX) >> 4)) - 1,
+		       cw_min, avg_back_off);
+		mwifiex_wmm_ac_debug_print(&wmm_ie->ac_params[num_ac]);
+	}
+
+	/* Bubble sort */
+	for (i = 0; i < num_ac; i++) {
+		for (j = 1; j < num_ac - i; j++) {
+			if (tmp[j - 1] > tmp[j]) {
+				swap(tmp[j - 1], tmp[j]);
+				swap(priv->wmm.queue_priority[j - 1],
+				     priv->wmm.queue_priority[j]);
+			} else if (tmp[j - 1] == tmp[j]) {
+				if (priv->wmm.queue_priority[j - 1]
+				    < priv->wmm.queue_priority[j])
+					swap(priv->wmm.queue_priority[j - 1],
+					     priv->wmm.queue_priority[j]);
+			}
+		}
+	}
+
+	mwifiex_wmm_queue_priorities_tid(priv, priv->wmm.queue_priority);
+}
+
+/*
+ * This function evaluates whether or not an AC is to be downgraded.
+ *
+ * In case the AC is not enabled, the highest AC is returned that is
+ * enabled and does not require admission control.
+ */
+static enum mwifiex_wmm_ac_e
+mwifiex_wmm_eval_downgrade_ac(struct mwifiex_private *priv,
+			      enum mwifiex_wmm_ac_e eval_ac)
+{
+	int down_ac;
+	enum mwifiex_wmm_ac_e ret_ac;
+	struct mwifiex_wmm_ac_status *ac_status;
+
+	ac_status = &priv->wmm.ac_status[eval_ac];
+
+	if (!ac_status->disabled)
+		/* Okay to use this AC, its enabled */
+		return eval_ac;
+
+	/* Setup a default return value of the lowest priority */
+	ret_ac = WMM_AC_BK;
+
+	/*
+	 *  Find the highest AC that is enabled and does not require
+	 *  admission control. The spec disallows downgrading to an AC,
+	 *  which is enabled due to a completed admission control.
+	 *  Unadmitted traffic is not to be sent on an AC with admitted
+	 *  traffic.
+	 */
+	for (down_ac = WMM_AC_BK; down_ac < eval_ac; down_ac++) {
+		ac_status = &priv->wmm.ac_status[down_ac];
+
+		if (!ac_status->disabled && !ac_status->flow_required)
+			/* AC is enabled and does not require admission
+			   control */
+			ret_ac = (enum mwifiex_wmm_ac_e) down_ac;
+	}
+
+	return ret_ac;
+}
+
+/*
+ * This function downgrades WMM priority queue.
+ */
+void
+mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
+{
+	int ac_val;
+
+	dev_dbg(priv->adapter->dev, "info: WMM: AC Priorities:"
+			"BK(0), BE(1), VI(2), VO(3)\n");
+
+	if (!priv->wmm_enabled) {
+		/* WMM is not enabled, default priorities */
+		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++)
+			priv->wmm.ac_down_graded_vals[ac_val] =
+				(enum mwifiex_wmm_ac_e) ac_val;
+	} else {
+		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++) {
+			priv->wmm.ac_down_graded_vals[ac_val]
+				= mwifiex_wmm_eval_downgrade_ac(priv,
+						(enum mwifiex_wmm_ac_e) ac_val);
+			dev_dbg(priv->adapter->dev, "info: WMM: AC PRIO %d maps to %d\n",
+				ac_val, priv->wmm.ac_down_graded_vals[ac_val]);
+		}
+	}
+}
+
+/*
+ * This function converts the IP TOS field to an WMM AC
+ * Queue assignment.
+ */
+static enum mwifiex_wmm_ac_e
+mwifiex_wmm_convert_tos_to_ac(struct mwifiex_adapter *adapter, u32 tos)
+{
+	/* Map of TOS UP values to WMM AC */
+	const enum mwifiex_wmm_ac_e tos_to_ac[] = { WMM_AC_BE,
+		WMM_AC_BK,
+		WMM_AC_BK,
+		WMM_AC_BE,
+		WMM_AC_VI,
+		WMM_AC_VI,
+		WMM_AC_VO,
+		WMM_AC_VO
+	};
+
+	if (tos >= ARRAY_SIZE(tos_to_ac))
+		return WMM_AC_BE;
+
+	return tos_to_ac[tos];
+}
+
+/*
+ * This function evaluates a given TID and downgrades it to a lower
+ * TID if the WMM Parameter IE received from the AP indicates that the
+ * AP is disabled (due to call admission control (ACM bit). Mapping
+ * of TID to AC is taken care of internally.
+ */
+static u8
+mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid)
+{
+	enum mwifiex_wmm_ac_e ac, ac_down;
+	u8 new_tid;
+
+	ac = mwifiex_wmm_convert_tos_to_ac(priv->adapter, tid);
+	ac_down = priv->wmm.ac_down_graded_vals[ac];
+
+	/* Send the index to tid array, picking from the array will be
+	 * taken care by dequeuing function
+	 */
+	new_tid = ac_to_tid[ac_down][tid % 2];
+
+	return new_tid;
+}
+
+/*
+ * This function initializes the WMM state information and the
+ * WMM data path queues.
+ */
+void
+mwifiex_wmm_init(struct mwifiex_adapter *adapter)
+{
+	int i, j;
+	struct mwifiex_private *priv;
+
+	for (j = 0; j < adapter->priv_num; ++j) {
+		priv = adapter->priv[j];
+		if (!priv)
+			continue;
+
+		for (i = 0; i < MAX_NUM_TID; ++i) {
+			priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
+			priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
+			priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
+		}
+
+		priv->aggr_prio_tbl[6].amsdu
+			= priv->aggr_prio_tbl[6].ampdu_ap
+			= priv->aggr_prio_tbl[6].ampdu_user
+			= BA_STREAM_NOT_ALLOWED;
+
+		priv->aggr_prio_tbl[7].amsdu = priv->aggr_prio_tbl[7].ampdu_ap
+			= priv->aggr_prio_tbl[7].ampdu_user
+			= BA_STREAM_NOT_ALLOWED;
+
+		priv->add_ba_param.timeout = MWIFIEX_DEFAULT_BLOCK_ACK_TIMEOUT;
+		priv->add_ba_param.tx_win_size = MWIFIEX_AMPDU_DEF_TXWINSIZE;
+		priv->add_ba_param.rx_win_size = MWIFIEX_AMPDU_DEF_RXWINSIZE;
+	}
+}
+
+/*
+ * This function checks if WMM Tx queue is empty.
+ */
+int
+mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
+{
+	int i, j;
+	struct mwifiex_private *priv;
+
+	for (j = 0; j < adapter->priv_num; ++j) {
+		priv = adapter->priv[j];
+		if (priv) {
+			for (i = 0; i < MAX_NUM_TID; i++)
+				if (!mwifiex_wmm_is_ra_list_empty(adapter,
+					     &priv->wmm.tid_tbl_ptr[i].ra_list))
+					return false;
+		}
+	}
+
+	return true;
+}
+
+/*
+ * This function deletes all packets in an RA list node.
+ *
+ * The packet sent completion callback handler are called with
+ * status failure, after they are dequeued to ensure proper
+ * cleanup. The RA list node itself is freed at the end.
+ */
+static void
+mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
+				    struct mwifiex_ra_list_tbl *ra_list)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct sk_buff *skb, *tmp;
+
+	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp)
+		mwifiex_write_data_complete(adapter, skb, -1);
+}
+
+/*
+ * This function deletes all packets in an RA list.
+ *
+ * Each nodes in the RA list are freed individually first, and then
+ * the RA list itself is freed.
+ */
+static void
+mwifiex_wmm_del_pkts_in_ralist(struct mwifiex_private *priv,
+			       struct list_head *ra_list_head)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+
+	list_for_each_entry(ra_list, ra_list_head, list)
+		mwifiex_wmm_del_pkts_in_ralist_node(priv, ra_list);
+}
+
+/*
+ * This function deletes all packets in all RA lists.
+ */
+static void mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
+{
+	int i;
+
+	for (i = 0; i < MAX_NUM_TID; i++)
+		mwifiex_wmm_del_pkts_in_ralist(priv, &priv->wmm.tid_tbl_ptr[i].
+						     ra_list);
+}
+
+/*
+ * This function deletes all route addresses from all RA lists.
+ */
+static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
+{
+	struct mwifiex_ra_list_tbl *ra_list, *tmp_node;
+	int i;
+
+	for (i = 0; i < MAX_NUM_TID; ++i) {
+		dev_dbg(priv->adapter->dev,
+				"info: ra_list: freeing buf for tid %d\n", i);
+		list_for_each_entry_safe(ra_list, tmp_node,
+				&priv->wmm.tid_tbl_ptr[i].ra_list, list) {
+			list_del(&ra_list->list);
+			kfree(ra_list);
+		}
+
+		INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[i].ra_list);
+
+		priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
+	}
+}
+
+/*
+ * This function cleans up the Tx and Rx queues.
+ *
+ * Cleanup includes -
+ *      - All packets in RA lists
+ *      - All entries in Rx reorder table
+ *      - All entries in Tx BA stream table
+ *      - MPA buffer (if required)
+ *      - All RA lists
+ */
+void
+mwifiex_clean_txrx(struct mwifiex_private *priv)
+{
+	unsigned long flags;
+
+	mwifiex_11n_cleanup_reorder_tbl(priv);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	mwifiex_wmm_cleanup_queues(priv);
+	mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
+
+	if (priv->adapter->if_ops.cleanup_mpa_buf)
+		priv->adapter->if_ops.cleanup_mpa_buf(priv->adapter);
+
+	mwifiex_wmm_delete_all_ralist(priv);
+	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
+/*
+ * This function retrieves a particular RA list node, matching with the
+ * given TID and RA address.
+ */
+static struct mwifiex_ra_list_tbl *
+mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
+			    u8 *ra_addr)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+
+	list_for_each_entry(ra_list, &priv->wmm.tid_tbl_ptr[tid].ra_list,
+			    list) {
+		if (!memcmp(ra_list->ra, ra_addr, ETH_ALEN))
+			return ra_list;
+	}
+
+	return NULL;
+}
+
+/*
+ * This function retrieves an RA list node for a given TID and
+ * RA address pair.
+ *
+ * If no such node is found, a new node is added first and then
+ * retrieved.
+ */
+static struct mwifiex_ra_list_tbl *
+mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+
+	ra_list = mwifiex_wmm_get_ralist_node(priv, tid, ra_addr);
+	if (ra_list)
+		return ra_list;
+	mwifiex_ralist_add(priv, ra_addr);
+
+	return mwifiex_wmm_get_ralist_node(priv, tid, ra_addr);
+}
+
+/*
+ * This function checks if a particular RA list node exists in a given TID
+ * table index.
+ */
+int
+mwifiex_is_ralist_valid(struct mwifiex_private *priv,
+			struct mwifiex_ra_list_tbl *ra_list, int ptr_index)
+{
+	struct mwifiex_ra_list_tbl *rlist;
+
+	list_for_each_entry(rlist, &priv->wmm.tid_tbl_ptr[ptr_index].ra_list,
+			    list) {
+		if (rlist == ra_list)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * This function adds a packet to WMM queue.
+ *
+ * In disconnected state the packet is immediately dropped and the
+ * packet send completion callback is called with status failure.
+ *
+ * Otherwise, the correct RA list node is located and the packet
+ * is queued at the list tail.
+ */
+void
+mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
+			    struct sk_buff *skb)
+{
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+	struct mwifiex_private *priv = adapter->priv[tx_info->bss_index];
+	u32 tid;
+	struct mwifiex_ra_list_tbl *ra_list;
+	u8 ra[ETH_ALEN], tid_down;
+	unsigned long flags;
+
+	if (!priv->media_connected) {
+		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
+		mwifiex_write_data_complete(adapter, skb, -1);
+		return;
+	}
+
+	tid = skb->priority;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
+
+	/* In case of infra as we have already created the list during
+	   association we just don't have to call get_queue_raptr, we will
+	   have only 1 raptr for a tid in case of infra */
+	if (!mwifiex_queuing_ra_based(priv)) {
+		if (!list_empty(&priv->wmm.tid_tbl_ptr[tid_down].ra_list))
+			ra_list = list_first_entry(
+				&priv->wmm.tid_tbl_ptr[tid_down].ra_list,
+				struct mwifiex_ra_list_tbl, list);
+		else
+			ra_list = NULL;
+	} else {
+		memcpy(ra, skb->data, ETH_ALEN);
+		ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down, ra);
+	}
+
+	if (!ra_list) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		mwifiex_write_data_complete(adapter, skb, -1);
+		return;
+	}
+
+	skb_queue_tail(&ra_list->skb_head, skb);
+
+	ra_list->total_pkts_size += skb->len;
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
+/*
+ * This function processes the get WMM status command response from firmware.
+ *
+ * The response may contain multiple TLVs -
+ *      - AC Queue status TLVs
+ *      - Current WMM Parameter IE TLV
+ *      - Admission Control action frame TLVs
+ *
+ * This function parses the TLVs and then calls further specific functions
+ * to process any changes in the queue prioritize or state.
+ */
+int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
+			       const struct host_cmd_ds_command *resp)
+{
+	u8 *curr = (u8 *) &resp->params.get_wmm_status;
+	uint16_t resp_len = le16_to_cpu(resp->size), tlv_len;
+	int valid = true;
+
+	struct mwifiex_ie_types_data *tlv_hdr;
+	struct mwifiex_ie_types_wmm_queue_status *tlv_wmm_qstatus;
+	struct ieee_types_wmm_parameter *wmm_param_ie = NULL;
+	struct mwifiex_wmm_ac_status *ac_status;
+
+	dev_dbg(priv->adapter->dev, "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
+			resp_len);
+
+	while ((resp_len >= sizeof(tlv_hdr->header)) && valid) {
+		tlv_hdr = (struct mwifiex_ie_types_data *) curr;
+		tlv_len = le16_to_cpu(tlv_hdr->header.len);
+
+		switch (le16_to_cpu(tlv_hdr->header.type)) {
+		case TLV_TYPE_WMMQSTATUS:
+			tlv_wmm_qstatus =
+				(struct mwifiex_ie_types_wmm_queue_status *)
+				tlv_hdr;
+			dev_dbg(priv->adapter->dev,
+				"info: CMD_RESP: WMM_GET_STATUS:"
+				" QSTATUS TLV: %d, %d, %d\n",
+			       tlv_wmm_qstatus->queue_index,
+			       tlv_wmm_qstatus->flow_required,
+			       tlv_wmm_qstatus->disabled);
+
+			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
+							 queue_index];
+			ac_status->disabled = tlv_wmm_qstatus->disabled;
+			ac_status->flow_required =
+				tlv_wmm_qstatus->flow_required;
+			ac_status->flow_created = tlv_wmm_qstatus->flow_created;
+			break;
+
+		case WLAN_EID_VENDOR_SPECIFIC:
+			/*
+			 * Point the regular IEEE IE 2 bytes into the Marvell IE
+			 *   and setup the IEEE IE type and length byte fields
+			 */
+
+			wmm_param_ie =
+				(struct ieee_types_wmm_parameter *) (curr +
+								    2);
+			wmm_param_ie->vend_hdr.len = (u8) tlv_len;
+			wmm_param_ie->vend_hdr.element_id =
+						WLAN_EID_VENDOR_SPECIFIC;
+
+			dev_dbg(priv->adapter->dev,
+				"info: CMD_RESP: WMM_GET_STATUS:"
+				" WMM Parameter Set Count: %d\n",
+				wmm_param_ie->qos_info_bitmap &
+				IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK);
+
+			memcpy((u8 *) &priv->curr_bss_params.bss_descriptor.
+			       wmm_ie, wmm_param_ie,
+			       wmm_param_ie->vend_hdr.len + 2);
+
+			break;
+
+		default:
+			valid = false;
+			break;
+		}
+
+		curr += (tlv_len + sizeof(tlv_hdr->header));
+		resp_len -= (tlv_len + sizeof(tlv_hdr->header));
+	}
+
+	mwifiex_wmm_setup_queue_priorities(priv, wmm_param_ie);
+	mwifiex_wmm_setup_ac_downgrade(priv);
+
+	return 0;
+}
+
+/*
+ * Callback handler from the command module to allow insertion of a WMM TLV.
+ *
+ * If the BSS we are associating to supports WMM, this function adds the
+ * required WMM Information IE to the association request command buffer in
+ * the form of a Marvell extended IEEE IE.
+ */
+u32
+mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
+				    u8 **assoc_buf,
+				    struct ieee_types_wmm_parameter *wmm_ie,
+				    struct ieee80211_ht_cap *ht_cap)
+{
+	struct mwifiex_ie_types_wmm_param_set *wmm_tlv;
+	u32 ret_len = 0;
+
+	/* Null checks */
+	if (!assoc_buf)
+		return 0;
+	if (!(*assoc_buf))
+		return 0;
+
+	if (!wmm_ie)
+		return 0;
+
+	dev_dbg(priv->adapter->dev, "info: WMM: process assoc req:"
+			"bss->wmmIe=0x%x\n",
+			wmm_ie->vend_hdr.element_id);
+
+	if ((priv->wmm_required
+	     || (ht_cap && (priv->adapter->config_bands & BAND_GN
+		     || priv->adapter->config_bands & BAND_AN))
+	    )
+	    && wmm_ie->vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC) {
+		wmm_tlv = (struct mwifiex_ie_types_wmm_param_set *) *assoc_buf;
+		wmm_tlv->header.type = cpu_to_le16((u16) wmm_info_ie[0]);
+		wmm_tlv->header.len = cpu_to_le16((u16) wmm_info_ie[1]);
+		memcpy(wmm_tlv->wmm_ie, &wmm_info_ie[2],
+			le16_to_cpu(wmm_tlv->header.len));
+		if (wmm_ie->qos_info_bitmap & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD)
+			memcpy((u8 *) (wmm_tlv->wmm_ie
+					+ le16_to_cpu(wmm_tlv->header.len)
+					 - sizeof(priv->wmm_qosinfo)),
+					&priv->wmm_qosinfo,
+					sizeof(priv->wmm_qosinfo));
+
+		ret_len = sizeof(wmm_tlv->header)
+			+ le16_to_cpu(wmm_tlv->header.len);
+
+		*assoc_buf += ret_len;
+	}
+
+	return ret_len;
+}
+
+/*
+ * This function computes the time delay in the driver queues for a
+ * given packet.
+ *
+ * When the packet is received at the OS/Driver interface, the current
+ * time is set in the packet structure. The difference between the present
+ * time and that received time is computed in this function and limited
+ * based on pre-compiled limits in the driver.
+ */
+u8
+mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
+					const struct sk_buff *skb)
+{
+	u8 ret_val = 0;
+	struct timeval out_tstamp, in_tstamp;
+	u32 queue_delay;
+
+	do_gettimeofday(&out_tstamp);
+	in_tstamp = ktime_to_timeval(skb->tstamp);
+
+	queue_delay = (out_tstamp.tv_sec - in_tstamp.tv_sec) * 1000;
+	queue_delay += (out_tstamp.tv_usec - in_tstamp.tv_usec) / 1000;
+
+	/*
+	 * Queue delay is passed as a uint8 in units of 2ms (ms shifted
+	 *  by 1). Min value (other than 0) is therefore 2ms, max is 510ms.
+	 *
+	 * Pass max value if queue_delay is beyond the uint8 range
+	 */
+	ret_val = (u8) (min(queue_delay, priv->wmm.drv_pkt_delay_max) >> 1);
+
+	dev_dbg(priv->adapter->dev, "data: WMM: Pkt Delay: %d ms,"
+				" %d ms sent to FW\n", queue_delay, ret_val);
+
+	return ret_val;
+}
+
+/*
+ * This function retrieves the highest priority RA list table pointer.
+ */
+static struct mwifiex_ra_list_tbl *
+mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
+				     struct mwifiex_private **priv, int *tid)
+{
+	struct mwifiex_private *priv_tmp;
+	struct mwifiex_ra_list_tbl *ptr, *head;
+	struct mwifiex_bss_prio_node *bssprio_node, *bssprio_head;
+	struct mwifiex_tid_tbl *tid_ptr;
+	int is_list_empty;
+	unsigned long flags;
+	int i, j;
+
+	for (j = adapter->priv_num - 1; j >= 0; --j) {
+		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				flags);
+		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
+				.bss_prio_head);
+		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				flags);
+		if (is_list_empty)
+			continue;
+
+		if (adapter->bss_prio_tbl[j].bss_prio_cur ==
+		    (struct mwifiex_bss_prio_node *)
+		    &adapter->bss_prio_tbl[j].bss_prio_head) {
+			bssprio_node =
+				list_first_entry(&adapter->bss_prio_tbl[j]
+						 .bss_prio_head,
+						 struct mwifiex_bss_prio_node,
+						 list);
+			bssprio_head = bssprio_node;
+		} else {
+			bssprio_node = adapter->bss_prio_tbl[j].bss_prio_cur;
+			bssprio_head = bssprio_node;
+		}
+
+		do {
+			priv_tmp = bssprio_node->priv;
+
+			for (i = HIGH_PRIO_TID; i >= LOW_PRIO_TID; --i) {
+
+				tid_ptr = &(priv_tmp)->wmm.
+					tid_tbl_ptr[tos_to_tid[i]];
+
+				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
+						  flags);
+				is_list_empty =
+					list_empty(&adapter->bss_prio_tbl[j]
+						   .bss_prio_head);
+				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
+						       flags);
+				if (is_list_empty)
+					continue;
+
+				/*
+				 * Always choose the next ra we transmitted
+				 * last time, this way we pick the ra's in
+				 * round robin fashion.
+				 */
+				ptr = list_first_entry(
+						&tid_ptr->ra_list_curr->list,
+						struct mwifiex_ra_list_tbl,
+						list);
+
+				head = ptr;
+				if (ptr == (struct mwifiex_ra_list_tbl *)
+						&tid_ptr->ra_list) {
+					/* Get next ra */
+					ptr = list_first_entry(&ptr->list,
+					    struct mwifiex_ra_list_tbl, list);
+					head = ptr;
+				}
+
+				do {
+					is_list_empty =
+						skb_queue_empty(&ptr->skb_head);
+					if (!is_list_empty) {
+						*priv = priv_tmp;
+						*tid = tos_to_tid[i];
+						return ptr;
+					}
+					/* Get next ra */
+					ptr = list_first_entry(&ptr->list,
+						 struct mwifiex_ra_list_tbl,
+						 list);
+					if (ptr ==
+					    (struct mwifiex_ra_list_tbl *)
+					    &tid_ptr->ra_list)
+						ptr = list_first_entry(
+						    &ptr->list,
+						    struct mwifiex_ra_list_tbl,
+						    list);
+				} while (ptr != head);
+			}
+
+			/* Get next bss priority node */
+			bssprio_node = list_first_entry(&bssprio_node->list,
+						struct mwifiex_bss_prio_node,
+						list);
+
+			if (bssprio_node ==
+			    (struct mwifiex_bss_prio_node *)
+			    &adapter->bss_prio_tbl[j].bss_prio_head)
+				/* Get next bss priority node */
+				bssprio_node = list_first_entry(
+						&bssprio_node->list,
+						struct mwifiex_bss_prio_node,
+						list);
+		} while (bssprio_node != bssprio_head);
+	}
+	return NULL;
+}
+
+/*
+ * This function gets the number of packets in the Tx queue of a
+ * particular RA list.
+ */
+static int
+mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
+			struct mwifiex_ra_list_tbl *ptr, int max_buf_size)
+{
+	int count = 0, total_size = 0;
+	struct sk_buff *skb, *tmp;
+
+	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
+		total_size += skb->len;
+		if (total_size < max_buf_size)
+			++count;
+		else
+			break;
+	}
+
+	return count;
+}
+
+/*
+ * This function sends a single packet to firmware for transmission.
+ */
+static void
+mwifiex_send_single_packet(struct mwifiex_private *priv,
+			   struct mwifiex_ra_list_tbl *ptr, int ptr_index,
+			   unsigned long ra_list_flags)
+			   __releases(&priv->wmm.ra_list_spinlock)
+{
+	struct sk_buff *skb, *skb_next;
+	struct mwifiex_tx_param tx_param;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int status = 0;
+	struct mwifiex_txinfo *tx_info;
+
+	if (skb_queue_empty(&ptr->skb_head)) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		dev_dbg(adapter->dev, "data: nothing to send\n");
+		return;
+	}
+
+	skb = skb_dequeue(&ptr->skb_head);
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
+
+	ptr->total_pkts_size -= skb->len;
+
+	if (!skb_queue_empty(&ptr->skb_head))
+		skb_next = skb_peek(&ptr->skb_head);
+	else
+		skb_next = NULL;
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+	tx_param.next_pkt_len = ((skb_next) ? skb_next->len +
+				sizeof(struct txpd) : 0);
+
+	status = mwifiex_process_tx(priv, skb, &tx_param);
+
+	if (status == -EBUSY) {
+		/* Queue the packet back at the head */
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
+			mwifiex_write_data_complete(adapter, skb, -1);
+			return;
+		}
+
+		skb_queue_tail(&ptr->skb_head, skb);
+
+		ptr->total_pkts_size += skb->len;
+		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+	} else {
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			priv->wmm.packets_out[ptr_index]++;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
+		}
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node,
+				list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+	}
+}
+
+/*
+ * This function checks if the first packet in the given RA list
+ * is already processed or not.
+ */
+static int
+mwifiex_is_ptr_processed(struct mwifiex_private *priv,
+			 struct mwifiex_ra_list_tbl *ptr)
+{
+	struct sk_buff *skb;
+	struct mwifiex_txinfo *tx_info;
+
+	if (skb_queue_empty(&ptr->skb_head))
+		return false;
+
+	skb = skb_peek(&ptr->skb_head);
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_REQUEUED_PKT)
+		return true;
+
+	return false;
+}
+
+/*
+ * This function sends a single processed packet to firmware for
+ * transmission.
+ */
+static void
+mwifiex_send_processed_packet(struct mwifiex_private *priv,
+			      struct mwifiex_ra_list_tbl *ptr, int ptr_index,
+			      unsigned long ra_list_flags)
+				__releases(&priv->wmm.ra_list_spinlock)
+{
+	struct mwifiex_tx_param tx_param;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	int ret = -1;
+	struct sk_buff *skb, *skb_next;
+	struct mwifiex_txinfo *tx_info;
+
+	if (skb_queue_empty(&ptr->skb_head)) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		return;
+	}
+
+	skb = skb_dequeue(&ptr->skb_head);
+
+	if (!skb_queue_empty(&ptr->skb_head))
+		skb_next = skb_peek(&ptr->skb_head);
+	else
+		skb_next = NULL;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
+	tx_param.next_pkt_len =
+		((skb_next) ? skb_next->len +
+		 sizeof(struct txpd) : 0);
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					   skb->data, skb->len, &tx_param);
+	switch (ret) {
+	case -EBUSY:
+		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
+			mwifiex_write_data_complete(adapter, skb, -1);
+			return;
+		}
+
+		skb_queue_tail(&ptr->skb_head, skb);
+
+		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		break;
+	case -1:
+		adapter->data_sent = false;
+		dev_err(adapter->dev, "host_to_card failed: %#x\n", ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, skb, ret);
+		break;
+	case -EINPROGRESS:
+		adapter->data_sent = false;
+	default:
+		break;
+	}
+	if (ret != -EBUSY) {
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			priv->wmm.packets_out[ptr_index]++;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
+		}
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node,
+				list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+	}
+}
+
+/*
+ * This function dequeues a packet from the highest priority list
+ * and transmits it.
+ */
+static int
+mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_ra_list_tbl *ptr;
+	struct mwifiex_private *priv = NULL;
+	int ptr_index = 0;
+	u8 ra[ETH_ALEN];
+	int tid_del = 0, tid = 0;
+	unsigned long flags;
+
+	ptr = mwifiex_wmm_get_highest_priolist_ptr(adapter, &priv, &ptr_index);
+	if (!ptr)
+		return -1;
+
+	tid = mwifiex_get_tid(priv->adapter, ptr);
+
+	dev_dbg(adapter->dev, "data: tid=%d\n", tid);
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		return -1;
+	}
+
+	if (mwifiex_is_ptr_processed(priv, ptr)) {
+		mwifiex_send_processed_packet(priv, ptr, ptr_index, flags);
+		/* ra_list_spinlock has been freed in
+		   mwifiex_send_processed_packet() */
+		return 0;
+	}
+
+	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
+	    || ((priv->sec_info.wpa_enabled
+		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set)
+		) {
+		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
+		/* ra_list_spinlock has been freed in
+		   mwifiex_send_single_packet() */
+	} else {
+		if (mwifiex_is_ampdu_allowed(priv, ptr, tid)) {
+			if (mwifiex_is_ba_stream_avail(priv)) {
+				mwifiex_11n_create_tx_ba_stream_tbl(priv,
+						ptr->ra, tid,
+						BA_STREAM_SETUP_INPROGRESS);
+				mwifiex_send_addba(priv, tid, ptr->ra);
+			} else if (mwifiex_find_stream_to_delete
+				   (priv, ptr, tid, &tid_del, ra)) {
+				mwifiex_11n_create_tx_ba_stream_tbl(priv,
+						ptr->ra, tid,
+						BA_STREAM_SETUP_INPROGRESS);
+				mwifiex_send_delba(priv, tid_del, ra, 1);
+			}
+		}
+/* Minimum number of AMSDU */
+#define MIN_NUM_AMSDU 2
+		if (mwifiex_is_amsdu_allowed(priv, ptr, tid) &&
+		    (mwifiex_num_pkts_in_txq(priv, ptr, adapter->tx_buf_size) >=
+		     MIN_NUM_AMSDU))
+			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
+						  ptr_index, flags);
+			/* ra_list_spinlock has been freed in
+			   mwifiex_11n_aggregate_pkt() */
+		else
+			mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
+			/* ra_list_spinlock has been freed in
+			   mwifiex_send_single_packet() */
+	}
+	return 0;
+}
+
+/*
+ * This function transmits the highest priority packet awaiting in the
+ * WMM Queues.
+ */
+void
+mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter)
+{
+	do {
+		/* Check if busy */
+		if (adapter->data_sent || adapter->tx_lock_flag)
+			break;
+
+		if (mwifiex_dequeue_tx_packet(adapter))
+			break;
+	} while (true);
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
new file mode 100644
index 0000000..241f1b0
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -0,0 +1,112 @@
+/*
+ * Marvell Wireless LAN device driver: WMM
+ *
+ * Copyright (C) 2011, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_WMM_H_
+#define _MWIFIEX_WMM_H_
+
+enum ieee_types_wmm_aciaifsn_bitmasks {
+	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ACM = BIT(4),
+	MWIFIEX_ACI = (BIT(5) | BIT(6)),
+};
+
+enum ieee_types_wmm_ecw_bitmasks {
+	MWIFIEX_ECW_MIN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
+};
+
+/*
+ * This function retrieves the TID of the given RA list.
+ */
+static inline int
+mwifiex_get_tid(struct mwifiex_adapter *adapter,
+		struct mwifiex_ra_list_tbl *ptr)
+{
+	struct sk_buff *skb;
+
+	if (skb_queue_empty(&ptr->skb_head))
+		return 0;
+
+	skb = skb_peek(&ptr->skb_head);
+
+	return skb->priority;
+}
+
+/*
+ * This function gets the length of a list.
+ */
+static inline int
+mwifiex_wmm_list_len(struct mwifiex_adapter *adapter, struct list_head *head)
+{
+	struct list_head *pos;
+	int count = 0;
+
+	list_for_each(pos, head)
+		++count;
+
+	return count;
+}
+
+/*
+ * This function checks if a RA list is empty or not.
+ */
+static inline u8
+mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
+			     struct list_head *ra_list_hhead)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	int is_list_empty;
+
+	list_for_each_entry(ra_list, ra_list_hhead, list) {
+		is_list_empty = skb_queue_empty(&ra_list->skb_head);
+		if (!is_list_empty)
+			return false;
+	}
+
+	return true;
+}
+
+void mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
+				 struct sk_buff *skb);
+void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
+
+int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
+void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
+int mwifiex_is_ralist_valid(struct mwifiex_private *priv,
+			    struct mwifiex_ra_list_tbl *ra_list, int tid);
+
+u8 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
+					     const struct sk_buff *skb);
+void mwifiex_wmm_init(struct mwifiex_adapter *adapter);
+
+extern u32 mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
+						 u8 **assoc_buf,
+						 struct ieee_types_wmm_parameter
+						 *wmmie,
+						 struct ieee80211_ht_cap
+						 *htcap);
+
+void mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
+					struct ieee_types_wmm_parameter
+					*wmm_ie);
+void mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv);
+extern int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
+				      const struct host_cmd_ds_command *resp);
+
+#endif /* !_MWIFIEX_WMM_H_ */
-- 
1.7.0.2

