Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53756 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZAIM6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:58:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 04:58:34 -0800
From: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 9 Jan 2009 18:26:01 +0530
Subject: RE: multicast traffic and ath9k
Message-ID: <44EE5C37ADC36343B0625A05DD408C4845A77DAF07@CHEXMB-01.global.atheros.com> (sfid-20090109_135839_795342_B0722525)
References: <1231346161.3545.52.camel@johannes>
In-Reply-To: <1231346161.3545.52.camel@johannes>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> I'm inclined to ask you to remove that multicast checking from mac80211
> and do it closer to the hardware, and simply require from the
> driver/hardware that mac80211 needs not do anything for multicast
> traffic. Mostly because I'm thinking that once we start relying on the
> software implementation in mac80211 the delay may be too large.

I'm curious to know how this is implemented in other vendor drivers because
beacon processing is shared between the hw and sw. mc bit is processed in
the hw whereas tim bit and timestamp update need sw's help. Is the mc bit
checking done only on enabling power save? if set and mc packets are received,
how does it automatically go back to sleep and wouldn't there be any conflict
between mac80211 and the hw regarding power state since mac80211 is not aware
of the mc bit induced state change?

Vivek.
