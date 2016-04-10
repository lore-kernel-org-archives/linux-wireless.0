Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33929 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbcDJAbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2016 20:31:38 -0400
Received: by mail-io0-f181.google.com with SMTP id 2so170903189ioy.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Apr 2016 17:31:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460177816.7409.4.camel@sipsolutions.net>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	<1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	<1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	<1456222441.2041.10.camel@sipsolutions.net>
	<CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
	<1456257946.9910.23.camel@sipsolutions.net>
	<CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
	<1459928436.17504.11.camel@sipsolutions.net>
	<CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com>
	<1460098614.30678.1.camel@sipsolutions.net>
	<1460098909.30678.2.camel@sipsolutions.net>
	<1460099746.30678.3.camel@sipsolutions.net>
	<CAHqTa-1SO+asqf7Fn2d+J_w8vvJ1CnnMG8AGB2O1CBjeaaL8hA@mail.gmail.com>
	<CAHqTa-0oji0=-CMYbQ6PQw-R5_jsuUjAAtERwDvLieBD=ObCKw@mail.gmail.com>
	<1460177816.7409.4.camel@sipsolutions.net>
Date: Sat, 9 Apr 2016 17:31:37 -0700
Message-ID: <CAJ-Vmon7Qyms95U4AuidkqMcGFPqXi3pWuEQastUdHe7B6hfFA@mail.gmail.com> (sfid-20160410_023147_905185_DC21C386)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Avery Pennarun <apenwarr@gmail.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2016 at 21:56, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-04-08 at 21:27 -0400, Avery Pennarun wrote:
>
>> > Just to be clear, this crash is only from *reading* the agg_status
>> > files.  I don't know if the crashiness reduces when disabling the
>> > aggregation timeouts, since that's a separate bug (in which the
>> > queue gets stuck and the 'pending' column of this file just keeps
>> > increasing).
>
> Oh, right, I was confusing the two. The reading one is even stranger
> though, in a way. I have no explanation for it (yet). We could suspect
> memory corruption, but why would it specifically hit issues here? Not
> very plausible.
>
>> Updated .ko file that definitely has debug symbols this time:
>> http://apenwarr.ca/tmp/mac80211-agg-status-crash-debugsyms.ko
>>
>
> Ok, that confirms what I did manually in my previous email - that it
> crashed on this:
>
> 141                     p += scnprintf(p, sizeof(buf) + buf - p, "\t%#.2x",
> 142                                     tid_tx ? tid_tx->dialog_token : 0);
>
> (and by hand I'd already checked that it crashed dereferencing the
> tid_tx->dialog_token, since tid_tx was the value 0x5b35da40.
>
> If any people more familiar with ARM are reading this - does the value
> 0x5b35da40 ring a bell? Is that a userspace area? Or an area where the
> stack would be? All other points around here seem to look like
> 0xac0c3c58, or maybe 0x838c6958, but not 0x5b35...., how could we end
> up with that?

.. that looks very userland-y to me. Is it just some pointer garbage perhaps?

Do you have a full crashdump? what's sta->ampdu_mlme look like?



-a
