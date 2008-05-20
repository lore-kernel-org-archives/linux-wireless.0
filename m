Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:1377 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYETNol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:44:41 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2369882waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 06:44:40 -0700 (PDT)
Message-ID: <1ba2fa240805200644o34ec17f5h32224e921a77702d@mail.gmail.com> (sfid-20080520_154454_877198_9E6488DF)
Date: Tue, 20 May 2008 16:44:40 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211290714.6252.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>
	 <1211289769.6252.90.camel@johannes.berg>
	 <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com>
	 <1211290714.6252.93.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 4:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > Thing is, I'm not totally convinced it is wrong to the code while it may
>> > or may not be wrong...
>>
>> Doesn't should be bss pinned int he bss list if you are associating to
>> it. If it's not there you don't have access to it's info It looks very
>> wrong to me.
>
> Well, yes, it is a bit odd.
>
>> > I think this patch should go in first as it
>> > actually fixes the oops, and then we can discuss the merits of adding a
>> > warning there separately. Maybe after we look a bit at the code and try
>> > to figure out whether it can still happen after that patch from
>> > Abhijeet.
>>
>> I'm not sure if this patch is complete without this warning. What is
>> in the else statement is a hack and it should be obvious.
>
> Considering that the message won't help us at all, why bother? We know
> it's triggering, we know this might be a problem, and we know we can
> only solve it by auditing the code. So why add a message that will get
> us countless emails/complaints from people we cannot do anything about
> anyway without doing the audit?


As I understand it's not easily reproducible so you need reference
point in the trace
when it happens. I'm not sure what your debug techniques are, though.

Tomas



> johannes
>
