Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3IWJLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 05:11:35 -0400
Date: Mon, 23 Sep 2013 04:08:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Jakub Kicinski <kubakici@wp.pl>,
	moorray@wp.pl
Subject: [PATCH 3.12] Revert "rt2x00pci: Use PCI MSIs whenever possible"
Message-ID: <20130923020812.GA1577@redhat.com> (sfid-20130923_111139_192427_B50D8368)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 9483f40d8d01918b399b4e24d0c1111db0afffeb.

Some devices stop to connect with above commit, see:
https://bugzilla.kernel.org/show_bug.cgi?id=61621

Since there is no clear benefit of having MSI enabled, just revert
change to fix the problem.

Cc: stable@vger.kernel.org # 3.11+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 76d95de..dc49e52 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -105,13 +105,11 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
 		goto exit_release_regions;
 	}
 
-	pci_enable_msi(pci_dev);
-
 	hw = ieee80211_alloc_hw(sizeof(struct rt2x00_dev), ops->hw);
 	if (!hw) {
 		rt2x00_probe_err("Failed to allocate hardware\n");
 		retval = -ENOMEM;
-		goto exit_disable_msi;
+		goto exit_release_regions;
 	}
 
 	pci_set_drvdata(pci_dev, hw);
@@ -152,9 +150,6 @@ exit_free_reg:
 exit_free_device:
 	ieee80211_free_hw(hw);
 
-exit_disable_msi:
-	pci_disable_msi(pci_dev);
-
 exit_release_regions:
 	pci_release_regions(pci_dev);
 
@@ -179,8 +174,6 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	rt2x00pci_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
-	pci_disable_msi(pci_dev);
-
 	/*
 	 * Free the PCI device data.
 	 */
-- 
1.8.3.1

