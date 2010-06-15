Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39274 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752892Ab0FONtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 09:49:02 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
Date: Tue, 15 Jun 2010 15:49:41 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de> <20100615132619.GB12885@tuxdriver.com> <1276609006.3648.233.camel@jlt3.sipsolutions.net>
In-Reply-To: <1276609006.3648.233.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006151549.41963.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
> > On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> > > Hi,
> > >
> > > the at76c50x-usb driver fails to authenticate with an AP.
> 
> We need more information on how it fails.

The problem is that the following if-statement is never true:

http://lxr.linux.no/#linux+v2.6.34/drivers/net/wireless/at76c50x-usb.c#L1986

What else information do you need? dmesg output, debugfs trace?

> 
> > > The last working
> > > major kernel version was 2.6.30. I investigated the problem and found
> > > out that the driver needs to send a join command (CMD_JOIN) prior to
> > > the actual authentication process. For the join command, the driver
> > > needs to know the bssid of the AP. The problem is now that the
> > > mac80211 layer does not inform the driver about the bssid prior to
> > > the authentication. So we have a chicken-and-egg dilemma.

-- 
Sebastian
