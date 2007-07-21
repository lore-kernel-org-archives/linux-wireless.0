Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37049
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762609AbXGUMuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 08:50:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Date: Sat, 21 Jul 2007 14:50:09 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	Ehud Gavron <gavron@wetwork.net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Jeff Garzik <jeff@garzik.org>
References: <46963C0F.3080104@lwfinger.net> <20070720180558.GG7428@tuxdriver.com> <46A11DF4.5090307@lwfinger.net>
In-Reply-To: <46A11DF4.5090307@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707211450.10270.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 July 2007 22:41, Larry Finger wrote:
> John W. Linville wrote:
> > 
> > ACK...fwiw, I like the "b43" name suggestion.  I wonder if that is
> > too prone to confusion w/ "b44"?  Probably no worse than "ixgb" vs
> > "cxgb3" or "e100" vs "e1000" I suppose.
> 
> Today's discussion was very useful for me - I picked up two suggestions that I have or will be 
> putting into the code.
> 
> 1. The drivers that use V3 firmware will get a default fwpostfix value of ".fw3". If the resulting 
> name fails, it will fallback to a blank value for fwpostfix. Of course, if a value is supplied, it 
> will override the default.
> 
> 2. Any b-only driver will contain an alternate PCI ID table that can be selected by using the 
> appropriate module option (not yet named). If that option is selected, the driver will load a 
> combined b/g table of ID's. This way, it will be easy to supply a work-around for any user that 
> cannot get the default 802.11g driver to work. In addition, this fix will not require mucking with 
> rc.local.

No, don't go the way to make the PCI table selectable by a Kconfig
or even worse a dynamic module option.
That is _really_ confusing and I really hope everyone upstream
rejects such patches.
Either a driver does support some hardware, or it doesn't. There
is no step inbetween.
If bcm43xx-mac80211 for G is not ready for merge, yet, don't strip
the IDs from bcm43xx. If bcm43xx-mac80211 for G is ready for production,
remove them.
