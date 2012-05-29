Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44024 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2E2WmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:42:05 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat: remove hci_mon.h
Date: Wed, 30 May 2012 00:41:47 +0200
Message-Id: <1338331308-29732-4-git-send-email-hauke@hauke-m.de> (sfid-20120530_004210_122540_0EE20180)
In-Reply-To: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
References: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat-wireless should copy this file from the kernel

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/net/bluetooth/hci_mon.h |   51 ---------------------------------------
 1 file changed, 51 deletions(-)
 delete mode 100644 include/net/bluetooth/hci_mon.h

diff --git a/include/net/bluetooth/hci_mon.h b/include/net/bluetooth/hci_mon.h
deleted file mode 100644
index 07a25c9..0000000
--- a/include/net/bluetooth/hci_mon.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
-   BlueZ - Bluetooth protocol stack for Linux
-
-   Copyright (C) 2011-2012  Intel Corporation
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License version 2 as
-   published by the Free Software Foundation;
-
-   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
-   IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
-   CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
-   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-
-   ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
-   COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
-   SOFTWARE IS DISCLAIMED.
-*/
-
-#ifndef __HCI_MON_H
-#define __HCI_MON_H
-
-struct hci_mon_hdr {
-	__le16	opcode;
-	__le16	index;
-	__le16	len;
-} __packed;
-#define HCI_MON_HDR_SIZE 6
-
-#define HCI_MON_NEW_INDEX	0
-#define HCI_MON_DEL_INDEX	1
-#define HCI_MON_COMMAND_PKT	2
-#define HCI_MON_EVENT_PKT	3
-#define HCI_MON_ACL_TX_PKT	4
-#define HCI_MON_ACL_RX_PKT	5
-#define HCI_MON_SCO_TX_PKT	6
-#define HCI_MON_SCO_RX_PKT	7
-
-struct hci_mon_new_index {
-	__u8	type;
-	__u8	bus;
-	bdaddr_t bdaddr;
-	char	name[8];
-} __packed;
-#define HCI_MON_NEW_INDEX_SIZE 16
-
-#endif /* __HCI_MON_H */
-- 
1.7.9.5

