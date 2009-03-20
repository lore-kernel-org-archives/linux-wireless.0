Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:33845 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbZCTU7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 16:59:44 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Alina Friedrichsen" <x-alina@gmx.net>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's otus)
Date: Fri, 20 Mar 2009 21:59:41 +0100
Cc: linux-wireless@vger.kernel.org,
	otus-devel@lists.madwifi-project.org, greg@kroah.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170408.12626.chunkeey@web.de> <200903202036.09255.chunkeey@web.de> <20090320200736.261050@gmx.net>
In-Reply-To: <20090320200736.261050@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903202159.41613.chunkeey@web.de> (sfid-20090320_220013_584427_8158CBD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 21:07:36 Alina Friedrichsen wrote:
> Hello Christian!
Hello!

> > Based on the number of mails I got, this driver should be ready for
> > inclusion.
> 
> ACK
Good ;-)
 
> > So, this is probably the last RFC and the official patches will follow on
> > sunday (only if no one finds a bug that needs to be fixed ASAP.)
> 
> This is not same driver. Its much different, and I couldn't follow the changes in Johannes' git repository.
Well, the USB code was rewritten & "outsourced" into a separate module...
I did that because:
1. we might want to replace most of the "common" code with portions of ath9k.
    (no one, except Atheros' developers can really us with ANI/BC/HT/
    ABOLT/VAP etc. ;-) )

2. The otus driver talks about SPI devices. So maybe one day, we will need to
    add another frontend for the people with a handhelds or tablet with such a
    chip.

Now, what "changes" are you referring to?
Most of the qos, hw & rate control changes were already present in Johannes' tree.
And all I did was moving lines from other mac80211 driver around. :)
 
> Today, if have implement rate control (the needed ieee80211_tx_status_irqsafe() calls) for the original code. Now after one hour this code already outdated. :/
well, this "rate control" code was already part of the first RFC...
which was posted earlier this week?!

> In your code the implementation of it is not yet complete?
What's missing? Well, there is no BA (fail) & MCS rate report, true...
But under normal operation the rate should go up or down depending on the
current link quality.

However, please tell me about your idea. As my way of solving this issue
properly has some drawbacks (of course, I'm _fully_ aware of them)!

Regards,
	Chr
