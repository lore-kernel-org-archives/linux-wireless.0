Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58744 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1GJOQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 10:16:36 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p6AEGabJ022767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 09:16:36 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep33.itg.ti.com (8.13.7/8.13.8) with ESMTP id p6AEGZj7018877
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 09:16:35 -0500 (CDT)
Received: from DNCE73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p6AEGZVh000202
	for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 09:16:35 -0500 (CDT)
From: "Elias, Ilan" <ilane@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 10 Jul 2011 16:16:32 +0200
Subject: Re: [PATCH v5 0/6] NFC subsystem
Message-ID: <AC090B9732AB2B4DB7FF476E907FE66001317B8E2A@dnce02.ent.ti.com> (sfid-20110710_161641_548008_EA792786)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aloisio,

I went over the userspace interface and it seems to me 
that it's very much following the PN533 chip interface.

As you probably know, the NFC forum is in the process of defining 
a new industry standard for the NFC Controller Interface (NCI).
All NFC chips in the near future will probably support the NCI, 
which will provide a generic and standard interface for NFC functionality.

I think that your current userspace interface might be too specific 
for PN533 chip, and might not expose all the required NFC functionality.

A similar case with Bluetooth, where HCI is the industry standard which 
is supported by most Bluetooth chips, thus BlueZ support it of course.

Doesn't it make more sense to make the userspace interface more similar to the NCI?
I think this solution will make the Linux Kernel better prepare to support the 
future NFC controllers.

Thanks & BR,
Ilan


On Fri, Jul 01, 2011 at 07:31:32PM -0300, Aloisio Almeida Jr wrote:
> This version has only debug related changes.
> 
>  1. NFC_*() macros were renamed to nfc_*(). For err and info nfc_printk() is
>     called. For dbg pr_debug() is called.
>  2. nfc_dev_*() macros were created to be used by device drivers. These macros
>     use dev_*().
>  3. The macros does not have __func__ anymore.
> 
> Aloisio Almeida Jr (3):
>   NFC: add NFC socket family
>   NFC: pn533: add NXP pn533 nfc device driver
>   NFC: add Documentation/networking/nfc.txt
> 
> Lauro Ramos Venancio (3):
>   NFC: add nfc subsystem core
>   NFC: add nfc generic netlink interface
>   NFC: add the NFC socket raw protocol
> 
>  Documentation/networking/nfc.txt |  128 +++
>  drivers/Kconfig                  |    2 -
>  drivers/Makefile                 |    1 +
>  drivers/nfc/Kconfig              |   24 +-
>  drivers/nfc/Makefile             |    3 +
>  drivers/nfc/pn533.c              | 1632 ++++++++++++++++++++++++++++++++++++++
>  include/linux/nfc.h              |  126 +++
>  include/linux/socket.h           |    4 +-
>  include/net/nfc.h                |  156 ++++
>  net/Kconfig                      |    1 +
>  net/Makefile                     |    1 +
>  net/core/sock.c                  |    6 +-
>  net/nfc/Kconfig                  |   16 +
>  net/nfc/Makefile                 |    7 +
>  net/nfc/af_nfc.c                 |   98 +++
>  net/nfc/core.c                   |  468 +++++++++++
>  net/nfc/netlink.c                |  537 +++++++++++++
>  net/nfc/nfc.h                    |  117 +++
>  net/nfc/rawsock.c                |  354 +++++++++
>  19 files changed, 3663 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/networking/nfc.txt
>  create mode 100644 drivers/nfc/pn533.c
>  create mode 100644 include/linux/nfc.h
>  create mode 100644 include/net/nfc.h
>  create mode 100644 net/nfc/Kconfig
>  create mode 100644 net/nfc/Makefile
>  create mode 100644 net/nfc/af_nfc.c
>  create mode 100644 net/nfc/core.c
>  create mode 100644 net/nfc/netlink.c
>  create mode 100644 net/nfc/nfc.h
>  create mode 100644 net/nfc/rawsock.c
> 
> -- 
> 1.7.5.4
