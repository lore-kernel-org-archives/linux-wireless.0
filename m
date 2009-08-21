Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:18131 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZHUSKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 14:10:42 -0400
Received: by fg-out-1718.google.com with SMTP id e12so235601fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 11:10:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250877589.30019.14474.camel@rc-desk>
References: <4A8DC955.9060100@gmail.com> <1250872433.30019.14430.camel@rc-desk>
	<69e28c910908211024n1c255b3p160839c60ae0b3a@mail.gmail.com>
	<1250877589.30019.14474.camel@rc-desk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 20:10:23 +0200
Message-ID: <69e28c910908211110h5a326f4cw7e21cc424bc5fbdc@mail.gmail.com>
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
> On Fri, 2009-08-21 at 10:24 -0700, Gábor Stefanik wrote:
>
>> For some odd reason, reverting Wei-Yi Guy's patch makes the bug go
>> away
>
> ah - now I see. The driver defaulted to monitor mode in iwl_mac_start.
> This is not correct and this patch rightly removed that code.
>
>> ... should we do that instead for 2.6.31? (I'm all for it, if this
>> patch is not the right thing to do, as Wey-Yi's patch was not a bug
>> fix, just a cleanup.)
>
> No, this patch was more than code cleanup - it changed the driver to
> behave correctly wrt monitor interface type. Unfortunately the
> workaround to get packet injection working was not apparent enough and
> was missed.
>
>
>> My guess is that the "default to MONITOR mode"
>> change is the culprit.
>
> yeah ...
>
>
>> Maybe we should check info->flags & IEEE80211_TX_CTL_INJECTED
>> instead... is there a way to access the ieee80211_tx_info structure
>> from this function (e.g. through priv)?
>
> No, but it may not be necessary. Why is is necessary to call this
> function in the first place if you know this is an injection packet?
> Specifically, in iwl_tx_skb and iwl3945_tx_skb (where ieee80211_tx_info)
> is known) there could just be a test if this is an injected packet, if
> it is, then do not call iwl_get_sta_id, but just use "bcast_sta_id"
> directly. Would this work? Is a test for monitor mode still needed in
> this case?

That can be done, yes. It is also a good idea to convert
iwl_is_monitor_mode(priv) calls with TX_CTL_INJECTED checks, as
mac80211 will set IEEE80211_TX_CTL_INJECTED if and only if the packet
arrived from a monitor interface. (However, when I submitted the first
patches to iwlwifi to enable injection, they were rejected
specifically because I checked INJECTED in iwl_tx_skb/iwl394_tx_skb,
rather than adding a monitor mode case to iwl_get_sta_id... times
change I guess.) I'll submit a patch for this.

>
> Reinette
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
