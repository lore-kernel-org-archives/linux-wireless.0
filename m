Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53136 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0ECSPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 14:15:11 -0400
Date: Mon, 3 May 2010 14:02:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH V2] mac80211: fix paged defragmentation
Message-ID: <20100503180241.GB25748@tuxdriver.com>
References: <1272668279-6065-1-git-send-email-abhijeet.kolekar@intel.com>
 <87hbmsa4bj.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87hbmsa4bj.fsf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 30, 2010 at 07:49:52PM -0400, Ben Gamari wrote:
> On Fri, 30 Apr 2010 15:57:59 -0700, Abhijeet Kolekar <abhijeet.kolekar@intel.com> wrote:
> > 
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index 72efbd8..e7217e2 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -1255,6 +1255,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
> >  	if (skb_linearize(rx->skb))
> >  		return RX_DROP_UNUSABLE;
> >  
> > +	hdr = (struct ieee80211_hdr *)rx->skb->data;
> >  	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
> >  
> It seems to me that this might deserve a comment describing exactly why
> hdr needs to be set twice in one function. To the uninformed outsider
> the code simply seems redundant. It's unclear semantics like this that
> could cause nasty issues when someone goes back for housecleaning. Just
> a thought.

Not only that, but is there something we need to do to make sure the
compiler doesn't think it can optimize away the second assignment
of hdr?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
