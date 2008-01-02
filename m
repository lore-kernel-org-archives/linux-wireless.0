Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.LOGIN.COM ([192.195.240.2]:2071 "EHLO login.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752850AbYABTo2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 14:44:28 -0500
Message-ID: <477BE805.9020500@wetwork.net> (sfid-20080102_194432_626455_D0976830)
Date: Wed, 02 Jan 2008 12:37:41 -0700
From: Ehud Gavron <gavron@wetwork.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <larry.finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Fix rxheader channel parsing
References: <200801021855.53410.mb@bu3sch.de> <477BDD58.9050702@lwfinger.net> <200801022002.58434.mb@bu3sch.de>
In-Reply-To: <200801022002.58434.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Happy New Year, Michael!

:)

Ehud

Michael Buesch wrote:
> On Wednesday 02 January 2008 19:52:08 Larry Finger wrote:
>   
>> Michael Buesch wrote:
>>     
>>> This patch fixes the parsing of the RX data header channel field.
>>>
>>> The current code parses the header incorrectly and passes a wrong
>>> channel number and frequency for each frame to mac80211.
>>> The FIXMEs added by this patch don't matter for now as the code
>>> where they live won't get executed anyway. They will be fixed later.
>>>
>>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>>>
>>> ---
>>>
>>> John, as this is a bugfix, it should go into 2.6.24 if still possible.
>>>
>>> Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
>>> ===================================================================
>>> --- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-12-30 20:30:03.000000000 +0100
>>> +++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2008-01-02 18:13:15.000000000 +0100
>>> @@ -549,21 +549,32 @@ void b43_rx(struct b43_wldev *dev, struc
>>>  	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
>>>  	case B43_PHYTYPE_A:
>>>  		status.phymode = MODE_IEEE80211A;
>>> -		status.freq = chanid;
>>> -		status.channel = b43_freq_to_channel_a(chanid);
>>> -		break;
>>> -	case B43_PHYTYPE_B:
>>> -		status.phymode = MODE_IEEE80211B;
>>> -		status.freq = chanid + 2400;
>>> -		status.channel = b43_freq_to_channel_bg(chanid + 2400);
>>> +		B43_WARN_ON(1);
>>> +		/* FIXME: We don't really know which value the "chanid" contains.
>>> +		 *        So the following assignment might be wrong. */
>>> +		status.channel = chanid;
>>> +		status.freq = b43_channel_to_freq_5ghz(status.channel);
>>>  		break;
>>>       
>> Shouldn't you just drop this case? No B PHY devices will ever use b43 and the default branch will
>> issue the WARN_ON anyway.
>>     
>
> I guess you misread the patch.
>
>   
