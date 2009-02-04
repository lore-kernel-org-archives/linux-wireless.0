Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2946 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZBDXkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:40:25 -0500
Received: by nf-out-0910.google.com with SMTP id d3so448312nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:40:22 -0800 (PST)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: pihhan@cipis.net, stephenhoinhk@gmail.com, iojedaperez@gmail.com,
	Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] zd1211rw: treat MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for TP-Link WN322/422G
Date: Wed,  4 Feb 2009 23:40:43 +0000
Message-Id: <1233790843-7000-1-git-send-email-HinTak.Leung@gmail.com> (sfid-20090205_004034_745596_1DD64489)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three people (Petr Mensik <pihhan@cipis.net> 
["si" should be U+0161 U+00ED], Stephen Ho <stephenhoinhk@gmail.com> 
on zd1211-devs and Ismael Ojeda Perez <iojedaperez@gmail.com> 
on linux-wiress) reported success in getting TP-Link WN322G/WN422G 
working by treating MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for rf 
chip hardware initialization.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Petr Mensik <pihhan@cipis.net>
Tested-by: Stephen Ho <stephenhoinhk@gmail.com>
Tested-by: Ismael Ojeda Perez <iojedaperez@gmail.com>
---
 drivers/net/wireless/zd1211rw/zd_rf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index 7207bfd..c875ee0 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -86,6 +86,7 @@ int zd_rf_init_hw(struct zd_rf *rf, u8 type)
 	case AL7230B_RF:
 		r = zd_rf_init_al7230b(rf);
 		break;
+	case MAXIM_NEW_RF:
 	case UW2453_RF:
 		r = zd_rf_init_uw2453(rf);
 		break;
-- 
1.6.0.6

