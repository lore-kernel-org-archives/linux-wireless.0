Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab2BMX2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 18:28:25 -0500
Received: by iacb35 with SMTP id b35so5164948iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Feb 2012 15:28:25 -0800 (PST)
Message-ID: <4F399C96.3090701@lwfinger.net> (sfid-20120214_002829_445970_18CB49F7)
Date: Mon, 13 Feb 2012 17:28:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	zajec5@gmail.com
Subject: Re: [RFC/RFT 2/5] b43: Load firmware from a work queue and not from
 the probe routine
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> <1329161826-11135-3-git-send-email-Larry.Finger@lwfinger.net> <CAGRGNgVC4moLEnBKvjmPpnuSxs-yppGVx5Bn+0FhtwGAo_JrEQ@mail.gmail.com>
In-Reply-To: <CAGRGNgVC4moLEnBKvjmPpnuSxs-yppGVx5Bn+0FhtwGAo_JrEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2012 05:06 PM, Julian Calaby wrote:
> Hi Larry,
>
> On Tue, Feb 14, 2012 at 06:37, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> Recent changes in udev are causing problems for drivers that load firmware
>> from the probe routine. As b43 has such a structure, it must be changed.
>> As this driver loads more than 1 firmware file, changing to the asynchronous routine
>> request_firmware_nowait() would be complicated. In this implementation, the probe
>> routine starts a delayed_work queue that calls the firmware loading routines when
>> the delay (1 sec) expires..
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>> index 835462d..532ba79 100644
>> --- a/drivers/net/wireless/b43/b43.h
>> +++ b/drivers/net/wireless/b43/b43.h
>> @@ -932,6 +932,9 @@ struct b43_wl {
>>         /* Flag that implement the queues stopping. */
>>         bool tx_queue_stopped[B43_QOS_QUEUE_NUM];
>>
>> +       /* delayed firmware loading */
>> +       struct delayed_work firmware_load;
>> +
>>         /* The device LEDs. */
>>         struct b43_leds leds;
>>
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index 1b540d2..903e1ea 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -2427,9 +2433,17 @@ static int b43_request_firmware(struct b43_wldev *dev)
>>         b43_print_fw_helptext(dev->wl, 1);
>>         err = -ENOENT;
>
> Should something be done here rather than immediately going to
> register the card with ieee80211?

I don't think so. When firmware is loaded from the probe routine, it registers 
the card as the next step. I did miss the step that registers the leds - that 
has now been added.

Larry

>
>> +start_ieee80211:
>> +       err = ieee80211_register_hw(wl->hw);
>> +       if (err)
>> +               goto err_one_core_detach;
>> +       goto out;
>> +
>> +err_one_core_detach:
>> +       b43_one_core_detach(dev->dev);
>> +
>>   out:
>>         kfree(ctx);
>> -       return err;
>>   }
>>
>>   static int b43_upload_microcode(struct b43_wldev *dev)
>
> Thanks,
>

