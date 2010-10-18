Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:54489 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab0JRPM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 11:12:29 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9IFCRpD030597
	for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 18:12:27 +0300
Subject: Re: [PATCH v2] wl1271: Fix warning about unsupported RX rate
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287412289.20107.66.camel@chilepepper>
References: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1287412289.20107.66.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 18:12:09 +0300
Message-ID: <1287414729.20107.68.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-18 at 16:31 +0200, ext Luciano Coelho wrote:
> On Thu, 2010-10-14 at 11:00 +0200, Teemu Paasikivi wrote:
> > While scanning, it is possible that beacon and probe response frames are
> > received on other band than configured to the driver. In rx status
> > handling this has caused "Unsupported RX rate from HW" warnings. This
> > patch changes the wl1271_rate_to_index function to take the band of the
> > received frame as a parameter instead of using value configuret to
> > wl->band.
> > 
> > Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> > ---
> 
> Applied, thanks!

Hmmm... I'm now getting loads of these:

[  465.265594] wl1271: ERROR Unsupported RX rate from HW: 15

...when scanning with my beagle board.  I have also included the 11n
patches by Shahar and Ido's "optimizations and fixes".

Teemu, I had to merge your patch on top of Ido's and Shahar's patches.
Can you check your patch in the wl12xx/master tree and confirm that it
is okay? To me it looks good, but you never know ;)


-- 
Cheers,
Luca.

