Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 10/16] rtl8xxxu: Set register 0xfe10 on rtl8192cu based parts
Date: Thu, 14 Apr 2016 16:37:15 -0400
Message-Id: <1460666241-5365-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223728_059825_8CBE35C5)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This register is undocumented in the vendor code, but it is set
unconditionally for all 8192cu/8188cu/8188ru parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index de62f0b..6280d3d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7214,6 +7214,8 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 		CR_SCHEDULE_ENABLE | CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE;
 	rtl8xxxu_write16(priv, REG_CR, val16);
 
+	rtl8xxxu_write8(priv, 0xfe10, 0x19);
+
 	/*
 	 * Workaround for 8188RU LNA power leakage problem.
 	 */
-- 
2.5.5

