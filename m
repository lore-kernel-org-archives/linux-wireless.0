Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33819 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbdELI2S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 04:28:18 -0400
Received: by mail-pg0-f54.google.com with SMTP id u28so27071085pgn.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 01:28:18 -0700 (PDT)
Subject: Re: [v2 05/11] rsi: Remove unnecessary buffer allocation
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
 <1494336614-2107-6-git-send-email-amit.karwar@redpinesignals.com>
 <87fugbs0x5.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <72458624-9a4d-bb20-2bdb-1a8f4c53ca6e@broadcom.com> (sfid-20170512_102836_403721_FD0F71B1)
Date: Fri, 12 May 2017 10:28:09 +0200
MIME-Version: 1.0
In-Reply-To: <87fugbs0x5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/11/2017 8:28 PM, Kalle Valo wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
> 
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> In functions usb read register and usb write register, dynamic allocation
>> of 4 bytes is used. This is removed as it is unncessary for local variable
>> and for such small data.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> ---
>>   drivers/net/wireless/rsi/rsi_91x_usb.c | 18 ++++--------------
>>   1 file changed, 4 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
>> index 73b01a8..8eb7407 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
>> @@ -157,12 +157,8 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
>>   			    u16 *value,
>>   			    u16 len)
>>   {
>> -	u8 *buf;
>> -	int status = -ENOMEM;
>> -
>> -	buf  = kmalloc(0x04, GFP_KERNEL);
>> -	if (!buf)
>> -		return status;
>> +	u8 buf[4];
>> +	int status;
>>   
>>   	status = usb_control_msg(usbdev,
>>   				 usb_rcvctrlpipe(usbdev, 0),
> 
> Recently I got a patch to orinoco_usb which did exactly the opposite
> (unless I'm missing something):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2f6ae79cb04bb7f9b4be3f1c32b6fda35bf976bc
> 
> The documentation for usb_control_msg() does not mention anything if
> it's possible to use stack memory, but AFAIU it's not possible to use
> stack memory with DMA. Can anyone clarify?

After private message I sent to Kalle here my public response :-p
According to Greg this has been a USB core requirement for a long, long 
time (see below).

Regards,
Arend

[1] http://marc.info/?l=linux-kernel&m=149391173014176&w=2

-------- Forwarded Message --------
Subject: Re: [PATCH] i2c: i2c-tiny-usb: fix buffer not being DMA capable
Date: Thu, 4 May 2017 08:27:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
CC: Sebastian Reichel <sre@kernel.org>, Till Harbaum <till@harbaum.org>, 
Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org, 
linux-kernel@vger.kernel.org, # Kernel 4 . 9+ <stable@vger.kernel.org>

On Thu, May 04, 2017 at 02:56:32PM +0200, Sebastian Reichel wrote:
 > The i2c-tiny-usb driver generates the following trace and fails to
 > read or write data on a v4.9 or newer kernels. This patch avoids the
 > problem by allocating a DMA capable buffer for data transfer.

[snip]

This has been a USB core requirement since the 2.2 days, it's only since
4.9 that most people have started to notice this.  So backporting it to
anything that it can go to is best to have happen :)

 > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
 > ---
 >  drivers/i2c/busses/i2c-tiny-usb.c | 19 +++++++++++++++----
 >  1 file changed, 15 insertions(+), 4 deletions(-)
