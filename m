Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:47642 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965522Ab2B1MGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 07:06:03 -0500
Received: by mail-lpp01m010-f45.google.com with SMTP id e6so1997244lah.32
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 04:06:01 -0800 (PST)
Message-ID: <1330430758.18637.42.camel@cumari> (sfid-20120228_130607_874371_9F750CBF)
Subject: Re: [PATCH 1/7] wl12xx: set the ELP entry delay to the FW dyn-ps
 timeout
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Feb 2012 14:05:58 +0200
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-28 at 00:41 +0200, Arik Nemtsov wrote: 
> With PSM handled in FW, the checks in wl1271_elp_work() are always true.
> Thus during active traffic we constantly enter and exit ELP (many times
> per second). As each ELP exit takes ~10ms, this can have an adverse
> effect on throughput and interactivity.
> Set the ELP timeout to the dyn-ps timeout. This period is longer and
> avoids the above problem. It also makes sense to stay out of ELP while
> we are awake on the network, to minimize delays in Tx/Rx. The same thing
> was done by the mac80211 dynamic-ps mechanism before the FW DPS changes.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied this whole series with the change from WARN_ON to WARN_ON_ONCE
on patch 3/7 and pushed.

Thanks, Arik!

-- 
Cheers,
Luca.

