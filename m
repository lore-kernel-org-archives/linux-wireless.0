Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52891 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZLKPE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 10:04:59 -0500
Date: Fri, 11 Dec 2009 16:05:00 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091211160500.1dae2406@strolchi.home.s3e.de>
In-Reply-To: <1260543323.2442.287.camel@johannes.local>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	<20091211133603.46bec686@strolchi.home.s3e.de>
	<20091211144221.GA6663@tuxdriver.com>
	<1260543323.2442.287.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 11 Dec 2009 15:55:23 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Fri, 2009-12-11 at 09:42 -0500, John W. Linville wrote:
> 
> > It strikes me as strange that you are hitting two drivers to support
> > one device.  Are you saying that your ar9170usb has the goofy storage
> > device thing using the same USB IDs that the zd1211rw devices like that
> > used?  I suppose that makes some sense given the shared heritage...
> 
> Good catch -- even if ar9170 descended from zd1211 it doesn't seem
> appropriate to require two drivers for a single device.

Unfortunately, the device ID of the (unswitched) device is already
listed in zd1211, so the easy way was to add the eject there. The
zd1211rw will be loaded anyway, it will just barf that it cannot find
the correct endpoint:

usb 1-1: zd1211rw: Could not find bulk out endpoint

For the long run, a better solution would be nice, yes.

Thanks,

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
