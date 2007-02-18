Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:34044 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXBRVys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 16:54:48 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HItyE-0001tx-1R
	for linux-wireless@vger.kernel.org; Sun, 18 Feb 2007 16:53:22 -0500
Subject: Re: [PATCH] d80211: fix incorrect hw.priv setting in  ieee80211_alloc_hw()
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171707397.3487.5.camel@johannes.berg>
References: <20070217074208.348.69546.stgit@dv.roinet.com>
	 <1171707397.3487.5.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 16:54:45 -0500
Message-Id: <1171835685.2201.4.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-02-17 at 11:16 +0100, Johannes Berg wrote:
> On Sat, 2007-02-17 at 02:42 -0500, Pavel Roskin wrote:
> > hw.priv is set twice, and the second time it's set incorrectly to an
> > area relative to the master device, which wasn't allocated for private
> > data.
> 
> Yeah, this is obviously correct. Guess I was drinking when I did these
> patches. I really wonder why I never saw any of your problems though, I
> do have bcm43xx running here. Not that the driver actually does anything
> for me, it always refuses to associate...

Oh, and by the way, wouldn't it be reasonable to have an inline function
to calculate the pointer to the priv area instead of having an actual
field for the pointer?

Also, it looks like we need a generic macro for aligning sizes.

-- 
Regards,
Pavel Roskin

