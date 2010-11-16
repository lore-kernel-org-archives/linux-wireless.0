Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:37975 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab0KPTHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:07:05 -0500
Date: Tue, 16 Nov 2010 20:06:54 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	jay_hung@ralinktech.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com,
	Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Message-ID: <20101116190654.GA3659@sig21.net>
References: <201011131911.47346.IvDoorn@gmail.com>
 <201011161742.08503.helmut.schaa@googlemail.com>
 <20101116165302.GA29570@sig21.net>
 <201011161800.40654.helmut.schaa@googlemail.com>
 <AANLkTi=ANfE3s8RUmS5=qyofqHM2geRnatK-eCUjovEc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=ANfE3s8RUmS5=qyofqHM2geRnatK-eCUjovEc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(quoting repaired)

On Tue, Nov 16, 2010 at 06:36:27PM +0100, Ivo Van Doorn wrote:
> On Nov 16, 2010 6:01 PM, "Helmut Schaa" <helmut.schaa@googlemail.com> wrote:
> > Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> >> On Tue, Nov 16, 2010 at 05:42:08PM +0100, Helmut Schaa wrote:
> >> >
> >> > Right. We could of course add a mac80211-queue <-> rt2x00-queue mapping in
> >> > the appropriate places or rename the QID_* identifiers accordingly. Not sure
> >> > if it's worth it ...
> >>
> >> Hm, reducing confusion enhances maintainability.
> >
> > I fully agree. I just meant that there are more severe issues in rt2x00 I plan
> > to work on. But feel free to send a patch :)
> 
> But is this a mapping problem, or naming problem? Queue 0 is supposed to be
> the queue with highest priority right?
> So that would inficate a naming problem only

The main source of confusion for me is the implicit conversion
between the queue number 0..3 used by the mac80211 layer
and the enum data_queue_qid used by rt2x00, which assignes a
different _meaning_ to the numbers.  IMHO the enum values
should be rearranged.  Maybe a comment would be good, too.

And I'm still confused.  There is code like e.g.
rt2400pci_kick_tx_queue() which tests against QID_AC_BE etc.,
but does it really the kick the right queue?
IOW, where does the qid passed to it ultimately come from?

  rt2x00mac_tx():   qid = skb_get_queue_mapping(skb);  i.e. 2 for AC_BE
  -> rt2x00queue_get_queue()  returns queue #2 which has queue->qid == QID_AC_VI
    -> rt2x00queue_write_tx_frame()
      -> rt2400pci_kick_tx_queue() is called with qid == QID_AC_VI

Bug?


Thanks
Johannes
