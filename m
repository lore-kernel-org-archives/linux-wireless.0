Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35819 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdHCJNf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:13:35 -0400
Received: by mail-pf0-f196.google.com with SMTP id j68so954577pfc.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 02:13:34 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 1/2] mwifiex: Do not change bss_num in change_virtual_intf
Date: Thu,  3 Aug 2017 09:13:27 +0000
Message-Id: <1501751608-12829-1-git-send-email-huxinming820@gmail.com> (sfid-20170803_111338_969009_38F3042A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Commit "mwifiex: Do not change bss_type in change_virtual_intf"
Keep original bss_type unchanged. bss_num should keep the same
style, in this way. Unique tuple (bss_type, bss_num) will be
able to locate the right priv structure.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 820475a..58720c9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -893,23 +893,15 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
-			 MWIFIEX_BSS_TYPE_STA);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
-			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
-			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
 		break;
 	case NL80211_IFTYPE_AP:
-		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
-			 MWIFIEX_BSS_TYPE_UAP);
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		break;
 	default:
-- 
1.9.1
