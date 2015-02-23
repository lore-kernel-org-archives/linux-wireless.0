Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:41033 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbbBWV1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 16:27:13 -0500
Received: by yks20 with SMTP id 20so731493yks.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 13:27:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424709235.3075.22.camel@sipsolutions.net>
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
 <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com> <1424709235.3075.22.camel@sipsolutions.net>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Tue, 24 Feb 2015 00:26:52 +0300
Message-ID: <CAHNKnsR0j1u6Eu2e19pzcu2Rw7nZ6D6BKV-cRg9KTwoKO74fdQ@mail.gmail.com> (sfid-20150223_222718_360973_93C6ABFC)
Subject: Re: [RFC] mac80211: use rhashtable for station table
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-23 19:33 GMT+03:00 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2015-02-14 at 05:14 +0300, Sergey Ryazanov wrote:
>
>> A nice change! Couple of years ago I did some tests with real sets of
>> MACs and jhash gives a better distribution than usage of a last octet.
>>
>> BTW, why do you use full address and generic jhash? Hashing of two
>> least significant words could be faster. Isn't it?
>
> Well - not sure what you're trying to say? First you're saying jhash()
> was clearly better and then you're saying I shouldn't use it? ;-)
>
In first case, I mean the jhash _algorithm_, which has a better
distribution, in second case I mean the _generic_ jhash() _function_
and express my doubts about its performance. See below.

> Anyway - just using the last two bytes (or even 16-bit words) won't
> cover the case where the locally administered bit is set in an otherwise
> unchanged address, which is getting more common for P2P.
>
> I also don't really see any major drawbacks to hashing it all?
>
I agree that hashing all octets is not a drawback. But the jhash()
function is tailored to the input data of variable length, while we
have a vector of fixed length and appropriate functions. Could we do
the hashing in following way:

u32 sta_info_hash(void *addr, u32 len, u32 seed)
{
  u32 *k = addr + 2;
  return jhash_1word(*k, seed);
}

structu rhashtable_pararms param = {
  ...
  .hashfn = sta_info_hash,
  ...
}

or even (to account LA bit):

u32 sta_info_hash(void *addr, u32 len, u32 seed)
{
  u32 *k = addr;
  return jhash_2words(k[0], k[1], seed);
}

structu rhashtable_pararms param = {
  ...
  .key_len = 8,
  .hashfn = sta_info_hash,
  ...
}

This could save a couple of CPU circles and a couple of bytes in the
output image :)

-- 
Sergey
