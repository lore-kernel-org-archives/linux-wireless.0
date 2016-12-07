Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:16852 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbcLGNG3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 08:06:29 -0500
Date: Wed, 7 Dec 2016 14:21:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Michael Wu <flamingice@sourmilk.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] adm80211: return an error if adm8211_alloc_rings() fails
Message-ID: <20161207112122.GA5686@elgon.mountain> (sfid-20161207_140632_720921_41C40120)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We accidentally return success when adm8211_alloc_rings() fails but we
should preserve the error code.

Fixes: cc0b88cf5ecf ("[PATCH] Add adm8211 802.11b wireless driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 2b4a3eb38dfa..098c814e22c8 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1863,7 +1863,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 	priv->rx_ring_size = rx_ring_size;
 	priv->tx_ring_size = tx_ring_size;
 
-	if (adm8211_alloc_rings(dev)) {
+	err = adm8211_alloc_rings(dev);
+	if (err) {
 		printk(KERN_ERR "%s (adm8211): Cannot allocate TX/RX ring\n",
 		       pci_name(pdev));
 		goto err_iounmap;
