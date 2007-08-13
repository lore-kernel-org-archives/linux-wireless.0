Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39391 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbXHMXNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 19:13:52 -0400
Message-ID: <46C0E5AD.2080407@lwfinger.net>
Date: Mon, 13 Aug 2007 18:13:49 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when software  WEP encryption is used
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net> <200708140054.22845.IvDoorn@gmail.com>
In-Reply-To: <200708140054.22845.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> 
> Not a question regarding the patch itself, but more about the comment
> regarding IEEE80211_HW_WEP_INCLUDE_IV and WEP encryption. ;)
> 
> You mean the drivers that require mac80211 to do the encryption/decryption
> must make sure the IEEE80211_HW_WEP_INCLUDE_IV is _not_ set?
> I figured that when device requires software encryption they should set the flag
> since they do not touch the frame and pass it through completely to the stack
> this would also mean that the IV is passed on. Which should suggest that the
> flag should be set to tell mac80211 it can use the IV.

I'm not too up on this myself, but when I ported the frond end of bcm43xx-mac80211 to b43legacy, I 
left the flags supplied to mac80211 untouched. Once I got the basic engine running using V3, rather 
than V4, firmware, it did WPA encryption just fine. Of course, WPA is done in software in both 
instances. WEP encrypt/decrypt is done in hardware in bcm43xx-mac80211, but it does not work in V3. 
The only way I could get software-based WEP to work was to get rid of the "set_key" callback, which 
sets an internal flag called force_sw_encrypt, and kill that flag. Then both WEP and WPA worked in 
software, but the message showed up for WPA.

Yes, this empirical behavior does not seem to match one's intuition on what the flag should do.

Of course my patch is a complete hack that is band-aiding over a deeper flaw/bug in mac80211; 
however, my request for a fix has gone unanswered. In addition, this problem is preventing me from 
sending b43legacy to John. I originally intended to use my hack only while debugging, but when no 
fix was coming, I decided that an awful patch would probably get some action. We'll see, 
particularly now that my deep/dark secret is exposed. ;-)

Larry
