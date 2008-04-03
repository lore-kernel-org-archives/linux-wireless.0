Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:46045 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbYDCUyH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 16:54:07 -0400
Received: from peterson.fenrir.org.uk ([10.0.0.2])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JhWRi-00036Y-Hv
	for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 21:54:06 +0100
Date: Thu, 3 Apr 2008 21:54:06 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Re: [REGRESSION] BCM4306 cannot associate with any version of b43
 driver
Message-ID: <20080403215406.6fafe376@peterson.fenrir.org.uk> (sfid-20080403_215411_206840_ED6D4BF2)
In-Reply-To: <pan.2008.04.03.17.47.01@telenet.be>
References: <200804031115.52596.ace@staticwave.ca>
	<pan.2008.04.03.17.47.01@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Apr 2008 17:47:02 +0000 (UTC)
Frederik Himpe <fhimpe@telenet.be> wrote:

> On Thu, 03 Apr 2008 11:15:52 -0400, Gabriel A. Devenyi wrote:
> 
> > I feel I have to escalate this regression to the mailing lists because
> > I've had no response on the kernel bugzilla from quite some time now.
> > 
> > With the release of the b43 driver, my card can no longer associate with
> > its AP. I've been testing with 2.6.24 and the wireless-git tree hoping
> > that someone would fix it, but I've had no requests for testing and no
> > response.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9987
> 
> Is your AP using channel 13 or something like that by any chance?
> Then you'll need to load mac80211 with the option ieee80211_regdom=64 to 
> make this work. Add
> 
> options mac80211 ieee80211_regdom=64
> 
> to modprobe.conf and reload the mac80211 module.
> 

If it is a recent kernel (2.6.24) then this needs to be:

options cfg80211 ieee80211_regdom="JP"

instead.

I had a problem with the iwlwifi driver in this regard, my AP is on
channel 12. Scanning found it, but it wouldn't associate. The option
string above fixed it for me.

-- 

Brian Morrison

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it."
