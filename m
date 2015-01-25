Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:4257 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955AbbAYTbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 14:31:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/14] brcmfmac: store revinfo retrieval result
Date: Sun, 25 Jan 2015 20:31:42 +0100
Message-ID: <1422214303-7816-14-git-send-email-arend@broadcom.com> (sfid-20150125_203212_857538_CAC03FAD)
In-Reply-To: <1422214303-7816-1-git-send-email-arend@broadcom.com>
References: <1422214303-7816-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When revinfo retrieval fails we can not show the firmware version
in ethtool driver info. Store the result to be used when handling
ethtool driver info callback.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/common.c |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/core.c   |  7 ++++---
 drivers/net/wireless/brcm80211/brcmfmac/core.h   | 10 +++++++++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index 91213a6..fe54844 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -57,10 +57,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO,
 				     &revinfo, sizeof(revinfo));
+	ri = &ifp->drvr->revinfo;
 	if (err < 0) {
 		brcmf_err("retrieving revision info failed, %d\n", err);
 	} else {
-		ri = &ifp->drvr->revinfo;
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
 		ri->deviceid = le32_to_cpu(revinfo.deviceid);
 		ri->radiorev = le32_to_cpu(revinfo.radiorev);
@@ -79,6 +79,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		ri->chippkg = le32_to_cpu(revinfo.chippkg);
 		ri->nvramrev = le32_to_cpu(revinfo.nvramrev);
 	}
+	ri->result = err;
 
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 8d03588..2d6e2cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -601,11 +601,12 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
-	char drev[BRCMU_DOTREV_LEN];
+	char drev[BRCMU_DOTREV_LEN] = "n/a";
 
+	if (drvr->revinfo.result == 0)
+		brcmu_dotrev_str(drvr->revinfo.driverrev, drev);
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strlcpy(info->version, brcmu_dotrev_str(drvr->revinfo.driverrev, drev),
-		sizeof(info->version));
+	strlcpy(info->version, drev, sizeof(info->version));
 	strlcpy(info->fw_version, drvr->fwver, sizeof(info->fw_version));
 	strlcpy(info->bus_info, dev_name(drvr->bus_if->dev),
 		sizeof(info->bus_info));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index db7f35f..fd74a9c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -71,8 +71,16 @@ struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
 struct brcmf_fws_info; /* firmware signalling info */
 
-/* see struct brcmf_rev_info_le in fwil_types.h */
+/*
+ * struct brcmf_rev_info
+ *
+ * The result field stores the error code of the
+ * revision info request from firmware. For the
+ * other fields see struct brcmf_rev_info_le in
+ * fwil_types.h
+ */
 struct brcmf_rev_info {
+	int result;
 	u32 vendorid;
 	u32 deviceid;
 	u32 radiorev;
-- 
1.9.1

