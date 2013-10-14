Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3JNRph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:45:37 -0400
Message-ID: <1381772716.13092.21.camel@jlt4.sipsolutions.net> (sfid-20131014_194540_026284_47FE2AD3)
Subject: Re: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh
 beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Date: Mon, 14 Oct 2013 19:45:16 +0200
In-Reply-To: <CAHS2MGMONy37xZedzRhx10Mes9MCUMfiEjmWjprVOEQY_brw9Q@mail.gmail.com> (sfid-20131014_191519_154649_CCA765BB)
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com>
	 <1381760191.13092.13.camel@jlt4.sipsolutions.net>
	 <CAHS2MGMONy37xZedzRhx10Mes9MCUMfiEjmWjprVOEQY_brw9Q@mail.gmail.com>
	 (sfid-20131014_191519_154649_CCA765BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 01:15 +0800, Chun-Yeow Yeoh wrote:

> > Does this even make sense here - it can't ever be non-NULL in this
> > patch?
> Actually, the NULL and non-NULL situation should occur here. Whenever
> the node triggers the channel switching period, it will append CSA and
> MCSP elements in the beacon.

It occurs after later patches only though, and this patch introduces an
RCU warning. I'd suggest to roll this into patch 5 or so since there
it's really only used?

johannes

