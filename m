Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:39524 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbbBNCPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 21:15:20 -0500
Received: by mail-yk0-f170.google.com with SMTP id 10so5368582ykt.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 18:15:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sat, 14 Feb 2015 05:14:59 +0300
Message-ID: <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com> (sfid-20150214_032228_249262_CDB5E707)
Subject: Re: [RFC] mac80211: use rhashtable for station table
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-14 0:47 GMT+03:00 Johannes Berg <johannes@sipsolutions.net>:
> We currently have a hand-rolled table with 256 entries and are
> using the last byte of the MAC address as the hash. This hash
> is obviously very fast, but collisions are easily created and
> we waste a lot of space in the common case of just connecting
> as a client to an AP where we just have a single station. The
> other common case of an AP is also suboptimal due to the size
> of the hash table and the ease of causing collisions.
>
> Convert all of this to use rhashtable with jhash, which gives
> us the advantage of a far better hash function (with random
> perturbation to avoid hash collision attacks) and of course
> that the hash table grows and shrinks dynamically with chain
> length, improving both cases above.
>
A nice change! Couple of years ago I did some tests with real sets of
MACs and jhash gives a better distribution than usage of a last octet.

BTW, why do you use full address and generic jhash? Hashing of two
least significant words could be faster. Isn't it?

-- 
Sergey
