Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63527 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaGKTCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 15:02:50 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so1523063wgh.17
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 12:02:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6656: Fix pairwise key for non station modes
Date: Fri, 11 Jul 2014 20:02:18 +0100
Message-Id: <1405105338-3073-2-git-send-email-tvboxspy@gmail.com> (sfid-20140711_210253_398698_37B3DEE2)
In-Reply-To: <1405105338-3073-1-git-send-email-tvboxspy@gmail.com>
References: <1405105338-3073-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch 'vnt_set_keymode don't save pairwise key entry' caused
a slight regression in access point mode

Only don't save in station mode.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/key.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 7275f09..b76ee31 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -98,8 +98,9 @@ static int vnt_set_keymode(struct ieee80211_hw *hw, u8 *mac_addr,
 	case  VNT_KEY_PAIRWISE:
 		key_mode |= mode;
 		key_inx = 4;
-		/* Don't save entry for pairwise key */
-		clear_bit(entry, &priv->key_entry_inuse);
+		/* Don't save entry for pairwise key for station mode */
+		if (priv->op_mode == NL80211_IFTYPE_STATION)
+			clear_bit(entry, &priv->key_entry_inuse);
 		break;
 	default:
 		return -EINVAL;
-- 
1.9.1

