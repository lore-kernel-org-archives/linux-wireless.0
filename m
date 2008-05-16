Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:27402 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYEPOao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:30:44 -0400
Received: by yw-out-2324.google.com with SMTP id 9so524898ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 07:30:39 -0700 (PDT)
Message-ID: <69e28c910805160730u73f4910bpfeec8eca8af3e165@mail.gmail.com> (sfid-20080516_163047_679598_E2A78FCF)
Date: Fri, 16 May 2008 16:30:39 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Martin Dubuc" <martind1111@gmail.com>
Subject: Re: [ipw3945-devel] Monitor mode on boot
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910805160728x5c7305f1h6512af1506e4f08b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7a0107ba0805151404o778a09ddj522fffa3edbeec6@mail.gmail.com>
	 <69e28c910805160316q7c1b869an7fd554979ea260b8@mail.gmail.com>
	 <7a0107ba0805160627l55f53b04r69a32e1bba36ecb6@mail.gmail.com>
	 <69e28c910805160703j4fef73e8x2c357f91d4b43ea5@mail.gmail.com>
	 <69e28c910805160728x5c7305f1h6512af1506e4f08b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 4:28 PM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> On Fri, May 16, 2008 at 4:03 PM, Stefanik G=E1bor <netrolller.3d@gmai=
l.com> wrote:
>> On Fri, May 16, 2008 at 3:27 PM, Martin Dubuc <martind1111@gmail.com=
> wrote:
>>>
>>> You are right pointing out that it is possible to perform monitor m=
ode
>>> configuration using startup scripts. However, to fit nicely in exis=
ting
>>> frameworks, such as the ones available from Fedora, it would be nic=
e that
>>> the driver be enhanced. Madwifi allows users to put a configuration=
 like
>>> this one in the modprobe.conf.:
>>>
>>> options ath_pci autocreate=3Dmonitor
>>>
>>> The nice thing about such a configuration is that it decouples the =
device
>>> type configuration from the interface management function. One does=
 not need
>>> to worry which interface (wlan0, wlan1, wlan2, etc.) a device will =
come up
>>> on, the system configures any device of a given type using a common=
 set of
>>> configuration. For systems that have only one Wi-Fi device, your me=
thod is
>>> as good as this one, but for systems that have more than one Wi-Fi =
device,
>>> some of them coming off and on while the system is running, possibl=
y using
>>> different interface names, the modprobe.conf solution is better.
>>>
>>> Martin
>>
>>
>> This might better be done in the stack, rather than the driver. This=
 way,
>> all drivers would get this functionality. CCing the linux-wireless m=
ailing
>> list.
>> Also, since an userspace solution might be preferred by Linville and=
 the
>> other wireless maintainers, it might be wise to add an "aggregate de=
vice" or
>> a "supermaster" which can be targeted by iw so that all devices gove=
rned by
>> that driver get a new interface.
>> Alternatively, a script can be made that creates a monitor interface=
 on monX
>> or rtapX for all wmasterX devices. This is equivalent to madwifi's s=
olution,
>> except that it's userspace, which is preferred now.
>>
>> --
>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-=
)
>
> BTW, here is a script that automatically creates a "monX" interface
> for every "wmasterX" master device it encounters:
>
> #!/bin/sh
> for a in $(iwconfig 2>&1 | grep wmaster | sed -e 's/wmaster//' | cut =
-b 1); do
> iw dev wmaster$a interface add mon$a type monitor
> ifconfig mon$a up
> done
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>

Oops... this is enough:
#!/bin/sh
for a in $(iwconfig 2>&1 | grep wmaster | cut -b 8); do
iw dev wmaster$a interface add mon$a type monitor
ifconfig mon$a up
done

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
