Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39133 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2BNKri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:47:38 -0500
Received: by wics10 with SMTP id s10so4057272wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 02:47:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329108519-5342-2-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
	<1329108519-5342-2-git-send-email-kubakici@wp.pl>
Date: Tue, 14 Feb 2012 11:47:37 +0100
Message-ID: <CAL1gcdPWEf_qYcjp8nYuZNkJUR=pA93P3-hi5xhokvUm1t-Ljg@mail.gmail.com> (sfid-20120214_114747_589756_86DC92CE)
Subject: Re: [rt2x00-users] [PATCH v2 1/4] rt2800pci: remove
 rt2800pci_set_state function
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 5:48 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> rt2800pci_set_state was introduced to group requests preceded with
> common introduction. As that introduction is no longer used
> rt2800pci_set_state can be removed.
>
> Note that this patch changes behaviour for STATE_DEEP_SLEEP and
> STATE_STANDBY, but those states are not used in rt2800 anyway.
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

I know this patch has been out there for a while, but I only now have
taken a good look at it.
First of all, I think that it would have been easy to not change the
behaviour for STATE_DEEP_SLEEP
and STATE_STANDBY, even though these are not used in rt2800. They can
simply be put as their
own cases in the switch statement in which nothing is done.

Also some comments to the actual code below.

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++++++++++--------------------
>  1 files changed, 13 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 6ad6929..6ab4637 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -517,23 +517,6 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
>        }
>  }
>
> -static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
> -                              enum dev_state state)
> -{
> -       if (state == STATE_AWAKE) {
> -               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
> -               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
> -       } else if (state == STATE_SLEEP) {
> -               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
> -                                        0xffffffff);
> -               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID,
> -                                        0xffffffff);
> -               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
> -       }
> -
> -       return 0;
> -}
> -
>  static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>                                      enum dev_state state)
>  {
> @@ -546,7 +529,7 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>                 * to be woken up. After that it needs a bit of time
>                 * to be fully awake and then the radio can be enabled.
>                 */
> -               rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
> +               rt2800pci_set_device_state(rt2x00dev, STATE_AWAKE);
>                msleep(1);
>                retval = rt2800pci_enable_radio(rt2x00dev);
>                break;

I don't like this recursive call, but this is removed in patch 4, so I
don't mind it here.

> @@ -556,17 +539,22 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>                 * be put to sleep for powersaving.
>                 */
>                rt2800pci_disable_radio(rt2x00dev);
> -               rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
> -               break;
> -       case STATE_RADIO_IRQ_ON:
> -       case STATE_RADIO_IRQ_OFF:
> -               rt2800pci_toggle_irq(rt2x00dev, state);
> -               break;
> +               /* fall through */

I don't really like this falling through, which is just there out of
convenience, as the states have
some common code. However, in reality these states have not a lot in
common, so just a bit
of code duplication would have been better here, IMHO.

>        case STATE_DEEP_SLEEP:
>        case STATE_SLEEP:
>        case STATE_STANDBY:
> +               /* PCIe devices won't report status after SLEEP request. */
> +               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
> +               rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> +               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
> +               break;
>        case STATE_AWAKE:
> -               retval = rt2800pci_set_state(rt2x00dev, state);
> +               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
> +               rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
> +               break;
> +       case STATE_RADIO_IRQ_ON:
> +       case STATE_RADIO_IRQ_OFF:
> +               rt2800pci_toggle_irq(rt2x00dev, state);
>                break;
>        default:
>                retval = -ENOTSUPP;

---
Gertjan
