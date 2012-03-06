Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41516 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab2CFTAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 14:00:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S4zcC-0006v0-2Q
	for linux-wireless@vger.kernel.org; Tue, 06 Mar 2012 20:00:04 +0100
Received: from 151.66.132.125 ([151.66.132.125])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 20:00:04 +0100
Received: from fschiava by 151.66.132.125 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 20:00:04 +0100
To: linux-wireless@vger.kernel.org
From: Francesco Saverio Schiavarelli <fschiava@libero.it>
Subject: brcm80211: brcmsmac not working on channel 13
Date: Tue, 06 Mar 2012 19:56:25 +0100
Message-ID: <jj5mkp$he9$1@dough.gmane.org> (sfid-20120306_200013_056354_0EA8E6F6)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

using my MacMini 4,1 integrated wireless adapter on kernel 3.2 and 
brcmsmac I cannot connect to AP on channel 13, other 2.4 GHz channels 
work fine.
When booting MacOsX with the same AP on channel 13 it works.

My distro is Debian and I tried to set country code via:
- iw reg set
- crda
- setting the AP to broadcast country code
but made no difference.

The very same issue with detailed symptoms is described here:

http://133nux.blogspot.com/2011/12/missing-channel-13-this-time-broadcom.html

I tried the fix proposed in the above page, basically in 
brcmsmac/channel.c struct locale_info change from 
LOCALE_RESTRICTED_SET_2G_SHORT to LOCALE_RESTRICTED_NONE.
To me this seems like a hack, but works. Can you please comment?

Is this a bug or the code was intented that way?
if the latter how am I supposed to use channel 13?

uname and lspci output follows:

> frankio@debmini:~$ uname -a
> Linux debmini 3.2.0-1-686-pae #1 SMP Fri Feb 17 06:27:21 UTC 2012 i686 GNU/Linux

> frankio@debmini:~$ lspci -v -d 14e4:4353
> 03:00.0 Network controller: Broadcom Corporation BCM43224 802.11a/b/g/n (rev 01)
> 	Subsystem: Apple Computer Inc. Device 0093
> 	Flags: bus master, fast devsel, latency 0, IRQ 21
> 	Memory at d3300000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: brcmsmac


thank you
Francesco


