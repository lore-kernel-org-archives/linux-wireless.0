Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:61180 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BHSsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 13:48:24 -0500
Received: by mail-ia0-f170.google.com with SMTP id k20so4657282iak.29
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 10:48:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com>
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
 <CAMgrJ3bLJyVYa47zxGgNOcks0bK70oo1w1JLObW4DT_vpyU_SA@mail.gmail.com> <CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Fri, 8 Feb 2013 13:48:03 -0500
Message-ID: <CAMgrJ3b_W0it4p9pY0rayuZu5yupMJPrGc2T6DTrKO-G27y4Vg@mail.gmail.com> (sfid-20130208_195008_206593_D108785E)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maybe I have the terminology wrong, but I thought a cold reset meant
toggling the PCI reset line.

On Thu, Feb 7, 2013 at 4:40 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 7 February 2013 11:43, Robert Shade <robert.shade@gmail.com> wrote:
>> AR9160 / AR9106
>
> Things are getting into a really odd state if that particular initial
> calibration isn't finishing...
>
> Things I can think of:
>
> * There's some kind of noise going on that's angering the PHY (eg a spur);
> * We should be doing a cold reset instead of a warm reset, upon a
> channel change; (That fixes some issues I've seen on the AR9280 in
> some environments);
> * Bad/incorrectly hooked up antenans.
>
> From a software side, nothing much can be going wrong. as long as the
> driver isn't doing something stupid like running multiple copies of
> the reset / setup path on different CPUs/threads, it should be
> reliable.
>
> HTH,
>
>
>
> Adrian
