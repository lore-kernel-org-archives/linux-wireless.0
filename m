Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33333 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbZAEUIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:08:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 12:08:12 -0800
Date: Mon, 5 Jan 2009 12:08:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Message-ID: <20090105200809.GH6834@tesla> (sfid-20090105_210817_729963_67768FBF)
References: <200901042021.10904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901042021.10904.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 11:21:10AM -0800, Ivo van Doorn wrote:
> rt2500pci and rt2500usb contain a special field in the EEPROM
> which indicates which regulatory domain the card belongs to.
> This code can easily be translated into a country code which
> we can send as alpha2 hint for CRDA.
> 
> Please note that most cards will have 0xffff as EEPROM value,
> and thus do not provide a regulatory hint through the EEPROM.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

I believe regulatory_hint() is being called before the ieee80211_register_hw()
call. This is not a requirement right now but I believe this should be the case
in the future as we want cfg80211 to keep track a few things for the driver, like
the regulatory domain it wants in case of conflicts with other drivers. I'm working
on this right now so just wanted to throw that out there.

Is it possible to move the regulatory_hint() to be used after ieee80211_register_hw()
is called?

  Luis
