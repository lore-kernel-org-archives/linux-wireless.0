Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:56756 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdKGCZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 21:25:13 -0500
Received: by mail-io0-f194.google.com with SMTP id m81so527033ioi.13
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 18:25:13 -0800 (PST)
Date: Mon, 6 Nov 2017 18:25:09 -0800
From: Brian Norris <briannorris@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: Re: [EXT] Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in
 11n_rxreorder.c
Message-ID: <20171107022508.GA42502@google.com> (sfid-20171107_032520_232579_0224B172)
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com>
 <20171101212853.GA89416@google.com>
 <cb98c452aa344fc0b501a776cfa8708a@SC-EXCH02.marvell.com>
 <CAD=FV=VuxFtDdcMndLNzVYDoid8N3jP46j0sOFXG1D4CzX0=Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=FV=VuxFtDdcMndLNzVYDoid8N3jP46j0sOFXG1D4CzX0=Zw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Doug and Ganapathi,

On Mon, Nov 06, 2017 at 04:42:20PM -0800, Doug Anderson wrote:
> Hi,
> 
> Please take the review below with a grain of salt since I'm not
> terribly familiar with this driver.  I thought I might be able to help
> since I had previously looked at some of the spinlock stuff, but after
> digging through the below I'm not 100% convinced I understand this
> driver enough to do a quick review...
> 
> On Thu, Nov 2, 2017 at 3:30 AM, Ganapathi Bhat <gbhat@marvell.com> wrote:
> > Hi Brian,
> >
> >> On Tue, Oct 31, 2017 at 03:12:45PM +0530, Ganapathi Bhat wrote:
> >> > From: Karthik Ananthapadmanabha <karthida@marvell.com>
> >> >
> >> > Fix the incorrect usage of rx_pkt_lock spinlock. Realsing the spinlock
> >> > while the element is still in process is unsafe. The lock must be
> >> > released only after the element processing is complete.
> >> >
> >> > Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> >> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> >> > ---
> >> >  drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 5 +++--
> >> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> >> > b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> >> > index 1edcdda..0149c4a 100644
> >> > --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> >> > +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> >> > @@ -124,9 +124,10 @@ static int mwifiex_11n_dispatch_pkt(struct
> >> mwifiex_private *priv, void *payload)
> >> >                     rx_tmp_ptr = tbl->rx_reorder_ptr[i];
> >> >                     tbl->rx_reorder_ptr[i] = NULL;
> >> >             }
> >> > -           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >>
> >> So, what is this lock protecting? Is it for protecting the packet itself, or for
> >> protecting the ring buffer?
> >
> > This lock is protecting the ring buffer but with the current change, we are trying also to protect the packet too.
> 
> What are you trying to protect the packet from?  In other words: what
> other code is trying to make changes to the same structure?  I'd agree

Agreed on this question. I don't understand what, specifically, about
"the packet" you're trying to protect, nor what other code might be
accessing it.

> with Brian that on first glance nobody else can have a reference to
> this packet since we've removed it from the global list.  If you're

Right, if we're safely removing it from the pseudo ring buffer, then
nobody else should have access to it now.

> trying to protect something internal to this structure or something
> global to mwifiex then it seems like you'd want a different lock...
> 
> 
> >> As I read it, it's just the latter, since once we've
> >> removed it from the ring buffer (and are about to dispatch it up toward the
> >> networking layer), it's handled only by a single context (or else, protected via
> >> some other common lock(s)).
> >>
> >> If I'm correct above, then I think the current code here is actually safe, since
> >> it holds the lock while removing from the ring buffer -- after it's removed
> >> from the ring, there's no way another thread can find this payload, and so we
> >> can release the lock.
> >
> > There are cases where the ring buffer is iterated by cfg80211 thread:
> > mwifiex_cfg80211_tdls_oper => mwifiex_tdls_oper => mwifiex_tdls_process_disable_link => mwifiex_11n_cleanup_reorder_tbl => mwifiex_del_rx_reorder_entry => mwifiex_11n_dispatch_pkt_until_start_win => {iterates the ring buffer}
> > So, at worst case we can have two threads (main & cfg80211) running mwifiex_11n_dispatch_pkt_until_start_win(), iterating the ring buffer.
> 
> Let me see if I'm understanding properly.
> 
> There's a global (one for the whole driver) list called the

