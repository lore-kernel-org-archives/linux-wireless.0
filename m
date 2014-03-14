Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaCNTCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:02:51 -0400
Message-ID: <1394823891.5829.14.camel@dcbw.local> (sfid-20140314_200255_009146_624F8CCC)
Subject: Re: [PATCH v4 00/11] rsi: Adding RS9113 wireless driver.
From: Dan Williams <dcbw@redhat.com>
To: fariyaf@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Mar 2014 14:04:51 -0500
In-Reply-To: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
References: <1394465199-10042-1-git-send-email-fariyaf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-10 at 20:56 +0530, fariyaf@gmail.com wrote:
> From: Fariya Fatima <fariyaf@gmail.com>
> 
> This series of patches adds Redpine Signals wireless driver.

Looking much better, good work.

One last comment; there are a couple functions (rsi_device_init,
rsi_host_intf_write_pkt) that are defined multiple times, once in the
USB code and once in the SDIO code.  These need to be renamed, otherwise
you will not be able to load the USB and the SDIO modules at the same
time.

I would suggest making all the functions in rsi_usb.h start with
"rsi_usb" if they don't already, and have functions in rsi_sdio.h start
with "rsi_sdio" if they don't already.

Dan

> Fariya Fatima (11):
>   Adding RS9113 driver header files
>   Adding remaining header files
>   Adding core and main files.
>   Writing packets to device and debugfs.
>   MAC80211 callbacks to driver.
>   MAC80211 callbacks and management functions internal to device.
>   Management functions internal to the device.
>   USB functionality
>   SDIO functionality.
>   Remaining SDIO functionality.
>   Makefile and Kconfig
> 
>  drivers/net/wireless/Kconfig                |    1 +
>  drivers/net/wireless/Makefile               |    1 +
>  drivers/net/wireless/rsi/Kconfig            |   30 +
>  drivers/net/wireless/rsi/Makefile           |   12 +
>  drivers/net/wireless/rsi/rsi_91x_core.c     |  342 +++++++
>  drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  339 +++++++
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 1008 +++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_main.c     |  270 ++++++
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 1302 +++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_pkt.c      |  195 ++++
>  drivers/net/wireless/rsi/rsi_91x_sdio.c     |  845 +++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  566 ++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_usb.c      |  572 ++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  177 ++++
>  drivers/net/wireless/rsi/rsi_boot_params.h  |  126 +++
>  drivers/net/wireless/rsi/rsi_common.h       |   87 ++
>  drivers/net/wireless/rsi/rsi_debugfs.h      |   48 +
>  drivers/net/wireless/rsi/rsi_main.h         |  232 +++++
>  drivers/net/wireless/rsi/rsi_mgmt.h         |  285 ++++++
>  drivers/net/wireless/rsi/rsi_sdio.h         |  129 +++
>  drivers/net/wireless/rsi/rsi_usb.h          |   70 ++
>  21 files changed, 6637 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/wireless/rsi/Kconfig
>  create mode 100644 drivers/net/wireless/rsi/Makefile
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_core.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_debugfs.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_mac80211.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_main.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_mgmt.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_usb_ops.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_boot_params.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_common.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_debugfs.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_main.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_mgmt.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_sdio.h
>  create mode 100644 drivers/net/wireless/rsi/rsi_usb.h
> 


