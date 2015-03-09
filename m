Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 18.mo6.mail-out.ovh.net ([46.105.73.110]:40806 "EHLO
	18.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbbCIKen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 06:34:43 -0400
Received: from mail187.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id 18C6BFFA3D3
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2015 11:19:12 +0100 (CET)
From: clement.perrochaud@effinnov.com
To: linux-nfc@lists.01.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= <clement.perrochaud@nxp.com>,
	sunil.jogi@nxp.com, jerome.pele@nxp.com,
	Charles.Gorand-Effinnov@nxp.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	anda-maria.nicolae@intel.com,
	=?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>
Subject: [PATCH v2 1/3] NFC: nci: Add firmware download support
Date: Mon,  9 Mar 2015 11:12:03 +0100
Message-Id: <1425895925-20593-2-git-send-email-clement.perrochaud@effinnov.com> (sfid-20150309_113510_609358_769238F4)
In-Reply-To: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com>
References: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Clément Perrochaud <clement.perrochaud@nxp.com>

A simple forward for firmware download (i.e. sending a new firmware
to the NFC adapter) from the NFC subsystem to the drivers.

This feature is required to update the firmware of NXP-NCI NFC
controllers but can be used by any NCI driver.

This feature has been present in the HCI subsystem since 9a695d.

Signed-off-by: Clément Perrochaud <clement.perrochaud@effinnov.com>
---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/core.c         | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index ff87f86..34a6e09 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -71,6 +71,7 @@ struct nci_ops {
 	int   (*close)(struct nci_dev *ndev);
 	int   (*send)(struct nci_dev *ndev, struct sk_buff *skb);
 	int   (*setup)(struct nci_dev *ndev);
+	int   (*fw_download)(struct nci_dev *ndev, const char *firmware_name);
 	__u32 (*get_rfprotocol)(struct nci_dev *ndev, __u8 rf_protocol);
 	int   (*discover_se)(struct nci_dev *ndev);
 	int   (*disable_se)(struct nci_dev *ndev, u32 se_idx);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 9575a18..49ff321 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -907,6 +907,16 @@ static int nci_se_io(struct nfc_dev *nfc_dev, u32 se_idx,
 	return 0;
 }
 
+static int nci_fw_download(struct nfc_dev *nfc_dev, const char *firmware_name)
+{
+	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+
+	if (!ndev->ops->fw_download)
+		return -ENOTSUPP;
+
+	return ndev->ops->fw_download(ndev, firmware_name);
+}
+
 static struct nfc_ops nci_nfc_ops = {
 	.dev_up = nci_dev_up,
 	.dev_down = nci_dev_down,
@@ -922,6 +932,7 @@ static struct nfc_ops nci_nfc_ops = {
 	.disable_se = nci_disable_se,
 	.discover_se = nci_discover_se,
 	.se_io = nci_se_io,
+	.fw_download = nci_fw_download,
 };
 
 /* ---- Interface to NCI drivers ---- */
-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com

