Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37708
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXHFVfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:35:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC V2] bcm43xx-mac80211: Add TX power set file to debugfs
Date: Mon, 6 Aug 2007 23:35:14 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <46b78ac2.M4X/XQ9LXYHUe/aO%Larry.Finger@lwfinger.net> <200708062307.40590.mb@bu3sch.de> <46B791EF.7000105@lwfinger.net>
In-Reply-To: <46B791EF.7000105@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708062335.14693.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 August 2007 23:26:07 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > No, why do you poke with this at all.
> > This completely breaks power adjustment from mac80211.
> > Simply don't touch bcm43xx_dev_config :)
> > 
> 
> The problem is that mac80211 never seems to do any power adjustment. The funny 0x1b value for power 
> level that I wondered about earlier is coming from a value of 27 dBm that is set in 
> net/mac80211/regdomain.c, and conf->power_level doesn't get any information from anywhere else that 
> I see.
> 
> Do you know how to get mac80211 to change what it is sending to us?

I think we have an ioctl.
But it's probably the task of the rc algorithm to adjust power.

-- 
Greetings Michael.
