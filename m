Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55656 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZDGEU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 00:20:27 -0400
Received: by bwz17 with SMTP id 17so2130877bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 21:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
References: <43e72e890904032115m7548f967m5020481c660c8f13@mail.gmail.com>
	 <3ace41890904041944p6cd60084ub2d05a85373459c3@mail.gmail.com>
Date: Tue, 7 Apr 2009 05:20:24 +0100
Message-ID: <3ace41890904062120o78018361x409bb3e20b735b75@mail.gmail.com> (sfid-20090407_062031_960440_FFD72D6D)
Subject: Re: zd1211 3.0.0.56 "vendor driver" - please help port to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 5, 2009 at 3:44 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Sat, Apr 4, 2009 at 5:15 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> Here is our latest "vendor driver" for the old zd1211. We much prefer
>> the in-kernel zd1211rw driver but I've heard a few users with issues
>> with some devices. Perhaps this might help a few developers help port
>> over any changes. I myself have not looked at this yet.
>>
>> http://www.kernel.org/pub/linux/kernel/people/mcgrof/zd1211/LinuxUSB_AR2524-3.0.0.56.tgz
>
> Somebody reported some problems with the 3.0.0.56 driver in the zd1211
> list a few days ago, and I was wondering where he got it from :-) ...
> anyway, if you see an obvious answer with the regression noted in this
> mail, it might worth either correcting it or something.
>
> http://sourceforge.net/mailarchive/message.php?msg_name=8c675e9b0904010320j18f49dccub37b65b81d254cb4%40mail.gmail.com
>
> I'll certainly have a look at the vendor driver sometime soon - I use
> the AP mode.
>

I have given it a try and even just adding the minimal bits
(enough to cope with David S. Miller's "wext: Emit event stream
entries correctly when compat."
change some 9 months ago) to port beyond 2.6.27(?), the result is a hard lock up
in AP mode of the machine if either 'iwpriv <dev> card_reset' is
issued, or even having a client trying to associate.

Also the message above is a hard crash problem, and seem to relate to
this paragraph
in LinuxUSB_AR2524-3.0.0.56/docs/PortingNotes.txt

-------------------
1. RX_OFFSET = 3 result in a unaligned rx buffer for usb dma.
   This is used to ensure the WLAN/ETH/IP Header is 2 bytes aligned.
   But it RX_OFFSET=0, These headers are not aligned , we neeed to
   do a copy
------------------

May I ask what's the context and origin of the file
"PortingNotes.txt"? it seems to be collection of
some doubts and/or in-coherent thoughts about some changes made, etc.
