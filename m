Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54386 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab1DTSDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 14:03:07 -0400
Received: by mail-ew0-f49.google.com with SMTP id 3so389204ewy.22
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 11:03:06 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: avoid redundant join on interface
 reconfiguration
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302020008-28018-1-git-send-email-eliad@wizery.com>
References: <1302020008-28018-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:05:34 +0300
Message-ID: <1303322734.1988.740.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 19:13 +0300, Eliad Peller wrote:
> ieee80211_reconfig() sets most of the "changed" flags regardless
> of the actual change (e.g. BSS_CHANGED_ASSOC will be set even if
> the interface is still not associated). in this case the driver
> will issue some unneeded commands.
> 
> Since the driver relies solely on the BSS_CHANGED_ASSOC flag,
> without checking if there was an actual change, it will end up
> issuing unjoin() and dummy_join() commands, although it was
> never associated and should just remain idle.
> 
> Avoid it by checking the actual state change, in addition to the
> "changed" flag.
> 
> (there seem to be more redundant configuration commands being
> issued, but they shouldn't harm)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Indeed, I have seen similar assumptions in the driver that caused
problems.  Thanks for the fix.

Applied.

-- 
Cheers,
Luca.

