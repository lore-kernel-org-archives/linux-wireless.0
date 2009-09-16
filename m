Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx40.mail.ru ([94.100.176.54]:62756 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbZIPIHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 04:07:48 -0400
Date: Wed, 16 Sep 2009 12:14:43 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1382256815.20090916121443@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re[6]: cfg80211 and rfkill_backport question.
In-reply-To: <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
References: <174470396.20090916030952@mail.ru>
 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
 <792649359.20090916034611@mail.ru>
 <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
 <90263558.20090916050213@mail.ru>
 <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis!

Wednesday, September 16, 2009, 4:17:40 AM, Luis R. Rodriguez wrote:
> They don't have to be exported and inlined, its one or the other. So
Yes, that's what I supposed.
> just ensure you your symbols you have conflicts with as
> EXPORT_SYMBOL() or defined in a header file as inline. You will
> obviously also need the header declaration if defined as an
> EXPORT_SYMBOL.
>From what I checked it all looks fine to me, except that there is
a circular dependency between cfg80211 and rfkill_backport (which
is confirmed by nm output I suppose). Is this circular dependency
intentional? Or, could it be avoided? (My understanding was that
as module loader loads one file at a time, it just have no way
to resolve such symbols, maybe I'm wrong on this)

Nikolai

>   Luis


