Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab0ITTKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 15:10:30 -0400
Subject: Re: [mac80211] mac80211:  Support receiving data frames on
 multiple vifs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285005163-4569-1-git-send-email-greearb@candelatech.com>
References: <1285005163-4569-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 21:10:28 +0200
Message-ID: <1285009828.3688.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 10:52 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When using multiple STA interfaces on the same radio, some
> data packets need to be received on all interfaces
> (broadcast, for instance).
> 
> Remove special loop for data-only packets and just process all
> packets in the big loop that previously only handled non-data
> packets.

I'd prefer keeping different for_each_*, but maybe we can make the loops
just call a common function, say with &prev pointer or something? The
station loop will typically be iterating over fewer things here.

johannes

