Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32016 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047Ab1GMISk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:18:40 -0400
Message-ID: <4E1D54C8.8020304@qca.qualcomm.com> (sfid-20110713_101846_481942_421AB294)
Date: Wed, 13 Jul 2011 11:18:16 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 17/24] ath6kl: add main.c
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013545.8517.71741.stgit@localhost6.localdomain6> <1310531456.1143.30.camel@Joe-Laptop>
In-Reply-To: <1310531456.1143.30.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 07:30 AM, Joe Perches wrote:
> On Wed, 2011-07-13 at 04:35 +0300, Kalle Valo wrote:
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath6kl/main.c | 1337 ++++++++++++++++++++++++++++++++
> 
>> +static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
>> +			u8 ielen, u8 keymgmt, u8 ucipher, u8 auth)
>> +{
>> +	u8 free_slot;
>> +
>> +	free_slot = aid - 1;
>> +	memcpy(ar->sta_list[free_slot].mac, mac, ETH_ALEN);
>> +	memcpy(ar->sta_list[free_slot].wpa_ie, wpaie, ielen);
> 
> 
> Many versions of gcc do not optimize these repeated dereferences.
> It's better to use a temporary local.
> 
> 	struct ath6kl_sta *sta = &ar->sta_list[free_slot];
> 
> 	memcpy(sta->mac, mac, ETH_ALEN);
> 	memcpy(sta->wpa_ie, wpaie, ielen);
> 
> 	etc..

Fixed.

>> +static void ath6kl_sta_cleanup(struct ath6kl *ar, u8 i)
>> +{
>> +	/* empty the queued pkts in the PS queue if any */
>> +	spin_lock_bh(&ar->sta_list[i].psq_lock);
>> +	skb_queue_purge(&ar->sta_list[i].psq);
>> +	spin_unlock_bh(&ar->sta_list[i].psq_lock);
>> +
>> +	memset(&ar->ap_stats.sta[ar->sta_list[i].aid - 1], 0,
> 
> here too.

Fixed.

>> +void ath6kl_tgt_stats_event(struct ath6kl *ar, u8 *ptr, u32 len)
>> +{
>> +	struct wmi_ap_mode_stat *p = (struct wmi_ap_mode_stat *) ptr;
>> +	struct wmi_ap_mode_stat *ap = &ar->ap_stats;
>> +	u8 ac;
>> +
>> +	if (ar->nw_type == AP_NETWORK) {
>> +		if (len < sizeof(*p))
>> +			return;
>> +
>> +		for (ac = 0; ac < AP_MAX_NUM_STA; ac++) {
>> +			ath6kl_add_le32(&ap->sta[ac].tx_bytes,
>> +					p->sta[ac].tx_bytes);
> 
> maybe better here to use temporaries too.
> 
> 		struct ath6kl_sta *st_ap = &ap->sta[ac];
> 		struct ath6kl_sta *st_p = &p->sta[ac];
> 
>> +			ath6kl_add_le32(&ap->sta[ac].tx_pkts,
>> +					p->sta[ac].tx_pkts);
>> +			ath6kl_add_le32(&ap->sta[ac].tx_error,
>> +					p->sta[ac].tx_error);
> 
> 			ath6kl_add_le32(st_ap->tx_pkts, st_p->tx_pkts);
> 			ath6kl_add_le32(st_ap->tx_error, st_p->tx_error);
> 
> etc.

Fixed.

Kalle
