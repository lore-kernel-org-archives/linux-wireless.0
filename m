Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64466 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2BNKug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:50:36 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so4068627wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 02:50:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329108519-5342-5-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
	<1329108519-5342-5-git-send-email-kubakici@wp.pl>
Date: Tue, 14 Feb 2012 11:50:36 +0100
Message-ID: <CAL1gcdORGntSRzAzagTPHi8d6ZhvHCRvo2PN4JV36TEMVhBjbw@mail.gmail.com> (sfid-20120214_115049_650600_3F3A634D)
Subject: Re: [rt2x00-users] [PATCH v2 4/4] rt2800pci: Fix 'Error - MCU request
 failed' during initialization
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 5:48 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Bring MCU operations during device initialization to sync
> with legacy driver.
>
> This should fix following error:
> phy0 -> rt2800pci_mcu_status: Error - MCU request failed,
> no response from hardware
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

provided that my comments to patches 1 & 2 are handled.

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   20 +++++++++++++-------
>  1 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index f184a4f..773d078 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -524,14 +524,20 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>
>        switch (state) {
>        case STATE_RADIO_ON:
> -               /*
> -                * Before the radio can be enabled, the device first has
> -                * to be woken up. After that it needs a bit of time
> -                * to be fully awake and then the radio can be enabled.
> -                */
> -               rt2800pci_set_device_state(rt2x00dev, STATE_AWAKE);
> -               msleep(1);
> +               /* Initialise all registers and send MCU_BOOT_SIGNAL. */
>                retval = rt2800pci_enable_radio(rt2x00dev);
> +
> +               /* After resume MCU_BOOT_SIGNAL will trash these. */
> +               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
> +               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> +
> +               /* Finish initialization procedure. */
> +               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF,
> +                                  0xff, 0x02);
> +               rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
> +
> +               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP, 0, 0);
> +               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
>                break;
>        case STATE_RADIO_OFF:
>                /*
> --
> 1.7.7.6
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com



-- 
---
Gertjan
