Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:37125 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaGILtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 07:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <53BAB7F7.3060705@rempel-privat.de>
References: <Pine.LNX.4.44L0.1407041225290.6607-100000@netrider.rowland.org>
	<53B6DC5F.3090304@rempel-privat.de>
	<CAE4k238pWc4nB1S1S7OJBVh-_bUnO+D6uQJ98wMTk-E7FZ4+yw@mail.gmail.com>
	<53BAB7F7.3060705@rempel-privat.de>
Date: Wed, 9 Jul 2014 13:49:03 +0200
Message-ID: <CAE4k238cFpA-y3T9G3+1MXun8fv8jt=6TJv8k9ZJuav9f5Av9A@mail.gmail.com> (sfid-20140709_134912_583009_BAE52A6A)
Subject: Re: ath9k -> bogus usb xfer on at91
From: Anders Darander <anders.darander@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 July 2014 17:08, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 07.07.2014 15:40, schrieb Anders Darander:
>> On 4 July 2014 18:54, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>> Am 04.07.2014 18:30, schrieb Alan Stern:
>>>> On Fri, 4 Jul 2014, Anders Darander wrote:
>>>>> ~# usb 1-1: new full-speed USB device number 3 using at91_ohci
>>>>> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
>>>>> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>>>>> -----------[ cut here ]-----------
>>>>> WARNING: CPU: 0 PID: 93 at
>>>>> /mnt/cs-builds/anders/oe-build/build-ccu/tmp-eglibc/work/ccu-oe-linux-gnueabi/linux-yocto-ccu/3.14+gitAUTOINC+7b03bd3dfd-r0/linux/drivers/usb/core/urb.c:450
>>>>> usb_submit_urb+0x2ac/0x460()
>>>>> usb 1-1: BOGUS urb xfer, pipe 1 != type 3
>>
>>>>
>>>> I can't tell exactly where the fault is, but this message means that an
>>>> URB was submitted for a bulk endpoint with a pipe of type
>>>> PIPE_INTERRUPT.
>>>
>>> Then kernel driver and firmware should be updated. There was some
>>> Bulk/Interrupt issues which was fixed last year.
>>
>> Any pointers to the bulk/interrupt issues? Was it a general issue, or
>> related either to
>> at91-ohci or ar9271?
>
> It is primary ar9271 issue. The interrupt EP has different response time
> on different host controllers. Initially as workaround ath9k was forcing
> Bulk traffic on Interrupt EP. But this workaround is working with some
> host controllers and completely fails on others. So i removed it. The
> patches are included in master kernel branch and git firmware source.

Thanks for the comments!
I'll take a look at it, though it might have to be scheduled after the
upcoming vacations...

I'll sure try to look into those workarounds (and your removal of
those). I guess that
it's the firmware in open-ath9-htc-firmware you're talking about.

>>
>> As far as I've been able to find out, I've got the latest firmware
>> (check again with linux-firmware).
>> I've also tried with the master from open-ath9k-htc-firmware.
>>
>>> I hope this HW will not be used as AP.
>>
>> Is this based on the use of at91- SoC, or based on the ar9271?
>
> ar9271 can work as AP with limit on 8 stations but according to user
> reports it fails even with one station on at91
>
>> The primary use case is to run as a client, though there will likely
>> be some instances where it'll
>> function as a AP. (Though primarily for M2M communications), thus
>> pretty low traffic.
>
> For AP usually should be created monitor mode interface for receiving
> and transmitting management frames. Depending on location and STAs or
> APs working on same channel, you will get a lot of traffic on this usb
> interface.
> Some users reported huge traffic drops on at91 based APs. Since i can't
> debug it, i can't promise that it will be fixed any time soon.

Again, thanks for the information.
I think I've got a much better understanding of the issues (both those that I've
seen, and those that you have mentioned / explained). I'll see when/what I can
look into this and what I can find out.

Cheers,
Anders

-- 
Anders Darander
EPO guidelines 1978: "If the contribution to the known art resides
solely in a computer program then the subject matter is not
patentable in whatever manner it may be presented in the claims."
