Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:42862 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3BGVkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 16:40:15 -0500
Received: by mail-we0-f169.google.com with SMTP id t11so2536859wey.14
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 13:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3bLJyVYa47zxGgNOcks0bK70oo1w1JLObW4DT_vpyU_SA@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAMgrJ3YQ5oua0MJvmVcbb-GuQ8Rr5vwAO3Jy1vs0w-VRRDdcMg@mail.gmail.com>
	<CAJ-VmomnvMqc_0sKvmL-_OQY4cm5xKjqfeWXs_jfUsvFtK9YcQ@mail.gmail.com>
	<CAMgrJ3bvJ-XwBGVcWuUGGyqAoJbjRFZz=om5dsG6MecRAYRO7g@mail.gmail.com>
	<CAJ-VmonzUE9uFN=tDfMXVF-b1Vk3c_+ZTWiGZKPgw8Vnwwadgw@mail.gmail.com>
	<CAMgrJ3ZHRMxzzxf0pj5zc+1TeWkfT2RPwL82JSkTU=AsYnXwfg@mail.gmail.com>
	<CAJ-VmomRvj2hf0i6AMJzCiR42thmTUQ=QCe7FX0k3tw1DTbkoQ@mail.gmail.com>
	<CAMgrJ3YCryn2VvtZJbJSVFUT61TQYPXw+cOXnJQN8Jab-rSuKA@mail.gmail.com>
	<CAMgrJ3b-_a5aBDjAMPChnxEWobnYOhXX3y_FwfNwF75u4hHD6A@mail.gmail.com>
	<CAJ-VmombhTgTaFuQXWR1Q4M8Awg4CwFseDu+iN_U6GfBDUaCig@mail.gmail.com>
	<CAMgrJ3bLJyVYa47zxGgNOcks0bK70oo1w1JLObW4DT_vpyU_SA@mail.gmail.com>
Date: Thu, 7 Feb 2013 13:40:13 -0800
Message-ID: <CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com> (sfid-20130207_224020_786154_77103F12)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 February 2013 11:43, Robert Shade <robert.shade@gmail.com> wrote:
> AR9160 / AR9106

Things are getting into a really odd state if that particular initial
calibration isn't finishing...

Things I can think of:

* There's some kind of noise going on that's angering the PHY (eg a spur);
* We should be doing a cold reset instead of a warm reset, upon a
channel change; (That fixes some issues I've seen on the AR9280 in
some environments);
* Bad/incorrectly hooked up antenans.

>From a software side, nothing much can be going wrong. as long as the
driver isn't doing something stupid like running multiple copies of
the reset / setup path on different CPUs/threads, it should be
reliable.

HTH,



Adrian
