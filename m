Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ammma.de ([213.83.39.131]:1174 "EHLO ammma.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755348AbZBLQPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 11:15:37 -0500
Message-ID: <20090212171524.25594h73bstakizk@neo.wg.de> (sfid-20090212_171542_152234_B6984E24)
Date: Thu, 12 Feb 2009 17:15:24 +0100
From: Jan Schneider <jan@horde.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: =?utf-8?b?R8OhYm9y?= Stefanik <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: Microcode SW error detected.
References: <20090206233134.11116cap9kcroxgc@neo.wg.de>
 <1233960318.11530.114.camel@rc-desk>
 <20090208192343.106487dmjra19g6o@neo.wg.de>
 <69e28c910902081159v1371ee70nb5e70ebdc648b54a@mail.gmail.com>
 <20090208235149.58334qon9gu98ykg@neo.wg.de>
 <20090209004532.11356srchh8hvbwg@neo.wg.de>
 <20090210121904.94213ubhpr3wui04@neo.wg.de>
 <1234289247.11530.178.camel@rc-desk>
 <20090211004526.121437a8xc0p72io@neo.wg.de>
 <20090212000957.14354bd97ikg8xc8@neo.wg.de>
 <1234405359.23593.96.camel@rc-desk> <1234421881.23593.109.camel@rc-desk>
In-Reply-To: <1234421881.23593.109.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zitat von reinette chatre <reinette.chatre@intel.com>:

> On Wed, 2009-02-11 at 18:22 -0800, reinette chatre wrote:
>> On Wed, 2009-02-11 at 15:09 -0800, Jan Schneider wrote:
>> > Zitat von Jan Schneider <jan@horde.org>:
>> >
>> > > Zitat von reinette chatre <reinette.chatre@intel.com>:
>> > >
>> > >> On Tue, 2009-02-10 at 03:19 -0800, Jan Schneider wrote:
>> > >>> Zitat von Jan Schneider <jan@horde.org>:
>> > >>>
>> > >>>> Zitat von Jan Schneider <jan@horde.org>:
>> > >>>>
>> > >>>>> Zitat von G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
>> > >>>>>
>> > >>>>>> On Sun, Feb 8, 2009 at 7:23 PM, Jan Schneider =20
>> <jan@horde.org> wrote:
>> > >>>>>>> Zitat von reinette chatre <reinette.chatre@intel.com>:
>> > >>>>>>>
>> > >>>>>>>> On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
>> > >>>>>>>>>
>> > >>>>>>>>> I've seen in a post from January that someone already ha=
d
>> > >>>>>>>>> this problem
>> > >>>>>>>>> but couldn't reproduce it.
>> > >>>>>>>>> I can't reliably reproduce, but I see this more often =20
>> than I like.
>> > >>>>>>>>> When this happens, it usually doesn't help to reload the=
 kernel
>> > >>>>>>>>> module. Sometimes it helps to use the rfkill switch thou=
gh.
>> > >>>>>>>>>
>> > >>>>>>>>> Here's a log with debug=3D0x43fff:
>> > >>>>>>>>
>> > >>>>>>>> It does not seem as though your driver is compiled with =20
>> debug support.
>> > >>>>>>>> You can confirm that by looking at the version number of =
=20
>> the driver
>> > >>>>>>>> printed when it loads ... it should have a "d" in it =20
>> like "1.2.26kds".
>> > >>>>>>>> Could you please recompile the driver with debug support
>> > >>>>>>>> (IWLWIFI_DEBUG)
>> > >>>>>>>> and rerun your test?  This will provide us with a complet=
e
>> > >>>>>>>> event log of
>> > >>>>>>>> the uCode error.
>> > >>>>>>>
>> > >>>>>>> Enabling debug didn't help:
>> > >>>>>>>
>> > >>>>>>> Feb  7 00:04:40 tank kernel: [ 2769.084395] iwlagn: Intel(=
R)
>> > >>>>>>> Wireless WiFi
>> > >>>>>>> Link
>> > >>>>>>> AGN driver for Linux, 1.3.27kds
>> > >>>>>>>
>> > >>>>>>>
>> > >>>>>>> /etc/modprobe.d/iwlagn:
>> > >>>>>>>
>> > >>>>>>> options iwlagn debug=3D0x43fff
>> > >>>>>>>
>> > >>>>>>>
>> > >>>>>>> I still get:
>> > >>>>>>>
>> > >>>>>>> Feb  8 18:40:53 tank kernel: [77584.979829] iwlagn
>> > >>>>>>> 0000:0c:00.0: Microcode
>> > >>>>>>> SW er
>> > >>>>>>> ror detected.  Restarting 0x2000000.
>> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.029747] Registered led=
 device:
>> > >>>>>>> iwl-phy0::rad
>> > >>>>>>> io
>> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.030765] Registered led=
 device:
>> > >>>>>>> iwl-phy0::ass
>> > >>>>>>> oc
>> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.031602] Registered led=
 device:
>> > >>>>>>> iwl-phy0::RX
>> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.032467] Registered led=
 device:
>> > >>>>>>> iwl-phy0::TX
>> > >>>>>>
>> > >>>>>> No - enable IWLWIFI_DEBUG in your kernel config, then rebui=
ld the
>> > >>>>>> kernel (or at least the iwlwifi modules).
>> > >>>>>
>> > >>>>> That's what I did, see the "d" in "1.2.26kds" above.
>> > >>>>
>> > >>>> Eh, that was the wrong citation of course. But it's still a "=
d" in
>> > >>>> "1.3.27kds".
>> > >>>
>> > >>> Anything else I can try to provide more information?
>> > >>
>> > >> Which hardware are you running? If it is a member of the 5k ser=
ies then
>> > >> you need to use the debug50 parameter.
>> > >
>> > > Yeah, it is, a 5300. I'll try that and get back to you.
>> >
>> > Now, this was was fun. I was just reading this mailing list, wonde=
ring
>> > why the driver still didn't crashed. When I left this mail folder,=
 it
>> > happened. :-) Did anybody sneak some semantic analysis into the la=
test
>> > code? ;-) And how it crashed! I had to reboot and it keeps crashin=
g
>> > now after a few seconds activity at most.
>> >
>> > Anyway, here is the log, I hope the attachment makes it to the lis=
t.
>> > If you need more, I have more, but I figured this should contain a=
ll
>> > important information.
>>
>> Thank you very much for this log. Do you perhaps have a log that sho=
ws a
>> bit what is going on _before_ the SYSASSERT occurs?
>>
>> I passed this log on to our hardware folks for some information. At =
this
>> time, please consider opening a bug in
>> http://www.intellinuxwireless.org/bugzilla/ with your debug logs.
>>
>
> I got an answer back promptly because you encountered a problem that =
was
> fixed recently. Could you please try with the latest wireless-testing=
?
> Patch f50f70bb8d10fa407d7d0e6f4421b928f62357e3 "iwlwifi: fix FAT chan=
nel
> config for 5000 series" should fix this problem.

Unfortunately not. I created a ticket.

Jan.

--=20
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
