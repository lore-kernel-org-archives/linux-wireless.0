Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:42781 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab3HOJjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 05:39:20 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Christian Gagneraud <chgans@gna.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Switching band of a dual-band WiFi device
Date: Thu, 15 Aug 2013 10:03:14 +0100
Message-ID: <1483073.ZnhDhG6Z68@f17simon> (sfid-20130815_113934_139739_3F3EA851)
In-Reply-To: <520C631F.6010806@gna.org>
References: <520C631F.6010806@gna.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5628300.acKoguF54f"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart5628300.acKoguF54f
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 15 August 2013 17:11:59 Christian Gagneraud wrote:
> Hi there,
> 
> I am using a TP-Link TL-WDN3200 on a ubuntu 13.04 (kernel 
> 3.8.0-27-generic), and I have install relevant modules with 
> backports-3.11-rc3-1.
> 
> I would like to switch my WiFi stick to 5GHz, I tried iwconfig wlan0 
> freq 5G, but I get ENOTSUPP.
> Is the freq settings suppose to handle this 2.4 vs 5GHz band or is it 
> only for selecting channel frequency within a given band?
> 
> Does linux-wireless provides a way for selecting 2.4 or 5GHz band?

Linux should automatically select the right frequency band, depending on
the frequencies in use by the device you're trying to communicate with.
Connect to an AP in the 5GHz band, and Linux should just use 5GHz
automatically.
> 
> "iw phy phy11 info" tells me that in band 2, all the frequencies are 
> disabled except:
>                          * 5745 MHz [149] (30.0 dBm)
>                          * 5755 MHz [151] (30.0 dBm)
>                          * 5765 MHz [153] (30.0 dBm)
>                          * 5775 MHz [155] (30.0 dBm)
>                          * 5785 MHz [157] (30.0 dBm)
>                          * 5795 MHz [159] (30.0 dBm)
>                          * 5805 MHz [161] (30.0 dBm)
>                          * 5825 MHz [165] (30.0 dBm)
> 
That's showing you that, with Linux's understanding of the RF regulations in
your area, it can only transmit on certain frequencies.

> As well, my understanding of WiFi might be a bit limited but, does a 
> dual-band WiFi device provides 2.4 and 5GHz services at the same time or 
> do I need to select one or the other myself? Or maybe I can just 
> enable/disable them manually (and separately)?
> 
A dual-band WiFi device can only transmit and receive on one channel at a
time. The advantage of dual-band is that it can transmit and receive on either
the 5GHz band (which is less crowded), or the 2.4GHz band (which is more
commonly used). There's no need to select the band manually - it will just
use 5GHz when the other device (e.g. the AP) is using 5GHz.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart5628300.acKoguF54f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJSDJlVAAoJELb1E1yQPsc0NLwIAKvi5lnjWJy4nwA+NNiy77JC
wy/to2F2+lluP3Ayu4lmHh7FSZuCXJGSloBBBc/It56bCa7SMJd098GLqxg9iSjs
i+R3Mops/x6JHZzog2xUiriH0csk0f/61bJwm481ONlPHQJ4oKVTzbf/8wcwMW+p
ekwyuB+HaIQ+WpeGVrFo8hOnRZ/eBDP9R3GEnN2WGx5/y8GDJIFrLrBJ10UgXAXA
lHSOuU8gdcO/RVqP1rwAw0lpiXcoYEc8sWWlO4kFjAvuoZyG9Y+9VzFi+4k3O/d1
awHXZpl4rpSIn+psJkDZf2ogZA2P57BRDAbbPlxd+sZqC3v9rH7c+tzlVULD6f0=
=X/jU
-----END PGP SIGNATURE-----

--nextPart5628300.acKoguF54f--

