Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:16650 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbZJZJLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 05:11:15 -0400
Message-ID: <4AE56792.8080401@nokia.com>
Date: Mon, 26 Oct 2009 11:10:42 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration
 struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>	<1256201719.12174.19.camel@johannes.local>	<4AE291DC.3010505@nokia.com> <87pr8ah7pi.fsf@purkki.valot.fi>
In-Reply-To: <87pr8ah7pi.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@nokia.com> writes:
> 
>> ext Johannes Berg wrote:
>>> On Fri, 2009-10-16 at 15:27 +0300, Luciano Coelho wrote:
>>>
>>>> +	if (memcmp(sdata->local->hw.conf.oper_bssid,
>>>> +		   req->bss->bssid, ETH_ALEN)) {
>>>> +		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
>>>> +		memcpy(sdata->local->hw.conf.oper_bssid,
>>>> +		       req->bss->bssid, ETH_ALEN);
>>>> +	}
>>>> +
>>>> +	ieee80211_hw_config(sdata->local, config_changed);
>>>>  
>>> Is this really necessary before you can auth?
>> As we discussed on IRC, it is really needed.  We must always provide a
>> BSSID when changing channels in preparation for an association.
> 
> I'm not sure about the must part here. Maybe we can workaround it by
> using ff:ff:ff:ff:ff bssid during authentication and association and
> send a new join command after association. But that's not a clean
> solution.

During one of our camps with TI, they told us that we must send the correct 
BSSID, otherwise we are going to have some side-effects.  At least BT coext will 
be affected.  And we have also seen the firmware send probe_reqs to 
ff:ff:ff:ff:ff:ff, which was causing problems.  The firmware is simply not 
designed to do this.  You probably also remember that we have recently removed 
extra joins from the wl1251 code as well, because they were causing some 
problems.  So, from my point-of-view, this is unfortunately a must for wl1271. :(


-- 
Cheers,
Luca.
