Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13917 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaELIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:43 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 02/14] brcmfmac: Report the support of firmware roaming
Date: Mon, 12 May 2014 10:47:27 +0200
Message-ID: <1399884459-5048-3-git-send-email-arend@broadcom.com> (sfid-20140512_104815_145085_8501768E)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

Currently firmware roaming support is not reported to cfg80211.
This patch reports the support of firmware based roaming when
it is enabled.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index afb3d15..c3857c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4364,6 +4364,8 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			WIPHY_FLAG_SUPPORTS_TDLS;
+	if (!brcmf_roamoff)
+		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
-- 
1.7.9.5

