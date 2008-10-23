Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48175 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbYJWTDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 15:03:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 12:03:22 -0700
Date: Thu, 23 Oct 2008 05:03:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: make use of regulatory tx power settings on
	change of tx power
Message-ID: <20081023120316.GD5979@tesla> (sfid-20081023_210327_484236_4175FC0A)
References: <1224706433-12582-1-git-send-email-lrodriguez@atheros.com> <1224742961.5865.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224742961.5865.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 11:22:41PM -0700, Johannes Berg wrote:
> On Wed, 2008-10-22 at 13:13 -0700, Luis R. Rodriguez wrote:
> 
> > +	if (data->txpower.fixed)
> > +		new_power_level = min(data->txpower.value, chan->max_power);
> 
> Incidentally, are the units really the same? Just wondering, haven't
> checked, if yes this looks good to me.

Yes, we were using both in the previous case too, this just uses
the min() now.

  Luis
