Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45991 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYDCSvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 14:51:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Partial Fix for Range issue
Date: Thu, 3 Apr 2008 20:50:38 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	KURT PETERS <peterskurt@msn.com>
References: <BAY103-F373BE8D28C2F2A21BC15E0D8F70@phx.gbl> <200804031719.44026.mb@bu3sch.de> <47F5242D.80404@lwfinger.net>
In-Reply-To: <47F5242D.80404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804032050.38774.mb@bu3sch.de> (sfid-20080403_195119_268869_3A15AEB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 20:38:37 Larry Finger wrote:
> When the mac80211 channel tables were recently changed,
> the power_level member was removed. As a result, the value
> passed to b43legacy in conf->power_level became zero. This
> value is transferred to phy->power_level and used in calculating
> the desired TX power, which thus became zero. This patch does not
> fix all the power problems with b43legacy, but it will be needed
> anyway.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This is 2.6.25 material.
> 
> Larry
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
> +++ wireless-testing/drivers/net/wireless/b43legacy/main.c
> @@ -127,6 +127,7 @@ static struct ieee80211_rate __b43legacy
>   	{							\
>   		.center_freq	= (_freq),			\
>   		.hw_value	= (_chanid),			\
> +		.max_power	= 0x14,				\
>   	}
>   static struct ieee80211_channel b43legacy_bg_chantable[] = {
>   	CHANTAB_ENT(1, 2412),
> 
> 

In b43 I set this value to 30.
I dunno what the real HW upper limit is, so I set it so something
that's way above the actual value mac80211 will ever try anyway (because
mac80211 won't try illegal rates, if implemented correctly).

-- 
Greetings Michael.
