Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59306 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932350AbdKBKa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 06:30:28 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        "Karthik Doddayennegere Ananthapadmanabha" <karthida@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in
 11n_rxreorder.c
Date: Thu, 2 Nov 2017 10:30:25 +0000
Message-ID: <cb98c452aa344fc0b501a776cfa8708a@SC-EXCH02.marvell.com> (sfid-20171102_113032_298002_5409CD1D)
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com>
 <20171101212853.GA89416@google.com>
In-Reply-To: <20171101212853.GA89416@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> On Tue, Oct 31, 2017 at 03:12:45PM +0530, Ganapathi Bhat wrote:
> > From: Karthik Ananthapadmanabha <karthida@marvell.com>
> >
> > Fix the incorrect usage of rx_pkt_lock spinlock. Realsing the spinlock
> > while the element is still in process is unsafe. The lock must be
> > released only after the element processing is complete.
> >
> > Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > index 1edcdda..0149c4a 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> > @@ -124,9 +124,10 @@ static int mwifiex_11n_dispatch_pkt(struct
> mwifiex_private *priv, void *payload)
> >                     rx_tmp_ptr = tbl->rx_reorder_ptr[i];
> >                     tbl->rx_reorder_ptr[i] = NULL;
> >             }
> > -           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
>
> So, what is this lock protecting? Is it for protecting the packet itself, or for
> protecting the ring buffer?

This lock is protecting the ring buffer but with the current change, we are trying also to protect the packet too.

> As I read it, it's just the latter, since once we've
> removed it from the ring buffer (and are about to dispatch it up toward the
> networking layer), it's handled only by a single context (or else, protected via
> some other common lock(s)).
>
> If I'm correct above, then I think the current code here is actually safe, since
> it holds the lock while removing from the ring buffer -- after it's removed
> from the ring, there's no way another thread can find this payload, and so we
> can release the lock.

There are cases where the ring buffer is iterated by cfg80211 thread:
mwifiex_cfg80211_tdls_oper => mwifiex_tdls_oper => mwifiex_tdls_process_disable_link => mwifiex_11n_cleanup_reorder_tbl => mwifiex_del_rx_reorder_entry => mwifiex_11n_dispatch_pkt_until_start_win => {iterates the ring buffer}
So, at worst case we can have two threads (main & cfg80211) running mwifiex_11n_dispatch_pkt_until_start_win(), iterating the ring buffer.

>
> On a related note: I don't actually see the ring buffer *insertion* being
> protected by this rx_pkt_lock, so is it really useful? See
> mwifiex_11n_rx_reorder_pkt(). Perhaps the correct lock is actually
> rx_reorder_tbl_lock()? Except that serves multiple purposes it seems...

Right, ring buffer insertion is not protected.  I think we should be using both rx_reorder_tbl_lock(which is already present) and rx_pkt_lock(we need to add) during insertion (mwifiex_11n_rx_reorder_pkt()).

Also, we should be using rx_pkt_lock instead of rx_reorder_tbl_lock in mwifiex_11n_find_last_seq_num().
>
> Another thought: from what I can tell, all of these operations are
> *only* performed on the main thread, so there's actually no concurrency
> involved at all. So we also could probably drop this lock entirely...

Let us know your inputs on above observations.
>
> I guess the real point is: can you explain better what you intend this lock to
> do? Then we can review whether you're accomplishing your intention, or
> whether we should improve the usage of this lock in some other way, or
> perhaps even kill it entirely.
>
> Thanks,
> Brian
>
> >             if (rx_tmp_ptr)
> >                     mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> > +
> > +           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >     }
> >
> >     spin_lock_irqsave(&priv->rx_pkt_lock, flags); @@ -167,8 +168,8 @@
> > static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void
> *payload)
> >             }
> >             rx_tmp_ptr = tbl->rx_reorder_ptr[i];
> >             tbl->rx_reorder_ptr[i] = NULL;
> > -           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >             mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> > +           spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
> >     }
> >
> >     spin_lock_irqsave(&priv->rx_pkt_lock, flags);
> > --
> > 1.9.1
> >

Regards,
Ganapathi
