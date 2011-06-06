Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44225 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1FFSqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 14:46:19 -0400
Date: Mon, 6 Jun 2011 14:44:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
Message-ID: <20110606184447.GG2604@tuxdriver.com> (sfid-20110606_204622_563437_023AF7C2)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
 <1306823717.9366.3.camel@jlt3.sipsolutions.net>
 <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2011 at 05:00:01AM +0000, Manoharan, Rajkumar wrote:
> > On Fri, 2011-05-20 at 17:52 +0530, Rajkumar Manoharan wrote:
> > > Stop tx queues before updating rate control to ensure
> > > proper rate selection. Otherwise packets can be transmitted
> > > in 40 Mhz whereas hw is configured in HT20.
> > 
> > Looks like I completely missed this since you hid it in an ath9k
> > patchset. DON'T DO THAT.
> 
> Sorry for the delayed response. I was on vacation. 
> >
> > Anyway, John, please revert. This is completely useless. Not only is
> > abusing the CSA stop reason a show-stopper, the whole patch is also just
> > not right, it seems like a workaround around a rate control algorithm
> > that isn't able to do an atomic HT change by itself. Also, it won't even
> > do what you want, there may be packets being processed concurrently
> > while stopping the queue -- calling stop_queues() is no guarantee that
> > no packet will be processed afterwards.
> 
> During the channel type change, the pending tx frames in hw queues are dropped by hw config.
> But before updating rate control, the packets can be queued again with older HT rates.
> This contradicts with hw config mode and sometimes is causing baseband issues. This issue
> was observed only on flooding uplink traffic. To ensure that the frames are always xmitted with
> updated rates, the queues are stopped before hw config and waken up after rc updation.

Johannes, do you find this explanation satisfactory (perhaps with
some new queue stop reason definition)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
