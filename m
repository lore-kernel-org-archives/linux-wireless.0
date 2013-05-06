Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:60864 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3EFW3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 18:29:10 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] rt2x00pci: Use PCI MSIs whenever possible
Date: Tue,  7 May 2013 00:28:50 +0200
Message-Id: <1367879330-5718-1-git-send-email-kubakici@wp.pl> (sfid-20130507_002916_422034_6EC728F9)
In-Reply-To: <1349292758-20045-1-git-send-email-kubakici@wp.pl>
References: <1349292758-20045-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All PCIe devices must support MSIs, make use of them.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index dc49e52..76d95de 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -105,11 +105,13 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 		goto exit_release_regions;
 	}

+	pci_enable_msi(pci_dev);
+
 	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
 	if (!hw) {
 		rt2x00_probe_err("Failed to allocate hardware\n");
 		retval = -ENOMEM;
-		goto exit_release_regions;
+		goto exit_disable_msi;
 	}

 	pci_set_drvdata(pci_dev, hw);
@@ -150,6 +152,9 @@ exit_free_reg:
 exit_free_device:
 	ieee80211_free_hw(hw);

+exit_disable_msi:
+	pci_disable_msi(pci_dev);
+
 exit_release_regions:
 	pci_release_regions(pci_dev);

@@ -174,6 +179,8 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	rt2x00pci_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);

+	pci_disable_msi(pci_dev);
+
 	/*
 	 * Free the PCI device data.
 	 */
--
1.8.1.4
