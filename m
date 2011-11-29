Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:25565 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab1K2Lwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 06:52:45 -0500
Message-ID: <4ED4C789.8060701@allnet.de> (sfid-20111129_125258_741403_289EEE8F)
Date: Tue, 29 Nov 2011 12:52:41 +0100
From: Daniel Golle <dgolle@allnet.de>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v1 0/3] support for antenna configuration profiles
References: <20111128161225.GA25430@localhost>	 (sfid-20111128_171757_078893_7ACF616B) <1322499145.4060.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322499145.4060.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Johannes,

On 11/28/2011 05:52 PM, Johannes Berg wrote:
> Can you remind us what it is you're trying to achieve? And why it can't
> be done with the antenna selection API today?
My idea is to have a generic API allowing the user to select configuration
profiles for external LNA/mixers found in outdoor high-power appliances.
I also first thought of just using the existing antenna selection API for that,
but there are good reasons against that:
* Antenna control API assumes that the allowed values for tx_ant and rx_ant are
independent of each other. In high-power applications, this is not the case
(i.e. you'll probably even damage the RX-part of your hardware when selecting
the same path for RX and TX). Therefore simple bitmasks such as
available_antennas_rx/tx won't do the job.
* Both, external mixer and antenna control may be used together in MiMo
applications, e.g. you may have antennas 0,1 which are controlled by the usual
antenna selection API and additionally you got an external LNA/mixer which
allows you to select either the built-in antenna-pair or an externally connected
one.
In my example, it looks like this

+---------+       +-------+
|         ---TXa---       |
| WiFi    ---RXa1--  ext. |
| Chip    ---RXa2--  LNA  |
|(AR9285) ......... mixer |
+---------+       +-------+

You may still want to use antenna selection API to selected either RX-path 0 or
1 or both of the AR9285, additionally you want to select a profile for the
external LNA/mixer.

* As Adrian pointed out and I agree with, it's nice to give the user some
information about the available configuration profiles, i.e. have user-parsable
names and descriptions of the different configuration profiles (e.g.
"built-in"/"external", "horizontal"/"vertical", ...) for the device.

My current solution how things are done in ath9k is specific for the AR9285, but
once there is a generic infrastructure for this in mac80211, it can be used for
different solutions, e.g. ath5k-devices with a similar setup which control the
ext.LNA/mixer using some GPIO PINs.
In future we may also see devices with several directional MiMo beams and we
want to select which one(s) to use.

I hope things are more clear now.


Cheers


Daniel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1MeFAAoJEDy9cKN/1Et0R14P/0boU8k9U1CHDJAQzLswT6aF
ts9gE0DLvC10qSu15sdRWH516T9K3sFeq2LlSYx4ljV6G3Y1lECzlJjuhFk15ZW+
5Q0dlofmEhmO3shdvODgrKcqIdmvDkxHRqlCXtYuEPsDKi3QWVEqj8nji588nORt
wCDGxdNEl8HJYmKi8R+OsAZcypCylV5HFo/J+Xt9pgQmP6gtqGkF3s+KwiPLDFo8
BnusiD2aQOgqbSs/63t+yaapGLi2ATwFjgKOE/5DywyKUHPGT6e/SouGnWHVuEfA
+Kq33fUm5C93VK9aBVg+hawj6LGB9DAizGlDaEUib4TVt6R23N5HaeOp4uI+T41K
pjz3jQD6CsTM8Ypo3UvsRI+SWvacNPcmRqJMplOL7sc9pkNx1UatP/wE2/pRPfki
X1t9Lw8cb6FIeRZAe+ftiDZN5TEvqOTXBMAYe4tsPMr/GZ/g5eubdZDiHVe0gkQ2
oIWFq8vnTX8UUP8jz0h4xkENsPoMHi6YwEFULIqdPfwEFqBXsxOCFPednZ5BU6ww
KO9CQpMWqDhDtGsp5jsaC5s1K2Mo7w2hmfwMZjxy+wudftL7oe25niqlJZsTBKa9
j72u+XwqXkf4wmsbbaPmDOI93mqBcgSPOUtaEz3RRZbi4EFFQUZA1+bX0SMdUHxD
8oTrNnbFvv7ow1T2oQfy
=I+el
-----END PGP SIGNATURE-----
