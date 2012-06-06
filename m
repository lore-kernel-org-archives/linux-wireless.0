Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17207 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2FFKGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:06:52 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/29] NFC: LLCP's MIUX is 10 bytes long, not 7
Date: Wed,  6 Jun 2012 12:16:22 +0200
Message-Id: <1338977806-30279-6-git-send-email-sameo@linux.intel.com> (sfid-20120606_120654_719723_0DB4DAEC)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mask is 0x7ff and not 0x7f and the return value is an u16.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 850e5cf..b982b5b 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -51,7 +51,7 @@ static u8 llcp_tlv8(u8 *tlv, u8 type)
 	return tlv[2];
 }
 
-static u8 llcp_tlv16(u8 *tlv, u8 type)
+static u16 llcp_tlv16(u8 *tlv, u8 type)
 {
 	if (tlv[0] != type || tlv[1] != llcp_tlv_length[tlv[0]])
 		return 0;
@@ -67,7 +67,7 @@ static u8 llcp_tlv_version(u8 *tlv)
 
 static u16 llcp_tlv_miux(u8 *tlv)
 {
-	return llcp_tlv16(tlv, LLCP_TLV_MIUX) & 0x7f;
+	return llcp_tlv16(tlv, LLCP_TLV_MIUX) & 0x7ff;
 }
 
 static u16 llcp_tlv_wks(u8 *tlv)
-- 
1.7.9.1

