Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:55082 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3CXWks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 18:40:48 -0400
Received: by mail-ia0-f182.google.com with SMTP id u8so4986993iag.41
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 15:40:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com>
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
 <CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com>
 <CAMgrJ3b_W0it4p9pY0rayuZu5yupMJPrGc2T6DTrKO-G27y4Vg@mail.gmail.com>
 <CAJ-Vmok-iP+=6EK+mG+jqnEPY2gPLhypjcGKxceEvy=EG59Ngw@mail.gmail.com>
 <CAMgrJ3aDhKgPjWx_znDCJVeibTChHAORnFS4Cv6fF56SvV=sNA@mail.gmail.com> <CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Sun, 24 Mar 2013 18:40:27 -0400
Message-ID: <CAMgrJ3buZxZermRmpUW2r3gYtUmF=3UoEo7NW9VYTkAwS7gdtQ@mail.gmail.com> (sfid-20130324_234056_951750_ED8E253B)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hm, so it's doing some fast channel changes?

Yes, the fastcc does seem to work, it's just that sometimes the chip
can get in a bad state when it's not cold reset.

> Just disable fast channel change entirely and re-test? And why not
> just force a cold reset always? Why bother checking for the queue to
> be stopped?

Just disabling fastcc was not enough, the cold resets are what seemed
to have made the difference.  I was actually thinking about
re-enabling fastcc and testing again.

The TXE/RXE checking path is from felix's "ath9k_hw: improve reset
reliability after errors" patch.  I've just got the exception in there
for 9160, since I don't have other hardware to test with.  What do the
hardware engineers say about warm vs. cold reset?  I did notice that
your latest ar9300 HAL has a note stating that "Warm reset is
optimistic."
