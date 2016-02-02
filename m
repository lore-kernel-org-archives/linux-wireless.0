Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41890 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbcBBKAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 05:00:45 -0500
Date: Tue, 2 Feb 2016 13:00:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: huxm@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: enable pcie MSIx interrupt mode support
Message-ID: <20160202100034.GB3040@mwanda> (sfid-20160202_110049_967951_95AEC76C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Xinming Hu,

This is a semi-automatic email about new static checker warnings.

The patch 99074fc1e67b: "mwifiex: enable pcie MSIx interrupt mode 
support" from Jan 11, 2016, leads to the following Smatch complaint:

drivers/net/wireless/marvell/mwifiex/pcie.c:2780 mwifiex_unregister_dev()
	 warn: variable dereferenced before check 'card' (see line 2777)

drivers/net/wireless/marvell/mwifiex/pcie.c
  2776		const struct mwifiex_pcie_card_reg *reg;
  2777		struct pci_dev *pdev = card->dev;
                                       ^^^^^^^^^
New dereference.

  2778		int i;
  2779	
  2780		if (card) {
                    ^^^^
Old check.

  2781			if (card->msix_enable) {
  2782				for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)

regards,
dan carpenter
