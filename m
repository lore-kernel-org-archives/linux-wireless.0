Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 26/26] Re-enable 8192eu support
Date: Thu, 14 Apr 2016 14:59:07 -0400
Message-Id: <1460660347-26299-27-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205936_810309_39047B97)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Revert "rtl8xxxu: Temporarily disable 8192eu device init"

This reverts commit ccfe1e85322090649d2fae599e55300c1512bf15.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6febda5..39a033c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3137,10 +3137,6 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 				 raw[i + 6], raw[i + 7]);
 		}
 	}
-	/*
-	 * Temporarily disable 8192eu support
-	 */
-	return -EINVAL;
 	return 0;
 }
 
-- 
2.5.5

