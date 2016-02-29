Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbcB2WF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:58 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 113/113] rtl8xxxu: Temporarily disable 8192eu device init
Date: Mon, 29 Feb 2016 17:05:51 -0500
Message-Id: <1456783551-28315-114-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_089419_7624E50E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To reduce the patch volume, temporariliy disable 8192eu device init.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 1c5a6ef..8b3523d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2562,6 +2562,10 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 				 raw[i + 6], raw[i + 7]);
 		}
 	}
+	/*
+	 * Temporarily disable 8192eu support
+	 */
+	return -EINVAL;
 	return 0;
 }
 
-- 
2.5.0

