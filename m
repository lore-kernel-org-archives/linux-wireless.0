Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51610 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbXFKQTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 12:19:11 -0400
Message-ID: <466D75FD.9090809@lwfinger.net>
Date: Mon, 11 Jun 2007 11:19:09 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net> <4668C577.4030008@lwfinger.net> <200706072012.56652.flamingice@sourmilk.net>
In-Reply-To: <200706072012.56652.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 07 June 2007 19:56, Larry Finger wrote:
>> When I leave this part out, the rate _NEVER_ gets set, no matter what you
>> say. My experiments say that it is needed.
>>
> That's because force_unicast_rateidx and max_ratectrl_rateidx is being set in 
> the wrong struct ieee80211_if_ap. (how did I miss that..) sdata->u.ap is only 
> valid when sdata->type == IEEE80211_IF_TYPE_AP, yet it's being accessed 
> without any mode checks. sdata->bss should be used instead.

Does sdata->bss need to be checked to verify that it is not NULL?

Larry
