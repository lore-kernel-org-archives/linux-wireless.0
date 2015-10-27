Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:35301 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950AbbJ0TD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 15:03:58 -0400
From: Punit Vara <punitvara@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Punit Vara <punitvara@gmail.com>
Subject: [RESEND PATCH 04/10] net: wireless: brcm80211: Remove duplicated arguments to |
Date: Wed, 28 Oct 2015 00:32:39 +0530
Message-Id: <1445972565-14963-4-git-send-email-punitvara@gmail.com> (sfid-20151027_200653_198589_DE22A439)
In-Reply-To: <1445972565-14963-1-git-send-email-punitvara@gmail.com>
References: <1445972565-14963-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove uncessary repeated arguments with OR(|)

This is patch to the brcmsmac/channel.c file that removes following
 warning reported by coccicheck:

-duplicated argument to & or |

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 635ae03..d56fa03 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -652,7 +652,6 @@ static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
 		 */
 		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
 			ch->flags |= IEEE80211_CHAN_RADAR |
-				     IEEE80211_CHAN_NO_IR |
 				     IEEE80211_CHAN_NO_IR;
 	}
 }
-- 
2.5.3

