Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45198 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbaFUKLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: replace cfg80211 testmode with vendor command
Date: Sat, 21 Jun 2014 12:11:16 +0200
Message-ID: <1403345479-13467-6-git-send-email-arend@broadcom.com> (sfid-20140621_121135_735646_A26DE7B9)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Passing a pointer from user space and using it directly in driver is not a
preferable behavior. Switch to cfg80211 vendor mode for dongle command for
better cross platform compatibility.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   10 --
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c   |  115 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/vendor.h   |   64 +++++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   37 ++-----
 5 files changed, 188 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/vendor.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 98e67c1..4cffb2e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -34,7 +34,8 @@ brcmfmac-objs += \
 		dhd_common.o \
 		dhd_linux.o \
 		firmware.o \
-		btcoex.o
+		btcoex.o \
+		vendor.o
 brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		dhd_sdio.o \
 		bcmsdh.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 16f9ab2..a8998eb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -49,16 +49,6 @@
  */
 #define BRCMF_DRIVER_FIRMWARE_VERSION_LEN	32
 
-/* Bus independent dongle command */
-struct brcmf_dcmd {
-	uint cmd;		/* common dongle cmd definition */
-	void *buf;		/* pointer to user buffer */
-	uint len;		/* length of user buffer */
-	u8 set;			/* get or set request (optional) */
-	uint used;		/* bytes read or written (optional) */
-	uint needed;		/* bytes needed (optional) */
-};
-
 /**
  * struct brcmf_ampdu_rx_reorder - AMPDU receive reorder info
  *
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
new file mode 100644
index 0000000..5960d82
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/vmalloc.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+
+#include <brcmu_wifi.h>
+#include "fwil_types.h"
+#include "dhd.h"
+#include "p2p.h"
+#include "dhd_dbg.h"
+#include "wl_cfg80211.h"
+#include "vendor.h"
+#include "fwil.h"
+
+static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
+						 struct wireless_dev *wdev,
+						 const void *data, int len)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
+	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
+	struct sk_buff *reply;
+	int ret, payload, ret_len;
+	void *dcmd_buf = NULL, *wr_pointer;
+	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
+
+	brcmf_dbg(TRACE, "cmd %x set %d len %d\n", cmdhdr->cmd, cmdhdr->set,
+		  cmdhdr->len);
+
+	len -= sizeof(struct brcmf_vndr_dcmd_hdr);
+	ret_len = cmdhdr->len;
+	if (ret_len > 0 || len > 0) {
+		if (len > BRCMF_DCMD_MAXLEN) {
+			brcmf_err("oversize input buffer %d\n", len);
+			len = BRCMF_DCMD_MAXLEN;
+		}
+		if (ret_len > BRCMF_DCMD_MAXLEN) {
+			brcmf_err("oversize return buffer %d\n", ret_len);
+			ret_len = BRCMF_DCMD_MAXLEN;
+		}
+		payload = max(ret_len, len) + 1;
+		dcmd_buf = vzalloc(payload);
+		if (NULL == dcmd_buf)
+			return -ENOMEM;
+
+		memcpy(dcmd_buf, (void *)cmdhdr + cmdhdr->offset, len);
+		*(char *)(dcmd_buf + len)  = '\0';
+	}
+
+	if (cmdhdr->set)
+		ret = brcmf_fil_cmd_data_set(netdev_priv(ndev), cmdhdr->cmd,
+					     dcmd_buf, ret_len);
+	else
+		ret = brcmf_fil_cmd_data_get(netdev_priv(ndev), cmdhdr->cmd,
+					     dcmd_buf, ret_len);
+	if (ret != 0)
+		goto exit;
+
+	wr_pointer = dcmd_buf;
+	while (ret_len > 0) {
+		msglen = ret_len > maxmsglen ? maxmsglen : ret_len;
+		ret_len -= msglen;
+		payload = msglen + sizeof(msglen);
+		reply = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, payload);
+		if (NULL == reply) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		if (nla_put(reply, BRCMF_NLATTR_DATA, msglen, wr_pointer) ||
+		    nla_put_u16(reply, BRCMF_NLATTR_LEN, msglen)) {
+			kfree_skb(reply);
+			ret = -ENOBUFS;
+			break;
+		}
+
+		ret = cfg80211_vendor_cmd_reply(reply);
+		if (ret)
+			break;
+
+		wr_pointer += msglen;
+	}
+
+exit:
+	vfree(dcmd_buf);
+
+	return ret;
+}
+
+const struct wiphy_vendor_command brcmf_vendor_cmds[] = {
+	{
+		{
+			.vendor_id = BROADCOM_OUI,
+			.subcmd = BRCMF_VNDR_CMDS_DCMD
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_WDEV |
+			 WIPHY_VENDOR_CMD_NEED_NETDEV,
+		.doit = brcmf_cfg80211_vndr_cmds_dcmd_handler
+	},
+};
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.h b/drivers/net/wireless/brcm80211/brcmfmac/vendor.h
new file mode 100644
index 0000000..061b7bf
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _vendor_h_
+#define _vendor_h_
+
+#define BROADCOM_OUI	0x001018
+
+enum brcmf_vndr_cmds {
+	BRCMF_VNDR_CMDS_UNSPEC,
+	BRCMF_VNDR_CMDS_DCMD,
+	BRCMF_VNDR_CMDS_LAST
+};
+
+/**
+ * enum brcmf_nlattrs - nl80211 message attributes
+ *
+ * @BRCMF_NLATTR_LEN: message body length
+ * @BRCMF_NLATTR_DATA: message body
+ */
+enum brcmf_nlattrs {
+	BRCMF_NLATTR_UNSPEC,
+
+	BRCMF_NLATTR_LEN,
+	BRCMF_NLATTR_DATA,
+
+	__BRCMF_NLATTR_AFTER_LAST,
+	BRCMF_NLATTR_MAX = __BRCMF_NLATTR_AFTER_LAST - 1
+};
+
+/**
+ * struct brcmf_vndr_dcmd_hdr - message header for cfg80211 vendor command dcmd
+ *				support
+ *
+ * @cmd: common dongle cmd definition
+ * @len: length of expecting return buffer
+ * @offset: offset of data buffer
+ * @set: get or set request(optional)
+ * @magic: magic number for verification
+ */
+struct brcmf_vndr_dcmd_hdr {
+	uint cmd;
+	int len;
+	uint offset;
+	uint set;
+	uint magic;
+};
+
+extern const struct wiphy_vendor_command brcmf_vendor_cmds[];
+
+#endif /* _vendor_h_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6bbd708..f534bf2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 #include <net/cfg80211.h>
 #include <net/netlink.h>
 
