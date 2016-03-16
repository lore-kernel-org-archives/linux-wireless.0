Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54858 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778AbcCPJ5B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 05:57:01 -0400
Message-ID: <1458122217.2158.4.camel@sipsolutions.net> (sfid-20160316_105705_114685_E14116E8)
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Roger James <roger@beardandsandals.co.uk>,
	linux-wireless@vger.kernel.org
Date: Wed, 16 Mar 2016 10:56:57 +0100
In-Reply-To: <56E92D0A.9090905@beardandsandals.co.uk> (sfid-20160316_105322_529591_4414BB8B)
References: <56E92D0A.9090905@beardandsandals.co.uk>
	 (sfid-20160316_105322_529591_4414BB8B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-16 at 09:53 +0000, Roger James wrote:
> 
> However that only accounts for the ath10k, iwldvm, and iwlmvm
> drivers. I realise that there is a lot of history here, but is what
> the remaining drivers doing in any way deprecated? Also can anyone
> give me a heads up on what the architectural difference is between
> hooking the monitor config change and and setting the want monitor
> flag. Is one way preferable to the other? Both seem to inform the
> driver that there is a transition between having no monitor virtual
> interfaces and having one or more.

Not quite. CONF_MONITOR says "you have >0" monitor interfaces.
drv_add_interface(type=monitor) says "you have >0 monitor interfaces
and 0 others", so there's a difference.

Checking type==monitor in add_interface() *without*
setting WANT_MONITOR_VIF will never be true, since that cannot happen.
Not sure which drivers are doing that, and why they'd try to.

johannes
