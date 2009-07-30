Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:60847 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZG3DvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 23:51:21 -0400
Received: by fxm28 with SMTP id 28so383061fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 20:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090729T120228-576@post.gmane.org>
References: <loom.20090729T111851-320@post.gmane.org>
	 <200907291350.27426.hs4233@mail.mn-solutions.de>
	 <loom.20090729T120228-576@post.gmane.org>
Date: Thu, 30 Jul 2009 04:43:05 +0100
Message-ID: <3ace41890907292043rad37b63y12cacfeb713dc575@mail.gmail.com>
Subject: Re: zd1211rw couldn't load firmware. Error number -145 with Kernel
	2.6.30
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Mladen Horvat <acid-burn@opendreambox.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 1:08 PM, Mladen
Horvat<acid-burn@opendreambox.org> wrote:
> Holger Schurig <hs4233@...> writes:
>
>>
>> > [  415.271000] usb 1-1: upload_firmware()
>> > firmware device id 0x4810 is equal to the actual device id
>>
>> Looks like your firmware could be successfully loaded and checked
>> by the driver.
>>
>> > [  416.350000] usb 1-1: USB control request for firmware
>> > upload failed. Error number -145
>>
>> Looks like an URB (USB request block) couldn't transferred to the
>> device. As you speak about an embedded device: are you sure that
>> your USB hardware works correctly?
>>
>
>
> Hello Holger,
>
> thanks for your fast answer.
>
> I hope to be sure that the usb hardware works correctly.
> As i said, the same stb only booted with a rt73usb wlan stick attached has no
> problems with the firmware upload and also wpa-supplicant connection and
> everything works on wlan0.  only problem are these two zd1211b usb sticks in the
> zd1211rw driver.
>
> the same stb running a kernel 2.6.12 and the original vendor driver 2.22.00
> works without problems..
>
> so i think i can exclude a hardware bug on the usb/stb side.
>
> Hope this helps.
> If any other logs are needed i will provide them.
>
>
> Regards
>
> Mladen
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I noticed you have a particularly slow CPU (33MHz?)... the vendor
driver has some preculiar coding to interrupt some operations to
prevent deadlocks; I wonder if the rw driver inherit that? One of the
patches in my patch set for the vendor driver put a delay right after
firmware load;
it might be appropriate to add something similiar to the rw driver.
