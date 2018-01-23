Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44666 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeAWLf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 06:35:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 23 Jan 2018 17:05:27 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com
Subject: Re: [PATCH 1/2] cfg80211: Add support to notify station's opmode
 change to userspace
In-Reply-To: <1516625287.2508.18.camel@sipsolutions.net>
References: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org>
 <1516625287.2508.18.camel@sipsolutions.net>
Message-ID: <7bf43e88a9460f06f1dd56ae3a75e138@codeaurora.org> (sfid-20180123_123543_551999_67F8BFED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the code review comments, I'll address these comments and 
send V2 patchset.

>> 
>>  /**
>> + * enum wiphy_opmode_info_flag - opmode information flags
>> + *
>> + * @MAX_BW_CHANGED: Max Bandwidth changed
>> + * @SMPS_MODE_CHANGED: SMPS mode changed
>> + * @N_SS_CHANGED: max N_SS (number of spatial streams) changed
>> + *
>> + */
>> +enum wiphy_opmode_info_flag {
>> +	MAX_BW_CHANGED		= BIT(0),
>> +	SMPS_MODE_CHANGED	= BIT(1),
>> +	N_SS_CHANGED		= BIT(2),
>> +};
> 
> These need to have some kind of common prefix, e.g.
> STA_OPMODE_{BW,SMPS,NSS}_CHANGED
> 
> 
>>  /**
>> + * cfg80211_sta_opmode_change_notify - Station's SMPS mode, rx_nss 
>> and
>> + *	max bandwidth change event
> 
> need to find a shorter description - must fit on one line
> 
>> + * @dev: network device
>> + * @mac: MAC address of a station which opmode got modified
>> + * @changed: contains value from &enum wiphy_opmode_info_flag
>> + * @smps_mode: New SMPS mode of a station
>> + * @bw: new max bandwidth value of a station
>> + * @rx_nss: new rx_nss value of a station
>> + * @gfp: context flags
>> + *
>> + * This function is called when station's opmode modified via action 
>> frame.
> 
> Rephrase, say "Drivers should call this function when ..."
> 
>> +void cfg80211_sta_opmode_change_notify(struct net_device *dev, const 
>> u8 *mac,
>> +				       enum wiphy_opmode_info_flag changed,
>> +				       u8 smps_mode, u8 bw, u8 rx_nss,
>> +				       gfp_t gfp);
> 
> We may not want to add more, but pulling out those parameters "changed,
> smps_mode, bw, rx_nss" into a small structure would IMHO be a good
> idea.
> 
>> + * @NL80211_CMD_STA_OPMODE_CHANGED: An event that notify station's
>> + *	ht opmode or vht opmode changes. This will use 
>> &NL80211_ATTR_SMPS_MODE,
>> + *	&NL80211_ATTR_CHANNEL_WIDTH, &NL80211_ATTR_NSS to send the event 
>> to
>> + *	userspace.
> 
> Should document that not all of those attributes may be included at all
> times.
> 
>> +void cfg80211_sta_opmode_change_notify(struct net_device *dev, const 
>> u8 *mac,
>> +				       enum wiphy_opmode_info_flag changed,
>> +				       u8 smps, u8 bw, u8 rx_nss, gfp_t gfp)
>> +{
>> +	struct sk_buff *msg;
>> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +	struct cfg80211_registered_device *rdev = 
>> wiphy_to_rdev(wdev->wiphy);
>> +	void *hdr;
>> +
>> +	if (!mac)
>> +		return;
> 
> WARN_ON(), perhaps
> 
>> +	if (mac && nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
>> +		goto nla_put_failure;
> 
> no need to check mac != NULL again
> 
>> +nla_put_failure:
>> +	genlmsg_cancel(msg, hdr);
> 
> no need for cancel when you're going to free the message
> 
> johannes
