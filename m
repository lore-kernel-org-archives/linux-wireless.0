Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55384 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LESOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 13:14:46 -0500
Received: by vcbfk14 with SMTP id fk14so4169401vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2011 10:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALSq=BbAG_aJ=p10cHdmQVYTMpfdRwf6sTPEAaFrrrDJCmNW4Q@mail.gmail.com>
References: <1320918297-1799-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4EBBA1C4.3070007@openwrt.org> <4EBBF90A.2000808@openwrt.org> <CALSq=BbAG_aJ=p10cHdmQVYTMpfdRwf6sTPEAaFrrrDJCmNW4Q@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 5 Dec 2011 10:14:25 -0800
Message-ID: <CALSq=Bau2P5+==m9Se7XjuXqgPJNwBNeY04mS3d6ACdU3zRTkA@mail.gmail.com> (sfid-20111205_191450_286108_6E21CE7C)
Subject: Fwd: [PATCH v2 4/4] ath9k_hw: Fix tx power settings for AR9003
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reiterating that the l-w filter is really dumb. It should selectively
block PATCH mails (and not responses to them).

See below.

---------- Forwarded message ----------
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, Dec 5, 2011 at 10:09 AM
Subject: Re: [PATCH v2 4/4] ath9k_hw: Fix tx power settings for AR9003
To: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
linville@tuxdriver.com, linux-wireless@vger.kernel.org, Paul Stewart
<pstew@google.com>, Adrian Chadd <adrian.chadd@gmail.com>


On Thu, Nov 10, 2011 at 8:17 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>
>>>  In the FCC rulings, only transmissions that are completely non-coherent, are
>>>  allowed to waive the array gain contribution to EIRP for multi-transmit configurations.
>>>  The use of 2-stream with 2 transmit and use of 3-steam with 3 transmit qualifies
>>>  for this spatial multiplexing MIMO classification as long as the streams are
>>>  directly mapped to each radio (not Walsh spread prior to splitting to multiple radios)


Hi Rajkumar, Felix, etc.,

There are 2 (or more) different power limits in play here. In
particular, the transmit cards have a maximum power output (for
example, 50 mW), and the local regulatory body has a maximum EIRP
(say, 1 W for 2.4 GHz in US, maybe 200 mW, maybe 50 mW).

I understand the comment above about the FCC regulations, but maybe we
should only disable spreading if we're too close (within 3 dB for 2
antennas, 4.77 dB for 3 antennas) to the regulatory limit?  In other
words, we should compute the actual EIRP with and without spreading
and ensure that the EIRP is over the local regulatory limits before we
disable this feature.

This calculation necessarily includes an estimation of the antenna
gain; probably the 5 dBi 2.4 GHz and 2 dBi 5 GHz is good enough, we
could be conservative if necessary. Note that we're already giving
responsibility to the user in the event that she has hacked together
an EIRP-requirement-violating directional antenna ;).

[We should only bother if Walsh spreading helps performance. I think
this is true because it enables each TX chain to transmit slightly
more power and still meet transmit tolerances, but I might be wrong!]

Thanks,
Dan
