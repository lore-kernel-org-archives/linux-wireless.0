Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758585Ab0ECWIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 18:08:47 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
Date: Tue, 4 May 2010 00:08:34 +0200
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com> <1272919385-18004-3-git-send-email-gwingerde@gmail.com> <1272920358.4907.3.camel@mj>
In-Reply-To: <1272920358.4907.3.camel@mj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005040008.36956.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Monday 03 May 2010, Pavel Roskin wrote:
> On Mon, 2010-05-03 at 22:43 +0200, Gertjan van Wingerde wrote:
> > Now that RT30xx support is at the same level as RT28xx support we can enable
> > these devices by default.
[...]
> > --- a/drivers/net/wireless/rt2x00/Kconfig
> > +++ b/drivers/net/wireless/rt2x00/Kconfig
> > @@ -87,7 +87,7 @@ if RT2800PCI
> >  
> >  config RT2800PCI_RT30XX
> >  	bool "rt2800pci - Include support for rt30xx (PCI/PCIe/PCMCIA) devices"
> > -	default n
> > +	default y
> 
> I believe defaulting booleans to "y" is discouraged, especially for
> drivers.  Most users don't have any particular hardware device.

[disclaimer, I have no access to any rt30xx USB/ PCI devices, so I'm not 
proposing the attached patch, as I can't evaluate the stability of 
rt2800pci's rt30xx support myself but merely use it for demonstration 
purposes]

RT2800PCI_RT30XX is not a new/ separate module, its only function is to 
limit the PCI ID space (to not claim PCI IDs for chipset generations not
yet debugged properly) of rt2800pci.ko; this symbol isn't even used 
anywhere else than within the PCI table. A 100% equivalent patch would be 
to just drop the config option completely. I doubt that doing that would 
meet resistance, as it merely adds previously 'unknown' (to be supported) 
PCI IDs.

[However if RT2800PCI_RT30XX is going to be kept, but changed to default 
to 'y', I'd propose to drop the 'Support for these devices is 
non-functional at the moment and is intended for testers and developers" 
paragraph at the same time.]

Regards
	Stefan Lippers-Hollmann


rt2x00: claim RT30xx PCI IDs in rt2800pci

Now that RT30xx support is at the same level as RT28xx, it can be enabled 
unconditionally.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 5239e08..ee088ac 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -85,17 +85,6 @@ config RT2800PCI
 
 if RT2800PCI
 
-config RT2800PCI_RT30XX
-	bool "rt2800pci - Include support for rt30xx (PCI/PCIe/PCMCIA) devices"
-	default n
-	---help---
-	  This adds support for rt30xx wireless chipset family to the
-	  rt2800pci driver.
-	  Supported chips: RT3090, RT3091 & RT3092
-
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800PCI_RT35XX
 	bool "rt2800pci - Include support for rt35xx (PCI/PCIe/PCMCIA) devices"
 	default n
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0e52f17..9efd4fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1225,12 +1225,10 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1432, 0x7758), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7768), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1a3b, 0x1059), PCI_DEVICE_DATA(&rt2800pci_ops) },
-#ifdef CONFIG_RT2800PCI_RT30XX
 	{ PCI_DEVICE(0x1814, 0x3090), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3091), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3092), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1462, 0x891a), PCI_DEVICE_DATA(&rt2800pci_ops) },
-#endif
 #ifdef CONFIG_RT2800PCI_RT35XX
 	{ PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
