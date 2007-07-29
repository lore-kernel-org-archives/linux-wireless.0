Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35100
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761770AbXG2Mic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 08:38:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Paul TBBle Hampson <Paul.Hampson@pobox.com>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Date: Sun, 29 Jul 2007 14:38:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <1185527932.14697.535.camel@pmac.infradead.org> <20070729115943.GA12631@keitarou>
In-Reply-To: <20070729115943.GA12631@keitarou>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707291438.20337.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 July 2007 13:59, Paul TBBle Hampson wrote:
> On Fri, Jul 27, 2007 at 10:18:52AM +0100, David Woodhouse wrote:
> > I still get constant complaints of 'eth1: duplicate address detected'
> > due to the fact that it sees its own outgoing packets, and IPv6 doesn't
> > work.
> 
> Last time I looked at this, I believed it was a mac80211 issue since it
> affected both the bcm43xx-mac80211 and dadwifi drivers, which otherwise
> functioned fine, but didn't affect (the non-mac80211) bcm43xx driver.
> 

This is almost certainly a mac80211 issue.
The TX and RX paths are completely seperate in bcm43xx-mac80211.
