Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64466 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2BNKuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:50:06 -0500
Received: by werb13 with SMTP id b13so4068627wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 02:50:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329108519-5342-4-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
	<1329108519-5342-4-git-send-email-kubakici@wp.pl>
Date: Tue, 14 Feb 2012 11:50:04 +0100
Message-ID: <CAL1gcdOpUmKpc2Ff_WwnOYKDYwQ0Qeh55U7LM1LKm6NkWOp83g@mail.gmail.com> (sfid-20120214_115012_186475_71E2BAC9)
Subject: Re: [rt2x00-users] [PATCH v2 3/4] rt2800: Add documentation on MCU requests
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 5:48 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Add documentation on MCU communication, some of known commands and
> their arguments. Supplement command ids.
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

provided that my comments to patches 1 & 2 are handled.

> ---
>  drivers/net/wireless/rt2x00/rt2800.h    |   14 +++++++++++++-
>  drivers/net/wireless/rt2x00/rt2800pci.c |    8 +++++---
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 06acabd..4d771db 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1627,6 +1627,7 @@ struct mac_iveiv_entry {
>
>  /*
>  * H2M_MAILBOX_CSR: Host-to-MCU Mailbox.
> + * CMD_TOKEN: Command id, 0xff disable status reporting
>  */
>  #define H2M_MAILBOX_CSR                        0x7010
>  #define H2M_MAILBOX_CSR_ARG0           FIELD32(0x000000ff)
> @@ -1636,6 +1637,8 @@ struct mac_iveiv_entry {
>
>  /*
>  * H2M_MAILBOX_CID:
> + * Free slots contain 0xff. MCU will store command's token to lowest free slot.
> + * If all slots are occupied status will be dropped.
>  */
>  #define H2M_MAILBOX_CID                        0x7014
>  #define H2M_MAILBOX_CID_CMD0           FIELD32(0x000000ff)
> @@ -1645,6 +1648,7 @@ struct mac_iveiv_entry {
>
>  /*
>  * H2M_MAILBOX_STATUS:
> + * Command status will be saved to same slot as command id.
>  */
>  #define H2M_MAILBOX_STATUS             0x701c
>
> @@ -2288,6 +2292,12 @@ struct mac_iveiv_entry {
>
>  /*
>  * MCU mailbox commands.
> + * MCU_SLEEP - go to power-save mode.
> + *             arg1: 1: save as much power as possible, 0: save less power
> + *             status: 1: success, 2: already asleep,
> + *                     3: maybe MAC is busy so can't finish this task
> + * MCU_RADIO_OFF
> + *             arg0: 0: do power-saving, NOT turn off radio
>  */
>  #define MCU_SLEEP                      0x30
>  #define MCU_WAKEUP                     0x31
> @@ -2308,7 +2318,9 @@ struct mac_iveiv_entry {
>  /*
>  * MCU mailbox tokens
>  */
> -#define TOKEN_WAKUP                    3
> +#define TOKEN_SLEEP                    1
> +#define TOKEN_RADIO_OFF                        2
> +#define TOKEN_WAKEUP                   3
>
>  /*
>  * DMA descriptor defines.
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 6ab4637..f184a4f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -546,11 +546,13 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>                /* PCIe devices won't report status after SLEEP request. */
>                rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
>                rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> -               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
> +               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_SLEEP,
> +                                  0xff, 0x01);
>                break;
>        case STATE_AWAKE:
> -               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
> -               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
> +               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP,
> +                                  0, 0x02);
> +               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
>                break;
>        case STATE_RADIO_IRQ_ON:
>        case STATE_RADIO_IRQ_OFF:
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
