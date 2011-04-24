Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1DXINE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 04:13:04 -0400
Subject: Re: [PATCH 4/4] iwlwifi: split the drivers for agn and legacy
 devices 3945/4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
In-Reply-To: <1303562444.11751.6.camel@maxim-laptop>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
	 <1303558517.8537.7.camel@maxim-laptop>
	 <1303562444.11751.6.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 10:13:01 +0200
Message-ID: <1303632781.3795.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-23 at 15:40 +0300, Maxim Levitsky wrote:

> > This one came to me as a surprise, I updated the kernel, and whoops, the
> > wireless led, blinks all the time!
> > It turns out that in splitted driver iwl3945 doesn't have any led
> > support, and indeed the light on my notebook doesn't change state often.
> > It ether doesn't light up at all, or just blinks at constant rate.
> OK, found the cause, it is dead simple, and in fact affects all intel
> wireless card.
> I wonder how such bug could escape unnoticed.
> Nobody uses linux these days I guess.... :-(

Wow, so you're one of the people who think the LED blinking is the most
important thing... good job...

Anyhow this was intentional, it's supposed to blink in that mode
according to the product documentation. If you don't like it, you can
now override it in sysfs.

johannes

