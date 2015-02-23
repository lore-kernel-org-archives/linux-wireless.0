Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33328 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbbBWQd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 11:33:57 -0500
Message-ID: <1424709235.3075.22.camel@sipsolutions.net> (sfid-20150223_173401_135454_EA963663)
Subject: Re: [RFC] mac80211: use rhashtable for station table
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Date: Mon, 23 Feb 2015 17:33:55 +0100
In-Reply-To: <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com> (sfid-20150214_031521_538381_CAA3F347)
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
	 <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com>
	 (sfid-20150214_031521_538381_CAA3F347)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-14 at 05:14 +0300, Sergey Ryazanov wrote:

> A nice change! Couple of years ago I did some tests with real sets of
> MACs and jhash gives a better distribution than usage of a last octet.
> 
> BTW, why do you use full address and generic jhash? Hashing of two
> least significant words could be faster. Isn't it?

Well - not sure what you're trying to say? First you're saying jhash()
was clearly better and then you're saying I shouldn't use it? ;-)

Anyway - just using the last two bytes (or even 16-bit words) won't
cover the case where the locally administered bit is set in an otherwise
unchanged address, which is getting more common for P2P.

I also don't really see any major drawbacks to hashing it all?

johannes

