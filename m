Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 16.mo1.mail-out.ovh.net ([178.33.104.224]:44887 "EHLO
	16.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbbAVPwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 10:52:42 -0500
Received: from mail434.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 5962AFF9E67
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 16:33:50 +0100 (CET)
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
	=?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>
Subject: [PATCH 1/4] NFC: nci: Add FWDL support
Date: Thu, 22 Jan 2015 16:27:37 +0100
Message-Id: <1421940460-14049-2-git-send-email-clement.perrochaud@effinnov.com> (sfid-20150122_165320_342042_ECB7AE93)
In-Reply-To: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Clément Perrochaud <clement.perrochaud@nxp.com>

Signed-off-by: Clément Perrochaud <clement.perrochaud@nxp.com>
Signed-off-by: Clément Perrochaud <clement.perrochaud@effinnov.com>
---
 include/net/nfc/nci_core.h |  1 +
 net/nfc/nci/core.c         | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 9e51bb4..137e059 100644
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
index 51feb5e..1342c7d 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -789,6 +789,16 @@ static int nci_se_io(struct nfc_dev *nfc_dev, u32 se_idx,
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
@@ -804,6 +814,7 @@ static struct nfc_ops nci_nfc_ops = {
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

