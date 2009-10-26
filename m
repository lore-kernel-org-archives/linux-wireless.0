Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47789 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbZJZIhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 04:37:11 -0400
Received: by ewy4 with SMTP id 4so3375133ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 01:37:15 -0700 (PDT)
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso \(Nokia-D\/Tampere\)" <juuso.oikarinen@nokia.com>
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
	<1256201719.12174.19.camel@johannes.local>
	<4AE291DC.3010505@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 10:37:13 +0200
In-Reply-To: <4AE291DC.3010505@nokia.com> (Luciano Coelho's message of "Sat\, 24 Oct 2009 08\:34\:20 +0300")
Message-ID: <87pr8ah7pi.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@nokia.com> writes:

> ext Johannes Berg wrote:
>> On Fri, 2009-10-16 at 15:27 +0300, Luciano Coelho wrote:
>>
>>> +	if (memcmp(sdata->local->hw.conf.oper_bssid,
>>> +		   req->bss->bssid, ETH_ALEN)) {
>>> +		config_changed |= IEEE80211_CONF_CHANGE_OPER_BSSID;
>>> +		memcpy(sdata->local->hw.conf.oper_bssid,
>>> +		       req->bss->bssid, ETH_ALEN);
>>> +	}
>>> +
>>> +	ieee80211_hw_config(sdata->local, config_changed);
>>>  
>>
>> Is this really necessary before you can auth?
>
> As we discussed on IRC, it is really needed.  We must always provide a
> BSSID when changing channels in preparation for an association.

I'm not sure about the must part here. Maybe we can workaround it by
using ff:ff:ff:ff:ff bssid during authentication and association and
send a new join command after association. But that's not a clean
solution.

> Also, I'm not 100% sure, but IIRC Kalle has mentioned that the
> at76c50x-usb card also needs this feature.

Yeah, at76c50x-usb also has a similar requirement. wl1251, wl1271 and
at76c50x-usb have these weird join/start commands which need bssid and
must be executed before any data transmission. I tried to workaround
the bssid requirement in at76c50x-usb a long time ago but failed. I
need to try it again.

-- 
Kalle Valo
