Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65089 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZCJRiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 13:38:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 10:38:50 -0700
Date: Tue, 10 Mar 2009 09:38:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Daniel Drake <dsd@gentoo.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
Message-ID: <20090310163810.GA6140@tesla> (sfid-20090310_183854_146177_7CBA852D)
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com> <49B66A73.4030408@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49B66A73.4030408@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 06:26:11AM -0700, Daniel Drake wrote:
> Luis R. Rodriguez wrote:
> > The __nocast attribute is used to shut sparse up but we
> > don't need it, lets just use u16 directly.
> 
> Which warning does this remove?

Yeah sorry, I should have added that, here it is:

  CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
drivers/net/wireless/zd1211rw/zd_usb.c:363:24: warning: implicit cast from nocast type
  CC [M]  drivers/net/wireless/zd1211rw/zd_usb.o

> The purpose of this system was (I think) to make it so that if you got
> addr and value in the wrong order in calls to e.g. zd_ioread16() then
> sparse would tell you about it. Looks like your patch would remove that
> protection?

Sure.

> Admittedly it is a bit of a strange thing and no excuse for programmers
> getting parameters in the wrong order.. if it needs to go then I'm happy
> with whatever you decide.

It would seem to make the code cleaner and more legible but it just fixed a
sparse warning for me. Unfortunately I don't have an old zydas hardware to
test it with too though.

  Luis
