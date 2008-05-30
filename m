Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Bass.Opus1.COM ([192.245.12.9]:4653 "EHLO bass.opus1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYE3PYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:24:35 -0400
Received: from egdell.wetwork.net ([204.17.34.178])
 by Opus1.COM (PMDF V6.2-X27 #9830)
 with ESMTPSA id <01MVE4ZP9BZM955VRF@Opus1.COM> for
 linux-wireless@vger.kernel.org; Fri, 30 May 2008 08:02:52 -0700 (MST)
Date: Fri, 30 May 2008 08:02:51 -0700
From: Ehud Gavron <gavron@wetwork.net>
Subject: Re: suspend vs. b43
In-reply-to: <1212158238.4117.4.camel@johannes.berg>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Message-id: <4840171B.5080604@wetwork.net> (sfid-20080530_172438_586913_6E44C381)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <1212150713.4117.2.camel@johannes.berg>
 <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> On Fri, 2008-05-30 at 16:06 +0200, Michael Buesch wrote:
>   
>> On Friday 30 May 2008 14:31:53 Johannes Berg wrote:
>>     
>>> Since a while ago I've had trouble resuming when b43 was connected to an
>>> AP while suspended.
>>>
>>> I did a test today where this was the only difference, but I failed to
>>> see whether ssb or b43 were causing the problem.
>>>
>>> Does anyone have a machine with b43 in it that can suspend and supports
>>> the RTC-trace feature so we can narrow it down? Even reproducing might
>>> help to make sure it's not just something weird with my powerbook.
>>>       
>> Resume is pretty broken since some time for me.
>> It sometimes works fine and sometimes just hangs with a black screen.
>> I have no idea what's going on.
>>     
>
> Odd. Resume itself works just fine here, except when b43 is up. But then
> again, you might not notice that this is the problem because by default,
> nothing gets printed on the resume console and then it will indeed hang
> with a black screen.
>
> johannes
>   
>   
With NM disabled 2.6.25-wl  4311 after a suspend/resume I can:
1. Successfully scan for APs (ifconfig wlan0 up... iwlist wlan0 scan)
2. Associate with an AP  (iwconfig ...essid...key...)
3. Get a DHCP address (dhclient... offer... bound to address such and such)
but
4. NO FURTHER IP COMMUNICATIONS WORKS

Let me know what other diags to run or if I should upgrade to the latest 
wl tree if you think that will change the symptoms.
Things have been busy but there is a weekend coming up here shortly.

Ehud

> ------------------------------------------------------------------------
>
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>   
