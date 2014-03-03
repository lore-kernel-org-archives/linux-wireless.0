Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55443 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCCJ5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 04:57:14 -0500
Message-ID: <1393840630.13669.82.camel@dubbel> (sfid-20140303_105721_687690_7850629B)
Subject: Re: [RFC v2 3/4] mac80211: allow reservation of a running chanctx
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Mon, 03 Mar 2014 11:57:10 +0200
In-Reply-To: <5cdea7fa-8919-48b0-898a-a03cbd26123d@email.android.com>
References: <1393512081-31453-1-git-send-email-luca@coelho.fi>
	 <1393512081-31453-4-git-send-email-luca@coelho.fi>
	 <CA+BoTQ=yoYAcg8Jo2zoV76gmXe9UU1=wSi1CVWfwiRpqC7yr6w@mail.gmail.com>
	 <1393589841.13669.32.camel@dubbel>
	 <CA+BoTQmaF+johnB5ia+ez5dFKYPWWwk7E=482Q3hzLv=YvZAvQ@mail.gmail.com>
	 <1393594886.13669.47.camel@dubbel>
	 <CA+BoTQkafvtCDU5LkDcyVonO2T=koaBCWABzSQmnDOXJh=AvDA@mail.gmail.com>
	 <1393597923.13669.65.camel@dubbel>
	 <CA+BoTQk=YLd+bur3HkJ5jwrT-EYKMF8+nzJSX+bJP_psesuE5g@mail.gmail.com>
	 <5cdea7fa-8919-48b0-898a-a03cbd26123d@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michał,

I had a new idea.


On Fri, 2014-02-28 at 17:31 +0200, Luca Coelho wrote:
> But seriously, I'm almost fully convinced your approach is better. I'll try to spin without the RESERVED mode.
> 
> But that probably will only happened Monday, because I'm already spinning down for the weekend.

What about this: when we are reserving the chanctx, even if we're the
only ones in it (and thus will change it on-the-fly), we increase the
refcount.  This means that we would have refcount == 2, even though
we're the only users, but that's aligned with what happens when we
reserve a different chanctx.

When we use the reservation, we do exactly the same thing as if we were
moving to a new chanctx, but add a intermediate step where we check if
the old ctx has refcount 0, in which case we change its channel:

Reserving our own chanctx for future change:

1. new_ctx = old_ctx;
2. increase new_ctx.refcount (new.refcount == 2, old.refcount == 2);


Using the reservation:

1. unassign the vif from the old chanctx (old.refcount == 1,
new.refcount == 1);
2. we decrease the refcount of the new chanctx (new.refcount == 0,
old.refcount == 0);
3. if (old.refcount == 0) means we were the only user, change channel;
4. we assign ourselves to the new chanctx (new.refcount == 1 again);


This would make this whole thing pretty generic with only one extra if
for the on-the-fly chanctx change case.

If more vifs came and are changing the chanctx at the same time, it will
be fine too because the channel will only change when the last reserver
uses the reservation.

Does this make sense?

--
Luca.

