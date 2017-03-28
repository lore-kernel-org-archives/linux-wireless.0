Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41339 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754572AbdC1Knw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:43:52 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: add support to move wiphy instance into network namespace
Date: Tue, 28 Mar 2017 11:43:26 +0100
Message-Id: <1490697808-5538-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_124743_622304_36AF78FA)
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support network namespace the driver must assure all created
network interfaces are in the same namespace as the wiphy instance
and flag the support using WIPHY_FLAG_NETNS_OK.

Verified using two terminals:

 Terminal 1			Terminal 2
 --------------------------	---------------------------------
 # ip netns add brcm-wifi	# iw dev
				phy#0
					Interface wlan3
						ifindex 11
						wdev 0x1
 # ip netns exec brcm-wifi bash
 # iw dev
 # echo $$
 20337			# iw phy0 set netns 20337
 # iw dev
 phy#0
	Interface wlan3
		ifindex 11
		wdev 0x2
 # iw phy0 interface add wl3.ap type __ap
 # iw dev
 phy#0
	Interface wl3.ap
		ifindex 2
		wdev 0x3
	Interface wlan3
		ifindex 11
		wdev 0x2
				# iw dev
 # iw phy0 set netns 1
 # iw dev
				# iw dev
				phy#0
					Interface wl3.ap
						ifindex 2
						wdev 0x5
					Interface wlan3
						ifindex 11
						wdev 0x4

Note:
	increasing wdev identifier above indicates issue in
	cfg80211 which is addressed separately.

Tested-by: Mark Asselstine <mark.asselstine@windriver.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Change-Id: I533ad998aec13b42b2605d8eae19a9c8fa540ffb
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8161
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 4e1ca69..89ac124 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6453,7 +6453,8 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 				    BIT(NL80211_BSS_SELECT_ATTR_BAND_PREF) |
 				    BIT(NL80211_BSS_SELECT_ATTR_RSSI_ADJUST);
 
-	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
+	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
+			WIPHY_FLAG_PS_ON_BY_DEFAULT |
 			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ba4da48..a5ffdfe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -475,8 +475,9 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	ndev->needed_headroom += drvr->hdrlen;
 	ndev->ethtool_ops = &brcmf_ethtool_ops;
 
-	/* set the mac address */
+	/* set the mac address & netns */
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
+	dev_net_set(ndev, wiphy_net(cfg_to_wiphy(drvr->config)));
 
 	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 	INIT_WORK(&ifp->ndoffload_work, _brcmf_update_ndtable);
-- 
1.9.1
