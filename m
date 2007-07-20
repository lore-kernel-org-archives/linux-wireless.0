Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:54692 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936829AbXGTUlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 16:41:35 -0400
Message-ID: <46A11DF4.5090307@lwfinger.net>
Date: Fri, 20 Jul 2007 15:41:24 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Pavel Roskin <proski@gnu.org>, Ehud Gavron <gavron@Wetwork.Net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
References: <46963C0F.3080104@lwfinger.net> <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte> <46A01209.4030200@lwfinger.net> <1184906596.9511.42.camel@dv> <20070720134425.GC7428@tuxdriver.com> <1184947521.1962.15.camel@dv> <46A0E3F2.5080209@Wetwork.Net> <1184954268.1962.43.camel@dv> <20070720180558.GG7428@tuxdriver.com>
In-Reply-To: <20070720180558.GG7428@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> ACK...fwiw, I like the "b43" name suggestion.  I wonder if that is
> too prone to confusion w/ "b44"?  Probably no worse than "ixgb" vs
> "cxgb3" or "e100" vs "e1000" I suppose.

Today's discussion was very useful for me - I picked up two suggestions that I have or will be 
putting into the code.

1. The drivers that use V3 firmware will get a default fwpostfix value of ".fw3". If the resulting 
name fails, it will fallback to a blank value for fwpostfix. Of course, if a value is supplied, it 
will override the default.

2. Any b-only driver will contain an alternate PCI ID table that can be selected by using the 
appropriate module option (not yet named). If that option is selected, the driver will load a 
combined b/g table of ID's. This way, it will be easy to supply a work-around for any user that 
cannot get the default 802.11g driver to work. In addition, this fix will not require mucking with 
rc.local.

Larry

