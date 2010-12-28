Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:44520 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0L1Ulu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 15:41:50 -0500
MIME-Version: 1.0
In-Reply-To: <201012282104.06232.rjw@sisk.pl>
References: <AANLkTimj0E3Rz_8WQrU4wGg3ONyXzkUT9+U3Xqz7Cq0X@mail.gmail.com>
 <201012261937.21256.rjw@sisk.pl> <AANLkTinewad6YxXvn5gnJQ+HJn41Sg96319GQn9KRKWj@mail.gmail.com>
 <201012282104.06232.rjw@sisk.pl>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 22:41:29 +0200
Message-ID: <AANLkTikxmS0sw6HeXL5QhdzBzBU3U9+hTvsPcyJay5J6@mail.gmail.com>
Subject: Re: [linux-pm] subtle pm_runtime_put_sync race and sdio functions
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Ido Yariv <ido@wizery.com>,
	linux-pm@lists.linux-foundation.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 28, 2010 at 10:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, December 28, 2010, Ohad Ben-Cohen wrote:
>> On Sun, Dec 26, 2010 at 8:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > So, it only happens during asynchronous suspend?  In other words, if suspend
>> > is synchronous, everything should be fine, right?
>>
>> Not necessarily.
>
> So it's not a race after all, is it?

There are several scenarios to the same problem.. In one of them, we
were racing against an event that caused a suspend handler of an
entirely unrelated device to fail. I'm trying very hard not to
overload this thread with irrelevant details.. but anyway this forked
discussion is a bit moot IMHO

> Second, what you'd really want to do (I guess) is:
>
> pm_runtime_put_noidle(device);
> device->bus->pm->runtime_suspend(device);

Yes, our workaround is somewhere in these lines. We're using it
regardless of the system state (runtime or suspending), and frankly,
we're happy with it, just like I said in:

http://www.spinics.net/linux/lists/linux-mmc/msg05052.html

I still call it a workaround though...
