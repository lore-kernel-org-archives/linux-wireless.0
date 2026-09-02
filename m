Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE77F4AA004
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367981; cv=none; b=m8rjivB7rZdFCLXBoW6pb1PyueFgaR53xFm5zHeJoYr9hUSZvRgikIDQ1X37Lguu+MKjOtzwmZWGZ6bIWsxt5JnQRpgbakCiSncy4mQk4E0uHseoevYOg+0Wn4L7fRHAV1Vzdbbk2VsZw07XnZfmS1RXjsIaKOYyepno8hXOJ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367981; c=relaxed/simple;
	bh=LmxcHJHRinfHQoDO7E2NUseFxzAFq61r7lcglSNgxtY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvIB1q13/jNDa/ee6uKTjdKeZZcsJtzzJ0gwxECMTDcOsV50SDEcwKrivX3mCNvcwQYbqU4gRDjXzjmUAkQredKMuuC6yONg0h5j5bUXwb4PkqsG7ZLh7JbAEOLOfyJB8PvFsJrA4PSlZBhP0CvsPYN2/rk8lJZdbqX4W5FJgx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=ImMxI7Rd; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="ImMxI7Rd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367979; x=1819903979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LmxcHJHRinfHQoDO7E2NUseFxzAFq61r7lcglSNgxtY=;
  b=ImMxI7Rdcrn5FGA57IVKlKNAxCFhA32to7ztLBUaEr/6dfXSPRprqN/4
   YNCkUHXdL8SIdG2N10CHp/YHhSyLwllejX8zpFjOrFEYOcrz8lc486vvF
   aHFBucun18I0lmZAZsbbaHp/Fjpc5Ev9dDdlSS/EvDBDl/kQQuIM2/02j
   c=;
X-CSE-ConnectionGUID: i+I4E2EgSEWxD9xhrT3eNA==
X-CSE-MsgGUID: 8XnkZivkTxqvaXzScjLqYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="159196493"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="159196493"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:52:57 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:52:55 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:52:53 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 08/25] wifi: inffmac: add main.c/h
Date: Wed, 2 Sep 2026 16:50:39 +0000
Message-ID: <20260902165057.456447-9-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE817.infineon.com (172.23.29.43) To
 MUCSE827.infineon.com (172.23.29.20)

Driver main file to initialize and De-initialize the Kernel module in the
kernel. Also maintains some of the core driver structures, functions and
common module param registrations.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 drivers/net/wireless/infineon/inffmac/main.c | 821 +++++++++++++++++++
 drivers/net/wireless/infineon/inffmac/main.h | 314 +++++++
 2 files changed, 1135 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/main.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/main.h

