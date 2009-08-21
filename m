Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45897 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZHUShc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 14:37:32 -0400
Received: by fxm17 with SMTP id 17so607353fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 11:37:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250879069.30019.14482.camel@rc-desk>
References: <4A8DC955.9060100@gmail.com> <1250872433.30019.14430.camel@rc-desk>
	<69e28c910908211024n1c255b3p160839c60ae0b3a@mail.gmail.com>
	<1250877589.30019.14474.camel@rc-desk> <69e28c910908211110h5a326f4cw7e21cc424bc5fbdc@mail.gmail.com>
	<1250879069.30019.14482.camel@rc-desk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 21 Aug 2009 20:37:12 +0200
Message-ID: <69e28c910908211137o73cdcfb4i702769a687f9dbd6@mail.gmail.com>
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
> On Fri, 2009-08-21 at 11:10 -0700, Gábor Stefanik wrote:
>
>> That can be done, yes. It is also a good idea to convert
>> iwl_is_monitor_mode(priv) calls with TX_CTL_INJECTED checks, as
>> mac80211 will set IEEE80211_TX_CTL_INJECTED if and only if the packet
>> arrived from a monitor interface.
>
> I don't think that is the intention of that function.
> iwl_is_monitor_mode() needs to return whether the interface is in
> monitor mode or not and being in monitor mode is specifically when some
> filter flags are set up. This is what is tested in this function.

Thanks for the clarification. Will submit a corrected patch soon.

>
>>  (However, when I submitted the first
>> patches to iwlwifi to enable injection, they were rejected
>> specifically because I checked INJECTED in iwl_tx_skb/iwl394_tx_skb,
>> rather than adding a monitor mode case to iwl_get_sta_id... times
>> change I guess.) I'll submit a patch for this.
>
> Sure - you can move the check to iwl_get_sta_id. You will need to
> indicate to that function that the frame is being injected.
>
> Reinette
>
>
>
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
