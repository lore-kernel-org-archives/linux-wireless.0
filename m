Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab2DJRfy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:54 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 13/18] NFC: Fix LLCP TLV building routine
Date: Tue, 10 Apr 2012 19:43:15 +0200
Message-Id: <1334079800-10671-14-git-send-email-sameo@linux.intel.com> (sfid-20120410_193557_793104_2E4C6C10)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The if logic could lead to zero length TLVs.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 4aa52b8..34ee684 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -102,7 +102,7 @@ u8 *nfc_llcp_build_tlv(u8 type, u8 *value, u8 value_length, u8 *tlv_length)
 	length = llcp_tlv_length[type];
 	if (length == 0 && value_length == 0)
 		return NULL;
-	else
+	else if (length == 0)
 		length = value_length;
 
 	*tlv_length = 2 + length;
-- 
1.7.9.1

