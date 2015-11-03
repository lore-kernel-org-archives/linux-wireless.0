Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42082 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbKCMmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 07:42:07 -0500
Date: Tue, 3 Nov 2015 15:41:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: robert.dolca@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: NFC: Add Intel Fields Peak NFC solution driver
Message-ID: <20151103124147.GA31752@mwanda> (sfid-20151103_134212_066898_079CC7F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Robert Dolca,

This is a semi-automatic email about new static checker warnings.

The patch a06347c04c13: "NFC: Add Intel Fields Peak NFC solution 
driver" from Oct 22, 2015, leads to the following Smatch complaint:

drivers/nfc/fdp/i2c.c:216 fdp_nci_i2c_irq_thread_fn()
	 warn: variable dereferenced before check 'phy' (see line 213)

drivers/nfc/fdp/i2c.c
   212	
   213		client = phy->i2c_dev;
                         ^^^^^
Dereference.

   214		dev_dbg(&client->dev, "%s\n", __func__);
   215	
   216		if (!phy || irq != phy->i2c_dev->irq) {
                    ^^^^
Check.

   217			WARN_ON_ONCE(1);
   218			return IRQ_NONE;

regards,
dan carpenter
