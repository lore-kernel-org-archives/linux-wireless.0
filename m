Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1KQLQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 06:16:11 -0500
Subject: Re: [RFC] cfg80211: more correct support of multi-essid bss-es
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYjwVHbdEr0eJPV6wcp9ZFO2m2HKcWUdBeP3GC0Z6_G+jA@mail.gmail.com> (sfid-20111117_003845_290657_7982E7A1)
References: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com>
	 <1321479498.4502.27.camel@jlt3.sipsolutions.net>
	 <CAMG6FYjwVHbdEr0eJPV6wcp9ZFO2m2HKcWUdBeP3GC0Z6_G+jA@mail.gmail.com>
	 (sfid-20111117_003845_290657_7982E7A1)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 12:16:02 +0100
Message-ID: <1321528562.3997.16.camel@jlt3.sipsolutions.net> (sfid-20111117_121617_455341_90EA4BF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 00:38 +0100, Dmitry Tarnyagin wrote:

> I think I need to add more comment in the logic :)

Please :-)

> Idea is to fill beacon ies of incoming unknown probe responses with
> existing, but possibly incorrect information from aliases and replace
> it when and if the real beacon comes.

Hm ok I guess that makes sense.

> Then, addressing the first scenario:
> 1a. There is a beacon bss entry in the list and a probe response is coming
> Probe resp is filled with beacon ies and contains complete set of IEs.
> Existing beacon bss entry is not updating to keep consistence of rb
> tree.
> 1b. There is a probe response bss entry in the list and a beacon is coming
> The beacon updates the probe response with its ies.
> 
> Second:
> 2a. There is an existing entry in the list with a whole set of ies and
> a new beacon comes
> The beacon starts a new bss entry. The old one is getting expired soon.
> 2b. Same, but a new probe response comes
> It starts a new bss entry with inconsistent set of ies. After
> reception of an updated beacon the inconsistence is getting fixed. The
> old entry is getting expired soon.
> 
> Third:
> Similar to second, but old entry does not expire.

Ok. I'm not sure I follow, need to take a closer look at the code I
guess ...

johannes

