Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2CDX6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:13 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 17/22] NFC: SN is not an invalid GT value
Date: Mon,  5 Mar 2012 01:03:49 +0100
Message-Id: <1330905834-6994-18-git-send-email-sameo@linux.intel.com> (sfid-20120305_005817_948336_DB59EDD9)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We just don't do anything with it when parsing the general bytes.
We handle it from the CONNECT reception code.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index bfe35b8..7c74b82 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -152,6 +152,8 @@ int nfc_llcp_parse_tlv(struct nfc_llcp_local *local,
 		case LLCP_TLV_RW:
 			local->remote_rw = llcp_tlv_rw(tlv);
 			break;
+		case LLCP_TLV_SN:
+			break;
 		default:
 			pr_err("Invalid gt tlv value 0x%x\n", type);
 			break;
-- 
1.7.7.3

