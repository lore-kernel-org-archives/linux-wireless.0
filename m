Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EJH0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 03:26:25 -0400
Message-ID: <1368170776.8390.4.camel@jlt4.sipsolutions.net> (sfid-20130510_092628_886361_389FADDA)
Subject: Re: [PATCH 0/8] Add support for 5 and 10 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: a@pandem0nium.sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 10 May 2013 09:26:16 +0200
In-Reply-To: <1368123036-22721-1-git-send-email-a>
References: <1368123036-22721-1-git-send-email-a>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-09 at 20:10 +0200, a@pandem0nium wrote:

> Comments:
>  * Is there any special requirement for handling beacons? For example,
>    rates are halfed or quartered, but some rates could not be represented
>    in the rate IEs. For example, 2.25 mbit/s can not be represented as
>    multiple of 500 kbps.
>  * therefore, all rates are handled like the corresponding 20 MHz
> rates
>    internally, which makes a lot of things easier (no changes required
>    for rc-algos, beacon creation, etc...). We might consider adjusting
> the
>    output of rates for nl80211 or radiotap, though.

This seems completely wrong, since Clause 18 says:

        The OFDM system also provides a “half-clocked” operation using
        10 MHz channel spacings with data communications capabilities of
        3, 4.5, 6, 9, 12, 18, 24, and 27 Mb/s. The support of
        transmitting and receiving at data rates of 3, 6, and 12 Mb/s is
        mandatory when using 10 MHz channel spacing. The half-clocked
        operation doubles symbol times and clear channel assessment
        (CCA) times when using 10 MHz channel spacing. The regulatory
        requirements and information regarding use of this OFDM PHY are
        in Annex D and Annex E.

IOW, it treats the rates as actually the rate they should be. Besides,
what's so hard about rounding up? (8.4.2.4)

        and bits 6 to 0 are set to the data rate, if necessary rounded
        up to the next 500kb/s, in units of 500 kb/s.


I also think you really need to handle this. If you just want a hack for
5/10 MHz, you can put it into drivers' debugfs, if not, then it should
be done properly :-)

johannes

