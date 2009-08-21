Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:18236 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZHUNWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 09:22:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so176348fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 06:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250842889.13872.8.camel@johannes.local>
References: <4A8DC955.9060100@gmail.com> <1250842889.13872.8.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 15:21:43 +0200
Message-ID: <69e28c910908210621t3e239f09w6a2037e8c37b40ae@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
	again
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/21 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2009-08-21 at 00:08 +0200, Gábor Stefanik wrote:
>
>>       /* If this frame is broadcast or management, use broadcast station id */
>> -     if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
>> +     if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
>> +         iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
>>               return priv->hw_params.bcast_sta_id;
>
> Now you still can't transmit frames to another AP when connected to one,
> which will, for example, be required for 11r. IMHO that code should, in
> STATION mode, be checking the RA against the BSSID, and if they match
> use the AP ID, otherwise the bcast ID.

I'll probably do that, in a separate patch. This patch is a regression
fix targeted at the next 2.6.31-rc (injection of non-broadcasts works
fine in 2.6.30, but causes an ucode SYSASSERT in 2.6.31 and up). The
problem you are describing is not a regression AFAIK, it's something
that never worked; so it should be targeted @ 2.6.32.

> And remove the warning in the
> default case, since that's what happens if in pure monitor mode afaict.

>From my limited testing, in monitor mode, the vif type will be
IFTYPE_STATION, so the default case is never hit. (Is this a bug?)

(BTW now that in mac80211, we internally use IFTYPE_MONITOR in monitor
mode, as opposed to just checking for a missing STA - why can't we
propagate this to the drivers, and have a much saner way of informing
the driver of monitor mode? This is especially a problem for zd1211rw,
where to get proper monitor mode, ZD_SNIFFER_ON needs to be turned
on.)

>
> johannes
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
