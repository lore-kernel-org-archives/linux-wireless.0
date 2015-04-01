Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15713 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbDAJBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 05:01:55 -0400
Message-ID: <551BB401.7070607@broadcom.com> (sfid-20150401_110200_217661_9F397489)
Date: Wed, 1 Apr 2015 11:01:53 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Luca Coelho <luca@coelho.fi>
CC: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: broadcast ssid in scheduled scan
References: <55105DA7.3040703@broadcom.com>	 <1427811715.2057.24.camel@sipsolutions.net> <1427869720.10642.6.camel@coelho.fi>
In-Reply-To: <1427869720.10642.6.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/15 08:28, Luca Coelho wrote:
> On Tue, 2015-03-31 at 16:21 +0200, Johannes Berg wrote:
>> On Mon, 2015-03-23 at 19:38 +0100, Arend van Spriel wrote:
>>> Johannes, Jouni,
>>>
>>> I have noticed that under some circumstances wpa_supplicant initiates a
>>> scheduled scan with broadcast ssid. This is something our firmware can
>>> not do so could this be avoided? Maybe by adding a feature flag for it.
>>
>> I guess this would be difficult to do since you'd basically have to
>> "remove" support for normal scheduled scan (that assumes this ability)
>> and add support for another scheduled scan (that doesn't assume it) in
>> nl80211 ... just to be compatible with older implementations of
>> wpa_supplicant etc.
>>
>> I do wonder why the firmware cannot do this though - there's no
>> fundamental reason the 0-length SSID is all that different from a 1-byte
>> one?
>
> Is the problem in having a 0-length SSID in the probe_reqs or is it in
> having it in the matches (i.e. it doesn't support "pass all")? The
> latter makes a bit more sense, since filtering on a 0-length SSID, if
> not treated specially, would return nothing (since it would never match,
> unless an AP does send an SSID IE with 0-length).

This is indeed the issue. The scheduled scan firmware implementation 
sits on top of the scan engine and tries to match found bss'es. So 
having a broadcast ssid in struct cfg80211_sched_scan_request::ssids but 
it is for struct cfg80211_sched_scan_request::match_sets.

> It doesn't make much sense to have a "match all" scheduled scan though,
> unless wpa_s needs to find more SSIDs than what the driver supports.
> Even in that case, it wouldn't make much difference than using a normal
> scan periodically...

That is what scheduled scan with only broadcast ssid intends to do, 
right? I guess the advantage is that host can be idle.

Regards,
Arend

> --
> Luca.
>

