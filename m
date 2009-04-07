Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:33184 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbZDGFev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 01:34:51 -0400
Received: by gxk4 with SMTP id 4so5515348gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 22:34:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	<3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
	<3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 6 Apr 2009 22:34:34 -0700
Message-ID: <43e72e890904062234m3d572f36t1aa7fefa5f78ae74@mail.gmail.com> (sfid-20090407_073651_763338_7E51C453)
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 6, 2009 at 9:20 PM, Hin-Tak Leung <hintak.leung@gmail.com> =
wrote:
> On Sun, Apr 5, 2009 at 3:44 AM, Hin-Tak Leung <hintak.leung@gmail.com=
> wrote:
>> On Sat, Apr 4, 2009 at 5:15 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> Here is our latest "vendor driver" for the old zd1211. We much pref=
er
>>> the in-kernel zd1211rw driver but I've heard a few users with issue=
s
>>> with some devices. Perhaps this might help a few developers help po=
rt
>>> over any changes. I myself have not looked at this yet.
>>>
>>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/zd1211/LinuxUS=
B_AR2524-3.0.0.56.tgz
>>
>> Somebody reported some problems with the 3.0.0.56 driver in the zd12=
11
>> list a few days ago, and I was wondering where he got it from :-) ..=
=2E
>> anyway, if you see an obvious answer with the regression noted in th=
is
>> mail, it might worth either correcting it or something.
>>
>> http://sourceforge.net/mailarchive/message.php?msg_name=3D8c675e9b09=
04010320j18f49dccub37b65b81d254cb4%40mail.gmail.com
>>
>> I'll certainly have a look at the vendor driver sometime soon - I us=
e
>> the AP mode.
>>
>
> I have given it a try and even just adding the minimal bits
> (enough to cope with David S. Miller's "wext: Emit event stream
> entries correctly when compat."
> change some 9 months ago) to port beyond 2.6.27(?), the result is a h=
ard lock up
> in AP mode of the machine if either 'iwpriv <dev> card_reset' is
> issued, or even having a client trying to associate.
>
> Also the message above is a hard crash problem, and seem to relate to
> this paragraph
> in LinuxUSB_AR2524-3.0.0.56/docs/PortingNotes.txt
>
> -------------------
> 1. RX_OFFSET =3D 3 result in a unaligned rx buffer for usb dma.
> =C2=A0 This is used to ensure the WLAN/ETH/IP Header is 2 bytes align=
ed.
> =C2=A0 But it RX_OFFSET=3D0, These headers are not aligned , we neeed=
 to
> =C2=A0 do a copy
> ------------------
>
> May I ask what's the context and origin of the file
> "PortingNotes.txt"?

Not sure, I wanted to get this out to help those who are interested in
porting changes over (if any) to zd1211rw. If you find nothing useful
from it please simply disregard it.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
