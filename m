Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2K1QZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 11:25:53 -0500
Message-ID: <1354119974.9345.32.camel@jlt4.sipsolutions.net> (sfid-20121128_172556_583026_D4517449)
Subject: Re: [RFC 1/3] nl80211: add spec scan flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 28 Nov 2012 17:26:14 +0100
In-Reply-To: <20121128151916.GA6175@pandem0nium>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354106128.9345.6.camel@jlt4.sipsolutions.net>
	 <1354106616.9345.13.camel@jlt4.sipsolutions.net>
	 <20121128151916.GA6175@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > That "if supported" here is pretty problematic. There's no way to know.
> > > Feature flag maybe?
> 
> Hmm, I could certainly add a WIPHY_FLAG for that.

nl80211 feature flag would be better

> > > Also, there are scan flags now. However, I don't see that this should
> > > (ab)use the scan function. It doesn't seem likely that you want to do
> > > this while you're sending probe requests, etc. OTOH, it seems likely
> > > you'd want identical dwell times on all channels to have comparable
> > > values, which isn't the case here.
> 
> The times are not a big problem - at least for now, the spectral scan
> is only done for a very short time [tm] when the channel is changed.
> 
> The main reason why I wanted to use this function is that it can be used
> while operation, that is sending power save, forbidding payload tx, etc.

That's not an argument for using the scan API. That might be an argument
for piggy-backing on the scan *implementation*, but that's an orthogonal
issue. Note how I didn't comment on patch 2 -- I do think piggy-backing
on the scan implementation would be acceptable.

> > So bottom line is that I think there are two choices:
> > 1) for a proof of concept, implement it in debugfs only, in ath9k only,
> >    with e.g. a debugfs file that sets a flag that then triggers the
> >    spectral scan when you do a scan (using sw_scan_start, config hooks)
> >    --> no need to modify nl80211 at all
> 
> So the idea is something like:
>  * open debugfs-file (e.g. with cat)
>  * start scan "normally", without any flags
>  * read debugfs results, and close it
> 
> Mhm, this is definitely possible, although not too beautiful as well. :)
> 
> It seems there is no way to trigger a scan from within ath9k/debugfs, right?

No.

> sw_scan_start() is currently undefined in ath9k, but we could add that.
> By "config hooks" you mean the general config driver call to set the channel
> etc?

I meant to trigger the data collection there.

> I could also cycle channels within ath9k, but the main problem I see is that
> I can't turn off TX/go into power save mode from the driver, or would you see
> anything feasible? 

Triggering it all from the driver doesn't seem possible, no. You could
have the function take effect on the next scan, but it's still kinda
hybrid. However, it wouldn't "pollute" nl80211 that way.

> > 2) implement some well-defined API in nl80211, but don't tie it to
> >    scanning or a debugfs implementation of getting the data out, with
> >    versioning of the FFT data packets etc. so it can be updated later
> >    without breaking everything
> 
> I guess if we implement this in iw, this would be done similarly to scan,
> e.g. trigger the scan and wait on the socket for results? Or would we
> use events instead?
> 
> This would roughly mean:
>  * duplicate the mac80211 scan part for spectral scan to cycle channels/be quite
>    while doing this

No, I didn't say this. I said the API should be different, the
implementation in mac80211 could very well just be "either going to send
probes & wait, or collect spectral scan data and continue to the next
channel"

>  * duplicate iw scan (at least some parts), the interface could look very similar:
>    trigger scan, on receive scan results on another socket, wait for completion
>    (although iw still has this "warning, it's racy" thing inside. :] )

Actually you need a separate application anyway, to interpret the
results, so that application would
 * open a socket
 * send the spectral scan command
 * read the results on the socket

johannes

