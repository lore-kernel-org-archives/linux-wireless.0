Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:36602 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbYEBVsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 17:48:33 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1063685fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 14:48:31 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
Date: Fri, 2 May 2008 23:53:46 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805022141.28351.IvDoorn@gmail.com> <1209762178.3608.21.camel@johannes.berg> <200805022328.00185.IvDoorn@gmail.com>
In-Reply-To: <200805022328.00185.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805022353.47018.IvDoorn@gmail.com> (sfid-20080502_234811_421602_616121EC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> *however* with the "reserved" descriptor field added to the tail of the frame,
> made the device come to live again. The rx_handlers_drop counter now stays at the
> usual level of 3, and pings are getting through.
> I haven't checked if the descriptor field actually contains any data, but then again
> mac80211 doesn't check the value either (with WEP anyway). ;)
> So either the descriptor field is indeed the ICV,
> or just appending 4 random bytes at the end of the frame did the trick.
> Somehow I think the second idea has the highest probability. :S

Hmm, looking at the data coming from the hardware,
one would really think the third column looks random enough
to have something to do with encryption. ;)

RX: 00744ef3 00000000 511beb8f
RX: 00bc6056 00000000 9ba5d723
RX: 00384c30 00000000 32f2d121
RX: 00a57027 00000000 9278a11c
RX: 008ff83d 00000000 8f9cd735
RX: 00c4d0a6 00000000 efa740b8
RX: 00dbe43e 00000000 0383ed8d
RX: 00d3b2cd 00000000 367d1648
RX: 00029e40 00000000 de4c3589
RX: 00a1cea7 00000000 825a88cc
RX: 006d325c 00000000 e1f7be5d
RX: 00ca0a8b 00000000 32165233
RX: 003a6811 00000000 635ab7db
RX: 00c7224c 00000000 9d19d071
RX: 009992c5 00000000 577bc5e3
RX: 0059da01 00000000 c2a4e66e
RX: 00ff7459 00000000 f3c6e38b
RX: 00d1b68f 00000000 511beb8f
RX: 00073a8a 00000000 e1f7be5d

Ivo
