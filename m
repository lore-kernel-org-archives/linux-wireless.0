Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:13519 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0AGNIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 08:08:09 -0500
Received: by fg-out-1718.google.com with SMTP id 19so7480838fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 05:08:06 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 07 Jan 2010 14:09:27 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	=?utf-8?Q?Stefanik_G=C3=A1bor?= <netrolller.3d@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: LP-PHY: note and explain specs inconsistency
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u55yt0dz9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_lp.c |    7 +++++++
  1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 1e318d8..eae15a1 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -79,6 +79,7 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
  	dev->phy.lp = NULL;
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/LP/ReadBandSrom */
  static void lpphy_read_band_sprom(struct b43_wldev *dev)
  {
  	struct b43_phy_lp *lpphy = dev->phy.lp;
@@ -100,6 +101,12 @@ static void lpphy_read_band_sprom(struct b43_wldev *dev)
  		maxpwr = bus->sprom.maxpwr_bg;
  		lpphy->max_tx_pwr_med_band = maxpwr;
  		cckpo = bus->sprom.cck2gpo;
+		/*
+		 * We don't read SPROM's opo as specs say. On rev8 SPROMs
+		 * opo == ofdm2gpo and we don't know any SSB with LP-PHY
+		 * and SPROM rev below 8.
+		 */
+		B43_WARN_ON(bus->sprom.revision < 8);
  		ofdmpo = bus->sprom.ofdm2gpo;
  		if (cckpo) {
  			for (i = 0; i < 4; i++) {
-- 
1.6.4.2

