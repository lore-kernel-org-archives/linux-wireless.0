Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1ARKv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:51:28 -0500
Subject: Re: intermittent eap authentication failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:52:12 +0100
Message-ID: <1295347932.3563.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chuck,

> Sometime ago I found a conflict between the supplicant and the MAC80211 code 
> dealing with Cisco session timeouts. When we were 'deauthenticated', the MAC 
> code notified the supplicant AND re-associated with the AP.

That doesn't seem right, mac80211 will never re-associate by itself.

> We modified the driver so that if it received a 
> de-auth with reason code 1 (undefined?), it would *NOT* notify the 
> supplicant but would re-associate, then notify the supplicant of the new 
> association. 

What's that driver you're talking about? A mac80211 driver that
reassociates by itself doesn't seem right at all.

johannes

