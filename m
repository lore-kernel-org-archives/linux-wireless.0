Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58956 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab0JAIZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 04:25:57 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so992504wwj.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 01:25:56 -0700 (PDT)
Date: Fri, 1 Oct 2010 10:25:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
Message-ID: <20101001082531.GA2781@bicker>
References: <201009210057.13297.chunkeey@googlemail.com> <201009250002.21219.chunkeey@googlemail.com> <AANLkTikqRuDVwhxhXkpA3c5ppzVu_HhkaEUhyr+YBUMy@mail.gmail.com> <201009301852.31682.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009301852.31682.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 06:52:30PM +0200, Christian Lamparter wrote:
> On Thursday 30 September 2010 18:27:08 Bob Copeland wrote:
> > On Fri, Sep 24, 2010 at 6:02 PM, Christian Lamparter
> > <chunkeey@googlemail.com> wrote:
> > 
> > > hard to say, smatch must see the null dereference, when
> > > we receive an action action frame where ftype is PLINK_OPEN
> > > and the mesh_matches_local(&elems, sdata) check fail, but why
> > > doesn't it complain about the "spin_lock_bh(&sta->lock)"?
> > 
> > Smatch just does pattern matching right?
> Uhh, I guess that's a question for Dan.
> 
> The README-smatch sums it up as:
> "It's basically a state machine that tracks the flow of code."
> 
> (I think coccicheck,  is the "pattern matching" checker, right?)
> > Maybe smatch doesn't assume you are actually using
> > the pointer in spin_lock_bh().
> > 
> > I.e. it is ok to do "&null_ptr->member", offsetof() basically
> > does that; but not "null_ptr->member".
> 

Yes.  You are right.

This is from check_check_deref.c which handles this as a special case
because people quite often do:

	struct foo *bar = &x->y;

	if (!x)
		return;

If you comment out the "if (getting_address())" check then it will
complain.

> net/mac80211/mesh_plink.c +574 mesh_rx_plink_frame(168)
> error: we previously assumed 'sta' could be null.
> 
> 574:        switch (sta->plink_state) {
> 
> Smatch is definitely following code paths. Is there a switch
> to make it more verbose (e.g.: comment on about the conditions
> about the objected code - branch)?

There is a --debug but I suspect it's way more verbose than what you
want.

You could also hack the net/mac80211/mesh_plink.c source file and add
an "#include /path/to/smatch/check_debug.h" and sprinkle the code with
calls to __smatch_cur_slist() which will make it dump all the current
states at that point.

regards,
dan carpenter

