Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0CRRHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 13:07:51 -0400
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
 ieee80211_local data structure
From: Johannes Berg <johannes@sipsolutions.net>
To: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	br1@einfach.org, ht6100@gmail.com
In-Reply-To: <4BA24A12.4030208@gmail.com>
References: <4BA24A12.4030208@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 09:19:09 -0700
Message-ID: <1268929149.4005.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 16:43 +0100, lorenzo.bianconi83@gmail.com wrote:
> Hi all,
> 
> I resend the patch in order to fix style violations that Larry suggested me.
> 
> I noticed a possible issue in the pending queue management of the
> ieee80211_local data structure. In particular, there is no control of the queue
> depth and this could cause a memory overflow. In the tests I carried out I
> obtain a memory overflow when I use a low priority queue (e.g. Backgreound
> queue) and I transmit a data stream that exceeds the channel capacity (e.g.
> 50Mbps@MCS 3, 800ns GI and 20MHz channel width). I tested the patch below on the
> last compat-wireless (2010-03-03) on an AR9280 chipset (Ubiquiti Rocket M with
> the latest version of OpenWrt trunk).

What kernel are you testing this on? I would have thought
cf0277e714a0db302a8f80e1b85fd61c32cf00b3 fixed this.

johannes

