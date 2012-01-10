Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40157 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2AJP4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 10:56:40 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Rke3z-0001N3-4B
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 16:56:39 +0100
Received: from f053222165.adsl.alicedsl.de ([78.53.222.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 16:56:39 +0100
Received: from drahemmaps by f053222165.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 16:56:39 +0100
To: linux-wireless@vger.kernel.org
From: Martin Schleier <drahemmaps@gmx.net>
Subject: Re: DFS implementation status update
Date: Tue, 10 Jan 2012 15:56:22 +0000 (UTC)
Message-ID: <loom.20120110T162707-893@post.gmane.org> (sfid-20120110_165647_008586_62468CD8)
References: <CAK80WHZZp=NxVigOZWgECF6Z1Apdzc3dPCXyYRn98QizALTh=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Goldenshtein, Victor <victorg@...> writes:

> 
> Dear all,
> 
> We're now in the final DFS development stage and planning to release
> RFC patchsets (both hostapd and nl/cfg/mac80211) in the next week or
> so.
> 
> Main idea
> [...]
Don't have the background to tell whenever these ideas are sane or not...

> Enclosed:
> 1. dfs_init_flow.jpeg: Which illustrates DFS init flow.
> 2. radar_event_channel_switch.jpeg: Which illustrates radar_detection
> event and the channel switch procedure.
But your diagrams look really odd to me. They seem to look like shiny UML
sequence diagrams, but some things are wrong.

The kernel will never "call" directly into userspace. But you
use a "synchronizied call" arrow for RADAR_EVENT from "driver" over
mac/nl80211 into hostapd. The same is true for CHANNEL_SWITCH as well.
That's not how this is supposed to work, mac80211 sends an async nl80211
message and hostapd's event listener is processing it.

Also why are you using "alt" [radar_detected], when there's only one
condition? Wouldn't it make it more sense to go for the "opt" fragment there?

