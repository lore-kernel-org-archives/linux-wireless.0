Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BLRps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:45:48 -0500
Message-ID: <1360691139.29913.8.camel@jlt4.sipsolutions.net> (sfid-20130212_184550_832363_EB019B91)
Subject: Re: [PATCHv2 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 12 Feb 2013 18:45:39 +0100
In-Reply-To: <c35750825fc4c49d07d9d6e232b46623@fami-braun.de> (sfid-20130212_184310_653774_8CDBA907)
References: <1360687038-17610-1-git-send-email-michael-dev@fami-braun.de>
	 <1360687038-17610-2-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130212_173731_351014_1564560C) <1360687114.29913.5.camel@jlt4.sipsolutions.net>
	 <c35750825fc4c49d07d9d6e232b46623@fami-braun.de>
	 (sfid-20130212_184310_653774_8CDBA907)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 18:42 +0100, michael-dev wrote:

> >> -		if (!ieee80211_tx_prepare(sdata, &tx, skb))
> >> +		frame_sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
> >> +		if (!ieee80211_tx_prepare(frame_sdata, &tx, skb))
> >>  			break;
> > 
> > This can now crash the machine.
> 
> why? when?

There's no guarantee that the VLAN interface isn't destroyed while the
frame is stuck on the buffer queue.

> What would be a better approach?

This is probably fine, but incomplete -- frames for a VLAN need to be
removed from the PS queue when it goes down.

johannes

