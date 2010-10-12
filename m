Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42643 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab0JLOgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:36:07 -0400
Message-ID: <4CB472FE.9040802@ti.com>
Date: Tue, 12 Oct 2010 16:38:54 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/03] wl1271: BA Initiator support, BA functions
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>	 <1286456762-17480-3-git-send-email-shahar_levi@ti.com> <1286541447.21349.145.camel@chilepepper>
In-Reply-To: <1286541447.21349.145.camel@chilepepper>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the review. most will be fix on v2.
Two comments inline.
regards,
Shahar

Luciano Coelho wrote:
> On Thu, 2010-10-07 at 15:06 +0200, ext Shahar Levi wrote:
>> New ops support ampdu_action as initiator returns EINVAL due to
>> the fact that BA initiator session manage in the FW independently.
>> acx function set BA policies.
> 
> Please rephrase this as it is hard to understand what the patch really
> is about.
> 
> 
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
> 
> Some more, mostly style comments.  Having mostly style-related comments
> means that your implementation is really good and I appreciate it! It
> just need a bit of polishing and parfumerie ;)
> 
> This patch can also be merged with the next one.  This doesn't add any
> real functionality and there are things added here (for example the
> mac_addr = FFFFFFFFFFFF is not used at all) that are changed in the next
> patch.  This just confuses things.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
>> index cc6b7d8..f82656e 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_acx.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
>> @@ -1317,6 +1317,61 @@ out:
>>  	return ret;
>>  }
>>  
>> +/*
>> + * wl1271_acx_set_ba_session
> 
> Remove this line.  And then the comment can be in one line.
> 
> 
>> + * configure BA session initiator\receiver parameters setting in the FW.
>> + */
>> +int wl1271_acx_set_ba_session(struct wl1271 *wl,
>> +							  u16 id,
>> +							  u8 tid_index,
>> +							  u8 policy)
> 
> Fix the indentation and maybe it all fits in one line?
one character is go beyond.

> 
> 
>> +{
>> +	struct wl1271_acx_ba_session_policy *acx;
>> +	int ret = 0;
>> +	/*
>> +	* Note, currently this value will be set to FFFFFFFFFFFF to indicate
>> +	* it is relevant for all peers.
>> +	*/
>> +	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> 
> No need to do this here, since this code is not called and, when you
> call it (ie. in patch 03/03), you remove this FF'ing anyway. ;)
> 
> 
>> +	if (ACX_BA_SESSION_INITIATOR_POLICY == id)
> 
> Please use natural order (ie. id == ACX_BA_SESSION_INITIATOR_POLICY).
> 
> 
>> +		acx->inactivity_timeout = BA_INACTIVITY_TIMEOUT;
>> +	else
>> +		if (ACX_BA_SESSION_RESPONDER_POLICY == id)
>> +			acx->inactivity_timeout = 0;
>> +		else {
>> +			wl1271_error("Incorrect acx command id=%x\n", id);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
> 
> Use this structure for the if else statements:
> 
> if (...) {
> 	...
> } else if (...) {
> 	...
> } else {
> 	...
> }
> 
> Or a switch-case.
> 
> 
>> +
>> +	ret = wl1271_cmd_configure(wl,
>> +				   id,
>> +				   acx,
>> +				   sizeof(*acx));
> 
> Fits in one line.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
>> index 6c3c7c0..f417624 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
>> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
>> @@ -1205,6 +1205,10 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
>>  				    bool allow_ht_operation);
>>  int wl1271_acx_set_ht_information(struct wl1271 *wl,
>>  				   u16 ht_operation_mode);
>> +int wl1271_acx_set_ba_session(struct wl1271 *wl,
>> +							  u16 id,
>> +							  u8 tid_index,
>> +							  u8 policy);
> 
> Indentation.
> 
> 
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
>> index af092f4..53c03e5 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> @@ -1128,6 +1128,22 @@ static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
>>  	}
>>  }
>>  
>> +/*
>> + * wl1271_set_ba_policies
> 
> Same as earlier: remove this line.  And then the comment can be in one
> line.
> 
> 
>> + * Set the BA session policies to the FW.
>> + */
>> +static void wl1271_set_ba_policies(struct wl1271 *wl)
>> +{
>> +	u8	tid_index;
> 
> No need for the TAB between u8 and tid_index.
> 
> 
>> @@ -2056,6 +2072,32 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
>>  	return 0;
>>  }
>>  
>> +int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
>> +			    struct ieee80211_vif *vif,
>> +			    enum ieee80211_ampdu_mlme_action action,
>> +			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
>> +{
>> +		int ret;
>> +
>> +		switch (action) {
>> +		case IEEE80211_AMPDU_RX_START:
>> +		case IEEE80211_AMPDU_RX_STOP:
>> +
>> +		/* The BA initiator session management in FW independently */
>> +		case IEEE80211_AMPDU_TX_START:
>> +		case IEEE80211_AMPDU_TX_STOP:
>> +		case IEEE80211_AMPDU_TX_OPERATIONAL:
>> +			ret = -EINVAL;
>> +		break;
>> +
>> +		default:
>> +			wl1271_error("Incorrect ampdu action id=%x\n", action);
>> +			ret = -ENODEV;
>> +		}
>> +
>> +		return ret;
>> +}
> 
> This function doesn't do anything, really.  Except for returning -EINVAL
> in TX cases.  Is it really needed?
you right, for TX we didn't need it. i will remove it.

