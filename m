Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946599AbXBIQQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:16:40 -0500
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200702051455.59331.flamingice@sourmilk.net>
References: <20070131013717.GA28076@tuxdriver.com>
	 <200702051423.13998.flamingice@sourmilk.net>
	 <1170703485.3572.43.camel@johannes.berg>
	 <200702051455.59331.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 17:14:08 +0100
Message-Id: <1171037648.4520.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-05 at 14:55 -0500, Michael Wu wrote:

> 1. Userspace usually expects to send things on network interfaces. The kernel 
> usually receives frames from userspace on network interfaces. I don't see the 
> point of making an exception for 802.11 frames. (or rather, the potential for 
> simpler frame injection code is not enough to justify inventing a new 
> interface for doing it)

I guess I'm a purist here and would expect to be able to push frames of
whatever type the interface says it supports, if any. But this breaks,
you'll be pushing some sort of extensible format down there. [1]

Also, assuming that we do transmit software in userspace then has to
parse the 

> 2. nl80211/cfg80211 is for configuring interfaces. Everything there is related 
> to configuration of wireless interfaces except for the frame injection hook. 
> It doesn't look right.

Ok, well, I've removed it for now.

johannes

[1] it would have to be, I'm sure new frame injection requirements will
come up at some point and we can't break old apps


