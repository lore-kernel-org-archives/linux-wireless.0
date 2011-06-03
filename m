Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28786 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1FCFAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 01:00:03 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 6/6] mac80211: stop queues before rate control updation
Date: Fri, 3 Jun 2011 05:00:01 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com> (sfid-20110603_070012_916022_8220153F)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
	 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
	 (sfid-20110520_142300_320315_15BD860C),<1306823717.9366.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1306823717.9366.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, 2011-05-20 at 17:52 +0530, Rajkumar Manoharan wrote:
> > Stop tx queues before updating rate control to ensure
> > proper rate selection. Otherwise packets can be transmitted
> > in 40 Mhz whereas hw is configured in HT20.
> 
> Looks like I completely missed this since you hid it in an ath9k
> patchset. DON'T DO THAT.

Sorry for the delayed response. I was on vacation. 
>
> Anyway, John, please revert. This is completely useless. Not only is
> abusing the CSA stop reason a show-stopper, the whole patch is also just
> not right, it seems like a workaround around a rate control algorithm
> that isn't able to do an atomic HT change by itself. Also, it won't even
> do what you want, there may be packets being processed concurrently
> while stopping the queue -- calling stop_queues() is no guarantee that
> no packet will be processed afterwards.

During the channel type change, the pending tx frames in hw queues are dropped by hw config.
But before updating rate control, the packets can be queued again with older HT rates.
This contradicts with hw config mode and sometimes is causing baseband issues. This issue
was observed only on flooding uplink traffic. To ensure that the frames are always xmitted with
updated rates, the queues are stopped before hw config and waken up after rc updation.

--
Rajkumar

