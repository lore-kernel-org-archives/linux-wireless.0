Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44119 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1HRFFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 01:05:50 -0400
Message-ID: <810b521f028c03b74ef357f22bd5d5ab.squirrel@mail.candelatech.com> (sfid-20110818_070554_360631_B5C54BC5)
In-Reply-To: <6FA32078-B95C-47B6-98C8-17DE81CE5FE5@comsys.rwth-aachen.de>
References: <6FA32078-B95C-47B6-98C8-17DE81CE5FE5@comsys.rwth-aachen.de>
Date: Wed, 17 Aug 2011 22:05:42 -0700 (PDT)
Subject: Re: Multiple virtual interfaces, ath9k
From: greearb@candelatech.com
To: "Hanno Wirtz" <hanno.wirtz@comsys.rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
>
> I am having problems with the operation of multiple virtual interfaces.
> A short scenario description :

Please post your hostapd configs for the two virtual APs.

Every virtual station must be on the same channel.  APs must
be configured for the same channel, and stations must be able to
associate with an AP on the same channel...

Thanks,
Ben

>
> I would like to provide two independent wifi networks at my device, both
> using a virtual AP interface.
> Furthermore, I would like to dynamically associate to (multiple) other
> networks using dynamically created STA interfaces.
> This results in two AP interfaces that are permanently active and at least
> one (up to 5) STA interface(s) that run(s) concurrently.
> I use Ubuntu kernel 3.1-rc2 with compat-wireless-3.1, the machine has an
> Atheros AR9285 wireless chip.
>
>>From what I read, this should be possible, and in fact *some*
>> combinations work, i.e. 2 AP interfaces, 1 AP + 1 STA and 2 STA
>> interfaces.
> However, adding a STA interface or an AP interface respectively, causes
> the connections to all associated stations to be terminated in the case of
> AP interfaces.
> In the case of STA interfaces, no working association to a network is
> possible.
> The debug output in /var/log/syslog and in
> /sys/kernel/debug/ieee80211/phy*/ath9k is rather inconclusive to me, as I
> only seem to find notifications and
> statistics. The only thing I found so far that could be the cause for such
> behavior is the "ieee80211_iface_combination" structure in
> compat-wireless,
> in which the number, types and allowed combination of virtual interfaces
> is set.
>
> I would be happy to work on the driver code itself, however I am a bit
> clueless where to start and what actual *errors* to search and fix.
> If anyone could point me to something, that would help me a lot. If that
> helps, I can post complete syslog and debug traces tomorrow.
>
> Thanks a lot in advance,
>
> Hanno
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

