Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350AbZHUSY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 14:24:28 -0400
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
 again
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910908211110h5a326f4cw7e21cc424bc5fbdc@mail.gmail.com>
References: <4A8DC955.9060100@gmail.com>
	 <1250872433.30019.14430.camel@rc-desk>
	 <69e28c910908211024n1c255b3p160839c60ae0b3a@mail.gmail.com>
	 <1250877589.30019.14474.camel@rc-desk>
	 <69e28c910908211110h5a326f4cw7e21cc424bc5fbdc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Aug 2009 11:24:29 -0700
Message-Id: <1250879069.30019.14482.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gábor,

On Fri, 2009-08-21 at 11:10 -0700, Gábor Stefanik wrote:

> That can be done, yes. It is also a good idea to convert
> iwl_is_monitor_mode(priv) calls with TX_CTL_INJECTED checks, as
> mac80211 will set IEEE80211_TX_CTL_INJECTED if and only if the packet
> arrived from a monitor interface.

I don't think that is the intention of that function.
iwl_is_monitor_mode() needs to return whether the interface is in
monitor mode or not and being in monitor mode is specifically when some
filter flags are set up. This is what is tested in this function. 

>  (However, when I submitted the first
> patches to iwlwifi to enable injection, they were rejected
> specifically because I checked INJECTED in iwl_tx_skb/iwl394_tx_skb,
> rather than adding a monitor mode case to iwl_get_sta_id... times
> change I guess.) I'll submit a patch for this.

Sure - you can move the check to iwl_get_sta_id. You will need to
indicate to that function that the frame is being injected.

Reinette





