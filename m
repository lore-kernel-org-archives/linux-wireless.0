Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20866 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1FGIj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 04:39:59 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 6/6] mac80211: stop queues before rate control updation
Date: Tue, 7 Jun 2011 08:39:57 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC88012CE709@nasanexd02d.na.qualcomm.com> (sfid-20110607_104005_203509_012DA05F)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
	 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
	 <1306823717.9366.3.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com>
	 <20110606184447.GG2604@tuxdriver.com>,<1307386634.3894.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1307386634.3894.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > On Mon, 2011-06-06 at 14:44 -0400, John W. Linville wrote:
> 
> > > During the channel type change, the pending tx frames in hw queues are dropped by hw config.
> > > But before updating rate control, the packets can be queued again with older HT rates.
> > > This contradicts with hw config mode and sometimes is causing baseband issues. This issue
> > > was observed only on flooding uplink traffic. To ensure that the frames are always xmitted with
> > > updated rates, the queues are stopped before hw config and waken up after rc updation.
>> 
> > Johannes, do you find this explanation satisfactory (perhaps with
> > some new queue stop reason definition)?
> 
> No, it doesn't address the fact that any packet that is pending will
> still be processed -- as I said before, the stop doesn't include a
> flush.

Yes. I agree. Without flushing, still the packets can choose wrong rates. I missed that.
But I assumed that it would be better to stop queues before rc update. Thus we can avoid revisiting
the queued frames chosen with older (this case ht40) rate after rc changes. And fixing at mac80211 would help
to other rate controls too.

--
Rajkumar