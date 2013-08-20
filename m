Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1389 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3HTOBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:01:00 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/12] brcmsmac: reinitialize TSSI power control upon
 channel switch
Date: Tue, 20 Aug 2013 16:00:45 +0200
Message-ID: <1377007246-9957-12-git-send-email-arend@broadcom.com> (sfid-20130820_160138_838659_C4D0B22E)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing channels the TSSI based power control needs to be
reinitialized.

Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 2917f5c..8fb1048 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -5019,6 +5019,8 @@ void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 		wlc_lcnphy_load_tx_iir_filter(pi, true, 3);
 
 	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		wlc_lcnphy_tssi_setup(pi);
 }
 
 void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
-- 
1.7.10.4


