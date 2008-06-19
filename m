Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:60483 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYFSTxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 15:53:23 -0400
Received: by wa-out-1112.google.com with SMTP id j37so676300waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 12:53:22 -0700 (PDT)
Message-ID: <1ba2fa240806191253l2769dec3q2a49638eafe01e48@mail.gmail.com> (sfid-20080619_215329_498639_4297B7D6)
Date: Thu, 19 Jun 2008 22:53:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mike Kershaw" <dragorn@kismetwireless.net>
Subject: Re: More 4965 woes
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080619134138.GA27021@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080617132401.GA8328@drd1813.lan>
	 <1213781294.2625.52.camel@debian.sh.intel.com>
	 <20080618154109.GB15170@drd1813.lan>
	 <20080619134138.GA27021@drd1813.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 4:41 PM, Mike Kershaw
<dragorn@kismetwireless.net> wrote:
> On Wed, Jun 18, 2008 at 11:41:10AM -0400, Mike Kershaw wrote:
>> On Wed, Jun 18, 2008 at 05:28:14PM +0800, Zhu Yi wrote:
>> > On Tue, 2008-06-17 at 09:24 -0400, Mike Kershaw wrote:
>> > > 1 - Inability to associate to a network on 5ghz.  Same AP on 2.4ghz
>> > >   works fine, scanning shows the AP fine.  Sniffing with an additional
>> > >   card shows no frames at all being sent by the 4965. AP is on a
>> > > channel
>> > >   the 4965 should be able to talk to according to iwlist channel (logs
>> > > attached)
>> >
>> > >From the log, you are trying to use channel 56 which is under radar
>> > detection. The card must hear from the AP first in order to send. Can
>> > you try 36?
>>
>> Must hear from the AP?  Like, beacons?  If beacons aren't enough, how is
>> something ever supposed to associate?
>>
>> The AP is detected normally via scanning (wpa_supplicant 'scan' and
>> iwlist scan) so the card is seeing beacons fine.
>>
>> I'll reboot into the git kernel later today and redo the test on another
>> channel.
>
> On channel 36 things appear to work (well, as much as they do otherwise,
> packet hanging still makes the device unusable).  I'm still confused as
> to why the card can report it works on that channel, scan that channel,
> see beacons, but then refuse to transmit.

There is a bug in the firmware. the fix is on the way. Unfortunately I
cannot currently commit to
to any particular day it will be published yet.

What AP do you use I don't see such bad behviour on A band.
Thanks
Tomas
