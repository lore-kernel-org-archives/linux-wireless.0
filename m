Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:47364 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXK0Ao3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 19:44:29 -0500
Received: by py-out-1112.google.com with SMTP id u77so1812546pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 16:44:28 -0800 (PST)
Message-ID: <43e72e890711261644qede40d4ga6dd4c0ff31d499c@mail.gmail.com> (sfid-20071127_004434_614633_2E8173FF)
Date: Mon, 26 Nov 2007 19:44:26 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: ath5k signal/noise fixes
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 5:52 AM, Bruno Randolf <bruno@thinktube.com> wrote:
>
> hello!
>
> the next 3 patches contain fixes for the signal/noise level calibration and
> reporting of ath5k.  i split them up because i'm not 100% sure of the second
> two.
>
>   1) fixes the reading of the noise floor register and puts it into one function.
>
>   2) also enables noise floor calibration for rf511x.
>
>   3) saves the read noise floor and exports signal/noise and "quality" to
>   mac80211/wext.
>
> i'm also not sure if what we call noise calibration in this case really is an
> calibration or just a reading of the values?
>
> is ath5k_hw the right place to store the noise_floor?
>
> the values reported, especially the noise seems a bit high, it's around -77 in
> the A bands and around -92 in G bands (thats with an AR5215/RF5111/2111), so we
> might have some more tweaking to do. since i add the RSSI to get the signal
> quality in dBm it seems a bit too high too.
>
> this comment from madwifi leads me to believe this is the correct thing to do:
>
>  * rx_rssi is in units of dbm above the noise floor.  This value
>  * is measured during the preamble and PLCP; i.e. with the initial
>  * 4us of detection.  The noise floor is typically a consistent
>  * -96dBm absolute power in a 20MHz channel
>
> at least we have some values to play with now :)
>
> ah, and they are based on my last debugging and logging, patches (although
> there are not huge dependencies).

I should have read this first :), sorry I had missed it.

  Luis.
