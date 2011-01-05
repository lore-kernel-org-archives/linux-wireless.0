Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52031 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1AEW5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 17:57:48 -0500
Received: by iwn9 with SMTP id 9so15730783iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 14:57:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110105182617.GB10391@tux>
References: <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
 <1292501047.3612.9.camel@jlt3.sipsolutions.net> <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
 <1292502934.3612.15.camel@jlt3.sipsolutions.net> <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
 <1292504020.3612.17.camel@jlt3.sipsolutions.net> <AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
 <20101216174410.GB5677@tux> <AANLkTinvrdj4jbzH3COVZ9gW8W0h0em7uD6DBWBEXUp=@mail.gmail.com>
 <AANLkTikDP_uF_jGh5bNyMv17VoZB=9u-SrdWRUQ15gRb@mail.gmail.com> <20110105182617.GB10391@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 5 Jan 2011 14:57:27 -0800
Message-ID: <AANLkTikT8cS-ZD=MPC+XUTeXbca3gt2=Epj4XU__+4uH@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
To: Paul Stewart <pstew@google.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amod Bodas <amod@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 10:26 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Jan 04, 2011 at 02:29:53PM -0800, Paul Stewart wrote:
>> On Tue, Jan 4, 2011 at 10:19 AM, Paul Stewart <pstew@google.com> wrote:
>> > On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
>> > <lrodriguez@atheros.com> wrote:
>> >> Try this:
>> >
>> > Happy new year.  I've tried this patch, and the system continues to
>> > suspend and resume successfully (i.e, the fix from the earlier patches
>> > continues to alleviate the original problem), however the system
>> > continues to be "deaf" to beacons at resume time if the system
>> > suspends and resumes while associated.  You don't need a ChromeOS
>> > system to reproduce this issue.  Just associate to the network and
>> > suspend/resume.  On resume the system believes it should be
>> > associated, but then the beacon loss timer kicks in and we
>> > disassociate, since we are never successful in receiving a response.
>>
>> Whoops.  I didn't apply that change correctly.  Actually, I think this
>> change works.  I think I may have spotted a couple of unrelated
>> anomalies I'll trace down and address separately.
>
> Great, I think this patch got sucked up already, I'll check.

Indeed, John just sent this to David as part of the queued up patches
for 2.6.38.

  Luis
