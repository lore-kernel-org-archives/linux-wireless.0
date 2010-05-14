Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0ENN6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:58:35 -0400
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4BEB175F.7000001@free.fr>
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr>
	 <1273098986-19330-2-git-send-email-benoit.papillault@free.fr>
	 <1273128051.3573.17.camel@jlt3.sipsolutions.net> <4BE49BDD.8010803@free.fr>
	 <1273574892.3669.54.camel@jlt3.sipsolutions.net> <4BEB175F.7000001@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 15:58:34 +0200
Message-ID: <1273845514.4950.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-12 at 23:02 +0200, Benoit Papillault wrote:

> I thought again about 2 HT STA joining a non-HT IBSS. If we want those 2 
> STA to be able to send/receive HT frames then they must know each other 
> capabilities. So HT Capabilities should be sent if ht_supported = true, 
> even if channel_type is CHAN_NO_HT

That has interesting protection requirements. How do we take care of
those?

> I did some patch in this area in my tree. Basically, the peer STA is 
> created only on beacon/probe response since only those frames contains 
> peer capabilities. Any frames received before is simply ignored.

I'll let you discuss that with Bruno. I think we may need to "upgrade"
to HT on receiving that, rather than leaving us without connectivity to
that peer.

johannes

