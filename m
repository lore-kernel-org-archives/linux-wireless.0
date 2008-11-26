Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42385 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKZBCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 20:02:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 17:02:20 -0800
Date: Tue, 25 Nov 2008 17:02:18 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Richard Farina <sidhayn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@Atheros.com>
Subject: Re: wireless-regdb: flaw in general functionality
Message-ID: <20081126010218.GP5950@tesla> (sfid-20081126_020224_657388_F5049183)
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla> <1227568883.28878.15.camel@dv> <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com> <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv> <20081126001942.GN5950@tesla> <1227659754.2556.11.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1227659754.2556.11.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 04:35:54PM -0800, Pavel Roskin wrote:
> On Tue, 2008-11-25 at 16:19 -0800, Luis R. Rodriguez wrote:
> 
> > This is documented here:
> >
> > http://wireless.kernel.org/en/developers/Regulatory#Changingthedatabasefileformat
> 
> I mean, I don't know how painful it can be.  Perhaps it's better to
> anticipate some requirements earlier than to change them later.

Its painful to add anything new. To understand this better it helps to
understand why some flags were added in the first place to regulatory rules.
The short and sweet answer is DFS. And the general rule of thumb goes like this:

When in a DFS freq, if you don't support DFS in your mode of operation,
then you cannot TX.

So if you don't support DFS in IBSS, you get NO-IBSS. If your AP doesn't
support DFS then you can't use DFS channels. If you don't support DFS
then you better not use active scanning on a STA, hence the passive scan
flag (I guess this should be renamed to NO-ACTIVE-SCAN to be more
consistent).

The NO-HT20 is historical, we're not aware of countries disallowing
this. No-HT40 is also a bit historical as it seems the countries which
do not allow this will soon allow for it.

The NO-OFDM and NO-CCK flag is unused and purely historical.

So before adding a flag I think its *really* good to think about it
thrice and see if there is a need of it, otherwise the answer should
usually be that its not a good idea to add it.

If anything we can consolidate flags or remove flags, that would be nicer
if possible.

> I think
> both "don't transmit" and "don't transmit unless permitted by the AP"
> could be useful in some jurisdictions.

Don't transmit is implicit, CRDA just "allows", so the flags we have now
are all negative for special considerations on "allowing", such as NO
IBSS, etc.

  Luis
