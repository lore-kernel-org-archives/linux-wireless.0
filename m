Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZKMKs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 05:48:57 -0500
From: Bernhard Schiffner <bernhard@schiffner-limbach.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT 2/6 V2] rtl8187se: Create file rtl8187se_dev.c
Date: Fri, 13 Nov 2009 11:49:10 +0100
Cc: John W Linville <linville@tuxdriver.com>, bzolnier@gmail.com,
	linux-wireless@vger.kernel.org
References: <4afb8fa1.nfiZuHNJ466dvkyn%Larry.Finger@lwfinger.net>
In-Reply-To: <4afb8fa1.nfiZuHNJ466dvkyn%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911131149.11080.bernhard@schiffner-limbach.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 05:31:29 Larry Finger wrote:
> Create the main device file for rtl8187se.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

This little typo prevents module from loading.
(compare with staging/rtl8187se, given by lspci too.)

Bernhard


bs7:/usr/src/kernel_rtl8187se# git diff
diff --git a/drivers/net/wireless/rtl818x/rtl8187se_dev.c 
b/drivers/net/wireless/rtl818x/rtl8187se_dev.c
index f998ff9..1f479de 100644
--- a/drivers/net/wireless/rtl818x/rtl8187se_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187se_dev.c
@@ -29,7 +29,7 @@ MODULE_DESCRIPTION("RTL8187SE PCI wireless driver");
 MODULE_LICENSE("GPL");

 static struct pci_device_id rtl8187se_table[] __devinitdata = {
-       { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8189) },
+       { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8199) },
        { }
 };
