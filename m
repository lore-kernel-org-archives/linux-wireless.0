Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:54424 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182AbXKVFcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 00:32:03 -0500
Message-ID: <474513E7.3000104@linux.intel.com> (sfid-20071122_053224_241357_93347617)
Date: Wed, 21 Nov 2007 21:30:15 -0800
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	linville@tuxdriver.com
Subject: Re: wpa_supplicant/key deletion with all-zeroes mac
References: <4743E5DF.9040603@linux.intel.com> <1195658254.12000.23.camel@johannes.berg> <20071122043722.GC8672@jm.kir.nu>
In-Reply-To: <20071122043722.GC8672@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Wed, Nov 21, 2007 at 04:17:34PM +0100, Johannes Berg wrote:
>
>   
>>> When I connect to an AP with wpa, then I receive deauth frame, 
>>> ieee80211_rx_mgmt_deauth will be called, which will call 
>>> ieee80211_set_associated(dev, ifsta, 0); to disconnect. In function 
>>> ieee80211_set_associated, it calls wireless_send_event with SIOCGIWAP 
>>> event and memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN).
>>>       
>
> This sounds correct.
>
>   
>>> wpa_supplicant will 
>>> receives this event then call mac80211 to remove any old security key, 
>>> the problem it will pass 00:00:00:00:00:00 as station address. 
>>>       
>
> This sounds broken. wpa_supplicant should remove the key for the
> previous BSSID.
>
>   
>>> ieee80211_set_encryption will fail since there are no station with 
>>> 00:00:00:00:00:00. This will leave the old key which causes the problems 
>>> in the next reconnection.
>>>       
>
> This sounds correct behavior.
>
>   
>> Interesting. I'd think this is a wpa_supplicant bug, Jouni, how is the
>> security wext stuff supposed to work here?
>>     
>
> Agreed, this sounds like a bug in wpa_supplicant. Unicast keys should be
> removed with their correct address. I think this used to work, but maybe
> some of the changes in BSSID processing in disassociation cases caused
> the old BSSID to be forgotten.
>
>   
>>> diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
>>> @@ -97,7 +97,10 @@ static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
>>> -		sta = sta_info_get(local, sta_addr);
>>> +		if (is_zero_ether_addr(sta_addr))
>>> +			sta = sta_info_get(local, sdata->u.sta.bssid);
>>> +		else
>>> +			sta = sta_info_get(local, sta_addr);
>>>       
>
> NAK. I don't think this is the correct fix here.
>
>   
I agree I just included this workaround to illustrated what I did to 
make it work. 
