Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1FFS5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 14:57:21 -0400
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110606184447.GG2604@tuxdriver.com>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
	 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
	 <1306823717.9366.3.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC88012CC51B@nasanexd02b.na.qualcomm.com>
	 <20110606184447.GG2604@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:57:14 +0200
Message-ID: <1307386634.3894.14.camel@jlt3.sipsolutions.net> (sfid-20110606_205725_143382_8804AF71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 14:44 -0400, John W. Linville wrote:

> > During the channel type change, the pending tx frames in hw queues are dropped by hw config.
> > But before updating rate control, the packets can be queued again with older HT rates.
> > This contradicts with hw config mode and sometimes is causing baseband issues. This issue
> > was observed only on flooding uplink traffic. To ensure that the frames are always xmitted with
> > updated rates, the queues are stopped before hw config and waken up after rc updation.
> 
> Johannes, do you find this explanation satisfactory (perhaps with
> some new queue stop reason definition)?

No, it doesn't address the fact that any packet that is pending will
still be processed -- as I said before, the stop doesn't include a
flush.

johannes

