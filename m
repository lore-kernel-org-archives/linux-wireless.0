Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43279 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1BPM6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 07:58:13 -0500
Received: by eye27 with SMTP id 27so730276eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 04:58:11 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH 2/2] ssb: remove invalid define SSB_TMSLOW_PHYCLK
Date: Wed, 16 Feb 2011 13:58:26 +0100
Message-Id: <1297861106-18739-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1297861106-18739-1-git-send-email-zajec5@gmail.com>
References: <1297861106-18739-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was incorrectly introduced in d2730b2a6a019d14455556019d744ab051e6554b. We
have already fixed function to use correct define, but forgot remove old one.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Gábor Stefanik <netrolller.3d@gmail.com>
---
 include/linux/ssb/ssb_regs.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 489f7b6..01253c6 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -97,7 +97,6 @@
 #define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
 #define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
 #define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
-#define  SSB_TMSLOW_PHYCLK	0x00000010 /* MAC PHY Clock Control Enable */
 #define  SSB_TMSLOW_CLOCK	0x00010000 /* Clock Enable */
 #define  SSB_TMSLOW_FGC		0x00020000 /* Force Gated Clocks On */
 #define  SSB_TMSLOW_PE		0x40000000 /* Power Management Enable */
-- 
1.7.1

