Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:38136 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbXDZEQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 00:16:36 -0400
Message-ID: <463027A3.9040201@lwfinger.net>
Date: Wed, 25 Apr 2007 23:16:35 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
References: <462F9617.8010207@lwfinger.net> <200704251637.53683.flamingice@sourmilk.net>
In-Reply-To: <200704251637.53683.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Wednesday 25 April 2007 13:55, Larry Finger wrote:
>> In mac80211, the SIOC{S,G}IWRATE commands are not implemented. Is there
>> another way to find out what transmission rate is being used?
>>
> If mac80211 is configured to be verbose enough, it will periodically print the 
> average rate used since the last time the message was printed out.
> 
> #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>                         printk(KERN_DEBUG "%s: STA " MAC_FMT " Average rate: "
>                                "%d (%d/%d)\n",
>                                dev->name, MAC_ARG(sta->addr),
>                                srctrl->tx_avg_rate_sum /
>                                srctrl->tx_avg_rate_num,
>                                srctrl->tx_avg_rate_sum,
>                                srctrl->tx_avg_rate_num);
> #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */

The problem with that level of debug, the logs are flooded with many lines each scan cycle, which 
happens every 1 minute with NetworkManager. In addidtion, I was hoping for something I could look at 
without having to peruse my way through the complete log.

Larry
