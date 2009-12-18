Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26534 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZLRRTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 12:19:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 09:19:47 -0800
Date: Fri, 18 Dec 2009 09:19:45 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Shahar Or <mightyiampresence@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add support for Dell Vostro A860
 LED
Message-ID: <20091218171945.GE6231@tux>
References: <20091204192315.GA5786@tuxdriver.com>
 <bf87febf0912070205k40a7286dpbb48cfcc494203d2@mail.gmail.com>
 <20091207215903.GC18939@tuxdriver.com>
 <b6c5339f0912080657s7cfccd4dp6525702e609bdd5f@mail.gmail.com>
 <43e72e890912080801s52607743s738ed6cdad7d154e@mail.gmail.com>
 <20091208160659.GG15172@tuxdriver.com>
 <43e72e890912080830v40ff214co178fb17c38439e70@mail.gmail.com>
 <bf87febf0912180342w134d92eblc24f326cfa751b08@mail.gmail.com>
 <43e72e890912180737s382c24c5q8720f1e3138fefb@mail.gmail.com>
 <bf87febf0912180903x168462ffw6c9faeac0cd1596c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <bf87febf0912180903x168462ffw6c9faeac0cd1596c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 09:03:26AM -0800, Shahar Or wrote:
> On Fri, Dec 18, 2009 at 5:37 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> >> If we have all the IDs from the INF file, then why do we need this in
> >> userspace? Is the list growing?
> >
> > No, but for other newer hardware/drivers it can likely grow, so my
> > comment was more of a generic driver approach to this.
> 
> Is this a linux-wireless thing

You mean my suggestion? It depends, I personally am not aware of
upstream drivers keeping tabs on knobs in userspace currently
but I do think things like configs are used to tweak, for example
Oracle db stuff. configs can technically also be used to expose
knobs for example for non-generic device configuration stuff
for example but as far as I can tell no one has really used it
yet for this. It does' mean its not possible. The other question
is where do we stuff this in userspace and if it really makes
sense to start following that practice. For GPIO pin mapping,
perhaps given the number of patches I see for it but since its
the only thing I see a good use of perhaps its not worth it.
The kernel should always use default sensible values but since
this is more of database thing it makes sence to start thinking
istead of userspace for a better solution. Examples of moving
large dbs to userspace could be the preference on USB side to
not keep the USB vendor/device IDs names in the kernel, and also
the regulatory database stuff.

> or do other areas of linux keep some
> data in userspace?

I gave a few examples, not sure what else the kernel keeps in
userspace for data which is generic like that. Moving PCI device
vendor/device names might be good example.

  Luis
