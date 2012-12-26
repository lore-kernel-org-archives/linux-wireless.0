Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:56587 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2LZCda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2012 21:33:30 -0500
Message-ID: <50DA61F6.2050304@lwfinger.net> (sfid-20121226_033336_435679_B890125B)
Date: Tue, 25 Dec 2012 20:33:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linville@tuxdriver.com, Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE combo
 device
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net> <1356479032.21837.107.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1356479032.21837.107.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/25/2012 05:43 PM, Ben Hutchings wrote:
> On Fri, 2012-12-21 at 02:52 +0000, Larry Finger wrote:
> [...]
>> --- /dev/null
>> +++ b/drivers/bluetooth/rtk_btusb.c
> [...]
>> +#include <linux/version.h>
>
> Not needed.
>
>> +#include <linux/pm_runtime.h>
>
> Move this up to the first group of #includes.
>
>> +#define HDEV_BUS		(hdev->bus)
>
> This is just obfuscation.
>
>> +#define USB_RPM			1
>> +
>> +#define GET_DRV_DATA(x)		hci_get_drvdata(x)
>> +
>> +
>> +#define BTUSB_RPM		0	/*1 SS enable; 0 SS disable */
>
> Run-time power management should be enabled if it works and not included
> yet if it doesn't.  This shouldn't be a compile-time option in a
> production driver.
>
>> +#define LOAD_CONFIG		0
>
> Seems to be a rather pointless development option, but if it still has
> some value then it deserves a comment.
>
>> +#define URB_CANCELING_DELAY_MS	10   /*  Added by Realtek */
>
> /* BWH 2012-12-25: Doesn't Realtek have version control to record this? */
>
> [...]
>> +/*******************************
>> +**    Reasil patch code
>> +********************************/
>
> Another weird little bit of history which no-one cares about.
>
>> +#include <linux/firmware.h>
>> +#include <linux/suspend.h>
>> +#include <net/bluetooth/hci.h>
>
> Belong at the top of the file.
>
> [...]
>> +static int rtkbt_pm_notify(struct notifier_block *notifier, ulong pm_event,
>> +                   void *unused)
>> +{
>> +       struct dev_data *dev_entry;
>> +       struct patch_info       *patch_entry;
>> +       struct usb_device *udev;
>> +
>> +       dev_entry = container_of(notifier, struct dev_data, pm_notifier);
>> +       patch_entry = dev_entry->patch_entry;
>> +       udev = dev_entry->udev;
>> +       RTKBT_DBG("rtkbt_pm_notify pm_event =%ld", pm_event);
>> +       switch (pm_event) {
>> +       case PM_SUSPEND_PREPARE:
>> +       case PM_HIBERNATION_PREPARE:
>> +               patch_entry->fw_len = load_firmware(dev_entry,
>> +                                                   &patch_entry->fw_cache);
>
> But this is done once for each device, not for each device type.  So you
> potentially load the firmware multiple times here and leak all but one.
>
> Anyway I'm not sure this caching is needed any more due to the firmware
> management improvements in 3.7.

I will modify this to make sure that the firmware is loaded only once.

> [...]
>> +static int load_firmware(struct dev_data *dev_entry, uint8_t **buff)
>> +{
>> +#if LOAD_CONFIG
>> +	const struct firmware *fw;
>> +#endif
>> +	struct usb_device *udev;
>> +	struct patch_info *patch_entry;
>> +	char *fw_name;
>> +	int fw_len = 0, ret_val;
>> +
>> +	udev = dev_entry->udev;
>> +	init_completion(&dev_entry->firmware_loading_complete);
>> +	patch_entry = dev_entry->patch_entry;
>> +	fw_name = patch_entry->patch_name;
>> +	RTKBT_DBG("Reading firmware file %s", fw_name);
>> +	ret_val = request_firmware_nowait(THIS_MODULE, 1, fw_name, &udev->dev,
>> +					  GFP_KERNEL, dev_entry, bt_fw_cb);
>> +	if (ret_val < 0)
>> +		goto fw_fail;
>> +
>> +	wait_for_completion(&dev_entry->firmware_loading_complete);
>
> What was the point of using request_firmware_nowait() then?

None. Obviously a synchronous firmware load will work as long as load_firmware() 
is not called from the probe routine, and this one will fail if it is.

>> +	if (!dev_entry->fw)
>> +		goto fw_fail;
>> +	*buff = kzalloc(dev_entry->fw->size, GFP_KERNEL);
>> +	if (NULL == *buff)
>> +		goto alloc_fail;
>> +	memcpy(*buff, dev_entry->fw->data, dev_entry->fw->size);
>> +	fw_len = dev_entry->fw->size;
>> +
>> +#if LOAD_CONFIG
>> +	release_firmware(dev_entry->fw);
>> +	fw_name = patch_entry->config_name;
>> +	ret_val = request_firmware(&fw, fw_name, &udev->dev);
>> +	if (ret_val < 0) {
>> +		fw_len = 0;
>> +		kfree(*buff);
>> +		*buff = NULL;
>> +		goto fw_fail;
>> +	}
>> +
>> +	*buff = krealloc(*buff, fw_len + fw->size, GFP_KERNEL);
>> +	if (NULL == *buff) {
>> +		fw_len = 0;
>> +		release_firmware(fw);
>> +		goto fw_fail;
>> +	}
>> +	memcpy(*buff + fw_len, fw->data, fw->size);
>> +	fw_len += fw->size;
>> +#endif
>
> It's easy to concatenate files in userland; why do it in the driver?
>
>> +alloc_fail:
>> +	release_firmware(dev_entry->fw);
>> +fw_fail:
>> +	return fw_len;
>> +}
> [...]
>

Thanks for the review. Following the previous suggestions, I am trying to use 
btusb.c for this device with the mini-driver proposed by Tedd Ho-Jeong An.

Larry

