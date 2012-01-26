Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64107 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2AZWvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 17:51:25 -0500
Received: by dadi2 with SMTP id i2so871269dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 14:51:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOVbLLHirAKiDehW=79dv1ku1pB0JdpA9SfFkLTcLk5NZctX7A@mail.gmail.com>
References: <CAOVbLLHPdC3XkuTs6OapNMFkSbWaRq54D5U3RDY=N4ugZfEKKQ@mail.gmail.com>
	<CAOVbLLHK=3K5KfYs7V+9PyE2joWTewuXvpS7RzU63GJS0C2=ug@mail.gmail.com>
	<CAOVbLLH_RXSzXeQ-g7--6QrUBGD63o-9-7a7NjKc=LM8UL2+GA@mail.gmail.com>
	<CAOVbLLEzuyBkQv0a238SfDrNXi3hf72Kzyjv8L=m9hokhGjx5A@mail.gmail.com>
	<CAOVbLLFcja-DV1bEq9C2U8q5eohc7O0AE=oymfjMMBOBi4D52g@mail.gmail.com>
	<4F21A01E.20105@lwfinger.net>
	<CAOVbLLHirAKiDehW=79dv1ku1pB0JdpA9SfFkLTcLk5NZctX7A@mail.gmail.com>
Date: Thu, 26 Jan 2012 23:51:25 +0100
Message-ID: <CAOVbLLGpEYU+WvQ=v8Obz4WmYs65wQNq4k+EB+89n-3Ao1b6NQ@mail.gmail.com> (sfid-20120126_235145_126056_340A3EA2)
Subject: Re: Question regarding Linux RTL driver
From: Nikola Gacic <empnik@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, thank you for your answer. Sorry for reporting this late. I will
send mails to mailing list too.

I don't know which device is RTL8187L but this device definitely isn't
RTL8187B because it doesn't use RTL8187B routines and field
rtl8187_priv.is_rtl8187b is FALSE.

I am using MANAGED  BSS STATION  interface  for device, but I also
tried MONITOR interface to try to capture beacons from AP on any
channel. It was the same, I can't read anything from 0x81 endpoint
because I am always getting NAK packets.

If I am not mistaken endpoint 2 is used for sending and 0x81 for
receiving, but enumeration shows there is endpoint 3 also. Do you
remember what is it used for?

I again inspected rtl8187_start() routine and I am now inspecting
rtl8187_probe() again but it is much bigger and I will need more time.
Is the rtl8187_probe() crucial for initializing device or just for
getting device information and allocating resources? I mean, will some
false bits when writing to endpoint 0 cause the device to stop
responding in this routine?

Thanks,
Nikola

On Thu, Jan 26, 2012 at 7:49 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 01/26/2012 11:37 AM, Nikola Gacic wrote:
>>
>> Hello Mr. Finger,
>>
>>     I don't know if this is the right way for contacting you but I couldn't
>> find the other way.
>>     Firstly, I want to say that I am student at School of electrical
>> Engineering in Belgrade and I am working on some embedded project where I tried
>> to use you RTL8187 Linux driver to communicate with PIC32 microcontroller over USB.
>>     I would appreciate any help with my problem. If you could spare some time
>> to read this it would be great. I have several questions. Initialization worked
>> fine I think (I get ACK packets), but when I try to finally send IN packet to
>> endpoint 0x81 I get NAK packets all the time!
>>     I checked code in microcontroller several times and, of course, maybe error
>> could be somewhere in initialization, but would that block my IN packets to
>> device? I know that PIC32 cannot work in high-speed mode, only  in full-speed,
>> but in the datasheet for this dongle it says it can work in full-speed. So I
>> want to know does USB card set its speed to full-speed automatically?
>>     I think my understanding of driver code is good so you can give me some
>> general guidelines regarding initialization if you don't want to go to
>> details.Thank you in advance.
>
>
> Contacting me is OK, but all communication should also be Cc'd to the linux-wireless mailing list.
>
> Could you please give me some more details? Is this setup as an ad-hoc wireless connection? I know that rtl8187 does not work in AP mode, but I'm not sure about ad-hoc mode, and I am unable to test that at the moment.
>
> Which device are you using - RTL8187L, or RTL8187B? The USB ID should tell that.
>
> Yes, the device will work with USB1.1 hardware, and it might even work with USB1.0, but I have never tested that.
>
> Larry
>
>
>
>
>
>
>
>
>
>
>
