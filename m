Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43720 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbcCHLVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:21:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 08 Mar 2016 16:51:17 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: move mgmt descriptor limit handle under
 mgmt_tx
In-Reply-To: <CA+BoTQmnY0omFh0iddjcVBXubt3WC49DpFumUBY=NSCYs-PuHw@mail.gmail.com>
References: <1457250469-22994-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQmnY0omFh0iddjcVBXubt3WC49DpFumUBY=NSCYs-PuHw@mail.gmail.com>
Message-ID: <4ac3af9a07398243a8a363692cc62f47@codeaurora.org> (sfid-20160308_122135_634434_AA3135FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Michal Kazior wrote:
> On 6 March 2016 at 08:47, Rajkumar Manoharan 
> <rmanohar@qti.qualcomm.com> wrote:
>> Firmware reserves few descriptors for management frames transmission.
>> In 16 MBSSID scenario, these slots will be easy exhausted due to 
>> frequent
>> probe responses. So for 10.4 based solutions, probe responses are 
>> limited
>> by a threshold (24).
>> 
>> management tx path is separate for all except tlv based solutions. 
>> Since
>> tlv solutions (qca6174 & qca9377) do not support 16 AP interfaces, it 
>> is
>> safe to move management descriptor limitation check under mgmt_tx
>> function. Though CPU improvement is negligible, unlikely conditions or
>> never hit conditions in hot path can be avoided on data transmission.
>> 
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> ---
>> v2:
>>   - rebased on top of Michal changes
> [...]
>> @@ -3979,13 +3977,22 @@ static void ath10k_mac_op_tx(struct 
>> ieee80211_hw *hw,
>>         is_htt = (txpath == ATH10K_MAC_TX_HTT ||
>>                   txpath == ATH10K_MAC_TX_HTT_MGMT);
>> 
>> -       if (is_htt) {
>> -               spin_lock_bh(&ar->htt.tx_lock);
>> -
>> -               is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
>> +       is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
>> +       spin_lock_bh(&ar->htt.tx_lock);
>> +       if (is_mgmt) {
>>                 is_presp = 
>> ieee80211_is_probe_resp(hdr->frame_control);
>> 
>> -               ret = ath10k_htt_tx_inc_pending(htt, is_mgmt, 
>> is_presp);
>> +               ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_presp);
>> +               if (ret) {
>> +                       ath10k_warn(ar, "failed to increase tx mgmt 
>> pending count: %d, dropping\n",
>> +                                   ret);
>> +                       spin_unlock_bh(&ar->htt.tx_lock);
>> +                       ieee80211_free_txskb(ar->hw, skb);
>> +                       return;
>> +               }
>> +       }
>> +       if (is_htt) {
>> +               ret = ath10k_htt_tx_inc_pending(htt);
>>                 if (ret) {
>>                         ath10k_warn(ar, "failed to increase tx pending 
>> count: %d, dropping\n",
>>                                     ret);
> 
> This doesn't look good.
> 
> You'll call ath10k_htt_tx_mgmt_inc_pending() regardless of the tx path
> being chosen. FWIW It could be WMI on older firmware, oops.
> 
> Holding the lock for the entire time doesn't make much sense either, 
> does it?
> 
inc_pending is being called from different contexts. So it is possible 
that inc_pending will return false
after mgmt_inc_pending. Thats why lock is hold until both got increased 
successfully.

-Rajkumar
