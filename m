Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620Ab2DJRgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:16 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 18/18] NFC: Fix LLCP link timeout typo
Date: Tue, 10 Apr 2012 19:43:20 +0200
Message-Id: <1334079800-10671-19-git-send-email-sameo@linux.intel.com> (sfid-20120410_193630_901795_FF7D8028)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were sending the LTO TLV as a version TLV instead of the actual link
timeout one.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 31a05e5..92988aa 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -318,7 +318,7 @@ static int nfc_llcp_build_gb(struct nfc_llcp_local *local)
 
 	/* 1500 ms */
 	lto = 150;
-	lto_tlv = nfc_llcp_build_tlv(LLCP_TLV_VERSION, &lto, 1, &lto_length);
+	lto_tlv = nfc_llcp_build_tlv(LLCP_TLV_LTO, &lto, 1, &lto_length);
 	gb_len += lto_length;
 
 	pr_debug("Local wks 0x%lx\n", local->local_wks);
-- 
1.7.9.1

