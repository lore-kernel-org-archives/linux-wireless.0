Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41156 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbXL1WLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 17:11:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: cfg80211 API for channels/bitrates, mac80211 and driver conversion
Date: Fri, 28 Dec 2007 23:10:56 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1198878633.4172.19.camel@johannes.berg>
In-Reply-To: <1198878633.4172.19.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200712282310.56981.mb@bu3sch.de> (sfid-20071228_221129_647929_68CA82EB)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 December 2007 22:50:33 Johannes Berg wrote:
> This patch creates new cfg80211 wiphy API for channel and bitrate
> registration and converts mac80211 and drivers to the new API. The
> old mac80211 API is completely ripped out.
> 
> Along with the regulatory code I've also ripped out the
> IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
> unnecessary if the hardware simply gives us whatever channels it wants
> to support and we then enable/disable them as required, which is pretty
> much required for travelling.
> 
> Additionally, the patch adds proper "basic" rate handling for STA
> mode interface, AP mode interface will have to have new API added
> to allow userspace to set the basic rate set, currently it'll be
> empty... However, the basic rate handling will need to be moved to
> the BSS conf stuff.
> 
> ---
>  drivers/net/wireless/adm8211.c               |   80 ++--
>  drivers/net/wireless/adm8211.h               |   65 ---
>  drivers/net/wireless/b43/b43.h               |    5 
>  drivers/net/wireless/b43/main.c              |  162 ++++-----
>  drivers/net/wireless/b43/sysfs.c             |   89 -----
>  drivers/net/wireless/b43/xmit.c              |   73 ++--
>  drivers/net/wireless/b43legacy/b43legacy.h   |    4 
>  drivers/net/wireless/b43legacy/main.c        |  159 ++++-----
>  drivers/net/wireless/b43legacy/xmit.c        |   64 +-- 

Ack for the b43 and b43legacy changes.
But that one FIXME for the bphy should get fixed first in b43legacy.
You can drop the FIXME in b43, as b43 does not support bphy devices.

I'll probably submit a few changes to this after this was applied.

-- 
Greetings Michael.
