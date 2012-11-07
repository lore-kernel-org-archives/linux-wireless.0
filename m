Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:35860 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab2KGJBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 04:01:46 -0500
Message-ID: <509A2374.4060601@posedge.com> (sfid-20121107_100201_287130_B8B50831)
Date: Wed, 07 Nov 2012 14:31:40 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Clarification needed on Last Tx Rate statistic update
References: <509A11F9.8050108@posedge.com> <1352275534.9854.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352275534.9854.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thanks for the clarification. So it seems the in the other case that you 
had mentioned, we can confirm that last_tx_rate is updated with 
inappropriate value.
So probably we could add another variable for the highest 
performing/probability rate and update it with the  txrc.reported rate 
value.
The Last_tx_rate update with the highest performing/probability rate can 
be removed.

As far as Last Tx Rate is concerned, should we need to check for the flag?
I think the Last Tx Rate can be updated irrespective of the 
IEEE80211_HW_HAS_RATE_CONTROL set or not.

Please let me know your inputs on this.

Thanks,
Saravana
On 11/07/2012 01:35 PM, Johannes Berg wrote:
> On Wed, 2012-11-07 at 13:17 +0530, Saravana wrote:
>
>> Could somebody clarify why the statistics update happens only when the
>> rate control is done by the hardware(flag IEEE80211_HW_HAS_RATE_CONTROL
>> is set)?
> In the other case, it's set to txrc.reported_rate upon transmission, so
> it's not the *last* rate, but more accurately the highest
> performing/probability rate.
>
> johannes
>
>

