Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:58448 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbaIKUvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:51:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 1/3] brcmfmac: Fix memory leak and missing assignment.
Date: Thu, 11 Sep 2014 22:51:30 +0200
Message-ID: <1410468692-20852-2-git-send-email-arend@broadcom.com> (sfid-20140911_225147_044867_E45E6CD1)
In-Reply-To: <1410468692-20852-1-git-send-email-arend@broadcom.com>
References: <1410468692-20852-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The function brcmf_enable_bw40_2g contains a memory leak. The
function is also missing initialisation of one of the members of
ch struct, which can lead to warning but this has no impact on
result.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 02fe706..2e134a6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5143,6 +5143,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 
 		ch.band = BRCMU_CHAN_BAND_2G;
 		ch.bw = BRCMU_CHAN_BW_40;
+		ch.sb = BRCMU_CHAN_SB_NONE;
 		ch.chnum = 0;
 		cfg->d11inf.encchspec(&ch);
 
@@ -5176,6 +5177,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 
 			brcmf_update_bw40_channel_flag(&band->channels[j], &ch);
 		}
+		kfree(pbuf);
 	}
 	return err;
 }
-- 
1.9.1

