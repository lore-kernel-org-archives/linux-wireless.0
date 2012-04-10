Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab2DJRgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:12 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 17/18] NFC: Add MIUX to the local LLCP general bytes
Date: Tue, 10 Apr 2012 19:43:19 +0200
Message-Id: <1334079800-10671-18-git-send-email-sameo@linux.intel.com> (sfid-20120410_193656_671644_D241BD21)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 2cf01e6..31a05e5 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -307,6 +307,8 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 	u8 *gb_cur, *version_tlv, version, version_length;
 	u8 *lto_tlv, lto, lto_length;
 	u8 *wks_tlv, wks_length;
+	u8 *miux_tlv, miux_length;
+	__be16 miux;
 	u8 gb_len = 0;
 
 	version = LLCP_VERSION_11;
@@ -324,6 +326,11 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 				     &wks_length);
 	gb_len += wks_length;
 
+	miux = cpu_to_be16(LLCP_MAX_MIUX);
+	miux_tlv = nfc_llcp_build_tlv(LLCP_TLV_MIUX, (u8 *)&miux, 0,
+				      &miux_length);
+	gb_len += miux_length;
+
 	gb_len += ARRAY_SIZE(llcp_magic);
 
 	if (gb_len > NFC_MAX_GT_LEN) {
@@ -345,6 +352,9 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 	memcpy(gb_cur, wks_tlv, wks_length);
 	gb_cur += wks_length;
 
+	memcpy(gb_cur, miux_tlv, miux_length);
+	gb_cur += miux_length;
+
 	kfree(version_tlv);
 	kfree(lto_tlv);
 
-- 
1.7.9.1

