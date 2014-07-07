Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37584 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaGGMCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 08:02:55 -0400
Message-ID: <53BA8C5D.4000604@openwrt.org> (sfid-20140707_140301_867682_6DAFDC09)
Date: Mon, 07 Jul 2014 14:02:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC 03/10] ath9k: add dynamic ack timeout estimation
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com> <1404725506-9571-4-git-send-email-lorenzo.bianconi83@gmail.com> <0D7AC98D-7356-44BC-8DBC-2916DF58F41F@net.t-labs.tu-berlin.de>
In-Reply-To: <0D7AC98D-7356-44BC-8DBC-2916DF58F41F@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-07-07 13:41, Thomas Hühn wrote:

>> +{
>> +	struct ath_node *an;
>> +	u32 to = 0;
>> +	struct ath_dynack *da = &ah->dynack;
>> +	struct ath_common *common = ath9k_hw_common(ah);
>> +
> 
>> +	list_for_each_entry(an, &da->nodes, list)
>> +		if (an->ackto > to)
>> +			to = an->ackto;
>> +
> 
> This list parsing would probably need rcu protection like:
> 	
> 	rcu_read_lock();
> 	list_for_each_entry(an, &da->nodes, list)
> 		if (an->ackto > to)
> 			to = an->ackto;
> 	rcu_read_unlock();
Nope, that's already done in the calling code.

> I am not sure that you need to call the entire function with spin_lock as you do it now.
> 
>> +	if (to && da->ackto != to) {
>> +		u32 slottime;
>> +
>> +		slottime = (to - 3) / 2;
> 
> Should the case to < 3 be covered or is it safe to have potentially slottime = 0 ?
slottime should never be 0. It is not user configurable.

>> +/**
>> + * ath_dynack_compute_to - compute ack timeout
>> + * @ah: ath hw
>> + *
>> + * should be called while holding qlock
>> + */
>> +static void ath_dynack_compute_to(struct ath_hw *ah)
>> +{
>> +	u32 ackto, ack_ts;
>> +	u8 *dst, *src;
>> +	struct ieee80211_sta *sta;
>> +	struct ath_node *an;
>> +	struct ts_info *st_ts;
>> +	struct ath_dynack *da = &ah->dynack;
>> +
>> +	rcu_read_lock();
>> +
>> +	while (da->st_rbf.h_rb != da->st_rbf.t_rb &&
>> +	       da->ack_rbf.h_rb != da->ack_rbf.t_rb) {
>> +		ack_ts = da->ack_rbf.tstamp[da->ack_rbf.h_rb];
>> +		st_ts = &da->st_rbf.ts[da->st_rbf.h_rb];
>> +		dst = da->st_rbf.addr[da->st_rbf.h_rb].h_dest;
>> +		src = da->st_rbf.addr[da->st_rbf.h_rb].h_src;
>> +
>> +		ath_dbg(ath9k_hw_common(ah), DYNACK,
>> +			"ack_ts %u st_ts %u st_dur %u [%u-%u]\n",
>> +			ack_ts, st_ts->tstamp, st_ts->dur,
>> +			da->ack_rbf.h_rb, da->st_rbf.h_rb);
>> +
>> +		if (ack_ts > st_ts->tstamp + st_ts->dur) {
>> +			ackto = ack_ts - st_ts->tstamp - st_ts->dur;
>> +
>> +			if (ackto < MAX_DELAY) {
>> +				sta = ieee80211_find_sta_by_ifaddr(ah->hw, dst,
>> +								   src);
>> +				if (sta) {
>> +					an = (struct ath_node *)sta->drv_priv;
>> +					an->ackto = DYNACK_EWMA((u32)ackto,
>> +								an->ackto);
>> +					ath_dbg(ath9k_hw_common(ah), DYNACK,
>> +						"%pM to %u\n", dst, an->ackto);
>> +					if (time_is_before_jiffies(da->lto)) {
>> +						ath_dynack_compute_ackto(ah);
>> +						da->lto = jiffies + COMPUTE_TO;
>> +					}
>> +				}
>> +				INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
>> +			}
>> +			INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
>> +		} else {
>> +			INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
>> +		}
>> +	}
>> +
>> +	rcu_read_unlock();
> 
> I think it is sufficient to have the rcu_read_unlock just around
> ieee80211_find_sta_by_ifaddr(). So the lock does not need to
> include the whole while loop under lock.
That doesn't make things any better - rcu_read_lock is not like a normal
lock. Doing it once outside of the loop is not only simpler, but also
slightly more efficient.

- Felix
