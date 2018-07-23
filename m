Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39183 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbeGWOde (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 10:33:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id l15-v6so561999lji.6
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2018 06:32:17 -0700 (PDT)
From: roman.stratiienko@globallogic.com
To: akarwar@marvell.com
Cc: nishants@marvell.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roman Stratiienko <roman.stratiienko@globallogic.com>
Subject: [PATCH] mwifiex: Fix skipped vendor specific IEs
Date: Mon, 23 Jul 2018 16:31:39 +0300
Message-Id: <1532352699-3232-1-git-send-email-roman.stratiienko@globallogic.com> (sfid-20180723_153332_151603_B897A18E)
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
