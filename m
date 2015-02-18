Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57140 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbbBRUJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 15:09:55 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so6249655obb.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 12:09:54 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: Silence warning for unknown backplane revision
Date: Wed, 18 Feb 2015 14:09:38 -0600
Message-Id: <1424290178-25328-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150218_210958_373352_8F880AA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using a BCM4318 in a PCMCIA format, I get a startup message that the
device uses backplane revision 0xF000000. Next a WARNING is logged. Despite
the message, the device works fine, This patch silences the warning.

Cc: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/ssb/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 1e180c4..a48a743 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1135,6 +1135,8 @@ static u32 ssb_tmslow_reject_bitmask(struct ssb_device *dev)
 	case SSB_IDLOW_SSBREV_25:     /* TODO - find the proper REJECT bit */
 	case SSB_IDLOW_SSBREV_27:     /* same here */
 		return SSB_TMSLOW_REJECT;	/* this is a guess */
+	case SSB_IDLOW_SSBREV:
+		break;
 	default:
 		WARN(1, KERN_INFO "ssb: Backplane Revision 0x%.8X\n", rev);
 	}
-- 
2.1.4

