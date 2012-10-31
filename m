Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798Ab2JaTK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 15:10:59 -0400
Message-ID: <1351710420.6281.8.camel@jlt4.sipsolutions.net> (sfid-20121031_201103_477639_E3334E71)
Subject: Re: Problem with drv_remove_interface when associated in 3.5.7?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <50917587.9010305@candelatech.com> (sfid-20121031_200131_307985_1A302D25)
References: <50917587.9010305@candelatech.com>
	 (sfid-20121031_200131_307985_1A302D25)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 20:07:00 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-31 at 12:01 -0700, Ben Greear wrote:
> I am working on debugging the splat I reported a few days ago in a tainted
> 3.5.7 kernel.  I've removed the tainting module, and added some debug.
> 
> I think at least part of the problem is that drv_remove_interface can
> be called with ifmgd->associated != NULL.

That should be fixed by this patch, I hope:

http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=commit;h=6863255bd0e48bc41ae5a066d5c771801e92735a

johannes

