Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63293 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3J2Sel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:34:41 -0400
Received: by mail-wi0-f171.google.com with SMTP id f4so1718906wiw.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:34:40 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/3] brcm80211: fix usage of freq_reg_info()
Date: Tue, 29 Oct 2013 19:34:25 +0100
Message-Id: <1383071666-26817-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_193444_395058_AB05954C)
In-Reply-To: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

freq_reg_info() expects KHz and not MHz, fix this. In
this case we'll now be getting the no-ir flags cleared
on channels for any channel when the country IE trusts
that channel.

@@
struct ieee80211_channel *ch;
struct wiphy *wiphy;
const struct ieee80211_reg_rule *rule;
@@

-rule = freq_reg_info(wiphy, ch->center_freq);
+rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));

Generated-by: Coccinelle SmPL
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>
Reported-by: Mihir Shete <smihir@qti.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index c99364f..8272570 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -678,7 +678,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				rule = freq_reg_info(wiphy, ch->center_freq);
+				rule = freq_reg_info(wiphy,
+						     MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(rule))
 					continue;
 
-- 
1.8.4.rc3

