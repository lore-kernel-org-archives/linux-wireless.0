Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45794 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2BNKsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:48:52 -0500
Received: by wgbdt10 with SMTP id dt10so5799179wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 02:48:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329108519-5342-3-git-send-email-kubakici@wp.pl>
References: <1329108519-5342-1-git-send-email-kubakici@wp.pl>
	<1329108519-5342-3-git-send-email-kubakici@wp.pl>
Date: Tue, 14 Feb 2012 11:48:50 +0100
Message-ID: <CAL1gcdP2WaKm75rJn91zKpLiP=tNKxp8GWixn4Cqov-DWw6TOA@mail.gmail.com> (sfid-20120214_114855_376504_2D881C39)
Subject: Re: [rt2x00-users] [PATCH v2 2/4] rt2800usb: remove
 rt2800usb_set_state function
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 5:48 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> Remove rt2800usb_set_state to make the flow inside USB driver
> similar to that of PCI driver.
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

The same comment with respect to falling through the state cases as
for patch 1 of the
series applies here.

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   28 +++++++++-------------------
>  1 files changed, 9 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index d009b6b..15cce5e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -272,17 +272,6 @@ static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
>        rt2x00usb_disable_radio(rt2x00dev);
>  }
>
> -static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
> -                              enum dev_state state)
> -{
> -       if (state == STATE_AWAKE)
> -               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
> -       else
> -               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
> -
> -       return 0;
> -}
> -
>  static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
>                                      enum dev_state state)
>  {
> @@ -295,7 +284,7 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
>                 * to be woken up. After that it needs a bit of time
>                 * to be fully awake and then the radio can be enabled.
>                 */
> -               rt2800usb_set_state(rt2x00dev, STATE_AWAKE);
> +               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
>                msleep(1);
>                retval = rt2800usb_enable_radio(rt2x00dev);
>                break;
> @@ -305,17 +294,18 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
>                 * be put to sleep for powersaving.
>                 */
>                rt2800usb_disable_radio(rt2x00dev);
> -               rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
> -               break;
> -       case STATE_RADIO_IRQ_ON:
> -       case STATE_RADIO_IRQ_OFF:
> -               /* No support, but no error either */
> -               break;
> +               /* fall through */
>        case STATE_DEEP_SLEEP:
>        case STATE_SLEEP:
>        case STATE_STANDBY:
> +               rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
> +               break;
>        case STATE_AWAKE:
> -               retval = rt2800usb_set_state(rt2x00dev, state);
> +               rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 2);
> +               break;
> +       case STATE_RADIO_IRQ_ON:
> +       case STATE_RADIO_IRQ_OFF:
> +               /* No support, but no error either */
>                break;
>        default:
>                retval = -ENOTSUPP;

---
Gertjan
