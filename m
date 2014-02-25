Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaBYMKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:10:14 -0500
Message-ID: <1393330210.4170.1.camel@jlt4.sipsolutions.net> (sfid-20140225_131019_157530_7D276925)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Feb 2014 13:10:10 +0100
In-Reply-To: <1393330040.4170.0.camel@jlt4.sipsolutions.net> (sfid-20140225_130729_700302_B6F153BB)
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140225_123231_872299_347E9F99) <1393330040.4170.0.camel@jlt4.sipsolutions.net>
	 (sfid-20140225_130729_700302_B6F153BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 13:07 +0100, Johannes Berg wrote:
> On Tue, 2014-02-25 at 12:27 +0100, Michal Kazior wrote:
> > The check led to VHT-capable devices being unable
> > to pair in VHT20 and were instead paired in HT20.
> 
> ??
> 
> 802.11ac says:
> ---
> A VHT STA shall support the following features:
> [...]
> — 20 MHz, 40 MHz, and 80 MHz channel widths
> [...]
> ---
> 
> so how can you have a device that's "VHT-capable" but doesn't support 40
> MHz?

And also:

A VHT STA shall set the Supported Channel Width Set subfield in its HT
Capabilities element HT Capabilities Info field to 1, indicating that
both 20 MHz operation and 40 MHz operation are supported.

(10.39.1)

johannes

