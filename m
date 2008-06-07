Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:52654 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYFGCYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 22:24:21 -0400
Received: by wa-out-1112.google.com with SMTP id j37so948426waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 19:24:21 -0700 (PDT)
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb
	return unsigned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212783357.29134.5.camel@dv>
References: <1212774672.6340.78.camel@brick>
	 <200806062024.24681.mb@bu3sch.de>  <1212778061.6340.85.camel@brick>
	 <1212783357.29134.5.camel@dv>
Content-Type: text/plain; charset=utf-8
Date: Fri, 06 Jun 2008 19:24:20 -0700
Message-Id: <1212805460.6340.91.camel@brick> (sfid-20080607_042446_986456_E93458B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-06 at 16:15 -0400, Pavel Roskin wrote:
> On Fri, 2008-06-06 at 11:47 -0700, Harvey Harrison wrote:
>=20
> > unlikely() isn't some magic make-me-faster function, it just moves =
code
> > to the end of the function to get it out of the icache and jumps to=
 it
> > in the unlikely case it is taken.  When all there is is a return, I
> > don't think it even makes any difference.  In both these cases a co=
mment
> > is probably more appropriate.
>=20
> If we don't more return to the end, we get something like:
>=20
> compare skb->len to 10
> if more or equal goto 1
> return
> 1: <the likely case>
>=20
> =EF=BB=BFI don't know much about modern processor design, but I remem=
ber reading
> that even a very short jump would flush the instruction pipeline and
> cause some delay.
>=20
> I would keep unlikely() and let the compiler think what to do with it=
=2E
>=20

On X86-32 at least the generated code is exactly the same with or
without the unlikely()s.  I'll put them back in a follow-on if people
are really attached to them.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
