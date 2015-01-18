Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55806 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbARSwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 13:52:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFws=-MY+rUsEny=DsBx9gct93BnfeGXSnOCLxEFtvDj8A@mail.gmail.com>
References: <CA+55aFyr9LC7oLoJeyFwK4KRURbbUyO63jznTTAkQF+9LBAsfg@mail.gmail.com>
	<CANUX_P0LCr3fzqLyjKQbZ-P2hAV-Nk6=AMm=oFOWCLW34cRg2w@mail.gmail.com>
	<CA+55aFzEr-R1anNm91pnM=ujfhBstJikZBVtduphff1PtccHDw@mail.gmail.com>
	<54BBF207.2030708@broadcom.com>
	<CA+55aFws=-MY+rUsEny=DsBx9gct93BnfeGXSnOCLxEFtvDj8A@mail.gmail.com>
Date: Sun, 18 Jan 2015 20:52:44 +0200
Message-ID: <CANUX_P1pmB2PD00N2r2LgjNL4fG6RuTPxsO8G2weU+8EeENPTg@mail.gmail.com> (sfid-20150118_195253_631908_14325767)
Subject: Re: Wireless scanning while turning off the radio problem..
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2015 at 8:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 19, 2015 at 5:48 AM, Arend van Spriel <arend@broadcom.com> wrote:
>>
>> So as you indicated you were in location where none of your configured
>> networks were available. Flipping the rfkill switch in that situation is the
>> way to trigger the issue.
>
> So you certainly seem to be able to explain the behavior I saw under
> the circumstances they happened.
>
> I suspect the best thing to do is to just apply your patch. I may not
> be able to really test it much for the next few days anyway. Emmanuel?
>

Sorry - I was a bit busy.
The patch seems wrong, we can't really call that function from the
rfkill interrupt - it will blow up.
The good news is that I could reproduce the bug based on what Arend
pointed. I totally missed the fact
that it was scheduled scan - thanks Arend for that.

So the system I have here doesn't have HW rfkill so I had to implement
a hook that fakes it,
but I can't reproduce the problem.
I'll come up with a patch.
