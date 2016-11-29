Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f179.google.com ([209.85.210.179]:35953 "EHLO
        mail-wj0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbcK2Jpu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 04:45:50 -0500
Received: by mail-wj0-f179.google.com with SMTP id qp4so139884359wjc.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 01:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net>
References: <20161128042757.8609-1-anthony.romano@coreos.com> <a433d14f-d762-fc53-ba7a-da616ac670ca@gmx.net>
From: Anthony Romano <anthony.romano@coreos.com>
Date: Tue, 29 Nov 2016 01:45:48 -0800
Message-ID: <CAENtvd7sTN0HRkY4z+f8wozEk_AQDipX9nNV7r-Sbyzh4tt9pA@mail.gmail.com> (sfid-20161129_104556_070566_5D1E905C)
Subject: Re: [PATCH] ath9k_htc: don't use HZ for usb msg timeouts
To: Oleksij Rempel <fishor@gmx.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

I put 4 ar9271's on a 4 port hub into monitor mode for you and all
interfaces are simultaneously collecting packets. My cheap USB power
meter reads 4.37v@650mA between the hub and the host, so it's pushing
the limit but appears stable.

On Mon, Nov 28, 2016 at 7:34 AM, Oleksij Rempel <fishor@gmx.net> wrote:
> Hi Anthony,
>
> Am 28.11.2016 um 05:27 schrieb Anthony Romano:
>> The usb_*_msg() functions expect a timeout in msecs but are given HZ,
>> which is ticks per second. If HZ=100, firmware download often times out
>> when there is modest USB utilization and the device fails to initialize.
>
>> Replaces HZ in usb_*_msg timeouts with 1000 msec since HZ is one second
>> for timeouts in jiffies.
>
> wow..
> This fix allow you use 4 adapter at same time?
>
>> Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/hif_usb.c | 9 +++++----
>>  drivers/net/wireless/ath/ath9k/hif_usb.h | 2 ++
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> index e1c338cb9cb5..de2d212f39ec 100644
>> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
>> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> @@ -997,7 +997,8 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>>               err = usb_control_msg(hif_dev->udev,
>>                                     usb_sndctrlpipe(hif_dev->udev, 0),
>>                                     FIRMWARE_DOWNLOAD, 0x40 | USB_DIR_OUT,
>> -                                   addr >> 8, 0, buf, transfer, HZ);
>> +                                   addr >> 8, 0, buf, transfer,
>> +                                   USB_MSG_TIMEOUT);
>>               if (err < 0) {
>>                       kfree(buf);
>>                       return err;
>> @@ -1020,7 +1021,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>>       err = usb_control_msg(hif_dev->udev, usb_sndctrlpipe(hif_dev->udev, 0),
>>                             FIRMWARE_DOWNLOAD_COMP,
>>                             0x40 | USB_DIR_OUT,
>> -                           firm_offset >> 8, 0, NULL, 0, HZ);
>> +                           firm_offset >> 8, 0, NULL, 0, USB_MSG_TIMEOUT);
>>       if (err)
>>               return -EIO;
>>
>> @@ -1249,7 +1250,7 @@ static int send_eject_command(struct usb_interface *interface)
>>
>>       dev_info(&udev->dev, "Ejecting storage device...\n");
>>       r = usb_bulk_msg(udev, usb_sndbulkpipe(udev, bulk_out_ep),
>> -             cmd, 31, NULL, 2000);
>> +             cmd, 31, NULL, 2 * USB_MSG_TIMEOUT);
>>       kfree(cmd);
>>       if (r)
>>               return r;
>> @@ -1314,7 +1315,7 @@ static void ath9k_hif_usb_reboot(struct usb_device *udev)
>>               return;
>>
>>       ret = usb_interrupt_msg(udev, usb_sndintpipe(udev, USB_REG_OUT_PIPE),
>> -                        buf, 4, NULL, HZ);
>> +                        buf, 4, NULL, USB_MSG_TIMEOUT);
>>       if (ret)
>>               dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
>> index 7c2ef7ecd98b..7846916aa01d 100644
>> --- a/drivers/net/wireless/ath/ath9k/hif_usb.h
>> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
>> @@ -71,6 +71,8 @@ extern int htc_use_dev_fw;
>>  #define USB_REG_IN_PIPE   3
>>  #define USB_REG_OUT_PIPE  4
>>
>> +#define USB_MSG_TIMEOUT 1000 /* (ms) */
>> +
>>  #define HIF_USB_MAX_RXPIPES 2
>>  #define HIF_USB_MAX_TXPIPES 4
>>
>>
>
>
