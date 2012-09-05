Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2265 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2IEJtl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 05:49:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: [PATCH 1/2] brcmsmac: fix mismatch in number of custom
 regulatory rules
Date: Wed, 5 Sep 2012 11:49:21 +0200
Message-ID: <1346838562-4818-2-git-send-email-arend@broadcom.com> (sfid-20120905_114946_874563_46672E12)
In-Reply-To: <1346838562-4818-1-git-send-email-arend@broadcom.com>
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver provides the cfg80211 regulatory framework with a set of
custom rules. However, there was a mismatch in number of rules
and the actual rules provided. This resulted in setting an invalid
power level:

ieee80211 phy0: brcms_ops_config: change channel 13
ieee80211 phy0: brcms_ops_config: Error setting power_level (8758364)

Closer look in cfg80211 regulatory blurb showed following bogus rule:
cfg80211: 0 KHz - -60446948 KHz @ 875836468 KHz), (875836468 mBi, 875836468 mBm)

Cc: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 7ed7d75..64a48f0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -77,7 +77,7 @@
 					 NL80211_RRF_NO_IBSS)
 
 static const struct ieee80211_regdomain brcms_regdom_x2 = {
-	.n_reg_rules = 7,
+	.n_reg_rules = 6,
 	.alpha2 = "X2",
 	.reg_rules = {
 		BRCM_2GHZ_2412_2462,
-- 
1.7.9.5


