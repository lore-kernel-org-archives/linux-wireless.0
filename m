Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50771 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeBWNg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 08:36:26 -0500
From: Colin King <colin.king@canonical.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: remove duplicated bit-wise or of IEEE80211_CHAN_NO_IR
Date: Fri, 23 Feb 2018 13:36:22 +0000
Message-Id: <20180223133622.25700-1-colin.king@canonical.com> (sfid-20180223_143650_238006_0F8D9B71)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Bit pattern IEEE80211_CHAN_NO_IR is being bit-wise or'd twice;
remove the redundant 2nd IEEE80211_CHAN_NO_IR

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index 3a03287fa912..db783e94f929 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -652,7 +652,6 @@ static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
 		 */
 		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
 			ch->flags |= IEEE80211_CHAN_RADAR |
-				     IEEE80211_CHAN_NO_IR |
 				     IEEE80211_CHAN_NO_IR;
 	}
 }
-- 
2.15.1
