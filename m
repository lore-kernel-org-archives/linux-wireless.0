Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41510 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZEIBsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 21:48:43 -0400
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
 reorder buffer
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1241709323.4903.25.camel@localhost.localdomain>
References: <20090505173512.349795688@atheros.com>
	 <20090505173550.273830766@atheros.com>
	 <1241709323.4903.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 08 May 2009 18:48:23 -0700
Message-Id: <1241833703.4903.83.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > This patch allows skbs to be released from the RX reorder buffer in
> > case they have been there for an unexpectedly long time without us
> > having received the missing frames before them. Previously, these
> > frames were only released when the reorder window moved and that could
> > take very long time unless new frames were received constantly (e.g.,
> > TCP connections could be killed more or less indefinitely).
> > 
> > This situation should not happen very frequently, but it looks like
> > there are some scenarious that trigger it for some reason. As such,
> > this should be considered mostly a workaround to speed up recovery
> > from unexpected siutation that could result in connections hanging for
> > long periods of time.
> 
> I can confirm that this used to be a regular situation between my X200
> and a D-Link access point. I was originally thinking this was a driver
> issue, but your patch makes it possible to use wireless-testing tree
> again. I am not kidding here, before your patch it was impossible to use
> it at all. For me it was a real frequent situation. It is still present,
> but now it handles it more gracefully:
> 
> Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
> iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
> activated addBA response timer on tid 0
> switched off addBA timer for tid 0 
> Aggregation is on for tid 0 
> Rx A-MPDU request on tid 0 result 0
> unexpected AddBA Req from 00:1c:f0:xx:xx:xx on tid 0
> phy0: release an RX reorder frame due to timeout on earlier frames
> phy0: release an RX reorder frame due to timeout on earlier frames

so I finally got the debug output for you. Took only over a day :)

phy0: AddBA: ssn=195, dialog_token=1 tid=0 timeout=0ba_policy=1
addba: d0 00 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
addba: 00 1c f0 62 88 5b 50 d7 03 00 01 02 10 00 00 30 
addba: 0c 
Rx A-MPDU request on tid 0 result 0
Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
activated addBA response timer on tid 0
switched off addBA timer for tid 0 
Aggregation is on for tid 0 
phy0: AddBA: ssn=371, dialog_token=2 tid=0 timeout=0ba_policy=1
addba: d0 00 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
addba: 00 1c f0 62 88 5b 90 f0 03 00 02 02 10 00 00 30 
addba: 17 
phy0: RX reorder buf: head_seq=371 ssn=195 buf_size=64 stored_mpdu_num=0 timeout=0 index=48; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
unexpected AddBA Req from 00:1c:f0:xx:xx:xx on tid 0
phy0: release an RX reorder frame due to timeout on earlier frames
phy0: RX reorder buf: head_seq=2001 ssn=195 buf_size=64 stored_mpdu_num=3 timeout=0 index=14; - - - - - - - - - - - - - - - - 236 229 0 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
phy0: release an RX reorder frame due to timeout on earlier frames
phy0: RX reorder buf: head_seq=2004 ssn=195 buf_size=64 stored_mpdu_num=2 timeout=0 index=17; - - - - - - - - - - - - - - - - - 229 0 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
phy0: release an RX reorder frame due to timeout on earlier frames
phy0: RX reorder buf: head_seq=2197 ssn=195 buf_size=64 stored_mpdu_num=3 timeout=0 index=18; - - - - - - - - - - - - - - - - - - - 124 124 0 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
phy0: release an RX reorder frame due to timeout on earlier frames
phy0: RX reorder buf: head_seq=2199 ssn=195 buf_size=64 stored_mpdu_num=2 timeout=0 index=20; - - - - - - - - - - - - - - - - - - - - 124 0 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Regards

Marcel


