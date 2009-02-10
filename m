Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18568 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZBJSDp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 13:03:45 -0500
Subject: Re: iwlagn: Microcode SW error detected.
From: reinette chatre <reinette.chatre@intel.com>
To: Jan Schneider <jan@horde.org>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090210121904.94213ubhpr3wui04@neo.wg.de>
References: <20090206233134.11116cap9kcroxgc@neo.wg.de>
	 <1233960318.11530.114.camel@rc-desk>
	 <20090208192343.106487dmjra19g6o@neo.wg.de>
	 <69e28c910902081159v1371ee70nb5e70ebdc648b54a@mail.gmail.com>
	 <20090208235149.58334qon9gu98ykg@neo.wg.de>
	 <20090209004532.11356srchh8hvbwg@neo.wg.de>
	 <20090210121904.94213ubhpr3wui04@neo.wg.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 10 Feb 2009 10:07:27 -0800
Message-Id: <1234289247.11530.178.camel@rc-desk> (sfid-20090210_190350_014863_61542D0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 03:19 -0800, Jan Schneider wrote:
> Zitat von Jan Schneider <jan@horde.org>:
>=20
> > Zitat von Jan Schneider <jan@horde.org>:
> >
> >> Zitat von G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> >>
> >>> On Sun, Feb 8, 2009 at 7:23 PM, Jan Schneider <jan@horde.org> wro=
te:
> >>>> Zitat von reinette chatre <reinette.chatre@intel.com>:
> >>>>
> >>>>> On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
> >>>>>>
> >>>>>> I've seen in a post from January that someone already had this=
 problem
> >>>>>> but couldn't reproduce it.
> >>>>>> I can't reliably reproduce, but I see this more often than I l=
ike.
> >>>>>> When this happens, it usually doesn't help to reload the kerne=
l
> >>>>>> module. Sometimes it helps to use the rfkill switch though.
> >>>>>>
> >>>>>> Here's a log with debug=3D0x43fff:
> >>>>>
> >>>>> It does not seem as though your driver is compiled with debug s=
upport.
> >>>>> You can confirm that by looking at the version number of the dr=
iver
> >>>>> printed when it loads ... it should have a "d" in it like "1.2.=
26kds".
> >>>>> Could you please recompile the driver with debug support (IWLWI=
=46I_DEBUG)
> >>>>> and rerun your test?  This will provide us with a complete even=
t log of
> >>>>> the uCode error.
> >>>>
> >>>> Enabling debug didn't help:
> >>>>
> >>>> Feb  7 00:04:40 tank kernel: [ 2769.084395] iwlagn: Intel(R) Wir=
eless WiFi
> >>>> Link
> >>>> AGN driver for Linux, 1.3.27kds
> >>>>
> >>>>
> >>>> /etc/modprobe.d/iwlagn:
> >>>>
> >>>> options iwlagn debug=3D0x43fff
> >>>>
> >>>>
> >>>> I still get:
> >>>>
> >>>> Feb  8 18:40:53 tank kernel: [77584.979829] iwlagn 0000:0c:00.0:=
 Microcode
> >>>> SW er
> >>>> ror detected.  Restarting 0x2000000.
> >>>> Feb  8 18:40:53 tank kernel: [77585.029747] Registered led devic=
e:
> >>>> iwl-phy0::rad
> >>>> io
> >>>> Feb  8 18:40:53 tank kernel: [77585.030765] Registered led devic=
e:
> >>>> iwl-phy0::ass
> >>>> oc
> >>>> Feb  8 18:40:53 tank kernel: [77585.031602] Registered led devic=
e:
> >>>> iwl-phy0::RX
> >>>> Feb  8 18:40:53 tank kernel: [77585.032467] Registered led devic=
e:
> >>>> iwl-phy0::TX
> >>>
> >>> No - enable IWLWIFI_DEBUG in your kernel config, then rebuild the
> >>> kernel (or at least the iwlwifi modules).
> >>
> >> That's what I did, see the "d" in "1.2.26kds" above.
> >
> > Eh, that was the wrong citation of course. But it's still a "d" in =
=20
> > "1.3.27kds".
>=20
> Anything else I can try to provide more information?

Which hardware are you running? If it is a member of the 5k series then
you need to use the debug50 parameter.

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
