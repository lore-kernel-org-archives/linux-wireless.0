Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41937 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZJXFef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 01:34:35 -0400
Message-ID: <4AE291DC.3010505@nokia.com>
Date: Sat, 24 Oct 2009 08:34:20 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration
 struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>	 <1255696042-28413-2-git-send-email-luciano.coelho@nokia.com> <1256201719.12174.19.camel@johannes.local>
In-Reply-To: <1256201719.12174.19.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-10-16 at 15:27 +0300, Luciano Coelho wrote:
> 
>> @@ -2405,7 +2411,15 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>>  	 *	to sleep and then change channel etc.
>>  	 */
>>  	sdata->local->oper_channel = req->bss->channel;
>> -	ieee80211_hw_config(sdata->local, 0);
>> +
>> +	if (memcmp(sdata->local->hw.conf.oper_bssid,
>> +		   req->bss->bssid, ETH_ALEN)) {
>> +		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
>> +		memcpy(sdata->local->hw.conf.oper_bssid,
>> +		       req->bss->bssid, ETH_ALEN);
>> +	}
>> +
>> +	ieee80211_hw_config(sdata->local, config_changed);
>>  
> 
> Is this really necessary before you can auth?

As we discussed on IRC, it is really needed.  We must always provide a BSSID 
when changing channels in preparation for an association.  For this reason (and 
others) the wl1271 with the current firmware does not support promiscuous mode 
or frame injections.

I'll ask TI next time we meet them, if there is any possibility to remove the 
need for the BSSID at this point, so things will be greatly simplified.  There 
is a very slight chance that this could be possible for wl1271, but for wl1251 I 
think there's no hope to change it anymore.  So in any case, we will need to 
support this on the stack if we want to have wl1251 to work correctly. :(

Also, I'm not 100% sure, but IIRC Kalle has mentioned that the at76c50x-usb card 
also needs this feature.


> If it is, you're going to have to do a lot more work and go all the way
> up to userspace so wpa_supplicant with -Dnl80211 knows about this too,
> and doesn't try to authenticate twice or do FT-OTA.

Thanks a lot for pointing this out.  I think I understand it better after our 
discussion on IRC.  I'll have to study more the authentication mechanism and 
figure out how to deal with multiple authentications, as you pointed out.

These are definitely details that I'll need to sort out.  But in principle, do 
you agree with the idea of passing the "operating" BSSID down to the driver in 
the hw_config op? And saving it as a hardware configuration parameter in 
local->hw.conf?

Once again, I really appreciate your help and the time you spend discussing and 
explaining these things in detail to me! :)

-- 
Cheers,
Luca.
