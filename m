Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19817 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbYCSTxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: convert RSSI to a direct command
Date: Wed, 19 Mar 2008 16:14:16 +0100
References: <200803181342.42704.hs4233@mail.mn-solutions.de> <1205937089.26119.20.camel@localhost.localdomain>
In-Reply-To: <1205937089.26119.20.camel@localhost.localdomain>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803191614.16402.hs4233@mail.mn-solutions.de> (sfid-20080319_195441_992048_BC4146A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> We do need a qual.level for adhoc though.

Hmm, I don't have really knowledge about ADHOC. If it is only

> We should be reporting 100% signal strength there or something.

then the code for this would probably be something like

       if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate
           && !lbs_ssid_cmp(priv->curbssparams.ssid,
                            priv->curbssparams.ssid_len,
                            bss->ssid, bss->ssid_len)) {
               iwe.u.qual.level = 100;
       }

If you think about something different or more complex, it would 
be cool if you could help me a bit more :-)


> Second, we really should be reporting the noise for scan
> results, _not_ the default noise value.  We certainly can get
> the noise results averaged from past beacons, providing those
> beacons are recent.  That was probably the intent of the
> beacon averaging stuff.  I might have been a bit too hasty in
> suggesting its removal.

We don't have a noise value for scan results. There is only an 
RSSI field in the scan result.

Yes, the GET_RSSI command would give us the noise of received 
baecon. *BUT* only for the beacons from the current associated 
access point. This has two problems:
* we might not be associated to an AP
* the noise level reported from an associated AP at channel 1 
might be very wrong to report the noise level of a scanned AP on 
channel 13.


Using averaged noise is useless for other reasons:

* in the case of a moving station the driver doesn't know if the 
old data that is used for the average is from the same location 
or if the device moved
* the age of the averaged data has not been taken into account.
* and here again driver ignored the fact that noise can be 
different on different channels.


So if we don't (1) have noise value for scanning, (2) can't 
really average it and (3) you don't to report a default value, 
then we can simply turn of the reporting of the noise:

- iwe.u.qual.updated = IW_QUAL_ALL_UPDATED;
+ iwe.u.qual.updated = IW_QUAL_QUAL_UPDATED |
+                      IW_QUAL_LEVEL_UPDATED;

"iwlist eth1 scan" then no longer reports the noise.
