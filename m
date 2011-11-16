Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38362 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1KPXiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:38:14 -0500
Received: by ggnb2 with SMTP id b2so335924ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 15:38:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321479498.4502.27.camel@jlt3.sipsolutions.net>
References: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com>
	<1321479498.4502.27.camel@jlt3.sipsolutions.net>
Date: Thu, 17 Nov 2011 00:38:12 +0100
Message-ID: <CAMG6FYjwVHbdEr0eJPV6wcp9ZFO2m2HKcWUdBeP3GC0Z6_G+jA@mail.gmail.com> (sfid-20111117_003818_062207_0E04F37D)
Subject: Re: [RFC] cfg80211: more correct support of multi-essid bss-es
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 10:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-11-16 at 15:00 +0100, Dmitry Tarnyagin wrote:

>> The patch implements linked list of aliases for bss (alias is a bss
>> with the same key information but with different ESSID).
>
> I think you mean here not "different SSID", but "possibly hidden SSID"?
> Otherwise the code doesn't make much sense -- if the SSID is really
> incompatible it doesn't seem to get stuffed into the same node?
>
I'm trying to address 3 different but similar scenarios:
1. Hidden AP, has different SSID in beacons (empty) and probe responses (real);
2. Changing of SSID of an existing AP (in some moment 2 aliases with
different SSID in both beacon and probe resp exist in the bss list);
3. (hypothetical) real multi-ssid AP with permanent set of 2 or more
different ies sets.

> (rfc patch only but just FYI something caused line-wrapping here)
>
Thanks, I will find and shoot it.


> can we call it "ssid", not "essid" please? :)
Ok :)

> Hm the fact that sometimes list_aliases is the anchor and sometimes not
> is a bit confusing, but I think I understand it.
>
> Wasn't there a case where an existing BSS entry is replaced by a new
> one?
>
I think I need to add more comment in the logic :)
Idea is to fill beacon ies of incoming unknown probe responses with
existing, but possibly incorrect information from aliases and replace
it when and if the real beacon comes.
Then, addressing the first scenario:
1a. There is a beacon bss entry in the list and a probe response is coming
Probe resp is filled with beacon ies and contains complete set of IEs.
Existing beacon bss entry is not updating to keep consistence of rb
tree.
1b. There is a probe response bss entry in the list and a beacon is coming
The beacon updates the probe response with its ies.

Second:
2a. There is an existing entry in the list with a whole set of ies and
a new beacon comes
The beacon starts a new bss entry. The old one is getting expired soon.
2b. Same, but a new probe response comes
It starts a new bss entry with inconsistent set of ies. After
reception of an updated beacon the inconsistence is getting fixed. The
old entry is getting expired soon.

Third:
Similar to second, but old entry does not expire.

Something like that :)
