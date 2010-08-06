Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38513 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0HFSsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:48:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:48:55 -0700
Date: Fri, 6 Aug 2010 11:48:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hakan Coskun <coskun@cs.tu-berlin.de>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Multiple interfaces with one card
Message-ID: <20100806184849.GF1757@tux>
References: <mailman.2.1281088802.10054.ath9k-devel@lists.ath9k.org>
 <F980642C-09A1-41C9-95D2-ABA6C7ED3F98@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <F980642C-09A1-41C9-95D2-ABA6C7ED3F98@cs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 06, 2010 at 03:32:20AM -0700, Hakan Coskun wrote:
> Hi,
> 
> we are doing research in order to study the behaviour of virtual wifi interfaces with channel switching. After a simulative study, we started to perform some real world experiments with ath9k. Running multiple wiphys on top of a card is working quite good. Of course there are several restrictions and performance problems, we are working on some scheduling algorithms to improve the operation.
> But now to take it a step further, we plan to go for a mac80211 based virtualization, meaning to run multiple vifs in parallel in station mode. The first step is to run them on the same channel, but as expected this is not working. We can create several interfaces with iw, there is no problem. Even scanning is working, but as soon as we want to connect to an open AP we get into trouble. The authentication is not working.
>  
> Sure, the mac80211 needs some additional functionality like ath9k, to cope with multiple associations and channel switching, etc.. How can we track the sequence of operations during the runtime in order to get a better understanding of the mac80211. At the moment, we enabled tracing and debug messages for mac80211, this helps but is not sufficient to follow the functions step by step. We can put a lot of debugging messages into the files, but  are there any "best practices" we should follow. 
> 

Hakan, I recommend you use the linux-wireless mailing list for this
and also always use wireless-testing.git for your development.

Can you post patches of what you have done to mac80211 / cfg80211?

  Luis

