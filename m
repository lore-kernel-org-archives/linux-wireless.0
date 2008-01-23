Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s39.bay0.hotmail.com ([65.54.246.239]:29608 "EHLO
	bay0-omc3-s39.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbYAWQid convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 11:38:33 -0500
Message-ID: <BAY129-W14C8943AE66B2644546B0CCB3F0@phx.gbl> (sfid-20080123_163838_673077_BED467DD)
From: Adrian Bassett <adrian.bassett@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: 
Date: Wed, 23 Jan 2008 16:38:33 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[Non-subscriber submission]

Hi,

I have been using the rtl8180 driver via the git kernel route for a while now and would like to suggest that the following local ammendment is included in the development tree in order to support the PCI device 1799:700f.

This device is found on the 'Belkin Wireless G Desktop Card' product, model 'F5D7000uk'.  From memory, the chip on the card is inscribed RTL8185L;  (I don't know the significance of the 'L', I'm afraid).

commit 1c15edc0ab13c2bbfaa6164f856a39a5cf1b14a2
Author: Adrian Bassett 
Date:   Wed Jan 23 14:31:47 2008 +0000

    rtl8180_dev.c:  add support for 1799:700f
    
    Signed-off-by: root 

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 07f37b0..27ebd68 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -36,6 +36,7 @@ MODULE_LICENSE("GPL");
 static struct pci_device_id rtl8180_table[] __devinitdata = {
        /* rtl8185 */
        { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
+       { PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x700f) },
        { PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x701f) },
 
        /* rtl8180 */

Thanks,

Adrian Bassett
_________________________________________________________________
Get Hotmail on your mobile, text MSN to 63463!
http://mobile.uk.msn.com/pc/mail.aspx