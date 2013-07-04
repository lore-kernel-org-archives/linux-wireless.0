Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3GDH2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 03:28:04 -0400
Message-ID: <1372922870.8235.0.camel@jlt4.sipsolutions.net> (sfid-20130704_092808_201680_8B186401)
Subject: Re: Replacement for local->hw.conf.channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 04 Jul 2013 09:27:50 +0200
In-Reply-To: <51D4BB56.9070401@candelatech.com> (sfid-20130704_020129_998241_BE6D0EF6)
References: <51D4BB56.9070401@candelatech.com>
	 (sfid-20130704_020129_998241_BE6D0EF6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-03 at 17:01 -0700, Ben Greear wrote:
> I'm trying to port some patches forward to 3.10....
> 
> I am trying to find the current channel for a radio.  Since
> hw.conf.channel no longer exists, what is the best way to
> go about this?

Well there's hw.conf.chandef.chan now I think, but that can be NULL and
generic mac80211 code must not use it. There's no single current channel
any more, you want vif->chanctx or so.

johannes

