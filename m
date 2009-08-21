Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37608 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbZHURYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:45 -0400
Received: by fxm17 with SMTP id 17so580347fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 10:24:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250872433.30019.14430.camel@rc-desk>
References: <4A8DC955.9060100@gmail.com> <1250872433.30019.14430.camel@rc-desk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 19:24:26 +0200
Message-ID: <69e28c910908211024n1c255b3p160839c60ae0b3a@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
	again
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/21 reinette chatre <reinette.chatre@intel.com>:
> Hi Gábor,
>
> On Thu, 2009-08-20 at 15:08 -0700, Gábor Stefanik wrote:
>> Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
>> ("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
>> broke injection of non-broadcast frames to unassociated stations
>> (causing a SYSASSERT for all such injected frames), due to injected
>> frames no longer automatically getting a broadcast station ID assigned,
>> and instead ending up with invalid station IDs.
>> This patch restores the old behavior, fixing the aforementioned
>> regression.
>
> The patch you are quoting cannot be the culprit here. As that commit
> message indicates we never set NL80211_IFTYPE_MONITOR for the interface
> type, so when that code removed the test for this interface type in
> iwl_get_sta_id it essentially removed dead code.

For some odd reason, reverting Wei-Yi Guy's patch makes the bug go
away... should we do that instead for 2.6.31? (I'm all for it, if this
patch is not the right thing to do, as Wey-Yi's patch was not a bug
fix, just a cleanup.) My guess is that the "default to MONITOR mode"
change is the culprit.

>
>>       /* If this frame is broadcast or management, use broadcast station id */
>> -     if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
>> +     if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
>> +         iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
>>               return priv->hw_params.bcast_sta_id;
>
> I think my comment ties in with what Johannes said. When we are
> associated (whether in station, adhoc, or AP mode) we want this function
> to return the correct station ID. We also know that an interface can be
> in monitor mode while it is in any of these other modes. When this
> happens we do not want to return the broadcast station id ... we still
> want to return the station id. Your patch changes this behavior and will
> in this case always return the broadcast station id.

Maybe we should check info->flags & IEEE80211_TX_CTL_INJECTED
instead... is there a way to access the ieee80211_tx_info structure
from this function (e.g. through priv)?

>
> Reinette
>
>
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
