Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4062 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: [PATCH 1/7] brcmfmac: add support for bus specific data command
Date: Tue, 26 Jun 2012 21:26:34 +0200
Message-ID: <1340738800-14087-2-git-send-email-arend@broadcom.com> (sfid-20120626_212738_252708_37B84E15)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmfmac need to support data command setting for dongle's bus
core. A list must be placed at brcmf_bus structure before calling
brcmf_bus_start in order to be sent by brcmf_c_preinit_dcmds.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    8 ++++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   16 ++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 ++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 3669164..537f499 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -36,6 +36,13 @@ struct dngl_stats {
 	unsigned long multicast;	/* multicast packets received */
 };
 
+struct brcmf_bus_dcmd {
+	char *name;
+	char *param;
+	int param_len;
+	struct list_head list;
+};
+
 /* interface structure between common and bus layer */
 struct brcmf_bus {
 	u8 type;		/* bus type */
@@ -50,6 +57,7 @@ struct brcmf_bus {
 	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
 	struct dngl_stats dstats;	/* Stats for dongle-based data */
 	u8 align;		/* bus alignment requirement */
+	struct list_head dcmd_list;
 
 	/* interface functions pointers */
 	/* Stop bus module: clear pending frames, disable data flow */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 236cb9f..1c9eb18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -807,6 +807,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	int scan_assoc_time = 40;
 	int scan_unassoc_time = 40;
 	int i;
+	struct brcmf_bus_dcmd *cmdlst;
+	struct list_head *cur, *q;
 
 	mutex_lock(&drvr->proto_block);
 
@@ -874,6 +876,20 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 						 0, true);
 	}
 
+	/* set bus specific command if there is any */
+	list_for_each_safe(cur, q, &drvr->bus_if->dcmd_list) {
+		cmdlst = list_entry(cur, struct brcmf_bus_dcmd, list);
+		if (cmdlst->name && cmdlst->param && cmdlst->param_len) {
+			brcmf_c_mkiovar(cmdlst->name, cmdlst->param,
+					cmdlst->param_len, iovbuf,
+					sizeof(iovbuf));
+			brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
+						 iovbuf, sizeof(iovbuf));
+		}
+		list_del(cur);
+		kfree(cmdlst);
+	}
+
 	mutex_unlock(&drvr->proto_block);
 
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 01cf6c0..57bf1d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1020,6 +1020,8 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	INIT_WORK(&drvr->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&drvr->multicast_work, _brcmf_set_multicast_list);
 
+	INIT_LIST_HEAD(&drvr->bus_if->dcmd_list);
+
 	return ret;
 
 fail:
-- 
1.7.9.5


