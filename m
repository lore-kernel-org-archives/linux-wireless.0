Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbeCLKAd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 06:00:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [v9 0/8] rsi: add bluetooth and coex support
References: <1519741578-12640-1-git-send-email-amitkarwar@gmail.com>
Date: Mon, 12 Mar 2018 12:00:28 +0200
In-Reply-To: <1519741578-12640-1-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Tue, 27 Feb 2018 19:56:10 +0530")
Message-ID: <87a7vd396r.fsf@purkki.adurom.net> (sfid-20180312_110036_896539_3B936E54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> This patch series adds new bluetooth driver and coex enhancments
> in existing wlan driver for RSI chipsets.
> As per our architecture, both wlan and bluetooth drivers talk
> over same SDIO interface to device. Separate endpoint will be
> used in case of USB interface.
>
> Change in v9: "#ifdef CONFIG_RSI_COEX" check moved from 6/8 to 4/6
>               to resolve kbuild test robot reported error
> Change in v8: 4/8, 5/8 are modified
> Change in v7: 4/8 is modified
> Changes in v6: 1/8, 3/8, 4/8, 5/8, 6/8 are modified
> Changes in v5: 5/8 is modified
> Changes in v4: 5/8 is modified
> Changes in v3: 4/8, 5/8 and 6/8 patches are modified
> Changes in v2: 2/8, 5/8 and 6/8 patches are modified
>
> Prameela Rani Garnepudi (6):
>   rsi: add rx control block to handle rx packets in USB
>   rsi: add header file rsi_91x
>   rsi: add coex support
>   Bluetooth: btrsi: add new rsi bluetooth driver
>   rsi: add module parameter operating mode
>   rsi: sdio changes to support BT
>
> Siva Rebbagondla (2):
>   rsi: add bluetooth rx endpoint
>   rsi: handle BT traffic in driver
>
>  drivers/bluetooth/Kconfig                   |  12 ++
>  drivers/bluetooth/Makefile                  |   2 +
>  drivers/bluetooth/btrsi.c                   | 188 ++++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/Kconfig            |   9 ++
>  drivers/net/wireless/rsi/Makefile           |   1 +
>  drivers/net/wireless/rsi/rsi_91x_coex.c     | 179 ++++++++++++++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_core.c     |  20 ++-
>  drivers/net/wireless/rsi/rsi_91x_hal.c      |  56 +++++++--
>  drivers/net/wireless/rsi/rsi_91x_main.c     | 129 ++++++++++++++++++-
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   2 +-
>  drivers/net/wireless/rsi/rsi_91x_sdio.c     |  13 +-
>  drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |   5 +-
>  drivers/net/wireless/rsi/rsi_91x_usb.c      | 124 +++++++++++++-----
>  drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  35 ++++--
>  drivers/net/wireless/rsi/rsi_coex.h         |  37 ++++++
>  drivers/net/wireless/rsi/rsi_common.h       |   5 +-
>  drivers/net/wireless/rsi/rsi_hal.h          |  21 ++++
>  drivers/net/wireless/rsi/rsi_main.h         |  21 ++--
>  drivers/net/wireless/rsi/rsi_mgmt.h         |   3 +
>  drivers/net/wireless/rsi/rsi_usb.h          |  16 ++-
>  include/net/rsi_91x.h                       |  56 +++++++++
>  21 files changed, 852 insertions(+), 82 deletions(-)
>  create mode 100644 drivers/bluetooth/btrsi.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
>  create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
>  create mode 100644 include/net/rsi_91x.h

Just a heads up to everyone that I applied this to pending branch in
w-d-next and if everything goes ok with kbuild bot I'll apply this to
the master branch soon.

-- 
Kalle Valo
