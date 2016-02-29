Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbcB2WGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:02 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 111/113] rtl8xxxu: Print a warning if flushing the FIFO fails
Date: Mon, 29 Feb 2016 17:05:49 -0500
Message-Id: <1456783551-28315-112-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_059883_0E9F4026)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Only print a warning if the FIFO flush fails, as opposed to printing
the status unconditionally.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c594afa..11a970c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5689,6 +5689,7 @@ static int rtl8xxxu_emu_to_disabled(struct rtl8xxxu_priv *priv)
 
 static int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv)
 {
+	struct device *dev = &priv->udev->dev;
 	u32 val32;
 	int retry, retval;
 
@@ -5712,7 +5713,9 @@ static int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write16(priv, REG_RQPN_NPQ, 0);
 	rtl8xxxu_write32(priv, REG_RQPN, 0x80000000);
 	mdelay(2);
-	pr_info("%s: retry %i\n", __func__, retry);
+
+	if (!retry)
+		dev_warn(dev, "Failed to flush FIFO\n");
 
 	return retval;
 }
-- 
2.5.0

