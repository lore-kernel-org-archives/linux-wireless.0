Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:28524 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZD1AxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2009 20:53:05 -0400
Received: by wf-out-1314.google.com with SMTP id 26so160199wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2009 17:53:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5b8543210904230439r45c982fbn66c1a2080adcd442@mail.gmail.com>
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
	<1240442334.14995.12.camel@localhost.localdomain> <5b8543210904230336j177998c4m1e0af03fbb3584df@mail.gmail.com>
	<1240483530.30082.178.camel@johannes.local> <5b8543210904230439r45c982fbn66c1a2080adcd442@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Apr 2009 17:52:50 -0700
Message-ID: <43e72e890904271752yd080607x910ef06c45f124d@mail.gmail.com> (sfid-20090428_025324_996048_E04999B7)
Subject: Re: Measure RSSI in adhoc networks
To: Kai Timmer <email@kait.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2009 at 4:39 AM, Kai Timmer <email@kait.de> wrote:
> 2009/4/23 Johannes Berg <johannes@sipsolutions.net>:
>> On Thu, 2009-04-23 at 12:36 +0200, Kai Timmer wrote:
>>
>>> I need the RSSI values for distance measurements between the nodes.
>>
>> Note that is very unreliable...
>
> I know, it is a work for my diploma thesis. I'm trying to combine it
> with some kind of round trip time measurements. It is in the very
> early stages,...
>
>>> So
>>> what i need is not a "quality value" for the whole network, but the
>>> recieved mW from every reachable point in the network. So i think the
>>> RSSI value for every network node (if i can print them out seperatly)
>>> should do the job.
>>
>> iw dev wlan0 station dump
>
> That works on my laptop, but on not on my Openmoko Freerunner devices.
> There I get the following:
>
> runner1:~# iw dev eth1 station dump
> nl80211 not found.
>
> I assume that something with the freerunner wireless driver is not
> compatible with the linux wireless stack. The driver is called
> "ar6000".

The ar6000 driver uses wext and not cfg80211 which all new shiny
mac80211 drivers use. The command Johannes gave you was for cfg80211
devices.

  Luis
