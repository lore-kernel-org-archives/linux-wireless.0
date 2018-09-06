Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbeIFLoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 07:44:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 06 Sep 2018 12:40:45 +0530
From: Anilkumar Kolli <akolli@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rge?= =?UTF-8?Q?nsen?=
        <toke@toke.dk>
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
In-Reply-To: <1535969922.3437.37.camel@sipsolutions.net>
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
 <87k1o6d8hw.fsf@kamboji.qca.qualcomm.com>
 <1535969922.3437.37.camel@sipsolutions.net>
Message-ID: <57c9d018e6c8bddc50871c88bddee3b7@codeaurora.org> (sfid-20180906_091048_391685_932A8210)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-03 15:48, Johannes Berg wrote:
> On Fri, 2018-08-31 at 15:29 +0300, Kalle Valo wrote:
> 
>> Too me this feels like a bad idea but I'm not familiar enough with
>> mac80211 to really comment on this. What kind of implications does 
>> this
>> have for Mesh or ATF, for example? Adding Johannes and Toke to hear
>> about their opinion about this.
> 
> The biggest implication is probably radiotap. Beyond that, it's using
> this to report the "last rate" to nl80211, but that's not all super
> useful anyway.
> 
> The retry count is also affected, and since you report "somewhat
> liberally" that would lead to erroneous statistics.
> 
> I'd recommend against doing this and disentangling the necessary code 
> in
> mac80211, e.g. with ieee80211_tx_status_ext() or adding similar APIs.
> 
> johannes

Thanks for the review.

Is this okay to implement a new API to update the tx rate alone?

Code snippet:
  /**
  * ieee80211_tx_status_rate_upd - transmit rate update callback
  *
  * This function can be used in drivers that does not have provision
  * in updating the tx rate in data path.
  *
  * @hw: the hardware the frame was transmitted by
  * @status: tx status information
  * @pubsta: the station to update the tx rate for.
  */
void ieee80211_tx_status_rate_upd(struct ieee80211_hw *hw,
				  struct ieee80211_sta *pubsta,
				  struct ieee80211_tx_info *info);


Source:
void ieee80211_tx_status_rate_upd(struct ieee80211_hw *hw,
				  struct ieee80211_sta *pubsta,
				  struct ieee80211_tx_info *info)
{
	struct ieee80211_local *local = hw_to_local(hw);
	struct ieee80211_supported_band *sband;
	int retry_count;
	int rates_idx;
	struct ieee80211_tx_status status = {
		.skb = NULL,
		.info = info,
	};

	ieee80211_tx_get_rates(hw, info, &retry_count);
	sband = hw->wiphy->bands[info->band];

	if (pubsta) {
		struct sta_info *sta;

		sta = container_of(pubsta, struct sta_info, sta);
		status.sta = &sta->sta;
		rate_control_tx_status(local, sband, &status);
		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
		    (rates_idx != -1))
			sta->tx_stats.last_rate = info->status.rates[rates_idx];
	}

}
EXPORT_SYMBOL(ieee80211_tx_status_rate_upd);


Thanks
Anil.
