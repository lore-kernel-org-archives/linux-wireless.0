Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZBLGyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 01:54:11 -0500
Subject: Re: iwlagn: Microcode SW error detected.
From: reinette chatre <reinette.chatre@intel.com>
To: Jan Schneider <jan@horde.org>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1234405359.23593.96.camel@rc-desk>
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
	 <1234405359.23593.96.camel@rc-desk>
Content-Type: text/plain; charset=utf-8
Date: Wed, 11 Feb 2009 22:58:01 -0800
Message-Id: <1234421881.23593.109.camel@rc-desk> (sfid-20090212_075423_328067_F1B495FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-11 at 18:22 -0800, reinette chatre wrote:
> On Wed, 2009-02-11 at 15:09 -0800, Jan Schneider wrote:
> > Zitat von Jan Schneider <jan@horde.org>:
> >=20
> > > Zitat von reinette chatre <reinette.chatre@intel.com>:
> > >
> > >> On Tue, 2009-02-10 at 03:19 -0800, Jan Schneider wrote:
> > >>> Zitat von Jan Schneider <jan@horde.org>:
> > >>>
> > >>>> Zitat von Jan Schneider <jan@horde.org>:
> > >>>>
> > >>>>> Zitat von G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> > >>>>>
> > >>>>>> On Sun, Feb 8, 2009 at 7:23 PM, Jan Schneider <jan@horde.org=
> wrote:
> > >>>>>>> Zitat von reinette chatre <reinette.chatre@intel.com>:
> > >>>>>>>
> > >>>>>>>> On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
> > >>>>>>>>>
> > >>>>>>>>> I've seen in a post from January that someone already had
> > >>>>>>>>> this problem
> > >>>>>>>>> but couldn't reproduce it.
> > >>>>>>>>> I can't reliably reproduce, but I see this more often tha=
n I like.
> > >>>>>>>>> When this happens, it usually doesn't help to reload the =
kernel
> > >>>>>>>>> module. Sometimes it helps to use the rfkill switch thoug=
h.
> > >>>>>>>>>
> > >>>>>>>>> Here's a log with debug=3D0x43fff:
> > >>>>>>>>
> > >>>>>>>> It does not seem as though your driver is compiled with de=
bug support.
> > >>>>>>>> You can confirm that by looking at the version number of t=
he driver
> > >>>>>>>> printed when it loads ... it should have a "d" in it like =
"1.2.26kds".
> > >>>>>>>> Could you please recompile the driver with debug support
> > >>>>>>>> (IWLWIFI_DEBUG)
> > >>>>>>>> and rerun your test?  This will provide us with a complete
> > >>>>>>>> event log of
> > >>>>>>>> the uCode error.
> > >>>>>>>
> > >>>>>>> Enabling debug didn't help:
> > >>>>>>>
> > >>>>>>> Feb  7 00:04:40 tank kernel: [ 2769.084395] iwlagn: Intel(R=
)
> > >>>>>>> Wireless WiFi
> > >>>>>>> Link
> > >>>>>>> AGN driver for Linux, 1.3.27kds
> > >>>>>>>
> > >>>>>>>
> > >>>>>>> /etc/modprobe.d/iwlagn:
> > >>>>>>>
> > >>>>>>> options iwlagn debug=3D0x43fff
> > >>>>>>>
> > >>>>>>>
> > >>>>>>> I still get:
> > >>>>>>>
> > >>>>>>> Feb  8 18:40:53 tank kernel: [77584.979829] iwlagn
> > >>>>>>> 0000:0c:00.0: Microcode
> > >>>>>>> SW er
> > >>>>>>> ror detected.  Restarting 0x2000000.
> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.029747] Registered led =
device:
> > >>>>>>> iwl-phy0::rad
> > >>>>>>> io
> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.030765] Registered led =
device:
> > >>>>>>> iwl-phy0::ass
> > >>>>>>> oc
> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.031602] Registered led =
device:
> > >>>>>>> iwl-phy0::RX
> > >>>>>>> Feb  8 18:40:53 tank kernel: [77585.032467] Registered led =
device:
> > >>>>>>> iwl-phy0::TX
> > >>>>>>
> > >>>>>> No - enable IWLWIFI_DEBUG in your kernel config, then rebuil=
d the
> > >>>>>> kernel (or at least the iwlwifi modules).
> > >>>>>
> > >>>>> That's what I did, see the "d" in "1.2.26kds" above.
> > >>>>
> > >>>> Eh, that was the wrong citation of course. But it's still a "d=
" in
> > >>>> "1.3.27kds".
> > >>>
> > >>> Anything else I can try to provide more information?
> > >>
> > >> Which hardware are you running? If it is a member of the 5k seri=
es then
> > >> you need to use the debug50 parameter.
> > >
> > > Yeah, it is, a 5300. I'll try that and get back to you.
> >=20
> > Now, this was was fun. I was just reading this mailing list, wonder=
ing
> > why the driver still didn't crashed. When I left this mail folder, =
it
> > happened. :-) Did anybody sneak some semantic analysis into the lat=
est
> > code? ;-) And how it crashed! I had to reboot and it keeps crashing
> > now after a few seconds activity at most.
> >=20
> > Anyway, here is the log, I hope the attachment makes it to the list=
=2E
> > If you need more, I have more, but I figured this should contain al=
l
> > important information.
>=20
> Thank you very much for this log. Do you perhaps have a log that show=
s a
> bit what is going on _before_ the SYSASSERT occurs?=20
>=20
> I passed this log on to our hardware folks for some information. At t=
his
> time, please consider opening a bug in
> http://www.intellinuxwireless.org/bugzilla/ with your debug logs.
>=20

I got an answer back promptly because you encountered a problem that wa=
s
fixed recently. Could you please try with the latest wireless-testing?
Patch f50f70bb8d10fa407d7d0e6f4421b928f62357e3 "iwlwifi: fix FAT channe=
l
config for 5000 series" should fix this problem.

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
