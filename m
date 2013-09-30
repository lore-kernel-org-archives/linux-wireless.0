Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3I3KeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 06:34:25 -0400
Message-ID: <1380537261.14467.8.camel@jlt4.sipsolutions.net> (sfid-20130930_123434_338995_9031FAA0)
Subject: Re: [PATCH 3.12 2/2] mac80211: update sta->last_rx on acked tx
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 12:34:21 +0200
In-Reply-To: <52494861.8010007@openwrt.org>
References: <1380483574-88667-1-git-send-email-nbd@openwrt.org>
	  <1380483574-88667-2-git-send-email-nbd@openwrt.org>
	 <1380532248.14467.4.camel@jlt4.sipsolutions.net>
	 <52494861.8010007@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 11:46 +0200, Felix Fietkau wrote:
> On 2013-09-30 11:10 AM, Johannes Berg wrote:
> > On Sun, 2013-09-29 at 21:39 +0200, Felix Fietkau wrote:
> >> When clients are idle for too long, hostapd sends nullfunc frames for
> >> probing. When those are acked by the client, the idle time needs to be
> >> updated.
> >> 
> >> To make this work (and to avoid unnecessary probing), update sta->last_rx
> >> whenever an ACK was received for a tx packet. Only do this if the flag
> >> IEEE80211_HW_REPORTS_TX_ACK_STATUS is set.
> > 
> > Why that last bit? If we got an ack status, wouldn't it be OK to do
> > either way? Or are you saying drivers are lying more often than not
> > otherwise?
> I added that just in case, some drivers might not be fully reliable wrt.
> reporting the ACK status.

Ok, I'll apply it.

johannes

