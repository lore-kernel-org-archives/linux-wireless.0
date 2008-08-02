Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25764 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYHBXta (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 11/12] ath9k: Add initial link quality reporting
Date: Sat, 2 Aug 2008 16:49:03 -0700
Message-ID: <1217720944-23234-12-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014937_301961_3B7D8CDF)
In-Reply-To: <1217720944-23234-11-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-7-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-8-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-9-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-10-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-11-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index effcce9..7222a42 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -282,10 +282,11 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
 	rx_status->mactime = status->tsf;
 	rx_status->band = curchan->band;
 	rx_status->freq =  curchan->center_freq;
-	rx_status->signal = (status->rssi * 64) / 100;
 	rx_status->noise = ATH_DEFAULT_NOISE_FLOOR;
+	rx_status->signal = rx_status->noise + status->rssi;
 	rx_status->rate_idx = ath_rate2idx(sc, (status->rateKbps / 100));
 	rx_status->antenna = status->antenna;
+	rx_status->qual = status->rssi * 100 / 64;
 
 	if (status->flags & ATH_RX_MIC_ERROR)
 		rx_status->flag |= RX_FLAG_MMIC_ERROR;
@@ -1402,6 +1403,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad2;
 	}
 
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_NOISE_DBM;
+
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
-- 
1.5.6.rc2.15.g457bb.dirty

