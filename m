Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1LRIjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 03:39:07 -0500
Received: by iaeh11 with SMTP id h11so6806549iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 00:39:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMG6FYjwVHbdEr0eJPV6wcp9ZFO2m2HKcWUdBeP3GC0Z6_G+jA@mail.gmail.com>
References: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com>
	<1321479498.4502.27.camel@jlt3.sipsolutions.net>
	<CAMG6FYjwVHbdEr0eJPV6wcp9ZFO2m2HKcWUdBeP3GC0Z6_G+jA@mail.gmail.com>
Date: Sun, 18 Dec 2011 10:39:06 +0200
Message-ID: <CAB3XZEfdu3Jau4L=40xn32BEayd7pT_Dj_ALWFH+by5EdE4z6Q@mail.gmail.com> (sfid-20111218_093911_269617_C132784F)
Subject: Re: [RFC] cfg80211: more correct support of multi-essid bss-es
From: Eliad Peller <eliad@wizery.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Dmitry,

On Thu, Nov 17, 2011 at 1:38 AM, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> On Wed, Nov 16, 2011 at 10:38 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2011-11-16 at 15:00 +0100, Dmitry Tarnyagin wrote:
>
>>> The patch implements linked list of aliases for bss (alias is a bss
>>> with the same key information but with different ESSID).
>>
>> I think you mean here not "different SSID", but "possibly hidden SSID"?
>> Otherwise the code doesn't make much sense -- if the SSID is really
>> incompatible it doesn't seem to get stuffed into the same node?
>>
> I'm trying to address 3 different but similar scenarios:
> 1. Hidden AP, has different SSID in beacons (empty) and probe responses (real);
> 2. Changing of SSID of an existing AP (in some moment 2 aliases with
> different SSID in both beacon and probe resp exist in the bss list);
> 3. (hypothetical) real multi-ssid AP with permanent set of 2 or more
> different ies sets.
>

are you going to resubmit this RFC as a proper patch?
in wl12xx we sometimes encounter the case in which we get the hidden
beacon only after the probe response, which prevents us from entering
psm. this patch seems to fix it (although, as Johannes noted, you
might want to add some checks to validate this is actually a hidden
ssid).

thanks,
Eliad.
