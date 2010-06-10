Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41982 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0FJGeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 02:34:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 23:34:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19472.34751.901289.691973@gargle.gargle.HOWL>
Date: Thu, 10 Jun 2010 12:05:43 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 06/22] mac80211: pull mgmt frame rx into rx handler
In-Reply-To: <1276151288.3623.4.camel@jlt3.sipsolutions.net>
References: <20100609150142.227469359@sipsolutions.net>
	<20100609150454.085469240@sipsolutions.net>
	<19472.26203.835523.525595@gargle.gargle.HOWL>
	<1276151288.3623.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Mesh also used (and needed to!) RX_QUEUED for the case where it actually
> wanted the packet. I just wrote the code the other way around -- before
> it was returning RX_QUEUED if wanted, now it short-cuts to
> "RX_DROP_MONITOR" if unwanted.
> 
> > Wouldn't this change mesh mode's existing behavior ?
> 
> No, I don't think it does, in ieee80211_rx_h_mgmt() RX_CONTINUE and
> RX_DROP_MONITOR are equivalent since that's the last possible thing to
> happen with a (management) frame. Unless I'm misunderstanding you?

Ok. I assumed that RX_CONTINUE was needed by mesh for some purpose.

Sujith
