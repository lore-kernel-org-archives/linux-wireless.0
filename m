Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25761 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2GFT7x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:53 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 20/33] NFC: Build LLCP general bytes upon request
Date: Fri,  6 Jul 2012 22:09:40 +0200
Message-Id: <1341605393-32056-21-git-send-email-sameo@linux.intel.com> (sfid-20120706_220532_698089_BBC53C80)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers will need them before starting a poll or when being activated
as targets. Mostly WKS can have changed between device registration and
then so we need to re-build the whole array.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index eee4b92..6812b1e 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -310,21 +310,6 @@ void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap)
 	mutex_unlock(&local->sdp_lock);
 }
 
-u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len)
-{
-	struct nfc_llcp_local *local;
-
-	local = nfc_llcp_find_local(dev);
-	if (local == NULL) {
-		*general_bytes_len = 0;
-		return NULL;
-	}
-
-	*general_bytes_len = local->gb_len;
-
-	return local->gb;
-}
-
 static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 {
 	u8 *gb_cur, *version_tlv, version, version_length;
@@ -386,6 +371,23 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 	return 0;
 }
 
+u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *general_bytes_len)
+{
+	struct nfc_llcp_local *local;
+
+	local = nfc_llcp_find_local(dev);
+	if (local == NULL) {
+		*general_bytes_len = 0;
+		return NULL;
+	}
+
+	nfc_llcp_build_gb(local);
+
+	*general_bytes_len = local->gb_len;
+
+	return local->gb;
+}
+
 int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 {
 	struct nfc_llcp_local *local = nfc_llcp_find_local(dev);
-- 
1.7.10

