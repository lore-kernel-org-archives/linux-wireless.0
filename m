Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26791 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZB0DQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 22:16:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2009 19:16:14 -0800
Date: Thu, 26 Feb 2009 19:15:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"proski@gnu.org" <proski@gnu.org>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090227031525.GG13456@tesla> (sfid-20090227_041618_536807_73AAFA89)
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090227030608.GA29974@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 07:06:08PM -0800, Bob Copeland wrote:
> On Thu, Feb 26, 2009 at 06:39:12PM -0800, Luis R. Rodriguez wrote:
> > Might be worth adding a note why this is the case. Can't we simply avoid
> > this by checking earlier for the error or simply assigning it an actual
> > default _good_ hw rate value?
> 
> I guess an alternative is to initialize to 0, that would count any rx
> packets whose hw rate we don't know about as the base rate, so it would
> probably bias the RC to 1mb, but this is already one of those 'should
> never happen' cases.

Understood.

> Also I can't forsee having a rate index > 127 so
> changing the sign is pretty low risk.

Sure, it just seems a bit strange to see a signed rate index,
that's all. And if its to deal with an error I think it may
be nicer to actually use a rate that works and then warn
rather than warn and not use a valid rate at all.

Mind you I haven't checked this code in while.

  Luis
