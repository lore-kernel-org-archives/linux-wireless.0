Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54808 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2AZX6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 18:58:55 -0500
Received: by pbaa10 with SMTP id a10so1126621pba.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 15:58:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F21E1EF.1020608@lwfinger.net>
References: <CAOVbLLHPdC3XkuTs6OapNMFkSbWaRq54D5U3RDY=N4ugZfEKKQ@mail.gmail.com>
	<CAOVbLLHK=3K5KfYs7V+9PyE2joWTewuXvpS7RzU63GJS0C2=ug@mail.gmail.com>
	<CAOVbLLH_RXSzXeQ-g7--6QrUBGD63o-9-7a7NjKc=LM8UL2+GA@mail.gmail.com>
	<CAOVbLLEzuyBkQv0a238SfDrNXi3hf72Kzyjv8L=m9hokhGjx5A@mail.gmail.com>
	<CAOVbLLFcja-DV1bEq9C2U8q5eohc7O0AE=oymfjMMBOBi4D52g@mail.gmail.com>
	<4F21A01E.20105@lwfinger.net>
	<CAOVbLLHirAKiDehW=79dv1ku1pB0JdpA9SfFkLTcLk5NZctX7A@mail.gmail.com>
	<4F21E1EF.1020608@lwfinger.net>
Date: Fri, 27 Jan 2012 00:58:55 +0100
Message-ID: <CAOVbLLH7=n+9j4Wv+RZk2BOrVYwv-To=gd6aUUb9m2b_yCYhmA@mail.gmail.com> (sfid-20120127_005859_562090_9C92D8EF)
Subject: Re: Question regarding Linux RTL driver
From: Nikola Gacic <empnik@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I put some printk() functions in driver functions to print arguments
in log and then I used these same arguments in my code for firmware in
microcontroller.

Good idea with aircrack and injecting raw packets. I will check this right now.

Nikola

On Fri, Jan 27, 2012 at 12:29 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 01/26/2012 04:44 PM, Nikola Gacic wrote:
>>
>> I don't know which device is RTL8187L but this device definitely isn't
>> RTL8187B
>> because it doesn't use RTL8187B routines and field
>> rtl8187_priv.is_rtl8187b is
>> FALSE.
>
>
> If you only have the 3 endpoints, then it is an RTL8187L.
>
>> I am using MANAGED  BSS STATION  interface  for device, but I also tried
>> MONITOR
>> interface to try to capture beacons from AP on any channel. It was the
>> same, I
>> can't read anything from 0x81 endpoint because I am always getting NAK
>> packets.
>>
>> If I am not mistaken endpoint 2 is used for sending and 0x81 for
>> receiving, but
>> enumeration shows there is endpoint 3 also. Do you remember what is it
>> used for?
>
>
> No, we do not use it, and you are correct in that the endpoint with the
> address 0x81 is used for input, and the one for address 0x02 for output.
>
>> I again inspected rtl8187_start() routine and I am now inspecting
>> rtl8187_probe() again but it is much bigger and I will need more time. Is
>> the
>> rtl8187_probe() crucial for initializing device or just for getting device
>> information and allocating resources? I mean, will some false bits when
>> writing
>> to endpoint 0 cause the device to stop responding in this routine?
>
>
> The devices are very sensitive to the initialization. A mistake there could
> completely lock the device. I have never tried to use raw in/out on any of
> these devices. If I were to do what you are trying, I would use the ioctl's
> that are used by aircrack to inject packets. Those should setup the receiver
> correctly. In particular, the RX descriptor would be critical.
>
> Have you been using usbmon to look at the traffic between the CPU and the
> device?
>
> Larry
