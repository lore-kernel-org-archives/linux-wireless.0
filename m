Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58324 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZFBOlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 10:41:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
Date: Tue, 2 Jun 2009 16:41:10 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090602111027.460530075@sipsolutions.net> <20090602111112.460472915@sipsolutions.net>
In-Reply-To: <20090602111112.460472915@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906021641.11019.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 June 2009 13:10:30 Johannes Berg wrote:
> This ports the b43/legacy rfkill code to the new API offered
> by cfg80211 and thus removes a lot of useless stuff.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/b43/Kconfig           |    7 --
>  drivers/net/wireless/b43/Makefile          |    2 
>  drivers/net/wireless/b43/b43.h             |    3 
>  drivers/net/wireless/b43/leds.c            |    2 
>  drivers/net/wireless/b43/main.c            |   27 ++-----
>  drivers/net/wireless/b43/phy_common.h      |    2 
>  drivers/net/wireless/b43/rfkill.c          |   94 +--------------------------
>  drivers/net/wireless/b43/rfkill.h          |   46 -------------
>  drivers/net/wireless/b43legacy/Kconfig     |    8 --
>  drivers/net/wireless/b43legacy/Makefile    |    2 
>  drivers/net/wireless/b43legacy/b43legacy.h |    3 
>  drivers/net/wireless/b43legacy/leds.c      |    2 
>  drivers/net/wireless/b43legacy/main.c      |   17 +---
>  drivers/net/wireless/b43legacy/rfkill.c    |   99 +----------------------------
>  drivers/net/wireless/b43legacy/rfkill.h    |   51 --------------
>  15 files changed, 29 insertions(+), 336 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-06-02 12:53:36.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-06-02 12:56:11.000000000 +0200
> @@ -98,13 +98,6 @@ config B43_LEDS
>  	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
>  	default y
>  
> -# This config option automatically enables b43 RFKILL support,
> -# if it's possible.
> -config B43_RFKILL
> -	bool
> -	depends on B43 && (RFKILL = y || RFKILL = B43)
> -	default y

Don't you need to add a new "depends on" to "B43", if you remove this?
Or is rfkill always compiled in if wireless is present?

-- 
Greetings, Michael.
