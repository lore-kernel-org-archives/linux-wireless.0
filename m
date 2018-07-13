Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39201 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbeGMRzN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 13:55:13 -0400
Received: by mail-lf0-f68.google.com with SMTP id a134-v6so27812353lfe.6
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2018 10:39:36 -0700 (PDT)
From: roman.stratiienko@globallogic.com
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roman Stratiienko <roman.stratiienko@globallogic.com>
Subject: [PATCH] mwifiex: Fix skipped vendor specific IEs
Date: Fri, 13 Jul 2018 20:37:33 +0300
Message-Id: <1531503453-27343-1-git-send-email-roman.stratiienko@globallogic.com> (sfid-20180713_193941_533954_A286366C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roman Stratiienko <roman.stratiienko@globallogic.com>

Only microsoft specific IE is added by FW
Let other IEs to pass from userspace

Signed-off-by: Roman Stratiienko <roman.stratiienko@globallogic.com>
---
 drivers/net/wireless/marvell/mwifiex/ie.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index c488c30..c58b345 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -353,8 +353,16 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 		case WLAN_EID_HT_OPERATION:
 		case WLAN_EID_VHT_CAPABILITY:
 		case WLAN_EID_VHT_OPERATION:
-		case WLAN_EID_VENDOR_SPECIFIC:
 			break;
+		case WLAN_EID_VENDOR_SPECIFIC:
+			/* Skip only Microsoft IE that added by FW
+			 * Let other vendor specific IE to pass
+			 */
+			if (cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+						    WLAN_OUI_TYPE_MICROSOFT_WMM,
+						    (const u8 *)hdr,
+						    hdr->len + sizeof(struct ieee_types_header)))
+				break;
 		default:
 			memcpy(gen_ie->ie_buffer + ie_len, hdr,
 			       hdr->len + sizeof(struct ieee_types_header));
-- 
2.7.4
