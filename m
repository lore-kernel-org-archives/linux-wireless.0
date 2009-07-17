Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:25710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649AbZGQQw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:52:57 -0400
Received: by wf-out-1314.google.com with SMTP id 26so287580wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:52:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247848427.8139.4386.camel@localhost.localdomain>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
	<1247848427.8139.4386.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 09:52:37 -0700
Message-ID: <43e72e890907170952v20677c7fr50204df952228d53@mail.gmail.com>
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
To: Bastien Nocera <hadess@hadess.net>
Cc: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	till.kamppeter@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 9:33 AM, Bastien Nocera<hadess@hadess.net> wrote:
> On Thu, 2009-07-16 at 18:10 -0700, Luis R. Rodriguez wrote:
>> The GSoC project to integrate GeoClue to GNOME and eventually send
>> regulatory hint information to the kernel [1] will not be completed
>> through GSoC. Since I am not sure if the student will be interested in
>> following up on this project idea outside the scope of GSoC I'm
>> looking for advice to better get an idea of what it is exactly we
>> should be looking forward to change to get information to the kernel
>> to enhance regulatory support using GeoClue. At the very least I'd
>> like to come to some conclusion as to where it is best to put software
>> to send information to the kernel to help distributions.
>>
>> The current best alternative I've seen is to read the current timezone
>> information and extract the country from that. That is how John
>> implemented it for Fedora. This may be enough but GeoClue should
>> provide better accuracy. All we need in the kernel is to determine the
>> country you are on. The user can obviously set this themselves during
>> a distribution install, but it may make sense to just use GeoClue for
>> this. Under the assumption that using GeoClue is the way to go how
>> should we do this?
>>
>> For the GSoC project I was initially suggesting for Network Manager to
>> get GeoClue integration and then have Network Manager send the
>> regulatory hint once a country was determined through either user
>> input or through GeoClue magic. After some discussions with Jouni
>> about this he convinced me this may not be the best place for this. So
>> if not Network Manager, where? Do we want a GNOME location aware panel
>> under System->Administration? Is it as simple as that? If not are
>> there any other suggestions?
>
> Adding more preferences certainly isn't the solution.
>
> One of the problems you'd encounter would be trying to get information
> about which country you're in, which might sometimes require a network
> to get.
>
> You get a bit of a chicken/egg problem. How can I get online to get my
> location given that I can't get online because my wireless card's been
> restricted to channels outside my reach.

Agreed, but there is certain information even from wireless cards
which may feed GeoClue even before establishing a network connection,
for example a nearby country AP sending beacons with a country IE.

Another non-network related GeoClue feed could be a GPS device.

> How does John's code react when the timezone changes?

It just reads the country from timezone file, I've pasted the script
below inline in case you are curious.

> How do you get
> online to get the country when the network isn't available because of
> previous restrictions?

Cards that have no regulatory information programmed into them either
through the firmware or through an EEPROM get to world roam. This
means passive scanning on some channels, for example. It means you
cannot send probe requests out but instead just have to wait for
beacons on each channel. When a beacon is received though we do enable
active scanning -- that is we enable probe requests and even
beaconing.

Our world roaming capabilities may suffice for most of the world, the
only excemption is DFS channels on 5 GHz for which we do not allow to
even passively scan. For that you do need to set a regulatory domain.

Another advantage to having the country defined is you may be allowed
to TX at a higher power. This should improve performance.

Keep in mind that cards that have EEPROM regulatory information is
always trusted first, but cards that do not have any regulatory
information benefit completely from user input.

So in summary it is possible for you to connect to a wireless network
even without regulatory information -- when we world roam. The
exemption is when an AP is on a DFS channel. The next good thing is to
improve performance in case your regdomian does allow higher max EIRP.

> Do you need to change the regulatory hint in the
> kernel as soon as you know the new position?

No, and in some cases it not required at all -- in the case of intel
cards or Atheros cards where the regulatory domain is programmed into
the card. For these cards setting the regulatory domain just further
helps compliance in case say your card is for Japan and allows channel
13, and you move to the US and need to disable channel 13. Setting the
regulatory domain to "US" through userspace will disable channel 13.
With Intel or Atheros cards if you do it the other way around -- buy a
US card and move to the JP you won't get channel 13 enabled.

For cards that have no regulatory information the default is to world
roam. So for these cases (b43, b43legacy, rt2x00 drivers, etc) there
is a good benefit to getting some user input for regulatory
information.

> Is it saved and cached
> somewhere so you don't need to pound the hardware on each reboot?

No! And that's the point to this e-mail, the goal is getting userspace
to catch up with the new regulatory framework designed in the kernel
to help compliance. Seems to me like GeoClue integration on the
desktop would help.

  Luis
