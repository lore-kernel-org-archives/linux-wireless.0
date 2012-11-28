Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2K1MnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:43:12 -0500
Message-ID: <1354106616.9345.13.camel@jlt4.sipsolutions.net> (sfid-20121128_134316_136924_969C54C1)
Subject: Re: [RFC 1/3] nl80211: add spec scan flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 28 Nov 2012 13:43:36 +0100
In-Reply-To: <1354106128.9345.6.camel@jlt4.sipsolutions.net> (sfid-20121128_133513_369326_2A721201)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354106128.9345.6.camel@jlt4.sipsolutions.net>
	 (sfid-20121128_133513_369326_2A721201)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 13:35 +0100, Johannes Berg wrote:
> On Tue, 2012-11-27 at 20:01 +0100, Simon Wunderlich wrote:
> > This flag indicates that a spectrum scan is requested, if supported.
> 
> That "if supported" here is pretty problematic. There's no way to know.
> Feature flag maybe?
> 
> Also, there are scan flags now. However, I don't see that this should
> (ab)use the scan function. It doesn't seem likely that you want to do
> this while you're sending probe requests, etc. OTOH, it seems likely
> you'd want identical dwell times on all channels to have comparable
> values, which isn't the case here.
> 
> I really think you need to decouple the API for this from scanning.

And then you can also define APIs to get the data out. While I realize
that the data is implementation-dependent, you could have an enum that
indicates the data format and describes it:

@NL80211_SPECTRAL_DATA_ATHEROS: u8 rssi,ext_rssi,noise,fft_data[] ...

enum nl80211_spectral_data {
	NL80211_SPECTRAL_DATA_ATHEROS,
	...
};

Then you can define a function to send the data to the userspace socket
that asked for it (yes, if you have a separate command you can send it
only to that app... wohoo! :P ) and don't even have to store it in the
kernel...

So bottom line is that I think there are two choices:
1) for a proof of concept, implement it in debugfs only, in ath9k only,
   with e.g. a debugfs file that sets a flag that then triggers the
   spectral scan when you do a scan (using sw_scan_start, config hooks)
   --> no need to modify nl80211 at all
2) implement some well-defined API in nl80211, but don't tie it to
   scanning or a debugfs implementation of getting the data out, with
   versioning of the FFT data packets etc. so it can be updated later
   without breaking everything

This hybrid isn't a good approach at all.

johannes

