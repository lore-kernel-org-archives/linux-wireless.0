Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48925 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1LPUZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 15:25:48 -0500
Date: Fri, 16 Dec 2011 23:25:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] NFC: double unlock in nfc_llcp_recv_connect()
Message-ID: <20111216202529.GA18570@elgon.mountain> (sfid-20111216_212553_638540_1B91087C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We unlock inside the if block on the other side of this if else
statement.  It could result in calling mutex_unlock() twice.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 67756b2..f99d6b4 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -554,11 +554,9 @@ static void nfc_llcp_recv_connect(struct nfc_llcp_local *local,
 				goto enqueue;
 			}
 		}
-
+		mutex_unlock(&local->socket_lock);
 	}
 
-	mutex_unlock(&local->socket_lock);
-
 	reason = LLCP_DM_NOBOUND;
 	goto fail;
 
