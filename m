Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:23780 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751209Ab0LFIaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 03:30:22 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-057094220
	for <linux-wireless@vger.kernel.org>; Mon,  6 Dec 2010 17:30:21 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] nl80211: Export available antennas
Date: Mon, 6 Dec 2010 17:30:16 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6> <20101206034535.11462.70791.stgit@localhost6.localdomain6> <1291623453.3506.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291623453.3506.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012061730.16102.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon December 6 2010 17:17:33 Johannes Berg wrote:
> On Mon, 2010-12-06 at 12:45 +0900, Bruno Randolf wrote:
> > +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
> > +			    dev->wiphy.available_antennas);
> 
> I think you should not advertise this unless it's non-zero, and unless
> also the set/get callbacks are available.

I don't. Please check the context of this patch, esp patch 1. of this series.

> Similarly, I think you shouldn't advertise the set/get CMDs when the
> available antennas aren't set.

There are no set/get commands for antennas since you preferred putting it into 
wiphy info.

> Finally, you should check for nl80211 that the given tx/rx masks fall
> into the available antennas mask.

Allright, I can do that. Would you prefer to reject the command in this case 
or just apply the available mask?

bruno
