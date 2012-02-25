Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39406 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab2BYIqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 03:46:50 -0500
Received: by vcqp1 with SMTP id p1so635290vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2012 00:46:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329944338-4696-2-git-send-email-kubakici@wp.pl>
References: <1329944338-4696-1-git-send-email-kubakici@wp.pl>
	<1329944338-4696-2-git-send-email-kubakici@wp.pl>
Date: Sat, 25 Feb 2012 09:46:49 +0100
Message-ID: <CAOZOX0XfdtC+WXhiEUVPY2BsZG2ft2Ga4m+vdh7cS7gz+faGFg@mail.gmail.com> (sfid-20120225_094717_269285_F38FDB89)
Subject: Re: [PATCH v3 2/2] rt2800pci: Fix 'Error - MCU request failed' during initialization
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 22, 2012 at 9:58 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Bring MCU operations during device initialization to sync
> with legacy driver.
>
> This should fix following error:
> phy0 -> rt2800pci_mcu_status: Error - MCU request failed,
> no response from hardware
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> v3: move code from switch statement to appropriate function.
> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 891547c..ac874db 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -501,11 +501,27 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
>
>  static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
>  {
> +       int retval;
> +
>        if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
>                     rt2800pci_init_queues(rt2x00dev)))
>                return -EIO;
>
> -       return rt2800_enable_radio(rt2x00dev);
> +       retval = rt2800_enable_radio(rt2x00dev);
> +       if (retval)
> +               return retval;
> +
> +       /* After resume MCU_BOOT_SIGNAL will trash these. */
> +       rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
> +       rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> +
> +       rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
> +       rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
> +
> +       rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP, 0, 0);
> +       rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
> +
> +       return retval;
>  }
>
>  static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
> @@ -543,13 +559,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>
>        switch (state) {
>        case STATE_RADIO_ON:
> -               /*
> -                * Before the radio can be enabled, the device first has
> -                * to be woken up. After that it needs a bit of time
> -                * to be fully awake and then the radio can be enabled.
> -                */
> -               rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
> -               msleep(1);
>                retval = rt2800pci_enable_radio(rt2x00dev);
>                break;
>        case STATE_RADIO_OFF:
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
