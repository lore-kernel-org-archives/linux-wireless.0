Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38757 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbcA1KMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 05:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <1453974492.2217.2.camel@sipsolutions.net>
References: <20160126111730.GA6765@localhost> <20160127154618.GA5717@localhost>
 <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com> <1453974492.2217.2.camel@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 28 Jan 2016 21:11:45 +1100
Message-ID: <CAGRGNgVqtj8SwP-gEt0ZnbgWzgVHjcY9Q=JyB6bf6d_m+8mvhA@mail.gmail.com> (sfid-20160128_111250_717631_1F54C65C)
Subject: Re: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	aryabinin@virtuozzo.com, Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Jan 28, 2016 at 8:48 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2016-01-28 at 10:27 +1100, Julian Calaby wrote:
>> I'd prefer to just set ->removed to false right after we set
>> ->auto_seq as that should be faster, however I don't know if
>> __ieee80211_start_rx_ba_session() is a fast path so I don't know if
>> this is saving anything.
>
> It's not supposed to be called frequently, no.

Then most of my commentary is moot.

I guess the argument comes down to do we zero everything or initialise
everything, and if speed isn't an issue, the former is better.

>> On another note, this is an error that should be pretty easy to spot.
>> Could any of the automated tools find cases where a struct containing
>> a bool variable is kmalloc'd and returned without assigning all the
>> bools?
>
> I think you'd quickly drown in false positives, since "return" isn't
> necessarily something that means it needs to have been fully
> initialized.

True.

Either way, I'm guessing that UBSAN will pick up a lot of similar bugs
and the output of that is probably a much smaller haystack to dig
through than just "every" kmalloc() call.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
