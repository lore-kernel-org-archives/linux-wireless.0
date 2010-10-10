Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51556 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0JJKYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 06:24:15 -0400
Message-ID: <4CB194DC.7030206@ti.com>
Date: Sun, 10 Oct 2010 12:26:36 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 02/03] wl1271: 11n Support, ACX Commands
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>	 <1286388491-28752-4-git-send-email-shahar_levi@ti.com> <1286476676.1662.57.camel@powerslave>
In-Reply-To: <1286476676.1662.57.camel@powerslave>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the review. All fixed on v3.
Cheers,
Shahar

Luciano Coelho wrote:
> On Wed, 2010-10-06 at 20:08 +0200, ext Shahar Levi wrote:
>> Added ACX command to the FW for 11n support.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
> 
> Again, mostly coding-style comments.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
>> index 6189934..cc6b7d8 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_acx.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
>> @@ -1226,6 +1226,97 @@ out:
>>  	return ret;
>>  }
>>  
>> +int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
>> +				    struct ieee80211_sta_ht_cap *ht_cap,
>> +				    bool allow_ht_operation)
>> +{
>> +	struct wl1271_acx_ht_capabilities *acx;
>> +	/*
>> +	* Note, currently this value will be set to FFFFFFFFFFFF to indicate
>> +	* it is relevant for all peers since we only support HT in
>> +	* infrastructure mode. Later on this field will be relevant to
>> +	* IBSS/DLS operation */
>> +	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> 
> I didn't realize this when reviewing patch 01/03, but you could actually
> remove the Note from the wl1271_acx.h file and leave it here.  There's
> no need to have it repeated there and here.
> 
> 
>> +	/* Allow HT Operation ? */
>> +	if (true == allow_ht_operation) {
> 
> I know that some people like to put the constant in the left side of the
> comparison operator to avoid problems with mistyping == as =, but
> reading this in the opposite way is less intuitive (like top-posting? ;)
> and the compiler, if called with reasonable options, will warn you if
> you make that mistake.  So, summarizing, please use it like this
> instead, then you don't even risk mistyping == in the first place :P
> 
> 	if (allow_ht_operation) {
> 
> 
>> +		acx->ht_capabilites =
>> +		WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION;
> 
> Add a more indentation on the second line, it's easier to read.
> 
> 
>> +		acx->ht_capabilites |=
>> +		((ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD) ?
>> +		WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT : 0);
>> +		acx->ht_capabilites |=
>> +		((ht_cap->cap & IEEE80211_HT_CAP_SGI_20) ?
>> +		WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS : 0);
>> +		acx->ht_capabilites |=
>> +		((ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT) ?
>> +		WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION : 0);
> 
> Same thing for all these other assignments.
> 
> 
>> +
>> +		/* get date from A-MPDU parameters field */
> 
> "get data"
> 
> 
>> +		acx->ampdu_max_length = ht_cap->ampdu_factor;
>> +		acx->ampdu_min_spacing = ht_cap->ampdu_density;
>> +
>> +		memcpy(acx->mac_address, mac_address, ETH_ALEN);
>> +	}
>> +	/* HT operations are not allowed */
>> +	else
>> +		acx->ht_capabilites = 0;
> 
> According to Documentation/CodingStyle, you should write the else block
> like this:
> 
> if (...) {
> 	...
> } else {
> 	acx->ht_capabilities = 0;
> }
> 
> 
>> +int wl1271_acx_set_ht_information(struct wl1271 *wl,
>> +				   u16 ht_operation_mode)
>> +{
>> +	struct wl1271_acx_ht_information *acx;
>> +	int ret = 0;
>> +
>> +	wl1271_debug(DEBUG_ACX, "acx ht information setting");
>> +
>> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
>> +	if (!acx) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	acx->ht_protection =
>> +		(u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
>> +	acx->rifs_mode = 0;
>> +	acx->gf_protection = 0;
>> +	acx->ht_tx_burst_limit = 0;
>> +	acx->dual_cts_protection = 0;
>> +
>> +	ret = wl1271_cmd_configure(wl,
>> +				   ACX_HT_BSS_OPERATION,
>> +				   acx,
>> +				   sizeof(*acx));
> 
> Doesn't this fit in less lines?
> 

