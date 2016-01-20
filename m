Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35860 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcATNGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 08:06:41 -0500
Received: by mail-lb0-f172.google.com with SMTP id oh2so4677747lbb.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 05:06:40 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: advertise frames supported for TX in AP mode
Date: Wed, 20 Jan 2016 14:06:30 +0100
Message-Id: <1453295190-28404-1-git-send-email-zajec5@gmail.com> (sfid-20160120_140644_772327_6E4028AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Callback mgmt_tx implementation supports both: PROBE_RESP and ACTION.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This matches code I can see in brcmf_cfg80211_mgmt_tx, hope it makes
sense.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ab431e5..8d9cff4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5948,6 +5948,10 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
 	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_RESP >> 4)
+	},
 	[NL80211_IFTYPE_P2P_CLIENT] = {
 		.tx = 0xffff,
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-- 
1.8.4.5

