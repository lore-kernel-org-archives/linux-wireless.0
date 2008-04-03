Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49988 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbYDCSFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 14:05:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JhTo6-0001q2-EW
	for linux-wireless@vger.kernel.org; Thu, 03 Apr 2008 18:05:02 +0000
Received: from 78-23-171-221.access.telenet.be ([78.23.171.221])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 18:05:02 +0000
Received: from fhimpe by 78-23-171-221.access.telenet.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 18:05:02 +0000
To: linux-wireless@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: [REGRESSION] BCM4306 cannot associate with any version of b43
 driver
Date: Thu, 3 Apr 2008 17:47:02 +0000 (UTC)
Message-ID: <pan.2008.04.03.17.47.01@telenet.be> (sfid-20080403_190513_049168_93EA31E0)
References: <200804031115.52596.ace@staticwave.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 Apr 2008 11:15:52 -0400, Gabriel A. Devenyi wrote:

> I feel I have to escalate this regression to the mailing lists because
> I've had no response on the kernel bugzilla from quite some time now.
> 
> With the release of the b43 driver, my card can no longer associate with
> its AP. I've been testing with 2.6.24 and the wireless-git tree hoping
> that someone would fix it, but I've had no requests for testing and no
> response.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9987

Is your AP using channel 13 or something like that by any chance?
Then you'll need to load mac80211 with the option ieee80211_regdom=64 to 
make this work. Add

options mac80211 ieee80211_regdom=64

to modprobe.conf and reload the mac80211 module.

-- 
Frederik Himpe

