Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33907 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751124AbdFVHGG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 03:06:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v5M74SKb003697
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 00:06:05 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2b6bsy1een-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 00:06:05 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: Do not change bss_type in change_virtual_intf
Date: Thu, 22 Jun 2017 12:32:52 +0530
Message-ID: <1498114972-25712-1-git-send-email-gbhat@marvell.com> (sfid-20170622_090609_892639_02B33A05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user adds a virtual interface driver will set the
bss_type to the iface_type given by the user. When
supplicant is started on the same interface, a call to
change_virtual_intf will be triggered if if_type is not
NL80211_IFTYPE_STATION. Here driver should not update
it's bss_type, because bss_type is intended to indicate
the original iface_type and changing the same will defeat
the purpose of creating this interface.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6ecbcbd..2239d8f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -875,24 +875,20 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
 			 MWIFIEX_BSS_TYPE_STA);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
-		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
 			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_STA;
-		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
 			 MWIFIEX_BSS_TYPE_P2P);
 		priv->bss_role =  MWIFIEX_BSS_ROLE_UAP;
-		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 		break;
 	case NL80211_IFTYPE_AP:
 		priv->bss_num = mwifiex_get_unused_bss_num(adapter,
 			 MWIFIEX_BSS_TYPE_UAP);
-		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		break;
 	default:
-- 
1.9.1
