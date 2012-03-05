Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab2CDX5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:44 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/22] NFC: Clear LLCP SDPs whan MAC goes down
Date: Mon,  5 Mar 2012 01:03:40 +0100
Message-Id: <1330905834-6994-9-git-send-email-sameo@linux.intel.com> (sfid-20120305_005749_013162_623B6E29)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 443407e..577bcb9 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -97,6 +97,17 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local)
 	mutex_unlock(&local->socket_lock);
 }
 
+static void nfc_llcp_clear_sdp(struct nfc_llcp_local *local)
+{
+	mutex_lock(&local->sdp_lock);
+
+	local->local_wks = 0;
+	local->local_sdp = 0;
+	local->local_sap = 0;
+
+	mutex_unlock(&local->sdp_lock);
+}
+
 static void nfc_llcp_timeout_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
@@ -857,6 +868,8 @@ void nfc_llcp_mac_is_down(struct nfc_dev *dev)
 	if (local == NULL)
 		return;
 
+	nfc_llcp_clear_sdp(local);
+
 	/* Close and purge all existing sockets */
 	nfc_llcp_socket_release(local);
 }
-- 
1.7.7.3

