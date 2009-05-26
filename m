Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48093 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbZEZQjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 12:39:10 -0400
Subject: Re: [RFT 3/4] cfg80211: add rfkill support
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1243171957.24236.13.camel@localhost.localdomain>
References: <20090521215940.344214804@sipsolutions.net>
	 <20090521220105.198751775@sipsolutions.net>
	 <1243171957.24236.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 26 May 2009 18:38:53 +0200
Message-Id: <1243355933.20399.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > plain text document attachment (015-cfg80211-rfkill.patch)
> > To be easier on drivers and users, have cfg80211 register an
> > rfkill structure that drivers can access. When soft-killed,
> > simply take down all interfaces; when hard-killed the driver
> > needs to notify us and we will take down the interfaces
> > after the fact. While rfkilled, interfaces cannot be set UP.
> 
> Any chance we could get something other than EINVAL returned from the
> PRE_UP notifier when the device is rfkilled?  It's useful to get some
> indication of *why* the device can't be brought up.  For example, if the
> device requires firmware but that firmware isn't present, the driver
> will usually return ENOENT because that's what request_firmware()
> returns when it can't find what it needs.  Thus userspace can do
> something intelligent with the error.
> 
> So maybe EL2HLT could be (ab)used here?  I guess technically it's an L1
> halt since the PHY is powered down, but whatever.  The only other stuff
> that seems to use this are the USB 'gadget' drivers.  Either that, or
> lets make an EL1OFF or ERFKILL maybe.

I think that creating ERFKILL is a really good idea. We should do that.

Regards

Marcel


