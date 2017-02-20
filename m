Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:46768 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdBTSWA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 13:22:00 -0500
Date: Mon, 20 Feb 2017 21:15:33 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-wireless@vger.kernel.org, x86@kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] uapi: fix definition of struct sockaddr_nfc_llcp on x32 and mips n32
Message-ID: <20170220181533.GA11185@altlinux.org> (sfid-20170220_192208_462723_9DE2C94C)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace size_t with __kernel_size_t to fix definition of struct
sockaddr_nfc_llcp on architectures like x32 and mips n32 where
sizeof(size_t) < sizeof(__kernel_size_t).

This also fixes the following linux/nfc.h userspace compilation error:

/usr/include/linux/nfc.h:279:2: error: unknown type name 'size_t'
  size_t service_name_len;

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 include/uapi/linux/nfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/nfc.h b/include/uapi/linux/nfc.h
index 399f39f..f8ccc12 100644
--- a/include/uapi/linux/nfc.h
+++ b/include/uapi/linux/nfc.h
@@ -276,7 +276,7 @@ struct sockaddr_nfc_llcp {
 	__u8 dsap; /* Destination SAP, if known */
 	__u8 ssap; /* Source SAP to be bound to */
 	char service_name[NFC_LLCP_MAX_SERVICE_NAME]; /* Service name URI */;
-	size_t service_name_len;
+	__kernel_size_t service_name_len;
 };
 
 /* NFC socket protocols */
-- 
ldv
