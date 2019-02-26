Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83CDC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD520651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgiYDJpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfBZNMB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:12:01 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45292 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfBZNMB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:12:01 -0500
Received: by mail-lj1-f194.google.com with SMTP id d24so10430760ljc.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 05:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcVv+XhwhadZvdGYXvwV+SiX4KJ1bsdNrTTyWe5H02A=;
        b=AgiYDJpElwGAuvnhTl8vgT+y2bfa/3V4MJeBeghmwyBILlo1+gMkZ66+xWT/L1LtUx
         4Np2qEDzBS5s1FDlxr3PbeK1TeqJo/OzQQBOYna1MroaxSlprdCBPZU557S6eIJnCdb5
         olLmv3QagqFH+mHhOLiSq93fm0Uh0rVu9I4UxIa8LXfoFPAkZi39u6oPfnbtI4crbERR
         Ff9bAHJ8G2/kjJ7Y3+5iOhEFMiw/W8v8dNThLyzjw/miPWcPYawmCiSu2KIFWP97qr0l
         FDcT5r9I0EFEBIg1qoa2vtPZYNcnrmtvKMee/Wak/qdUuMzpRoOC0uDwHG8ysEHpR63s
         It9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcVv+XhwhadZvdGYXvwV+SiX4KJ1bsdNrTTyWe5H02A=;
        b=sZEf7VgMG7w3xl52unlDhU3DENGLYHGv97PNn9nEb+oH5gDTNnW1Od7VkVRvZOWChU
         81kifLXr9iALmcJnlVBNSpAaEWQpxS2nPj4E+ulW09BY2nAqJM/ceP5yFmy8lgCj9kw5
         /6kvy15XHneT3WalyJZfZb/tjSK/IVIipWycj4VYYftwBAqHOMjGbpelWIMvwvLZyIzJ
         2Y03P6FjhWVFKD1nseqRrEvV2A3QceCT8j7KODQg/Q09RJDBi9mqJ1uGunvlZG2o27pf
         pD9pU58tQ/thLEDdAy467y5b2JKqml13k/T+K3gl1U7Uh9UlOnxHPCM4Wo+Zv8w+DtWw
         JHyw==
X-Gm-Message-State: AHQUAuY9GTqa5QDov92ckvHWaL84gqXUOgYTqeSanw8wnf7t0etB7+F5
        G3H/ON26OmUqEd+iB6RRg4g=
X-Google-Smtp-Source: AHgI3Ia6OCG7oOrK0hNHXpxkFJ4MTa1v28XXad2gtyDiqrSZkHlBif5RIEV8bC/SkmvIvQPtXQE6fA==
X-Received: by 2002:a2e:9a55:: with SMTP id k21mr13226480ljj.191.1551186718216;
        Tue, 26 Feb 2019 05:11:58 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16-v6sm2952518lji.88.2019.02.26.05.11.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:11:57 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4/4] brcmfmac: reset PCIe bus on a firmware crash
Date:   Tue, 26 Feb 2019 14:11:19 +0100
Message-Id: <20190226131119.7907-5-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226131119.7907-1-zajec5@gmail.com>
References: <20190226131119.7907-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This includes bus reset & reloading a firmware. It should be sufficient
for a user space to (setup and) use a wireless device again.

Support for reset on USB & SDIO can be added later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/bus.h         | 10 ++++++
 .../broadcom/brcm80211/brcmfmac/core.c        | 12 +++++++
 .../broadcom/brcm80211/brcmfmac/core.h        |  2 ++
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 35 +++++++++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 801106583ae7..2fe167eae22c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -91,6 +91,7 @@ struct brcmf_bus_ops {
 	int (*get_fwname)(struct device *dev, const char *ext,
 			  unsigned char *fw_name);
 	void (*debugfs_create)(struct device *dev);
+	int (*reset)(struct device *dev);
 };
 
 
@@ -245,6 +246,15 @@ void brcmf_bus_debugfs_create(struct brcmf_bus *bus)
 	return bus->ops->debugfs_create(bus->dev);
 }
 
+static inline
+int brcmf_bus_reset(struct brcmf_bus *bus)
+{
+	if (!bus->ops->reset)
+		return -EOPNOTSUPP;
+
+	return bus->ops->reset(bus->dev);
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 7f4d9356b79e..5f3548b13639 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1084,6 +1084,14 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	return 0;
 }
 
+static void brcmf_core_bus_reset(struct work_struct *work)
+{
+	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
+					      bus_reset);
+
+	brcmf_bus_reset(drvr->bus_if);
+}
+
 static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 {
 	int ret = -1;
@@ -1155,6 +1163,8 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 #endif
 #endif /* CONFIG_INET */
 
+	INIT_WORK(&drvr->bus_reset, brcmf_core_bus_reset);
+
 	/* populate debugfs */
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
@@ -1281,6 +1291,8 @@ void brcmf_fw_crashed(struct device *dev)
 	bphy_err(drvr, "Firmware has halted or crashed\n");
 
 	brcmf_dev_coredump(dev);
+
+	schedule_work(&drvr->bus_reset);
 }
 
 void brcmf_detach(struct device *dev)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index d8085ce579f4..9f09aa31eeda 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -143,6 +143,8 @@ struct brcmf_pub {
 	struct notifier_block inet6addr_notifier;
 	struct brcmf_mp_device *settings;
 
+	struct work_struct bus_reset;
+
 	u8 clmver[BRCMF_DCMD_SMLEN];
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index cfa34672315f..e941039ee1c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -345,6 +345,10 @@ static const u32 brcmf_ring_itemsize[BRCMF_NROF_COMMON_MSGRINGS] = {
 	BRCMF_D2H_MSGRING_RX_COMPLETE_ITEMSIZE
 };
 
+static void brcmf_pcie_setup(struct device *dev, int ret,
+			     struct brcmf_fw_request *fwreq);
+static struct brcmf_fw_request *
+brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo);
 
 static u32
 brcmf_pcie_read_reg32(struct brcmf_pciedev_info *devinfo, u32 reg_offset)
@@ -1409,6 +1413,36 @@ int brcmf_pcie_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
 	return 0;
 }
 
+static int brcmf_pcie_reset(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
+	struct brcmf_pciedev_info *devinfo = buspub->devinfo;
+	struct brcmf_fw_request *fwreq;
+	int err;
+
+	brcmf_detach(dev);
+
+	brcmf_pcie_release_irq(devinfo);
+	brcmf_pcie_release_scratchbuffers(devinfo);
+	brcmf_pcie_release_ringbuffers(devinfo);
+	brcmf_pcie_reset_device(devinfo);
+
+	fwreq = brcmf_pcie_prepare_fw_request(devinfo);
+	if (!fwreq) {
+		dev_err(dev, "Failed to prepare FW request\n");
+		return -ENOMEM;
+	}
+
+	err = brcmf_fw_get_firmwares(dev, fwreq, brcmf_pcie_setup);
+	if (err) {
+		dev_err(dev, "Failed to prepare FW request\n");
+		kfree(fwreq);
+	}
+
+	return err;
+}
+
 static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 	.txdata = brcmf_pcie_tx,
 	.stop = brcmf_pcie_down,
@@ -1418,6 +1452,7 @@ static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 	.get_ramsize = brcmf_pcie_get_ramsize,
 	.get_memdump = brcmf_pcie_get_memdump,
 	.get_fwname = brcmf_pcie_get_fwname,
+	.reset = brcmf_pcie_reset,
 };
 
 
-- 
2.20.1

