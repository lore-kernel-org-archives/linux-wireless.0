Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57774 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbHTP0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:26:47 -0400
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
	m.szyprowski@samsung.com, pebolle@tiscali.nl,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 1/3] NFC: nci: Add post_setup handler
Date: Thu, 20 Aug 2015 17:26:00 +0200
Message-id: <1440084362-27909-2-git-send-email-r.baldyga@samsung.com> (sfid-20150820_172759_843084_8FA12BF9)
In-reply-to: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
References: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers require non-standard configuration after NCI_CORE_INIT
request, because they need to know ndev->manufact_specific_info or
ndev->manufact_id. This patch adds post_setup handler allowing to do
such custom configuration.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 include/net/nfc/nci_core.h | 1 +
 net/nfc/nci/core.c         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 01fc8c5..1bdaa5f 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -79,6 +79,7 @@ struct nci_ops {
 	int   (*close)(struct nci_dev *ndev);
 	int   (*send)(struct nci_dev *ndev, struct sk_buff *skb);
 	int   (*setup)(struct nci_dev *ndev);
+	int   (*post_setup)(struct nci_dev *ndev);
 	int   (*fw_download)(struct nci_dev *ndev, const char *firmware_name);
 	__u32 (*get_rfprotocol)(struct nci_dev *ndev, __u8 rf_protocol);
 	int   (*discover_se)(struct nci_dev *ndev);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 95af2d2..d9045ec 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -388,6 +388,10 @@ static int nci_open_device(struct nci_dev *ndev)
 				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
 	}
 
+	if (ndev->ops->post_setup) {
+		rc = ndev->ops->post_setup(ndev);
+	}
+
 	if (!rc) {
 		rc = __nci_request(ndev, nci_init_complete_req, 0,
 				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
-- 
1.9.1

