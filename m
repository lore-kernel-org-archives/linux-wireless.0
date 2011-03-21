Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49243 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab1CUPYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:24:22 -0400
Received: by mail-wy0-f178.google.com with SMTP id 26so5264920wyj.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 08:24:19 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Fix potential incorrect band in rx-status
From: Luciano Coelho <coelho@ti.com>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300713823.2593.203.camel@cumari>
References: <1299744103-11077-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1300713823.2593.203.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 17:07:26 +0200
Message-ID: <1300720046.2593.232.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 15:23 +0200, Luciano Coelho wrote:
> On Thu, 2011-03-10 at 10:01 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The rx-status passed to mac80211 along with each received frame
> > contains the
> > band on which the frame was received. Under certain circumstances,
> > this band
> > information may be incorrect, causing in worst case a WARNING from
> > mac80211,
> > and causes the received frame to be dropped.
> > 
> > This scenario mainly occurs when performing connected-mode scans, when
> > the
> > received scan results are from the other band than the one currentl
> > associated to.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com> 
> 
> Looks good, thanks!
> 
> Reviewed-by: Luciano Coelho <coelho@ti.com>
> 
> Applied to wl12xx/master with a small s/currentl/currently/ ;)

Ahm, there was a compilation problem with this on my tree.  The
following line had to be changed as well:

-	status->freq = ieee80211_channel_to_frequency(desc->channel, desc_band);
+	status->freq = ieee80211_channel_to_frequency(desc->channel,
+						      status->band);

Fixed the patch and reapplied.

-- 
Cheers,
Luca.