diff --git a/drivers/net/wireless/infineon/inffmac/main.c b/drivers/net/wireless/infineon/inffmac/main.c
new file mode 100644
index 000000000000..9b9d0c4f1409
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/main.c
@@ -0,0 +1,821 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/etherdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/reboot.h>
+
+#include "main.h"
+#include "net.h"
+#include "cfg80211.h"
+#include "utils.h"
+#include "chan.h"
+#include "debug.h"
+#include "bus_proto.h"
+#include "sdio.h"
+#include "chip.h"
+#include "firmware.h"
+#include "dev_cmd.h"
+#include "dev_evt.h"
+#include "feature.h"
+#include "interface.h"
+
+#define INFF_DEFAULT_SCAN_CHANNEL_TIME	40
+#define INFF_DEFAULT_SCAN_UNASSOC_TIME	40
+
+/* default boost value for RSSI_DELTA in preferred join selection */
+#define INFF_JOIN_PREF_RSSI_BOOST	8
+
+/* Debug level configuration. See debug.h for bits, sysfs modifiable */
+int inff_msg_level;
+module_param_named(debug, inff_msg_level, int, 0600);
+MODULE_PARM_DESC(debug, "Level of debug output");
+
+static char inff_firmware_path[INFF_FW_ALTPATH_LEN];
+module_param_string(alternative_fw_path, inff_firmware_path,
+		    INFF_FW_ALTPATH_LEN, 0400);
+MODULE_PARM_DESC(alternative_fw_path, "Alternative firmware path");
+
+static int inff_fcmode = 2;
+module_param_named(fcmode, inff_fcmode, int, 0);
+MODULE_PARM_DESC(fcmode, "Mode of firmware signalled flow control");
+
+static int inff_afq_enable = 1;
+module_param_named(afq_enable, inff_afq_enable, int, 0);
+MODULE_PARM_DESC(afq_enable, "Enable AFQ txstatus mechanism");
+
+static int inff_reboot_callback(struct notifier_block *this, unsigned long code, void *unused);
+static struct notifier_block inff_reboot_notifier = {
+	.notifier_call = inff_reboot_callback,
+	.priority = 1,
+};
+
+#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
+
+bool inff_socitype_is_ai(struct inff_bus *bus)
+{
+	if (bus->chip_pub)
+		return (bus->chip_pub->socitype == INFF_SOCI_AI);
+
+	return false;
+}
+
+bool inff_socitype_is_cp(struct inff_bus *bus)
+{
+	if (bus->chip_pub)
+		return (bus->chip_pub->socitype == INFF_SOCI_CP);
+
+	return false;
+}
+
+char *inff_ifname(struct inff_if *ifp)
+{
+	if (!ifp)
+		return "<if_null>";
+
+	if (ifp->ndev)
+		return ifp->ndev->name;
+
+	return "<if_none>";
+}
+
+void __inff_err(struct device *dev, const char *func, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	if (dev)
+		dev_err(dev, "%s: %pV", func, &vaf);
+	else
+		pr_err("%s: %pV", func, &vaf);
+	va_end(args);
+}
+
+struct inff_if *inff_get_ifp(struct inff_pub *drvr, int ifidx)
+{
+	struct inff_if *ifp;
+	s32 bsscfgidx;
+
+	if (ifidx < 0 || ifidx >= INFF_MAX_IFS) {
+		iphy_err(drvr, "ifidx %d out of range\n", ifidx);
+		return NULL;
+	}
+
+	ifp = NULL;
+	bsscfgidx = drvr->if2bss[ifidx];
+	if (bsscfgidx >= 0)
+		ifp = drvr->iflist[bsscfgidx];
+
+	return ifp;
+}
+
+int inff_rx_hdrpull(struct inff_pub *drvr, struct sk_buff *skb,
+		    struct inff_if **ifp)
+{
+	int ret;
+
+	/* process and remove protocol-specific header */
+	ret = inff_proto_hdrpull(drvr, true, skb, ifp);
+
+	if (ret || !(*ifp) || !(*ifp)->ndev) {
+		if (ret != -ENODATA && *ifp && (*ifp)->ndev)
+			(*ifp)->ndev->stats.rx_errors++;
+		inff_pkt_buf_free_skb(skb);
+		return -ENODATA;
+	}
+
+	skb->protocol = eth_type_trans(skb, (*ifp)->ndev);
+	inff_dbg(DATA, "protocol: 0x%04X\n", skb->protocol);
+
+	return 0;
+}
+
+void inff_txfinalize(struct inff_if *ifp, struct sk_buff *txp, bool success)
+{
+	if (!txp) {
+		if (!success && ifp && ifp->ndev)
+			ifp->ndev->stats.tx_errors++;
+		return;
+	}
+
+	if (!ifp) {
+		inff_pkt_buf_free_skb(txp);
+		return;
+	}
+
+	if (txp->data) {
+		struct ethhdr *eh = (struct ethhdr *)(txp->data);
+		u16 type = ntohs(eh->h_proto);
+
+		if (type == ETH_P_PAE) {
+			atomic_dec(&ifp->pend_8021x_cnt);
+			/* Adding comment to avoid WARNING */
+			if (waitqueue_active(&ifp->pend_8021x_wait))
+				wake_up(&ifp->pend_8021x_wait);
+		}
+	}
+
+	if (!success && ifp->ndev)
+		ifp->ndev->stats.tx_errors++;
+
+	inff_pkt_buf_free_skb(txp);
+}
+
+void inff_fw_crashed(struct device *dev)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(dev);
+	struct inff_pub *drvr = bus_if->drvr;
+
+	iphy_err(drvr, "Firmware has halted or crashed\n");
+
+	if (drvr->bus_reset.func)
+		schedule_work(&drvr->bus_reset);
+}
+
+static int inff_get_pend_8021x_cnt(struct inff_if *ifp)
+{
+	return atomic_read(&ifp->pend_8021x_cnt);
+}
+
+int inff_netdev_wait_pend8021x(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	int err;
+
+	err = wait_event_timeout(ifp->pend_8021x_wait,
+				 !inff_get_pend_8021x_cnt(ifp),
+				 MAX_WAIT_FOR_8021X_TX);
+
+	if (!err) {
+		iphy_err(drvr, "Timed out waiting for no pending 802.1x packets\n");
+		atomic_set(&ifp->pend_8021x_cnt, 0);
+	}
+
+	return !err;
+}
+
+static int
+inff_psm_watchdog_notify(struct inff_if *ifp,
+			 const struct inff_event_msg *evtmsg,
+			 void *data)
+{
+	struct inff_pub *drvr = ifp->drvr;
+
+	iphy_err(drvr, "PSM's watchdog has fired bsscfgidx=%d !\n",
+		 ifp->bsscfgidx);
+
+	return 0;
+}
+
+void
+inff_set_joinpref_default(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_join_pref_params join_pref_params[2];
+	int err;
+
+	/* Setup join_pref to select target by RSSI (boost on 5GHz) */
+	join_pref_params[0].type = INFF_JOIN_PREF_RSSI_DELTA;
+	join_pref_params[0].len = 2;
+	join_pref_params[0].rssi_gain = INFF_JOIN_PREF_RSSI_BOOST;
+	join_pref_params[0].band = WLC_BAND_5G;
+
+	join_pref_params[1].type = INFF_JOIN_PREF_RSSI;
+	join_pref_params[1].len = 2;
+	join_pref_params[1].rssi_gain = 0;
+	join_pref_params[1].band = 0;
+	err = inff_fwcmd_iovar_data_set(ifp, "join_pref", join_pref_params,
+					sizeof(join_pref_params));
+	if (err)
+		iphy_err(drvr, "Set join_pref error (%d)\n", err);
+}
+
+static int
+inff_download_clm_blob(struct inff_if *ifp, u16 flag,
+		       struct inff_dload_data_le *dload_buf,
+		       u32 len)
+{
+	s32 err;
+
+	flag |= (DLOAD_HANDLER_VER << DLOAD_FLAG_VER_SHIFT);
+	dload_buf->flag = cpu_to_le16(flag);
+	dload_buf->dload_type = cpu_to_le16(DL_TYPE_CLM);
+	dload_buf->len = cpu_to_le32(len);
+	dload_buf->crc = cpu_to_le32(0);
+
+	err = inff_fwcmd_iovar_data_set(ifp, "clmload", dload_buf,
+					struct_size(dload_buf, data, len));
+
+	return err;
+}
+
+static int
+inff_process_clm_blob(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	struct inff_bus *bus = drvr->bus_if;
+	struct inff_dload_data_le *chunk_buf;
+	const struct firmware *clm = NULL;
+	u32 chunk_len;
+	u32 datalen;
+	u32 cumulative_len;
+	u16 dl_flag = DL_BEGIN;
+	u32 status = 0;
+	s32 err;
+
+	err = inff_bus_get_blob(bus, &clm, INFF_BLOB_CLM);
+	if (err || !clm) {
+		inff_info("no clm_blob available (err=%d), device may have limited channels available\n",
+			  err);
+		return 0;
+	}
+
+	chunk_buf = kzalloc_flex(*chunk_buf, data, MAX_CHUNK_LEN);
+	if (!chunk_buf) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	datalen = clm->size;
+	cumulative_len = 0;
+	do {
+		if (datalen > MAX_CHUNK_LEN) {
+			chunk_len = MAX_CHUNK_LEN;
+		} else {
+			chunk_len = datalen;
+			dl_flag |= DL_END;
+		}
+		memcpy(chunk_buf->data, clm->data + cumulative_len, chunk_len);
+
+		err = inff_download_clm_blob(ifp, dl_flag, chunk_buf, chunk_len);
+
+		dl_flag &= ~DL_BEGIN;
+
+		cumulative_len += chunk_len;
+		datalen -= chunk_len;
+	} while ((datalen > 0) && (err == 0));
+
+	if (err) {
+		iphy_err(drvr, "clmload (%zu byte file) failed (%d)\n",
+			 clm->size, err);
+		/* Retrieve clmload_status and print */
+		err = inff_fwcmd_iovar_int_get(ifp, "clmload_status", &status);
+		if (err)
+			iphy_err(drvr, "get clmload_status failed (%d)\n", err);
+		else
+			inff_dbg(INFO, "clmload_status=%d\n", status);
+		err = -EIO;
+	}
+
+	kfree(chunk_buf);
+done:
+	release_firmware(clm);
+	return err;
+}
+
+int
+inff_set_cur_etheraddr(struct inff_if *ifp, const u8 *addr)
+{
+	s32 err;
+
+	err = inff_fwcmd_iovar_data_set(ifp, "cur_etheraddr", addr, ETH_ALEN);
+	if (err < 0)
+		iphy_err(ifp->drvr, "Setting cur_etheraddr failed, %d\n", err);
+
+	return err;
+}
+
+/* On some boards there is no eeprom to hold the nvram, in this case instead
+ * a board specific nvram is loaded from /lib/firmware. On most boards the
+ * macaddr setting in the /lib/firmware nvram file is ignored because the
+ * wifibt chip has a unique MAC programmed into the chip itself.
+ * But in some cases the actual MAC from the /lib/firmware nvram file gets
+ * used, leading to MAC conflicts.
+ * The MAC addresses in the troublesome nvram files seem to all come from
+ * the same nvram file template, so we only need to check for 1 known
+ * address to detect this.
+ */
+static const u8 inff_default_mac_address[ETH_ALEN] = {
+	0x00, 0x90, 0x4c, 0xc5, 0x12, 0x38
+};
+
+static int
+inff_set_preinit_dcmds(struct inff_if *ifp)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s8 eventmask[INFF_EVENTING_MASK_LEN];
+	u8 buf[INFF_DCMD_SMLEN];
+	struct inff_bus *bus;
+	struct inff_rev_info_le revinfo;
+	struct inff_rev_info *ri;
+	struct inff_wlc_version_le wlc_ver;
+	char *clmver;
+	char *ptr;
+	s32 err;
+
+	if (is_valid_ether_addr(ifp->mac_addr)) {
+		/* set mac address */
+		err = inff_set_cur_etheraddr(ifp, ifp->mac_addr);
+		if (err < 0)
+			goto done;
+	} else {
+		/* retrieve mac address */
+		err = inff_fwcmd_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
+						sizeof(ifp->mac_addr));
+		if (err < 0) {
+			iphy_err(drvr, "Retrieving cur_etheraddr failed, %d\n", err);
+			goto done;
+		}
+
+		if (ether_addr_equal_unaligned(ifp->mac_addr, inff_default_mac_address)) {
+			iphy_err(drvr, "Default MAC is used, replacing with random MAC to avoid conflicts\n");
+			eth_random_addr(ifp->mac_addr);
+			ifp->ndev->addr_assign_type = NET_ADDR_RANDOM;
+			err = inff_set_cur_etheraddr(ifp, ifp->mac_addr);
+			if (err < 0)
+				goto done;
+		}
+	}
+
+	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
+	memcpy(ifp->drvr->wiphy->perm_addr, ifp->drvr->mac, ETH_ALEN);
+
+	bus = ifp->drvr->bus_if;
+	ri = &ifp->drvr->revinfo;
+
+	err = inff_fwcmd_data_get(ifp, INFF_C_GET_REVINFO,
+				  &revinfo, sizeof(revinfo));
+	if (err < 0) {
+		iphy_err(drvr, "retrieving revision info failed, %d\n", err);
+		strscpy(ri->chipname, "UNKNOWN", sizeof(ri->chipname));
+	} else {
+		ri->vendorid = le32_to_cpu(revinfo.vendorid);
+		ri->deviceid = le32_to_cpu(revinfo.deviceid);
+		ri->radiorev = le32_to_cpu(revinfo.radiorev);
+		ri->corerev = le32_to_cpu(revinfo.corerev);
+		ri->boardid = le32_to_cpu(revinfo.boardid);
+		ri->boardvendor = le32_to_cpu(revinfo.boardvendor);
+		ri->boardrev = le32_to_cpu(revinfo.boardrev);
+		ri->driverrev = le32_to_cpu(revinfo.driverrev);
+		ri->ucoderev = le32_to_cpu(revinfo.ucoderev);
+		ri->bus = le32_to_cpu(revinfo.bus);
+		ri->phytype = le32_to_cpu(revinfo.phytype);
+		ri->phyrev = le32_to_cpu(revinfo.phyrev);
+		ri->anarev = le32_to_cpu(revinfo.anarev);
+		ri->chippkg = le32_to_cpu(revinfo.chippkg);
+		ri->nvramrev = le32_to_cpu(revinfo.nvramrev);
+
+		/* use revinfo if not known yet */
+		if (!bus->chip) {
+			bus->chip = le32_to_cpu(revinfo.chipnum);
+			bus->chiprev = le32_to_cpu(revinfo.chiprev);
+		}
+	}
+	ri->result = err;
+
+	if (bus->chip)
+		inff_chip_name(bus->chip, bus->chiprev,
+			       ri->chipname, sizeof(ri->chipname));
+
+	if (inff_socitype_is_ai(drvr->bus_if)) {
+		/* Download CLM BLOB */
+		err = inff_process_clm_blob(ifp);
+		if (err < 0) {
+			iphy_err(drvr, "download CLM blob file failed, %d\n", err);
+			goto done;
+		}
+	}
+
+	/* query for 'ver' to get version info from firmware */
+	memset(buf, 0, sizeof(buf));
+	err = inff_fwcmd_iovar_data_get(ifp, "ver", buf, sizeof(buf));
+	if (err < 0) {
+		iphy_err(drvr, "Retrieving version information failed, %d\n",
+			 err);
+		goto done;
+	}
+	buf[sizeof(buf) - 1] = '\0';
+	ptr = (char *)buf;
+	strsep(&ptr, "\n");
+
+	/* Print fw version info */
+	inff_info("Firmware: %s %s\n", ri->chipname, buf);
+
+	/* locate firmware version number for ethtool */
+	ptr = strrchr(buf, ' ');
+	if (!ptr) {
+		iphy_err(drvr, "Retrieving version number failed");
+		goto done;
+	}
+	strscpy(ifp->drvr->fwver, ptr + 1, sizeof(ifp->drvr->fwver));
+
+	/* Get wlc interface version, set to 0 for legacy chip
+	 * that is not supporting wlc_ver iovar
+	 */
+	err = inff_fwcmd_iovar_data_get(ifp, "wlc_ver", &wlc_ver, sizeof(wlc_ver));
+	if (err < 0) {
+		ifp->drvr->wlc_ver.wlc_ver_major = 0;
+		ifp->drvr->wlc_ver.wlc_ver_minor = 0;
+	} else {
+		ifp->drvr->wlc_ver.wlc_ver_major = le16_to_cpu(wlc_ver.wlc_ver_major);
+		ifp->drvr->wlc_ver.wlc_ver_minor = le16_to_cpu(wlc_ver.wlc_ver_minor);
+	}
+	inff_dbg(TRACE, "wlc interface version, major=%d, minor=%d\n",
+		 ifp->drvr->wlc_ver.wlc_ver_major,
+		 ifp->drvr->wlc_ver.wlc_ver_minor);
+
+	/* Query for 'clmver' to get CLM version info from firmware */
+	if (inff_socitype_is_ai(drvr->bus_if)) {
+		memset(buf, 0, sizeof(buf));
+		err = inff_fwcmd_iovar_data_get(ifp, "clmver", buf, sizeof(buf));
+		if (err) {
+			inff_dbg(TRACE, "retrieving clmver failed, %d\n", err);
+		} else {
+			buf[sizeof(buf) - 1] = '\0';
+			clmver = (char *)buf;
+
+			/* Replace all newline/linefeed characters with space
+			 * character
+			 */
+			strreplace(clmver, '\n', ' ');
+
+			/* store CLM version for adding it to revinfo debugfs file */
+			memcpy(ifp->drvr->clmver, clmver, sizeof(ifp->drvr->clmver));
+
+			inff_dbg(INFO, "CLM version = %s\n", clmver);
+		}
+	}
+
+	/* set apsta */
+	err = inff_fwcmd_iovar_int_set(ifp, "apsta", 1);
+	if (err)
+		inff_info("failed setting apsta, %d\n", err);
+
+	/* set mpc */
+	err = inff_fwcmd_iovar_int_set(ifp, "mpc", 1);
+	if (err) {
+		iphy_err(drvr, "failed setting mpc\n");
+		goto done;
+	}
+
+	inff_set_joinpref_default(ifp);
+
+	/* Setup event_msgs, enable E_IF */
+	err = inff_fwcmd_iovar_data_get(ifp, "event_msgs", eventmask,
+					INFF_EVENTING_MASK_LEN);
+	if (err) {
+		iphy_err(drvr, "Get event_msgs error (%d)\n", err);
+		goto done;
+	}
+	setbit(eventmask, INFF_E_IF);
+	err = inff_fwcmd_iovar_data_set(ifp, "event_msgs", eventmask,
+					INFF_EVENTING_MASK_LEN);
+	if (err) {
+		iphy_err(drvr, "Set event_msgs error (%d)\n", err);
+		goto done;
+	}
+
+	if (inff_socitype_is_ai(drvr->bus_if)) {
+		/* Setup default scan channel time */
+		err = inff_fwcmd_int_set(ifp, INFF_C_SET_SCAN_CHANNEL_TIME,
+					 INFF_DEFAULT_SCAN_CHANNEL_TIME);
+		if (err) {
+			iphy_err(drvr, "INFF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+				 err);
+			goto done;
+		}
+
+		/* Setup default scan unassoc time */
+		err = inff_fwcmd_int_set(ifp, INFF_C_SET_SCAN_UNASSOC_TIME,
+					 INFF_DEFAULT_SCAN_UNASSOC_TIME);
+		if (err) {
+			iphy_err(drvr, "INFF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+				 err);
+			goto done;
+		}
+	}
+	/* Enable tx beamforming, errors can be ignored (not supported) */
+	(void)inff_fwcmd_iovar_int_set(ifp, "txbf", 1);
+	err = inff_fwcmd_iovar_int_set(ifp, "chanspec", 0x1001);
+	if (err < 0) {
+		iphy_err(drvr, "Initial Channel failed %d\n", err);
+		goto done;
+	}
+
+done:
+	return err;
+}
+
+static int
+inff_revinfo_read(struct seq_file *s, void *data)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(s->private);
+	struct inff_rev_info *ri = &bus_if->drvr->revinfo;
+	char drev[INFF_DOTREV_LEN];
+	char brev[INFF_BOARDREV_LEN];
+
+	seq_printf(s, "vendorid: 0x%04x\n", ri->vendorid);
+	seq_printf(s, "deviceid: 0x%04x\n", ri->deviceid);
+	seq_printf(s, "radiorev: %s\n", inff_dotrev_str(ri->radiorev, drev));
+	seq_printf(s, "chip: %s\n", ri->chipname);
+	seq_printf(s, "chippkg: %u\n", ri->chippkg);
+	seq_printf(s, "corerev: %u\n", ri->corerev);
+	seq_printf(s, "boardid: 0x%04x\n", ri->boardid);
+	seq_printf(s, "boardvendor: 0x%04x\n", ri->boardvendor);
+	seq_printf(s, "boardrev: %s\n", inff_boardrev_str(ri->boardrev, brev));
+	seq_printf(s, "driverrev: %s\n", inff_dotrev_str(ri->driverrev, drev));
+	seq_printf(s, "ucoderev: %u\n", ri->ucoderev);
+	seq_printf(s, "bus: %u\n", ri->bus);
+	seq_printf(s, "phytype: %u\n", ri->phytype);
+	seq_printf(s, "phyrev: %u\n", ri->phyrev);
+	seq_printf(s, "anarev: %u\n", ri->anarev);
+	seq_printf(s, "nvramrev: %08x\n", ri->nvramrev);
+
+	seq_printf(s, "clmver: %s\n", bus_if->drvr->clmver);
+
+	return 0;
+}
+
+int
+inff_bus_attach(struct device *dev)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(dev);
+	struct inff_pub *drvr = bus_if->drvr;
+	struct inff_if *pri_ifp;
+	struct inff_if *ifp_ap = NULL;
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(drvr->if2bss); i++)
+		drvr->if2bss[i] = INFF_BSSIDX_INVALID;
+
+	mutex_init(&drvr->proto_block);
+
+	/* Link to bus module */
+	drvr->hdrlen = 0;
+
+	drvr->req_mpc = 1;
+	/* Attach and link in the protocol */
+	ret = inff_bus_proto_attach(drvr);
+	if (ret < 0) {
+		iphy_err(drvr, "inff_prot_attach failed\n");
+		goto fail;
+	}
+
+	if (inff_socitype_is_ai(bus_if)) {
+		/* Attach to events important for core code */
+		inff_fwevt_register(drvr, INFF_E_PSM_WATCHDOG,
+				    inff_psm_watchdog_notify);
+		/* attach firmware event handler */
+		inff_fwevt_attach(drvr);
+	} else if (inff_socitype_is_cp(bus_if)) {
+		ret = inff_cpevt_attach(drvr);
+		if (ret != 0) {
+			iphy_err(drvr, "Event attach failed.!\n");
+			goto fail;
+		}
+	}
+
+	if (is_valid_ether_addr(user_mac_addr))
+		memcpy(drvr->settings->mac, user_mac_addr, ETH_ALEN);
+	/* add primary netdev in station mode */
+	pri_ifp = inff_net_add_if(drvr, INFF_INTERFACE_PRI_BSSCFGIDX,
+				  INFF_INTERFACE_PRI_IFIDX, "wlan%d",
+				  is_valid_ether_addr(drvr->settings->mac) ?
+				  drvr->settings->mac : NULL,
+				  NL80211_IFTYPE_STATION);
+	if (IS_ERR(pri_ifp)) {
+		ret = PTR_ERR(pri_ifp);
+		goto fail;
+	}
+
+	if (inff_socitype_is_cp(bus_if)) {
+		/* add netdev for SoftAP mode */
+		ifp_ap = inff_net_add_if(drvr, INFF_INTERFACE_SEC_BSSCFGIDX,
+					 INFF_INTERFACE_SEC_IFIDX, "wlan%d",
+					 NULL, NL80211_IFTYPE_AP);
+		if (IS_ERR(ifp_ap)) {
+			ret = PTR_ERR(ifp_ap);
+			goto fail;
+		}
+	}
+
+	if (inff_socitype_is_ai(bus_if)) {
+		/* signal bus ready */
+		inff_bus_change_state(bus_if, INFF_BUS_UP);
+
+		/* do bus specific preinit here */
+		ret = inff_bus_preinit(bus_if);
+		if (ret < 0)
+			goto fail;
+
+		ret = inff_bus_set_fcmode(bus_if);
+		/* Set fcmode = 0 for PCIe */
+		if (ret < 0)
+			drvr->settings->fcmode = 0;
+
+		ret = inff_proto_init_done(drvr);
+		if (ret < 0)
+			goto fail;
+
+		inff_proto_add_if(drvr, pri_ifp);
+	}
+
+	inff_feat_attach(drvr);
+
+	/* Bus is ready, do any initialization */
+	ret = inff_set_preinit_dcmds(pri_ifp);
+	if (ret < 0)
+		goto fail;
+
+	drvr->config = inff_cfg80211_attach(drvr, drvr->ops);
+	if (!drvr->config) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	ret = inff_net_attach(pri_ifp, false);
+	if (ret)
+		goto fail;
+
+	if (inff_socitype_is_cp(bus_if)) {
+		ret = inff_net_attach(ifp_ap, false);
+		if (ret)
+			goto fail;
+	}
+
+	/* populate debugfs */
+	inff_debugfs_add_entry(drvr, "revinfo", inff_revinfo_read);
+	inff_debugfs_add_entry(drvr, "parameter", inff_debugfs_param_read);
+	inff_feat_debugfs_create(drvr);
+	inff_bus_proto_debugfs_create(drvr);
+
+	goto exit;
+fail:
+	iphy_err(drvr, "dongle is not responding: err=%d\n",
+		 ret);
+	inff_bus_detach(dev);
+exit:
+	return ret;
+}
+
+void
+inff_bus_detach(struct device *dev)
+{
+	s32 i;
+	struct inff_bus *bus_if = dev_get_drvdata(dev);
+	struct inff_pub *drvr = bus_if->drvr;
+
+	if (!drvr)
+		return;
+
+	if (inff_socitype_is_ai(bus_if))
+		inff_fwevt_detach(drvr);
+	else if (inff_socitype_is_cp(bus_if))
+		inff_cpevt_detach(drvr);
+
+	inff_bus_stop(bus_if);
+
+	inff_bus_change_state(bus_if, INFF_BUS_DOWN);
+
+	/* make sure primary interface removed last */
+	for (i = INFF_MAX_IFS - 1; i > -1; i--) {
+		if (drvr->iflist[i])
+			inff_net_del_if(drvr, drvr->iflist[i], false);
+	}
+
+	inff_bus_proto_detach(drvr);
+
+	if (drvr->config) {
+		inff_cfg80211_detach(drvr->config);
+		drvr->config = NULL;
+	}
+}
+
+int inff_debugfs_param_read(struct seq_file *s, void *data)
+{
+	struct inff_bus *bus_if = dev_get_drvdata(s->private);
+
+	seq_printf(s, "%-20s: %s\n", "Name", "Value");
+	seq_printf(s, "%-20s: 0x%x\n", "debug", inff_msg_level);
+	seq_printf(s, "%-20s: %s\n", "alternative_fw_path", inff_firmware_path);
+	seq_printf(s, "%-20s: %d\n", "fcmode", bus_if->drvr->settings->fcmode);
+	seq_printf(s, "%-20s: %d\n", "afq_enable", !!inff_afq_enable);
+
+	return 0;
+}
+
+struct inff_mp_device *inff_get_module_param(struct device *dev)
+{
+	struct inff_mp_device *settings;
+
+	settings = kzalloc_obj(*settings, GFP_ATOMIC);
+	if (!settings)
+		return NULL;
+
+	/* start by using the module parameters */
+	inff_dbg(INFO, "debug: 0x%x\n", inff_msg_level);
+	strscpy(settings->firmware_path, inff_firmware_path,
+		INFF_FW_ALTPATH_LEN);
+	inff_dbg(INFO, "alternative_fw_path: %s\n", settings->firmware_path);
+
+	settings->fcmode = inff_fcmode;
+	inff_dbg(INFO, "fcmode: %d\n", settings->fcmode);
+	settings->afq_enable = !!inff_afq_enable;
+	inff_dbg(INFO, "afq_enable: %d\n", settings->afq_enable);
+
+	return settings;
+}
+
+void inff_release_module_param(struct inff_mp_device *module_param)
+{
+	kfree(module_param);
+}
+
+static int
+inff_reboot_callback(struct notifier_block *this, unsigned long code, void *unused)
+{
+	inff_dbg(INFO, "code = %ld\n", code);
+	if (code == SYS_RESTART)
+		inff_sdio_exit();
+
+	return NOTIFY_DONE;
+}
+
+static int __init inff_module_init(void)
+{
+	int err;
+
+	err = inff_sdio_register();
+	if (err)
+		return err;
+
+	register_reboot_notifier(&inff_reboot_notifier);
+
+	return 0;
+}
+
+static void __exit inff_module_exit(void)
+{
+	inff_sdio_exit();
+
+	unregister_reboot_notifier(&inff_reboot_notifier);
+}
+
+module_init(inff_module_init);
+module_exit(inff_module_exit);
+
+MODULE_AUTHOR("Infineon Technologies AG");
+MODULE_DESCRIPTION("Infineon 802.11 wireless LAN fullmac driver.");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/infineon/inffmac/main.h b/drivers/net/wireless/infineon/inffmac/main.h
new file mode 100644
index 000000000000..6f68838612ba
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/main.h
@@ -0,0 +1,314 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_MAIN_H
+#define INFF_MAIN_H
+
+#include <linux/types.h>
+#include <linux/firmware.h>
+#include <net/cfg80211.h>
+
+#include "dev_evt.h"
+#include "dev_cmd.h"
+#include "feature.h"
+
+/* The interval to poll console */
+#define INFF_CONSOLE_INTERVAL	500
+#define INFF_CPUSS_CONSOLE_INTERVAL	100
+
+/* The maximum console interval value (5 mins) */
+#define MAX_CONSOLE_INTERVAL	(5 * 60 * 1000)
+
+/*
+ * Priority definitions according 802.1D
+ */
+#define	PRIO_8021D_NONE		2
+#define	PRIO_8021D_BK		1
+#define	PRIO_8021D_BE		0
+#define	PRIO_8021D_EE		3
+#define	PRIO_8021D_CL		4
+#define	PRIO_8021D_VI		5
+#define	PRIO_8021D_VO		6
+#define	PRIO_8021D_NC		7
+
+#define MAXPRIO			7
+#define NUMPRIO			(MAXPRIO + 1)
+
+/* Bit masks for radio disabled status - returned by WL_GET_RADIO */
+
+#define WL_RADIO_SW_DISABLE       BIT(0)
+#define WL_RADIO_HW_DISABLE       BIT(1)
+/* some countries don't support any channel */
+#define WL_RADIO_COUNTRY_DISABLE  BIT(3)
+
+/* Override bit for SET_TXPWR.  if set, ignore other level limits */
+#define WL_TXPWR_OVERRIDE         BIT(31)
+
+/*
+ * Sonics Configuration Space Registers.
+ */
+
+/* core sbconfig regs are top 256bytes of regs */
+#define	SBCONFIGOFF		0xf00
+
+#define TOE_TX_CSUM_OL		0x00000001
+#define TOE_RX_CSUM_OL		0x00000002
+
+/* For supporting multiple interfaces */
+#define INFF_MAX_IFS	16
+
+/* Small, medium and maximum buffer size for dcmd
+ */
+#define INFF_DCMD_SMLEN	256
+#define INFF_DCMD_MEDLEN	1536
+#define INFF_DCMD_MAXLEN	8192
+
+/* IOCTL from host to device are limited in length. A device can only handle
+ * ethernet frame size. This limitation is to be applied by protocol layer.
+ */
+#define INFF_TX_IOCTL_MAX_MSG_SIZE	(ETH_FRAME_LEN + ETH_FCS_LEN)
+
+#define INFF_AMPDU_RX_REORDER_MAXFLOWS		256
+
+/* Length of firmware version string stored for
+ * ethtool driver info which uses 32 bytes as well.
+ */
+#define INFF_DRIVER_FIRMWARE_VERSION_LEN	32
+
+#define NDOL_MAX_ENTRIES	8
+
+#define INFF_FW_ALTPATH_LEN			256
+
+#define INFFMAC_DISABLE	0
+#define INFFMAC_ENABLE		1
+#define INFFMAC_AUTO		2
+
+#define INFF_DEFAULT_SDIO_IDLE_CONFIG         2
+/* Keeping these macro definition here because these are defined in mmc drivers.
+ * So for 3rd party mmc, fmac build should not fail due to build error.
+ */
+
+/* SDIO IDLECLOCK Support - reusing pm_caps */
+#ifndef SDIO_IDLECLOCK_DIS
+#define SDIO_IDLECLOCK_DIS	BIT(2)	/* Start SDClock */
+#define SDIO_IDLECLOCK_EN	BIT(3)	/* Stop SDClock */
+#define SDIO_SDMODE_1BIT	BIT(4)	/* Set 1-bit Bus mode */
+#define SDIO_SDMODE_4BIT	BIT(5)	/* Set 4-bit Bus mode */
+#endif /* !SDIO_IDLECLOCK_DIS */
+
+extern u8 user_mac_addr[ETH_ALEN];
+
+struct inff_sdio_platform_data {
+	bool		oob_irq_supported;
+	unsigned int	oob_irq_nr;
+	unsigned long	oob_irq_flags;
+	bool		broken_sg_support;
+	unsigned short	sd_head_align;
+	unsigned short	sd_sgentry_align;
+};
+
+/**
+ * struct inff_mp_device - Device module parameters.
+ *
+ * @fcmode: FWS flow control.
+ * @afq_enable: Enable AFQ txstatus mechanism.
+ * @country_codes: If available, pointer to struct for translating country codes
+ * @bus: Bus specific platform data. Only SDIO at the mmoment.
+ */
+#define INFF_MAX_FEATURE_BYTES DIV_ROUND_UP(INFF_FEAT_LAST, 8)
+struct inff_mp_device {
+	char		firmware_path[INFF_FW_ALTPATH_LEN];
+	int		fcmode;
+	bool		afq_enable;
+	const char	*board_type;
+	unsigned char	mac[ETH_ALEN];
+	union {
+		struct inff_sdio_platform_data sdio;
+	} bus;
+};
+
+/**
+ * struct inff_ampdu_rx_reorder - AMPDU receive reorder info
+ *
+ * @flow_id: AMPDU flow identifier.
+ * @cur_idx: last AMPDU index from firmware.
+ * @exp_idx: expected next AMPDU index.
+ * @max_idx: maximum amount of packets per AMPDU.
+ * @pend_pkts: number of packets currently in @pktslots.
+ * @pktslots: array for ordering AMPDU packets.
+ */
+struct inff_ampdu_rx_reorder {
+	u8 flow_id;
+	u8 cur_idx;
+	u8 exp_idx;
+	u8 max_idx;
+	u8 pend_pkts;
+	struct sk_buff *pktslots[];
+};
+
+/* Forward decls for struct inff_pub (see below) */
+struct inff_proto;	/* device communication protocol info */
+struct inff_fws_info;	/* firmware signalling info */
+struct inff_mp_device;	/* module parameters, device specific */
+
+/*
+ * struct inff_rev_info
+ *
+ * The result field stores the error code of the
+ * revision info request from firmware. For the
+ * other fields see struct inff_rev_info_le in
+ * fwil_types.h
+ */
+struct inff_rev_info {
+	int result;
+	u32 vendorid;
+	u32 deviceid;
+	u32 radiorev;
+	u32 corerev;
+	u32 boardid;
+	u32 boardvendor;
+	u32 boardrev;
+	u32 driverrev;
+	u32 ucoderev;
+	u32 bus;
+	char chipname[12];
+	u32 phytype;
+	u32 phyrev;
+	u32 anarev;
+	u32 chippkg;
+	u32 nvramrev;
+};
+
+/** wlc interface version */
+struct inff_wlc_version {
+	/* wlc interface version numbers */
+	u16	wlc_ver_major;		/**< wlc interface major version number */
+	u16	wlc_ver_minor;		/**< wlc interface minor version number */
+};
+
+/* Common structure for module and instance linkage */
+struct inff_pub {
+	/* Linkage ponters */
+	struct inff_bus *bus_if;
+	struct inff_proto *proto;
+	struct wiphy *wiphy;
+	struct cfg80211_ops *ops;
+	struct inff_cfg80211_info *config;
+
+	/* Internal inff items */
+	uint hdrlen;		/* Total INFF header length (proto + bus) */
+
+	/* Dongle media info */
+	char fwver[INFF_DRIVER_FIRMWARE_VERSION_LEN];
+	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
+
+	struct mac_address addresses[INFF_MAX_IFS];
+
+	struct inff_if *iflist[INFF_MAX_IFS];
+	s32 if2bss[INFF_MAX_IFS];
+
+	struct mutex proto_block;	/* used to protect proto resource */
+	unsigned char proto_buf[INFF_DCMD_MAXLEN];
+
+	struct inff_fwevt_info fwevt;
+
+	struct inff_ampdu_rx_reorder
+		*reorder_flows[INFF_AMPDU_RX_REORDER_MAXFLOWS];
+
+	u8 feat_flags[DIV_ROUND_UP(INFF_FEAT_LAST, 8)];
+	u32 chip_quirks;
+	int req_mpc;
+
+	struct inff_rev_info revinfo;
+	struct inff_wlc_version wlc_ver;
+#ifdef DEBUG
+	struct dentry *dbgfs_dir;
+#endif
+
+	struct inff_mp_device *settings;
+
+	struct work_struct bus_reset;
+
+	u8 clmver[INFF_DCMD_SMLEN];
+	u8 sta_mac_idx;
+
+	struct inff_dfu *dfu;
+	struct inff_cpevt_info evi;
+};
+
+/* forward declarations */
+struct inff_cfg80211_vif;
+struct inff_fws_mac_descriptor;
+
+#define INFF_BSSIDX_INVALID			-1
+
+/**
+ * struct inff_if - interface control information.
+ *
+ * @drvr: points to device related information.
+ * @vif: points to cfg80211 specific interface information.
+ * @ndev: associated network device.
+ * @multicast_work: wiphy work object for multicast provisioning.
+ * @fws_desc: interface specific firmware-signalling descriptor.
+ * @ifidx: interface index in device firmware.
+ * @bsscfgidx: index of bss associated with this interface.
+ * @mac_addr: assigned mac address.
+ * @netif_stop: bitmap indicates reason why netif queues are stopped.
+ * @netif_stop_lock: spinlock for update netif_stop from multiple sources.
+ * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
+ * @pend_8021x_wait: used for signalling change in count.
+ * @fwil_fwerr: flag indicating fwil layer should return firmware error codes.
+ * @fmac_pkt_fwd_en: Driver packet forward enabled for AP Mode.
+ * @napi: NAPI structure for handling the RX packets received on this interface.
+ * @napi_gro: NAPI GRO Receive enabled flag.
+ */
+struct inff_if {
+	struct inff_pub *drvr;
+	struct inff_cfg80211_vif *vif;
+	struct net_device *ndev;
+	struct wiphy_work multicast_work;
+	struct inff_fws_mac_descriptor *fws_desc;
+	int ifidx;
+	s32 bsscfgidx;
+	bool isap;
+	u8 mac_addr[ETH_ALEN];
+	u8 netif_stop;
+	spinlock_t netif_stop_lock;	/* used to protect netif_stop resource */
+	atomic_t pend_8021x_cnt;
+	wait_queue_head_t pend_8021x_wait;
+	bool fwil_fwerr;
+	bool fmac_pkt_fwd_en;
+	struct napi_struct napi;
+	bool napi_gro;
+	bool connected;
+};
+
+bool inff_socitype_is_ai(struct inff_bus *bus);
+bool inff_socitype_is_cp(struct inff_bus *bus);
+/* Return pointer to interface name */
+char *inff_ifname(struct inff_if *ifp);
+struct inff_if *inff_get_ifp(struct inff_pub *drvr, int ifidx);
+int inff_rx_hdrpull(struct inff_pub *drvr, struct sk_buff *skb,
+		    struct inff_if **ifp);
+void inff_txfinalize(struct inff_if *ifp, struct sk_buff *txp, bool success);
+/* Indication that firmware has halted or crashed */
+void inff_fw_crashed(struct device *dev);
+int inff_netdev_wait_pend8021x(struct inff_if *ifp);
+
+void inff_set_joinpref_default(struct inff_if *ifp);
+int inff_set_cur_etheraddr(struct inff_if *ifp, const u8 *addr);
+
+/* Indication from bus module regarding presence/insertion of dongle. */
+int inff_bus_attach(struct device *dev);
+/* Indication from bus module regarding removal/absence of dongle */
+void inff_bus_detach(struct device *dev);
+
+int inff_debugfs_param_read(struct seq_file *s, void *data);
+struct inff_mp_device *inff_get_module_param(struct device *dev);
+void inff_release_module_param(struct inff_mp_device *module_param);
+#endif /* INFF_MAIN_H */
-- 
2.43.0

