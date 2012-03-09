Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40491 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715Ab2CIQCV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 11:02:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F5A1BF2.7080102@lwfinger.net>
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com>
	<CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com>
	<4F581AF8.4080001@lwfinger.net>
	<CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com>
	<4F585BA9.6020903@amd.com>
	<2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com>
	<CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com>
	<CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com>
	<4F58F2D0.5060805@lwfinger.net>
	<CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
	<4F59800B.80407@lwfinger.net>
	<CAHaq0gK17axV0uo-EEj4s7=dgOs3vccJ4-icX9YFyBcYGn4u8g@mail.gmail.com>
	<4F5A1BF2.7080102@lwfinger.net>
Date: Sat, 10 Mar 2012 00:02:19 +0800
Message-ID: <CAHaq0gLvjYU3E9u4hD2jMaQ5JjopD2RqaRTuC47S3+hTr1vwQA@mail.gmail.com> (sfid-20120309_170228_187716_8D4ECC7F)
Subject: Re: rt8192cu on USB3
From: jerome huang <jerome.syno@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Xu, Andiry" <Andiry.Xu@amd.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2012 23:04, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/09/2012 01:39 AM, jerome huang wrote:
>>
>>
>> Are other patches recommend besides b0302a?
>
>
> That is the main one. Others that you might consider, but they probably will
> not make any difference:
>
> 3eda95d rtlwifi: Remove extra debugging message accidentally left in
>
> 4e3c3b8 rtlwifi: Fix breakage in debug functions when built as a module
>          This fixes a problem caused in commit 481b9606.
>
> ebecdcc rtlwifi: rtl8192c: Prevent sleeping from invalid context in
> rtl8192cu
>
> The patch below is currently under test. It is not likely to make any
> difference with your problem, but it changes USB reads a lot.
>
> Larry
>
> ========================================================================
>
> The current version of rtlwifi for USB operations uses kmalloc to
> acquire a 32-bit buffer for reading. When _usb_read_sync() is called
> with the rcu_lock held, the result is a "sleeping function called
> from invalid context" BUG. This is reported for two cases in
> https://bugzilla.kernel.org/show_bug.cgi?id=42775. The first case
> where the lock originates from within rtlwifi and could be fixed
> by rearranging the locking; however, the second originates from
> within mac80211. The kmalloc() call is removed from _usb_read_sync()
> by creating a ring buffer pointer in the private area and
> allocating the buffer data in the probe routine.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> [This version good for 3.3+ - different
> patch for 3.2 - 2.6.39]
> ---
>
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> @@ -124,46 +124,38 @@ static int _usbctrl_vendorreq_sync_read(
>        return status;
>  }
>
> -static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
> +static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len)
>  {
> +       struct device *dev = rtlpriv->io.dev;
> +       struct usb_device *udev = to_usb_device(dev);
>        u8 request;
>        u16 wvalue;
>        u16 index;
> -       u32 *data;
> -       u32 ret;
> +       __le32 *data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
>
> -       data = kmalloc(sizeof(u32), GFP_KERNEL);
> -       if (!data)
> -               return -ENOMEM;
>        request = REALTEK_USB_VENQT_CMD_REQ;
>        index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
>
>        wvalue = (u16)addr;
>        _usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data,
> len);
> -       ret = le32_to_cpu(*data);
> -       kfree(data);
> -       return ret;
> +       if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
> +               rtlpriv->usb_data_index = 0;
> +       return le32_to_cpu(*data);
>  }
>
>  static u8 _usb_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
>  {
> -       struct device *dev = rtlpriv->io.dev;
> -
> -       return (u8)_usb_read_sync(to_usb_device(dev), addr, 1);
> +       return (u8)_usb_read_sync(rtlpriv, addr, 1);
>  }
>
>  static u16 _usb_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
>  {
> -       struct device *dev = rtlpriv->io.dev;
> -
> -       return (u16)_usb_read_sync(to_usb_device(dev), addr, 2);
> +       return (u16)_usb_read_sync(rtlpriv, addr, 2);
>  }
>
>  static u32 _usb_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
>  {
> -       struct device *dev = rtlpriv->io.dev;
> -
> -       return _usb_read_sync(to_usb_device(dev), addr, 4);
> +       return _usb_read_sync(rtlpriv, addr, 4);
>  }
>
>  static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
> @@ -951,6 +943,13 @@ int __devinit rtl_usb_probe(struct usb_i
>                return -ENOMEM;
>        }
>        rtlpriv = hw->priv;
> +       rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
> +                                   GFP_KERNEL);
> +       if (!rtlpriv->usb_data) {
> +               RT_ASSERT(false, "USB data buffer allocation failed\n");
> +               return -ENOMEM;
> +       }
> +       rtlpriv->usb_data_index = 0;
>        init_completion(&rtlpriv->firmware_loading_complete);
>        SET_IEEE80211_DEV(hw, &intf->dev);
>        udev = interface_to_usbdev(intf);
> @@ -1019,6 +1018,7 @@ void rtl_usb_disconnect(struct usb_inter
>        /* rtl_deinit_rfkill(hw); */
>        rtl_usb_deinit(hw);
>        rtl_deinit_core(hw);
> +       kfree(rtlpriv->usb_data);
>        rtlpriv->cfg->ops->deinit_sw_leds(hw);
>        rtlpriv->cfg->ops->deinit_sw_vars(hw);
>        _rtl_usb_io_handler_release(hw);
> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
> @@ -67,7 +67,7 @@
>  #define QOS_QUEUE_NUM                          4
>  #define RTL_MAC80211_NUM_QUEUE                 5
>  #define REALTEK_USB_VENQT_MAX_BUF_SIZE         254
> -
> +#define RTL_USB_MAX_RX_COUNT                   100
>  #define QBSS_LOAD_SIZE                         5
>  #define MAX_WMMELE_LENGTH                      64
>
> @@ -1629,6 +1629,10 @@ struct rtl_priv {
>           interface or hardware */
>        unsigned long status;
>
> +       /* data buffer pointer for USB reads */
> +       __le32 *usb_data;
> +       int usb_data_index;
> +
>        /*This must be the last item so
>           that it points to the data allocated
>           beyond  this structure like:
>
>
>

Thanks for your help, Larry,
will let you know the result.

BR,
Jerome
