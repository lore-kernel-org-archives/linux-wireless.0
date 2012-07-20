Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33947 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GTTBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 15:01:42 -0400
Received: by wgbdr13 with SMTP id dr13so3942582wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2012 12:01:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: carl9170: improve unicast PS buffering
Date: Fri, 20 Jul 2012 21:01:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <20120719113628.GA32727@elgon.mountain> <CAAd0S9CeFhDi0AZAX7zqcLFkNtiK6vv4i4UCMs8oB5Z0pKe+mA@mail.gmail.com> <20120720072315.GK16348@mwanda>
In-Reply-To: <20120720072315.GK16348@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207202101.29600.chunkeey@googlemail.com> (sfid-20120720_210216_019957_B95DF10F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 July 2012 09:23:15 Dan Carpenter wrote:
> On Thu, Jul 19, 2012 at 02:29:41PM +0200, Christian Lamparter wrote:
> > Hello Dan,
> > 
> > On Thu, Jul 19, 2012 at 1:36 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > > Sorry this is so old.  I was going through some old Smatch warnings.
> > >
> > > This is a semi-automatic email about new static checker warnings.
> > >
> > > The patch caf1eae20668: "carl9170: improve unicast PS buffering" from
> > > Apr 24, 2011, leads to the following Smatch complaint:
> > >
> > > drivers/net/wireless/ath/carl9170/tx.c:1488 carl9170_op_tx()
> > >          error: we previously assumed 'sta' could be null (see line 1482)
> > >
> > > drivers/net/wireless/ath/carl9170/tx.c
> > >   1481
> > >   1482          if (sta) {
> > >                    ^^^^^
> > > New check.
> > >
> > >   1483                  struct carl9170_sta_info *stai = (void *) sta->drv_priv;
> > >   1484                  atomic_inc(&stai->pending_frames);
> > >   1485          }
> > >   1486
> > >   1487          if (info->flags & IEEE80211_TX_CTL_AMPDU) {
> > >   1488                  run = carl9170_tx_ampdu_queue(ar, sta, skb);
> > >                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Old dereference of "sta" inside the call to carl9170_tx_ampdu_queue().
> > >
> > >   1489                  if (run)
> > >   1490                          carl9170_tx_ampdu(ar);
> > >
> > > Probably we can remove the check?
> > What check do you want to remove? The check in smatch
> > which produces the warning/error. Or the "if (sta) {" in line
> > 1482?
> > 
> > Or do you mean I should extend the check in 1487 to:
> > if (sta) {
> >      ...
> >      if (info->flags & IEEE80211_TX_CTL_AMPDU) {
> >      ....
> >      }
> > }
> 
> What I'm saying is that I don't ?know? if it's possible
> for "sta" to be NULL at this pointer or not.
no, it is not possible.
In fact, in order to set up a ampdu session, the stack would
call the driver's op_ampdu_action callback which always needs
a station.

Regards,
	Chr

(So, where do we go from here -  do you still want a patch?)
