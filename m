Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61356 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaEWJLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:11:55 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so511339wiw.14
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 02:11:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400835214.4358.8.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-7-git-send-email-michal.kazior@tieto.com>
	<1400770624.4174.36.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=-swYkLOMdYVgH8DfCZwzScLmHJ9bw7MF+woXoQfy8ug@mail.gmail.com>
	<1400835214.4358.8.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 11:11:53 +0200
Message-ID: <CA+BoTQ=Ti22n_MoYbroVihNgFbBqoVAOgV-ThdfN0XBjNywYJw@mail.gmail.com> (sfid-20140523_111207_578682_464E0C96)
Subject: Re: [PATCH v6 6/6] cfg80211: remove channel_switch combination check
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 10:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-23 at 09:04 +0200, Michal Kazior wrote:
>> On 22 May 2014 16:57, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>> >> Make the driver responsible for making sure it is
>> >> capable of performing the switch. It might as well
>> >> accept a request but then disconnect an interface
>> >> if some requirements are not met.
>> >
>> > Care to elaborate? I'd really like to avoid this case as much as
>> > possible, so just mentioning here that it would be valid seems like a
>> > bad idea.
>>
>> Well, CSA isn't really visible to cfg80211 so you can't enforce anything now.
>>
>> Also since CSA requests are submitted one-by-one you already break
>> interface combinations and hope:
>>  a) userspace sends more CSA requests soon enough to make future
>> interface combination valid
>>  b) trust drivers deal with it either way
>>
>> So why bother?
>>
>> The most you can probably do is to prevent CSA requests from switching
>> to too many different channels but you can easily guarantee this in a
>> driver.
>
> Yeah, absolutely - it's just the fact that you're saying that it might
> accept but then disconnect ... that will make people feel OK about that,
> when it's really not all that desirable. Better to state that more
> explicitly that it should check before :)

I understand now. I'll try to emphasize this when I respin.


Michał
