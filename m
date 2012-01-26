Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41260 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2AZX3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 18:29:55 -0500
Received: by ghrr11 with SMTP id r11so544071ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 15:29:54 -0800 (PST)
Message-ID: <4F21E1EF.1020608@lwfinger.net> (sfid-20120127_002958_552409_8DDF53E7)
Date: Thu, 26 Jan 2012 17:29:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nikola Gacic <empnik@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question regarding Linux RTL driver
References: <CAOVbLLHPdC3XkuTs6OapNMFkSbWaRq54D5U3RDY=N4ugZfEKKQ@mail.gmail.com> <CAOVbLLHK=3K5KfYs7V+9PyE2joWTewuXvpS7RzU63GJS0C2=ug@mail.gmail.com> <CAOVbLLH_RXSzXeQ-g7--6QrUBGD63o-9-7a7NjKc=LM8UL2+GA@mail.gmail.com> <CAOVbLLEzuyBkQv0a238SfDrNXi3hf72Kzyjv8L=m9hokhGjx5A@mail.gmail.com> <CAOVbLLFcja-DV1bEq9C2U8q5eohc7O0AE=oymfjMMBOBi4D52g@mail.gmail.com> <4F21A01E.20105@lwfinger.net> <CAOVbLLHirAKiDehW=79dv1ku1pB0JdpA9SfFkLTcLk5NZctX7A@mail.gmail.com>
In-Reply-To: <CAOVbLLHirAKiDehW=79dv1ku1pB0JdpA9SfFkLTcLk5NZctX7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 04:44 PM, Nikola Gacic wrote:
> I don't know which device is RTL8187L but this device definitely isn't RTL8187B
> because it doesn't use RTL8187B routines and field rtl8187_priv.is_rtl8187b is
> FALSE.

If you only have the 3 endpoints, then it is an RTL8187L.

> I am using MANAGED  BSS STATION  interface  for device, but I also tried MONITOR
> interface to try to capture beacons from AP on any channel. It was the same, I
> can't read anything from 0x81 endpoint because I am always getting NAK packets.
>
> If I am not mistaken endpoint 2 is used for sending and 0x81 for receiving, but
> enumeration shows there is endpoint 3 also. Do you remember what is it used for?

No, we do not use it, and you are correct in that the endpoint with the address 
0x81 is used for input, and the one for address 0x02 for output.

> I again inspected rtl8187_start() routine and I am now inspecting
> rtl8187_probe() again but it is much bigger and I will need more time. Is the
> rtl8187_probe() crucial for initializing device or just for getting device
> information and allocating resources? I mean, will some false bits when writing
> to endpoint 0 cause the device to stop responding in this routine?

The devices are very sensitive to the initialization. A mistake there could 
completely lock the device. I have never tried to use raw in/out on any of these 
devices. If I were to do what you are trying, I would use the ioctl's that are 
used by aircrack to inject packets. Those should setup the receiver correctly. 
In particular, the RX descriptor would be critical.

Have you been using usbmon to look at the traffic between the CPU and the device?

Larry