Just a point of order: it's a single list for each 'mwifiex_private' --
there can actually be multiple virtual interfaces attached to each
physical wiphy interface, and each virtual interface gets a
'mwifiex_private' instance. But otherwise, your descriptions are
accurate I believe.

> "rx_reorder_tbl_ptr".  Insertion, deletion, and iteration of elements
> into this list are protected by the global "rx_reorder_tbl_lock" so we
> don't corrupt the linked list structure.
> 
> The actual elements in the "rx_reorder_tbl_ptr" are _not_ protected by
> the global "rx_reorder_tbl_lock".  I make this statement because I see
> mwifiex_11n_get_rx_reorder_tbl() which drops the lock before returning
> an entry.

Actually, patch 3 is changing that one :)

> ...and it seems sane that there could be a separate (more
> fine grained) lock protecting these elements.  It is OK to keep a
> pointer to an element in this list without holding the lock--even if
> it's removed from the list the pointer is still valid.  Presumably
> full deletion of the element (and any other access of members of the
> element) is protected by some other lock.

Aiee! You have too much faith. mwifiex_11n_del_rx_reorder_tbl_by_ta() ->
mwifiex_del_rx_reorder_entry(), for instance, has *very* bad handling of
this lock. It looks like:
(a) it does a series of acquire/release pairs on this lock while still
retaining the mwifiex_rx_reorder_tbl pointer. That's bad.
(b) it doesn't have any other lock to protect deletion; it *hopes* that
it cleared out the remaining packets in its buffer
(mwifiex_11n_dispatch_pkt_until_start_win()); but it doesn't hold any
other relevant locks between that and this:

        spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
        list_del(&tbl->list);
        spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);

        kfree(tbl->rx_reorder_ptr);
        kfree(tbl);

That's pretty bad.

I think it's best to work toward holding that lock while anyone is accessing
the entry. So we should only drop the lock when we're done accessing the
element, or when we've removed it from the list.

> Each element in the "rx_reorder_tbl_ptr" list is a "struct
> mwifiex_rx_reorder_tbl".  It contains a pseudo-circular buffer
> (win_size elements big) "tbl->rx_reorder_ptr[]".  Insertions and
> deletions from the pseudo-circular buffer are supposed to be protected
> by the global "rx_pkt_lock".

Seems right to me.

> In general if you hold an "index" into
> this buffer you should be holding the "rx_pkt_lock",

Sure.

> but if you hold
> one of the elements (each element is a pointer) then you presumably
> don't need the "rx_pkt_lock" (if you do, I'd be curious as to why).

You mean, "if you hold one of these elements [and have removed it from the ring
buffer]" then you don't need the lock? If so, I agree.

> Did I get that right?
> 
> 
> So overall the "rx_pkt_lock" seems a bit fishy to me.
> 
> My first clue that something seems wrong is that "rx_pkt_lock" is
> global (one for the whole driver) but seems to be protecting something
> that is more fine-grained.  Locks really ought to be part of the
> structure whose elements they are protecting.  Said another way, I'd
> expect "rx_pkt_lock" NOT to be in "priv" but for there to be a
> separate instance of "rx_pkt_lock" inside each "struct
> mwifiex_rx_reorder_tbl".  That would make it much more obvious what
> was being protected and also would allow different tables to be worked
> on at the same time.
> 
> NOTE: it's probably not the end of the world if there's a single
> global "rx_pkt_lock", it's just less ideal and not all that different
> than having one big lock protecting everything in the driver.

Agreed on the above 2 paragraphs. At a minimum, rx_pkt_lock should be
documented better. But part of that documentation is typically putting the lock
near what it's protecting.

But overall, I'm not sure we're getting much interesting concurrency
here at all, and so I'm not sure if all the (poort attempt at)
fine-grained locking is even helpful. Ganapathi only pointed out
cfg80211 TDLS operations as the "2nd thread of execution" besides the
mwifiex "main thread" -- this thread is only used for configuration
(e.g., setup, teardown, and configuration of TDLS links). And any time
we're holding the "fine grained" rx_pkt_lock, we already are holdling
the larger table lock.

