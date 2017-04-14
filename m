Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mic92-4-82-224-21-170.fbx.proxad.net ([82.224.21.170]:44778
        "EHLO dtbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751470AbdDNJxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:53:46 -0400
Date: Fri, 14 Apr 2017 11:53:42 +0200
From: Damien =?UTF-8?B?VGjDqWJhdWx0?= <damien@dtbo.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Add Dell Wireless 1601 with wowlan capability
Message-ID: <20170414115333.64abcba2@anakin> (sfid-20170414_115351_113261_29984896)
In-Reply-To: <20170406135110.3f4d1f92@anakin>
References: <20170406135110.3f4d1f92@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Sorry about this, but when I first sent this patch it didn't reach the
maintainers in Cc because of spam filters. My MX IP is now in spamhaus
PBL whitelist so this should work this time.


Add the Dell Wireless 1601 card as an AR9462 in the ath9k pci list.
Note that the wowlan feature is supported and has been tested
successfully.

Signed-off-by: Damien Th=C3=A9bault <damien@dtbo.net>
---
 drivers/net/wireless/ath/ath9k/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/at=
h/ath9k/pci.c
index aff473dfa10d..7b7627f85d3a 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -383,6 +383,11 @@ static const struct pci_device_id ath_pci_id_table[] =
=3D {
 			 0x10CF, /* Fujitsu */
 			 0x1783),
 	  .driver_data =3D ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_DELL,
+			 0x020B),
+	  .driver_data =3D ATH9K_PCI_WOW },
=20
 	/* Killer Wireless (2x2) */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
--=20
2.12.2
