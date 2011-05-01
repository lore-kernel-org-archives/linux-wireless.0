Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1EAJ3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 05:29:52 -0400
Subject: Re:
From: Johannes Berg <johannes@sipsolutions.net>
To: Naveen Singh <nsingh@atheros.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, Naveen Singh <nsingh@atheros.com>
In-Reply-To: <1304217038-1654-1-git-send-email-sningh@atheros.com> (sfid-20110501_043058_891986_1A574C4C)
References: <1304217038-1654-1-git-send-email-sningh@atheros.com>
	 (sfid-20110501_043058_891986_1A574C4C)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 May 2011 11:29:46 +0200
Message-ID: <1304242186.3669.3.camel@jlt3.sipsolutions.net> (sfid-20110501_113024_581944_8D9B5825)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-30 at 19:30 -0700, Naveen Singh wrote:
> From: Naveen Singh <nsingh@atheros.com>
> 
> The WPA-PSK association was not going through with 2.6.38
> kernel. It was found that supplicant was not able to set
> the PTK key. On further analysis it was found that the function
> nl80211_set_key in file net/wireless/nl80211.c is returning with
> code as -EOPNOTSUPP. This function has been modified to check for
> the flag "WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS"in wiphy
> struct. If this flag is not set in the driver init, it returns
> from here thereby causing the association to fail. The solution
> is to set this flag in driver init as there would be separate
> default keys for unicast and multicast packets.

We were discussing this before ... and I think the bug is in the
supplicant actually asking for the GTK to be set as the default key or
something like that.

In any case, this doesn't seem right unless you actually do support
separate unicast keys. Are you sure you fully understand what you're
doing here, and not just randomly hacking in a workaround?

johannes

