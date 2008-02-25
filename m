Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:32160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435AbYBYWYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:24:08 -0500
Received: by nf-out-0910.google.com with SMTP id g13so929403nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:24:06 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 1/6] rt2x00: Check for 5GHz band in link tuner
Date: Mon, 25 Feb 2008 23:20:33 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802252320.11809.IvDoorn@gmail.com>
In-Reply-To: <200802252320.11809.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802252320.33976.IvDoorn@gmail.com> (sfid-20080225_222412_412133_E328C125)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a typo in the link tuner where accidently the
2GHz band was checked instead of the 5GHz band.
This forced the link tuner to work in an invalid
range for the currently active band.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 70cfdad..ca83d94 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -769,7 +769,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->rx_status.band == IEEE80211_BAND_2GHZ) {
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
-- 
1.5.3.2

