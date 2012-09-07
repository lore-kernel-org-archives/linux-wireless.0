Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38674 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2IGNCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 09:02:11 -0400
Received: by ghrr11 with SMTP id r11so515028ghr.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2012 06:02:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347006078.4256.6.camel@jlt4.sipsolutions.net>
References: <5048ADFC.1010708@sonymobile.com>
	<20120906224448.GA16676@khazad-dum.debian.net>
	<CAMJBoFMd2sLEScY3j2-wsWQh3Mv_nArPC904dzJ+j-16+pdkgQ@mail.gmail.com>
	<1347006078.4256.6.camel@jlt4.sipsolutions.net>
Date: Fri, 7 Sep 2012 15:02:10 +0200
Message-ID: <CAMJBoFNQFpM_do9EVBAQu8vtbsAiZJDJkoL9pcXwVP-Cf1=ZZg@mail.gmail.com> (sfid-20120907_150214_758190_0AD7C001)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Vitaly Wool <vitalywool@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Vitaly Wool <vitaly.wool@sonymobile.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 7, 2012 at 10:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-09-07 at 08:54 +0200, Vitaly Wool wrote:
>> Hi Henrique,
>>
>> On Fri, Sep 7, 2012 at 12:44 AM, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>> >
>> > On Thu, 06 Sep 2012, Vitaly Wool wrote:
>> > > Prevent unnecessary rfkill event generation when the state has
>> > > not actually changed. These events have to be delivered to
>> > > relevant userspace processes, causing these processes to wake
>> > > up and do something while they could as well have slept. This
>> > > obviously results in more CPU usage, longer time-to-sleep-again
>> > > and therefore higher power consumption.
>> >
>> > Could this supress the first event when a switch is registered? Would that
>> > be a concern?
>>
>> I'm not sure I got your question, but just in case, rfkill is
>> initialized to all zeroes so rfkill->state is 0 and on each consequent
>> _real_ change there (prev != curr) == true and the event will be
>> generated.
>
> But maybe applications were expecting an event for registration? Or do
> we get that anyway maybe?

We should get them anyway. rfkill_fop_open() basically just pushes all
the startup events into the list so the application will see all the
_changes_ on registration. And at least wpa_supplicant reads out all
these events on rfkill registration. If an application does something
else, then I think it's buggy.

~Vitaly
