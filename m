Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33165 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbJSL2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:28:48 -0400
Received: by iodv82 with SMTP id v82so184110095iod.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 04:28:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444856468.3054.17.camel@sipsolutions.net>
References: <1444855924.3054.9.camel@sipsolutions.net>
	<1444856468.3054.17.camel@sipsolutions.net>
Date: Mon, 19 Oct 2015 14:28:47 +0300
Message-ID: <CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com> (sfid-20151019_132851_138032_9ADB164C)
Subject: Re: new regdb file format
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2015 at 12:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Err. Let's try that again.
>
> I spent a bit of time thinking about a file format that would be more
> extensible, yet still be loadable into the kernel without having to
> parse it into new data structures in the kernel, i.e. be easy enough to
> read when needed.
>
> My considerations
>  * must be extensible in some way
>  * should be relatively dense/small to not use too much kernel memory
>  * should still be reasonably easy to parse/read
>
> I came up with a file format that's similar to the existing
> regulatory.bin format, but with the following changes:
>  * put the DFS region into a reg rule collection
>  * put the frequency range and power rules directly into each reg rule
>    (i.e. don't try to normalize them)
>  * have a length field in the collection and rule structures so that we
>    can extend them with new fields
>  * use more compact pointers, i.e. u16 offsets, by aligning everything
>    to 4 bytes and shifting the offsets by 2 bits, this allows for
>    256KiB database files which seems large enough
>
> More documentation is here:
> https://wireless.wiki.kernel.org/en/developers/todo-list/regdb-file
> -format
>
while at it - is there any way to indicate exclusion of some channels?
e.g. channels 38/42 in US (the current rule is "(5170 - 5250 @ 40)",
which doesn't seem to forbid them)

Eliad.
