Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47082 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1IZPlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:41:17 -0400
References: <1317030121-3902-1-git-send-email-rmanohar@qca.qualcomm.com> <4E807DCF.1010405@openwrt.org> <20110926151231.GC9947@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110926151231.GC9947@vmraj-lnx.users.atheros.com>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <908BF0F1-F887-4A6C-B2F8-2A8B8C5FF74E@nbd.name> (sfid-20110926_174123_680154_6C5EAE63)
Cc: Felix Fietkau <nbd@openwrt.org>,
	"<linville@tuxdriver.com>" <linville@tuxdriver.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: optimize tx status update
Date: Mon, 26 Sep 2011 17:38:54 +0200
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26.09.2011, at 17:12, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:

> On Mon, Sep 26, 2011 at 07:27:43AM -0600, Felix Fietkau wrote:
>> On 2011-09-26 3:42 AM, Rajkumar Manoharan wrote:
>>> The recent changes of ath_tx_rc_status makes it to be called
>>> only for the first frame of aggregation or if there is a
>>> single subframe and for all normal frames. And also for all
>>> aggregated frames IEEE80211_TX_STAT_AMPDU will be set. This
>>> patch removes the unnecessary checks and make the ampdu_[ack]_len
>>> to be filled on both aggregation and normal frames.
>> This patch looks wrong to me. Only one subframe per A-MPDU is
>> supposed to carry the IEEE80211_TX_STAT_AMPDU flag, so the check you
>> removed from rc.c is actually necessary, otherwise it'll process the
>> tx status of an A-MPDU multiple times (once per completed subframe).
>> 
> I dont understand. Right now ath_tx_rc_status is called only for the first
> frame of aggregation or there is only one subframe in the aggregation.
> It never be called for all subframes. Am i right?
Right, but the rate control status update is called per subframe, so the rc.c change is broken