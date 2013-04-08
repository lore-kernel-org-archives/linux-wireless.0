Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54213 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113Ab3DHTQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 15:16:55 -0400
Received: by mail-wi0-f178.google.com with SMTP id ez12so2919362wid.17
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 12:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomtFvXuQtj-Kxs5QPcptO-QWsySkTEzWTC1XzG1zdbU2g@mail.gmail.com>
References: <loom.20130403T092722-24@post.gmane.org>
	<CAJ-Vmomn8A77jEvR2c312QukWy7Zozs4T2NQuiYMForr5+DthQ@mail.gmail.com>
	<515E9D1F.8000701@gmail.com>
	<CAJ-Vmok__=unaWchTzB6_ExM+P_krc4MmMNJ-9C-=We9NUGjGQ@mail.gmail.com>
	<CAMqNPvLAea9N2eSjkNo7s-4aNFoQMfkSDesTxfZFSiNWXdHB2w@mail.gmail.com>
	<CAJ-Vmoko0UOztAy2coQ2+XCqqiiPZN-6=mssCb1+5gFPwDBAdw@mail.gmail.com>
	<51614F9E.9010109@gmail.com>
	<CAJ-VmomtFvXuQtj-Kxs5QPcptO-QWsySkTEzWTC1XzG1zdbU2g@mail.gmail.com>
Date: Mon, 8 Apr 2013 12:16:53 -0700
Message-ID: <CAJ-VmonzdV5fVx1Ha_4PiZPt9yhLmMkpociYvqUO=0JYU7-L5g@mail.gmail.com> (sfid-20130408_211700_105649_DFEE3B64)
Subject: Re: [ath5k][802.11p] Deactivate beacon
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?Ricardo_Tub=EDo_Pardavila?= <rtpardavila@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. here's what Monthadar has put together thus far:

https://wiki.freebsd.org/802.11p

The two interesting bits:

1) reset within two TU;
2) timing: 'From amendment: "When a STA transmits the Timing
Advertisement frame, the Timestamp shall be set to the value of the
STA’s TSF timer at the time that the data symbol containing the first
bit of the Timestamp is transmitted to the PHY plus the transmitting
STA’s delays through its local PHY from the MAC-PHY interface to its
interface with the WM [e.g., antenna, light emitting diode (LED)
emission surface]'

Are these still required in 802.11-2012? If so, that's going to be fun to meet:

* Ar9380 and later have what I believe is supported and tested
fast-channel-change within a single band (ie, 5GHz-5GHz changes, but
not 5->2 or 2->5 changes) so that should be met.
* .. but the timing advertisement frame is going to be fun to meet. I
don't think Atheros hardware supports that out of the box. So we may
not be able to meet that requirement.

Hm! I'll ask around internally and see what people think.

But the rest of 802.11p is definitely doable.

Grr, these people defining standards that requires the MAC and PHY to
inject crap into the stream.. making things non backwards compatible.
Sigh.


Adrian
