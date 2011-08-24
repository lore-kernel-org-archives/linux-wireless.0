Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56670 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1HXG6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:11 -0400
Received: by gwaa12 with SMTP id a12so662805gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 23:58:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25d525ade5d006352bd7615ba5c98aa1@secure.sipsolutions.net>
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
	<1314099467-20464-2-git-send-email-eliad@wizery.com>
	<ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
	<CAB3XZEcqwZxYYEcVrHcnCwBBS-z505yOoy2y8PjGxRSsnZp8Uw@mail.gmail.com>
	<25d525ade5d006352bd7615ba5c98aa1@secure.sipsolutions.net>
Date: Wed, 24 Aug 2011 09:58:09 +0300
Message-ID: <CAB3XZEfH_WAVJNkbTeOYAg8GndkAQeg+q8pLgK32MQr++RqQRw@mail.gmail.com> (sfid-20110824_085817_812609_A2667EA8)
Subject: Re: [PATCH 2/2] mac80211: add uapsd_queues and max_sp params fields
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 6:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 23 Aug 2011 18:50:44 +0300, Eliad Peller wrote:
>>
>> basically these params come from the supplicant on sta addition.
>> if the ap wasn't configured with uapsd, there won't be
>> NL80211_ATTR_STA_WME attribute, and these fields will be 0.
>>
>> devices with no uapsd support will ignore these fields.
>> am i missing something?
>
> Well, so, how will the user know whether the device supports uAPSD? Or, if
> the user asks hostapd to enable uAPSD, how will hostapd know if the device
> supports it or not?
>
Currently, hostapd just looks for the uapsd_advertisement_enabled config param.
i guess we can add and require ap_uapsd capability (on a different
patch?). but won't it break environments that use new supplicant with
old drivers?

Eliad.