@@ -33,6 +34,7 @@
 #include "btcoex.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
+#include "vendor.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
 #define BRCMF_PNO_VERSION		2
@@ -3257,35 +3259,6 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 	return 0;
 }
 
-#ifdef CONFIG_NL80211_TESTMODE
-static int brcmf_cfg80211_testmode(struct wiphy *wiphy,
-				   struct wireless_dev *wdev,
-				   void *data, int len)
-{
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_dcmd *dcmd = data;
-	struct sk_buff *reply;
-	int ret;
-
-	brcmf_dbg(TRACE, "cmd %x set %d buf %p len %d\n", dcmd->cmd, dcmd->set,
-		  dcmd->buf, dcmd->len);
-
-	if (dcmd->set)
-		ret = brcmf_fil_cmd_data_set(netdev_priv(ndev), dcmd->cmd,
-					     dcmd->buf, dcmd->len);
-	else
-		ret = brcmf_fil_cmd_data_get(netdev_priv(ndev), dcmd->cmd,
-					     dcmd->buf, dcmd->len);
-	if (ret == 0) {
-		reply = cfg80211_testmode_alloc_reply_skb(wiphy, sizeof(*dcmd));
-		nla_put(reply, NL80211_ATTR_TESTDATA, sizeof(*dcmd), dcmd);
-		ret = cfg80211_testmode_reply(reply);
-	}
-	return ret;
-}
-#endif
-
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
 	s32 err;
@@ -4303,7 +4276,6 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
 	.tdls_oper = brcmf_cfg80211_tdls_oper,
-	CFG80211_TESTMODE_CMD(brcmf_cfg80211_testmode)
 };
 
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
@@ -4408,6 +4380,11 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	brcmf_dbg(INFO, "Registering custom regulatory\n");
 	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
 	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
+
+	/* vendor commands/events support */
+	wiphy->vendor_commands = brcmf_vendor_cmds;
+	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
+
 	err = wiphy_register(wiphy);
 	if (err < 0) {
 		brcmf_err("Could not register wiphy device (%d)\n", err);
-- 
1.7.9.5

