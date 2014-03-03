Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47101 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaCCMhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 07:37:18 -0500
Message-ID: <1393850234.13669.98.camel@dubbel> (sfid-20140303_133723_400570_F05D0655)
Subject: Re: [RFC v2 3/4] mac80211: allow reservation of a running chanctx
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Mon, 03 Mar 2014 14:37:14 +0200
In-Reply-To: <CA+BoTQ=TL6my5F7RCME08ZgGw6dGGmyqmn4W-LB7WyVD7VPUOQ@mail.gmail.com>
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
	 <1393840630.13669.82.camel@dubbel>
	 <CA+BoTQ=TL6my5F7RCME08ZgGw6dGGmyqmn4W-LB7WyVD7VPUOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 11:38 +0100, Michal Kazior wrote:
> On 3 March 2014 10:57, Luca Coelho <luca@coelho.fi> wrote:
> > Hi Michał,
> >
> > I had a new idea.
> >
> >
> > On Fri, 2014-02-28 at 17:31 +0200, Luca Coelho wrote:
> >> But seriously, I'm almost fully convinced your approach is better. I'll try to spin without the RESERVED mode.
> >>
> >> But that probably will only happened Monday, because I'm already spinning down for the weekend.
> >
> > What about this: when we are reserving the chanctx, even if we're the
> > only ones in it (and thus will change it on-the-fly), we increase the
> > refcount.  This means that we would have refcount == 2, even though
> > we're the only users, but that's aligned with what happens when we
> > reserve a different chanctx.
> >
> > When we use the reservation, we do exactly the same thing as if we were
> > moving to a new chanctx, but add a intermediate step where we check if
> > the old ctx has refcount 0, in which case we change its channel:
> >
> > Reserving our own chanctx for future change:
> >
> > 1. new_ctx = old_ctx;
> > 2. increase new_ctx.refcount (new.refcount == 2, old.refcount == 2);
> 
> I was thinking of doing it like this.

Your previous comments have definitely influenced this idea. :)


> > Using the reservation:
> >
> > 1. unassign the vif from the old chanctx (old.refcount == 1,
> > new.refcount == 1);
> > 2. we decrease the refcount of the new chanctx (new.refcount == 0,
> > old.refcount == 0);
> > 3. if (old.refcount == 0) means we were the only user, change channel;
> > 4. we assign ourselves to the new chanctx (new.refcount == 1 again);
> 
> I didn't really consider unassigning vif from chanctx like that (since
> the original single-channel channel non-chanctx hw doesn't do that).
> If you assume it is safe to unassign the vif then the logic seems
> plausible. I like it.

I think in theory it should be okay.  I don't know if any driver does
something funny with it, though.

For drivers that don't implement the unassign_vif_chanctx op (like
non-chanctx drivers), it should not be a problem.

I think I could probably get rid of the
IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag I was going to introduce as
well.



> > This would make this whole thing pretty generic with only one extra if
> > for the on-the-fly chanctx change case.
> 
> I'd rather call it "in place" chanctx change case :)

Heheh, I didn't think about the term much and just assumed you'd
understand what I meant. ;)


> > If more vifs came and are changing the chanctx at the same time, it will
> > be fine too because the channel will only change when the last reserver
> > uses the reservation.
> >
> > Does this make sense?
> 
> Does the following match your idea of multi-vif reservation with the
> refcount idea?
> 
> [2 vifs on chanctx->refcount==2]
> * vif1 reserve (refcount==3)
> * vif2 reserve (refcount==4)
> * vif1 use reservation: (refcount==3)
>   * stop queues
>   * unassign vif (refcount==2)
>   * since refcount!=0 do nothing more
> * vif3 use reservation: (refcount==1)
>   * unassign vif (refcount==0)
>   * since refcount==0 do:
>     * chanctx channel change
>     * vif1 assign (refcount==1)
>     * vif2 assign (refcount==2)
>     * wake queues

Right, this is a good idea (better than what I wrote in my previous
reply).  I just need to iterate all the vifs and assign the ones with
matching reserved_chanctx (and no assigned chanctx) to this chanctx when
refcount reaches 0.


> Additionally you'd have to check after each "use reservation": if all
> vifs with matching reserved_chanctx have no assigned chanctx but the
> reserved_chanctx->refcount > 0, then disconnect all vifs with the
> matching reserved_chanctx.

I'm not sure I understood this part.  I think that when refcount reaches
0 I should disconnect the ones that are still using this chanctx, right?
All the ones that wanted to switch together, will have already done so
(since the refcount reached 0).  If there's any remaining vif in the
chanctx we want to change, disconnect them.

--
Luca.

