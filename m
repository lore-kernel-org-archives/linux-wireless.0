Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab0EKS4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 14:56:37 -0400
Subject: Re: [PATCH V3] mac80211: fix paged defragmentation
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20100511182423.GC2400@tuxdriver.com>
References: <1273602131-9188-1-git-send-email-abhijeet.kolekar@intel.com>
	 <20100511181439.GB2400@tuxdriver.com>
	 <1273601810.5955.44.camel@abhi-desktop>
	 <20100511182423.GC2400@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 11:52:32 -0700
Message-ID: <1273603952.5955.45.camel@abhi-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John,
On Tue, 2010-05-11 at 11:24 -0700, John W. Linville wrote:
> On Tue, May 11, 2010 at 11:16:50AM -0700, Abhijeet Kolekar wrote:
> > Hello John,
> > On Tue, 2010-05-11 at 11:14 -0700, John W. Linville wrote:
> > > On Tue, May 11, 2010 at 11:22:11AM -0700, Abhijeet Kolekar wrote:
> > > > Paged RX skb patch broke the defragmentation. We need to read hdr again
> > > > after linearization.
> > > > 
> > > > It fixes following bug
> > > > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2194
> > > > 
> > > > Signed-off-by: Zhu, Yi <yi.zhu@intel.com>
> > > > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > > > ---
> > > > v2: Changed hdr reading.
> > > > v3: Added more comments.
> > > >  net/mac80211/rx.c |    6 ++++++
> > > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > > > index 9a08f2c..6e2a7bc 100644
> > > > --- a/net/mac80211/rx.c
> > > > +++ b/net/mac80211/rx.c
> > > > @@ -1253,6 +1253,12 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
> > > >  	if (skb_linearize(rx->skb))
> > > >  		return RX_DROP_UNUSABLE;
> > > >  
> > > > +	/*
> > > > +	 *  skb_linearize() might change the skb->data and
> > > > +	 *  previously cached variables (in this case, hdr) need to
> > > > +	 *  be refreshed with the new data.
> > > > +	 */
> > > > +	hdr = (struct ieee80211_hdr *)rx->skb->data;
> > > >  	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
> > > >  
> > > >  	if (frag == 0) {
> > > 
> > > And what about making sure the compiler doesn't optimize this away?
> > > 
> >  To avoid the double assignment, there is one more approach is to
> > directly read fc and seq_ctrl  using skb_data. I will send that in the
> > next version.
> 
> I don't think the double assignment is so bad, I just think that a
> compiler might decide to ignore the second assignment.  Am I wrong?
> 
I don't understand why compiler will ignore the second assignment other
than the above reason. What will be the solution in this case?

Abhijeet

> John


