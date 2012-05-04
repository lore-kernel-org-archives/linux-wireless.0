Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58971 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2EDG6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 02:58:32 -0400
Received: by wibhj6 with SMTP id hj6so1064219wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 23:58:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120504063644.GA2912@ritirata.org>
References: <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
	<20120502153914.GA9285@tuxdriver.com>
	<20120502162100.GA2528@ritirata.org>
	<20120503065351.GB2307@ritirata.org>
	<CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
	<CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
	<20120503200948.GC11326@ritirata.org>
	<CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
	<20120504002136.GA4201@ritirata.org>
	<CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
	<20120504063644.GA2912@ritirata.org>
Date: Fri, 4 May 2012 09:58:30 +0300
Message-ID: <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com> (sfid-20120504_085836_524514_57378356)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can't be with my patch, is it ?

Emmanuel Grumbach
egrumbach@gmail.com


On Fri, May 4, 2012 at 9:36 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> ops... my fault
>
> On Fri, May 04, 2012 at 08:11:54 +0300, Emmanuel Grumbach wrote:
>> nothing attaced
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>>
>>
>> On Fri, May 4, 2012 at 3:21 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> > mhmmm I attached dmesg again. Do you really need messages?
>> >
>> > Cheers,
>> >
>> >
>> > On Thu, May 03, 2012 at 11:17:14 +0300, Emmanuel Grumbach wrote:
>> >> ooops
>> >>
>> >>
>> >> here it is
>> >>
>> >>
>> >>
>> >> Emmanuel Grumbach
>> >> egrumbach@gmail.com
>> >>
>> >>
>> >> On Thu, May 3, 2012 at 11:09 PM, Antonio Quartulli <ordex@autistici.org> wrote:
>> >> > On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
>> >> >> Hi
>> >> >>
>> >> >> can you please apply the patch attached against wireless-testing ?
>> >> >
>> >> > which patch? If you refer to the patch attached to the bugreport, it doesn't
>> >> > apply on wireless-testing.
>> >> >
>> >> >
>> >> > Cheers,
>> >> >
>> >> >>
>> >> >> You will have quite a lot of prints, so you will probably need to send
>> >> >> /var/log/syslog or messages
>> >> >>
>> >> >>
>> >> >> Thanks
>> >> >>
>> >> >> Emmanuel Grumbach
>> >> >> egrumbach@gmail.com
>> >> >>
>> >> >>
>> >> >> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> >> >> > Please enable CONFIG_FRAME_POINTERS
>> >> >> > Emmanuel Grumbach
>> >> >> > egrumbach@gmail.com
>> >> >> >
>> >> >> >
>> >> >> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> >> >> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
>> >> >> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
>> >> >> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
>> >> >> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
>> >> >> >>> > > <meenakshi.venkataraman@intel.com> wrote:
>> >> >> >>> > > > Hi Antonio,
>> >> >> >>> > > >
>> >> >> >>> > > >>> it seems so. It happens at least once at boot time.
>> >> >> >>> > > >>> I will try wireless-testing and see what happens. Then I will apply your patch.
>> >> >> >>> > > >>
>> >> >> >>> > > >>The problem is there either with wireless-testing and with
>> >> >> >>> > > >>wireless-testing+your_patch.
>> >> >> >>> > > >>
>> >> >> >>> > > >>If it can somehow help, I also got several stack trace regarding intel_iova
>> >> >> >>> > > >>functions. But then the I got kernel panic and I was not able to copy the
>> >> >> >>> > > >>messages.
>> >> >> >>> > > >
>> >> >> >>> > > > [MV] Depending on how you set it up, perhaps the stack trace was saved in one of the syslog files in /var/log/...
>> >> >> >>> > > >
>> >> >> >>> > > > Thanks!
>> >> >> >>> > > > Meenakshi
>> >> >> >>> > > >
>> >> >> >>> > >
>> >> >> >>> > > Can you please re-run with debug=1 and send the whole log ?
>> >> >> >>> > > This will give a better indication on when the issue occurs.
>> >> >> >>> >
>> >> >> >>> > Does this help?
>> >> >> >>> >
>> >> >> >>> >     https://bugzilla.redhat.com/show_bug.cgi?id=815998#c18
>> >> >> >>>
>> >> >> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help but this time I got
>> >> >> >>> the WARNING even with debug=1. Log is attached.
>> >> >> >>>
>> >> >> >>
>> >> >> >>
>> >> >> >> Is there any particular kernel debugging option I could enable to make the log
>> >> >> >> more verbose?
>> >> >> >>
>> >> >> >>
>> >> >> >> Cheers,
>> >> >> >>
>> >> >> >>
>> >> >> >>
>> >> >> >> --
>> >> >> >> Antonio Quartulli
>> >> >> >>
>> >> >> >> ..each of us alone is worth nothing..
>> >> >> >> Ernesto "Che" Guevara
>> >> >
>> >> > --
>> >> > Antonio Quartulli
>> >> >
>> >> > ..each of us alone is worth nothing..
>> >> > Ernesto "Che" Guevara
>> >
>> >
>> >
>> > --
>> > Antonio Quartulli
>> >
>> > ..each of us alone is worth nothing..
>> > Ernesto "Che" Guevara
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Antonio Quartulli
>
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara
