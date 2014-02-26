Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1886 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaBZJ2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:28:31 -0500
Message-ID: <530DB3BA.20106@broadcom.com> (sfid-20140226_102836_686302_803B55CA)
Date: Wed, 26 Feb 2014 10:28:26 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the network
 device
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>		 <1393356639-19169-2-git-send-email-arend@broadcom.com>		 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>	 <530DAECD.8010405@broadcom.com> <1393406278.4133.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1393406278.4133.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2014 10:17 AM, Johannes Berg wrote:
> On Wed, 2014-02-26 at 10:07 +0100, Arend van Spriel wrote:
>> On 02/25/2014 08:59 PM, Johannes Berg wrote:
>>> On Tue, 2014-02-25 at 20:30 +0100, Arend van Spriel wrote:
>>>> Upon deleting the interface a cfg80211_disconnected() is called under
>>>> rtnl_lock. Right after the unlocking the rtnl_lock we unregister the
>>>> network device. This patch adds delay before unregister so cfg80211
>>>> can handle disconnect and notify wpa_supplicant.
>>>
>>>> +				/* make sure cfg80211 can send disconnect event
>>>> +				 * before unregistering the netdevice below.
>>>> +				 */
>>>> +				msleep(100);
>>>
>>> This has got to be one of the worst hacks I've seen in wireless so
>>> far ... :)
>>
>> Did you see I removed a sleep as well in this patch :-p
> 
> Yeah, I did :-)
> 
>> I just don't see how I can assure cfg80211 has actually done the
>> disconnect work. If we don't do a cfg80211_disconnected() I get a WARN
>> from the cfg80211 netdev notifier (or at least I did in previous kernel).
>>
>> Should we consider a clean solution, ie. modify cfg80211 for this scenario?
> 
> Yes. Can't we just flush the work at some strategic place?
> 
> Actually you're not talking about the "disconnect_work" (which is
> related to regulatory) but the "event_work" so I was confused here for a
> second.
> 
> What was the warning? cfg80211 already calls
> cfg80211_process_wdev_events() from within the REMOVE netdev notifier,
> so that *shouldn't* have happened.

I guess that means some wdev event is missing? It was the
WARN_ON(current->bss) that fired.

Gr. AvS
