Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0G0XzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 19:55:04 -0400
Date: Tue, 27 Jul 2010 16:54:51 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH 1/4 2.6.33.y] mac80211: explicitly
 disable/enable QoS
Message-ID: <20100727235451.GA12332@kroah.com>
References: <1275904827-6598-1-git-send-email-sgruszka@redhat.com>
 <20100727224008.GM14257@kroah.com>
 <1280272525.13192.67.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280272525.13192.67.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 12:15:25AM +0100, Ben Hutchings wrote:
> On Tue, 2010-07-27 at 15:40 -0700, Greg KH wrote:
> > On Mon, Jun 07, 2010 at 12:00:24PM +0200, Stanislaw Gruszka wrote:
> > > commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d upstream.
> > > 
> > > Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
> > > enable it explicitly when ->conf_tx method is called, and newer disable.
> > > Disabling is needed for some APs, which do not support QoS, such
> > > we should send QoS frames to them.
> > 
> > Why is this a patch for a -stable tree?  It looks like it adds a new api
> > for a new feature, right?
> [...]
> 
> It extends the interface between the 802.11 stack and drivers so that
> drivers can avoid sending QoS frames to APs that don't support them.
> There is no new interface to userland.  My understanding is that iwlwifi
> becomes unable to communicate with non-QoS-capable APs after having once
> associated with a QoS-capable AP, without this and the following change
> in iwlwifi itself.

Is this really true?  And is it a bug that people are hitting?

thanks,

greg k-h
