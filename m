Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab0G2Wc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 18:32:59 -0400
Date: Thu, 29 Jul 2010 14:48:37 -0700
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ben Hutchings <ben@decadent.org.uk>, stable@kernel.org
Subject: Re: [stable] [PATCH 1/4 2.6.33.y] mac80211: explicitly
 disable/enable QoS
Message-ID: <20100729214837.GG17470@kroah.com>
References: <1275904827-6598-1-git-send-email-sgruszka@redhat.com>
 <20100727224008.GM14257@kroah.com>
 <1280272525.13192.67.camel@localhost>
 <20100727235451.GA12332@kroah.com>
 <20100728085007.349b2c22@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100728085007.349b2c22@dhcp-lab-109.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 08:50:07AM +0200, Stanislaw Gruszka wrote:
> On Tue, 27 Jul 2010 16:54:51 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Wed, Jul 28, 2010 at 12:15:25AM +0100, Ben Hutchings wrote:
> > > On Tue, 2010-07-27 at 15:40 -0700, Greg KH wrote:
> > > > On Mon, Jun 07, 2010 at 12:00:24PM +0200, Stanislaw Gruszka wrote:
> > > > > commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d upstream.
> > > > > 
> > > > > Add interface to disable/enable QoS (aka WMM or WME). Currently drivers
> > > > > enable it explicitly when ->conf_tx method is called, and newer disable.
> > > > > Disabling is needed for some APs, which do not support QoS, such
> > > > > we should send QoS frames to them.
> > > > 
> > > > Why is this a patch for a -stable tree?  It looks like it adds a new api
> > > > for a new feature, right?
> > > [...]
> > > 
> > > It extends the interface between the 802.11 stack and drivers so that
> > > drivers can avoid sending QoS frames to APs that don't support them.
> > > There is no new interface to userland.  My understanding is that iwlwifi
> > > becomes unable to communicate with non-QoS-capable APs after having once
> > > associated with a QoS-capable AP, without this and the following change
> > > in iwlwifi itself.
> > 
> > Is this really true?  And is it a bug that people are hitting?
> 
> Yes, without that patch iwlwifi devices are not able to connect with some
> old APs. I had only two Fedora bug reports about that, so do not think
> this is something critical. Fill free to drop that patch (together with 
> "iwlwifi: manage QoS by mac stack" which is part of the fix and do not have
> sense alone), or apply only to 2.6.34.

Ok, I'm going to drop both of these.

thanks,

greg k-h
