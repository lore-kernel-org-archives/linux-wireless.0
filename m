Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38965 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZGaIEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 04:04:25 -0400
Received: by bwz19 with SMTP id 19so1048425bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 01:04:24 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249027087.29587.18.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
	 <1249027087.29587.18.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 11:04:20 +0300
Message-Id: <1249027460.2609.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 09:58 +0200, Johannes Berg wrote:
> On Fri, 2009-07-31 at 09:43 +0200, Johannes Berg wrote:
> 
> > Fix it then. Offer an implementation of your superior solution.
> 
> I just don't think that this patch is a solution because it means that
> we'll be connected to the AP forever, without knowing anything is wrong,
> if the AP can reach us but we can't reach the AP (maybe because we have
> a good Intel card with great sensitivity).
> 
> Sure -- it's possible to factor in transmit status reports (but remember
> that not all hardware gives those reliably) or do things on a different
> schedule etc. But as long as nobody wants to really improve things I
> don't see why we should take the regression and _remove_ the current
> behaviour.
> 
> johannes


It is ok to send probes every minute or so, but not each second, and 
probes must be retried.

Because of these probes, wireless literally reconnects every 5 seconds,
here, and I am 10 meters from the AP.

Maxim

