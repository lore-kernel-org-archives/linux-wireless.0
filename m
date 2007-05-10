Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50287 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbXEJO4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 10:56:22 -0400
Message-ID: <46433293.9010002@lwfinger.net>
Date: Thu, 10 May 2007 09:56:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide  rate information
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net> <200705100016.45876.flamingice@sourmilk.net>
In-Reply-To: <200705100016.45876.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 03 May 2007 21:21, Larry Finger wrote:
>> +static int ieee80211_ioctl_giwrate(struct net_device *dev,
>> +				  struct iw_request_info *info,
>> +				  struct iw_param *rate, char *extra)
>> +{
>> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>> +	struct sta_info * sta;
>> +	struct ieee80211_sub_if_data * sdata;
> Eliminate the spaces between * and the variable name.
> 
>> +
>> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +	if (sdata->type == IEEE80211_IF_TYPE_STA ||
>> +	    sdata->type == IEEE80211_IF_TYPE_IBSS)
>> +		sta = sta_info_get(local, sdata->u.sta.bssid);
>> +	else
>> +		return -EOPNOTSUPP;
>> +	if (!sta)
>> +		return -ENODEV;
>> +	rate->value = local->oper_hw_mode->rates[sta->txrate].rate * 100000;
> The index from sta->txrate needs to be checked to make sure it is less than 
> mode->num_rates.
> 
> Also, this function is safe in adhoc mode.. but it most likely won't do 
> anything useful since all the sta entries have different addresses and it is 
> likely that none of them are the same as the one in sdata->u.sta.bssid.

Why has the review of this patch been so strung out? Everything you comment on here was in versions 
1 & 2, but not mentioned in any review of those versions.

As to the usefulness of this function, I am testing in infrastructure, not ad-hoc, mode, and the 
output matches the average rate in the log files if debugging is enabled. If the address in 
u.sta.bssid is not correct, which address should I be using? I still maintain that the user is 
entitled to know the transmission rate from user space even if debugging is turned off, and that 
this function is needed.

Larry
