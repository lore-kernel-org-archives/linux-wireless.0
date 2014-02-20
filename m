Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33231 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaBTHMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:12:23 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so1040137lan.39
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 23:12:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WDvxXGT21H5-D4H3tSJ_iZufp6X05_quPpoAeaoMkOog@mail.gmail.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	<1392807806.4733.14.camel@jlt4.sipsolutions.net>
	<CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com>
	<1392809288.4733.15.camel@jlt4.sipsolutions.net>
	<CAB=NE6WDvxXGT21H5-D4H3tSJ_iZufp6X05_quPpoAeaoMkOog@mail.gmail.com>
Date: Thu, 20 Feb 2014 08:12:20 +0100
Message-ID: <CALhHN=qaD=WPxN=SUBiB0yWVMi3Tugsug6uDkjiiSJyCbVOeCA@mail.gmail.com> (sfid-20140220_081226_844370_00DB885F)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 23:11, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Wed, Feb 19, 2014 at 3:28 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> Ah ok, thanks.
>
> Let me know if you merge this so I can apply and push the respective
> patch for CRDA. Not sure if you saw but as proposed this means this
> bumps the wireless-regdb format. Janusz, I see you submitted a
> respective patch for iw and CRDA but not one for wireless-regdb, we'll
> need one there in order to parse the new entries in db.txt.
>
[PATCH] wireless-regdb: add DFS CAC time parameter

This one parse CAC time in wireless-regdb. I also change VERSION while
binary format was changed.
Didn't touch db.txt while will work as today (CAC = 0 - default CAC
time defined in mac80211).

> John, this should mean we will need two releases for wireless-regdb
> moving on so that older versions of CRDA can read the new rules under
> the old format. Another option may be to have wireless-regdb spit out
> the file in two formats and we modify the new CRDA to jump to the new
> format section if it supports it. Otherwise I'm afraid we get stuck
> with the latest rules for old kernels forever, or we make a branch on
> wireless-regdb for the old format.
>
We can allow VERSION=19 and VERSION=20, and handle this in CRDA
dynamically. This should be quite easy.

> Thoughts folks?
>
>   Luis
