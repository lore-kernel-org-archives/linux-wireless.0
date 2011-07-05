Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56848 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1GETQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 15:16:58 -0400
Date: Tue, 5 Jul 2011 15:12:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, joe@perches.com
Subject: Re: [PATCH v5 0/6] NFC subsystem
Message-ID: <20110705191235.GB7540@tuxdriver.com> (sfid-20110705_211701_512960_5021B9A7)
References: <1309559498-600-1-git-send-email-aloisio.almeida@openbossa.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309559498-600-1-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm merging this series.  Please post any further changes as patches on top.

John

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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
