Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34800 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbGFRr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 13:47:27 -0400
Date: Mon, 6 Jul 2015 19:48:04 +0200
From: Daniel Machon <dmachon.dev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] wilc1000: host_interface.c: global variables do not need
 to be explicitly initialized to 0 or NULL. GCC takes care of this
 implicitly.
Message-ID: <20150706174759.GA6913@gmail.com> (sfid-20150706_194741_861514_09368CA4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed explicit initialization of global pointer variable.

Signed-off-by: Daniel Machon <dmachon.dev@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b10bbb..209dd9c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -534,8 +534,8 @@ typedef enum {
 /*****************************************************************************/
 
 
-tstrWILC_WFIDrv *terminated_handle = NULL;
-tstrWILC_WFIDrv *gWFiDrvHandle = NULL;
+tstrWILC_WFIDrv *terminated_handle;
+tstrWILC_WFIDrv *gWFiDrvHandle;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 bool g_obtainingIP = false;
 #endif
-- 
2.1.4

