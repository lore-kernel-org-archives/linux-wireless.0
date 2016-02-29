Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 102/113] rtl8xxxu: Dump contents of unhandled C2H events
Date: Mon, 29 Feb 2016 17:05:40 -0500
Message-Id: <1456783551-28315-103-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_544887_2BC3E929)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Dump the contents of unhandled C2H events. We should be handling all
expected events, so this is debugging help in case an unexpected event
happens.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index f9d5b23..3985903 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7446,7 +7446,10 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 			c2h->bt_mp_info.ext_id, c2h->bt_mp_info.status);
 		break;
 	default:
-		dev_info(dev, "Unhandled C2H event %02x\n", c2h->id);
+		dev_info(dev, "Unhandled C2H event %02x seq %02x\n",
+			 c2h->id, c2h->seq);
+		print_hex_dump(KERN_INFO, "C2H content: ", DUMP_PREFIX_NONE,
+			       16, 1, c2h->raw.payload, len, false);
 		break;
 	}
 }
-- 
2.5.0

