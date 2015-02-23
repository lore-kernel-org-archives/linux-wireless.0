Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:35692 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbbBWWPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 17:15:31 -0500
Received: by yhoc41 with SMTP id c41so12302298yho.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 14:15:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424729246.1899.6.camel@sipsolutions.net>
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
 <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com>
 <1424709235.3075.22.camel@sipsolutions.net> <CAHNKnsR0j1u6Eu2e19pzcu2Rw7nZ6D6BKV-cRg9KTwoKO74fdQ@mail.gmail.com>
 <1424728360.1899.3.camel@sipsolutions.net> <1424728896.1899.4.camel@sipsolutions.net>
 <1424729246.1899.6.camel@sipsolutions.net>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Tue, 24 Feb 2015 01:15:08 +0300
Message-ID: <CAHNKnsTpYEdkF9OETnjKua9bOb4=-MXC26pctUvJW0gFJAUS1g@mail.gmail.com> (sfid-20150223_231548_970707_5311BF8A)
Subject: Re: [RFC] mac80211: use rhashtable for station table
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-24 1:07 GMT+03:00 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2015-02-23 at 23:01 +0100, Johannes Berg wrote:
>> On Mon, 2015-02-23 at 22:52 +0100, Johannes Berg wrote:
>>
>> > We also can't rely on 4-byte alignment though, so perhaps we should do
>> > something like
>> >
>> > u32 sta_info_hash(void *addr, u32 len, u32 seed)
>> > {
>> >     u16 *a = addr;
>> >
>> >     return jhash_3words(a[0], a[1], a[2], seed);
>> > }
>>
>> Or better do
>>
>>       return jhash_2words(addr[0], (addr[1] << 16) | addr[2], seed);
>>
>> since I have no idea how the missing high 16 bits would behave.
>> (we can rely on 2-byte alignment, but not 4-byte)
>
> Actually, we cannot rely on alignment, so we need to do this:
>
> static u32 sta_addr_hash(const void *key, u32 length, u32 seed)
> {
>         return jhash(key, ETH_ALEN, seed);
> }
>
> which still generates better code since the compiler can optimise based
> on the fixed length.
>
Nice catch!

-- 
Sergey
