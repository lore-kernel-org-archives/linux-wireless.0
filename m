Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38435
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753117AbYAZNkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:40:23 -0500
Date: Sat, 26 Jan 2008 05:40:36 -0800 (PST)
Message-Id: <20080126.054036.63438935.davem@davemloft.net> (sfid-20080126_134027_958089_53138330)
To: linville@tuxdriver.com
Cc: torvalds@linux-foundation.org, mb@bu3sch.de, dcbw@redhat.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080125211815.GF14687@tuxdriver.com>
References: <20080125194807.GD14687@tuxdriver.com>
	<20080125195037.GE14687@tuxdriver.com>
	<20080125211815.GF14687@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 25 Jan 2008 16:18:15 -0500

> Alright, here is my whack at it...  The iwl_handle_data_packet_monitor
> bits are untested, as I appear to be too daft to figure-out how to
> exercise those paths.
> 
> Anyway, this is mostly just so we can scope the driver change required
> in absence of a firmware change.  Persumably the changes required if
> we were to put such code in mac80211 would be similar.

If this buffer is in the SKB, this is an illegal transformation.

Once you put something in front of skb->data, it's fair game
for other things to write over that buffer area with a pushed
packet header of their own.

The only legal way to fix this is to completely copy the packet,
headers and all, at the input site.
