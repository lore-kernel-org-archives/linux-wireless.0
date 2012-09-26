Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2IZHNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:13:54 -0400
Message-ID: <1348643666.10548.2.camel@jlt4.sipsolutions.net> (sfid-20120926_091357_528263_D482A8F3)
Subject: Re: [RFC] mac80211: Notify new IBSS network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Sep 2012 09:14:26 +0200
In-Reply-To: <20578.31128.207010.660580@gargle.gargle.HOWL> (sfid-20120926_054322_128189_D4D138FB)
References: <20578.31128.207010.660580@gargle.gargle.HOWL>
	 (sfid-20120926_054322_128189_D4D138FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 09:12 +0530, Sujith Manoharan wrote:
> Initialization of beacon transmission in IBSS mode depends
> on whether a new BSS is being created or joined. When joining
> an existing IBSS network, beaconing has to start only after
> a TSF-sync has happened - this is explained in 11.1.4.
> 
> Introduce a new parameter in the BSS information structure to
> indicate creator/joiner mode.

Interesting, I guess this makes sense. Never seemed to come up, maybe it
doesn't matter all that much since we sync once we receive some other
beacon, so worst case we just transmit a few spuriously?

johannes

