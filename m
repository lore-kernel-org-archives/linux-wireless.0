Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2H2FAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 01:00:17 -0400
Received: by obbuo13 with SMTP id uo13so271269obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 22:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346166112.3412.14.camel@inferno>
References: <1346146736.3087.12.camel@inferno>
	<CAD2nsn0uis8_GnNnR2p84TkDmphPoHe9LGTn2TNNZ18tCBxkog@mail.gmail.com>
	<1346161526.3808.5.camel@inferno>
	<CAD2nsn0cyiFj-obgtZt1JDt7f9o_+Yk0i3uZAt8DweLKKPxeRQ@mail.gmail.com>
	<1346166112.3412.14.camel@inferno>
Date: Wed, 29 Aug 2012 10:30:16 +0530
Message-ID: <CAD2nsn0VEPGK5KLTL7gNid1=iTEkgzQNhopfrppwXRz2pTSbJA@mail.gmail.com> (sfid-20120829_070047_085895_E9093B14)
Subject: Re: ath9k AR9287 freeze linux system
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: =?ISO-8859-1?B?THXtcyBE7WF6IEdvbnrhbGV6?= <luis.hlodwig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Tue, Aug 28, 2012 at 8:31 PM, Luís Díaz González
<luis.hlodwig@gmail.com> wrote:
> I tested the patch, great job, thanks a lot. All works great.
> I think that coexistence between wifi and bluetooth never worked
> better. :-)

thanks a lot for reporting the issue! we really appreciate
your help for  reporting issues and testing them.

sure thanks, if you are interested in various BTCOEX stuff, you can
try AR9462 which has some enhanced  BTCOEX stuff called MCI.

>
> luis
>
>
> El mar, 28-08-2012 a las 19:28 +0530, Mohammed Shafi escribió:
>> On Tue, Aug 28, 2012 at 7:15 PM, Luís Díaz González
>> <luis.hlodwig@gmail.com> wrote:
>> > El mar, 28-08-2012 a las 19:08 +0530, Mohammed Shafi escribió:
>> >> Hi,
>> >>
>> >> On Tue, Aug 28, 2012 at 3:08 PM, Luís Díaz González
>> >> <luis.hlodwig@gmail.com> wrote:
>> >> > The last two releases compat-wireless (2012-08-26 and 2012-08-27) freeze
>> >> > my linux system.
>> >>
>> >> thanks for reporting.
>> >> *Please provide some information/call trace if you can get(you can
>> >> attach a photograph of the trace :) )
>> >> *like what did you do(sending traffic, suspend resume, keep the
>> >> station idle?) to see the freeze.
>> >> *I would try to recreate in my ubuntu 2.6.32.. kernel.
>> >> *are you using btcoex in the driver sudo modprobe ath9k btcoex_enable=1  ?
>> >
>> > Yes, I'm using btcoex, when I disabled it, all works again.
>>
>> please try the attached patch sent today,
>> http://comments.gmane.org/gmane.linux.kernel.wireless.general/96629
>> you have go to your compat-wireless folder
>> cd compat-wireless...
>> then do patch -p1 <  /home/myname/fix-bt.patch
>>
>> assuming the patch is in /home/myname/fix-bt.patch
>>
>> do
>> make clean && make && sudo make install
>>
>> sudo make unload
>> sudo modprobe -v ath9k btcoex_enable=1
>>
>>
>>
>> >
>> >>
>> >>
>> >> >
>> >> > I'm not a developer, I'm a simple user
>> >> >
>> >> > Debian Squeeze 2.6.32
>> >> > wireless card  AR9287
>> >> >
>> >> >
>> >> > thanks,
>> >> > luis
>> >> >
>> >> >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >>
>> >>
>> >
>> >
>>
>>
>>
>
>



-- 
thanks,
shafi
