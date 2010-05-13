Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:14962 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0EMTaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:30:14 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1287876fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 12:30:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273778166-3833-2-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
	 <1273778166-3833-2-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 21:30:12 +0200
Message-ID: <AANLkTilccqteZvPru-_q1tRqcDLpAqE2DjIdMoUC0Ij_@mail.gmail.com>
Subject: Re: [PATCH 1/4] rt2x00: Fix failed SLEEP->AWAKE and AWAKE->SLEEP
	transitions.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 9:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> (Based on a patch created by Ondrej Zary)
>
> In some circumstances the Ralink devices do not properly go to sleep
> or wake up, with timeouts occurring.
> Fix this by retrying telling the device that it has to wake up or
> sleep.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Nice catch, I think the legacy drivers also did this, but not too sure
about that.
Does this mean we can reenable the flag to enable powersaving by default?

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |    9 +++++----
>  drivers/net/wireless/rt2x00/rt2500pci.c |    9 +++++----
>  drivers/net/wireless/rt2x00/rt61pci.c   |    7 ++++---
>  drivers/net/wireless/rt2x00/rt73usb.c   |    7 ++++---
>  4 files changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 641459b..7b36db2 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -925,7 +925,7 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
>  static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
>                               enum dev_state state)
>  {
> -       u32 reg;
> +       u32 reg, reg2;
>        unsigned int i;
>        char put_to_sleep;
>        char bbp_state;
> @@ -946,11 +946,12 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
>         * device has entered the correct state.
>         */
>        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -               rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg);
> -               bbp_state = rt2x00_get_field32(reg, PWRCSR1_BBP_CURR_STATE);
> -               rf_state = rt2x00_get_field32(reg, PWRCSR1_RF_CURR_STATE);
> +               rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg2);
> +               bbp_state = rt2x00_get_field32(reg2, PWRCSR1_BBP_CURR_STATE);
> +               rf_state = rt2x00_get_field32(reg2, PWRCSR1_RF_CURR_STATE);
>                if (bbp_state == state && rf_state == state)
>                        return 0;
> +               rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
>                msleep(10);
>        }
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index c8363bc..4a29ede 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1083,7 +1083,7 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
>  static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
>                               enum dev_state state)
>  {
> -       u32 reg;
> +       u32 reg, reg2;
>        unsigned int i;
>        char put_to_sleep;
>        char bbp_state;
> @@ -1104,11 +1104,12 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
>         * device has entered the correct state.
>         */
>        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -               rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg);
> -               bbp_state = rt2x00_get_field32(reg, PWRCSR1_BBP_CURR_STATE);
> -               rf_state = rt2x00_get_field32(reg, PWRCSR1_RF_CURR_STATE);
> +               rt2x00pci_register_read(rt2x00dev, PWRCSR1, &reg2);
> +               bbp_state = rt2x00_get_field32(reg2, PWRCSR1_BBP_CURR_STATE);
> +               rf_state = rt2x00_get_field32(reg2, PWRCSR1_RF_CURR_STATE);
>                if (bbp_state == state && rf_state == state)
>                        return 0;
> +               rt2x00pci_register_write(rt2x00dev, PWRCSR1, reg);
>                msleep(10);
>        }
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 9ac2f5c..a03b6a2 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1688,7 +1688,7 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
>
>  static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
>  {
> -       u32 reg;
> +       u32 reg, reg2;
>        unsigned int i;
>        char put_to_sleep;
>
> @@ -1705,10 +1705,11 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
>         * device has entered the correct state.
>         */
>        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -               rt2x00pci_register_read(rt2x00dev, MAC_CSR12, &reg);
> -               state = rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
> +               rt2x00pci_register_read(rt2x00dev, MAC_CSR12, &reg2);
> +               state = rt2x00_get_field32(reg2, MAC_CSR12_BBP_CURRENT_STATE);
>                if (state == !put_to_sleep)
>                        return 0;
> +               rt2x00pci_register_write(rt2x00dev, MAC_CSR12, reg);
>                msleep(10);
>        }
>
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index a9738ee..dc4a028 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -1365,7 +1365,7 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
>
>  static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
>  {
> -       u32 reg;
> +       u32 reg, reg2;
>        unsigned int i;
>        char put_to_sleep;
>
> @@ -1382,10 +1382,11 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
>         * device has entered the correct state.
>         */
>        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -               rt2x00usb_register_read(rt2x00dev, MAC_CSR12, &reg);
> -               state = rt2x00_get_field32(reg, MAC_CSR12_BBP_CURRENT_STATE);
> +               rt2x00usb_register_read(rt2x00dev, MAC_CSR12, &reg2);
> +               state = rt2x00_get_field32(reg2, MAC_CSR12_BBP_CURRENT_STATE);
>                if (state == !put_to_sleep)
>                        return 0;
> +               rt2x00usb_register_write(rt2x00dev, MAC_CSR12, reg);
>                msleep(10);
>        }
>
> --
> 1.7.1
>
>
