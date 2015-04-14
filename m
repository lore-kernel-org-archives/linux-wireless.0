Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56944 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbbDNPNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:13:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Yi2X6-0000G0-C3
	for linux-wireless@vger.kernel.org; Tue, 14 Apr 2015 17:13:48 +0200
Message-ID: <1429024427.3019.18.camel@sipsolutions.net> (sfid-20150414_171353_232842_7E8DDE08)
Subject: Re: [RFC/RFT 00/11] mac80211: enable fast-xmit and some offloads
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 14 Apr 2015 17:13:47 +0200
In-Reply-To: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net> (sfid-20150414_170402_357343_42C8C498)
References: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150414_170402_357343_42C8C498)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-14 at 17:03 +0200, Johannes Berg wrote:
> First, add the TX fastpath ("fast-xmit") that I've been kicking around for
> a while. I'm pretty happy with the abstraction since it allows me to not
> have to worry about a lot of details in the regular TX path...
> 
> Secondly, I want to enable more offloads. So the first thing to do is to
> actually fix checksum offload - the TI driver has a bug in that if it fails
> to upload keys or so, checksums will be completely bogus.
> 
> So the first step to fix that bug is to enable checksum offload only on
> the fast-xmit path, while having a software fallback on the regular TX path
> to make software crypto etc. do the right thing. To not cause regressions
> for the TI/ath10k drivers, this requires extending fast-xmit to cover more
> cases, but that's easy.
> 
> Secondly then, we can add code to do in software what the driver might do,
> which is actually what the network stack does for us anyway today, but now
> we can do it only on the non-fast-xmit path so that the fast-xmit path can
> pass packets with required checksumming or segmentation to the device.
> 
> So far I've only tested the software fallbacks, not the actual hardware
> offloads.

Forgot to say - for those who do want to play with this, this is also
available in my mac80211-next tree in the fast-xmit branch.

johannes

