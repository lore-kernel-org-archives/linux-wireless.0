Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbYCSTng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:36 -0400
Subject: Re: [PATCH] libertas: convert RSSI to a direct command
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803191614.16402.hs4233@mail.mn-solutions.de>
References: <200803181342.42704.hs4233@mail.mn-solutions.de>
	 <1205937089.26119.20.camel@localhost.localdomain>
	 <200803191614.16402.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 11:27:11 -0400
Message-Id: <1205940431.4169.10.camel@localhost.localdomain> (sfid-20080319_194447_532136_14852463)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-19 at 16:14 +0100, Holger Schurig wrote:
> > We do need a qual.level for adhoc though.
> 
> Hmm, I don't have really knowledge about ADHOC. If it is only

When there is no existing ad-hoc BSS with the requested SSID, a driver
should create an AdHoc BSS with that SSID.  It generates a random MAC
address (within a certain range of course) and begins to beacon for that
SSID.  If other stations join the ad-hoc BSS, the beaconing
responsibility is handed off between stations according to a certain
interval.

If there is an existing ad-hoc BSS with the requested SSID, the driver
joins the BSS by using the existing BSSID and joining the beacon pool.
Scan results for Ad-Hoc stations are actually received beacons that the
stations themselves are putting out.

> > We should be reporting 100% signal strength there or something.
> 
> then the code for this would probably be something like
> 
>        if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate
>            && !lbs_ssid_cmp(priv->curbssparams.ssid,
>                             priv->curbssparams.ssid_len,
>                             bss->ssid, bss->ssid_len)) {
>                iwe.u.qual.level = 100;
>        }
> 
> If you think about something different or more complex, it would 
> be cool if you could help me a bit more :-)

This is fine for now; but we should in the future track the SNR and NF
from received beacons for this BSS through GET_RSSI and if there is an
acceptable value for that, use it instead.

Otherwise we'll always report 100% for a BSS that we created even if
others have joined and we are not beaconing, because we don't know if
we've gotten beacons from other stations, because we're not tracking the
beacon average for the current BSS using GET_RSSI.

> 
> > Second, we really should be reporting the noise for scan
> > results, _not_ the default noise value.  We certainly can get
> > the noise results averaged from past beacons, providing those
> > beacons are recent.  That was probably the intent of the
> > beacon averaging stuff.  I might have been a bit too hasty in
> > suggesting its removal.
> 
> We don't have a noise value for scan results. There is only an 
> RSSI field in the scan result.

I know.

> Yes, the GET_RSSI command would give us the noise of received 
> baecon. *BUT* only for the beacons from the current associated 
> access point. This has two problems:
> * we might not be associated to an AP

Right, at which point we'd just use the default.

> * the noise level reported from an associated AP at channel 1 
> might be very wrong to report the noise level of a scanned AP on 
> channel 13.

True.  So I guess on the non-associated channel we'd use the default,
and you can just use the default for now.

> 
> Using averaged noise is useless for other reasons:
> 
> * in the case of a moving station the driver doesn't know if the 
> old data that is used for the average is from the same location 
> or if the device moved
> * the age of the averaged data has not been taken into account.
> * and here again driver ignored the fact that noise can be 
> different on different channels.

Well, the averaged noise should be a fairly quickly sliding window that
only takes the last few seconds (maybe 30?) into account.

> So if we don't (1) have noise value for scanning, (2) can't 
> really average it and (3) you don't to report a default value, 
> then we can simply turn of the reporting of the noise:
> 
> - iwe.u.qual.updated = IW_QUAL_ALL_UPDATED;
> + iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED |
> +                      IW_QUAL_LEVEL_UPDATED;
> 
> "iwlist eth1 scan" then no longer reports the noise.

Yeah, and then you've just screwed over userspace tools that want noise,
like NetworkManager.

---------

My main points were:

1) There are certainly bugs in the current code, no doubt

2) We need to fix the Ad-Hoc code to report signal strength somehow, and
that can only happen by GET_RSSI

3) We can do a lot better (at least on the current channel) for scan
results by using the windowed average of the beacons as reported by
GET_RSSI; this is less important than #2 though


My recommendations:

1) We do need to fix the Ad-Hoc bits somehow, I guess that means
periodically poking GET_RSSI when connected and averaging the result
over the last 30 seconds, weighting recent results more

2) Use the windowed average for 'iwconfig'/SIOCGIWSTATS, the Ad-Hoc scan
result, and scan results on the current channel

3) Use the default noise floor for all channels not the associated
channel

If you like, I'm interested in doing this.

Dan

