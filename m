Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54822 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2GHWbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 18:31:31 -0400
Received: by obbuo13 with SMTP id uo13so19525821obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 15:31:30 -0700 (PDT)
Message-ID: <4FFA0A3C.3040204@lwfinger.net> (sfid-20120709_003209_999967_0DC961DE)
Date: Sun, 08 Jul 2012 17:31:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Eloy Anguiano <eloy.anguiano@uam.es>
CC: b43-dev@lists.infradead.org,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43 does not work on broadcom 43227
References: <1341782825.4900.11.camel@zeus>
In-Reply-To: <1341782825.4900.11.camel@zeus>
Content-Type: multipart/mixed;
 boundary="------------000401060508090305050409"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000401060508090305050409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/08/2012 04:27 PM, Eloy Anguiano wrote:
> Dear developers,
>
> Perhaps this is not a bug because my card is not probed. I have a
> Broadcom 43227 and the wireless does not work at all. I need your driver
> to activate it as a AP, but as far as I know, is imposible at this
> moment. Then I will use Broadcom driver waiting to your next
> developments. I say you because I think that developers need some
> feedback, for free software development.

As you guessed, it is not a bug as support for that device has never been 
enabled. I think your device will use bcma just as my BCM43228 does. I have 
started developing the patches needed to implement it with b43; however, I have 
not gotten very far. Could you please confirm that the the PCI ID is 14e4:4358? 
If that is correct, could you also try the attached patch and report the info 
that is logged in the dmesg output?

I think that Broadcom will be changing brcmsmac to support these devices, but my 
understanding is that they are concentrating on fullmac devices at the moment.

Larry

--------------000401060508090305050409
Content-Type: text/plain; charset=UTF-8;
 name="bcma_enable_43227"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bcma_enable_43227"

Index: wireless-testing-new/drivers/bcma/host_pci.c
===================================================================
--- wireless-testing-new.orig/drivers/bcma/host_pci.c
+++ wireless-testing-new/drivers/bcma/host_pci.c
@@ -272,6 +272,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4738) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
 };

--------------000401060508090305050409--
