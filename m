Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1IZPLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:11:51 -0400
Date: Mon, 26 Sep 2011 20:42:32 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: optimize tx status update
Message-ID: <20110926151231.GC9947@vmraj-lnx.users.atheros.com> (sfid-20110926_171155_446581_CB9B05D3)
References: <1317030121-3902-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E807DCF.1010405@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E807DCF.1010405@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 07:27:43AM -0600, Felix Fietkau wrote:
> On 2011-09-26 3:42 AM, Rajkumar Manoharan wrote:
> >The recent changes of ath_tx_rc_status makes it to be called
> >only for the first frame of aggregation or if there is a
> >single subframe and for all normal frames. And also for all
> >aggregated frames IEEE80211_TX_STAT_AMPDU will be set. This
> >patch removes the unnecessary checks and make the ampdu_[ack]_len
> >to be filled on both aggregation and normal frames.
> This patch looks wrong to me. Only one subframe per A-MPDU is
> supposed to carry the IEEE80211_TX_STAT_AMPDU flag, so the check you
> removed from rc.c is actually necessary, otherwise it'll process the
> tx status of an A-MPDU multiple times (once per completed subframe).
> 
I dont understand. Right now ath_tx_rc_status is called only for the first
frame of aggregation or there is only one subframe in the aggregation.
It never be called for all subframes. Am i right?

--
Rajkumar
