Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752251Ab0CKGsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 01:48:17 -0500
From: Malte Gell <malte.gell@gmx.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
Date: Thu, 11 Mar 2010 07:48:12 +0100
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <201003040835.29387.malte.gell@gmx.de> <1268199428.17677.9.camel@mj> <43e72e891003092352w433c018t3ed05d3279abf67e@mail.gmail.com>
In-Reply-To: <43e72e891003092352w433c018t3ed05d3279abf67e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sIJmLH+WniOqjEj"
Message-Id: <201003110748.12919.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_sIJmLH+WniOqjEj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit


"Luis R. Rodriguez" <mcgrof@gmail.com> wrote
 
> To debug firmware loading you can run
> udevadm monitor
> And read all the stuff there when you try to load the driver.

Thanks for this hint. I tried this now and the attached file ar9170.log 
contains the output.

Regards
Malte

--Boundary-00=_sIJmLH+WniOqjEj
Content-Type: text/x-log;
  charset="UTF-8";
  name="ar9170.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ar9170.log"

monitor will print the received events for:
UDEV the event which udev sends out after rule processing
UEVENT the kernel uevent

UEVENT[1268289459.747930] add      /module/ar9170usb (module)
UDEV  [1268289459.749855] add      /module/ar9170usb (module)
UEVENT[1268289460.986796] add      /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UEVENT[1268289520.986840] remove   /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UEVENT[1268289520.986910] add      /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UEVENT[1268289580.987043] remove   /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UEVENT[1268289580.987122] add      /bus/usb/drivers/ar9170usb (drivers)
UDEV  [1268289580.993885] remove   /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UDEV  [1268289581.000114] add      /bus/usb/drivers/ar9170usb (drivers)
UDEV  [1268289581.001316] remove   /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UDEV  [1268289581.025732] add      /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)
UDEV  [1268289581.029545] add      /devices/pci0000:00/0000:00:13.2/usb1/1-3/firmware/1-3 (firmware)

--Boundary-00=_sIJmLH+WniOqjEj--
