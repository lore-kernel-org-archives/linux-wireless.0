Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18840 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaBZKoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 05:44:04 -0500
Message-ID: <530DC56E.9040202@broadcom.com> (sfid-20140226_114408_494654_78FCE077)
Date: Wed, 26 Feb 2014 11:43:58 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the network
 device
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>			 <1393356639-19169-2-git-send-email-arend@broadcom.com>			 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>		 <530DAECD.8010405@broadcom.com>	 <1393406278.4133.4.camel@jlt4.sipsolutions.net>	 <530DB3BA.20106@broadcom.com> <1393407473.4133.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1393407473.4133.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2014 10:37 AM, Johannes Berg wrote:
> On Wed, 2014-02-26 at 10:28 +0100, Arend van Spriel wrote:
> 
>>> Yes. Can't we just flush the work at some strategic place?
>>>
>>> Actually you're not talking about the "disconnect_work" (which is
>>> related to regulatory) but the "event_work" so I was confused here for a
>>> second.
>>>
>>> What was the warning? cfg80211 already calls
>>> cfg80211_process_wdev_events() from within the REMOVE netdev notifier,
>>> so that *shouldn't* have happened.
>>
>> I guess that means some wdev event is missing? It was the
>> WARN_ON(current->bss) that fired.
> 
> Hmm, that's odd, the process_wdev_events() call is right before that, so
> I don't see how that could have happened?

Ok. The warning probably happened in earlier kernel, because our module
exit was buggy. I fixed that a while ago and I just verified I don't see
it without this patch. Sorry for bringing that diversion up.

Actually, this was not the reason for the doing the msleep(). The
problem was that wpa_supplicant received RTM_DELLINK, before getting the
NL08211_DISCONNECT. This resulted in RTM_DELLINK, immediately followed
by RTM_ADDLINK, followed by NL80211_DISCONNECT.

Gr. AvS
