Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26251 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaELIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:43 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/14] brcmfmac: remove usage of cfg80211_get_chandef_type()
Date: Mon, 12 May 2014 10:47:33 +0200
Message-ID: <1399884459-5048-9-git-send-email-arend@broadcom.com> (sfid-20140512_104751_585468_35D980C3)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the .start_ap callback cfg80211_get_chandef_type() was used to
provide debug log info. However, this causes a warning when the
chandef contains VHT channel with 80MHz bandwidth. Avoid the warning
by just printing the channel and bandwidth instead.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 401529c..5f89a42 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3766,10 +3766,9 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	enum nl80211_iftype dev_role;
 	struct brcmf_fil_bss_enable_le bss_enable;
 
-	brcmf_dbg(TRACE, "channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
-		  cfg80211_get_chandef_type(&settings->chandef),
-		  settings->beacon_interval,
-		  settings->dtim_period);
+	brcmf_dbg(TRACE, "channel=%d, bw=%d, beacon_interval=%d, dtim_period=%d,\n",
+		  settings->chandef.chan->hw_value, settings->chandef.width,
+		  settings->beacon_interval, settings->dtim_period);
 	brcmf_dbg(TRACE, "ssid=%s(%zu), auth_type=%d, inactivity_timeout=%d\n",
 		  settings->ssid, settings->ssid_len, settings->auth_type,
 		  settings->inactivity_timeout);
-- 
1.7.9.5

