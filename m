Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34481 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaFDMiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 08:38:24 -0400
Message-ID: <1401885493.6079.22.camel@jlt4.sipsolutions.net> (sfid-20140604_143827_289525_0882D83F)
Subject: Re: [PATCH v7 1/5] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jun 2014 14:38:13 +0200
In-Reply-To: <CA+BoTQn=rpLqg4AU9Q6jXSo3D1os76B7bFhnqPyk=47QX5T1SQ@mail.gmail.com> (sfid-20140604_141223_261913_438F9888)
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	 <1401348851-26732-2-git-send-email-michal.kazior@tieto.com>
	 <1401708800.5528.62.camel@dubbel>
	 <CA+BoTQnhOePTuDrzv_YNU6dmroRydqWfNjSj_e0UT6=SWu5r9w@mail.gmail.com>
	 <1401815433.4157.16.camel@jlt4.sipsolutions.net>
	 <CA+BoTQn=rpLqg4AU9Q6jXSo3D1os76B7bFhnqPyk=47QX5T1SQ@mail.gmail.com>
	 (sfid-20140604_141223_261913_438F9888)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 14:12 +0200, Michal Kazior wrote:

> >> >> +     if (!(old_ctx->replaced_by && new_ctx->replaces)) {
> >> >
> >> > Isn't !old->ctx->replaced_by enough here? Do you really care if the
> >> > new_ctx will replace something else at this point?
> >>
> >> Hmm..
> >>
> >> Now that I think this should actually be just:
> >>
> >>  if (!new_ctx->replaces) { ... }
> >
> > Oh ... I think that's what I asked above. Nah. This check actually means
> > that it *is* possible that replaced_by and replaces are true at the same
> > time? *confused*
> 
> If you refer to the original condition do note the *old_ctx* and *new_ctx*.
> 
> As I stated above for a single channel context both `replaces` and
> `replaced_by` shouldn't be set at the same time.

Ah, right, I did mix that up, thanks for the clarification.

johannes

