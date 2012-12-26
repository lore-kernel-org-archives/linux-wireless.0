Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50472 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2LZCqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2012 21:46:04 -0500
Message-ID: <50DA64E7.9050700@lwfinger.net> (sfid-20121226_034611_093719_46A2B3EE)
Date: Tue, 25 Dec 2012 20:45:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linville@tuxdriver.com, Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE combo
 device
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net> <6432515.NlhvICzq3b@linux-lqwf.site>
In-Reply-To: <6432515.NlhvICzq3b@linux-lqwf.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/2012 03:00 PM, Oliver Neukum wrote:
> On Thursday 20 December 2012 20:52:51 Larry Finger wrote:
>> This new driver works with the RTL8723AE wireless/BT combo device. The
>> corresponding firmware has been submitted to linux-firmware.
>>
>> Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>   drivers/bluetooth/Kconfig     |   10 +
>>   drivers/bluetooth/Makefile    |    1 +
>>   drivers/bluetooth/rtk_btusb.c | 1649 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 1660 insertions(+)
>>   create mode 100644 drivers/bluetooth/rtk_btusb.c
>>
>> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index e9f203e..efd3766 100644
>> --- a/drivers/bluetooth/Kconfig
>> +++ b/drivers/bluetooth/Kconfig
>> @@ -241,4 +241,14 @@ config BT_WILINK
>>
>>   	  Say Y here to compile support for Texas Instrument's WiLink7 driver
>>   	  into the kernel or say M to compile it as module.
>> +
>> +config BT_RTKUSB
>> +	tristate "Realtek BT driver for RTL8723AE"
>> +	select FW_LOADER
>> +	help
>> +	  This enables the Bluetooth driver for the Realtek RTL8723AE Wifi/BT
>> +	  combo device.
>> +
>> +	  Say Y here to compile support for these devices into the kernel
>> +	  or say M to build it as a module.
>>   endmenu
>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>> index 4afae20..167ccc0 100644
>> --- a/drivers/bluetooth/Makefile
>> +++ b/drivers/bluetooth/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
>>   obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
>>   obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
>>   obj-$(CONFIG_BT_WILINK)		+= btwilink.o
>> +obj-$(CONFIG_BT_RTKUSB)		+= rtk_btusb.o
>>
>>   btmrvl-y			:= btmrvl_main.o
>>   btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
>> diff --git a/drivers/bluetooth/rtk_btusb.c b/drivers/bluetooth/rtk_btusb.c
>> new file mode 100644
>> index 0000000..31c128a
>> --- /dev/null
>> +++ b/drivers/bluetooth/rtk_btusb.c
>> @@ -0,0 +1,1650 @@
>> +/*
>> + *
>> + *  Realtek Bluetooth USB driver
>> + *
>> + *  Copyright (C) 2012-2015  Edward Bian <edward_bian@realsil.com.cn>
>> + *
>> + *
>> + *  This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License as published by
>> + *  the Free Software Foundation; either version 2 of the License, or
>> + *  (at your option) any later version.
>> + *
>> + *  This program is distributed in the hope that it will be useful,
>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *  GNU General Public License for more details.
>> + *
>> + *  You should have received a copy of the GNU General Public License
>> + *  along with this program; if not, write to the Free Software
>> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/sched.h>
>> +#include <linux/errno.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/usb.h>
>> +#include <linux/completion.h>
>> +#include <net/bluetooth/bluetooth.h>
>> +#include <net/bluetooth/hci_core.h>
>> +
>> +#define VERSION "0.8"
>> +
>> +static struct usb_driv> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index e9f203e..efd3766 100644
>
>> +static struct usb_driver btusb_driver;
>> +#if 1
>> +#define RTKBT_DBG(fmt, arg...) pr_info("rtk_btusb: " fmt "\n" , ## arg)
>
> No new debug macros please.

OK.

>
>> +
>> +static int btusb_open(struct hci_dev *hdev)
>> +{
>> +	struct btusb_data *data = GET_DRV_DATA(hdev);
>> +	int err;
>> +
>> +	err = usb_autopm_get_interface(data->intf);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	data->intf->needs_remote_wakeup = 1;
>> +	RTKBT_DBG("%s start pm_usage_cnt(0x%x)", __func__,
>> +		  atomic_read(&(data->intf->pm_usage_cnt)));
>> +
>> +	/*******************************/
>> +	if (0 == atomic_read(&hdev->promisc)) {
>> +		RTKBT_DBG("btusb_open hdev->promisc == 0");
>> +		err = -1;
>
> This makes no sense

I will need to talk to the Realtek guys about this code to see what they meant.

>
>> +	}
>> +	err = download_patch(data->intf);
>> +	if (err < 0)
>> +		goto failed;
>
> On every open?
>
>> +	/*******************************/
>> +
>> +	if (test_and_set_bit(HCI_RUNNING, &hdev->flags))
>> +		goto done;
>> +
>> +	if (test_and_set_bit(BTUSB_INTR_RUNNING, &data->flags))
>> +		goto done;
>> +
>> +	err = btusb_submit_intr_urb(hdev, GFP_KERNEL);
>> +	if (err < 0)
>> +		goto failed;
>> +
>> +	err = btusb_submit_bulk_urb(hdev, GFP_KERNEL);
>> +	if (err < 0) {
>> +		mdelay(URB_CANCELING_DELAY_MS);      /*  Added by Realtek */
>> +		usb_kill_anchored_urbs(&data->intr_anchor);
>> +		goto failed;
>> +	}
>> +
>> +	set_bit(BTUSB_BULK_RUNNING, &data->flags);
>> +	btusb_submit_bulk_urb(hdev, GFP_KERNEL);
>> +
>> +done:
>> +	usb_autopm_put_interface(data->intf);
>> +	RTKBT_DBG("%s end  pm_usage_cnt(0x%x)", __func__,
>> +		  atomic_read(&(data->intf->pm_usage_cnt)));
>> +
>> +	return 0;
>> +
>> +failed:
>> +	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
>> +	clear_bit(HCI_RUNNING, &hdev->flags);
>> +	usb_autopm_put_interface(data->intf);
>> +	RTKBT_DBG("%s failed  pm_usage_cnt(0x%x)", __func__,
>> +		  atomic_read(&(data->intf->pm_usage_cnt)));
>> +	return err;
>> +}
>> +
>> +static void btusb_stop_traffic(struct btusb_data *data)
>> +{
>> +	mdelay(URB_CANCELING_DELAY_MS);    /*  Added by Realtek */
>> +	usb_kill_anchored_urbs(&data->intr_anchor);
>> +	usb_kill_anchored_urbs(&data->bulk_anchor);
>> +	usb_kill_anchored_urbs(&data->isoc_anchor);
>> +}
>> +
>> +static int btusb_close(struct hci_dev *hdev)
>> +{
>> +	struct btusb_data *data = GET_DRV_DATA(hdev);
>> +	int i, err;
>> +
>> +	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
>> +		return 0;
>> +
>> +	RTKBT_DBG("btusb_close");
>> +	/*******************************/
>> +	for (i = 0; i < NUM_REASSEMBLY; i++) {
>> +		if (hdev->reassembly[i])	{
>> +			kfree_skb(hdev->reassembly[i]);
>> +			hdev->reassembly[i] = NULL;
>> +			RTKBT_DBG("%s free ressembly i =%d", __func__, i);
>> +		}
>> +	}
>> +	/*******************************/
>> +	cancel_work_sync(&data->work);
>> +	cancel_work_sync(&data->waker);
>> +
>> +	clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +	clear_bit(BTUSB_BULK_RUNNING, &data->flags);
>> +	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
>> +
>> +	btusb_stop_traffic(data);
>> +	err = usb_autopm_get_interface(data->intf);
>> +	if (err < 0)
>> +		goto failed;
>> +
>> +	data->intf->needs_remote_wakeup = 0;
>> +	usb_autopm_put_interface(data->intf);
>> +
>> +failed:
>> +	mdelay(URB_CANCELING_DELAY_MS);     /*  Added by Realtek */
>
> This makes no sense. Those URBs never went over the wire.

Agreed.

>> +	usb_scuttle_anchored_urbs(&data->deferred);
>> +	return 0;
>> +}
>> +
>> +static int btusb_flush(struct hci_dev *hdev)
>> +{
>> +	struct btusb_data *data = GET_DRV_DATA(hdev);
>> +
>> +	RTKBT_DBG("%s add delay ", __func__);
>> +	mdelay(URB_CANCELING_DELAY_MS);     /*  Added by Realtek */
>> +	usb_kill_anchored_urbs(&data->tx_anchor);
>> +
>> +	return 0;
>> +}
>> +
>
>
>> +
>> +static void btusb_work(struct work_struct *work)
>> +{
>> +	struct btusb_data *data = container_of(work, struct btusb_data, work);
>> +	struct hci_dev *hdev = data->hdev;
>> +	int err;
>> +
>> +	if (hdev->conn_hash.sco_num > 0) {
>> +		if (!test_bit(BTUSB_DID_ISO_RESUME, &data->flags)) {
>> +			err = usb_autopm_get_interface(data->isoc ? data->isoc :
>> +						       data->intf);
>> +			if (err < 0) {
>> +				clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +				/*  Delay added by Realtek */
>> +				mdelay(URB_CANCELING_DELAY_MS);
>> +				usb_kill_anchored_urbs(&data->isoc_anchor);
>> +				return;
>> +			}
>> +
>> +			set_bit(BTUSB_DID_ISO_RESUME, &data->flags);
>> +		}
>> +		if (data->isoc_altsetting != 2) {
>> +			clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +			mdelay(URB_CANCELING_DELAY_MS);  /*  Added by Realtek */
>> +			usb_kill_anchored_urbs(&data->isoc_anchor);
>> +
>> +			if (__set_isoc_interface(hdev, 2) < 0)
>> +				return;
>> +		}
>> +
>> +		if (!test_and_set_bit(BTUSB_ISOC_RUNNING, &data->flags)) {
>> +			if (btusb_submit_isoc_urb(hdev, GFP_KERNEL) < 0)
>> +				clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +			else
>> +				btusb_submit_isoc_urb(hdev, GFP_KERNEL);
>> +		}
>> +	} else {
>> +		clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +		mdelay(URB_CANCELING_DELAY_MS);      /*  Added by Realtek */
>> +		usb_kill_anchored_urbs(&data->isoc_anchor);
>> +
>> +		__set_isoc_interface(hdev, 0);
>> +		if (test_and_clear_bit(BTUSB_DID_ISO_RESUME, &data->flags))
>> +			usb_autopm_put_interface(data->isoc ? data->isoc :
>> +						 data->intf);
>> +	}
>> +}
>
>> +static int btusb_probe(struct usb_interface *intf,
>> +				const struct usb_device_id *id)
>> +{
>> +	struct usb_endpoint_descriptor *ep_desc;
>> +	struct btusb_data *data;
>> +	struct hci_dev *hdev;
>> +	int i, err, flag1, flag2;
>> +	struct usb_device *udev;
>> +	udev = interface_to_usbdev(intf);
>> +
>> +	/* interface numbers are hardcoded in the spec */
>> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
>> +		return -ENODEV;
>> +
>> +	/*******************************/
>> +	flag1 = device_can_wakeup(&udev->dev);
>> +	flag2 = device_may_wakeup(&udev->dev);
>> +	RTKBT_DBG("btusb_probe 1 ========== can_wakeup =%x	 flag2 =%x",
>> +		  flag1, flag2);
>> +	device_wakeup_disable(&udev->dev);
>
> Why?

Another question for Realtek.

>
>> +	flag1 = device_can_wakeup(&udev->dev);
>> +	flag2 = device_may_wakeup(&udev->dev);
>> +	RTKBT_DBG("wakeup_disable ========== can_wakeup =%x	 flag2 =%x",
>> +		  flag1, flag2);
>> +	err = patch_add(intf);
>> +	if (err < 0)
>> +		return -1;
>> +	/*******************************/
>> +
>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +
>> +	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
>> +		ep_desc = &intf->cur_altsetting->endpoint[i].desc;
>> +
>> +		if (!data->intr_ep && usb_endpoint_is_int_in(ep_desc)) {
>> +			data->intr_ep = ep_desc;
>> +			continue;
>> +		}
>> +
>> +		if (!data->bulk_tx_ep && usb_endpoint_is_bulk_out(ep_desc)) {
>> +			data->bulk_tx_ep = ep_desc;
>> +			continue;
>> +		}
>> +
>> +		if (!data->bulk_rx_ep && usb_endpoint_is_bulk_in(ep_desc)) {
>> +			data->bulk_rx_ep = ep_desc;
>> +			continue;
>> +		}
>> +	}
>> +
>> +	if (!data->intr_ep || !data->bulk_tx_ep || !data->bulk_rx_ep) {
>> +		kfree(data);
>> +		return -ENODEV;
>> +	}
>> +
>> +	data->cmdreq_type = USB_TYPE_CLASS;
>> +
>> +	data->udev = interface_to_usbdev(intf);
>> +	data->intf = intf;
>> +
>> +	spin_lock_init(&data->lock);
>> +
>> +	INIT_WORK(&data->work, btusb_work);
>> +	INIT_WORK(&data->waker, btusb_waker);
>> +	spin_lock_init(&data->txlock);
>> +
>> +	init_usb_anchor(&data->tx_anchor);
>> +	init_usb_anchor(&data->intr_anchor);
>> +	init_usb_anchor(&data->bulk_anchor);
>> +	init_usb_anchor(&data->isoc_anchor);
>> +	init_usb_anchor(&data->deferred);
>> +
>> +	hdev = hci_alloc_dev();
>> +	if (!hdev) {
>> +		kfree(data);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	HDEV_BUS = HCI_USB;
>> +
>> +	data->hdev = hdev;
>> +
>> +	SET_HCIDEV_DEV(hdev, &intf->dev);
>> +
>> +	hdev->open     = btusb_open;
>> +	hdev->close    = btusb_close;
>> +	hdev->flush    = btusb_flush;
>> +	hdev->send     = btusb_send_frame;
>> +	hdev->notify   = btusb_notify;
>> +
>> +
>> +	hci_set_drvdata(hdev, data);
>> +
>> +	/* Interface numbers are hardcoded in the specification */
>> +	data->isoc = usb_ifnum_to_if(data->udev, 1);
>> +
>> +	if (data->isoc) {
>> +		err = usb_driver_claim_interface(&btusb_driver,
>> +						 data->isoc, data);
>> +		if (err < 0) {
>> +			hci_free_dev(hdev);
>> +			kfree(data);
>> +			return err;
>> +		}
>> +	}
>> +
>> +	err = hci_register_dev(hdev);
>> +	if (err < 0) {
>> +		hci_free_dev(hdev);
>> +		kfree(data);
>> +		return err;
>> +	}
>> +
>> +	usb_set_intfdata(intf, data);
>> +
>> +	return 0;
>> +}
>> +
>> +static void btusb_disconnect(struct usb_interface *intf)
>> +{
>> +	struct btusb_data *data = usb_get_intfdata(intf);
>> +	struct hci_dev *hdev;
>> +	struct usb_device *udev;
>> +	udev = interface_to_usbdev(intf);
>> +
>> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
>> +		return;
>> +
>> +	if (!data)
>> +		return;
>> +
>> +	RTKBT_DBG("btusb_disconnect");
>> +	/*******************************/
>> +	patch_remove(intf);
>
> This is a race. The device is not dead at this time.

Noted.

>
>> +	/*******************************/
>> +
>> +	hdev = data->hdev;
>> +
>> +	usb_set_intfdata(data->intf, NULL);
>> +
>> +	if (data->isoc)
>> +		usb_set_intfdata(data->isoc, NULL);
>> +
>> +	hci_unregister_dev(hdev);
>> +
>> +	if (intf == data->isoc)
>> +		usb_driver_release_interface(&btusb_driver, data->intf);
>> +	else if (data->isoc)
>> +		usb_driver_release_interface(&btusb_driver, data->isoc);
>> +
>> +	hci_free_dev(hdev);
>> +	kfree(data);
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int btusb_suspend(struct usb_interface *intf, pm_message_t message)
>> +{
>> +	struct btusb_data *data = usb_get_intfdata(intf);
>> +
>> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
>> +		return 0;
>> +
>> +	/*******************************/
>> +	RTKBT_DBG("btusb_suspend message.event = 0x%x, data->suspend_count =%d",
>> +		  message.event, data->suspend_count);
>> +	if (!test_bit(HCI_RUNNING, &data->hdev->flags)) {
>> +		RTKBT_DBG("btusb_suspend-----bt is off");
>> +		set_btoff(data->intf);
>
> Why repeat this if the device is already suspended?

Good point!

>
>> +	}
>> +	/*******************************/
>> +
>> +	if (data->suspend_count++)
>> +		return 0;
>> +
>> +	spin_lock_irq(&data->txlock);
>> +	if (!((message.event & PM_EVENT_AUTO) && data->tx_in_flight)) {
>> +		set_bit(BTUSB_SUSPENDING, &data->flags);
>> +		spin_unlock_irq(&data->txlock);
>> +	} else {
>> +		spin_unlock_irq(&data->txlock);
>> +		data->suspend_count--;
>> +		return -EBUSY;
>> +	}
>> +
>> +	cancel_work_sync(&data->work);
>> +
>> +	btusb_stop_traffic(data);
>> +	mdelay(URB_CANCELING_DELAY_MS);      /*  Added by Realtek */
>> +	usb_kill_anchored_urbs(&data->tx_anchor);
>> +
>> +	return 0;
>> +}
>> +
>> +static void play_deferred(struct btusb_data *data)
>> +{
>> +	struct urb *urb;
>> +	int err;
>> +
>> +	while ((urb = usb_get_from_anchor(&data->deferred))) {
>> +
>> +		/************************************/
>> +		usb_anchor_urb(urb, &data->tx_anchor);
>> +		err = usb_submit_urb(urb, GFP_ATOMIC);
>> +		if (err < 0) {
>> +			BT_ERR("play_deferred urb %p submission failed",  urb);
>> +			kfree(urb->setup_packet);
>> +			usb_unanchor_urb(urb);
>> +		} else {
>> +			usb_mark_last_busy(data->udev);
>> +		}
>> +		usb_free_urb(urb);
>> +		/************************************/
>> +		data->tx_in_flight++;
>> +	}
>> +	mdelay(URB_CANCELING_DELAY_MS);     /*  Added by Realtek */
>
> These URBs never went over the wire. Why a delay?

Agreed.

>
>> +	usb_scuttle_anchored_urbs(&data->deferred);
>> +}
>> +
>> +static int btusb_resume(struct usb_interface *intf)
>> +{
>> +	struct btusb_data *data = usb_get_intfdata(intf);
>> +	struct hci_dev *hdev = data->hdev;
>> +	int err = 0;
>> +
>> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
>> +		return 0;
>> +
>> +
>> +	/*******************************/
>> +	RTKBT_DBG("btusb_resume data->suspend_count =%d", data->suspend_count);
>> +
>> +	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
>> +		RTKBT_DBG("btusb_resume-----bt is off, download patch");
>> +		download_patch(intf);
>> +	} else {
>> +		RTKBT_DBG("btusb_resume,----bt is on");
>> +	}
>> +	/*******************************/
>> +	if (--data->suspend_count)
>> +		return 0;
>> +
>> +	if (test_bit(BTUSB_INTR_RUNNING, &data->flags)) {
>> +		err = btusb_submit_intr_urb(hdev, GFP_NOIO);
>> +		if (err < 0) {
>> +			clear_bit(BTUSB_INTR_RUNNING, &data->flags);
>> +			goto failed;
>> +		}
>> +	}
>> +
>> +	if (test_bit(BTUSB_BULK_RUNNING, &data->flags)) {
>> +		err = btusb_submit_bulk_urb(hdev, GFP_NOIO);
>> +		if (err < 0) {
>> +			clear_bit(BTUSB_BULK_RUNNING, &data->flags);
>> +			goto failed;
>> +		}
>> +
>> +		btusb_submit_bulk_urb(hdev, GFP_NOIO);
>> +	}
>> +
>> +	if (test_bit(BTUSB_ISOC_RUNNING, &data->flags)) {
>> +		if (btusb_submit_isoc_urb(hdev, GFP_NOIO) < 0)
>> +			clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
>> +		else
>> +			btusb_submit_isoc_urb(hdev, GFP_NOIO);
>> +	}
>> +
>> +	spin_lock_irq(&data->txlock);
>> +	play_deferred(data);
>> +	clear_bit(BTUSB_SUSPENDING, &data->flags);
>> +	spin_unlock_irq(&data->txlock);
>> +	schedule_work(&data->work);
>> +
>> +	return 0;
>> +
>> +failed:
>> +	mdelay(URB_CANCELING_DELAY_MS);      /*  Added by Realtek */
>
> Again, why?

Again, no good reason.

>> +	usb_scuttle_anchored_urbs(&data->deferred);
>> +/* done: */
>> +	spin_lock_irq(&data->txlock);
>> +	clear_bit(BTUSB_SUSPENDING, &data->flags);
>> +	spin_unlock_irq(&data->txlock);
>> +
>> +	return err;
>> +}
>> +#endif
>> +
>> +static struct usb_driver btusb_driver = {
>> +	.name		= "rtk_btusb",
>> +	.probe		= btusb_probe,
>> +	.disconnect	= btusb_disconnect,
>> +#ifdef CONFIG_PM
>> +	.suspend	= btusb_suspend,
>> +	.resume		= btusb_resume,
>> +#endif
>> +	.id_table	= btusb_table,
>> +	.supports_autosuspend = 1,
>> +};
>> +
>> +static int __init btusb_init(void)
>> +{
>> +	RTKBT_DBG("Realtek Bluetooth USB driver ver %s", VERSION);
>> +
>> +	return usb_register(&btusb_driver);
>> +}
>> +
>> +static void __exit btusb_exit(void)
>> +{
>> +	usb_deregister(&btusb_driver);
>> +}
>> +
>> +module_init(btusb_init);
>> +module_exit(btusb_exit);
>> +
>> +MODULE_AUTHOR("Edward Bian <edward_bian@realsil.com.cn>");
>> +MODULE_DESCRIPTION("Realtek Bluetooth USB driver ver " VERSION);
>> +MODULE_VERSION(VERSION);
>> +MODULE_LICENSE("GPL");
>> +MODULE_FIRMWARE("rtl_bt/rtl8723a.bin");
>> +
>> +/*******************************
>> +**    Reasil patch code
>> +********************************/
>> +
>> +
>> +#include <linux/firmware.h>
>> +#include <linux/suspend.h>
>> +#include <net/bluetooth/hci.h>
>> +
>> +
>> +#define CMD_CMP_EVT		0x0e
>> +#define PKT_LEN			300
>> +#define MSG_TO			1000
>> +#define PATCH_SEG_MAX	252
>> +#define DATA_END		0x80
>> +#define DOWNLOAD_OPCODE	0xfc20
>> +#define BTOFF_OPCODE	0xfc28
>> +#define TRUE			1
>> +#define FALSE			0
>> +#define CMD_HDR_LEN		sizeof(struct hci_command_hdr)
>> +#define EVT_HDR_LEN		sizeof(struct hci_event_hdr)
>> +#define CMD_CMP_LEN		sizeof(struct hci_ev_cmd_complete)
>> +
>> +
>> +enum rtk_endpoit {
>> +	CTRL_EP = 0,
>> +	INTR_EP = 1,
>> +	BULK_EP = 2,
>> +	ISOC_EP = 3
>> +};
>> +
>> +struct patch_info {
>> +	uint16_t	prod_id;
>> +	uint16_t	lmp_sub;
>> +	char		*patch_name;
>> +	char		*config_name;
>> +	uint8_t		*fw_cache;
>> +	int		fw_len;
>> +};
>> +
>> +struct xchange_data {
>> +	struct dev_data	*dev_entry;
>> +	int pipe_in, pipe_out;
>> +	uint8_t send_pkt[PKT_LEN];
>> +	uint8_t rcv_pkt[PKT_LEN];
>
> Violations of the DMA coherency rules, fails on non-x86

I see that the buffers are not 64-bit aligned. What other conditions are necessary?

>
>> +	struct hci_command_hdr *cmd_hdr;
>> +	struct hci_event_hdr *evt_hdr;
>> +	struct hci_ev_cmd_complete *cmd_cmp;
>> +	uint8_t *req_para, *rsp_para;
>> +	uint8_t *fw_data;
>> +	int pkt_len, fw_len;
>> +};
>> +
>> +struct dev_data {
>> +	struct list_head	list_node;
>> +	struct usb_interface	*intf;
>> +	struct usb_device	*udev;
>> +	struct notifier_block	pm_notifier;
>> +	struct patch_info	*patch_entry;
>> +	struct xchange_data	xdata;
>> +	struct completion firmware_loading_complete;
>> +	const struct firmware *fw;
>> +};
>> +
>> +struct download_cp {
>> +	uint8_t index;
>> +	uint8_t data[PATCH_SEG_MAX];
>
> DMA coherency
>
>> +} __packed;
>> +
>> +struct download_rp {
>> +	uint8_t status;
>> +	uint8_t index;
>> +} __packed;
>> +
>> +
>> +static struct dev_data *dev_data_find(struct usb_interface *intf);
>> +static struct patch_info *get_patch_entry(struct usb_device *udev);
>> +static int rtkbt_pm_notify(struct notifier_block *notifier, ulong pm_event,
>> +			   void *unused);
>> +static int load_firmware(struct dev_data *dev_entry, uint8_t **buff);
>> +static void init_xdata(struct xchange_data *xdata, struct dev_data *dev_entry);
>> +static int check_fw_version(struct xchange_data *xdata);
>> +static int get_firmware(struct xchange_data *xdata);
>> +static int download_data(struct xchange_data *xdata);
>> +static int send_hci_cmd(struct xchange_data *xdata);
>> +static int rcv_hci_evt(struct xchange_data *xdata);
>> +
>> +
>> +static struct patch_info patch_table[] = {
>> +	{0, 0x1200, "rtl_bt/rtl8723a.bin", "rtk8723_bt_config", NULL, 0}
>> +};
>> +
>> +static LIST_HEAD(dev_data_list);
>> +
>> +
>> +static int patch_add(struct usb_interface *intf)
>> +{
>> +	struct dev_data	*dev_entry;
>> +	struct usb_device *udev;
>> +
>> +	RTKBT_DBG("patch_add");
>> +	dev_entry = dev_data_find(intf);
>> +	if (NULL != dev_entry)
>> +		return -1;
>> +
>> +	udev = interface_to_usbdev(intf);
>> +#if BTUSB_RPM
>> +	RTKBT_DBG("auto suspend is enabled");
>> +	usb_enable_autosuspend(udev);
>> +	pm_runtime_set_autosuspend_delay(&(udev->dev), 2000);
>
> There is no good reason to overwrite the system values.

Noted.

Thanks for the review. As suggested by you and Marcel, a complete rewrite is 
needed. I plan to use the mini-driver approach of Tedd Ho-Jeong An; however, 
your comments will be used when constructing that code.

Larry


