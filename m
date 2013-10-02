Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:44739 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3JBFco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 01:32:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v6 4/4] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1380655155-10007-5-git-send-email-bzhao@marvell.com>
Date: Wed, 2 Oct 2013 07:32:27 +0200
Cc: <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <53A79334-AC60-4B9A-BD94-CD5EE3F7746C@holtmann.org> (sfid-20131002_073248_993397_04C55E6C)
References: <1380655155-10007-1-git-send-email-bzhao@marvell.com> <1380655155-10007-5-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> A text file containing calibration data in hex format can
> be provided at following path:
> 
> /lib/firmware/mrvl/sd8797_caldata.conf
> 
> The data will be downloaded to firmware during initialization.
> 
> Reviewed-by: Mike Frysinger <vapier@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Hyuckjoo Lee <hyuckjoo.lee@samsung.com>
> ---
> v2: Remove module parameter. The calibration data will be downloaded
>    only when the device speicific data file is provided.
>    (Marcel Holtmann)
> v3: Fix crash (misaligned memory access) on ARM
> v4: Simplify white space parsing and save some CPU cycles (Mike Frysinger)
> v5: Improvements in cal data parsing logic. Add explanatory comments.
>    Replace GFP_ATOMIC flag with GFP_KERNEL (Mike Frysinger)
> v6: Remove redundant label 'done' and 'cfg' check, and a new line character check
>    (Mike Frysinger)
>    Use btmrvl_send_sync_cmd() for downloading calibration data.
>    (Marcel Holtmann)
> 
> drivers/bluetooth/btmrvl_drv.h  |   8 +++
> drivers/bluetooth/btmrvl_main.c | 116 ++++++++++++++++++++++++++++++++++++++++
> drivers/bluetooth/btmrvl_sdio.c |   9 +++-
> drivers/bluetooth/btmrvl_sdio.h |   2 +
> 4 files changed, 134 insertions(+), 1 deletion(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

