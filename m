Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dike.telenet-ops.be ([195.130.132.36]:59104 "EHLO
	dike.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXJ0CL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 22:11:56 -0400
Received: from astra.telenet-ops.be (astra.telenet-ops.be [195.130.132.58])
	by dike.telenet-ops.be (Postfix) with ESMTP id A88B4820625
	for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 02:22:40 +0200 (CEST)
Message-ID: <472284A9.3070104@telenet.be> (sfid-20071027_031201_892344_0C82E99A)
Date: Sat, 27 Oct 2007 02:22:01 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> > On 10/17/07, Ian Schram <ischram@telenet.be> wrote:
>> >> I do *not* send a led command on each packet. (Unless i made a ho=
rrible
>> >> coding error that I do not see)
>> >>
>> >> I send a led command when on every association event. But that's =
only when
>> >> we actually associate. or hw/sw rfkill is activated, or deassocia=
ted.
>> >>
>> >> The leds for activity: keep a counter, which counts how many time=
s the led
>> >> is triggered from mac80211
>> >> right now this is a multiple of the #packets. A delayed work will=
 run
>> >> every 500 ms and translate this
>> >> amount of packets into a blinking rate for the led. When no packe=
ts are
>> >> transeived, the delayed work
>> >> will not be scheduled until new packets are transeived.
> >
> >
> > When no packets are transmitted correct behaviour is  steady  light=
  on.
> >
> > This is quite similar to how the leds work in
>> >> ipwraw, and ipw3945, only there the amount of byters were counted=
 in the
>> >> rx and tx path, which
>> >> was then converted to a blinking rate. This information is not av=
ailable
>> >> within the led framework,
>> >> hence i used the amount of led events and translate that into a b=
linking
>> >> rate.
> >

All these comments are on the activity led code. This code is the bulk
of the patch, and proably isn't the nicest solution to the problem.

I could send a stripped down patch, that only registers the association=
 led trigger.
This is something that is a lot easier the mac80211_leds way.

This basic functionality of the led being on when associated, is still =
a nice
gimmick imho. Second only to the firmware filename it's the comment i m=
ost
frequently read in irc.. but perhaps i have tunnel vision.



> >
> > I think we can figure out how to do it correctly we already have th=
rouput
> > masurement incorporated in.
> > Second I=B4m not sure that the wrokqueueu is really necessary. I th=
ink that
> > the command can be issued right away.

if i'm not mistaking ratescale has this data, and that there is no prob=
lem
collecting this data from the rx/tx paths. for activity, this is probab=
ly more
efficient and accurate. I just choose to do this the mac80211 way too


>> >>
>> >> I did manage to listen to your comments on my previous patch ;-)
> >
> >
> > I=B4ve  just recalled I wrote already once email as this one :) . Y=
eah I
> > didn=B4t read code carefully enough.
> >
> > Actually i believe this to be a crossection of what mac80211_leds e=
xpects,
>> >> and how ipw used to
>> >> do it.
>> >>
>> >> Ian
>> >>

Ian

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
