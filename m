Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44449 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0KSMnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 07:43:40 -0500
Message-ID: <4CE670FA.50704@openwrt.org>
Date: Fri, 19 Nov 2010 13:43:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: use nullfunc instead of probe request for connection
 monitoring
References: <1290141756-37252-1-git-send-email-nbd@openwrt.org> <b18357d5d26e318178407a9133214709@localhost>
In-Reply-To: <b18357d5d26e318178407a9133214709@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-19 6:58 AM, Johannes Berg wrote:
> On Fri, 19 Nov 2010 05:42:36 +0100, Felix Fietkau <nbd@openwrt.org> wrote:
>> +	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
>> +		ieee80211_send_nullfunc(sdata->local, sdata, 0);
> 
> Hmm, should that really be 0 always? Could it be racy either way?
> I think that probably needs some analysis.
Yes, it should be 0. While it's probing the AP,
IEEE80211_STA_CONNECTION_POLL or IEEE80211_STA_BEACON_POLL is set, and
before sending the first probe request or nullfunc frame,
ieee80211_recalc_ps is called. That effectively pulls us out of
powersave mode, so sending a nullfunc frame that indicates that we're
awake should be safe.

>> +	else {
>> +		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
>> +		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
>> +	}
>>  
>>  	ifmgd->probe_send_count++;
>>  	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
>> @@ -1509,29 +1562,8 @@ static void ieee80211_rx_mgmt_probe_resp(struct
>> ieee80211_sub_if_data *sdata,
>>  	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
>>  
>>  	if (ifmgd->associated &&
>> -	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0 &&
>> -	    ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
>> -			    IEEE80211_STA_CONNECTION_POLL)) {
>> -		ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
>> -				  IEEE80211_STA_BEACON_POLL);
>> -		mutex_lock(&sdata->local->iflist_mtx);
>> -		ieee80211_recalc_ps(sdata->local, -1);
>> -		mutex_unlock(&sdata->local->iflist_mtx);
>> -
>> -		if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
>> -			return;
>> -
>> -		/*
>> -		 * We've received a probe response, but are not sure whether
>> -		 * we have or will be receiving any beacons or data, so let's
>> -		 * schedule the timers again, just in case.
>> -		 */
>> -		ieee80211_sta_reset_beacon_monitor(sdata);
>> -
>> -		mod_timer(&ifmgd->conn_mon_timer,
>> -			  round_jiffies_up(jiffies +
>> -					   IEEE80211_CONNECTION_IDLE_TIME));
>> -	}
>> +	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0)
>> +		ieee80211_reset_ap_probe(sdata);
> 
> Not sure I get this part...
I just moved most of this code up to to the ieee80211_reset_ap_probe
function to avoid duplicating it (since it's called from
ieee80211_sta_tx_notify as well).

- Felix
