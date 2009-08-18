Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12168 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZHRS1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:27:52 -0400
Received: by ey-out-2122.google.com with SMTP id 22so815325eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:27:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
Date: Tue, 18 Aug 2009 20:27:51 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908181954.23419.IvDoorn@gmail.com> <200908182004.58584.IvDoorn@gmail.com> <1250618853.7887.0.camel@johannes.local>
In-Reply-To: <1250618853.7887.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908182027.51461.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 August 2009, Johannes Berg wrote:
> On Tue, 2009-08-18 at 20:04 +0200, Ivo van Doorn wrote:
> 
> > > Speaking of which -- bss_info_changed can sleep too, which means you can
> > > remove DRIVER_REQUIRE_SCHEDULED completely I think?
> > 
> > Seriously, that would be great. Patch coming up in a few minutes. ;)
> 
> Cool.
> 
> Hey, sorry it took so long to make it possible :)
>
> I wonder if drivers now ever have a reason to queue work on the mac80211
> workqueue? Some periodic calibration tasks maybe?

Well after the removal of DRIVER_REQUIRE_SCHEDULED I only have 1
workqueue structure left: Updating beacons.

During the update it needs to iterate through all interfaces using
ieee80211_iterate_active_interfaces_atomic(), during the actual update
a mutex is required because USB device access is required. And not in the least
the function is called by the set_tim() callback function.

Ivo


