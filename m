Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49165 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbcJXOxj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:53:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Date: Mon, 24 Oct 2016 16:53:30 +0200
Message-ID: <3164753.QVH0CDzpbV@prime> (sfid-20161024_165343_975880_DDEF709D)
In-Reply-To: <1477319916.4085.29.camel@sipsolutions.net>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com> <4116422.yZP7iyh9mq@prime> <1477319916.4085.29.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1924920.4O7cC1z8Cr"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1924920.4O7cC1z8Cr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, October 24, 2016 4:38:36 PM CEST Johannes Berg wrote:
> On Mon, 2016-10-24 at 16:36 +0200, Simon Wunderlich wrote:
> > On Monday, October 24, 2016 4:16:02 PM CEST Johannes Berg wrote:
> > > On Mon, 2016-10-24 at 15:42 +0200, Simon Wunderlich wrote:
> > > > Otherwise, it would be pretty much impossible to perform CSAs to
> > > > another DFS channel.
> > > 
> > > I was told that to do that you'd need another NIC that's pre-
> > > CAC'ing another channel.
> > 
> > Here is the portion from ETSI 301 893 v1.8.1 [1] (the most recent one
> > to my knowledege), section 4.7.1.4 which describes operation from
> >
> > master devices (Access Points):
> > [...]
> 
> Yeah I'm pretty sure there are differences in ETSI vs. FCC. Perhaps the
> information I was told about was for FCC. But perhaps it's all just
> completely wrong :)

I think I've found the right specification [1] for FCC. They doesn't state so 
explicitly that it is allowed, but I don't see any remark that this behaviour 
is forbidden, either. The important section is 5.1.1 Master devices in 905462 
D02 UNII DFS Compliance Procedures New Rules v02, which is pretty similar to 
ETSI. They say:

<snip>
a)
The Master Device will use  DFS  in order to detect  Radar Waveforms with 
received signal strength above the DFS Detection Threshold in the 5250 - 5350
MHz and 5470 - 5725 MHz bands.  DFS is not required in the 5150 - 5250 MHz or 
5725 - 5825 MHz bands. 
b)
Before initiating a network on a Channel, the Master Device will perform a 
Channel Availability Check for a specified time duration (Channel Availability 
Check Time) to ensure that there is no radar system operating on the 
Channel, using DFS described under subsection a) above.
c) The  Master Device initiates a U-NII network by transmitting control 
signals that will enable other U-NII devices to Associate with the Master 
Device.
d)
During normal operation, the Master Device will monitor the Channel
(In-Service Monitoring) to ensure that there is no radar system operating on 
the Channel, using DFS described under a).
e)
If the Master Device has detected a Radar Waveform during In-Service 
Monitoring as described under d), the Operating Channel of the U-
NII network is no longer an Available Channel.  The Master Device will
instruct all associated Client Device(s) to stop transmitting on this 
Channel within the Channel Move Time. The transmissions  during  the 
Channel  Move  Time will be  limited  to  the  Channel  Closing Transmission 
Time. 
</snap>

Again, no explicit "on installation" here, but there is also nothing saying 
that we can not check/operate on other channels in the meantime. (NOTE: going 
off-channel while operating is a different topic).

Cheers,
     Simon

[1] https://apps.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?
switch=P&id=27155
--nextPart1924920.4O7cC1z8Cr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYDiBqAAoJEKEr45hCkp6hgAcQALWZ1E9Ro5Ms1vKgBobFqwWh
GyfJsyT5diGhinV89r8n6x9EwmndnQQZSrk9w9EuIFJclAi6cKW1v9G8BbohMmni
041TZdqqZ2FK5+AZVnT6JhHyHawfmAVeuAMD+PVzjCwz4ug16gSvq9Vgr2s8uxiF
DaIxgMQqW2yJw5PBhySHW920lnIU3s8ySPlNz5gjxMVbQyKMvQYkAWR3KP2bhIS4
lrBVvXyUPHdeFQERFbH1qq/C1vR4zxM4HQeMn11ASJW70E4bQKOlMpPbcPceLwWM
qbcQT7O0Id5skS7Zgtf6buKpc+yKtRUxcuxTL6KDc/2IAWEhvQKpyYKcaablqzMh
sMr8s236HifyXXyTQ9pJifVpL3Vox/SHn0MMB1XB/2uFEeajDEMFyNDywE0Cqz/s
prAu/s0w6ZU3FJ917tc8sOpwS2884TzanwkPOee5szQHMXQvznkSlJgD9X8VwS+t
fV1CYBEGYfg/LlscAbqjq9QHynbEB/SDc6HCJAaLXEhr7rCnfHN2J483cSxX7iba
KPKHp5XBJ5t4+jHdSDesLaZBeZC4DkmuYIHMyXVNjjYirNqnlie58+nEdDojqXpc
KkQwKkAcZ1uideh1gtB6qat96CuvTQeXbozlg4DFVVJfEzBuI+BesDZQ1R2jFxNL
kD9iSbvR/R/JIr3mewCU
=jib6
-----END PGP SIGNATURE-----

--nextPart1924920.4O7cC1z8Cr--
