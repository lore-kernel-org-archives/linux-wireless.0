Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbbKBMY5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 07:24:57 -0500
Message-ID: <1446467094.3205.14.camel@sipsolutions.net> (sfid-20151102_132500_700362_D6597BD3)
Subject: Re: [RFC] mac80211_hwsim: Adds parameter use_hwsim_mon which can be
 used to disable hwism0
From: Johannes Berg <johannes@sipsolutions.net>
To: arwelle@cert.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Nov 2015 13:24:54 +0100
In-Reply-To: <1446239145-21119-1-git-send-email-arwelle@cert.org>
References: <1446239145-21119-1-git-send-email-arwelle@cert.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-30 at 17:05 -0400, arwelle@cert.org wrote:
> From: Adam Welle <arwelle@cert.org>
> 
> A new parameter, use_hwsim_mon has been created to implement new 
> functionalilty. use_hwsim_mon defaults to true so that normal 
> operation remains the same. When set to false, the hwsim0 device is 
> not created. This value is also checked before calling functions 
> which would transmit data to the hwsim0 device.

I understand the use case (since you explained it to me off-list), but
I don't think I want to apply this since in almost all cases having
hwsim0 around but unused isn't actually harmful.

FWIW,

> -	mac80211_hwsim_monitor_rx(hw, skb, channel);
> +	if (use_hwsim_mon)
> +		mac80211_hwsim_monitor_rx(hw, skb, channel);

Had I wanted to apply this, I'd probably have insisted to move the
check into the function instead of outside of it, since that leaves no
chances of getting it wrong when changing the code in the future.

johannes
