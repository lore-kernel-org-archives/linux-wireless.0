Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D5EC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3195C218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NqLrNcvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405278AbfBNMoQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:16 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48272 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394111AbfBNMoO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:14 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 26A7694A23;
        Thu, 14 Feb 2019 04:44:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 26A7694A23
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148252;
        bh=J0GDRvuNLSwLnoH+9p3rnZz/JiHp3eCoWqn/NyWtRmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqLrNcvde83vyDubj5MyCJeMheoQAbDPVYS++o2tdDpKo97oGx8kHc99dJ2xD053k
         RaJAgwwF8ERYmGIuUT5y6Hd7Zo85odZcGKGCzmi1gQfBhQeku0EfvUIA9jJv0s7/8F
         +To0IRR+p7gt8J63qvfCT2fAzVsFiEyBqrlioIvY=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 75F1B81EC5;
        Thu, 14 Feb 2019 04:44:12 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 36966B02A3E; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: create debugfs files for bus-specific layer
Date:   Thu, 14 Feb 2019 13:43:49 +0100
Message-Id: <1550148232-4309-4-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we moved the drivers debugfs directory under ieee80211 debugfs the
debugfs entries need to be added after wiphy_register() has been called.
For most part that has been done accordingly, but for the debugfs entries
added by SDIO it was not and failed silently. This patch fixes that by
adding a bus-layer callback for it.

Fixes: 856d5a011c86 ("brcmfmac: allocate struct brcmf_pub instance using wiphy_new()")
Reported-by: Russel King <linux@armlinux.org.uk>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h  | 10 ++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 +++++++-----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index c496518..3d441c5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -90,6 +90,7 @@ struct brcmf_bus_ops {
 	int (*get_memdump)(struct device *dev, void *data, size_t len);
 	int (*get_fwname)(struct device *dev, const char *ext,
 			  unsigned char *fw_name);
+	void (*debugfs_create)(struct device *dev);
 };
 
 
@@ -235,6 +236,15 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
 	return bus->ops->get_fwname(bus->dev, ext, fw_name);
 }
 
+static inline
+void brcmf_bus_debugfs_create(struct brcmf_bus *bus)
+{
+	if (!bus->ops->debugfs_create)
+		return;
+
+	return bus->ops->debugfs_create(bus->dev);
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index a368ba6..9d911dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1156,6 +1156,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
 	brcmf_proto_debugfs_create(drvr);
+	brcmf_bus_debugfs_create(bus_if);
 
 	return 0;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 0cd5b8d..5f9de61 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3143,9 +3143,12 @@ static int brcmf_debugfs_sdio_count_read(struct seq_file *seq, void *data)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
-	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
 	struct dentry *dentry = brcmf_debugfs_get_devdir(drvr);
 
 	if (IS_ERR_OR_NULL(dentry))
@@ -3165,7 +3168,7 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
 }
 #endif /* DEBUG */
@@ -3477,8 +3480,6 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (bus->rxbuf)
 		bus->rxblen = value;
 
-	brcmf_sdio_debugfs_create(bus);
-
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
@@ -4088,6 +4089,7 @@ int brcmf_sdio_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
 	.get_ramsize = brcmf_sdio_bus_get_ramsize,
 	.get_memdump = brcmf_sdio_bus_get_memdump,
 	.get_fwname = brcmf_sdio_get_fwname,
+	.debugfs_create = brcmf_sdio_debugfs_create
 };
 
 #define BRCMF_SDIO_FW_CODE	0
-- 
1.9.1

