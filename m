Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:44659 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab1A0Xtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 18:49:43 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	"Ohad Ben-Cohen" <ohad@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
References: <Pine.LNX.4.44L0.1101271439020.2090-100000@iolanthe.rowland.org>
	<87tyguje7j.fsf@ti.com> <201101280021.14344.rjw@sisk.pl>
Date: Thu, 27 Jan 2011 15:49:37 -0800
In-Reply-To: <201101280021.14344.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 28 Jan 2011 00:21:14 +0100")
Message-ID: <87lj25kium.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[...]

>> 
>> So, to summarize, as long as folks are OK with drivers directly calling
>> the subsystem runtime PM callbacks, I'll go this route.
>
> This is perfectly fine as long as you ensure that they won't be called
> concurrently through the runtime PM framework.

Yes, as long as they're only used in the suspend/resume (or _noirq
versions) this is guaranteed since the DPM core is already preventing
runtime PM transitions during suspend/resume.

Kevin