> The other thing that is fishy is that "rx_pkt_lock" doesn't seem to be
> reliably protecting, again as Brian pointed out.  Specifically:
> 
> * It seems like "start_win" is supposed to be protected by
> "rx_pkt_lock" too, but it's not in
> mwifiex_11n_dispatch_pkt_until_start_win() (and many other places, I
> didn't check).  In general any place where we're holding an _index_
> into the table seems like it should have the "rx_pkt_lock" and
> "start_win" is an index.  Why do I say this?  If you are holding an
> _index_ and something is deleted from the list (or shuffled) then the
> index just won't be valid anymore.  Thus if others can be inserting /
> removing / shuffling the list then holding an index isn't safe without
> the lock.

Agreed.

> * There are several places that access "rx_reorder_ptr" without
> grabbing "rx_pkt_lock".  That seems wrong.  For instance,
> mwifiex_get_rx_reorder_tbl(), but probably other places too.

Ah, yes.

> * Functions like mwifiex_11n_find_last_seq_num() seem quite confused.
> They act on a table entry but for some reason grab the
> "rx_reorder_tbl_lock", which was supposed to be protecting the linked
> list (I think).

Agreed.

> Worse yet mwifiex_11n_find_last_seq_num() returns an
> _index_ into the pseudo-queue.  I don't think that is a super valid
> thing to do unless you assume that the caller has the
> rx_reorder_tbl_lock, which it doesn't.  Probably
> mwifiex_11n_find_last_seq_num() should require the caller hold
> "rx_pkt_lock".

I'm not sure the right solution here, but it does look wrong today. The
only saving grace here would be if we don't care about this being
slightly inaccurate. For instance, I *think* it's fine to return some of
this out of order.

On a similar note: why does mwifiex_11n_dispatch_pkt_until_start_win()
release rx_pkt_lock in between each index (i.e., the "for (i = 0; i <
pkt_to_send; ++i)" loop)? That means that the entire ring buffer
indexing could change underneath our feet. I'm not sure this is
technically unsafe (we do still grab the lock and do NULL checks), but
it might still cause undesireable results around what packets get
dispatched or now -- i.e., we might not *really* be honoring the window
arguments that were passed in.

> >> On a related note: I don't actually see the ring buffer *insertion* being
> >> protected by this rx_pkt_lock, so is it really useful? See
> >> mwifiex_11n_rx_reorder_pkt(). Perhaps the correct lock is actually
> >> rx_reorder_tbl_lock()? Except that serves multiple purposes it seems...
> >
> > Right, ring buffer insertion is not protected.  I think we should be using both rx_reorder_tbl_lock(which is already present) and rx_pkt_lock(we need to add) during insertion (mwifiex_11n_rx_reorder_pkt()).
> 
> As far as I see mwifiex_11n_rx_reorder_pkt() doesn't hold
> "rx_reorder_tbl_lock" for the whole function.  It just grabs it to
> search the linked list and then drops it.  Is that right?  Seems OK
> given my current (limited) understanding but it sounded like you were
> expecting it to be held for the whole function?

I think patch 3 fixes that? It tries to grab the lock for (almost) the
entire function.

> IMHO then it needs to grab "rx_pkt_lock" before the access to
> tbl->start_win, but I haven't looked at everything fully.
> 
> 
> > Also, we should be using rx_pkt_lock instead of rx_reorder_tbl_lock in mwifiex_11n_find_last_seq_num().
> >>
> >> Another thought: from what I can tell, all of these operations are
> >> *only* performed on the main thread, so there's actually no concurrency
> >> involved at all. So we also could probably drop this lock entirely...
> >
> > Let us know your inputs on above observations.
> 
> Not sure if my thoughts above made sense or were useful.  Hopefully I
> didn't sound too stupid...  ;)

Not stupid to me. Thanks for looking.

Brian

> >> I guess the real point is: can you explain better what you intend this lock to
> >> do? Then we can review whether you're accomplishing your intention, or
> >> whether we should improve the usage of this lock in some other way, or
> >> perhaps even kill it entirely.
> >>
> >> Thanks,
> >> Brian
> >>
> >> >             if (rx_tmp_ptr)
> >> >                     mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> >> > +
> >> > +           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >> >     }
> >> >
> >> >     spin_lock_irqsave(&priv->rx_pkt_lock, flags); @@ -167,8 +168,8 @@
> >> > static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void
> >> *payload)
> >> >             }
> >> >             rx_tmp_ptr = tbl->rx_reorder_ptr[i];
> >> >             tbl->rx_reorder_ptr[i] = NULL;
> >> > -           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >> >             mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> >> > +           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >> >     }
> >> >
> >> >     spin_lock_irqsave(&priv->rx_pkt_lock, flags);
> >> > --
> >> > 1.9.1
> >> >
> >
> > Regards,
> > Ganapathi
