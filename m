Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbHTP04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:26:56 -0400
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
	m.szyprowski@samsung.com, pebolle@tiscali.nl,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 2/3] NFC: nci: export nci_core_reset and nci_core_init
Date: Thu, 20 Aug 2015 17:26:01 +0200
Message-id: <1440084362-27909-3-git-send-email-r.baldyga@samsung.com> (sfid-20150820_172739_455934_ECF0F561)
In-reply-to: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
References: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers needs to have ability to reinit NCI core, for example after
updating firmware in setup() of post_setup() callback. This patch makes
nci_core_reset() and nci_core_init() functions public, to make it possible.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 include/net/nfc/nci_core.h |  2 ++
 net/nfc/nci/core.c         | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 1bdaa5f..d0d0f1e 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -278,6 +278,8 @@ int nci_request(struct nci_dev *ndev,
 			    unsigned long opt),
 		unsigned long opt, __u32 timeout);
 int nci_prop_cmd(struct nci_dev *ndev, __u8 oid, size_t len, __u8 *payload);
+int nci_core_reset(struct nci_dev *ndev);
+int nci_core_init(struct nci_dev *ndev);
 
 int nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb);
 int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, __u8 *val);
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d9045ec..943889b 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -351,6 +351,20 @@ int nci_prop_cmd(struct nci_dev *ndev, __u8 oid, size_t len, __u8 *payload)
 }
 EXPORT_SYMBOL(nci_prop_cmd);
 
+int nci_core_reset(struct nci_dev *ndev)
+{
+	return __nci_request(ndev, nci_reset_req, 0,
+			     msecs_to_jiffies(NCI_RESET_TIMEOUT));
+}
+EXPORT_SYMBOL(nci_core_reset);
+
+int nci_core_init(struct nci_dev *ndev)
+{
+	return __nci_request(ndev, nci_init_req, 0,
+			     msecs_to_jiffies(NCI_INIT_TIMEOUT));
+}
+EXPORT_SYMBOL(nci_core_init);
+
 static int nci_open_device(struct nci_dev *ndev)
 {
 	int rc = 0;
-- 
1.9.1

