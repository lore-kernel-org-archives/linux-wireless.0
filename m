Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55994 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2LSADk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 19:03:40 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so649077eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2012 16:03:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 19 Dec 2012 10:58:05 +1100
Message-ID: <CAGRGNgVC46Qe0vYUYDFdjC+=ww8AL4NdHaS4wjp7w=S90ztKOA@mail.gmail.com> (sfid-20121219_010345_229435_F5EBF1F6)
Subject: Re: [PATCH 1/2] rt2x00: rt2800pci: verify ioremap return value
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Daniel Golle <dgolle@allnet.de>, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

One minor question:

On Wed, Dec 19, 2012 at 3:22 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> An ioremap call is allowed to fail, however
> the return value of that is not checked in
> the 'rt2800pci_read_eeprom_soc' function.
>
> The patch adds the missing check, and makes
> the function return an int value. The patch
> also converts the 'rt2800_read_eeprom' and
> 'rt2800_ops.read_eeprom' functions to return
> an int value, so the error value can be
> propagated up to the 'rt2800_validate_eeprom'
> function.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++++-
>  drivers/net/wireless/rt2x00/rt2800lib.h |    6 +++---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   17 ++++++++++++-----
>  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +++-
>  4 files changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 9224d87..5fc16dd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -970,14 +974,17 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
>  /*
>   * Device probe functions.
>   */
> -static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>         if (rt2x00_is_soc(rt2x00dev))
> -               rt2800pci_read_eeprom_soc(rt2x00dev);
> -       else if (rt2800pci_efuse_detect(rt2x00dev))
> +               return rt2800pci_read_eeprom_soc(rt2x00dev);
> +
> +       if (rt2800pci_efuse_detect(rt2x00dev))
>                 rt2800pci_read_eeprom_efuse(rt2x00dev);
>         else
>                 rt2800pci_read_eeprom_pci(rt2x00dev);

Would it make any sense to have rt2800pci_read_eeprom_efuse() and
rt2800pci_read_eeprom_pci() return a value, simply for consistency
with rt2800pci_read_eeprom_soc()?

> +
> +       return 0;
>  }
>
>  static const struct ieee80211_ops rt2800pci_mac80211_ops = {
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 5c149b5..48de5c9 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -735,13 +735,15 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>  /*
>   * Device probe functions.
>   */
> -static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
> +static int rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
>         if (rt2800_efuse_detect(rt2x00dev))
>                 rt2800_read_eeprom_efuse(rt2x00dev);
>         else
>                 rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
>                                       EEPROM_SIZE);

Same here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
