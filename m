Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35252 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbbBWWBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 17:01:38 -0500
Message-ID: <1424728896.1899.4.camel@sipsolutions.net> (sfid-20150223_230144_756013_7AD36172)
Subject: Re: [RFC] mac80211: use rhashtable for station table
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Date: Mon, 23 Feb 2015 23:01:36 +0100
In-Reply-To: <1424728360.1899.3.camel@sipsolutions.net> (sfid-20150223_225246_802504_8A0F3B9D)
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
	 <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com>
	 <1424709235.3075.22.camel@sipsolutions.net>
	 <CAHNKnsR0j1u6Eu2e19pzcu2Rw7nZ6D6BKV-cRg9KTwoKO74fdQ@mail.gmail.com>
	 (sfid-20150223_222714_678902_C1EA88E2) <1424728360.1899.3.camel@sipsolutions.net>
	 (sfid-20150223_225246_802504_8A0F3B9D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-23 at 22:52 +0100, Johannes Berg wrote:

> We also can't rely on 4-byte alignment though, so perhaps we should do
> something like
> 
> u32 sta_info_hash(void *addr, u32 len, u32 seed)
> {
> 	u16 *a = addr;
> 
> 	return jhash_3words(a[0], a[1], a[2], seed);
> }

Or better do

	return jhash_2words(addr[0], (addr[1] << 16) | addr[2], seed);

since I have no idea how the missing high 16 bits would behave.
(we can rely on 2-byte alignment, but not 4-byte)

johannes

