Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45844 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1FGSQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 14:16:24 -0400
Date: Tue, 7 Jun 2011 14:05:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
Message-ID: <20110607180552.GF9320@tuxdriver.com> (sfid-20110607_201627_681498_BD86CFE6)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
 <1306823717.9366.3.camel@jlt3.sipsolutions.net>
 <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com>
 <20110606184447.GG2604@tuxdriver.com>
 <1307386634.3894.14.camel@jlt3.sipsolutions.net>
 <8F3AF1C9F856774F8C8D67AA7EDFEC88012CE709@nasanexd02d.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8F3AF1C9F856774F8C8D67AA7EDFEC88012CE709@nasanexd02d.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 07, 2011 at 08:39:57AM +0000, Manoharan, Rajkumar wrote:
> > > On Mon, 2011-06-06 at 14:44 -0400, John W. Linville wrote:
> > 
> > > > During the channel type change, the pending tx frames in hw queues are dropped by hw config.
> > > > But before updating rate control, the packets can be queued again with older HT rates.
> > > > This contradicts with hw config mode and sometimes is causing baseband issues. This issue
> > > > was observed only on flooding uplink traffic. To ensure that the frames are always xmitted with
> > > > updated rates, the queues are stopped before hw config and waken up after rc updation.
> >> 
> > > Johannes, do you find this explanation satisfactory (perhaps with
> > > some new queue stop reason definition)?
> > 
> > No, it doesn't address the fact that any packet that is pending will
> > still be processed -- as I said before, the stop doesn't include a
> > flush.
> 
> Yes. I agree. Without flushing, still the packets can choose wrong rates. I missed that.
> But I assumed that it would be better to stop queues before rc update. Thus we can avoid revisiting
> the queued frames chosen with older (this case ht40) rate after rc changes. And fixing at mac80211 would help
> to other rate controls too.

OK, it seems like this isn't getting resolved quickly.  I'm going to
revert it for now, and hope for a more widely acceptable solution soon.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
