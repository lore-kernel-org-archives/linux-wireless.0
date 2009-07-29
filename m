Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55295 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbZG2WKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 18:10:36 -0400
Message-ID: <4A70C8D2.5050100@candelatech.com>
Date: Wed, 29 Jul 2009 15:10:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com> <1248903902.8925.1.camel@johannes.local>
In-Reply-To: <1248903902.8925.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2009 02:45 PM, Johannes Berg wrote:
> On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
>> From: Reinette Chatre<reinette.chatre@intel.com>
>>
>> The connection monitor currently relies on probe requests paired
>> with probe responses to ensure that a connection is alive. This is
>> fragile in some environments where probe responses can get lost.
>> When we receive beacons we can also consider the connection to be
>> alive, so cancel connection poll instance when we receive a beacon.
>>
>> The debug message "cancelling probereq poll due to a received beacon"
>> is removed as part of this change as this case is hit very often after
>> the above change and debug log receives significant number of these messages.
>
> Not doing that was actually intentional -- we want to know whether or
> not the connection is working both ways, not just whether we can receive
> frames. This can certainly be improved, but I'm not sure this is the
> best approach.
>
> johannes


While poking in this code, I think I found a logic bug:

In mlme.c ieee80211_associated, there are several places that do a mod-timer,
and then goto out.  But, out: just does a mod timer again blindly.

Am I missing something, or is this just wrong?

....
		mod_timer(&ifmgd->timer, jiffies + IEEE80211_PROBE_WAIT);
		goto out;
	}

	if (time_after(jiffies, last_rx + IEEE80211_PROBE_IDLE_TIME)) {
		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
		mutex_lock(&local->iflist_mtx);
		ieee80211_recalc_ps(local, -1);
		mutex_unlock(&local->iflist_mtx);
		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
					 ifmgd->ssid_len, NULL, 0);
	}

  out:
	if (!disassoc)
		mod_timer(&ifmgd->timer,
			  jiffies + IEEE80211_MONITORING_INTERVAL);


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

