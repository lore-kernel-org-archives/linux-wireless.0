Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.clemson.edu ([130.127.28.87]:44405 "EHLO CLEMSON.EDU"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754473AbYCAWhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 17:37:04 -0500
Message-ID: <47C9DA17.7000005@clemson.edu> (sfid-20080301_223711_077658_CCEB2A84)
Date: Sat, 01 Mar 2008 17:35:03 -0500
From: Bill Moss <bmoss@CLEMSON.EDU>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: bughost-1583&1499
References: <47C983A6.8060502@clemson.edu> <1204395671.3917.4.camel@johannes.berg>
In-Reply-To: <1204395671.3917.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have pounded on your patch hard for both broadcast and hidden access 
points and its seems solid. I can't make it fail. After boot or iwl3945 
module reload, I run

#!/bin/bash

ifconfig wlan0 up
iwconfig wlan0 mode Managed
iwconfig wlan0 key xxxxxxxxxxxxxxxxxxxxxxxxxx
iwconfig wlan0 essid mosswap
sleep 2
dhclient wlan0

which is essentially what ifup does in Fedora.

___________________________________________________________

Let me change horses to bughost 1499, part of which is the frequency 
with which 'iwlist wlan0 scan' produces the 'No scan results' output 
after a boot or a module reload and before any association is made. I 
use this script for testing.

#!/bin/bash

ifconfig wlan0 up

iwlist wlan0 scan
for ((  i = 0 ;  i < 10;  i++  ))
do
  sleep 5
  iwlist wlan0 scan
done

For a broadcast access point, I rarely see the 'No scan results' output 
when running 'iwlist wlan0 scan'. For the hidden access point case, here 
are some results

After module reload: 50 'No scan results' out of 50 scans

After association/disassociation: 24 'No scan results' out of 50 scans

Scanning while not associated is what NetworkManager does when it starts 
up and compares the scanned access point list with its stored list of 
acceptable access points. This is why I am interested in this bug. So 
far I am stumped. Any suggestions?

Bill Moss

Johannes Berg wrote:
> Bill,
>
>   
>> I sent an early version of this report to Johannes and Reinette a week 
>> ago. Johannes said he would look at it after finishing the mesh stuff 
>> and he wanted Zhu to look at it too. This report contains some further 
>> analysis. This is a pernicious bug for new users of Fedora so I don't 
>> want it to fall on the floor.
>>     
>
> Thanks for reminding me, I completely forgot to look at it again after
> the mesh stuff.
>
>   
>> done:  <----------- Add
>>        rcu_read_lock();
>>        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>>
>>                /* No need to wake the master device. */
>>                if (sdata->dev == local->mdev)
>>                        continue;
>>
>>                if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
>>                        if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
>>                                ieee80211_send_nullfunc(local, sdata, 0);
>>                        ieee80211_sta_timer((unsigned long)sdata);
>>                }
>>
>>                netif_wake_queue(sdata->dev);
>>        }
>>        rcu_read_unlock();
>>
>> done:  <---------- Remove
>>     
>
> I think this patch is wrong because it will result in sending a nullfunc
> frame to the AP which the firmware should already have done in
> hardware-scan case.
>
> Can you try the patch below? I think it would be a better fix, the only
> drawback is that we do two list iterations... I hope we'll never have
> that many virtual interfaces on the list that it matters. But if this
> patch works I can also refactor the function completely, just trying to
> understand whether the STA timer really is the problem.
>
> johannes
>
> ---
>  net/mac80211/ieee80211_sta.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> --- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-01 19:16:13.000000000 +0100
> +++ everything/net/mac80211/ieee80211_sta.c	2008-03-01 19:18:58.000000000 +0100
> @@ -3610,25 +3610,28 @@ void ieee80211_scan_completed(struct iee
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> -
>  		/* No need to wake the master device. */
>  		if (sdata->dev == local->mdev)
>  			continue;
>  
> -		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
> -			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
> -				ieee80211_send_nullfunc(local, sdata, 0);
> -			ieee80211_sta_timer((unsigned long)sdata);
> -		}
> -
> -		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
> -			ieee80211_sta_timer((unsigned long)sdata);
> +		/* Tell AP we're back */
> +		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
> +		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
> +			ieee80211_send_nullfunc(local, sdata, 0);
>  
>  		netif_wake_queue(sdata->dev);
>  	}
> +
> + done:
> +	/* Restart STA timer for both SW and HW scan cases */
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
> +		    ieee80211_vif_is_mesh(&sdata->vif))
> +			ieee80211_sta_timer((unsigned long)sdata);
> +	}
> +
>  	rcu_read_unlock();
>  
> -done:
>  	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
>  		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>
>
>
>   

-- 
Bill Moss
Alumni Distinguished Professor
Mathematical Sciences
Clemson University

