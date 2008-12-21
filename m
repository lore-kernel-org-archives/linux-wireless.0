Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:34910 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYLURxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 12:53:33 -0500
Received: by fg-out-1718.google.com with SMTP id 19so669158fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 09:53:31 -0800 (PST)
Message-ID: <31436f4a0812210953r3b715989vd76b907fe6e4fe8d@mail.gmail.com> (sfid-20081221_185357_604870_7DF465A7)
Date: Sun, 21 Dec 2008 19:53:30 +0200
From: "David Shwatrz" <dshwatrz@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/15] rt2x00: Implement Powersaving
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200812201052.43061.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200812201052.00655.IvDoorn@gmail.com>
	 <200812201052.43061.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Great new ! It seems to me that this is the first **usb** wireless
device with power save support (and please correct me if I am wrong).

Regards,
DavidS

On Sat, Dec 20, 2008 at 11:52 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Listen to IEEE80211_CONF_PS to determine if the device
> should drop into powersaving mode. This feature depends
> on the dynamic power save functionality in mac80211.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |   28 ++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2500pci.c |   28 ++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2500usb.c |   28 ++++++++++++++++
>  drivers/net/wireless/rt2x00/rt61pci.c   |   53 ++++++++++++++++++++++++++----
>  drivers/net/wireless/rt2x00/rt61pci.h   |    4 ++
>  drivers/net/wireless/rt2x00/rt73usb.c   |   40 +++++++++++++++++++++++
>  6 files changed, 174 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index fabcd71..031cb0a 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -524,6 +524,32 @@ static void rt2400pci_config_duration(struct rt2x00_dev *rt2x00dev,
>        rt2x00pci_register_write(rt2x00dev, CSR12, reg);
>  }
>
> +static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
> +                               struct rt2x00lib_conf *libconf)
> +{
> +       enum dev_state state =
> +           (libconf->conf->flags & IEEE80211_CONF_PS) ?
> +               STATE_SLEEP : STATE_AWAKE;
> +       u32 reg;
> +
> +       if (state == STATE_SLEEP) {
> +               rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
> +               rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
> +                                  (libconf->conf->beacon_int - 20) * 16);
> +               rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
> +                                  libconf->conf->listen_interval - 1);
> +
> +               /* We must first disable autowake before it can be enabled */
> +               rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
> +               rt2x00pci_register_write(rt2x00dev, CSR20, reg);
> +
> +               rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
> +               rt2x00pci_register_write(rt2x00dev, CSR20, reg);
> +       }
> +
> +       rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
> +}
> +
>  static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
>                             struct rt2x00lib_conf *libconf,
>                             const unsigned int flags)
> @@ -537,6 +563,8 @@ static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
>                rt2400pci_config_retry_limit(rt2x00dev, libconf);
>        if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
>                rt2400pci_config_duration(rt2x00dev, libconf);
> +       if (flags & IEEE80211_CONF_CHANGE_PS)
> +               rt2400pci_config_ps(rt2x00dev, libconf);
>  }
>
>  static void rt2400pci_config_cw(struct rt2x00_dev *rt2x00dev,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index a9add81..780c96b 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -573,6 +573,32 @@ static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
>        rt2x00pci_register_write(rt2x00dev, CSR12, reg);
>  }
>
> +static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
> +                               struct rt2x00lib_conf *libconf)
> +{
> +       enum dev_state state =
> +           (libconf->conf->flags & IEEE80211_CONF_PS) ?
> +               STATE_SLEEP : STATE_AWAKE;
> +       u32 reg;
> +
> +       if (state == STATE_SLEEP) {
> +               rt2x00pci_register_read(rt2x00dev, CSR20, &reg);
> +               rt2x00_set_field32(&reg, CSR20_DELAY_AFTER_TBCN,
> +                                  (libconf->conf->beacon_int - 20) * 16);
> +               rt2x00_set_field32(&reg, CSR20_TBCN_BEFORE_WAKEUP,
> +                                  libconf->conf->listen_interval - 1);
> +
> +               /* We must first disable autowake before it can be enabled */
> +               rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 0);
> +               rt2x00pci_register_write(rt2x00dev, CSR20, reg);
> +
> +               rt2x00_set_field32(&reg, CSR20_AUTOWAKE, 1);
> +               rt2x00pci_register_write(rt2x00dev, CSR20, reg);
> +       }
> +
> +       rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
> +}
> +
>  static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
>                             struct rt2x00lib_conf *libconf,
>                             const unsigned int flags)
> @@ -588,6 +614,8 @@ static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
>                rt2500pci_config_retry_limit(rt2x00dev, libconf);
>        if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
>                rt2500pci_config_duration(rt2x00dev, libconf);
> +       if (flags & IEEE80211_CONF_CHANGE_PS)
> +               rt2500pci_config_ps(rt2x00dev, libconf);
>  }
>
>  /*
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index d8c48fd..4de1bc1 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -634,6 +634,32 @@ static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
>        rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
>  }
>
> +static void rt2500usb_config_ps(struct rt2x00_dev *rt2x00dev,
> +                               struct rt2x00lib_conf *libconf)
> +{
> +       enum dev_state state =
> +           (libconf->conf->flags & IEEE80211_CONF_PS) ?
> +               STATE_SLEEP : STATE_AWAKE;
> +       u16 reg;
> +
> +       if (state == STATE_SLEEP) {
> +               rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
> +               rt2x00_set_field16(&reg, MAC_CSR18_DELAY_AFTER_BEACON,
> +                                  libconf->conf->beacon_int - 20);
> +               rt2x00_set_field16(&reg, MAC_CSR18_BEACONS_BEFORE_WAKEUP,
> +                                  libconf->conf->listen_interval - 1);
> +
> +               /* We must first disable autowake before it can be enabled */
> +               rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
> +               rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
> +
> +               rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
> +               rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
> +       }
> +
> +       rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
> +}
> +
>  static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
>                             struct rt2x00lib_conf *libconf,
>                             const unsigned int flags)
> @@ -647,6 +673,8 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
>                                         libconf->conf->power_level);
>        if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
>                rt2500usb_config_duration(rt2x00dev, libconf);
> +       if (flags & IEEE80211_CONF_CHANGE_PS)
> +               rt2500usb_config_ps(rt2x00dev, libconf);
>  }
>
>  /*
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 3b9015a..3f91a6e 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -146,12 +146,6 @@ static void rt61pci_rf_write(struct rt2x00_dev *rt2x00dev,
>        mutex_unlock(&rt2x00dev->csr_mutex);
>  }
>
> -#ifdef CONFIG_RT2X00_LIB_LEDS
> -/*
> - * This function is only called from rt61pci_led_brightness()
> - * make gcc happy by placing this function inside the
> - * same ifdef statement as the caller.
> - */
>  static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
>                                const u8 command, const u8 token,
>                                const u8 arg0, const u8 arg1)
> @@ -180,7 +174,6 @@ static void rt61pci_mcu_request(struct rt2x00_dev *rt2x00dev,
>        mutex_unlock(&rt2x00dev->csr_mutex);
>
>  }
> -#endif /* CONFIG_RT2X00_LIB_LEDS */
>
>  static void rt61pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
>  {
> @@ -967,6 +960,50 @@ static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
>        rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
>  }
>
> +static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
> +                               struct rt2x00lib_conf *libconf)
> +{
> +       enum dev_state state =
> +           (libconf->conf->flags & IEEE80211_CONF_PS) ?
> +               STATE_SLEEP : STATE_AWAKE;
> +       u32 reg;
> +
> +       if (state == STATE_SLEEP) {
> +               rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
> +               rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
> +                                  libconf->conf->beacon_int - 10);
> +               rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP,
> +                                  libconf->conf->listen_interval - 1);
> +               rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 5);
> +
> +               /* We must first disable autowake before it can be enabled */
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
> +               rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
> +
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 1);
> +               rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
> +
> +               rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000005);
> +               rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x0000001c);
> +               rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000060);
> +
> +               rt61pci_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0, 0);
> +       } else {
> +               rt2x00pci_register_read(rt2x00dev, MAC_CSR11, &reg);
> +               rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 0);
> +               rt2x00pci_register_write(rt2x00dev, MAC_CSR11, reg);
> +
> +               rt2x00pci_register_write(rt2x00dev, SOFT_RESET_CSR, 0x00000007);
> +               rt2x00pci_register_write(rt2x00dev, IO_CNTL_CSR, 0x00000018);
> +               rt2x00pci_register_write(rt2x00dev, PCI_USEC_CSR, 0x00000020);
> +
> +               rt61pci_mcu_request(rt2x00dev, MCU_WAKEUP, 0xff, 0, 0);
> +       }
> +}
> +
>  static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
>                           struct rt2x00lib_conf *libconf,
>                           const unsigned int flags)
> @@ -984,6 +1021,8 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
>                rt61pci_config_retry_limit(rt2x00dev, libconf);
>        if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
>                rt61pci_config_duration(rt2x00dev, libconf);
> +       if (flags & IEEE80211_CONF_CHANGE_PS)
> +               rt61pci_config_ps(rt2x00dev, libconf);
>  }
>
>  /*
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
> index 65fe333..86590c6 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.h
> +++ b/drivers/net/wireless/rt2x00/rt61pci.h
> @@ -88,8 +88,10 @@
>
>  /*
>  * SOFT_RESET_CSR
> + * FORCE_CLOCK_ON: Host force MAC clock ON
>  */
>  #define SOFT_RESET_CSR                 0x0010
> +#define SOFT_RESET_CSR_FORCE_CLOCK_ON  FIELD32(0x00000002)
>
>  /*
>  * MCU_INT_SOURCE_CSR: MCU interrupt source/mask register.
> @@ -1054,8 +1056,10 @@ struct hw_pairwise_ta_entry {
>
>  /*
>  * IO_CNTL_CSR
> + * RF_PS: Set RF interface value to power save
>  */
>  #define IO_CNTL_CSR                    0x3498
> +#define IO_CNTL_CSR_RF_PS              FIELD32(0x00000004)
>
>  /*
>  * UART_INT_SOURCE_CSR
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 563be0b..8a365c9 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -844,6 +844,44 @@ static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
>        rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
>  }
>
> +static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
> +                               struct rt2x00lib_conf *libconf)
> +{
> +       enum dev_state state =
> +           (libconf->conf->flags & IEEE80211_CONF_PS) ?
> +               STATE_SLEEP : STATE_AWAKE;
> +       u32 reg;
> +
> +       if (state == STATE_SLEEP) {
> +               rt2x00usb_register_read(rt2x00dev, MAC_CSR11, &reg);
> +               rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN,
> +                                  libconf->conf->beacon_int - 10);
> +               rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP,
> +                                  libconf->conf->listen_interval - 1);
> +               rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 5);
> +
> +               /* We must first disable autowake before it can be enabled */
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
> +               rt2x00usb_register_write(rt2x00dev, MAC_CSR11, reg);
> +
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 1);
> +               rt2x00usb_register_write(rt2x00dev, MAC_CSR11, reg);
> +
> +               rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
> +                                           USB_MODE_SLEEP, REGISTER_TIMEOUT);
> +       } else {
> +               rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
> +                                           USB_MODE_WAKEUP, REGISTER_TIMEOUT);
> +
> +               rt2x00usb_register_read(rt2x00dev, MAC_CSR11, &reg);
> +               rt2x00_set_field32(&reg, MAC_CSR11_DELAY_AFTER_TBCN, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_TBCN_BEFORE_WAKEUP, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_AUTOWAKE, 0);
> +               rt2x00_set_field32(&reg, MAC_CSR11_WAKEUP_LATENCY, 0);
> +               rt2x00usb_register_write(rt2x00dev, MAC_CSR11, reg);
> +       }
> +}
> +
>  static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
>                           struct rt2x00lib_conf *libconf,
>                           const unsigned int flags)
> @@ -861,6 +899,8 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
>                rt73usb_config_retry_limit(rt2x00dev, libconf);
>        if (flags & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
>                rt73usb_config_duration(rt2x00dev, libconf);
> +       if (flags & IEEE80211_CONF_CHANGE_PS)
> +               rt73usb_config_ps(rt2x00dev, libconf);
>  }
>
>  /*
> --
> 1.5.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
