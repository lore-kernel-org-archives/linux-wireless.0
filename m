Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48262 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbdAMIyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:54:39 -0500
Subject: Re: [PATCH] mac80211: initialize SMPS field in HT capabilities
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170111223322.14698-1-nbd@nbd.name>
 <1484295655.19860.9.camel@sipsolutions.net>
Cc: onelektra@gmx.net
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ba04d61c-3f80-573f-3108-c94a9c991404@nbd.name> (sfid-20170113_095445_796154_72B53E86)
Date: Fri, 13 Jan 2017 09:54:35 +0100
MIME-Version: 1.0
In-Reply-To: <1484295655.19860.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-13 09:20, Johannes Berg wrote:
> On Wed, 2017-01-11 at 23:33 +0100, Felix Fietkau wrote:
>> ibss and mesh modes copy the ht capabilites from the band without
>> overriding the SMPS state. Unfortunately the default value 0 for the
>> SMPS field means static SMPS instead of disabled.
>> 
>> This results in HT ibss and mesh setups using only single-stream
>> rates,
>> even though SMPS is not supposed to be active.
>> 
>> Initialize SMPS to disabled for all bands on ieee80211_hw_register to
>> ensure that the value is sane where it is not overriden with the real
>> SMPS state.
> 
> Hmm. I guess the only other place affected by it will be scanning?
Right.

>> Reported-by: Elektra Wagenrad <onelektra@gmx.net>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  net/mac80211/main.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>> 
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index 1822c77f2b1c..c269046aa02b 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -913,10 +913,15 @@ int ieee80211_register_hw(struct ieee80211_hw
>> *hw)
>>  		supp_ht = supp_ht || sband->ht_cap.ht_supported;
>>  		supp_vht = supp_vht || sband->vht_cap.vht_supported;
>>  
>> -		if (sband->ht_cap.ht_supported)
>> -			local->rx_chains =
>> -				max(ieee80211_mcs_to_chains(&sband-
>> >ht_cap.mcs),
>> -				    local->rx_chains);
>> +		if (!sband->ht_cap.ht_supported)
>> +			continue;
>> +
>> +		local->rx_chains =
>> +			max(ieee80211_mcs_to_chains(&sband-
>> >ht_cap.mcs),
>> +			    local->rx_chains);
>> +
>> +		sband->ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
>> +			             IEEE80211_HT_CAP_SM_PS_SHIFT;
> 
> This ... looks fishy. I know it's not, since it sets both bits, but
> still.
> 
> Additionally, ath10k appears to be setting this to
> WLAN_HT_CAP_SM_PS_DYNAMIC already, so apparently it's expecting
> something to happen with that value? Is it really correct then to be
> overwriting it?
Actually, that code seems to leave the value at 
WLAN_HT_CAP_SM_PS_DISABLED, because it sets that first and doesn't mask
out the field before trying to set it to WLAN_HT_CAP_SM_PS_DYNAMIC.
I don't think it even makes sense to set WLAN_HT_CAP_SM_PS_DYNAMIC at
this point, since it's up to mac80211 to deal with the SMPS state.

Either way, WLAN_HT_CAP_SM_PS_STATIC is a really bad default to have at
init time. If you want, I can change the patch to check for that value
before changing it, but I don't really see the point.

Additionally, I found this ath10k commit:


commit e33a99e227e430a788467e5a85dc29f6df16b983
Author: Peter Oh <poh@qca.qualcomm.com>
Date:   Thu Dec 31 15:26:20 2015 +0200

    ath10k: set SM power save disabled to default value
    
    Use SMPS disabled as default because FW does not indicate
    any support of SMPS.
    
    This change will help STAs out that don’t support SMPS from
    sticking on 1SS, since they don’t have method to change it
    back to multiple chains.
    
    This change also should not affect power consumption of STAs
    supporting SMPS, because they are capable to switch the mode
    to dynamic or static either at the end of frame sequence or
    by using SMPS action frame.
    
    Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b4bdeb07a012..6146a293601a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3860,7 +3860,8 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
        ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
        ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
        ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
-       ht_cap.cap |= WLAN_HT_CAP_SM_PS_STATIC << IEEE80211_HT_CAP_SM_PS_SHIFT;
+       ht_cap.cap |=
+               WLAN_HT_CAP_SM_PS_DISABLED << IEEE80211_HT_CAP_SM_PS_SHIFT;
 
        if (ar->ht_cap_info & WMI_HT_CAP_HT20_SGI)
                ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;

- Felix
