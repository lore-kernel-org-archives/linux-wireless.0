Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:6733 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbbFKLGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:06:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id C4B9E8E4A8E
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 13:06:36 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCHv2 3/4] brcm80211: send minimum bandwidth to handle
Date: Thu, 11 Jun 2015 13:06:30 +0200
Message-Id: <1434020791-16291-4-git-send-email-matthias.may@neratec.com> (sfid-20150611_130646_823522_65B64B2B)
In-Reply-To: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add 20MHz minimum bandwidth to the calls of freq_reg_info()

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 635ae03..1de5129 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -680,7 +680,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 				rule = freq_reg_info(wiphy,
-						     MHZ_TO_KHZ(ch->center_freq));
+						     MHZ_TO_KHZ(ch->center_freq),
+						     MHZ_TO_KHZ(20));
 				if (IS_ERR(rule))
 					continue;
 
-- 
2.1.4

