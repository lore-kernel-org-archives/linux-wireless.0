Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43968 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3CXVw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 17:52:58 -0400
Received: by mail-wi0-f182.google.com with SMTP id hi18so6009508wib.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 14:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3aDhKgPjWx_znDCJVeibTChHAORnFS4Cv6fF56SvV=sNA@mail.gmail.com>
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
	<CAMgrJ3aDhKgPjWx_znDCJVeibTChHAORnFS4Cv6fF56SvV=sNA@mail.gmail.com>
Date: Sun, 24 Mar 2013 14:52:56 -0700
Message-ID: <CAJ-Vmo=_t0SwB0hiekXcCMgAps1noghp273O-QXGQ-1tABQvkg@mail.gmail.com> (sfid-20130324_225302_880342_E03EE253)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Robert Shade <robert.shade@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2013 11:55, Robert Shade <robert.shade@gmail.com> wrote:
> I've done some more testing on this and it looks like the auth packets
> aren't delayed, they're never sent.  The "TX Complete" messages are
> from the queue being purged before a reset due to channel change.

Ew, ok.

> It only gets in this state when it's unable to change the channel due
> to the timeout on setting the AR_PHY_AGC_CONTROL register.  One thing
> that does look interesting is that, when we fail to change the
> channel, ath_complete_reset is never called and therefore
> ieee80211_wake_queues is never called either.  Are stop/wake queues
> calls supposed to be balanced?

I'll leave that up to Felix.

> Based on your suggestions, I've been testing a few days with the
> following patch and I have yet to see any DMA messages or the auth
> stuck state.  I had to check for SC_OP_INVALID because the initial
> reset in ath9k_start would cause a kernel panic when the system was
> being initialized from a powered off state.  I don't know enough about
> the internals to know if I should expect that, but I'll need to set up
> a serial console in order to capture the panic.

Hm, so it's doing some fast channel changes?

Just disable fast channel change entirely and re-test? And why not
just force a cold reset always? Why bother checking for the queue to
be stopped?





Adrian
