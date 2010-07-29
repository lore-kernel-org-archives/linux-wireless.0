Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53130 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab0G2T6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 15:58:47 -0400
Received: by bwz1 with SMTP id 1so102125bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 12:58:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280425899-20943-1-git-send-email-linville@tuxdriver.com>
References: <1280425899-20943-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 29 Jul 2010 21:58:45 +0200
Message-ID: <AANLkTi=BMeQexF+LjRYV=xfZFMLniovorLED80kRwKrr@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: update fw version info in wiphy struct
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 7:51 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This makes the information available through ethtool...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00firmware.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> index b818a43..f0e1eb7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> @@ -63,6 +63,9 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
>
>        INFO(rt2x00dev, "Firmware detected - version: %d.%d.\n",
>             fw->data[fw->size - 4], fw->data[fw->size - 3]);
> +       snprintf(rt2x00dev->hw->wiphy->fw_version,
> +                       sizeof(rt2x00dev->hw->wiphy->fw_version), "%d.%d",
> +                       fw->data[fw->size - 4], fw->data[fw->size - 3]);
>
>        retval = rt2x00dev->ops->lib->check_firmware(rt2x00dev, fw->data, fw->size);
>        switch (retval) {
> --
> 1.7.1.1
>
>
