Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43150 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbeGXMyF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 08:54:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id f135-v6so1037249lfg.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 04:48:00 -0700 (PDT)
From: roman.stratiienko@globallogic.com
To: akarwar@marvell.com
Cc: nishants@marvell.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Roman Stratiienko <roman.stratiienko@globallogic.com>
Subject: [PATCH] mwifiex: Fix skipped vendor specific IEs
Date: Tue, 24 Jul 2018 14:47:27 +0300
Message-Id: <1532432847-2885-1-git-send-email-roman.stratiienko@globallogic.com> (sfid-20180724_134807_228224_9539F28F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roman Stratiienko <roman.stratiienko@globallogic.com>

Mwifiex firmware inserts only Microsoft information element
Allow other vendor specific IEs to pass from userspace

Signed-off-by: Roman Stratiienko <roman.stratiienko@globallogic.com>
---
 drivers/net/wireless/marvell/mwifiex/ie.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index b10baac..75cbd60 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -355,8 +355,14 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 		case WLAN_EID_HT_OPERATION:
 		case WLAN_EID_VHT_CAPABILITY:
 		case WLAN_EID_VHT_OPERATION:
-		case WLAN_EID_VENDOR_SPECIFIC:
 			break;
+		case WLAN_EID_VENDOR_SPECIFIC:
+			/* Skip only Microsoft WMM IE */
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
