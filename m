Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab0FKSjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 14:39:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Cc: wilson.tsao@atheros.com, mian.tuo@atheros.com,
	akira.iida@atheros.com, jinyong.ren@atheros.com,
	david.quan@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT] ath5k: add new PCI devices
Date: Fri, 11 Jun 2010 14:39:23 -0400
Message-Id: <1276281563-18429-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found our PCI device list not up to date with respect
to the PCI device ID db for 0x168c for legacy (non-802.11)
devices:

https://pci-ids.ucw.cz/read/PC/168c/

There a few bogus ones there but I believe these are also
listed on our NDIS driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

[RFT] request to test, if any ath5k users have these devices.

Note: this e-mail is sent on a public mailing list. It is
      appreciated if you do reply to all and keep the
      public mailing list CC'd.

I just saw a patch to add 0xff19 internally but also spotted
the other ones on the PCI device ID db. Folks CC'd do you know if
these other are indeed ath5k device? Can you also confirm if
indeed 0xff19 is an AR5424 device?

  Luis

 drivers/net/wireless/ath/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9d37c1a..cd44e02 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -103,6 +103,9 @@ static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
+	{ PCI_VDEVICE(ATHEROS, 0xff19) }, /* 5424 */
+	{ PCI_VDEVICE(ATHEROS, 0xff1c) },
+	{ PCI_VDEVICE(ATHEROS, 0xff1d) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
-- 
1.6.3.3

