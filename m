Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYIQPgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 11:36:43 -0400
Date: Wed, 17 Sep 2008 12:36:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Carlos Corbacho <carlos@strangeworlds.co.uk>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080917153637.GD5186@khazad-dum.debian.net> (sfid-20080917_173648_185543_ECD829D7)
References: <48CFC03A.8020708@lwfinger.net> <48D0095B.40403@lwfinger.net> <20080916233240.GA18574@srcf.ucam.org> <200809171622.55882.mb@bu3sch.de> <20080917145007.GA5186@khazad-dum.debian.net> <48D1221B.1000601@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48D1221B.1000601@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Sep 2008, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > He means rfkill_force_state() should change the LED state in the process,
> > which it isn't doing.
> > 
> > It is an one-line patch, I am testing it now.
> 
> If your one-line patch fixes my regression, then I'll ACK it for 2.6.27.

Sorry, it can't fix that regression by itself, since b43 is not using
rfkill_force_state() in mainline.

It will fix the same issue you are experiencing on b43 in anything that uses
rfkill_force_state(), which means (for mainline): iwlwifi, rt2x00,
thinkpad-acpi and hp-wmi.

It is a regression only on b43 and thinkpad-acpi, as the other drivers above
didn't use rfkill_force_state() in 2.6.26.

To fix the regression in b43, you'd be faced with the need of both my simple
patch AND Matthew's more complex one.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
