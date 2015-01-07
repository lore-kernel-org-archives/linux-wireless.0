Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:43013 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbAGP6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:58:41 -0500
Received: by mail-ig0-f176.google.com with SMTP id a13so2883394igq.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 07:58:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdWsDsnVr_bJ3ScSYy6MEQ7VXvWw4VC36zheYN-B=yLrA@mail.gmail.com>
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	<1420542274.1966.21.camel@sipsolutions.net>
	<1420553111.1966.32.camel@sipsolutions.net>
	<1420553688.1966.33.camel@sipsolutions.net>
	<CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com>
	<1420570976.1966.34.camel@sipsolutions.net>
	<CAB3XZEdWsDsnVr_bJ3ScSYy6MEQ7VXvWw4VC36zheYN-B=yLrA@mail.gmail.com>
Date: Wed, 7 Jan 2015 17:58:40 +0200
Message-ID: <CAB3XZEdJw=vaLVO+5YXkH1ZPerKYC4s-_+E0nzL+XUXMiZQLkw@mail.gmail.com> (sfid-20150107_165846_455179_5B8FADC8)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2015 at 9:36 PM, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Jan 6, 2015 at 9:02 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2015-01-06 at 20:57 +0200, Eliad Peller wrote:
>>> On Tue, Jan 6, 2015 at 4:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > On Tue, 2015-01-06 at 15:05 +0100, Johannes Berg wrote:
>>> >> On Tue, 2015-01-06 at 12:04 +0100, Johannes Berg wrote:
>>> >> > all three applied.
>>> >>
>>> >> Nope, dropped patch 2 again
>>> >
>>> > And dropped the other two also - with them the sequence of two tests I
>>> > was looking at never completes.
>>> >
>>> err... sorry about that.
>>> i'll look into it.
>>
>> I think there's probably two bugs - the test suite should wait for all
>> the DFS stuff to finish.
>>
>> But the fact that it never completes now is strange, maybe somehow radar
>> detection doesn't get turned off properly after your patches?
>>
> it's probably local->radar_detect_enabled doesn't get cleared.
> patch (3) fixes a similar issue, but there seems to be another one.
> (it seems that patch (1) exposed these issues, so i should probably
> reorder the patches and make it the last one)
>
ok, sent a new patchset.

there were some missing updates of local->radar_detect_enabled, so i
preferred to simply remove it altogether and check for radar detection
directly when needed (i.e. on scan/roc).

ap_ht_40mhz_intolerant_ap still seems to fail here, but it fails even
when running only this test, without any of my patches applied.
now i get the same error with my patches applied ("Exception: AP did
not move to 40 MHz channel") instead of the EBUSY one.

i'll try debugging this issue as well.

Eliad.
