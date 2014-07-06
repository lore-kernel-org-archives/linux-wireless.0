Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:61291 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaGFWUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 18:20:19 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so3591909wes.15
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 15:20:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/3] staging: vt6656: vnt_set_keymode don't save pairwise key entry.
Date: Sun,  6 Jul 2014 23:19:47 +0100
Message-Id: <1404685188-3182-2-git-send-email-tvboxspy@gmail.com> (sfid-20140707_002027_006789_563E8653)
In-Reply-To: <1404685188-3182-1-git-send-email-tvboxspy@gmail.com>
References: <1404685188-3182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device refuses to associate to older access points even though in
the logs it appears to be associated in tkip or ccmp mode. 

Clear bit from key_entry_inuse in pairwise key so the entry is over written
by group address.

This doesn't seem to make any difference to newer access points and
is a temporary fix until a better solution is found.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index a7c7a2d..7275f09 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -98,6 +98,8 @@ static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
 	case  VNT_KEY_PAIRWISE:
 		key_mode |= mode;
 		key_inx = 4;
+		/* Don't save entry for pairwise key */
+		clear_bit(entry, &priv->key_entry_inuse);
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1

