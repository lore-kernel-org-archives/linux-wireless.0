Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51408 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765499Ab3DFTIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Apr 2013 15:08:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UOYG0-0003j3-JJ
	for linux-wireless@vger.kernel.org; Sat, 06 Apr 2013 20:54:32 +0200
Received: from static-65-129-225-77.ipcom.comunitel.net ([static-65-129-225-77.ipcom.comunitel.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 06 Apr 2013 20:54:32 +0200
Received: from rtpardavila by static-65-129-225-77.ipcom.comunitel.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 06 Apr 2013 20:54:32 +0200
To: linux-wireless@vger.kernel.org
From: Ricardo =?utf-8?b?VHViw61v?= <rtpardavila@gmail.com>
Subject: Re: [ath5k][802.11p] Deactivate beacon
Date: Fri, 5 Apr 2013 18:50:58 +0000 (UTC)
Message-ID: <loom.20130405T204912-602@post.gmane.org> (sfid-20130406_210858_176098_FBA6C767)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am now working with the GCDC v3 branch software and, after compiling it, I 
found that you still have to do some hacks on that code for it to work 
properly. I have made a couple of patches and, with that, I have achieved the 
following:

1) Full ITS band support (channels 176-184 @5.8-5.9 GHz).
2) iw tool modified for setting the beacon interval.
3) airemon-ng and aircrack utils support for the ITS band channels (by 
default, they do not support any channel above 120).

Currently, I am working on the following issues:

1) Packet injection support through 'aireplay-ng' by patching ath5k with the 
patches that I found on their website.
2) Bandwidth selection instead of turbo mode selection. For this, I am based 
my patch on the following patch submitted previously to the linux-networking 
group: http://thread.gmane.org/gmane.linux.kernel.wireless.general/59932

 I am testing all this and I have a network analyzer up to 6 GHz, so I can 
fully verified the integrity of the signal generated.

I would appreciate that anybody can provide me any support on these tasks.

