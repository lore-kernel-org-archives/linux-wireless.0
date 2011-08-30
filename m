Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53254 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1H3FkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 01:40:19 -0400
Message-ID: <4E5C77BC.3080103@openwrt.org> (sfid-20110830_074023_344977_F062C335)
Date: Tue, 30 Aug 2011 07:40:12 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Subject: Re: [PATCH v7 2/4] ath9k: always call ath_reset from workqueue context
References: <1314643245-59142-1-git-send-email-nbd@openwrt.org> <1314643245-59142-2-git-send-email-nbd@openwrt.org> <20110830052559.GB31187@vasanth-laptop>
In-Reply-To: <20110830052559.GB31187@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-30 7:26 AM, Vasanthakumar Thiagarajan wrote:
> On Mon, Aug 29, 2011 at 08:40:43PM +0200, Felix Fietkau wrote:
>>  This makes it much easier to add further rework to avoid race conditions
>>  between reset and other work items.
>>  Move other functions to make ath_reset static.
>
> Can you please explain where you'll run into race during
> ath_reset()?. It's always called with pcu_lock held.
I didn't actually observe any race, but I'm not sure if all work items 
can properly deal with being interrupted by a full reset, so I'm trying 
to make it more safe here.

>>  @@ -386,9 +386,7 @@ void ath_beacon_tasklet(unsigned long data)
>>   			ath_dbg(common, ATH_DBG_BSTUCK,
>>   				"beacon is officially stuck\n");
>>   			sc->sc_flags |= SC_OP_TSF_RESET;
>>  -			spin_lock(&sc->sc_pcu_lock);
>>  -			ath_reset(sc, true);
>>  -			spin_unlock(&sc->sc_pcu_lock);
>>  +			ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>
> We'll expect a reset happening as soon possible here. Handling this
> in a work item may not be appropriate.
We've already waited for multiples of 100ms. 1-2ms extra won't hurt now.

>>   void ath9k_tasklet(unsigned long data)
>>   {
>>  @@ -675,9 +607,7 @@ void ath9k_tasklet(unsigned long data)
>>
>>   	if ((status&  ATH9K_INT_FATAL) ||
>>   	(status&  ATH9K_INT_BB_WATCHDOG)) {
>>  -		spin_lock(&sc->sc_pcu_lock);
>>  -		ath_reset(sc, true);
>>  -		spin_unlock(&sc->sc_pcu_lock);
>>  +		ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>
> Above comment applies here as well.
I don't think the additional delay will be significant enough to matter 
here. What matters to me more is to be able to reliably kill all the 
currently running work, which can only be done if ath_reset gets called 
from process context.

- Felix
