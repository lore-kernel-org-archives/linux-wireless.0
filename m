Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39598 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab1IZN1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 09:27:50 -0400
Message-ID: <4E807DCF.1010405@openwrt.org> (sfid-20110926_152753_923597_36C12390)
Date: Mon, 26 Sep 2011 07:27:43 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: optimize tx status update
References: <1317030121-3902-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1317030121-3902-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-26 3:42 AM, Rajkumar Manoharan wrote:
> The recent changes of ath_tx_rc_status makes it to be called
> only for the first frame of aggregation or if there is a
> single subframe and for all normal frames. And also for all
> aggregated frames IEEE80211_TX_STAT_AMPDU will be set. This
> patch removes the unnecessary checks and make the ampdu_[ack]_len
> to be filled on both aggregation and normal frames.
This patch looks wrong to me. Only one subframe per A-MPDU is supposed 
to carry the IEEE80211_TX_STAT_AMPDU flag, so the check you removed from 
rc.c is actually necessary, otherwise it'll process the tx status of an 
A-MPDU multiple times (once per completed subframe).

