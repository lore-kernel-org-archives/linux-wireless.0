Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:35555 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbcETLj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 07:39:56 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2 4.8 2/2] brcmfmac: support get_channel cfg80211 callback
Date: Fri, 20 May 2016 13:38:58 +0200
Message-Id: <1463744355-5528-2-git-send-email-zajec5@gmail.com> (sfid-20160520_134024_376322_54B7317A)
In-Reply-To: <1463744355-5528-1-git-send-email-zajec5@gmail.com>
References: <1463655770-22467-1-git-send-email-zajec5@gmail.com>
 <1463744355-5528-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is important for brcmfmac as some of released firmwares (e.g.
brcmfmac4366b-pcie.bin) may pick different channel than requested. This
has been tested with BCM4366B1 in D-Link DIR-885L.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Check if ndev isn't NULL, update description.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 63 ++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 597495d..299a404 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4892,6 +4892,68 @@ exit:
 	return err;
 }
 
+static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
+				      struct wireless_dev *wdev,
+				      struct cfg80211_chan_def *chandef)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = wdev->netdev;
+	struct brcmf_if *ifp;
+	struct brcmu_chan ch;
+	enum nl80211_band band = 0;
+	enum nl80211_chan_width width = 0;
+	u32 chanspec;
+	int freq, err;
+
+	if (!ndev)
+		return -ENODEV;
+	ifp = netdev_priv(ndev);
+
+	err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
+	if (err) {
+		brcmf_err("chanspec failed (%d)\n", err);
+		return err;
+	}
+
+	ch.chspec = chanspec;
+	cfg->d11inf.decchspec(&ch);
+
+	switch (ch.band) {
+	case BRCMU_CHAN_BAND_2G:
+		band = NL80211_BAND_2GHZ;
+		break;
+	case BRCMU_CHAN_BAND_5G:
+		band = NL80211_BAND_5GHZ;
+		break;
+	}
+
+	switch (ch.bw) {
+	case BRCMU_CHAN_BW_80:
+		width = NL80211_CHAN_WIDTH_80;
+		break;
+	case BRCMU_CHAN_BW_40:
+		width = NL80211_CHAN_WIDTH_40;
+		break;
+	case BRCMU_CHAN_BW_20:
+		width = NL80211_CHAN_WIDTH_20;
+		break;
+	case BRCMU_CHAN_BW_80P80:
+		width = NL80211_CHAN_WIDTH_80P80;
+		break;
+	case BRCMU_CHAN_BW_160:
+		width = NL80211_CHAN_WIDTH_160;
+		break;
+	}
+
+	freq = ieee80211_channel_to_frequency(ch.control_ch_num, band);
+	chandef->chan = ieee80211_get_channel(wiphy, freq);
+	chandef->width = width;
+	chandef->center_freq1 = ieee80211_channel_to_frequency(ch.chnum, band);
+	chandef->center_freq2 = 0;
+
+	return 0;
+}
+
 static int brcmf_cfg80211_crit_proto_start(struct wiphy *wiphy,
 					   struct wireless_dev *wdev,
 					   enum nl80211_crit_proto_id proto,
@@ -5054,6 +5116,7 @@ static struct cfg80211_ops brcmf_cfg80211_ops = {
 	.mgmt_tx = brcmf_cfg80211_mgmt_tx,
 	.remain_on_channel = brcmf_p2p_remain_on_channel,
 	.cancel_remain_on_channel = brcmf_cfg80211_cancel_remain_on_channel,
+	.get_channel = brcmf_cfg80211_get_channel,
 	.start_p2p_device = brcmf_p2p_start_device,
 	.stop_p2p_device = brcmf_p2p_stop_device,
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
-- 
1.8.4.5

