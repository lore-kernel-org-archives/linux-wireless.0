Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48212 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZE1Q3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:29:10 -0400
Subject: Re: ath5k: works only occasionaly
From: Pavel Roskin <proski@gnu.org>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A1EAEA7.4070208@impulze.org>
References: <4A1EAEA7.4070208@impulze.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 12:29:10 -0400
Message-Id: <1243528150.20853.7.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-28 at 17:32 +0200, Daniel Mierswa wrote:
> i'm facing issues with ath5k and my laptop ever since i first installed
> it, linux 2.6.24 or somewhere around there.

The current kernel version is more important than the one you tried
initially.  Also, the chip revision from the kernel log may be useful.

> i get occasionaly associated and working wireless lan at home though any
> attempt to access public wifi (university/schools/cafes) results in
> "CTRL-EVENT-DISCONNECTED -- remove keys"

The reason for disconnect should be printed before that line.

>  or "noise floor calibration
> timeout" errors from wpa_supplicant

It must be from the driver, not from wpa_supplicant.

>  (don't worry i already tried every
> wpa_supplicant version from 0.6.1 to trunk, whereas the newer ones even
> with the -Dnl80211 option).

Using -Dwext or -Dnl80211 should have no effect on disconnects.

>  sometimes wpa_supplicant associates me but
> packets will just time out (dhcp, ping, etc) and it will disassociate me
> shortly after that attempt, also tried using nohwcrypt=1 as module
> parameter and different kernels (as of request in
> #linux-wireless/Freenode) which didn't cause any effect at all.
> as you can imagine it's hard to provide you with useful debug
> information right now, since i'm at home but i'm thankful for any
> suggestions and guides on how to give you more useful information than that.

If you can, try connecting to an access point with known good signal to
see if the problem is caused by low signal.

-- 
Regards,
Pavel Roskin
