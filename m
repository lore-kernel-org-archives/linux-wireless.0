Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36485 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0LWHvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 02:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <201012191122.09581.rjw@sisk.pl>
References: <AANLkTikJr+0kVPE4aSwPjZWRfA3gRSNgGwzQdSwRpo_5@mail.gmail.com>
 <AANLkTin23vbbA7+UDzh=v060HbkLMrJjB38cs+AWScPJ@mail.gmail.com>
 <201012182347.08635.rjw@sisk.pl> <201012191122.09581.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 23 Dec 2010 09:51:22 +0200
Message-ID: <AANLkTi=9kjmb3evOON3WMoGjqadDHqqBKVH4viT02Qf9@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 19, 2010 at 12:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> That said, I think we may do something different that perhaps will make your
> life somewhat easier.
...
> So, I think we can add a "runtime only" flag working as described above.

That will definitely solve the suspend/resume issue we're having.

But due to /sys/devices/.../power/control, we will still have to
bypass runtime PM for this particular device.

We need a way to unconditionally power down the device, and as long as
runtime PM can be disabled by the user, we can't use it.

Thanks,
Ohad.
