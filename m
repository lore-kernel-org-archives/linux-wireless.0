Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37815 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaE1OCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:02:35 -0400
Message-ID: <1401285737.8146.21.camel@jlt4.sipsolutions.net> (sfid-20140528_160238_992635_5508BEDF)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea.merello@gmail.com
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Date: Wed, 28 May 2014 16:02:17 +0200
In-Reply-To: <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com> (sfid-20140526_135345_142220_CC6E431E)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 <1400509775.4273.8.camel@jlt4.sipsolutions.net>
	 <1400510950.4273.9.camel@jlt4.sipsolutions.net>
	 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
	 <1400515344.4273.19.camel@jlt4.sipsolutions.net>
	 <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
	 <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com>
	 (sfid-20140526_135345_142220_CC6E431E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrea,

> Unfortunately it seems it does the same as mine..

Ok ... fair enough.

> If this is not the case (no one knowns/tells) IMHO the two choice are:
> - do what we said: parse beacons to extract channel information (and
> let monitor mode stay as it is)

Probably the best course of action for now. I'd make this conditional on
receiving probe response/beacon, there should be helper functions for
most of this. Since the chip is 2.4 GHz only you also don't have any
problems with band selection stuff.

> - do more investigation trying to fix also monitor mode issue.

That could be done as a follow-up, I guess.

> I could do some work on this (including opening the dongle to see if I
> can put HW probes on the RF chip, to see on with frequency the FW
> tunes it when scan commands are sent).
> 
> Also AFAIK there is a new firmware in the off-tree Atmel driver, that
> AFAIK also support WPA.
> If this turns out to be true, then I'm tempted to rework the driver
> for using it (hoping the the scan command works better on it).
> 
> FYI :
> Honestly I'm unsure if it's worth to do these last things:

Whatever you want to do :-)

johannes

