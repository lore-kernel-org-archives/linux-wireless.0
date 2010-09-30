Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63627 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0I3Qwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 12:52:40 -0400
Received: by bwz11 with SMTP id 11so1545112bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 09:52:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
Date: Thu, 30 Sep 2010 18:52:30 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, error27@gmail.com
References: <201009210057.13297.chunkeey@googlemail.com> <201009250002.21219.chunkeey@googlemail.com> <AANLkTikqRuDVwhxhXkpA3c5ppzVu_HhkaEUhyr+YBUMy@mail.gmail.com>
In-Reply-To: <AANLkTikqRuDVwhxhXkpA3c5ppzVu_HhkaEUhyr+YBUMy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009301852.31682.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 September 2010 18:27:08 Bob Copeland wrote:
> On Fri, Sep 24, 2010 at 6:02 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> 
> > hard to say, smatch must see the null dereference, when
> > we receive an action action frame where ftype is PLINK_OPEN
> > and the mesh_matches_local(&elems, sdata) check fail, but why
> > doesn't it complain about the "spin_lock_bh(&sta->lock)"?
> 
> Smatch just does pattern matching right?
Uhh, I guess that's a question for Dan.

The README-smatch sums it up as:
"It's basically a state machine that tracks the flow of code."

(I think coccicheck,  is the "pattern matching" checker, right?)
> Maybe smatch doesn't assume you are actually using
> the pointer in spin_lock_bh().
> 
> I.e. it is ok to do "&null_ptr->member", offsetof() basically
> does that; but not "null_ptr->member".

net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
error: we previously assumed 'sta' could be null.

574:        switch (sta->plink_state) {

Smatch is definitely following code paths. Is there a switch
to make it more verbose (e.g.: comment on about the conditions
about the objected code - branch)?

Regards,
	Chr
