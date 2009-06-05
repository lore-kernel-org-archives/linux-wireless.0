Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51447 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZFETB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 15:01:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
Date: Fri, 5 Jun 2009 21:01:46 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
In-Reply-To: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906052101.47168.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 June 2009 20:19:19 Larry Finger wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This ports the b43/legacy rfkill code to the new API offered
> by cfg80211 and thus removes a lot of useless stuff.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Michael Buesch <mb@bu3sch.de>
> ---
> 
> V1 - Original by Johannes.
> V2 - Modified in testing by Larry.
>      The rfkill polling routine brings the interface back to the initialized
>      state if it is found to be uninitialized. This way the rfkill switch
>      may be interpreted. In addition, the radio LED is not turned on in the
>      initialization routine unless the rfkill switch is on.

This is pretty silly behavior IMO. Just to bring it to the point:
We initialize a huge wireless MAC, PHY and Radio that consume several watts of power
just to poll a silly RF-kill bit.

We can't we just accept that the RF-kill status is unknown while the device is down?

I really do hate all that rfkill crap and I'm still refusing to sign off on anything that's
related to rfkill (like I did for the past year or so). If people want this merged,
somebody else maintain and sign it off, please.

-- 
Greetings, Michael.
