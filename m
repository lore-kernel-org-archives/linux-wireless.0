Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:51261 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYGAKnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:43:41 -0400
Received: by ik-out-1112.google.com with SMTP id c28so880323ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:43:40 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Tue, 1 Jul 2008 12:47:57 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg>
In-Reply-To: <1214907990.7763.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807011247.57739.IvDoorn@gmail.com> (sfid-20080701_124344_988121_63ACA7F2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Is there any way to get rt61 to report the receive timestamp? That would
> be very useful for monitor mode and good for IBSS.

The specsheets say nothing about TSF timestamps anywhere else then
the registers (which is accessed by the get_tsf() callback function).
To be more exact, the specsheets say _nothing_ about the RXD descriptors at all,
which means they are not helpful for that. ;)

However there are a few RXD fields which are labeled as "reserved" which could
mean the field is present, just not documented.

You could try printing the values of those words to see if they contain valid data,
and to be more exact the TSF data (this can be done in the function rt61pci_fill_rxdone(...))
The undocumented/reserved words are: 6 to 15

Do you want me to come up with a patch for this?

Note that these undocumented fields only are present in rt2500pci and rt61pci.
Neither rt2500usb or rt73usb contain them, which means that they can't report the TSF
based on descriptor information.

Ivo
