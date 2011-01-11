Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45114 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1AKIcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:32:21 -0500
Subject: Re: [PATCH] wl12xx: reset 5ghz num channels on hw init
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294734327.3611.1.camel@jlt3.sipsolutions.net>
References: <1294693444-30807-1-git-send-email-arik@wizery.com>
	 <1294734327.3611.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 10:32:18 +0200
Message-ID: <1294734738.12992.45.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, 2011-01-11 at 09:25 +0100, Johannes Berg wrote:
> On Mon, 2011-01-10 at 23:04 +0200, Arik Nemtsov wrote:
> > The number of 5ghz channels is set to 0 when 11a is not supported in the
> > NVS file. When a single rmmod/insmod of wl12xx_sdio this leads to a
> > supported band (5ghz) with 0 supported channels, which mac80211
> > considers illegal.
> 
> The setting to 0 shouldn't be happening in a global structure anyway
> since that way you can't support two different devices in the same
> system!!

This is that hack we discussed some time ago on how to disable the 11a
channels.  We only know that they're not supported after the driver is
loaded and the supported channels are already registered.  We get the
info that the 11a are not supported in the calibration data that we
receive later.

See commit fb6a6819fad0d71b47577a51709440a9f8441f0a.

Earlier I was disabling the channels by setting the DISABLED flag, but
that was bad, because I was touching regulatory stuff and it was causing
other problems.

-- 
Cheers,
Luca.

